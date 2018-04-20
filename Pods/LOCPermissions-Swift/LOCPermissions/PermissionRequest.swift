//
//  PermissionRequest.swift
//  PermissionsManagerSwift
//
//  Created by Hungju Lu on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

internal typealias UIAlertActionHandlerBlock = ((UIAlertAction) -> Void)

public class PermissionRequest: NSObject, PermissionsAccessViewDelegate {
    
    // MARK: - Public accessors / methods
    
    /// The current permission state
    public var currentStatus: PermissionRequestStatus {
        assert(false, "Subclass should implement this computed variable and not call super.")
        return .Unknown
    }
    
    /**
     Request permission directly by prompting system dialogue
     
     - parameter viewController: the optional view controller to present the error dialogue when permission denied previously, to redirect the user to Settings app
     - parameter completion:     the block with the permission reqest outcome
     */
    public func requestPermission(inViewController viewController: UIViewController?, completion: PermissionRequestCompletionBlock?) {
        self.presentingViewController = viewController
        self.completionBlock = completion
        
        if self.currentStatus == .SystemPromptDenied {
            self.presentErrorDialogue()
        } else {
            self.requestPermission(completion)
        }
    }
    
    /**
     Request permission with prompting an UIAlertController before the system dialogue
     
     - parameter viewController: the required view controller to present the alert and the error dialogue when permission denied previously
     - parameter completion:     the block with the permission request outcome
     */
    public final func requestPermission(promptPreAlertInViewController viewController: UIViewController, completion: PermissionRequestCompletionBlock?) {
        self.presentingViewController = viewController
        self.completionBlock = completion
        
        var appName = "We"
        if let displayName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as? String {
            appName = "\"\(displayName)\""
        } else if let bundleName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String {
            appName = "\"\(bundleName)\""
        }
        let permissionType = StringForPermissionType(self.permissionType())
        let title = "\(appName) Would Like to Access Your \(permissionType)"
        let message = "Please tap \"Allow\" in the next alert."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (_) -> Void in
            self.requestPermission(inViewController: viewController, completion: completion)
        }))
        alertController.addAction(UIAlertAction(title: "Decide Later", style: .Cancel, handler: { (_) -> Void in
            self.completionBlock?(outcome: .DidNotAsk, userInfo: nil)
        }))
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
     /**
     Request permission with presenting a modal view controller with the PermissionsAccessView inside before the system dialougue,
     you can use `-defaultAccessView` to instantiate the default view object or create a nib file and subclass `PermissionsAccessView`
     for customisation.
     
     - parameter promptViewController: the PermissionsAccessView to be presented in the modal view controller
     - parameter viewController:       the required view controller to present the PermissionsAccessViewController and the error dialogue when permission denied previously
     - parameter completion:           the block with the permission request outcome
     */
    public final func requestPermission(promptPresentedView view: PermissionsAccessView , inViewController viewController: UIViewController, completion: PermissionRequestCompletionBlock?) {
        let permissionAccessViewController = UIViewController()
        permissionAccessViewController.view = view
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.delegate = self
        
        self.permissionAccessViewController = permissionAccessViewController
        self.completionBlock = completion
        
        viewController.presentViewController(permissionAccessViewController, animated: true, completion: nil)
    }
    
    /**
     Instantiate the default permission access view controller
     
     - returns: an instantiation of the default PermissionsAccessViewController from the xib file attached with this component
     */
    public class func defaultAccessView() -> PermissionsAccessView {
        // the cocoapods will put the xib file in the Resources.bundle file
        let frameworkBundle = NSBundle(forClass: PermissionsAccessView.self)
        guard let resourceBundlePath = frameworkBundle.pathForResource("LOCPermissionsResources", ofType: "bundle") else {
            return PermissionsAccessView.loadFromNibNamed(PermissionsAccessViewDefaultNibName)
        }
        let bundle = NSBundle(path: resourceBundlePath)
        return PermissionsAccessView.loadFromNibNamed(PermissionsAccessViewDefaultNibName, bundle: bundle)
    }
    
    // MARK: - Internal accessors / methods
    
    internal var completionBlock: PermissionRequestCompletionBlock?
    internal var presentingViewController: UIViewController?
    private var permissionAccessViewController: UIViewController?
    
    internal func permissionType() -> PermissionType {
        assert(false, "Subclass should implement this method and not call super.")
        return .Unknown
    }
    
    /**
     Request permission directly by prompting system dialogue
     
     - parameter completion:     the block with the permission reqest outcome
     */
    internal func requestPermission(completion: PermissionRequestCompletionBlock?) {
        assert(false, "Subclass should implement this method and not call super.")
    }
    
    /**
     Presenting the error dialogue when the permission previously rejected by the user,
     and provides an option to redirect the user to the Settings app.
     */
    internal func presentErrorDialogue() {
        var presentingViewController: UIViewController
        if let vc = self.presentingViewController {
            presentingViewController = vc
        } else if let vc = self.permissionAccessViewController {
            presentingViewController = vc
        } else {
            return
        }
        
        let permissionType = StringForPermissionType(self.permissionType())
        let title = "Access Denied"
        let message = "Please enable \(permissionType) permission in the Settings app."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (_) -> Void in
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Later", style: .Cancel, handler: { (_) -> Void in
            if let controller = self.permissionAccessViewController {
                if let _ = controller.navigationController {
                    self.completionBlock?(outcome: .DidNotAsk, userInfo: nil)
                } else {
                    controller.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                self.completionBlock?(outcome: .Unknown, userInfo: nil)
            }
        }))
        
        presentingViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - PermissionsAccessViewDelegate
    
    public func permissionsAccessViewDidRequireAccessPermission(view: PermissionsAccessView) {
        self.requestPermission(inViewController: self.presentingViewController) { (outcome, userInfo) -> Void in
            guard let permissionAccessViewController = self.permissionAccessViewController else {
                self.completionBlock?(outcome: outcome, userInfo: userInfo)
                return
            }
            
            permissionAccessViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.completionBlock?(outcome: outcome, userInfo: userInfo)
            })
        }
    }
    
    public func permissionsAccessViewDidIgnoreAccessPermission(controller: PermissionsAccessView) {
        guard let permissionAccessViewController = self.permissionAccessViewController else {
            self.completionBlock?(outcome: .DidNotAsk, userInfo: nil)
            return
        }
        
        permissionAccessViewController.dismissViewControllerAnimated(true) { () -> Void in
            self.completionBlock?(outcome: .DidNotAsk, userInfo: nil)
        }
    }
}
