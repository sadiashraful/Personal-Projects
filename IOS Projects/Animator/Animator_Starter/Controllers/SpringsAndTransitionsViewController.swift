//
//  SpringsAndTransitionsViewController.swift
//  Animator_Starter
//
//  Created by Sadi Ashraful on 18.02.18.

import UIKit

class SpringsAndTransitionsViewController: UIViewController {

    // MARK: Storyboard outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfieldContainer: UIView!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var footerLabel: UILabel!
    
    // MARK: Additional variables
    let phoneTextfield = UITextField()
    let swappedFooterLabel = UILabel()
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Programmatic views for transitions
        phoneTextfield.frame = CGRect(x: 0, y: (passwordTextfield.frame.origin.y + passwordTextfield.frame.size.height + 18), width: 225, height: 35)
        phoneTextfield.placeholder = "Phone Number"
        phoneTextfield.backgroundColor = .white
        phoneTextfield.layer.cornerRadius = 5.0
        phoneTextfield.font = UIFont.systemFont(ofSize: 14)
        phoneTextfield.borderStyle = .roundedRect
        phoneTextfield.contentVerticalAlignment = .center
        
        swappedFooterLabel.frame = footerLabel.bounds
        swappedFooterLabel.backgroundColor = .white
        swappedFooterLabel.text = "Maybe next time!"
        swappedFooterLabel.font = UIFont(name: "Bodoni 72 Oldstyle", size: 15)
        swappedFooterLabel.textColor = .black
        swappedFooterLabel.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Animation setup
        titleLabel.alpha = 0
        continueButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: Fire initial animations
        animateTitleInWithSpring()
        showContinueButton()
    }

    // MARK: Action buttons
    @IBAction func segmentControlOnSelected(_ sender: UISegmentedControl) {
        // TODO: Toggle UI layout
        if sender.selectedSegmentIndex == 1{
            addTextFieldWithTransition()
        } else {
            removeTextFieldWithTransition()
        }
        
    }
    
    @IBAction func continueOnButtonPressed(_ sender: UIButton) {
        // TODO: Swap footer label
        swapViewWithTransition()
    }
    
    // MARK: Animations & Transitions
    func animateTitleInWithSpring(){
        UIView.animate(withDuration: 2.0, delay: 0.25, usingSpringWithDamping: 0.60, initialSpringVelocity: 3.5, options: [], animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.frame.origin.y += 150
            
        }, completion: nil)
    }
    
    func showContinueButton(){
        UIView.transition(with: self.continueButton, duration: 1.0, options: [.transitionFlipFromBottom], animations: {
            self.continueButton.isHidden = false
        }, completion: nil)
    }
    
    func addTextFieldWithTransition(){
        UIView.transition(with: self.textfieldContainer, duration: 1.0, options: [.transitionCrossDissolve], animations: {
            self.textfieldContainer.addSubview(self.phoneTextfield)
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.transitionCurlUp], animations: {
            self.continueButton.center.y += 28
        }, completion: nil)
    }
    
    func swapViewWithTransition(){
        UIView.transition(from: self.footerLabel, to: self.swappedFooterLabel, duration: 1.0, options: [.transitionCurlDown]) { completed in
            self.segueToNextViewController(segueID: Constants.Segues.toKeyframesVC, delay: 0.8)
        }
    }
    
    func removeTextFieldWithTransition(){
        UIView.transition(with: self.textfieldContainer, duration: 1.0, options: [.showHideTransitionViews], animations: {
            self.phoneTextfield.removeFromSuperview()
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.transitionCurlDown], animations: {
            self.continueButton.center.y -= 28
        }, completion: nil)
    }
    
    
    
    
    
    
    
}
