//
//  ConversationDetailVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 6/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import IDMPhotoBrowser
import CoreServices

class ConversationDetailVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, CLLocationManagerDelegate, IDMPhotoBrowserDelegate {
    
    //MARK:- Properties:
    
    // UI Properties:
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var chatInput: ResizingTextView!
    @IBOutlet weak var placeHolderText: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var tableviewBottom: NSLayoutConstraint!
    //    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var transparentLayer: UIView!
    
    var containerView: UIView?, imagePicker: UIDocumentPickerViewController?
    var uploadHUD: MBProgressHUD?, gpsHUD: MBProgressHUD?
    var keyboardVisible = false, locationManager: CLLocationManager?
    var hardwareKeyboardPresent = false
    
    // Data Properties:
    var day: String = "", contact: MLContact?, jabberId: String?
    var destinationDateFormat: DateFormatter?, gregorian: Calendar?
    var thisYear = 0, thisMonth = 0, thisDay = 0
    var wasaway = false, wasoffline = false, activeChats: [AnyHashable]?
    var oldFrame = CGRect.zero, firstmsg = false
    var messageList: [MLMessage] = [], photos: [AnyHashable]?
    var encryptChat: Bool?
    var sendLocation = false, xmppAccount: xmpp?
    var lastMamDate: Date?       //  used for first request
    var data = Data()
    
    
    func setup() {
        
        print("Entering: ConversationDetailVC: setup()")
        hidesBottomBarWhenPushed = true
        
        DataLayer.sharedInstance().details(forAccount: contact?.accountId, withCompletion: { result in
            let accountVals = result
            if accountVals!.count > 0 {
                if let object = (accountVals?[0] as? [AnyHashable : Any])?["username"], let object1 = (accountVals?[0] as? [AnyHashable : Any])?["domain"] {
                    self.jabberId = "\(object)@\(object1)"
                }
            }
        })
    }
    
    func setupWithContact(_ contact: MLContact?) {
        print("Entering: ConversationDetailVC: setupWithContact()")
        
        self.contact = contact
        setup()
    }
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        
        print("Entering: ConversationDetailVC: viewDidLoad()")
        super.viewDidLoad()
        
        setupDateObjects()
        setupUIComonents()
        setupBackendComponents()
        imagePicker?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Entering: ConversationDetailVC: viewWillAppear()")
        
        super.viewWillAppear(animated)
        MLNotificationManager.sharedInstance()?.currentAccountNo = contact?.accountId
        MLNotificationManager.sharedInstance()?.currentContact = contact
        
        if day.isEmpty == false {
            DataLayer.sharedInstance()?.fullName(forContact: contact?.contactJid, inAccount: contact?.accountId, withCompeltion: { name in
                DispatchQueue.main.async {
                    var displayTitle = name
                    if displayTitle?.count == 0 { displayTitle = self.contact?.contactJid }
                    self.navigationItem.title = "\(String(describing: displayTitle))(\(String(describing: self.day))"
                }
            })
            NotificationCenter.default.removeObserver(self)
            self.inputContainerView.isHidden = true
        } else {
            self.inputContainerView.isHidden = false
        }
        
        //Encryption feature goes below:
        if contact?.contactJid != nil && contact?.accountId != nil {
            encryptChat = DataLayer.sharedInstance()?.shouldEncrypt(forJid: contact?.contactJid, andAccountNo: contact?.accountId)
        }
        
        handleForeGround()
        refreshButton(nil)
        placeHolderText.text = ""
        
        
        //Load message draft from database
        //        DataLayer.sharedInstance()?.loadMessageDraft(contact?.contactJid, forAccount: contact?.accountId, withCompletion: { messageDraft in
        //            if let messageDraft = messageDraft {
        //                if messageDraft.count > 0 {
        //                    DispatchQueue.main.async {
        //                        self.chatInput.text = messageDraft
        //                        self.placeHolderText.isHidden = true
        //                    }
        //                }
        //            }
        //
        //        })
        hardwareKeyboardPresent = true
        scrollToBottom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("Entering: ConversationDetailVC: viewDidAppear()")
        super.viewDidAppear(animated)
        if (contact?.contactJid != nil) || (contact?.accountId != nil) { return }
        xmppAccount = MLXMPPManager.sharedInstance()?.getConnectedAccount(forID: contact?.accountId)
        synchChat()
        
        //Encryption features below:
        #if !DISABLE_OMEMO
        if contact?.subscription != kSubBoth {
            xmppAccount?.queryOMEMODevices(from: contact!.contactJid)
        }

        let devices = xmppAccount?.monalSignalStore.knownDevices(forAddressName: contact?.contactJid)
        if devices?.count == 0 {
            if encryptChat! {
                encryptChat = false
                DataLayer.sharedInstance().disableEncrypt(forJid: contact?.contactJid, andAccountNo: contact?.accountId)
            }
        }

        #endif
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.refreshCounter()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("Entering: ConversationDetailVC: viewWillDisappear()")
        
        
        // save message draft
        DataLayer.sharedInstance()?.saveMessageDraft(contact?.contactJid, forAccount: contact?.accountId, withComment: chatInput.text, withCompletion: { success in
            if success {
                // Update status message for contact to show current draft
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMonalContactRefresh), object: self, userInfo: ["contact": self.contact!])
            }
        })
        super.viewWillDisappear(animated)
        MLNotificationManager.sharedInstance()?.currentAccountNo = nil
        MLNotificationManager.sharedInstance()?.currentContact = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        
        print("Entering: ConversationDetailVC: viewDidLayoutSubviews()")
        super.viewDidLayoutSubviews()
        if messageTable.contentSize.height > messageTable.bounds.size.height {
            messageTable.setContentOffset(CGPoint(x: 0,
                                                  y: messageTable.contentSize.height - messageTable.bounds.size.height),
                                          animated: false)
        }
    }
    
    
    // MARK:- Rotation:
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Entering: ConversationDetailVC: viewWillTransition()")
        chatInput.resignFirstResponder()
    }
    
    func setupUIComonents(){
        containerView = view
        messageTable.scrollsToTop = true
        chatInput.scrollsToTop = false
        
        hidesBottomBarWhenPushed = true
        
        chatInput.layer.borderColor = UIColor.lightGray.cgColor
        chatInput.layer.cornerRadius = 3.0
        chatInput.layer.borderWidth = 0.5
        chatInput.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        messageTable.rowHeight = UITableView.automaticDimension
        messageTable.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setupBackendComponents(){
        
        print("Entering: ConversationDetailVC: setupBackendComponents()")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleNewMessage(_:)),
                                       name: NSNotification.Name(rawValue: kMonalNewMessageNotice), object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleSendFailedMessage),
                                       name: NSNotification.Name(rawValue: kMonalSendFailedMessageNotice), object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleSentMessage(_:)),
                                       name: NSNotification.Name(rawValue: kMonalSentMessageNotice), object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleMessageError(_:)),
                                       name: NSNotification.Name(rawValue: kMonalMessageErrorNotice), object: nil)
        notificationCenter.addObserver(self, selector: #selector(dismissKeyboard(_:)),
                                       name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleForeGround),
                                       name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)),
                                       name: UIResponder.keyboardDidShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)),
                                       name: UIResponder.keyboardDidHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self, selector: #selector(refreshMessage(_:)),
                                       name: NSNotification.Name(rawValue: kMonalMessageReceivedNotice), object: nil)
        notificationCenter.addObserver(self, selector: #selector(refreshButton(_:)),
                                       name: NSNotification.Name(rawValue: kMonalAccountStatusChanged), object: nil)
        
    }
    
    @objc func handleForeGround() {
        
        print("Entering: ConversationDetailVC: handleForeGround()")
        refreshData()
        reloadTable()
    }
    
    // gets recent messages  to fill an empty chat
    func synchChat() {
        
        print("Entering: ConversationDetailVC: syncChat()")
        DispatchQueue.main.async {
            if (self.xmppAccount?.connectionProperties.supportsMam2)! && self.contact!.isGroup == false{
                if self.messageList.count == 0 {
                    self.xmppAccount?.setMAMQueryMostRecentForJid(self.contact?.contactJid)
                }
            }
        }
    }
    
    @objc func refreshButton(_ notification: Notification?){
        if contact?.accountId == nil {
            return
        }
        //let xmppAcnt = MLXMPPManager.sharedInstance().getConnectedAccount(forID: contact?.accountId)
        DispatchQueue.main.async {
            let title = self.contact?.contactJid

                self.sendButton.isEnabled = true
                self.navigationItem.title = title
            

            if self.encryptChat == true {
                self.navigationItem.title = "\(self.navigationItem.title ?? "") 🔒"
            }
        }
    }
    
    
    //MARK:- Selector Methods:
    //MARK:- Observers Selector Methods:
    
    //MARK:- Handling Notifications:
    
    func reloadTable(){
        
        print("Entering: ConversationDetailVC: reloadTable()")
        if messageTable.hasUncommittedUpdates { return }
        messageTable.reloadData()
    }
    
    // Always messages going out:
    
    func addMessageTo(_ to: String?, withMessage message: String?,
                      andId messageId: String?,
                      withCompletion completion: @escaping(_ success: Bool) -> Void) {
        
        print("Entering: ConversationDetailVC: addMessageTo()")
        
        if jabberId == nil || messageId == nil {
            print("Entering: ConversationDetailVC: addMessageTo(): jabberId == nil || messageId == nil")
            return
        }
        
        DataLayer.sharedInstance()?.addMessageHistory(from: self.jabberId, to: to, forAccount: contact?.accountId,
                                                      withMessage: message, actuallyFrom: self.jabberId, withId: messageId,
                                                      encrypted: self.encryptChat!, withCompletion: { result, messageType in
                                                        
                                                        print("added message")
                                                        if result {
                                                            print("Entering: ConversationDetailVC: addMessageTo(): if result ")
                                                            DispatchQueue.main.async {
                                                                let messageObject = MLMessage()
                                                                messageObject.actualFrom = self.jabberId!
                                                                messageObject.from = self.jabberId!
                                                                messageObject.timestamp = Date()
                                                                messageObject.hasBeenSent = true
                                                                messageObject.messageId = messageId!
                                                                messageObject.encrypted = self.encryptChat!
                                                                messageObject.messageType = messageType!
                                                                messageObject.messageText = message!
                                                                
                                                                self.messageTable.performBatchUpdates({
                                                                    if self.messageList.isEmpty { self.messageList = [MLMessage]() }
                                                                    self.messageList.append(messageObject)
                                                                    let bottom = self.messageList.count - 1
                                                                    if bottom >= 0 {
                                                                        print("Entering: ConversationDetailVC: addMessageTo(): performBatchUpdates: if bottom >= 0")
                                                                        let path1 = IndexPath(row: bottom, section: 0)
                                                                        self.messageTable.insertRows(at: [path1], with: .fade)
                                                                    }
                                                                }) { finished in
                                                                    //                        if completion != nil {
                                                                    print("Entering: ConversationDetailVC: addMessageTo(): finished in { block")
                                                                    completion(result)
                                                                    //                        }
                                                                    self.scrollToBottom()
                                                                }
                                                            }
                                                        } else {
                                                            print("failed to add message")
                                                        }
        })
        if firstmsg == true {
            print("Entering: ConversationDetailVC: addMessageTo(): if firstmsg == true ")
            DataLayer.sharedInstance()?.addActiveBuddies(to, forAccount: self.contact?.accountId, withCompletion: nil)
            firstmsg = false
        }
    }
    
    @objc func handleNewMessage(_ notification: Notification?){
        
        print("Entering: ConversationDetailVC: handleNewMessage()")
        print("Chat view got new messsage notice \(String(describing: notification?.userInfo))")
        
        let message = notification?.userInfo?["message"] as? MLMessage
        if message == nil {
            print("Notification without message")
        }
        if ((message?.accountId == contact?.accountId)
            && ((message?.from == contact?.contactJid
                || message?.to == contact?.contactJid))) {
            
            DataLayer.sharedInstance()?.messageType(forMessage: message?.messageText, withKeepThread: true, andCompletion: { messageType in
                DispatchQueue.main.async {
                    var finalMessageType = messageType
                    if (message?.messageType.isEqual(kMessageTypeStatus))! {
                        finalMessageType = kMessageTypeStatus
                    }
                    message?.messageType = finalMessageType ?? ""
                    if self.messageList.isEmpty {
                        self.messageList = [MLMessage]()
                    }
                    self.messageList.append(message!)
                    
                    self.messageTable.beginUpdates()
                    var path1: IndexPath
                    let bottom = self.messageList.count - 1
                    if bottom >= 0 {
                        path1 = IndexPath(row: bottom, section: 0)
                        self.messageTable.insertRows(at: [path1], with: .bottom)
                    }
                    
                    self.messageTable.endUpdates()
                    self.scrollToBottom()
                }
            })
        }
        
    }
    
    @objc func handleSendFailedMessage(_ notification: Notification?) {
        
        print("Entering: ConversationDetailVC: handleSendFailedMessage()")
        
        let dictionary = (notification?.userInfo)! as! [String: Any]
        setMessageId(dictionary[kMessageId] as? String, delivered: false)
    }
    
    @objc func handleSentMessage(_ notification: Notification?) {
        
        print("Entering: ConversationDetailVC: handleSentMessage()")
//        let dictionary = notification?.userInfo! as! [String: String]
        
        let dictionary = (notification?.userInfo)! as! [String: Any]
        setMessageId(dictionary[kMessageId] as? String, delivered: true)
    }
    
    @objc func handleMessageError(_ notification: Notification?) {
        
        print("Entering: ConversationDetailVC: handleMessageError()")
        let dictionary = notification?.userInfo
        
        let messageId = dictionary?[kMessageId] as? String
        DispatchQueue.main.async(
            execute: {
                if UIApplication.shared.applicationState == .background {
                    return
                }
                
                var row = 0
                var indexPath: IndexPath?
                for message in self.messageList {
                    if (message.messageId == messageId) && !message.hasBeenReceived {
                        message.errorType = dictionary?["errorType"] as! String
                        message.errorReason = dictionary?["errorReason"] as! String
                        message.hasBeenSent = false
                        indexPath = IndexPath(row: row, section: 0)
                        break
                    }
                    row += 1
                }
                if indexPath != nil {
                    self.messageTable.beginUpdates()
                    self.messageTable.reloadRows(at: [indexPath].compactMap { $0 }, with: .none)
                    self.messageTable.endUpdates()
                }
        })
    }
    
    
    @objc func refreshMessage(_ notification: Notification?){
        
        print("Entering: ConversationDetailVC: refreshMessage()")
        let dictionary = notification?.userInfo! as! [String: String]
        setMessageId(dictionary[kMessageId], received: true)
    }
    
    
    func setMessageId(_ messageId: String?, delivered: Bool) {
        
        print("Entering: ConversationDetailVC: setMessageId[delivered]()")
        DispatchQueue.main.async(
            execute: {
                if UIApplication.shared.applicationState == .background {
                    return
                }
                
                var row = 0
                var indexPath: IndexPath?
                for message in self.messageList {
                    if message.messageId == messageId {
                        message.hasBeenSent = delivered
                        indexPath = IndexPath(row: row, section: 0)
                        break
                    }
                    row += 1
                }
                if indexPath != nil {
                    self.messageTable.beginUpdates()
                    self.messageTable.reloadRows(at: [indexPath].compactMap { $0 }, with: .none)
                    self.messageTable.endUpdates()
                }
        })
    }
    
    func setMessageId(_ messageId: String?, received: Bool) {
        
        print("Entering: ConversationDetailVC: setMessageId[received]()")
        DispatchQueue.main.async(
            execute: {
                if UIApplication.shared.applicationState == .background {
                    return
                }
                
                var row = 0
                var indexPath: IndexPath?
                for message in self.messageList {
                    if message.messageId == messageId {
                        message.hasBeenReceived = received
                        indexPath = IndexPath(row: row, section: 0)
                        break
                    }
                    row += 1
                }
                
                if indexPath != nil {
                    self.messageTable.beginUpdates()
                    self.messageTable.reloadRows(at: [indexPath].compactMap { $0 }, with: .none)
                    self.messageTable.endUpdates()
                }
        })
    }
    
    //MARK:- Gestures:
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        print("Entering: ConversationDetailVC: dismissKeyboard()")
        // Save message draft
        DataLayer.sharedInstance().saveMessageDraft(contact?.contactJid, forAccount: contact?.accountId, withComment: chatInput.text, withCompletion: nil)
        chatInput.resignFirstResponder()
    }
    
    // MARK:- Message Signals:
    
    func refreshCounter(){
        
        print("Entering: ConversationDetailVC: refreshCounter()")
        if self.navigationController?.topViewController == self {
            if MLNotificationManager.sharedInstance()?.currentContact != contact { return }
            if day.isEmpty {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.updateUnread()
                
                            NotificationCenter.default.post(name: NSNotification.Name("kMonalContactRefresh"),
                                                            object: self, userInfo: [
                                                                "contact": contact!
                            ])
            }
        }
    }
    
    func refreshData(){
        
        print("Entering: ConversationDetailVC: refreshData()")
        if contact?.contactJid == nil{
            return
        }
        var newList: NSMutableArray = []
        if day.isEmpty {
            DataLayer.sharedInstance()?.messages(forContact: contact?.contactJid, forAccount: contact?.accountId, withCompletion: { newList in
                DataLayer.sharedInstance()?.countUserUnreadMessages(self.contact?.contactJid, forAccount: self.contact?.accountId, withCompletion: { unread in
                    if unread?.intValue == 0 {
                        self.firstmsg = true
                    }
                })
                
                if self.jabberId == nil { return }
                let unreadStatus: MLMessage = MLMessage()
                unreadStatus.messageType = kMessageTypeStatus
                unreadStatus.messageText = "Unread Messages Below"
                unreadStatus.actualFrom = self.jabberId!
                
                var unreadPosition = newList!.count - 1
                while unreadPosition >= 0 {
                    let row = newList?[unreadPosition] as? MLMessage
                    if row?.unread == nil {
                        unreadPosition += 1
                        break
                    }
                    unreadPosition -= 1
                }
                
                if unreadPosition < newList!.count - 1 && unreadPosition > 0 {
                    newList?.insert(unreadStatus, at: unreadPosition)
                }
                
                if newList?.count != self.messageList.count {
                    self.messageList = newList as! [MLMessage]
                }
            })
        } else {
            newList = DataLayer.sharedInstance()?.messageHistoryDate(contact?.contactJid,
                                                                     forAccount: contact?.accountId,
                                                                     forDate: day) as! NSMutableArray
        }
    }
    
    // MARK:- TextView Methods:
    
    func sendMessage(_ messageText: String?) {
        
        print("Entering: ConversationDetailVC: sendMessage()")
        sendMessage(messageText, andMessageID: nil)
    }
    
    func sendWithShareSheet() {
        
        print("Entering: ConversationDetailVC: sendWithShareSheet()")
        // MLXMPPActivityItem *item = [[MLXMPPActivityItem alloc] initWithPlaceholderItem:@""];
        
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path)
        let documentsDirectory = paths[0] // Get documents directory
        let path = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("message.xmpp").absoluteString
        
        let url = URL(fileURLWithPath: path)
        let items = [url]
        let share = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // share.excludedActivityTypes = exclude;
        present(share, animated: true)
    }
    
    func sendMessage(_ messageText: String?, andMessageID messageID: String?) {
        
        print("Sending message")
        
        print("Entering: ConversationDetailVC: sendMessageAndMessageID()")
        let newMessageID = messageID ?? UUID().uuidString
        //dont read it, use the exisitng
        
        DataLayer.sharedInstance().details(forAccount: contact?.accountId, withCompletion: { result in
            
            let accounts = result
            if accounts?.count == 0 {
                print("Entering: ConversationDetailVC: sendMessageAndMessageID(): if accounts.count == 0")
                print("Account should be > 0")
                return
            }
            //let settings = accounts?[0] as? [AnyHashable : Any]
            
            if messageID == nil {
                print("Entering: ConversationDetailVC: sendMessageAndMessageID(): if messageID == nil")
                let contactNameCopy = self.contact?.contactJid // prevent retail cycle
                let accountNoCopy = self.contact?.accountId
                //                let isMucCopy = self.contact?.isGroup
                               let encryptChatCopy = self.encryptChat
                let contactCopy = self.contact
                
                self.addMessageTo(self.contact?.contactJid, withMessage: messageText, andId: newMessageID, withCompletion: { success in
                    
                    MLXMPPManager.sharedInstance().sendMessage(
                        messageText,
                        toContact: contactNameCopy,
                        fromAccount: accountNoCopy,
                        isEncrypted: encryptChatCopy!,
                        isMUC: false,
                        isUpload: false,
                        messageId: newMessageID,
                        withCompletionHandler: nil)
                    if let contactCopy = contactCopy {
                        print("Entering: ConversationDetailVC: sendMessageAndMessageID(): if let contactCopy = contactCopy")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMonalContactRefresh), object: nil, userInfo: [
                            "contact": contactCopy
                        ])
                    }
                })
            } else {
                print("Entering: ConversationDetailVC: sendMessageAndMessageID(): messageID != nil else block")
                MLXMPPManager.sharedInstance().sendMessage(
                    messageText,
                    toContact: self.contact?.contactJid,
                    fromAccount: self.contact?.accountId,
                    isEncrypted: self.encryptChat!,
                    isMUC: false,
                    isUpload: false,
                    messageId: newMessageID,
                    withCompletionHandler: nil)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMLMessageSentToContact), object: self, userInfo: [
                "contact": self.contact!
            ])
        })
    }
    
    func resignTextView() {
        
        print("Entering: ConversationDetailVC: resignTextView()")
        let cleanstring = chatInput.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if cleanstring.count > 0 {
            sendMessage(cleanstring)
            chatInput.text = ""
        }
    }
    
    @IBAction func sendMessageText(_ sender: Any) {
        
        print("Entering: ConversationDetailVC: sendMessageTextAction()")
        resignTextView()
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDetails" {
                let nav = segue.destination as? UINavigationController
                let details = nav?.topViewController as? ContactDetailsVC
                details?.contact = contact
                details?.completion = {
                    self.viewWillAppear(true)
                }
            }
        }
    
    //MARK:- Keyboard Selector Methods:
    
    @objc func keyboardDidShow(_ aNotification: Notification?){
        
        print("Entering: ConversationDetailVC: keyboardDidShow()")
        //TODO grab animation info
        let info = aNotification?.userInfo
        let kbSize = (info?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        if (kbSize.height ) > 100 {
            //my inputbar +any other
            hardwareKeyboardPresent = false
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (kbSize.height ) - 10, right: 0.0)
        messageTable.contentInset = contentInsets
        messageTable.scrollIndicatorInsets = contentInsets
        
        scrollToBottom()
    }
    
    @objc func keyboardDidHide(_ aNotification: Notification?){
        
        print("Entering: ConversationDetailVC: keyboardDidHide()")
        // Save message draft
        DataLayer.sharedInstance().saveMessageDraft(contact?.contactJid,
                                                    forAccount: contact?.accountId,
                                                    withComment: chatInput.text, withCompletion: nil)
        let contentInsets: UIEdgeInsets = .zero
        messageTable.contentInset = contentInsets
    }
    
    @objc func keyboardWillShow(_ aNotification: Notification?){
        
    }
    
    func scrollToBottom(){
        
        print("Entering: ConversationDetailVC: scrollToBottom()")
        if messageList.count == 0 {
            return
        }
        DispatchQueue.main.async {
            let bottom = self.messageTable.numberOfRows(inSection: 0)
            if bottom > 0 {
                let path1 = IndexPath(row: bottom - 1, section: 0)
                do {
                    self.messageTable.scrollToRow(at: path1, at: .bottom, animated: false)
                }
            }
        }
    }
    
    //MARK:- Date Time functions:
    
    func setupDateObjects(){
        
        print("Entering: ConversationDetailVC: setupDateObjects()")
        destinationDateFormat = DateFormatter()
        destinationDateFormat?.locale = NSLocale.current
        destinationDateFormat?.doesRelativeDateFormatting = true
        
        gregorian = Calendar(identifier: .gregorian)
        
        let now = Date()
        thisDay = gregorian!.component(.day, from: now)
        thisMonth = gregorian!.component(.month, from: now)
        thisYear = gregorian!.component(.year, from: now)
    }
    
    func formattedDate(withSource sourceDate: Date?, andPriorDate priorDate: Date?) -> String? {
        
        print("Entering: ConversationDetailVC: formattedDate()")
        var dateString: String?
        if sourceDate != nil {
            var messageDay: Int? = nil
            if let sourceDate = sourceDate{
                messageDay = gregorian?.component(.day, from: sourceDate)
            }
            var messageMonth: Int? = nil
            if let sourceDate = sourceDate {
                messageMonth = gregorian?.component(.month, from: sourceDate)
            }
            var messageYear: Int? = nil
            if let sourceDate = sourceDate {
                messageYear = gregorian?.component(.year, from: sourceDate)
            }
            
            var priorDay = 0, priorMonth = 0, priorYear = 0
            if priorDate != nil {
                if let priorDate = priorDate {
                    priorDay = gregorian?.component(.day, from: priorDate) as! Int
                    priorMonth = gregorian?.component(.month, from: priorDate) as! Int
                    priorYear = gregorian?.component(.day, from: priorDate) as! Int
                }
            }
            
            if priorDate != nil && ((priorDay != messageDay) || (priorMonth != messageMonth) || (priorYear != messageYear)) {
                destinationDateFormat?.timeStyle = .none
                destinationDateFormat?.dateStyle = .medium
                dateString = destinationDateFormat?.string(from: sourceDate!)
            }
        }
        
        return dateString
    }
    
    func formattedTimeStamp(withSource sourceDate: Date?) -> String? {
        
        print("Entering: ConversationDetailVC: formattedTimeStamp()")
        var dateString: String?
        if sourceDate != nil {
            destinationDateFormat?.dateStyle = .none
            destinationDateFormat?.timeStyle = .short
            
            if let sourceDate = sourceDate {
                dateString = destinationDateFormat?.string(from: sourceDate)
            }
        }
        
        return dateString
    }
    
    func retry(_ sender: Any?) {
        
        print("Entering: ConversationDetailVC: retry()")
        let historyId = (sender as? UIButton)?.tag ?? 0
        
        let alert = UIAlertController(title: "Retry sending message?", message: "This message failed to send.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            let messageArray = DataLayer.sharedInstance().message(forHistoryID: historyId)
            if messageArray!.count > 0 {
                let dictionary = messageArray?[0] as? [String : String]
                self.sendMessage(dictionary?["message"], andMessageID: dictionary?["messageid"])
                self.setMessageId(dictionary?["messageid"], delivered: true) // for the UI, db will be set in the notification
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true)
        }))
        alert.popoverPresentationController?.sourceView = sender as? UIView
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK:- Photo Browser Delegate:
    
    func numberOfPhotos(in photoBrowser: IDMPhotoBrowser?) -> Int {
        return photos!.count
    }
    
    func photoBrowser(_ photoBrowser: IDMPhotoBrowser?, photoAt index: Int) -> IDMPhoto? {
        if index < photos!.count {
            return photos?[index] as? IDMPhoto
        }
        return nil
    }
    
    // MARK:- Jingle Functionality:
    
    
        @IBAction func attachFile(_ sender: Any){
            chatInput.resignFirstResponder()
            
            let types = [String(kUTTypePDF), String(kUTTypeText), String(kUTTypeRTF), String(kUTTypeSpreadsheet), String(kUTTypePNG)]
            let documentPickerViewController = UIDocumentPickerViewController(documentTypes: types, in: .import)
            documentPickerViewController.delegate = self
            present(documentPickerViewController, animated: true, completion: nil)
            return
    
        }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let coordinator = NSFileCoordinator()
        coordinator.coordinate(readingItemAt: urls.first!, options: .forUploading, error: nil) { (newURL) in
            do{
                data = try Data(contentsOf: newURL)
                upload(data)
            } catch {}
        }
        
        print("didPickDocuments at \(urls)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
           dismiss(animated: true, completion: nil)
       }
    
    func upload(_ data: Data?){
        if uploadHUD == nil {
            uploadHUD = MBProgressHUD.showAdded(to: view, animated: true)
            uploadHUD?.removeFromSuperViewOnHide = true
            uploadHUD?.label.text = "Uploading"
            uploadHUD?.detailsLabel.text = "Uploading file to server"
        }

        let decryptedData = data
        let dataToPass = data
        var encrypted: MLEncryptedPayload?
        let keySize = 32
        if encryptChat! {
            encrypted = AESGcm.encrypt(decryptedData!, keySize: Int32(keySize))
            if encrypted != nil {
                var mutableBody = encrypted?.body
                if let authTag = encrypted?.authTag {
                    mutableBody?.append(authTag)
                }
                //dataToPass = mutableBody.copy
            } else {
                print("Could not encrypt attachment")
            }
        }
        
        MLXMPPManager.sharedInstance()?.call(contact)
        
        MLXMPPManager.sharedInstance().httpUploadJpegData(dataToPass, toContact: contact?.contactJid,
                                                          onAccount: contact?.accountId, withCompletionHandler: { url, error in
                                                            
            DispatchQueue.main.async {
                self.uploadHUD?.isHidden = true
                if url != nil {
                    let newMessageID = UUID().uuidString

                    let contactJidCopy = self.contact?.contactJid              //prevent retail cycle
                    let accountNoCopy = self.contact?.accountId
                    let isMucCopy = self.contact?.isGroup
                    let encryptChatCopy = self.encryptChat

                    var urlToPass = url
                    if encrypted != nil {
                        var urlComponents: NSURLComponents? = nil
                        if let url1 = URL(string: urlToPass ?? "") {
                            urlComponents = NSURLComponents(url: url1, resolvingAgainstBaseURL: false)
                        }
                        if urlComponents != nil {
                            urlComponents?.scheme = "aesgcm"
                            urlComponents?.fragment = "\(String(describing: EncodingTools.hexadecimalString(encrypted?.iv)))\(String(describing: EncodingTools.hexadecimalString(encrypted?.key.subdata(in: 0..<(keySize+1)))))"
                            urlToPass = urlComponents?.string
                        } else {
                            print("Could not parse url for conversion to aesgcm")
                        }
                    }

                    MLImageManager.sharedInstance().saveImageData(decryptedData, forLink: urlToPass)
                    self.addMessageTo(self.contact?.contactJid, withMessage: urlToPass, andId: newMessageID) { (success) in
                        MLXMPPManager.sharedInstance()?.sendMessage(urlToPass, toContact: contactJidCopy, fromAccount: accountNoCopy,
                                                                    isEncrypted: encryptChatCopy!, isMUC: isMucCopy!, isUpload: true, messageId: newMessageID, withCompletionHandler: nil)
                        print("Upload URL: \(String(describing: urlToPass))")
                    }
                }
            }
        })
    }
}


extension ConversationDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        print("Entering: ConversationDetailVC: numberOfSections()")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Entering: ConversationDetailVC: numberOfRowsInSection()")
        var toReturn = 0
        
        switch section {
            
        case 0:
            toReturn = messageList.count
            break
            
        default:
            break
        }
        
        return toReturn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Entering: ConversationDetailVC: cellForRowAt()")
        var cell: BaseCell?
        
        var row: MLMessage?
        if indexPath.row < messageList.count {
            print("Entering: ConversationDetailVC: cellForRowAt(): if indexPath.row < messageList.count")
            row = messageList[indexPath.row]
        } else {
            print("Attempt to access beyond bounds")
        }
        
        let from = row?.from
        if from == contact?.contactJid {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "textInCell") as? ChatCell
            //cell?.name.text = "From: \(String(describing: contact!.contactJid))"
            cell?.name.isHidden = true
            cell?.messageBody.textColor = .white
            cell?.bubbleView.layer.masksToBounds = true
            cell?.bubbleView.layer.cornerRadius = 10

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "textOutCell") as? ChatCell
            cell?.messageBody.textColor = .white
            cell?.messageStatus.isHidden = true
            cell?.bubbleView.layer.masksToBounds = true
            cell?.bubbleView.layer.cornerRadius = 10

        }
        
        cell?.messageBody.text = row?.messageText
        
        if row?.hasBeenSent == false {
            cell?.deliveryFailed = true
        } else {
            cell?.deliveryFailed = false
        }
        
        
        var nextRow: MLMessage? = nil
        if indexPath.row + 1 < self.messageList.count {
            print("Entering: ConversationDetailVC: cellForRowAt(): if indexPath.row + 1 < self.messageList.count")
            print("Indexpath.row in nextRow logic: \(indexPath.row)")
            nextRow = messageList[indexPath.row + 1]
        }
        
        var priorRow: MLMessage? = nil
        print("Indexpath.row before priorRow logic: \(indexPath.row)")
        if indexPath.row > 0 {
            print("Entering: ConversationDetailVC: cellForRowAt(): if indexPath.row > 0")
            priorRow = messageList[indexPath.row - 1]
        }
        
//        if row?.hasBeenReceived == true {
//            //cell?.messageStatus.text = kDelivered
//            if indexPath.row == messageList.count - 1 || nextRow?.actualFrom != jabberId {
//                cell?.messageStatus.isHidden = false
//            } else {
//                cell?.messageStatus.isHidden = true
//            }
//        }
        
        cell?.messageHistoryId = row?.messageDBId
        var newSender = false
        if indexPath.row > 0 {
            print("Entering: ConversationDetailVC: cellForRowAt(): if indexPath.row > 0")
            let priorSender = priorRow?.from
            if priorSender != row?.from {
                print("Entering: ConversationDetailVC: cellForRowAt(): if priorSender != row?.from ")
                newSender = true
            }
        }
        
        cell?.date.text = formattedTimeStamp(withSource: row?.timestamp)
        cell?.selectionStyle = .none
        cell?.dividerDate.text = formattedDate(withSource: row?.timestamp, andPriorDate: priorRow?.timestamp)
        
        if row!.encrypted {
            cell?.lockImage.isHidden = false
        } else {
            cell?.lockImage.isHidden = true
        }
        
        cell?.parent = self
        
        if row?.hasBeenReceived == false {
            if (row?.errorType.count)! > 0 {
                cell?.messageStatus.text = "Error:\(String(describing: row?.errorType)) - \(String(describing: row?.errorReason))"
                cell?.messageStatus.isHidden = false
            }
        }
        
        cell?.updateCell(withNewSender: newSender)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let message = messageList[indexPath.row]
            
            print(message)
            
            if message.messageId.isEmpty == false {
                DataLayer.sharedInstance().deleteMessageHistory(message.messageDBId)
            } else {
                return
            }
            messageList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    @objc func openLink(_ sender: Any?) {
    }
    
    override var canBecomeFirstResponder: Bool {
        print("Entering: ConversationDetailVC: canBecomeFirstResponder: Boolean")
        return true
    }
    
    override var inputAccessoryView: UIView? {
        
        print("Entering: ConversationDetailVC: inputAccessoryView()")
        return inputContainerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Entering: ConversationDetailVC: didSelectRowAt()")
        chatInput.resignFirstResponder()
        let cell = tableView.cellForRow(at: indexPath) as? BaseCell
        if cell?.link != nil {
            if cell?.responds(to: #selector(openLink(_:))) ?? false {
                (cell as? ChatCell)?.openLink(self)
            } else {
                photos = [AnyHashable]()
                let imageCell = cell as? ChatImageCell
                let photo = IDMPhoto(image: imageCell?.thumbnailImage.image)
                // photo.caption=[row objectForKey:@"caption"];
                photos?.append(photo)
            }
            
            DispatchQueue.main.async {
                if self.photos!.count > 0 {
                    let browser = IDMPhotoBrowser(photos: self.photos)
                    browser?.delegate = self
                    
                    let close = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.closePhotos))
                    browser?.navigationItem.rightBarButtonItem = close
                    let nav = UINavigationController(rootViewController: browser!)
                    self.present(nav, animated: true)
                }
            }
        }
    }
    
    @objc func closePhotos() {
        
        print("Entering: ConversationDetailVC: closePhotos()")
        navigationController?.dismiss(animated: true)
    }
}

// MARK:- Textview Delegate functions:

extension ConversationDetailVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print("Entering: ConversationDetailVC: textViewDidBeginEditing()")
        scrollToBottom()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print("Entering: ConversationDetailVC: shouldChangeTextIn()")
        var shouldinsert = true
        
        if hardwareKeyboardPresent && (text == "\n") {
            resignTextView()
            shouldinsert = false
        }
        
        return shouldinsert
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        print("Entering: ConversationDetailVC: textViewDidChange()")
        if textView.text.count > 0 {
            placeHolderText.isHidden = true
        } else {
            placeHolderText.isHidden = false
        }
    }
}


// MARK:- Commented out code to be used later:

// MARK:- Doc Picker:

//    @IBAction func attachFile(byUser sender: Any){

//        print("Entering: ConversationDetailVC: attachFile()")
//        chatInput.resignFirstResponder()
//        present(imagePicker!, animated: true)
//        return
//    }

//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        let coordinator = NSFileCoordinator()
//        if let firstObject = urls.first {
//            coordinator.coordinate(readingItemAt: firstObject, options: .forUploading, error: nil, byAccessor: { newURL in
//                do {
//                    let data = try Data(contentsOf: newURL)
//                    self.uploadData(data)
//                } catch {
//                    print("Could not upload data")
//                }
//            })
//        }
//    }

// MARK:- Location Delegate:

//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        let gpsStatus = CLLocationManager.authorizationStatus()
//        if gpsStatus == .authorizedAlways || gpsStatus == .authorizedWhenInUse {
//            if sendLocation {
//                sendLocation = false
//                locationManager?.requestLocation()
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locationManager?.stopUpdatingLocation()
//
//        // Only send geo message if gpsHUD is visible
//        if gpsHUD?.isHidden == true {
//            return
//        }
//
//        // Check last location
//        let gpsLoc = locations.last
//        if gpsLoc == nil {
//            return
//        }
//        gpsHUD?.isHidden = true
//        // Send location
//        sendMessage("geo:\(gpsLoc?.coordinate.latitude ?? 0),\(gpsLoc?.coordinate.longitude ?? 0)")
//    }

//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error while fetching location \(error)")
//    }
//
//    func makeLocationManager() {
//        if locationManager == nil {
//            locationManager = CLLocationManager()
//            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager?.delegate = self
//        }
//    }

//    func displayGPSHUD() {
//
//        print("Entering: ConversationDetailVC: displayGPSHUD()")
//        // Setup HUD
//        if (gpsHUD != nil) {
//            gpsHUD = MBProgressHUD.showAdded(to: view, animated: true)
//            gpsHUD?.removeFromSuperViewOnHide = false
//            gpsHUD?.label.text = "GPS"
//            gpsHUD?.detailsLabel.text = "Waiting for GPS signal"
//        }
//        // Display HUD
//        gpsHUD?.isHidden = false
//
//        // Trigger warning when no gps location was received
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(4 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
//            if self.gpsHUD?.isHidden == false {
//                // Stop locationManager & hide gpsHUD screen
//                self.locationManager?.stopUpdatingLocation()
//                self.gpsHUD?.isHidden = true
//
//                // Display warning
//                let gpsWarning = UIAlertController(
//                    title: "No GPS location received",
//                    message: "Monal did not received a gps location. Please try again later.",
//                    preferredStyle: .alert)
//
//                gpsWarning.addAction(UIAlertAction(title: "No GPS location received",
//                                                   style: .cancel, handler: { action in
//                                                    gpsWarning.dismiss(animated: true, completion: nil)
//                }))
//                self.present(gpsWarning, animated: true)
//            }
//        })
//    }

// MARK:- Attachment picker:

//    @IBAction func attach(_ sender: Any){

//        print("Entering: ConversationDetailVC: attach()")
//        chatInput.resignFirstResponder()
//        let account = MLXMPPManager.sharedInstance()?.getConnectedAccount(forID: contact?.accountId)
//        let actionController = UIAlertController(title: "Select Action", message: nil, preferredStyle: .actionSheet)
//
//        if (account?.connectionProperties.supportsHTTPUpload == false) {
//            let alertController = UIAlertController(
//                title: "Error",
//                message: "This server does not appear to support HTTP file uploads (XEP-0363). Please ask the administrator to enable it.",
//                preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
//                alertController.dismiss(animated: true)
//            }))
//            present(alertController, animated: true)
//            return
//        } else {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//
//            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
//                imagePicker.sourceType = .camera
//                self.present(imagePicker, animated: true)
//            })
//
//            let photosAction = UIAlertAction(title: "Photos", style: .default, handler: { action in
//                imagePicker.sourceType = .photoLibrary
//                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
//                    if granted {
//                        DispatchQueue.main.async(execute: {
//                            self.present(imagePicker, animated: true)
//                        })
//                    }
//                })
//            })
//
//            if #available(iOS 13.0, *) {
//                cameraAction.setValue(UIImage(systemName: "camera")?.withRenderingMode(.alwaysOriginal), forKey: "image")
//                photosAction.setValue(UIImage(systemName: "photo")?.withRenderingMode(.alwaysOriginal), forKey: "image")
//            } else {
//                cameraAction.setValue(UIImage(named: "714-camera")?.withRenderingMode(.alwaysOriginal), forKey: "image")
//            }
//            actionController.addAction(cameraAction)
//            actionController.addAction(photosAction)
//        }

//        let gpsAlert = UIAlertAction(title: "Send Location", style: .default, handler: { action in
//            // GPS
//            let gpsStatus = CLLocationManager.authorizationStatus()
//            if gpsStatus == .authorizedAlways || gpsStatus == .authorizedWhenInUse {
//                self.displayGPSHUD()
//                self.makeLocationManager()
//                self.locationManager?.startUpdatingLocation()
//            } else if gpsStatus == .notDetermined {
//                self.makeLocationManager()
//                self.sendLocation = true
//                self.locationManager?.requestWhenInUseAuthorization()
//            } else {
//                let permissionAlert = UIAlertController(
//                    title: "Location Access Needed",
//                    message: "ChatChat does not have access to your location. Please update the location access in your device's Privacy Settings.",
//                    preferredStyle: .alert)
//                self.present(permissionAlert, animated: true)
//                permissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//                    permissionAlert.dismiss(animated: true, completion: nil)
//                }))
//            }
//        })
//
//        if #available(iOS 13.0, *) {
//            gpsAlert.setValue(UIImage(systemName: "location")?.withRenderingMode(.alwaysOriginal), forKey: "image")
//        }
//        actionController.addAction(gpsAlert)
//
//        actionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//            actionController.dismiss(animated: true)
//        }))
//
//        actionController.popoverPresentationController?.sourceView = sender as? UIView
//        present(actionController, animated: true)
//
//    }
//
//    func uploadData(_ data: Data){
//
//        print("Entering: ConversationDetailVC: uploadData()")
//        if (uploadHUD == nil) {
//            uploadHUD = MBProgressHUD.showAdded(to: view, animated: true)
//            uploadHUD?.removeFromSuperViewOnHide = true
//            uploadHUD?.label.text = "Uploading"
//            uploadHUD?.detailsLabel.text = "Uploading file to server"
//        }
//        let decryptedData = data
//        var dataToPass = data
//        let encrypted: MLEncryptedPayload? = nil
//
//        let keySize = 32
//        if encryptChat {
//            encrypted = AESGcm.encrypt(decryptedData, keySize: keySize)
//            if (encrypted != nil) {
//                var mutableBody = encrypted?.body
//                mutableBody?.append(encrypted!.authTag)
//                dataToPass = mutableBody?.copy()
//            } else {
//                print("Could not encrypt attachment")
//            }
//        }


//More Encryption functionality below:
//
//    }

//    func imagePickerController(
//        _ picker: UIImagePickerController,
//        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//    ) {
//        dismiss(animated: true)
//
//        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
//        if mediaType == kUTTypeImage as String {
//            var selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//            if selectedImage == nil {
//                selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            }
//            let jpgData = selectedImage?.jpegData(compressionQuality: 0.5)
//            if jpgData != nil {
//                //uploadData(jpgData)
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true)
//    }


// MARK:- cellForRowAt() code:

//if row?.messageType == kMessageTypeStatus {
//    cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell") as? BaseCell
//    cell?.messageBody.text = row?.messageText
//    cell?.link = nil
//    return cell!
//}
//
//if contact!.isGroup {
//    if from == contact?.contactJid {
//        if (row?.messageType.isEqual(kMessageTypeUrl))! {
//            cell = tableView.dequeueReusableCell(withIdentifier: "linkInCell") as? BaseCell
//        } else {
//            cell = tableView.dequeueReusableCell(withIdentifier: "textInCell") as? BaseCell
//        }
//    }
//} else {
//    if (row?.messageType.isEqual(kMessageTypeUrl))! {
//        cell = tableView.dequeueReusableCell(withIdentifier: "linkOutCell") as? BaseCell
//    } else {
//        cell = tableView.dequeueReusableCell(withIdentifier: "textOutCell") as? BaseCell
//    }
//}
//
//if (row?.messageType.isEqual(kMessageTypeImage))! {
//    var imageCell: ChatImageCell?
//    if from == contact?.contactJid {
//        imageCell = tableView.dequeueReusableCell(withIdentifier: "imageInCell") as? ChatImageCell
//        imageCell?.outBound = false
//    } else {
//        imageCell = tableView.dequeueReusableCell(withIdentifier: "imageOutCell") as? ChatImageCell
//        imageCell?.outBound = true
//    }
//
//
//    if !(imageCell?.link == row?.messageText) {
//        imageCell?.link = row?.messageText
//        imageCell?.thumbnailImage.image = nil
//        imageCell?.loading = false
//        imageCell?.loadImage(withCompletion: {
//        })
//    }
//    cell = imageCell
//
//} else if (row?.messageType.isEqual(kMessageTypeUrl))! {
//    var toreturn: LinkCell?
//    if from == contact?.contactJid {
//        toreturn = tableView.dequeueReusableCell(withIdentifier: "linkInCell") as? LinkCell
//    } else {
//        toreturn = tableView.dequeueReusableCell(withIdentifier: "linkOutCell") as? LinkCell
//    }
//
//    let cleanLink = row?.messageText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    let parts = cleanLink?.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//    cell?.link = parts?[0]
//
//    toreturn?.messageBody.text = cell?.link
//    toreturn?.link = cell?.link
//
//    if row?.previewText != nil  || row?.previewImage != nil {
//        toreturn?.imageUrl = row!.previewImage as NSURL
//        toreturn?.messageTitle.text = row?.previewText
//        toreturn?.loadImage(withCompletion: {
//
//        })
//    } else {
//        toreturn?.loadPreview(withCompletion: {
//            if toreturn?.messageTitle.text?.count == 0 {
//                toreturn?.messageTitle.text = " " // prevent repeated calls
//            }
//            DataLayer.sharedInstance().setMessageId(row?.messageId, previewText: toreturn?.messageTitle.text, andPreviewImage: toreturn?.imageUrl.absoluteString)
//        })
//    }
//    cell = toreturn
//} else if (row?.messageType.isEqual(kMessageTypeGeo))! {
//    // Parse latitude and longitude
//    let geoPattern = "^geo:(-?(?:90|[1-8][0-9]|[0-9])(?:\\.[0-9]{1,32})?),(-?(?:180|1[0-7][0-9]|[0-9]{1,2})(?:\\.[0-9]{1,32})?)$"
//    let error: Error? = nil
//    var geoRegex: NSRegularExpression? = nil
//    do {
//        geoRegex = try NSRegularExpression(
//            pattern: geoPattern,
//            options: .caseInsensitive)
//    } catch {
//    }
//
//    if error != nil {
//        print("Error while loading geoPattern")
//    }
//
//    let geoMatch = geoRegex?.firstMatch(in: row!.messageText, options: [], range: NSRange(location: 0, length: (row?.messageText.count)!))
//
//    if geoMatch!.numberOfRanges > 0 {
//        let latitudeRange = (geoMatch?.range(at: 1))!
//        let longitudeRange = (geoMatch?.range(at: 2))!
//        let latitude = (row!.messageText as NSString).substring(with: latitudeRange)
//        let longitude = (row!.messageText as NSString).substring(with: longitudeRange)
//
//        // Display inline map
//        if UserDefaults.standard.bool(forKey: "ShowGeoLocation") {
//            var mapsCell: ChatMapsCell?
//            if from == contact?.contactJid {
//                mapsCell = tableView.dequeueReusableCell(withIdentifier: "mapsInCell") as? ChatMapsCell
//                mapsCell?.outBound = false
//            } else {
//                mapsCell = tableView.dequeueReusableCell(withIdentifier: "mapsOutCell") as? ChatMapsCell
//            }
//
//            // Set lat / long used for map view and pin
//            mapsCell?.latitude = Double(latitude) ?? 0.0
//            mapsCell?.longitude = Double(longitude) ?? 0.0
//
//            mapsCell?.loadCoordinates(withCompletion: {
//            })
//            cell = mapsCell
//        } else {
//            let geoString = NSMutableAttributedString(string: row!.messageText)
//            geoString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single, range: (geoMatch?.range(at: 0))!)
//
//            cell?.messageBody?.attributedText = geoString
//            let zoomLayer = 15
//            cell?.link = String(format: "https://www.openstreetmap.org/?mlat=%@&mlon=%@&zoom=%ldd", latitude, longitude, zoomLayer)
//        }
//    } else {
//        cell?.messageBody.text = row?.messageText
//        cell?.link = nil
//    }
//} else {
//
//    //Check if message contains a url
//    let lowerCase = row?.messageText.lowercased()
//    var pos = (lowerCase! as NSString).range(of: "https://")
//    if pos.location == NSNotFound {
//        pos = (lowerCase! as NSString).range(of: "http://")
//    }
//
//    var pos2: NSRange
//    if pos.location != NSNotFound {
//        var urlString = (row!.messageText as NSString).substring(from: pos.location)
//        pos2 = (urlString as NSString).range(of: " ")
//        if pos2.location == NSNotFound {
//            pos2 = (urlString as NSString).range(of: ">")
//        }
//
//        if pos2.location != NSNotFound {
//            urlString = (urlString as NSString).substring(to: pos2.location)
//        }
//        let parts = urlString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//        cell?.link = parts[0]
//
//        if (cell?.link != nil) {
//            let underlineAttribute = [
//                NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
//            ]
//            let underlined = NSAttributedString(string: (cell?.link)!, attributes: underlineAttribute)
//            let stitchedString = NSMutableAttributedString()
//            stitchedString.append(
//                NSAttributedString(string: (row!.messageText as NSString).substring(to: pos.location), attributes: nil))
//            stitchedString.append(underlined)
//            if pos2.location != NSNotFound {
//                let remainder = (row!.messageText as NSString).substring(from: pos.location + underlined.length)
//                stitchedString.append(NSAttributedString(string: remainder, attributes: nil))
//            }
//            cell?.messageBody?.attributedText = stitchedString
//        }
//    } else {
//        cell?.messageBody?.text = row?.messageText
//        cell?.link = nil
//    }
//}
//
//if contact!.isGroup {
//    cell?.name.isHidden = false
//    cell?.name.text = row?.actualFrom
//} else {
//    cell?.name.text = ""
//    cell?.name.isHidden = true
//}
//
//if row!.hasBeenSent == false {
//    cell?.deliveryFailed = true
//} else {
//    cell?.deliveryFailed = false
//}
//
//var nextRow: MLMessage? = nil
//if indexPath.row + 1 < messageList.count {
//    nextRow = messageList[indexPath.row + 1]
//}
//
//var priorRow: MLMessage? = nil
//if indexPath.row > 0 {
//    priorRow = messageList[indexPath.row - 1]
//}
//
//if row?.hasBeenReceived == true {
//    cell?.messageStatus.text = kDelivered
//    if indexPath.row == messageList.count - 1 || nextRow?.actualFrom != jabberId {
//        cell?.messageStatus.isHidden = false
//    } else {
//        cell?.messageStatus.isHidden = true
//    }
//} else {
//    cell?.messageStatus.isHidden = true
//}
//
//cell?.messageHistoryId = row?.messageDBId
//var newSender = false
//if indexPath.row > 0 {
//    let priorSender = priorRow?.from
//    if priorSender != row?.from {
//        newSender = true
//    }
//}
//
//cell?.date.text = formattedTimeStamp(withSource: row?.delayTimeStamp)
//cell?.selectionStyle = .none
//
//cell?.dividerDate.text = formattedDate(withSource: row?.delayTimeStamp, andPriorDate: priorRow?.timestamp)
//
//if row!.encrypted {
//    cell?.lockImage.isHidden = false
//} else {
//    cell?.lockImage.isHidden = true
//}
//
//if row?.from == jabberId {
//    cell?.outBound = true
//} else {
//    cell?.outBound = false
//}
//
//cell?.parent = self
//
//if row!.hasBeenReceived == false {
//    if (row?.errorType.count)! > 0 {
//        cell?.messageStatus.text = "Error:\(String(describing: row?.errorType)) - \(String(describing: row?.errorReason))"
//        cell?.messageStatus.isHidden = false
//    }
//}
//
//cell?.updateCell(withNewSender: newSender)
//
