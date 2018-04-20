//
//  PermissionTypes.swift
//  PermissionsManagerSwift
//
//  Created by Hungju Lu on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

@objc public enum PermissionType: Int {
    case Location
    case Notification
    case PhotoCamera
    case PhotoLibrary
    case CalendarEvents
    case CalendarReminders
    case Contacts
    case Microphone
    case Activities
    case SocialFacebook
    case SocialTwitter
    case Health
    case Unknown
}

public func StringForPermissionType(type: PermissionType) -> String {
    switch type {
    case .Location:
        return "Location"
    case .Notification:
        return "Notification"
    case .PhotoCamera:
        return "Camera"
    case .PhotoLibrary:
        return "Photos"
    case .CalendarEvents:
        return "Calendar"
    case .CalendarReminders:
        return "Reminders"
    case .Contacts:
        return "Contacts"
    case .Microphone:
        return "Microphone"
    case .Activities:
        return "Activities"
    case .SocialFacebook:
        return "Facebook Account"
    case .SocialTwitter:
        return "Twitter Account"
    case .Health:
        return "Health"
    case .Unknown:
        return "Unknown"
    }
}

@objc public enum PermissionRequestStatus: Int {
    case Unknown
    case Unsupported
    case DidNotAsk
    case SystemPromptDenied
    case SystemPromptAllowed
}

public typealias PermissionRequestCompletionBlock = (outcome: PermissionRequestStatus, userInfo: [String: AnyObject]?) -> Void
