//
//  LoginVC.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 20/9/20.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class LoginVC: UIViewController {
    
    //MARK:- Properties:
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Email Address..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let facebookLoginButon: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email, public_profile"]
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private var loginObserver: NSObjectProtocol?
    
    //MARK:- Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification,
                                                               object: nil, queue: .main, using: { [weak self] _ in
                                                                guard let strongSelf = self else { return }
                                                                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                                               })
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done, target: self,
                                                            action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        facebookLoginButon.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButon)
        scrollView.addSubview(googleLoginButton)
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20, width: size, height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        
        facebookLoginButon.frame = CGRect(x: 30,
                                          y: loginButton.bottom+10,
                                          width: scrollView.width-60,
                                          height: 52)
        
        
        googleLoginButton.frame = CGRect(x: 30,
                                         y: facebookLoginButon.bottom+10,
                                         width: scrollView.width-60,
                                         height: 52)
        
    }
    
    //MARK:- Selector Methods:
    
    @objc private func loginButtonTapped(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
        
        // Firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] (authResult, error) in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let result = authResult, error == nil else {
                print("Failed to login in user email: \(email)")
                return
            }
            let user = result.user
            print("DEBUG: Logged In User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertUserLoginError(){
        let alertController = UIAlertController(title: "Whoops",
                                                  message: "Please enter all information to log in.",
                                                  preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                  style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterVC()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}

extension LoginVC: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton,
                      didCompleteWith result: LoginManagerLoginResult?,
                      error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: [
                                                            "fields": "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start { (_, result, error) in
            guard let result = result as? [String: Any],
                  error == nil else {
                print("DEBUG: Failed to make facebook graph request")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let strongSelf = self else {return}
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("DEBUG: Facebook credential login failed, MFA may be needed - \(error)")
                    }
                    print("Facebook credential login failed, MFA may be needed")
                    return
                }
                print("DEBUG: Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
            
            print("DEBUG: Result is \(result)")
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String else {
                print("DEBUG: Failed to get email and name from fb result")
                return
            }
            
            DatabaseManager.shared.userExists(with: email) { (exists) in
                if !exists {
                    let chatUser = ChatAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser) { success in
                        if success {
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            print("DEBUG: Downloading data from facebook image")
                            URLSession.shared.dataTask(with: url) { (data, response, error) in
                                guard let data = data else {
                                    print("DEBUG: Failed to get data from facebook")
                                    return
                                }
                                // upload image
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data,
                                                                              fileName: fileName) { (result) in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage manager error: \(error)")
                                    }
                                }
                            }.resume()
                        }
                    }
                }
            }
            
            
        }
        
        
    }
    
    
}
