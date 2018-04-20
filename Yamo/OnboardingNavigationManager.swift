//
//  OnboardingNavigationManager.swift
//  Yamo
//
//  Created by Mo Moosa on 21/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

protocol OnboardingNavigationManagerDelegate: class {
    
    func onboardingNavigationManagerDidFinish(onboardingNavigationManager: LaunchNavigationManager)
}

class LaunchNavigationManager: UINavigationController, LaunchNavigationViewControllerDelegate, UINavigationControllerDelegate {
    weak var onboardingManagerDelegate: OnboardingNavigationManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let navigationController = self.navigationController {
            
//            self.navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//            self.navigationController.navigationBar.shadowImage = UIImage()
//            self.navigationController.navigationBar.translucent = true
//            
//            self.navigationController.navigationBar.tintColor = UIColor.whiteColor()
        }
    }
    
    func start() {

        if let accessToken = UserService.sharedInstance().accessToken() {
            
            self.loginAutomatically(accessToken)
        }
        else {
            
            self.presentLoginView(false)
        }
    }
    
    func pushNextViewController(fromViewController: UIViewController) {
    
    }
    
    func presentLoginView(animated: Bool) {
        
        let loginViewController = LoginPlaceholderViewController()
        loginViewController.onboardingDelegate = self
        self.pushViewController(loginViewController, animated: true)
    }
    
    func loginAutomatically(accessToken: NSString) {
    
        // Get the session manager, authorize it with the token and attempt to get the user.
        // If this fails, present the login screen.
        
        self.presentLoginView(true)
    }
    
    func presentView(userStage: NSInteger) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerDidFinish(viewController: UIViewController) {
        
        // While this is one big mess at this time it will be refactored when actual viewcontrollers with content are used
        // instead of placeholders.
        
        if viewController is ForgottenPasswordViewController {
            
            self.pushViewController(ChangePasswordViewController(), animated: true)
        }
        else if viewController is ChangePasswordViewController {
            
            self.onboardingManagerDelegate?.onboardingNavigationManagerDidFinish(self)
            
        }
        else if viewController is LoginPlaceholderViewController {
            
            self.onboardingManagerDelegate?.onboardingNavigationManagerDidFinish(self)
            
        }
        else if viewController is SignupPlaceholderViewController {
    
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.onboardingDelegate = self
            
            onboardingViewController.onboardingViewControllers = [OnboardingContentViewController(), OnboardingContentViewController(), OnboardingContentViewController()]
            
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(onboardingViewController, animated: true)
            }
            else {
                
                self.pushViewController(onboardingViewController, animated: true)
            }
        }
        else if viewController is OnboardingViewController {

            let permissionsViewController = NotificationsPermissionViewController()

            permissionsViewController.onboardingDelegate = self
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(permissionsViewController, animated: true)
            }
            else {
                
                self.pushViewController(permissionsViewController, animated: true)
            }
        }
        else if viewController is NotificationsPermissionViewController {
            
            let permissionsViewController = LocationPermissionsViewController()
            
            permissionsViewController.onboardingDelegate = self
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(permissionsViewController, animated: true)
            }
            else {
                
                self.pushViewController(permissionsViewController, animated: true)
            }
        }
        else if viewController is LocationPermissionsViewController {
            
            let permissionsViewController = PrivacyPermissionsViewController()
            
            permissionsViewController.onboardingDelegate = self
           
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(permissionsViewController, animated: true)
            }
            else {
                
                self.pushViewController(permissionsViewController, animated: true)
            }
            
        }
        else if viewController is PrivacyPermissionsViewController {
            
            let getToKnowMeViewController = GetToKnowMeViewController()
            getToKnowMeViewController.onboardingDelegate = self
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(getToKnowMeViewController, animated: true)
            }
            else {
                
                self.pushViewController(getToKnowMeViewController, animated: true)
            }
        }
        else if viewController is GetToKnowMeViewController {
            
            self.dismissViewControllerAnimated(false, completion: nil)
            self.onboardingManagerDelegate?.onboardingNavigationManagerDidFinish(self)
        }
    }

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        if let viewController = viewController as? LaunchNavigationViewController {
            
            viewController.onboardingDelegate = self
        }
    }
}
