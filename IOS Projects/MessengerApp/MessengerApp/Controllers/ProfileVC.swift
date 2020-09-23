//
//  ProfileVC.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 20/9/20.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn


class ProfileVC: UIViewController {
    
    
    // MARK:- Properties:
    @IBOutlet weak var userOptions: UITableView!
    let data = ["Log Out"]
    
    // MARK:- Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userOptions.register(UITableViewCell.self,
                             forCellReuseIdentifier: "cell")
        userOptions.delegate = self
        userOptions.dataSource = self
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userOptions.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userOptions.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "Sign out from the App",
                                            message: "Are you sure you want to sign out",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { [weak self] (_) in
                                                
                                                guard let strongSelf = self else {return}
                                                
                                                // Log out of Facebook
                                                FBSDKLoginKit.LoginManager().logOut()
                                                
                                                // Log out Google
                                                GIDSignIn.sharedInstance()?.signOut()
                                                
                                                do {
                                                    // Log out of Firebase
                                                    try FirebaseAuth.Auth.auth().signOut()
                                                    let viewController = LoginVC()
                                                    let navigationController = UINavigationController(rootViewController: viewController)
                                                    navigationController.modalPresentationStyle = .fullScreen
                                                    strongSelf.present(navigationController,
                                                                       animated: true,
                                                                       completion: nil)
                                                } catch {
                                                    print("DEBUG: Failed to sign out")
                                                }
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
}
