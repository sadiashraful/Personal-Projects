//
//  ViewController.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 20/9/20.
//

import UIKit

class ConversationsVC: UIViewController {

    // MARK:- Properties:
    
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        if !isLoggedIn {
            let viewController = LoginVC()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
        }
    }
    
    
    
    //MARK:- Selector Methods:

}

