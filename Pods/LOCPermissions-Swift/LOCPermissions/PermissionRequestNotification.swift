//
//  PermissionRequestNotification.swift
//  PermissionsManagerSwift
//
//  Created by Hungju Lu on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

public let PermissionRequestUserDefaultsNotificationPreviouslyAskedKey = "PermissionRequestUserDefaultsNotificationPreviouslyAskedKey"

/// Permission request handler for local and remote notification.
///
/// The notification settings are default granted for Sound, Badge and Alert, you can set the settings which 
/// suits for your application to the property `notificationSettings`.
///
/// Notice: To use the PermissionRequestNotification to register for local and user-facing remote notifications,
/// the app delegate must implement `-application:didRegisterUserNotificationSettings:` and
/// calls the `-application:didRegisterUserNotificationSettings:` method here to inform
/// any pending requests that a change occured.
///
public class PermissionRequestNotification: PermissionRequest {
   
    public static let sharedInstance = PermissionRequestNotification()
    
    /// The notification settings are default granted for Sound, Badge and Alert,
    /// you can change the settings which suits for your application
    public lazy var notificationSettings: UIUserNotificationSettings = {
        let types: UIUserNotificationType = [.Sound, .Badge, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        return settings
    }()
    
    private var internalCompletionBlock: PermissionRequestCompletionBlock?
    
    override init() {
        super.init()
    }
    
    /// The current permission state
    override public var currentStatus: PermissionRequestStatus {
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else {
            return .Unsupported
        }
        
        if (settings.types.contains(self.notificationSettings.types)) {
            return .SystemPromptAllowed
        } else {
            let previouslyAsked = NSUserDefaults.standardUserDefaults().boolForKey(PermissionRequestUserDefaultsNotificationPreviouslyAskedKey)
            
            if previouslyAsked {
                return .SystemPromptDenied
            } else {
                return .Unknown
            }
        }
    }
    
    override func permissionType() -> PermissionType {
        return .Notification
    }
    
    /**
     Request permission directly by prompting system dialogue
     
     - parameter completion:     the block with the permission reqest outcome
     */
    override func requestPermission(completion: PermissionRequestCompletionBlock?) {
        guard let appDelegate = UIApplication.sharedApplication().delegate else {
            assert(false, "No application delegate found")
            return
        }
        
        assert(appDelegate.respondsToSelector(#selector(UIApplicationDelegate.application(_:didRegisterUserNotificationSettings:))),
               "the app delegate must implement -application:didRegisterUserNotificationSettings: and calls the -application:didRegisterUserNotificationSettings: method here to inform any pending requests that a change occured.")
        
        self.internalCompletionBlock = completion
        
        UIApplication.sharedApplication().registerUserNotificationSettings(self.notificationSettings)
    }
    
    /**
     Deregister remote notification permission
     
     - parameter completion: the block with the permission reqest outcome
     */
    public func unregisterRemotePermission(completion: PermissionRequestCompletionBlock) {
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: PermissionRequestUserDefaultsNotificationPreviouslyAskedKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     This method must be called in the implementation of -application:didRegisterUserNotificationSettings: in app delegate
     
     - parameter application:
     - parameter notificationSettings:
     */
    public func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: PermissionRequestUserDefaultsNotificationPreviouslyAskedKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.internalCompletionBlock?(outcome: self.currentStatus, userInfo: nil)
    }
}
