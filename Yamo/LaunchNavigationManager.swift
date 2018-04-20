    //
    //  LaunchNavigationManager.swift
    //  Yamo
    //
    //  Created by Mo Moosa on 21/04/2016.
    //  Copyright © 2016 Locassa. All rights reserved.
    //
    
    import UIKit
    import LOCPermissions_Swift
    
    protocol LaunchNavigationManagerDelegate: class {
        
        func launchNavigationManagerDidFinish(launchNavigationManager: LaunchNavigationManager)
    }
    
    class LaunchNavigationManager: UINavigationController, LaunchNavigationViewControllerDelegate, UINavigationControllerDelegate {
        weak var launchManagerDelegate: LaunchNavigationManagerDelegate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.navigationBar.hidden = true
            self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
        }
        
        func startFromViewController(viewController: UIViewController) {
            
            if let accessToken = UserService.sharedInstance().accessToken() {
                self.loginAutomatically(accessToken, fromViewController: viewController)
            } else {
                // Note: Modification from Sep 2016 - Change requests from Yamo
                // self.presentOnBoarding(fromViewController: viewController)
                self.bypassOnboardingProcess()
            }
        }
        
        func loginAutomatically(accessToken: NSString, fromViewController: UIViewController) {
            
            APIClient.sharedInstance().userSessionManagerForAccessToken(accessToken as String)
            
            APIClient.sharedInstance().userGetUserWithSuccessBlock({
                successBlock in
                
                self.launchManagerDelegate?.launchNavigationManagerDidFinish(self)
                
                }, failureBlock: {
                    failureBlock in
                    
                    // Note: Modification from Sep 2016 - Change requests from Yamo
                    // self.presentOnBoarding(fromViewController: fromViewController)
                    self.bypassOnboardingProcess()
            })
        }
        
        func bypassOnboardingProcess() {
            
            self.showIndicator(true)
            
            APIClient.sharedInstance().authenticationCreateGuestUserBeforeLoad(nil, afterLoad: nil, successBlock: { (element) in
                
                self.showIndicator(false)
                
                self.navigateToMapViewController()
                
            }) { (error, status, context) in
                
                self.showIndicator(false)
                
                UIAlertController.showAlert(inViewController: self,
                                            withTitle: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Seems you are not connected to Internet", comment: ""),
                                            cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                                            destructiveButtonTitle: NSLocalizedString("Try Again", comment: ""),
                                            otherButtonTitles: nil,
                                            tapBlock: { (_, action, _) in
                                                if action.style == .Destructive {
                                                    self.bypassOnboardingProcess()
                                                }
                })
                
//                UIAlertController.showAlert(inViewController: self,
//                                            withTitle: NSLocalizedString("Error", comment: ""),
//                                            message: NSLocalizedString("Something went wrong, please try again later.", comment: ""),
//                                            cancelButtonTitle: NSLocalizedString("Ok", comment: ""),
//                                            destructiveButtonTitle: nil,
//                                            otherButtonTitles: nil,
//                                            tapBlock: nil)
            }
        }
        
        func viewControllerDidFinish(viewController: UIViewController) {
            self.navigateToViewControllerAsGuestUserFromViewController(viewController)
        }
        
        // MARK: - UINavigationControllerDelegate
        
        func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
            
            if let viewController = viewController as? LaunchNavigationViewController {
                
                viewController.onboardingDelegate = self
            }
        }
        
        // MARK: - View presentation
        
        private func presentLoginView(animated: Bool) {
            
            let loginViewController = AuthenticationViewController()
            loginViewController.onboardingDelegate = self
            self.pushViewController(loginViewController, animated: animated)
        }
        
        private func presentOnBoarding(fromViewController viewController: UIViewController) {
            
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.onboardingDelegate = self
            
            let onboardingViewMap = OnboardingContentViewController(title: NSLocalizedString("Map", comment: ""),
                                                                    message:NSLocalizedString("The map shows you exhibitions in your area represented by coloured spheres. The colour of the sphere tells you what kind of exhibition it is. The larger the sphere is, the more relevant the exhibition is to you.", comment: ""), onboardingImages: [UIImage(named:"OnboardingMap-1")!, UIImage(named:"OnboardingMap-2")! ])
            
            let onboardingRoutePlanner = OnboardingContentViewController(title: NSLocalizedString("Route Planner", comment: ""),
                                                                         message:NSLocalizedString("The route planner lets you plot a path to your chosen exhibition. You can choose a start and end location and view suggested exhibitions that are along your way.", comment: ""), onboardingImages: [UIImage(named:"OnboardingRoutePlanner-1")!, UIImage(named:"OnboardingRoutePlanner-2")! ])
            
            let onboardingGetToKnowMe = OnboardingContentViewController(title: NSLocalizedString("Get to Know Me", comment: ""),
                                                                        message:NSLocalizedString("Swipe the images to tell gowithYamo how you rate them. This helps us understand which exhibitions are most relevant to your taste.", comment: ""), onboardingImages: [UIImage(named:"OnboardingGTKM-1")!, UIImage(named:"OnboardingGTKM-2")!, UIImage(named:"OnboardingGTKM-3")! ])
            
            let onboardingProfile = OnboardingContentViewController(title: NSLocalizedString("Profile", comment: ""),
                                                                    message:NSLocalizedString("Your profile is where you can find galleries that you’ve saved, Friends that have joined, images that you have liked in the ‘Get To Know Me’, and routes to galleries that you have saved.", comment: ""), onboardingImages: [UIImage(named:"OnboardingProfile-1")!, UIImage(named:"OnboardingProfile-2")! ])
            
            let onboardingNotifications = OnboardingContentViewController(title: NSLocalizedString("Notifications", comment: ""),
                                                                          message:NSLocalizedString("This is where you can find out the latest. Which of your favourite galleries has a new exhibition opening or when an exhibition is close to finishing. This is where you find all of your notifications in one place.", comment: ""), onboardingImages: [UIImage(named:"OnboardingNotifications-1")!, UIImage(named:"OnboardingNotifications-2")! ])
            
            
            onboardingViewController.onboardingViewControllers = [onboardingGetToKnowMe, onboardingViewMap, onboardingRoutePlanner, onboardingProfile, onboardingNotifications]
            
            if let navigationController = viewController.navigationController {
                navigationController.pushViewController(onboardingViewController, animated: true)
            }
            else {
                self.pushViewController(onboardingViewController, animated: true)
            }
        }
        
        private func presentNotificationsPermissionRequest(fromViewController viewController: UIViewController) {
            
            let permissionsViewController = NotificationsPermissionRequestViewController()
            
            permissionsViewController.onboardingDelegate = self
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(permissionsViewController, animated: true)
            }
            else {
                
                self.pushViewController(permissionsViewController, animated: true)
            }
        }
        
        private func presentLocationPermissionRequest(fromViewController viewController: UIViewController) {
            
            let permissionsViewController = LocationPermissionRequestViewController()
            
            permissionsViewController.onboardingDelegate = self
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(permissionsViewController, animated: true)
            }
            else {
                
                self.pushViewController(permissionsViewController, animated: true)
            }
        }
        
        private func presentPrivacyPermissionRequest(fromViewController viewController: UIViewController) {
            
            let permissionsViewController = PrivacyPermissionRequestViewController()
            
            permissionsViewController.onboardingDelegate = self
            
            if let navigationController = viewController.navigationController {
                
                navigationController.pushViewController(permissionsViewController, animated: true)
            }
            else {
                
                self.pushViewController(permissionsViewController, animated: true)
            }
        }
        
        private func presentGetToKnowMe(fromViewController viewController: UIViewController) {
            
            let getToKnowMeViewController = GetToKnowMeOnboardingViewController(nibName: "GetToKnowMeOnboardingViewController", bundle: nil)
            
            getToKnowMeViewController.onboardingDelegate = self
            getToKnowMeViewController.getToKnowMeStyle = .OnBoarding
            
            if let navigationController = viewController.navigationController {
                navigationController.pushViewController(getToKnowMeViewController, animated: true)
            }
            else {
                
                self.pushViewController(getToKnowMeViewController, animated: true)
            }
            
        }
        private func presentMapSuggestion(venueSummaries:[VenueSearchSummary]?, fromViewController viewController: UIViewController) {
            
            let mapSuggestionsViewController = MapSuggestionsViewController(nibName: "MapSuggestionsViewController", bundle: nil)
            
            mapSuggestionsViewController.onboardingDelegate = self
            mapSuggestionsViewController.venueSummaries = venueSummaries
            
            if let navigationController = viewController.navigationController {
                navigationController.pushViewController(mapSuggestionsViewController, animated: true)
            }
            else {
                
                self.pushViewController(mapSuggestionsViewController, animated: true)
            }
            
        }
        
        private func navigateToViewControllerAsGuestUserFromViewController(viewController: UIViewController) {
            
            if viewController is OnboardingViewController {
                
                if PermissionRequestLocation.sharedInstance.currentStatus == .SystemPromptAllowed {
                    self.navigateToMapViewController()
                } else {
                    self.presentLocationPermissionRequest(fromViewController: viewController)
                }
            }
            else if viewController is LocationPermissionRequestViewController {
                
                self.navigateToMapViewController()
            }
            else {
                
                assert(false, "Unexpected flow")
            }
        }
        
        private func navigateToMapViewController() {
            
            self.dismissViewControllerAnimated(false, completion: nil)
            self.launchManagerDelegate?.launchNavigationManagerDidFinish(self)
        }
    }
