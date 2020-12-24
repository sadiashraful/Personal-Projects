//
//  KeysTableVC.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 16/8/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class KeysTableVC: UITableViewController {

    var ownKeys: Bool = true
    var contact: MLContact?
    var account: xmpp?
    var devices: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ownKeys {
            navigationItem.title = "My Encryption Keys"
        } else {
            navigationItem.title = "Encryption Keys"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        account = MLXMPPManager.sharedInstance()?.getConnectedAccount(forID: contact?.accountId)
        #if !DISABLE_OMEMO
            devices = account?.monalSignalStore.knownDevices(forAddressName: contact?.contactJid) as! [Int]
        #endif
    }
    
    @objc func toggleTrust(_ sender: Any){
        let button = sender as? UISwitch
        let row = (button?.tag ?? 0) - 100

        #if !DISABLE_OMEMO
            guard let device = devices[row] as? NSNumber else { return }
            let address = SignalAddress(name: contact!.contactJid, deviceId: Int32(Int(truncating: device)))

            guard let identity = account?.monalSignalStore.getIdentityFor(address) else { return }

            var newTrust: Bool
            if (account?.monalSignalStore.isTrustedIdentity(address, identityKey: identity))! {
                newTrust = false
            } else {
                newTrust = true
            }

            account?.monalSignalStore.updateTrust(newTrust, for: address)
        #endif
    }
}


extension KeysTableVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "key", for: indexPath) as? KeysCell
        let device = devices[indexPath.row]
        let address = SignalAddress(name: contact!.contactJid, deviceId: Int32(Int(device)))
        
        #if !DISABLE_OMEMO
            let identity = account?.monalSignalStore.getIdentityFor(address)
            
            cell?.key.text = EncodingTools.signalHexKey(with: identity)
            cell?.toggle.isOn = ((account?.monalSignalStore.isTrustedIdentity(address, identityKey: identity!)) != nil)
            cell?.toggle.tag = 100 + indexPath.row
            cell?.toggle.addTarget(self, action: #selector(toggleTrust(_:)), for: .valueChanged)
            if UInt32(device) == account?.monalSignalStore.deviceid {
                cell?.deviceId.text = String(format: "%ld (This device)", Int(device))
            } else {
                cell?.deviceId.text = String(format: "%ld", Int(device))
            }
        #endif
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var toReturn: String = ""
        if section == 0 {
            if ownKeys {
                toReturn = "These are your encryption keys. Each device is a different place you have logged in. You should trust a key when you have verified it."
            } else {
                toReturn = "You should trust a key when you have verified it. Verify by comparing the key below to the one on your contact's screen."
            }
        }
        
        return toReturn
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var toReturn: String = ""
        if section == 0 {
            toReturn = "Monal uses OMEMO encryption to protect your conversations"
        }
        return toReturn
    }
    
    
}
