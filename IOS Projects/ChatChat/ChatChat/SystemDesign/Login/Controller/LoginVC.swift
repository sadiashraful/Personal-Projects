//
//  ViewController.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 15/6/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import Foundation
import UIKit
import SAMKeychain
import monalxmpp
import MBProgressHUD

class LoginVC: UIViewController {
    
    //MARK:- Properties:
    var loginHUD: MBProgressHUD!
    @IBOutlet weak var containerView: ContainerView!
    @IBOutlet weak var bottomViewOne: BottomViewOne!
    @IBOutlet weak var bottomViewTwo: BottomViewTwo!
    
    
    weak var activeField: UITextField?
    var accountNumber: String? 
    
    //MARK:- Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Entering viewDidLoad() in LoginVC")
        
        
        setupViewComponents()
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let viewController = storyboard.instantiateViewController(identifier: "Conversations") as? ConversationsVC else {
                return
            }
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         print("Entering viewWillAppear() in LoginVC")
         let notificationCenter = NotificationCenter.default
         
         
         notificationCenter.addObserver(self, selector: #selector(connected),
                                        name: NSNotification.Name(kMonalAccountStatusChanged),
                                        object: nil)
         
         notificationCenter.addObserver(self, selector: #selector(error),
                                        name: NSNotification.Name(kXMPPError),
                                        object: nil)
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    func setupViewComponents() {
        setupContainerView()
        setupBottomOneView()
        setupBottomTwoView()
        
        
    }
    
    func setupContainerView(){
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 10
        containerView.loginButton.layer.cornerRadius = 10
        containerView.loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
    }
    
    func setupBottomOneView(){
        view.addSubview(bottomViewOne)
        bottomViewOne.layer.cornerRadius = 5
        bottomViewOne.layer.masksToBounds = false
        bottomViewOne.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bottomViewOne.addShadow(offset: CGSize.zero,
                                color: UIColor.black, radius: 3.0, opacity: 0.35)
    }
    
    func setupBottomTwoView(){
        view.addSubview(bottomViewTwo)
        bottomViewTwo.layer.cornerRadius = 5
        bottomViewTwo.layer.masksToBounds = false
        bottomViewTwo.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bottomViewTwo.addShadow(offset: CGSize.zero,
                                color: UIColor.black, radius: 3.0, opacity: 0.35)
    }
    
    @objc func loginPressed(){
        
        print("Entering: loginPressed() in LoginVC")
        loginHUD = MBProgressHUD.showAdded(to: view, animated: true)
        loginHUD.label.text = "Logging in"
        loginHUD.mode = MBProgressHUDMode.indeterminate
        loginHUD.removeFromSuperViewOnHide = true
        
        guard let jabberID = self.containerView.usernameTextField.text else { return }
        guard let password = self.containerView.passwordTextField.text else { return }
        let elements = jabberID.components(separatedBy: "@")
        var domain: String?
        var user: String?
        
        //if it is a JabberID
        if elements.count > 1 {
            user = elements[0]
            domain = elements[1]
        }
        if user == nil || domain == nil {
            loginHUD.isHidden = true
            let alert = UIAlertController(title: "Invalid Credentails",
                                          message: "Your XMPP account should be in in the format user@domain. For special configurations, use manual setup.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true)
            return
        }
        if password.count == 0 {
            loginHUD.isHidden = true
            let alert = UIAlertController(title: "Invalid Credentails", message: "Please enter a password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true)
            return
        }
        //Test
        var dictionary: [AnyHashable : Any] = [:]
        dictionary[kDomain] = domain
        dictionary[kUsername] = user
        dictionary[kResource] = EncodingTools.encodeRandomResource()
        dictionary[kSSL] = NSNumber(value: true)
        dictionary[kEnabled] = NSNumber(value: true)
        dictionary[kSelfSigned] = NSNumber(value: false)
        dictionary[kOldSSL] = NSNumber(value: false)
        dictionary[kOauth] = NSNumber(value: false)
        
        DataLayer.sharedInstance()?.addAccount(with: dictionary, andCompletion: { (result) in
            print("Entering: addAccountWithDictionary()")
            if result {
                print("Entering: if result condition in addAccountWithDictionary()")
                DataLayer.sharedInstance().executeScalar("select max(account_id) from account", withCompletion: { accountid in
                    if accountid != nil {
                        
                        if let accountid = accountid {
                            self.accountNumber = "\(accountid)"
                            print("Entering: accountNumber: \(String(describing: self.accountNumber!))")
                        }
                        
                        SAMKeychain.setAccessibilityType(kSecAttrAccessibleAfterFirstUnlock)
                        SAMKeychain.setPassword(password, forService: "Monal", account: self.accountNumber!)
                        print("Entering: leaving setPassword() in login() in LoginVC")
                        
//                        if MLXMPPManager.sharedInstance()?.connectedXMPP.count == 0 {
                              //print("Entering if condition in connectedXMPP.count and moving towards connectAccount()")
                             MLXMPPManager.sharedInstance().connectAccount(self.accountNumber)
//                        }
                    }
                })
            }
        })
        
        print("Entering: leaving login() in LoginVC")
    }
    
    
    
    @objc func connected(_ notification: Notification) {
        print("Entering: connected() in LoginVC")
        DispatchQueue.main.async {
            print("Entering DispatchQueue in connected() in LoginVC")
         
            let alert = UIAlertController(title: "Success",
                                          message: "You are set up and connected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Start using ChatChat", style: .default, handler: { action in
                alert.dismiss(animated: true)
            
                //if (MLXMPPManager.sharedInstance()?.isAccount(forIdConnected: self.accountNumber))! {
                    
                    UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let viewController = storyboard.instantiateViewController(identifier: "Conversations") as? ConversationsVC else {
                        return
                    }
                    self.navigationController?.pushViewController(viewController, animated: true)
//                }
            
                
        
            }))
            self.present(alert, animated: true)
        }
       print("Entering: leaving connected() in LoginVC")

    }
    
    @objc func error(_ notification: Notification){
        print("Entering error() in LoginVC")
        DispatchQueue.main.async(execute: {
            
            if self.loginHUD != nil {
                self.loginHUD.isHidden = true
            }
            let alert = UIAlertController(title: "Error",
                                          message: "We were not able to connect your account. Please check your credentials and make sure you are connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                alert.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            print("Entering: removeAccount() in LoginVC")
            DataLayer.sharedInstance().removeAccount(self.accountNumber)
        })
    }
    
    @IBAction func tapAction(_ sender: Any){
        view.endEditing(true)
    }
    
    
    func removeObservers(){
        print("Entering removeObservers() in LoginVC")
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: Notification.Name(kMonalAccountStatusChanged), object: nil)
        notificationCenter.removeObserver(self, name: Notification.Name(kXMPPError), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Entering: prepareForSegue() in LoginVC")
        removeObservers()
    }
}


//MARK:- Textfield delegate methods:

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.containerView.usernameTextField = textField
        self.containerView.passwordTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.containerView.usernameTextField = nil
        self.containerView.passwordTextField = nil
    }
}






