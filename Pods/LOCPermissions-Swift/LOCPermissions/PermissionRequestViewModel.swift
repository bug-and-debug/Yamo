//
//  PermissionRequestViewModel.swift
//  LOCPermissions
//
//  Created by Mo Moosa on 20/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

public class PermissionRequestViewModel: NSObject {

    public var permissionRequest: PermissionRequest?
    public var title: String?
    public var message: String?
    public var prompt: String?
    public var okButtonTitle: String?
    public var cancelButtonTitle: String?
    public var logo: UIImage?
    
    public init(permissionRequest: PermissionRequest) {
        
        super.init()
        self.permissionRequest = permissionRequest
    }
}
