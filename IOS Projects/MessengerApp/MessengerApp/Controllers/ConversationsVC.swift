//
//  ViewController.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 20/9/20.
//

import UIKit
import FirebaseAuth

class ConversationsVC: UIViewController {

    // MARK:- Properties:
    
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //DatabaseManager.shared.test()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let viewController = LoginVC()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
            
        }
    }
    
    
    
    //MARK:- Selector Methods:

}

