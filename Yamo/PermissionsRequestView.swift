//
//  PermissionsAccessView.swift
//  Yamo
//
//  Created by Mo Moosa on 19/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCPermissions_Swift

class PermissionsRequestView: PermissionsAccessView {

    @IBOutlet weak var privateAccountLabel: UILabel!
    
    @IBOutlet weak var privateAccountSwitch: UISwitch!
    
    var isPrivacyView: Bool = false {
        didSet {
            self.privateAccountLabel.hidden = !isPrivacyView
            self.privateAccountSwitch.hidden = !isPrivacyView
        }
    }
    
    override var permissionViewModel: PermissionRequestViewModel? {
        
        didSet {
            
            super.permissionViewModel = permissionViewModel
            
            guard let permissionViewModel = self.permissionViewModel else {
                return
            }
            
            if let title = permissionViewModel.title {
                let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 23),
                                  NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 23),
                                  NSForegroundColorAttributeName: UIColor.yamoBlack()]
                let attributedMessage = NSAttributedString(string: title, attributes: attributes)
                self.titleLabel.attributedText = attributedMessage
            }
            
            if let message = permissionViewModel.message {
                let paragraphStyle = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForText)
                let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 17),
                                  NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 17),
                                  NSForegroundColorAttributeName: UIColor.yamoDarkGray(),
                                  NSParagraphStyleAttributeName: paragraphStyle]
                let attributedMessage = NSAttributedString(string: message, attributes: attributes)
                self.messageLabel.attributedText = attributedMessage
            }
            
            if let okButtonTitle = permissionViewModel.okButtonTitle {
                let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14),
                                  NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14),
                                  NSForegroundColorAttributeName: UIColor.whiteColor()]
                let attributedCancelTitle = NSAttributedString(string: okButtonTitle, attributes: attributes)
                self.okButton.setAttributedTitle(attributedCancelTitle, forState: .Normal)
            }
            
            if let cancelButtonTitle = permissionViewModel.cancelButtonTitle {
                let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                                  NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 12),
                                  NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 12),
                                  NSForegroundColorAttributeName: UIColor.yamoDarkGray()]
                let attributedCancelTitle = NSAttributedString(string: cancelButtonTitle, attributes: attributes)
                self.cancelButton.setAttributedTitle(attributedCancelTitle, forState: .Normal)
            }
        }
    }
}
