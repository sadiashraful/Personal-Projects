//
//  ViewController.swift
//  GroomedStoryboard
//
//  Created by Mohammad Ashraful Islam Sadi on 7/10/20.
//

import UIKit

@IBDesignable
class LoginVC: UIViewController {
    
    @IBOutlet weak var appLogoAndNameView: AppLogoAndNameView!
    @IBOutlet weak var masterContainerView: MasterContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterContainerView.loginCredentialsContainerView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    
    
    @objc func signInButtonTapped(){
        
        
        
        
        
        // Set up Tab Bar
        
        let discoverStoryboard = UIStoryboard(name: "Discover", bundle: nil)
        let discoverVC = discoverStoryboard.instantiateViewController(identifier: "Discover")
        discoverVC.title = "Discover"
    
        let nearbyStoryboard = UIStoryboard(name: "Nearby", bundle: nil)
        let nearbyVC = nearbyStoryboard.instantiateViewController(identifier: "Nearby")
        nearbyVC.title = "Nearby"
        
        let appointmentStoryboard = UIStoryboard(name: "Appointment", bundle: nil)
        let appointmentVC = appointmentStoryboard.instantiateViewController(identifier: "Appointment")
        appointmentVC.title = "Appointment"
        
        let messagesStoryboard = UIStoryboard(name: "Message", bundle: nil)
        let messagesVC = messagesStoryboard.instantiateViewController(identifier: "Message")
        messagesVC.title = "Messages"
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(identifier: "Profile")
        profileVC.title = "Profile"
  
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([discoverVC, nearbyVC,
                                      appointmentVC, messagesVC,
                                      profileVC], animated: true)
                
        UITabBar.appearance().tintColor = UIColor.ColorFactory.groomedThemeColor
        UITabBar.appearance().barTintColor = .white
        
        guard let items = tabBarVC.tabBar.items else { return }
        
        let tabImages = ["Discover", "Nearby", "Appointment", "Messages", "Profile"]
        
        for item in 0..<items.count {
            items[item].image = UIImage(named: tabImages[item])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    
}


