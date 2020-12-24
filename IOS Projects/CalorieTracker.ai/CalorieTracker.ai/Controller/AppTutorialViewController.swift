//
//  AppTutorialViewController.swift
//  CalorieTracker.ai
//
//  Created by Sadi Ashraful on 26/11/2018.
//  Copyright © 2018 Sadi Ashraful. All rights reserved.
//

import UIKit
import PaperOnboarding

class AppTutorialViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    func onboardingItemsCount() -> Int {
        return 6
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "AppLogo2"),
                               title: "Welcome to CalorieTracker.ai!",
                               description: "Please take a few minutes to learn the features of the app",
                               pageIcon: #imageLiteral(resourceName: "AppLogo2"),
                               color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "slide_gesture"),
                               title: "Navigate through the application",
                               description: "Swipe to switch between Food Tracker, Run and Personal Information",
                               pageIcon: #imageLiteral(resourceName: "slide_gesture"),
                               color: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "iconfinder_home_house_lock_password_2992201"),
                               title: "Be part of our growing healthy community",
                               description: "Create an account using your email and password",
                               pageIcon: #imageLiteral(resourceName: "iconfinder_home_house_lock_password_2992201"),
                               color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 19)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 15)!),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "iconfinder_Camera_2998131"),
                               title: "Tracker",
                               description: "Take a picture or choose from your albums and let the app track down the calories",
                               pageIcon: #imageLiteral(resourceName: "iconfinder_Camera_2998131"),
                               color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "running-man"),
                               title: "Run",
                               description: "Keep Track of your location, pace and time while running",
                               pageIcon: #imageLiteral(resourceName: "running-man"),
                               color: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "iconfinder_f-optimization_256_282464"),
                               title: "Settings",
                               description: "You can click on Settings tab to see personal information and application details",
                               pageIcon: #imageLiteral(resourceName: "iconfinder_f-optimization_256_282464"),
                               color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!)
            ][index]
    }

    internal func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 5 {
            UIView.animate(withDuration: 0.2, animations: {
                self.getStartedButton.alpha = 1
            })
        }
    }
    
     @IBOutlet weak var onboardingView: OnboardingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

   

}
