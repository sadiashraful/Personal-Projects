//
//  NewVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 8/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class NewVC: UITableViewController {
    
    var table: UITableView!
    var selectContact: contactCompletion!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table = UITableView()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            if let addNewContactCell = tableView.dequeueReusableCell(withIdentifier: "AddNewContactCell", for: indexPath) as? AddNewContactCell {
                addNewContactCell.addNewContactLabel.text = "Add a New Contact"
                cell = addNewContactCell
            }
        } else {
            if let contactRequestsCell = tableView.dequeueReusableCell(withIdentifier: "ContactRequestsCell", for: indexPath) as? ContactRequestsCell {
                contactRequestsCell.contactRequestLabel.text = "View Contact Requests"
                cell = contactRequestsCell
            }
        }
        return cell
    }

    @IBAction func closeSreenPressed(byUser sender: UIButton){
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newContact" {
            let newScreen = segue.destination as? AddContactVC
            newScreen?.completion = { selectedContact in
                if (self.selectContact != nil) {
                    self.selectContact(selectedContact)
                }
            }
        }
        if segue.identifier == "acceptContact" {
            let newScreen = segue.destination as? ContactsRequestVC
            
        }
    }

}


