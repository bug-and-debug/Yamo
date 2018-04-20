//
//  PrivacyPermissionRequestViewController.swift
//  Yamo
//
//  Created by Hungju Lu on 03/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCPermissions_Swift

class PrivacyPermissionRequestViewController: PermissionRequestViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        if let permissionRequestView = self.permissionRequestView {
            permissionRequestView.isPrivacyView = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let privacyRequest = PrivacyPermissionRequest()
        
        let viewModel = PermissionRequestViewModel(permissionRequest: privacyRequest)
        
        viewModel.title = NSLocalizedString("Privacy", comment: "")
        viewModel.message = NSLocalizedString("By default your Yamo profile is public, meaning that other users can see the exhibitions, places and routes you're interested in. If you would like to only have people who follow you see this information please set your profile to private.", comment: "")
        viewModel.okButtonTitle = NSLocalizedString("Next", comment: "")
        viewModel.cancelButtonTitle = NSLocalizedString("", comment: "")
        viewModel.logo = nil
        
        self.permission = viewModel
    }
    
    override func permissionsAccessViewDidRequireAccessPermission(view: PermissionsAccessView) {
        guard let permissionRequestView = self.permissionRequestView else {
            self.pushToNextViewController()
            return
        }
        
        let visible = !permissionRequestView.privateAccountSwitch.on
        let parameters = ["visible": visible,
                          "signUpCompleted" : true]
        
        APIClient.sharedInstance().editUserProfileWithEditedObject(parameters, successBlock: { (element) in
            
            self.pushToNextViewController()

            }) { (error, statusCode, context) in
                
                UIAlertController.showAlert(inViewController: self,
                                            withTitle: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Couldn't change the privacy setting at this moment, you can set it again in edit profile page.", comment: ""),
                                            cancelButtonTitle: "Ok",
                                            destructiveButtonTitle: nil,
                                            otherButtonTitles: nil,
                                            tapBlock: { (_, _, _) in
                                                self.pushToNextViewController()
                })
        }
    }
    
    override func permissionsAccessViewDidIgnoreAccessPermission(view: PermissionsAccessView) {
        
        self.pushToNextViewController()
    }
}
