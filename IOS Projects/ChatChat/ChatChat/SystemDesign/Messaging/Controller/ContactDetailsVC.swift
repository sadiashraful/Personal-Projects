//
//  ContactDetailsVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 14/8/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

typealias controllerCompletion = () -> Void

class ContactDetailsVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var contact: MLContact?
    var completion: controllerCompletion?
    
    var isEncrypted: Bool?
    var isSubscribed: Bool?
    var subscriptionMessage: String?
    var accountNo: String?
    var xmppAccount: xmpp?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if contact == nil { return }
        
        MLXMPPManager.sharedInstance()?.getVCard(contact)
        navigationItem.title = contact?.contactJid
        
        accountNo = contact?.accountId
        DataLayer.sharedInstance()?.addContact(contact?.contactJid, forAccount: accountNo, fullname: "", nickname: "", andMucNick: nil, withCompletion: { (success) in })
        
        //Code might break here because it is unwrapped forcefully
        let newSubscription: [AnyHashable : Any] = (DataLayer.sharedInstance()?.getSubscriptionForContact(contact?.contactJid,
                                                                                                          andAccount: contact?.accountId))!
        contact?.ask = newSubscription["ask"] as! String
        contact?.subscription = newSubscription["subscription"] as! String
        
        if contact?.subscription == nil || contact?.subscription != kSubBoth {
            isSubscribed = false
            
            if contact?.subscription == kSubNone {
                subscriptionMessage = "Neither can see your keys"
            } else if contact?.subscription == kSubTo {
                subscriptionMessage = "You can see their keys. They can't see yours"
            } else if contact?.subscription == kSubFrom {
                subscriptionMessage = "They can see your keys. You can't see theirs"
            } else {
                subscriptionMessage = "Unknown Subscription"
            }
            
            if contact?.ask == kAskSubscribe {
                subscriptionMessage = "\(String(describing: subscriptionMessage)) Pending Approval"
            }
            
        } else {
            isSubscribed = true
        }
        
        #if !DISABLE_OMEMO
            xmppAccount = MLXMPPManager.sharedInstance().getConnectedAccount(forID: accountNo)
            xmppAccount?.queryOMEMODevices(from: contact!.contactJid)
        #endif
        
        refreshLock()
    }
    
    // Function prepare for segue below:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showKeys" {
            let keysTableVC = segue.destination as? KeysTableVC
            keysTableVC?.contact = contact
        }
    }
    
    @IBAction func toggleEncryption(_ sender: Any){
        #if !DISABLE_OMEMO
        let devices = xmppAccount?.monalSignalStore.knownDevices(forAddressName: contact?.contactJid)
//        let devices = xmppAccount?.monalSignalStore.allDeviceIds(forAddressName: contact!.contactJid)
            
                if devices!.count > 0 {
                    if isEncrypted! {
                        DataLayer.sharedInstance()?.disableEncrypt(forJid: contact?.contactJid, andAccountNo: accountNo)
                        refreshLock()
                    } else {
                        DataLayer.sharedInstance()?.encrypt(forJid: contact?.contactJid, andAccountNo: accountNo)
                        refreshLock()
                    }
                } else {
                    
         let alert = UIAlertController(title: "Encryption Not Supported",
                                                  message: "This contact does not appear to have any devices that support encryption.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                        alert.dismiss(animated: true)
                    }))
                    present(alert, animated: true)
                    return
                }
        #endif
    }
    
    func refreshLock(){
        isEncrypted = DataLayer.sharedInstance()?.shouldEncrypt(forJid: contact?.contactJid, andAccountNo: accountNo)
        DispatchQueue.main.async {
            let path = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [path], with: .none)
        }
    }
}


extension ContactDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? ContactDetailHeaderCell
            detailCell?.jabberID.text = contact?.contactJid
            detailCell?.isContact.isHidden = isSubscribed!
            detailCell?.isContact.text = subscriptionMessage
            detailCell?.lockButton.isHidden = false
            
            if isSubscribed == false {
                detailCell?.lockButton.isHidden = true
            }
            
            if isEncrypted! {
                detailCell?.lockButton.setImage(#imageLiteral(resourceName: "baseline_enhanced_encryption_white_24pt_1x"), for: .normal)
            } else {
                detailCell?.lockButton.setImage(#imageLiteral(resourceName: "baseline_no_encryption_white_24pt_1x"), for: .normal)
            }
            
            cell = detailCell!
            
        } else if indexPath.row == 1 {
            let encryptionCell = tableView.dequeueReusableCell(withIdentifier: "EncryptionKeysCell") as? EncryptionKeysCell
            encryptionCell?.encryptionKeys.text = "View Encryption Keys"
            encryptionCell?.accessoryType = .disclosureIndicator
            cell = encryptionCell!
            
        } else if indexPath.row == 2 {
            let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as? ContactCell
            
            if isSubscribed == true {
                contactCell?.contactLabel.text = "Remove Contact"
            } else {
                contactCell?.contactLabel.text = "Add Contact"
            }
            
            contactCell?.contactLabel.isHidden = false
            contactCell?.accessoryType = .disclosureIndicator
            cell = contactCell!
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "showKeys", sender: self)
        } else if indexPath.row == 2{
            if isSubscribed == true {
                removeContact()
            } else {
                addContact()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 225
        } else {
            return 42
        }
    }
}

extension ContactDetailsVC {
     
    // Add and Remove contact functionality:
    
    func addContact(){
        var messageString: String? = nil
        if let fullName = contact?.contactJid {
            messageString = "Add \(fullName) to your contacts"
        }
        let detailString = "They will see when you are online. They will be able to send you encrypted messages."

        let alert = UIAlertController(
            title: messageString,
            message: detailString,
            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            MLXMPPManager.sharedInstance().add(self.contact)
//            if (self.contact?.state == kSubTo) || (self.contact?.state == kSubNone) {
                if self.contact?.state == "to" || self.contact?.state == "none" {
                    MLXMPPManager.sharedInstance().approve(self.contact)                 //incase there was a pending request
                }
//            }
        }))

        alert.popoverPresentationController?.sourceView = tableView

        present(alert, animated: true)

    }
    
    func removeContact(){
        var messageString: String? = nil
        if let fullName = contact?.contactJid {
            messageString = "Remove \(fullName) from your contacts"
        }
        let detailString = "They will no longer see when you are online. They may not be able to send you encrypted messages."
        
        let alert = UIAlertController(
            title: messageString,
            message: detailString,
            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            MLXMPPManager.sharedInstance().remove(self.contact)
        }))

        alert.popoverPresentationController?.sourceView = tableView

        present(alert, animated: true)
    }
}
