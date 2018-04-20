//
//  LocationPermissionRequestViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 20/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCPermissions_Swift

class LocationPermissionRequestViewController: PermissionRequestViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationRequest = PermissionRequestLocation.sharedInstance
        
        let viewModel = PermissionRequestViewModel(permissionRequest: locationRequest)
        
        viewModel.title = NSLocalizedString("Location", comment: "")
        viewModel.message = NSLocalizedString("We would like to use your location to show you exhibitions near you and let you plan routes from your current location.", comment: "")
        viewModel.okButtonTitle = NSLocalizedString("Yeah, sounds good", comment: "")
        viewModel.cancelButtonTitle = NSLocalizedString("Maybe later", comment: "")
        viewModel.logo = nil
        self.permission = viewModel
    }
    
    override func permissionsAccessViewDidRequireAccessPermission(view: PermissionsAccessView) {
        
        let status = PermissionRequestLocation.sharedInstance.currentStatus
        
        switch status {
            
        case .Unknown:
            
            PermissionRequestLocation.sharedInstance.requestPermission(inViewController: self, completion: { (outcome, userInfo) in
                
                self.pushToNextViewController()
            })
            
        case  .SystemPromptDenied:
            
            let title = NSLocalizedString("Open Settings", comment: "")
            let message = NSLocalizedString("Please configure your location preferences in Settings.", comment: "")
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: { (action) in
                
                self.pushToNextViewController()
            })
            
            let okAction = UIAlertAction(title: NSLocalizedString("Open Settings", comment: ""), style: .Default, handler: { (action) in
                
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        default:
            
            self.pushToNextViewController()
        }
    }
    
    override func permissionsAccessViewDidIgnoreAccessPermission(view: PermissionsAccessView) {
        
        // Before calling super's implementation we need to set the DidNotAsk value
        // in defaults.
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: PermissionRequestUserDefaultsLocationPreviouslyAskedKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        super.permissionsAccessViewDidIgnoreAccessPermission(view)

    }
}
