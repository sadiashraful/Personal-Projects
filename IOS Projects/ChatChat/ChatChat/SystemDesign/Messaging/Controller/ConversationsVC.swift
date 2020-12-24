//
//  ConversationsVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 6/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit


class ConversationsVC: UITableViewController  {
    
    //MARK:- Properties"
    
    //UI Components:
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    // Functional Properties:
    var destinationDateFormat: DateFormatter?
    var sourceDateFormat: DateFormatter?
    var gregorian: Calendar?
    var thisYear = 0
    var thisMonth = 0
    var thisDay = 0
    var contacts: NSMutableArray = []
    var lastSelectedUser: MLContact?
    var lastSelectedIndexPath: IndexPath?
    
    //MARK:- Lifecycle:
    
    override func viewWillAppear(_ animated: Bool) {
        print("Entering viewWillAppear()")
        self.lastSelectedUser = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Entering: viewDidLoad() in ConversationsVC")
        
        self.navigationItem.title = "Conversations"
        view.backgroundColor = .lightGray
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.activeConversations = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view = tableView
        

        setupBackendComponents()
    }
    
    func setupBackendComponents(){
        print("Entering setupBackendComponents() in ConversationsVC")
        setupObservers()
        setupDateObjects()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Entering: viewDidAppear() in ConversationsVC")
        if contacts.count == 0 {
            refreshDisplay()
        }
    }
    
    func presentChat(withRow row: MLContact?) {
        performSegue(withIdentifier: "showConversation", sender: row)
    }
    
    func setupObservers(){
        print("Entering: setupObservers() in ConversationsVC")
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshContact(_:)),
                                               name: NSNotification.Name("kMonalContactRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNewMessage(_:)),
                                               name: NSNotification.Name("kMLNewMessageNotice"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.messageSent(_:)),
                                               name: NSNotification.Name("kMLMessageSentToContact"), object: nil)
    }
    
    func refreshDisplay(){
        print("Entering: refreshDisplay() in ConversationsVC")
        DataLayer.sharedInstance()?.activeContacts(completion: { cleanActive in
            DispatchQueue.main.async {
                if self.tableView.hasUncommittedUpdates {
                    print("Entering: if self.tableView.hasUncommittedUpdates condition in refreshDisplay() in ConversationsVC")
                    return
                }
                MLXMPPManager.sharedInstance()?.cleanArray(ofConnectedAccounts: cleanActive)
                self.contacts = cleanActive!
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK:- Selector Methods:
    
    @objc func refreshContact(_ notification: Notification?) {
        print("Entering: refreshContact() in ConversationsVC")
        let user = notification?.userInfo?["contact"] as? MLContact
        refreshRow(for: user)
    }
    
    func refreshRow(for contact: MLContact?) {
        print("Entering: refreshRowForContact() in ConversationsVC")
        DispatchQueue.main.async(execute: {
            var indexPath: IndexPath?
            self.tableView.performBatchUpdates({
                self.contacts.enumerateObjects({ obj, idx, stop in
                    let rowContact = obj as? MLContact
                    if rowContact?.contactJid == contact?.contactJid {
                        indexPath = IndexPath(row: idx, section: 0)
                        self.tableView.reloadRows(at: [indexPath].compactMap {$0}, with: .none)
                        stop.initialize(to: true)
                        return
                    }
                })
            }) { finished in
                if indexPath?.row == self.lastSelectedIndexPath?.row && !(self.navigationController?.splitViewController?.isCollapsed ?? false) {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
        })
    }
    
    
    @objc func handleNewMessage(_ notification: Notification?) {
        print("Entering: handleNewMessage() in ConversationsVC")
        let message = notification?.userInfo?["message"] as? MLMessage
        print("Message received entering handleNewMessage() is: \(String(describing: message?.messageText))")
        if message?.messageType == kMessageTypeStatus {
            print("Entering: if message?.messageType == kMessageTypeStatus condition in handleNewMessage() in ConversationsVCs")
            return
        }
        DispatchQueue.main.async {
            print("Entering: DispatchQueue in handleNewMessage() in ConversationsVC")
            if UIApplication.shared.applicationState == .background || message?.shouldShowAlert == nil {
                return
            }
            var messageContact: MLContact?
//            self.tableView.performBatchUpdates({
//                print("Entering: tableView.performBatchUpdates() in handleNewMessage() in ConversationsVC")
//                self.contacts.enumerateObjects({ object, index, stop in
//                    print("Entering: contacts.enumerateObjects() in handleNewMessage() in ConversationsVC")
//                    let rowContact = object as? MLContact
//                    if rowContact?.contactJid == message?.from {
//                        print("Entering if rowContact?.contactJid == message?.from in handleNewMessage() in ConversationsVC")
//                        messageContact = rowContact
//
//                        let indexPath = IndexPath(row: index, section: 0)
//                        self.tableView.reloadRows(at: [indexPath], with: .none)
//                        stop.initialize(to: true)
//                    }
//                })
//            })
                
            for object in self.contacts {
                let rowContact  = object as? MLContact
                if rowContact?.contactJid == message?.from {
                    messageContact = rowContact
                }
            }
            self.tableView.reloadData()
//            { finished in
                if (messageContact == nil) {
                    print("Entering: messageContact != nil condition in handleNewMessage() in ConversationsVC")
                    self.refreshDisplay()
                } else {
                    self.insertOrMove(Contact: messageContact, completion: nil)
                }
//            }
            print("Entering: leaving DispatchQueue() in handleNewMessage() in ConversationsVC")
        }
        
        print("Entering: leaving handleNewMessage() in ConversationsVC")
    }
    
    @objc func messageSent(_ notification: Notification?) {
        print("Entering: messageSent() in ConversationsVC")
        let contact = notification?.userInfo?["contact"] as? MLContact
        DispatchQueue.main.async(execute: {
            self.insertOrMove(Contact: contact, completion: nil)
        })
    }
    
    func insertOrMove(Contact contact: MLContact?, completion: ((_ finished: Bool) -> Void)? = nil) {
        print("Entering: insertOrMove() in ConversationsVC")
        let newPath = IndexPath(row: 0, section: 0)
        var indexPath = IndexPath(row: 0, section: 0)
//        contacts.enumerateObjects({ object, index, stop in
//            print("Entering: contacts.enumerateObjects() in insertOrMoveContact() in ConversationsVC ")
//            let rowContact = object as? MLContact
//            if rowContact?.contactJid == contact?.contactJid {
//                print("Entering: if rowContact?.contactjid == contact.contactJid in insertOrMoveContact() in ConversationsVC")
//                indexPath = IndexPath(row: index, section: 0)
//                stop.initialize(to: true)
//            }
//        })
        
        for object in self.contacts {
            let rowContact  = object as? MLContact
            if rowContact?.contactJid == contact?.contactJid {
                //messageContact = rowContact
            }
        }
        
        
        if indexPath.count != 0 {
            print("Entering: if indexPath.count != 0 in insertOrMoveContact() in ConversationsVC")
            if indexPath.row != 0 {
                print("Entering: if indexPath.row != 0 in insertOrMoveContact() in ConversationsVC")
//                tableView.performBatchUpdates({
//                    self.contacts.remove(indexPath.row)
//                    self.contacts.insert(contact!, at: 0)
//                    self.tableView.moveRow(at: indexPath, to: newPath)
//                })
//                { finished in
//                    if (completion != nil) {
//                        completion!(finished)
//                    }
//                }
                
                self.tableView.reloadData()
            }
        } else {
            
//            tableView.performBatchUpdates({
//                print("Entering: else condition performBatchUpdates() in insertOrMoveContact() in ConversationsVC")
//                self.contacts.insert(contact!, at: 0)
//                self.tableView.insertRows(at: [newPath], with: .automatic)
//            }) { finished in
                self.tableView.reloadData()
                print("Entering: refreshDisplay() after completion in insertOrMoveContact() in ConversationsVC")
                self.refreshDisplay()                //to remove empty dataset
//                if (completion != nil) {
//                    print("Entering: if completion != nil in insertOrMoveContact() in ConversationsVC")
//                    completion!(finished)
//                }
//            }
        }
        print("Entering: leaving insertOrMoveContact() in ConversationsVC")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Entering: prepareForSegue() in ConversationsVC")
        if segue.identifier == "showConversation" {
            let navigationController = segue.destination as? UINavigationController
            let conversationDetailVC = navigationController?.topViewController as? ConversationDetailVC
            conversationDetailVC?.setupWithContact(sender as? MLContact)
            
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            guard let conversationDetailVC = storyboard.instantiateViewController(identifier: "ConversationDetail") as? ConversationDetailVC else {
//                return
//            }
//            self.navigationController?.pushViewController(conversationDetailVC, animated: true)
            
            
            
        } else if segue.identifier == "showContacts" {
            let navigationController = segue.destination as? UINavigationController
            let contacts = navigationController?.topViewController as? ContactsVC
            contacts?.selectContact = { selectedContact in
                DataLayer.sharedInstance().addActiveBuddies(selectedContact?.contactJid,
                                                            forAccount: selectedContact?.accountId,
                                                            withCompletion: { success in
                                                                //no success may mean its already there
                                                                DispatchQueue.main.async(execute: {
                                                                    self.insertOrMove(Contact: selectedContact) { finished in
                                                                        let path = IndexPath(row: 0, section: 0)
                                                                        self.tableView.selectRow(at: path, animated: false, scrollPosition: .none)
                                                                        self.presentChat(withRow: selectedContact)
                                                                    }
                                                                })
                })
            }
        } else if segue.identifier == "showNew" {
            let navigationController = segue.destination as? UINavigationController
            let newScreen = navigationController?.topViewController as? NewVC
            newScreen?.selectContact = { selectedContact in
                DataLayer.sharedInstance()?.addActiveBuddies(selectedContact?.contactJid,
                                                             forAccount: selectedContact?.accountId,
                                                             withCompletion: { success in
                                                                //no success may mean its already here
                                                                DispatchQueue.main.async {
                                                                    self.insertOrMove(Contact: selectedContact) { finished in
                                                                        let path = IndexPath(row: 0, section: 0)
                                                                        self.tableView.selectRow(at: path, animated: false, scrollPosition: .none)
                                                                        self.presentChat(withRow: selectedContact)
                                                                    }
                                                                }
                })
            }
        }
    }
    
    
    
    //MARK:- TableView Datasource:
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Entering: numberOfRowsInSection() in ConversationsVC")
        print("Contact count entering in numberOfRowsInSection(): \(contacts.count)")
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Entering: cellForRowAt() in ConversationsVC")
        var cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell
        if cell == nil {
            cell = ConversationCell(style: .default, reuseIdentifier: "ConversationCell")
        }
        
        let row = contacts[indexPath.row] as! MLContact
        
        cell?.displayName.text = row.contactJid
        
        let state = row.state.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (state == "away") || (state == "dnd") || (state == "xa") {
            cell?.status = statusType.kStatusAway.rawValue
        } else if state == "offline" {
            cell?.status = statusType.kStatusOffline.rawValue
        } else if (state == "(null)") || (state == "") {
            cell?.status = statusType.kStatusOnline.rawValue
        }
        
        let accountNumberString = (row.accountId)
        let accountNumberInt = Int(accountNumberString)
        cell?.accountNo = accountNumberInt!
        cell?.username = row.contactJid
        cell?.count = 0
        
        
        DataLayer.sharedInstance().countUserUnreadMessages(cell?.username, forAccount: row.accountId, withCompletion: { unread in
            print("Entering: countUserUnreadMessages() in cellForRowAt() in ConversationsVC")

            DispatchQueue.main.async(execute: {
                print("Entering: DispatchQueue1 in cellForRowAt() in ConversationsVC")
                
                cell?.count = unread?.intValue ?? 0
                print("Entering: leaving DispatchQueue1 in cellForRowAt() in ConversationsVC")
            })
        })
        
        
        DataLayer.sharedInstance()?.lastMessage(forContact: cell?.username, forAccount: row.accountId, withCompletion: { (messages) in
            print("Entering: lastMessageForContact() in cellForRowAt() in ConversationsVC")
            
            DispatchQueue.main.async {
                print("Entering: DispatchQueue2 in cellForRowAt() in ConversationsVC")
                
                if messages!.count > 0 {
                    print("Entering: if messages!.count > 0 condition in cellForRowAt() in ConversationVC()")
                    let messageRow = messages?[0] as! MLMessage
                    
                    if messageRow.messageType.isEqual(kMessageTypeUrl) {
                        cell?.showStatusText("🔗 A Link")
                    } else if messageRow.messageType.isEqual(kMessageTypeImage) {
                        cell?.showStatusText("📷 An Image")
//                    } else if messageRow.messageType.isEqual(kMessageTypeMessageDraft) {
//                        let draftPreview = "Draft: \(messageRow.messageText)"
//                        cell?.showStatusTextItalic(draftPreview, withItalicRange: NSRange(location: 0, length: 6))
                    } else if messageRow.messageType.isEqual(kMessageTypeGeo) {
                        cell?.showStatusText("📍 A Location")
                    } else {
                        cell?.showStatusText(messageRow.messageText)
                    }
                    
                    if messageRow.timestamp.description.isEmpty == false {
                        cell?.time.text = self.formattedDate(withSource: messageRow.timestamp)
                        cell?.time.isHidden = false
                    } else {
                        cell?.time.isHidden = true
                    }
                    
                } else {
                    cell?.showStatusText(nil)
                    print("Active chat but no messages found in history for \(String(describing: row.contactJid)).")
                }
                print("Entering: leaving DispatchQueue2 in cellForRowAt() in ConversationsVC")
            }
        })
        
        MLImageManager.sharedInstance().getIconForContact(row.contactJid, andAccount: row.accountId) { (image) in
            cell?.userImage.image = image
        }
        
        print("Entering: leaving cellForRowAt() in ConversationsVC")
        return cell!
        
    }
    
    
    //MARK:- TableView Delegate:
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Hide Chat"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelectedIndexPath = indexPath
        //let selected = contacts[indexPath.row] as! MLContact
//        if selected.contactJid == lastSelectedUser?.contactJid {
//            return
//        }
        presentChat(withRow: contacts[indexPath.row] as? MLContact)
        lastSelectedUser = contacts[indexPath.row] as? MLContact
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let contactDictionary = contacts[indexPath.row]
        //performSegue(withIdentifier: "showDetails", sender: contactDictionary)
    }
    
    // MARK:- Date Functions:
    
    func formattedDate(withSource sourceDate: Date) -> String {
        let messageDay = self.gregorian?.component(.day, from: sourceDate)
        let messageMonth = self.gregorian?.component(.month, from: sourceDate)
        let messageYear = self.gregorian?.component(.year, from: sourceDate)
        
        let showFullDate = true
        
        if((thisDay != messageDay) || (thisMonth != messageMonth) || (thisYear != messageYear)) && showFullDate {
            destinationDateFormat?.dateStyle = .medium
            destinationDateFormat?.timeStyle = .none
        } else {
            destinationDateFormat?.dateStyle = .none
            destinationDateFormat?.timeStyle = .short
        }
        
        let dateString = destinationDateFormat?.string(from: sourceDate)
        return (dateString != "" ? dateString: "")!
    }
    
    func setupDateObjects(){
        destinationDateFormat = DateFormatter()
        destinationDateFormat?.locale = NSLocale.current
        destinationDateFormat?.doesRelativeDateFormatting = true
        
        sourceDateFormat = DateFormatter()
        sourceDateFormat?.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        sourceDateFormat?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        thisDay = gregorian!.component(.day, from: now)
        thisMonth = gregorian!.component(.month, from: now)
        thisYear = gregorian!.component(.year, from: now)
    }
}

// MARK:- Empty Data set:

//extension ConversationsVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//
//    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        let text = "No one is here"
//        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0),
//                          NSAttributedString.Key.foregroundColor: UIColor.darkGray]
//
//        return NSAttributedString(string: text, attributes: attributes)
//    }
//
//    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        let text = "When you start talking to someone,\n they will show up here."
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byWordWrapping
//        paragraph.alignment = .center
//
//        let attributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),
//            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
//            NSAttributedString.Key.paragraphStyle: paragraph
//        ]
//
//        return NSAttributedString(string: text, attributes: attributes)
//    }
//
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
//        let toReturn = (contacts.count == 0) ? true : false
//        if toReturn {
//            tableView.tableFooterView = UIView()
//        }
//        return toReturn
//    }
//}



