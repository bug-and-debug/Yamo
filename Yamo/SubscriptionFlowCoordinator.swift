//
//  SubscriptionFlowCoordinator.swift
//  Yamo
//
//  Created by Peter Su on 07/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCPermissions_Swift

@objc protocol SubscriptionFlowCoordinatorDelegate: class {
    
    func subscriptionFlowDidFinishWithViewController(viewController: UIViewController)
}

// This class will take in a view controller and check the current state of the app to see which view controller should be pushed next, once it reaches the end, it will dismiss the viewcontroller's navigation controller

class SubscriptionFlowCoordinator: NSObject {
    weak var delegate: SubscriptionFlowCoordinatorDelegate?
    
    // if it's self or nil then it means we're at the end of the flow
    func nextViewForCurrentViewController(viewController: UIViewController) -> UIViewController? {
    
        if viewController is AuthenticationViewController {
            
            // privacyFlow() handles asking the user to change their privacy settings or go to get to know me.
            return self.privacyFlow()
        } else if viewController is PrivacyPermissionRequestViewController {
            
            return self.getToKnowMeFlow()
        } else if viewController is GetToKnowMeOnboardingViewController {
            
            let getToKnowMeViewController = viewController as! GetToKnowMeOnboardingViewController
            
            if let venueResults = getToKnowMeViewController.venueResults where getToKnowMeViewController.venueResults?.count > 0 {
                
                let numberOfMatchingSummaries = MapSuggestionsViewController.numberOfMatchingVenueSummaries(venueResults)
                
                if numberOfMatchingSummaries > 0 {
                    
                    return self.presentMapSuggestion(venueResults)
                }
                else {
                    
                    self.delegate?.subscriptionFlowDidFinishWithViewController(viewController)
                    return nil
                }
            } else {
                self.delegate?.subscriptionFlowDidFinishWithViewController(viewController)
                return nil
            }
        }
        
        self.delegate?.subscriptionFlowDidFinishWithViewController(viewController)
        return nil
    }
    
    // MARK: - Private
    
    // MARK: Flows
    
    private func privacyFlow() -> UIViewController? {
        
        if self.currentLoggedInUserHasCompletedSignup() {
            
            return self.getToKnowMeFlow()
        } else {
            return self.presentPrivacyPermissionRequest()
        }
    }
    
    private func getToKnowMeFlow() -> UIViewController? {
        
        let getToKnowMeViewController = GetToKnowMeOnboardingViewController(nibName: "GetToKnowMeOnboardingViewController", bundle: nil)
        getToKnowMeViewController.getToKnowMeStyle = .OnBoarding
        return getToKnowMeViewController
    }
    
    // MARK: Helpers
    
    private func presentNotificationsPermissionRequest() -> NotificationsPermissionRequestViewController {
        
        let permissionsViewController = NotificationsPermissionRequestViewController()

        return permissionsViewController
    }
    
    private func presentPrivacyPermissionRequest() -> PrivacyPermissionRequestViewController {
        
        let permissionsViewController = PrivacyPermissionRequestViewController()

        return permissionsViewController
    }
    
    private func presentMapSuggestion(venueSummaries:[VenueSearchSummary]?) -> MapSuggestionsViewController {
        
        let mapSuggestionsViewController = MapSuggestionsViewController(nibName: "MapSuggestionsViewController", bundle: nil)
        mapSuggestionsViewController.venueSummaries = venueSummaries
        
        return mapSuggestionsViewController
    }
    
    private func currentLoggedInUserHasCompletedSignup() -> Bool {
        
        return UserService.sharedInstance().loggedInUser.signUpCompleted
    }
    
    private func checkNotificationEnabled() -> Bool {
        
        let application = UIApplication.sharedApplication()
        
        var enabled = application.isRegisteredForRemoteNotifications()
        
        if enabled {
            
            let userNotificationSettings = application.currentUserNotificationSettings()
            if let settings = userNotificationSettings{
                if settings.types == .None {
                    enabled = false
                }
            }
        }
        
        return enabled
    }
}
