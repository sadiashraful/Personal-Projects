//
//  ViewController.swift
//  Groomed
//
//  Created by Mohammad Ashraful Islam Sadi on 6/10/20.
//

import UIKit

class LoginVC: UIViewController {
    
    private let labelAndLogoContainerView: UIView = {
       let view = UIView()
        view.setDimensions(height: 54, width: 265)
        return view
    }()
    
    private let logoImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "appLogo")!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.setDimensions(height: 33, width: 33)
        imageView.addShadow()
        return imageView
    }()
    
    private let groomedLabel: UILabel = {
       let label = UILabel()
        label.text = "GROOMED"
        label.textColor = .white
        label.font = UIFont.FontFactory.appLogoFont
        label.addShadow()
        return label
    }()
    
    private let emailLabel: UILabel = {
      let label = UILabel()
        label.text = "Email"
        label.font = UIFont(name: "AvenirNext-Light", size: 8)
        label.textColor = .gray
        return label
    }()
    
    private let emailTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .blue
        textField.textColor = .black
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 10)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private let emailLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.setHeight(2.0)
        return view
    }()
    
    private let passwordLabel: UILabel = {
       let label = UILabel()
        label.text = "Password"
        label.font = UIFont(name: "AvenirNext-Light", size: 8)
        label.textColor = .gray
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.backgroundColor = .blue
        textField.textColor = .black
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 10)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private let passwordLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.setHeight(2.0)
        return view
    }()
    
    private let forgotPasswordButton: UIButton = {
       let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.textColor = .black
        button.backgroundColor = .white
        return button
    }()
    
    private let signInButton: UIButton = {
      let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = UIColor.ColorFactory.groomedThemeColor
        return button
    }()
    
    private let credentialsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let socialMediaSignInContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("You don't have an account? Sign Up", for: .normal)
        return button
    }()
    
    private let masterContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ColorFactory.groomedThemeColor
        navigationController?.navigationBar.isHidden = true
        
        configureUI()
    }
    
    func configureUI(){
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Adding Subviews
        labelAndLogoContainerView.addSubview(groomedLabel)
        labelAndLogoContainerView.addSubview(logoImage)
        view.addSubview(labelAndLogoContainerView)
        
        labelAndLogoContainerView.centerX(inView: view)
        labelAndLogoContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                    paddingTop: 88)
        
        groomedLabel.centerY(inView: labelAndLogoContainerView)
        groomedLabel.anchor(right: labelAndLogoContainerView.safeAreaLayoutGuide.rightAnchor,
                            paddingRight: -5)
        
        logoImage.centerY(inView: labelAndLogoContainerView)
        logoImage.anchor(left: labelAndLogoContainerView.safeAreaLayoutGuide.leftAnchor,
                         paddingLeft: 5)
        
        let credentialStackView = UIStackView()
        credentialStackView.axis = NSLayoutConstraint.Axis.vertical
        credentialStackView.distribution = UIStackView.Distribution.equalSpacing
        credentialStackView.alignment = UIStackView.Alignment.leading
        credentialStackView.spacing = 15.0
        
        credentialStackView.addArrangedSubview(emailLabel)
        credentialStackView.addArrangedSubview(emailTextField)
        credentialStackView.addArrangedSubview(passwordLabel)
        credentialStackView.addArrangedSubview(passwordTextField)
        
        credentialsContainerView.addSubview(credentialStackView)
        credentialStackView.anchor(top: credentialsContainerView.safeAreaLayoutGuide.topAnchor,
                                   left: credentialsContainerView.safeAreaLayoutGuide.leftAnchor,
                                   right: credentialsContainerView.safeAreaLayoutGuide.rightAnchor,
                                   paddingTop: 50, paddingLeft: 0, paddingRight: 0)
        emailTextField.setDimensions(height: 15, width: credentialsContainerView.bounds.size.width)
        
        credentialsContainerView.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: credentialStackView.safeAreaLayoutGuide.bottomAnchor,
                                    right: credentialStackView.safeAreaLayoutGuide.rightAnchor,
                                    paddingTop: 5, paddingBottom: 15, paddingRight: 5)
        
        credentialsContainerView.addSubview(signInButton)
        signInButton.centerX(inView: credentialsContainerView)
        signInButton.anchor(top: forgotPasswordButton.safeAreaLayoutGuide.bottomAnchor,
                            left: credentialsContainerView.safeAreaLayoutGuide.leftAnchor,
                            right: credentialsContainerView.safeAreaLayoutGuide.rightAnchor,
                            paddingTop: 20, paddingLeft: 0, paddingRight: 0)
                            
        
        masterContainerView.addSubview(credentialsContainerView)
        credentialsContainerView.anchor(top: masterContainerView.safeAreaLayoutGuide.topAnchor,
                                        left: masterContainerView.safeAreaLayoutGuide.leftAnchor,
                                        right: masterContainerView.safeAreaLayoutGuide.rightAnchor,
                                        paddingTop: 10, paddingLeft: 25, paddingRight: -25)
        
        masterContainerView.addSubview(socialMediaSignInContainerView)
        masterContainerView.addSubview(signUpButton)
        
        view.addSubview(masterContainerView)
        masterContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                   left: view.safeAreaLayoutGuide.leftAnchor,
                                   bottom: view.bottomAnchor,
                                   right: view.safeAreaLayoutGuide.rightAnchor,
                                   paddingTop: 200,
                                   paddingLeft: 0,
                                   paddingBottom: 0,
                                   paddingRight: 0)
        
    }
}


extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
            print("TextField did begin editing method called")
        }

    func textFieldDidEndEditing(_ textField: UITextField) {
            print("TextField did end editing method called")
        }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            print("TextField should begin editing method called")
            return true;
        }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
            print("TextField should clear method called")
            return true;
        }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            print("TextField should snd editing method called")
            return true;
        }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            print("While entering the characters this method gets called")
            return true;
        }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("TextField should return method called")
            textField.resignFirstResponder();
            return true;
        }
}

