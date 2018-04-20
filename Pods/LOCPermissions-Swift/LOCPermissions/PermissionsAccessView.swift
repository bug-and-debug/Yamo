//
//  PermissionAccessView.swift
//  LOCPermissions
//
//  Created by Hungju Lu on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

let PermissionsAccessViewDefaultNibName = "PermissionsAccessView"

@objc public protocol PermissionsAccessViewDelegate: class {
    func permissionsAccessViewDidRequireAccessPermission(view: PermissionsAccessView)
    func permissionsAccessViewDidIgnoreAccessPermission(view: PermissionsAccessView)
}

public class PermissionsAccessView: UIView {
    
    public weak var delegate:PermissionsAccessViewDelegate?
    public var permissionViewModel: PermissionRequestViewModel? {
        
        didSet {
            
            guard let permissionViewModel = self.permissionViewModel else {
        
                return
            }
            
            self.titleLabel.text = permissionViewModel.title
            self.messageLabel.text = permissionViewModel.message
            self.okButton.setTitle(permissionViewModel.okButtonTitle, forState: .Normal)
            self.cancelButton.setTitle(permissionViewModel.cancelButtonTitle, forState: .Normal)
            self.logoImageView.image = permissionViewModel.logo
        }
    }
    
    @IBOutlet weak public var logoImageView: UIImageView!
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var messageLabel: UILabel!
    @IBOutlet weak public var okButton: UIButton!
    @IBOutlet weak public var cancelButton: UIButton!
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> PermissionsAccessView {
        if let view = UINib(nibName: nibNamed, bundle: bundle).instantiateWithOwner(nil, options: nil)[0] as? PermissionsAccessView {
            return view
        } else {
            return PermissionsAccessView() // ???: shouldn't be an error here
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    private func configureView() {
        if let okButton = self.okButton {
            okButton.layer.cornerRadius = 3.0
        }
    }
    
    @IBAction func handleOKButtonTap(sender: UIButton!) {
        self.delegate?.permissionsAccessViewDidRequireAccessPermission(self)
    }
    
    @IBAction func handleIgnoreButtonTap(sender: UIButton!) {
        self.delegate?.permissionsAccessViewDidIgnoreAccessPermission(self)
    }
}
