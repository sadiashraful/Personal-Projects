//
//  Alert.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 28/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import Foundation

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Ugly Alert Code", message: "You should really refactor this")
    }
    
    static func showAccountConnectedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Success", message: "Start using ChatChat")
        
    }
    
    static func showAccountErrorAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Unable to Retrieve Data", message: "Network Error")
    }
}
