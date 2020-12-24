//
//  ComposeMessageVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class ComposeMessageVC: UITableViewController {
    
    // MARK:- Properties:
    
    @IBOutlet weak var keyboardToolbar: UIToolbar!
    weak var contactName: UITextField?
    weak var message: UITextField?
    weak var accountName: UITextField?
 
    var currentTextField: UITextField?
    var accountPicker: UIPickerView?
    var accountPickerView: UIView?
    var selectedRow = 0
    

    // MARK:- Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Send A Message"
        accountPicker = UIPickerView()
        accountPickerView = UIView(frame: accountPicker!.frame)
        accountPickerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        accountPickerView?.addSubview(accountPicker!)
        accountPicker?.delegate = self
        accountPicker?.dataSource = self
        accountPicker?.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        
        tableView.register(UINib(nibName: "TextInputCell", bundle: Bundle.main),
                            forCellReuseIdentifier: "TextCell")
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountPicker?.reloadAllComponents()
        
        if MLXMPPManager.sharedInstance()?.connectedXMPP.count == 1 {
            MLXMPPManager.sharedInstance()?.getServiceDetails(forAccount: 0)
            accountPicker?.selectedRow(inComponent: 0)
        }
    }
    
    @IBAction func close(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: Any){
        if MLXMPPManager.sharedInstance()?.connectedXMPP.count == 0 {
            let messageAlert = UIAlertController(title: "No connected accounts",
                                                   message: "Please make sure at least one account has connected before trying to message someone.",
                                                   preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel)
            messageAlert.addAction(closeAction)
            present(messageAlert, animated: true)
        } else {
            if self.message?.text?.count == 0 {
                let messageAlert = UIAlertController(title: "Error", message: "Message can't be empty", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .cancel)
                messageAlert.addAction(closeAction)
                present(messageAlert, animated: true)
                return
            }
            if (self.contactName?.text!.count)! > 0 {
                var account: xmpp?
                if selectedRow < (MLXMPPManager.sharedInstance()?.connectedXMPP.count)! && selectedRow >= 0 {
                    let dataRow = MLXMPPManager.sharedInstance()?.connectedXMPP[selectedRow] as? [AnyHashable: Any]
                    account = dataRow?["xmppAccount"] as? xmpp
                }
                let messageID = UUID().uuidString
                let name = contactName?.text
                let text = message?.text
                let encryptChat = DataLayer.sharedInstance()?.shouldEncrypt(forJid: name, andAccountNo: account?.accountNo)
                DataLayer.sharedInstance()?.addMessageHistory(from: account?.connectionProperties.identity.jid, to: name, forAccount: account?.accountNo,
                                                              withMessage: text, actuallyFrom: account?.connectionProperties.identity.jid, withId: messageID,
                                                              encrypted: encryptChat!, withCompletion: nil)
                MLXMPPManager.sharedInstance()?.sendMessage(text, toContact: name, fromAccount: account?.accountNo,
                                                            isEncrypted: encryptChat!, isMUC: false, isUpload: false,
                                                                messageId: messageID, withCompletionHandler: nil)
                DataLayer.sharedInstance()?.addActiveBuddies(name, forAccount: account?.accountNo, withCompletion: nil)
                dismiss(animated: true)
            } else {
                let messageAlert = UIAlertController(title: "Error", message: "Recipient name can't be empty", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .cancel) 
                messageAlert.addAction(closeAction)
                self.present(messageAlert, animated: true, completion: nil)
            }
        }
        
        close(self)
    }
    
    // MARK: - Table view data source and delegate:

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var toReturn = 0
        switch section {
            case 0:
                toReturn = 3
            case 1:
                toReturn = 1
            default:
                break
        }

        return toReturn
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let textCell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextInputCell
            if indexPath.row == 0 {
                if MLXMPPManager.sharedInstance()?.connectedXMPP.count == 1 {
                    self.accountName?.text = MLXMPPManager.sharedInstance()?.getAccountName(forConnectedRow: 0)
                }
                if (MLXMPPManager.sharedInstance()?.connectedXMPP.count)! > 1 {
                    self.accountName = textCell.textInput
                    self.accountName?.placeholder = "Account"
                    self.accountName?.inputView = accountPickerView
                    self.accountName?.delegate = self
                } else {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "blank")
                    cell.contentView.backgroundColor = UIColor.systemGroupedBackground
                    break
                }
            } else if indexPath.row == 1 {
                self.contactName = textCell.textInput
                self.contactName?.placeholder = "Receipient Name"
                self.contactName?.delegate = self
            } else if indexPath.row == 2 {
                self.message = textCell.textInput
                self.message?.placeholder = "Message"
                self.message?.delegate = self
            }
            textCell.textInput.inputAccessoryView = keyboardToolbar
            cell = textCell
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "addButton")!
            break
        default: break
    }
        return cell
    }
    
    // MARK:- Toolbar Actions:
    
    @IBAction func toolbarDone(_ sender: Any) {
        if currentTextField == contactName {
            contactName?.resignFirstResponder()
        } else {
            accountName?.resignFirstResponder()
        }
    }
    
    @IBAction func toolbarPrevious(_ sender: Any) {
        if currentTextField == contactName {
            accountName?.becomeFirstResponder()
        } else {
            contactName?.becomeFirstResponder()
        }
    }
    
    @IBAction func toolbarNext(_ sender: Any) {
        if currentTextField == contactName {
            accountName?.becomeFirstResponder()
        } else {
            contactName?.becomeFirstResponder()
        }
    }
    
}



// MARK:- PickerView Delegate:
extension ComposeMessageVC: UIPickerViewDelegate {
    
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedRow = row
    accountName?.text = MLXMPPManager.sharedInstance().getAccountName(forConnectedRow: row)
    MLXMPPManager.sharedInstance().getServiceDetails(forAccount: row)
  }
    
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if row < MLXMPPManager.sharedInstance().connectedXMPP.count {
          let name = MLXMPPManager.sharedInstance().getAccountName(forConnectedRow: row)
          if name != "" {
              return name
          }
      }
      return "Unnamed"
  }
}

// MARK:- PickerView Datasource:
extension ComposeMessageVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (MLXMPPManager.sharedInstance()?.connectedXMPP.count)!
    }
}

 // MARK:- TextField Delegate:
extension ComposeMessageVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
     
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         currentTextField = textField
         return true
     }
}


