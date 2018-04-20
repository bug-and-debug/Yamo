//
//  UIButton-LOCUtilities.swift
//  UIButton-LOCExtensions
//
//  Created by Hungju Lu on 22/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import UIImage_LOCExtensions

public extension UIButton {
    
    public func setHighlightedTitle(
        highlightedTitle: String?,
        highlightedTitleColour: UIColor?,
        highlightedImageName: String?,
        highlightedBackgroundImageName: String?) {
            if let highlightedTitle = highlightedTitle {
                self.setTitle(highlightedTitle, forState: .Highlighted)
            }
            
            if let highlightedTitleColour = highlightedTitleColour {
                self.setTitleColor(highlightedTitleColour, forState: .Highlighted)
            }
            
            if let highlightedImageName = highlightedImageName {
                self.setImage(UIImage(named: highlightedImageName), forState: .Highlighted)
            }
            
            if let highlightedBackgroundImageName = highlightedBackgroundImageName {
                self.setBackgroundImage(UIImage(named: highlightedBackgroundImageName), forState: .Highlighted)
            }
    }
    
    public func setHighlightedAttributedTitle(
        highlightedAttributedTitle: NSAttributedString?,
        highlightedImageName: String?,
        highlightedBackgroundImageName: String?) {
            if let highlightedAttributedTitle = highlightedAttributedTitle {
                self.setAttributedTitle(highlightedAttributedTitle, forState: .Highlighted)
            }
            
            if let highlightedImageName = highlightedImageName {
                self.setImage(UIImage(named: highlightedImageName), forState: .Highlighted)
            }
            
            if let highlightedBackgroundImageName = highlightedBackgroundImageName {
                self.setBackgroundImage(UIImage(named: highlightedBackgroundImageName), forState: .Highlighted)
            }
    }
    
    public func setDisabledTitle(
        disabledTitle: String?,
        disabledTitleColour: UIColor?,
        disabledImageName: String?,
        disabledBackgroundImageName: String?) {
            if let disabledTitle = disabledTitle {
                self.setTitle(disabledTitle, forState: .Disabled)
            }
            
            if let disabledTitleColour = disabledTitleColour {
                self.setTitleColor(disabledTitleColour, forState: .Disabled)
            }
            
            if let disabledImageName = disabledImageName {
                self.setImage(UIImage(named: disabledImageName), forState: .Disabled)
            }
            
            if let disabledBackgroundImageName = disabledBackgroundImageName {
                self.setBackgroundImage(UIImage(named: disabledBackgroundImageName), forState: .Disabled)
            }
    }
    
    public func setDisabledAttributedTitle(
        disabledAttributedTitle: NSAttributedString?,
        disabledImageName: String?,
        disabledBackgroundImageName: String?) {
            if let disabledAttributedTitle = disabledAttributedTitle {
                self.setAttributedTitle(disabledAttributedTitle, forState: .Disabled)
            }
            
            if let disabledImageName = disabledImageName {
                self.setImage(UIImage(named: disabledImageName), forState: .Disabled)
            }
            
            if let disabledBackgroundImageName = disabledBackgroundImageName {
                self.setBackgroundImage(UIImage(named: disabledBackgroundImageName), forState: .Disabled)
            }
    }
    
    public func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        self.setBackgroundImage(UIImage(color: color), forState: state)
    }
    
    public func centerVertically() {
        
        let defaultPadding: CGFloat = 6.0
        self.centerVerticallyWithPadding(defaultPadding)
    }
    
    public func centerVerticallyWithPadding(padding: CGFloat) {
        
        let imageSize = self.imageView?.frame.size;
        let titleSize = self.titleLabel?.frame.size;
        
        if let validImageSize = imageSize, let validTitleSize = titleSize {
            
            let totalHeight = validImageSize.height + validTitleSize.height + padding
            self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - validImageSize.height), 0.0, 0.0, -validTitleSize.width)
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -validImageSize.width, -(totalHeight - validTitleSize.height), 0)
        }
    }
    
    public func centerButtonWithImage() {
        
        let imageSize = self.imageView?.frame.size;
        
        if let validImageSize = imageSize {
            
            let imageWidth = validImageSize.width
            let padding: CGFloat = 10.0
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0.0, -(imageWidth + padding), 0.0, 0.0)
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, padding, 0.0, 0.0)
        }
    }
}