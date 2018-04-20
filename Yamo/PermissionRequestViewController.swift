//
//  PermissionRequestViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 19/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCPermissions_Swift

class PermissionRequestViewController: UIViewController, PermissionsAccessViewDelegate {
    
    weak var onboardingDelegate: LaunchNavigationViewControllerDelegate?
    let  activeImage = "Buttonyellowactive"
    let  inactiveImage = "Buttonyellowdisabled"
    var permissionRequestView: PermissionsRequestView?
    var permission: PermissionRequestViewModel? {
        
        get {
            if let permissionRequestView = self.permissionRequestView {
                
                return permissionRequestView.permissionViewModel
            }
            
            return nil
        }
        set {
            
            if let permissionRequestView = self.permissionRequestView {
                
                permissionRequestView.permissionViewModel = newValue
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.permissionRequestView = UINib(nibName: "PermissionsRequestView",
            bundle: NSBundle.mainBundle()).instantiateWithOwner(nil, options: nil)[0] as? PermissionsRequestView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.permissionRequestView!.okButton.setBackgroundImage(UIImage.init(named: inactiveImage), forState: UIControlState.Selected)
        self.permissionRequestView!.okButton.setBackgroundImage(UIImage.init(named: inactiveImage), forState: UIControlState.Highlighted)
        self.permissionRequestView!.okButton.setBackgroundImage(UIImage.init(named: activeImage), forState: UIControlState.Normal)
        
        guard let permissionRequestView = self.permissionRequestView else {
            
            print("Error instantiating PermissionsRequestView in PermissionRequestViewController")
            return
        }
        
        permissionRequestView.delegate = self
        permissionRequestView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(permissionRequestView)
        
        self.view.addConstraints(
            
            [NSLayoutConstraint(
                item: permissionRequestView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0),
                
                NSLayoutConstraint(
                    item: permissionRequestView,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: self.view,
                    attribute: .Top,
                    multiplier: 1.0,
                    constant: 0.0),
                
                NSLayoutConstraint(
                    item: permissionRequestView,
                    attribute: .Trailing,
                    relatedBy: .Equal,
                    toItem: self.view,
                    attribute: .Trailing,
                    multiplier: 1.0,
                    constant: 0.0),
                
                NSLayoutConstraint(
                    item: permissionRequestView,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: self.view,
                    attribute: .Bottom,
                    multiplier: 1.0,
                    constant: 0.0)
            ])
        
        self.permissionRequestView?.permissionViewModel = self.permission
    }
    
    func pushToNextViewController() {
        
        if let delegate = self.onboardingDelegate {
            delegate.viewControllerDidFinish(self)
        } else {
            print("No onboarding delegate, use coordinator")
            if let nextViewController = SubscriptionFlowCoordinator().nextViewForCurrentViewController(self) {
                self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
    // MARK: - PermissionAccessViewDelegate
    
    func permissionsAccessViewDidRequireAccessPermission(view: PermissionsAccessView) {
        
    }
    
    func permissionsAccessViewDidIgnoreAccessPermission(view: PermissionsAccessView) {
        self.pushToNextViewController()
    }
    
}
