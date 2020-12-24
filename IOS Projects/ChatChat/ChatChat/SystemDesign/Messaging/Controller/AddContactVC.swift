//
//  AddContactVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 8/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class AddContactVC: UITableViewController, UITextFieldDelegate {
    
    // MARK:- Properties:
    var currentTextField: UITextField?
    var selectedRow = 0
    var closeButton: UIBarButtonItem?
    weak var contactName: UITextField?
    var completion: contactCompletion?

    // MARK:- Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Add Contact"
        closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeView))
        navigationItem.rightBarButtonItem = closeButton
        
        tableView.register(UINib(nibName: "TextInputCell", bundle: Bundle.main), forCellReuseIdentifier: "TextCell")
        selectedRow = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MLXMPPManager.sharedInstance()?.connectedXMPP.count == 1 {
            MLXMPPManager.sharedInstance()?.getServiceDetails(forAccount: 0)
            selectedRow = 0
        }
    }
    
    @IBAction func addContactPressed(byUser sender: UIButton){
        if MLXMPPManager.sharedInstance()?.connectedXMPP.count == 0 {
            let messageAlert = UIAlertController(title: "No connected accounts", message: "Please make sure at least one account is connected before trying to add a new contact", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel) { action in
                print("Close Action generated")
            }
            messageAlert.addAction(closeAction)
            present(messageAlert, animated: true)
        } else {
            if (contactName?.text!.count)! > 0 {
                let dataRow = MLXMPPManager.sharedInstance()?.connectedXMPP[selectedRow] as? [AnyHashable: Any]
                let account = dataRow?["xmppAccount"] as? xmpp
                
                let contactObject = MLContact()
                contactObject.contactJid = contactName?.text as! String
                contactObject.accountId = account?.accountNo as! String
                MLXMPPManager.sharedInstance()?.add(contactObject)
                
                let messageAlert = UIAlertController(title: "Permission Requested",
                                                     message: "The new contact will be added to your contacts list when the person you have added has approved your request",
                                                     preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .cancel) { action in
                    if (self.completion != nil) {
                        self.completion!(contactObject)
                    }
                    self.dismiss(animated: true)
                }
                messageAlert.addAction(closeAction)
                present(messageAlert, animated: true, completion: nil)
            } else {
                let messageAlert = UIAlertController(title: "Permission Requested",
                                                     message: "The new contact will be added to your contact list when the person you've added has approved your request",
                                                     preferredStyle: .alert)
                present(messageAlert, animated: true, completion: nil)
                
            }
        }
    }
    
    @objc func closeView(){
        dismiss(animated: true, completion: nil)
    }

    
    //MARK:- Textfield delegate:
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    
    // MARK: - Table view datasource:

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var toReturn = 0
        switch section {
            case 0:
                toReturn = 2
                break
            case 1:
                toReturn = 1
                break
                
            default:
                break
        }
        return toReturn
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Contacts are usually in the format: username@domain.something"
        } else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let accountCell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as? AccountCell
                accountCell?.label?.text = "Using Account: \(String(describing: MLXMPPManager.sharedInstance().getAccountName(forConnectedRow: selectedRow)!))"
                accountCell?.accessoryType = .disclosureIndicator
                cell = accountCell
            } else if indexPath.row == 1 {
                let textCell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as? TextInputCell
                contactName = textCell?.textInput
                contactName?.placeholder = "Contact Name"
                contactName?.delegate = self
                cell = textCell
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "addButton")
            break
        default:
            break
        }
        return cell!
    }
    
    //MARK:- Tableview delegate:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "showAccountPicker", sender: self)
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccountPicker" {
            print("Going to next page")
        }
    }

}
