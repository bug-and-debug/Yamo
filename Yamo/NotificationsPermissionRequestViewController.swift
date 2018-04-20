//
//  NotificationsPermissionRequestViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 20/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCPermissions_Swift

class NotificationsPermissionRequestViewController: PermissionRequestViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationRequest = PermissionRequestNotification.sharedInstance
        
        let viewModel = PermissionRequestViewModel(permissionRequest: notificationRequest)
        
        viewModel.title = NSLocalizedString("Notifications", comment: "")
        viewModel.message = NSLocalizedString("We would like to send you notifications about exhibitions near you as well as friends who join Yamo.", comment: "")
        viewModel.okButtonTitle = NSLocalizedString("Yeah, sounds good", comment: "")
        viewModel.cancelButtonTitle = NSLocalizedString("Maybe later", comment: "")
        viewModel.logo = nil
        self.permission = viewModel
    }
    
    override func permissionsAccessViewDidRequireAccessPermission(view: PermissionsAccessView) {
        
        let status = PermissionRequestNotification.sharedInstance.currentStatus
        
        switch status {
            
        case .Unknown:
            
            PermissionRequestNotification.sharedInstance.requestPermission(inViewController: self, completion: { (outcome, userInfo) in
                
                self.pushToNextViewController()
            })
            
        case  .SystemPromptDenied:
            
            let title = NSLocalizedString("Open Settings", comment: "")
            let message = NSLocalizedString("Please configure your notification preferences in Settings.", comment: "")
            
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
}
