//
//  EditProfileHeaderView.swift
//  Yamo
//
//  Created by Mo Moosa on 04/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class EditProfileHeaderView: UIView {

    let profileImageView = UIImageView()
    let profilePromptLabel = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(self.profileImageView)

        self.profileImageView.clipsToBounds = true
        self.profileImageView.backgroundColor = UIColor.yamoDarkGray()
        self.addSubview(self.profilePromptLabel)
        let padding: CGFloat = 8.0
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profilePromptLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.addConstraints([
            
            /// Prompt Image View Leading, Top & Bottom
            
            NSLayoutConstraint(
                item: self.profileImageView,
                attribute: .Leading, 
                relatedBy: .Equal, 
                toItem: self,
                attribute: .Leading, 
                multiplier: 1.0, 
                constant: 20.0),
            
            NSLayoutConstraint(
                item: self,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self.profileImageView,
                attribute: .CenterY,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.profileImageView,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: 55.0),
            
            NSLayoutConstraint(
                item: self.profileImageView,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: 55.0),
            
            /// Prompt Image View Trailing to Prompt Label Leading
            
            NSLayoutConstraint(
                item: self.profilePromptLabel,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.profileImageView,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 20.0),
            
            /// Prompt Label Trailing, Top & Bottom

            NSLayoutConstraint(
                item: self,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.profilePromptLabel,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 20.0),
            
            NSLayoutConstraint(
                item: self.profilePromptLabel,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Top,
                multiplier: 1.0,
                constant: padding),
            
            NSLayoutConstraint(
                item: self,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.profilePromptLabel,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: padding)
            ]
        )
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height * 0.5
    }
}
