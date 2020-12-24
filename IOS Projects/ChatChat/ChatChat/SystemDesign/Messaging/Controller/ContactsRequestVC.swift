//
//  ContactsRequestVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 12/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class ContactsRequestVC: UITableViewController {
    
//    var requests: [AnyHashable]?
    var requests: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataLayer.sharedInstance()?.contactRequestsForAccount(completion: { result in
//            self.requests = result as? [AnyHashable]
            self.requests = result!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath)
        let contact = requests[indexPath.row] as? MLContact
        cell.textLabel?.text = contact?.contactJid
        let account = MLXMPPManager.sharedInstance()?.getConnectedAccount(forID: contact?.accountId)
//        if let jabberId = account?.connectionProperties.identity.jid {
//            cell.detailTextLabel?.text = "Account: \(jabberId)"
//        }
        
        cell.detailTextLabel?.text = "Account: \(String(describing: account?.connectionProperties.identity.jid))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Allowing someone to add you as a contact lets them see when you online. It also allows you to send encrypted messages.  Tap to approve. Swipe to reject." 
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = requests[indexPath.row] as? MLContact
        MLXMPPManager.sharedInstance()?.approve(contact)
        print("Contact approved successfully")
        DataLayer.sharedInstance()?.deleteContactRequest(contact)
        if contact?.subscription == kSubFrom || contact?.subscription == kSubNone {
            if let contact = contact {
                MLXMPPManager.sharedInstance()?.add(contact)
                print("Contact added successfully")
            }
        }
        //requests.remove(indexPath.row)
        requests.removeObject(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }


}
