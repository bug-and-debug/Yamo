//
//  UIButton-LOCCreation.swift
//  UIButton-LOCExtensions
//
//  Created by Hungju Lu on 22/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

public extension UIButton {
    
    public class func button(
        frame frame: CGRect,
        isExclusive: Bool,
        showsTouchOnHighlight: Bool,
        font: UIFont,
        normalTitle: String?,
        normalTitleColour: UIColor?,
        selectedTitle: String?,
        selectedTitleColour: UIColor?,
        normalImageName: String?,
        selectedImageName: String?,
        normalBackgroundImageName: String?,
        selectedBackgroundImageName: String?,
        addToView parentView: UIView) -> UIButton {
            let button = UIButton(frame: frame)
            
            button.exclusiveTouch = isExclusive
            button.showsTouchWhenHighlighted = showsTouchOnHighlight
            button.titleLabel?.font = font
            
            if let normalTitle = normalTitle {
               button.setTitle(normalTitle, forState: .Normal)
            }
            
            if let normalTitleColour = normalTitleColour {
                button.setTitleColor(normalTitleColour, forState: .Normal)
            }
            
            if let selectedTitle = selectedTitle {
                button.setTitle(selectedTitle, forState: .Selected)
            }
            
            if let selectedTitleColour = selectedTitleColour {
                button.setTitleColor(selectedTitleColour, forState: .Selected)
            }
            
            if let normalImageName = normalImageName {
                button.setImage(UIImage(named: normalImageName), forState: .Normal)
            }
            
            if let selectedImageName = selectedImageName {
                button.setImage(UIImage(named: selectedImageName), forState: .Selected)
            }
            
            if let normalBackgroundImageName = normalBackgroundImageName {
                button.setBackgroundImage(UIImage(named: normalBackgroundImageName), forState: .Normal)
            }
            
            if let selectedBackgroundImageName = selectedBackgroundImageName {
                button.setBackgroundImage(UIImage(named: selectedBackgroundImageName), forState: .Selected)
            }
            
            parentView.addSubview(button)
            return button
    }
    
    public class func button(
        frame frame: CGRect,
        isExclusive: Bool,
        showsTouchOnHighlight: Bool,
        normalAttributedTitle: NSAttributedString?,
        selectedAttributedTitle: NSAttributedString?,
        normalImageName: String?,
        selectedImageName: String?,
        normalBackgroundImageName: String?,
        selectedBackgroundImageName: String?,
        addToView parentView: UIView) -> UIButton {
            let button = UIButton(frame: frame)
            
            button.exclusiveTouch = isExclusive
            button.showsTouchWhenHighlighted = showsTouchOnHighlight
            
            if let normalAttributedTitle = normalAttributedTitle {
                button.setAttributedTitle(normalAttributedTitle, forState: .Normal)
            }
            
            if let selectedAttributedTitle = selectedAttributedTitle {
                button.setAttributedTitle(selectedAttributedTitle, forState: .Selected)
            }
            
            if let normalImageName = normalImageName {
                button.setImage(UIImage(named: normalImageName), forState: .Normal)
            }
            
            if let selectedImageName = selectedImageName {
                button.setImage(UIImage(named: selectedImageName), forState: .Selected)
            }
            
            if let normalBackgroundImageName = normalBackgroundImageName {
                button.setBackgroundImage(UIImage(named: normalBackgroundImageName), forState: .Normal)
            }
            
            if let selectedBackgroundImageName = selectedBackgroundImageName {
                button.setBackgroundImage(UIImage(named: selectedBackgroundImageName), forState: .Selected)
            }
            
            parentView.addSubview(button)
            return button
    }
    
    public class func blankButton(
        frame frame: CGRect,
        isExclusive: Bool,
        showsTouchOnHighlight: Bool,
        addToView parentView: UIView) -> UIButton {
            let button = UIButton(frame: frame)
            
            button.exclusiveTouch = isExclusive
            button.showsTouchWhenHighlighted = showsTouchOnHighlight
            
            parentView.addSubview(button)
            return button
    }
}