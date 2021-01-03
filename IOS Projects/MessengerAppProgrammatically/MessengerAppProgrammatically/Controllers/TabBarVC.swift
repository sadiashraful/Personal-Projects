//
//  TabBarVC.swift
//  MessengerAppProgrammatically
//
//  Created by Mohammad Ashraful Islam Sadi on 2/1/21.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
//        let conversationVC = ConversationVC()
//        let conversationIcon = UITabBarItem(title: "Conversations", image: <#T##UIImage?#>)
//        conversationVC.tabBarItem = conversationIcon
//
//        let profileVC = ProfileVC()
//        let profileIcon = UITabBarItem(title: "Profile", image: )
//        conversationVC.tabBarItem = profileVC
//
//        self.viewControllers = [conversationVC, profileVC]
    }
    
    
    
}

extension TabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
