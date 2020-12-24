//
//  ContactsVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 8/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//


import UIKit


class ContactsVC: UITableViewController {
    
    let konlineSection = 1
    let kofflineSection = 2
    var contactsTable: UITableView!
    var selectContact: contactCompletion!
    var searchResults: [MLContact] = []
    var searchController: UISearchController?
    var contacts: [MLContact] = []
    var offlineContacts: [MLContact] = []
    var lastSelectedContact: MLContact?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Contacts"

        contactsTable = tableView
        contactsTable.delegate = self
        contactsTable.dataSource = self
        
        contactsTable.reloadData()
        contactsTable.register(
            UINib(
                nibName: "ContactCell",
                bundle: Bundle.main),
            forCellReuseIdentifier: "ContactCell")
        
//        searchController = UISearchController(searchResultsController: nil)
//        searchController?.searchResultsUpdater = self
//        searchController?.delegate = self
//        searchController?.obscuresBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        navigationItem.searchController = searchController

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        lastSelectedContact = nil
        refreshDisplay()
        
        if contacts.count + offlineContacts.count == 0 {
            reloadTable()
        }
        
    }
    
    // MARK:- Jingle:
    
    
    
    
    //MARK:- Message Signals:
    
    func reloadTable(){
        if contactsTable.hasUncommittedUpdates {
            return
                contactsTable.reloadData()
        }
    }
    
    func refreshDisplay(){
        if UserDefaults.standard.bool(forKey: "SortContacts"){
            DataLayer.sharedInstance()?.onlineContactsSorted(by: "Status", withCompeltion: { results in
                DispatchQueue.main.async {
                    self.contacts = results as! [MLContact]
                    self.reloadTable()
                }
            })
        } else {
            DataLayer.sharedInstance()?.onlineContactsSorted(by: "Name", withCompeltion: { results in
                DispatchQueue.main.async {
                    self.contacts = results as! [MLContact]
                    self.reloadTable()
                }
            })
        }
        
        if UserDefaults.standard.bool(forKey: "OfflineContact"){
            DataLayer.sharedInstance()?.offlineContacts(completion: { results in
                DispatchQueue.main.async {
                    self.offlineContacts = results as! [MLContact]
                    self.reloadTable()
                }
            })
        }
        
        if searchResults.count == 0 {
            DispatchQueue.main.async {
                self.reloadTable()
            }
        }
    }

    // MARK: - Table view data source
    
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row: MLContact? = nil
        if searchResults.count > 0{
            //row = searchResults[indexPath.row]
        } else {
            if indexPath.section == konlineSection{
                row = contacts[indexPath.row]
            } else if indexPath.section == kofflineSection{
                row = offlineContacts[indexPath.row]
            } else {
                print("Could not identify cell section")
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ConversationCell
        if cell == nil {
            cell = ConversationCell(style: .subtitle, reuseIdentifier: "ContactCell")
        }
        cell?.count = 0
        cell?.userImage.image = nil
        cell?.statusText.text = ""
        //cell?.showDisplayName(row?.contactDisplayName())
        if !(row?.statusMessage == "(null)") && !(row?.statusMessage == "") {
            cell?.showStatusText(row?.statusMessage)
        } else {
            cell?.showStatusText(nil)
        }
       
        if tableView == view {
            if indexPath.section == konlineSection {
                let stateString = row?.state.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if stateString == "away" || stateString == "dnd" || stateString == "xa" {
                    cell?.status = statusType.kStatusAway.rawValue
                } else if row?.state == "(null)" || row?.state == "" {
                    cell?.status = statusType.kStatusOnline.rawValue
                }
            } else if indexPath.section == kofflineSection {
                cell?.status = statusType.kStatusOffline.rawValue
            }
        } else {
            if row?.isOnline == true{
                cell?.status = statusType.kStatusOnline.rawValue
            } else {
                cell?.status = statusType.kStatusOffline.rawValue
            }
        }
        
        cell?.accessoryType = .detailDisclosureButton
        
        //let accountId = row?.accountId
        cell?.accountNo = (row!.accountId as NSString).integerValue
        cell?.username = row?.contactJid
        
        DataLayer.sharedInstance()?.countUserUnreadMessages(cell?.username, forAccount: row?.accountId, withCompletion: { (unread) in
            DispatchQueue.main.async {
                cell?.count = unread as! Int
            }
        })
        
        MLImageManager.sharedInstance().getIconForContact(row!.contactJid, andAccount: row!.accountId) { (image) in
            cell?.userImage.image = image
        }
        
        cell?.setOnlineOrOfflineStatus()
        
        DataLayer.sharedInstance()?.isMutedJid(row?.contactJid, withCompletion: { (muted) in
            DispatchQueue.main.async {
                //cell.muteBadge.isHidden = true
            }
        })
        return cell!
      }
      
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        var toReturn = 0
        if searchResults.count > 0 {
            toReturn = 1
        } else if UserDefaults.standard.bool(forKey: "OfflineContact"){
            toReturn = 3
        } else {
            toReturn = 2
        }
        return toReturn
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         var toReturn =  ""
         switch section {
         case konlineSection:
             toReturn = "Recently Seen"
         case kofflineSection:
             toReturn = "Away"
         default:
             break
         }
         return toReturn
     }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var toReturn = 0
        if searchResults.count > 0 {
            toReturn = searchResults.count
        } else {
            switch section {
                case konlineSection:
                    toReturn = contacts.count
                    break
                case kofflineSection:
                    toReturn = offlineContacts.count
                    break
                default:
                    break
            }
        }
        return toReturn
    }

  

//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { action, indexPath in
//            //self.deleteRow(at: indexPath)
//        })
//        var mute: UITableViewRowAction?
//        let cell = tableView.cellForRow(at: indexPath) as? MLContactCell
//        if cell?.muteBadge.hidden != nil {
//            mute = UITableViewRowAction(style: .default, title: "Mute", handler: { action, indexPath in
//                //self.muteContact(at: indexPath)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    self.tableView.reloadRows(at: [indexPath], with: .none)
//                })
//            })
//            mute?.backgroundColor = .red
//        } else {
//            mute = UITableViewRowAction(style: .default, title: "Unmute", handler: { action, indexPath in
//                //self.unMuteContact(at: indexPath)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    self.tableView.reloadRows(at: [indexPath], with: .none)
//                })
//            })
//            mute?.backgroundColor = .red
//        }
//        return [delete, mute]
//
//    }
    
    func contact(atIndexPath indexPath: IndexPath) -> MLContact? {
        var contact: MLContact?
        if (indexPath.section == 1) && ((indexPath.row ) <= contacts.count) {
            contact = contacts[indexPath.row]
        } else if (indexPath.section == 2) && ((indexPath.row ) <= offlineContacts.count) {
            contact = offlineContacts[indexPath.row]
        }
        return contact
    }
    
    func muteContact(atIndexPath indexPath: IndexPath){
        let contact: MLContact? = self.contact(atIndexPath: indexPath)
        if contact != nil {
            DataLayer.sharedInstance()?.muteJid(contact?.contactJid)
        }
        
    }
    
    func unMuteContact(atIndexPath indexPath: IndexPath) {
        let contact: MLContact? = self.contact(atIndexPath: indexPath)
        if contact != nil {
            DataLayer.sharedInstance()?.unMuteJid(contact?.contactJid)
        }
    }
    
    func blockContact(atIndexPath indexPath: IndexPath) {
        let contact: MLContact? = self.contact(atIndexPath: indexPath)
        if contact != nil {
            DataLayer.sharedInstance()?.blockJid(contact?.contactJid)
        }
    }
    
    
    
    // MARK:- TableView Delegate:
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if contactsTable == self.view {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove Contact"
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if tableView == self.view {
            return true
        } else {
            return false
        }
    }
    
    func deleteRow(atIndexPath indexPath: IndexPath){
        var contact: MLContact?
        if ((indexPath.section == 1) && (indexPath.row <= contacts.count)) {
            contact = contacts[indexPath.row]
        } else if(indexPath.section == 2) && (indexPath.row <= offlineContacts.count){
            contact = offlineContacts[indexPath.row]
        } else {
            return
        }
        
        var messageString: String? = nil
        if let fullName = contact?.fullName {
            messageString = "Remove \(fullName) from contacts?"
        }
        let detailString = "They will no longer see you are online. They may be able to access your encryption keys"
        let isMultiUserChat = (contact?.isGroup)!
        let alert = UIAlertController(title: messageString, message: detailString,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            if isMultiUserChat {
                MLXMPPManager.sharedInstance()?.leaveRoom(contact?.contactJid, withNick: contact?.accountNickInGroup, forAccountId: contact?.accountId)
            } else {
                MLXMPPManager.sharedInstance()?.remove(contact)
            }
            if self.searchResults.count == 0 {
                self.contactsTable.beginUpdates()
                if ((indexPath.section == 1) && (indexPath.row <= self.contacts.count)){
                    self.contacts.remove(at: indexPath.row)
                } else if (indexPath.section == 2) && (indexPath.row <= self.offlineContacts.count){
                    self.offlineContacts.remove(at: indexPath.row)
                } else {
                    self.contactsTable.endUpdates()
                    return
                }
                self.contactsTable.deleteRows(at: [indexPath], with: .automatic)
                self.contactsTable.endUpdates()
            }
        }))
        alert.popoverPresentationController?.sourceView = tableView
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var row: MLContact?
        if (searchResults.count) > 0 {
            row = searchResults[indexPath.row]
        } else {
            if indexPath.section == konlineSection {
                if indexPath.row < contacts.count {
                    row = contacts[indexPath.row]
                }
            } else if indexPath.section == kofflineSection {
                if indexPath.row < offlineContacts.count {
                    row = offlineContacts[indexPath.row]
                }
            }
            row?.unreadCount = 0
        }
        dismiss(animated: true) {
            if (self.selectContact != nil) {
                self.selectContact(row)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(atIndexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        var contactDictionary: MLContact?
        if searchResults.count > 0 {
            contactDictionary = searchResults[indexPath.row]
        } else {
            if indexPath.section == konlineSection {
                contactDictionary = contacts[indexPath.row]
            } else {
                contactDictionary = offlineContacts[indexPath.row]
            }
        }
        //performSegue(withIdentifier: "showDetails", sender: contactDictionary)
    }

}

// MARK:- Empty Data Set

extension ContactsVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "You need friends for this ride"
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "Add new contacts with the + button above. Your friends will pop up here when they can talk"

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center

        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]

        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        let toreturn = (contacts.count + offlineContacts.count == 0) ? true : false

        if toreturn {
            // A little trick for removing the cell separators
            tableView.tableFooterView = UIView()
        }

        return toreturn
    }
}

    //MARK:- SearchBar Delegate:

//extension ContactsVC: UISearchResultsUpdating, UISearchControllerDelegate {
    
        
    //    func didDismissSearchController(_ searchController: UISearchController) {
    //        searchResults = nil
    //        reloadTable()
    //    }
    //
    //    func updateSearchResults(for searchController: UISearchController) {
    //        if (searchController.searchBar.text?.count ?? 0) > 0 {
    //
    //            let term = searchController.searchBar.text
    //            searchResults = DataLayer.sharedInstance().searchContacts(with: term)
    //        } else {
    //            searchResults = nil
    //        }
    //        reloadTable()
    //    }
    // }

