//
//  PermissionRequestLocation.swift
//  PermissionsManagerSwift
//
//  Created by Hungju Lu on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import CoreLocation

public let PermissionRequestUserDefaultsLocationPreviouslyAskedKey = "PermissionRequestUserDefaultsLocationPreviouslyAskedKey"

public let PermissionRequestUserInfoLocationKey = "PermissionRequestUserLocationKey"

/// Permission request handler for location service.
///
public class PermissionRequestLocation: PermissionRequest, CLLocationManagerDelegate {

    public static let sharedInstance = PermissionRequestLocation()
    
    private lazy var locationManager: CLLocationManager = {
        return CLLocationManager()
    }()
    
    private var internalCompletionBlock: PermissionRequestCompletionBlock?
    
    override init() {
        super.init()
    }
    
    /// The current permission state
    override public var currentStatus: PermissionRequestStatus {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            return .SystemPromptAllowed
        case .AuthorizedAlways:
            return .SystemPromptAllowed
        case .Denied:
            return .SystemPromptDenied
        case .NotDetermined:
            
            let previouslyAsked = NSUserDefaults.standardUserDefaults().boolForKey(PermissionRequestUserDefaultsLocationPreviouslyAskedKey)
            
            if previouslyAsked == true {
                
                return .DidNotAsk
            }
            else {
                
                return .Unknown
            }
            
        case .Restricted:
            return .SystemPromptDenied
        }
    }
    
    override func permissionType() -> PermissionType {
        return .Location
    }
    
    /**
     Request permission directly by prompting system dialogue
     
     - parameter completion:     the block with the permission reqest outcome
     */
    override func requestPermission(completion: PermissionRequestCompletionBlock?) {
        self.internalCompletionBlock = completion
        self.requestAuthorization()
    }
    
    private func requestAuthorization() {
        self.locationManager.delegate = self
        
        if let _ = NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") {
            self.locationManager.requestAlwaysAuthorization()
        } else if let _ = NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            assert(false, "To use location services in iOS 8+, your Info.plist must provide a value " +
                "for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription")
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .AuthorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .Denied:
            self.internalCompletionBlock?(outcome: .SystemPromptDenied, userInfo: nil)
        case .NotDetermined:
            self.requestAuthorization()
        case .Restricted:
            self.internalCompletionBlock?(outcome: .SystemPromptDenied, userInfo: nil)
        }
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        
        guard let location = locations.first else {
            self.internalCompletionBlock?(outcome: .SystemPromptAllowed, userInfo: nil)
            return
        }
        
        self.internalCompletionBlock?(outcome: .SystemPromptAllowed, userInfo: [PermissionRequestUserInfoLocationKey: location])
    }
    
    override public func permissionsAccessViewDidIgnoreAccessPermission(controller: PermissionsAccessView) {
        
        // Before calling super's implementation we need to set the DidNotAsk value
        // in defaults.
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: PermissionRequestUserDefaultsLocationPreviouslyAskedKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        super.permissionsAccessViewDidIgnoreAccessPermission(controller)
    }
}
