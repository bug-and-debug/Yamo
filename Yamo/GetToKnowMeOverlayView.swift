//
//  OverlayViewGTKM.swift
//  Yamo
//
//  Created by Vlad Buhaescu on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class GetToKnowMeOverlayView: UIView {
    
    private let buttonImageName = "Buttonyellowdisabled"

    private let titleLabel = UILabel()
    private let infoTextView = UITextView()
    
    let startButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.yamoGoldenBrownWithTransparency()
        
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 23),
                          NSForegroundColorAttributeName: UIColor.whiteColor(),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 23)]
        let attributedString = NSAttributedString(string: NSLocalizedString("Get to know me", comment: ""), attributes: titleAttributes)
        self.titleLabel.attributedText = attributedString
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.addConstraintsForTitle()
        
        let textAttributes = [ NSFontAttributeName : UIFont.preferredFontForStyle(.GraphikRegular, size: 14),
                               NSForegroundColorAttributeName : UIColor.whiteColor(),
                               NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14) ]
        let attributedTitle = NSAttributedString(string: NSLocalizedString("Start", comment: ""), attributes: textAttributes)
        
        self.startButton.setAttributedTitle(attributedTitle, forState: .Normal)
        self.startButton.setBackgroundImage(UIImage.init(named: buttonImageName), forState: .Normal)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(startButton)
        self.addConstraintsForStartButton()
        
        let attrString = NSString(string:"You must answer from at least 5 cards to proceed. Your answers will help us suggest the most relevant artist, galleries and exhibitions! Rate the image over five stars." )
        
        let style = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForText)
        let attributes = [NSParagraphStyleAttributeName : style,
                          NSFontAttributeName : UIFont.preferredFontForStyle(.GraphikRegular, size: 17.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 17)]
        self.infoTextView.attributedText = NSAttributedString(string: attrString as String, attributes:attributes)
        self.infoTextView.backgroundColor = UIColor.clearColor()
        self.infoTextView.textColor = UIColor.whiteColor()
        self.infoTextView.userInteractionEnabled = false
        self.infoTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(infoTextView)
        self.addConstraintsForTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addConstraintsForTitle()  {
        
        self.addConstraints([
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 16.0),
            NSLayoutConstraint(
                item: self,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: titleLabel,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 16.0),
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Top,
                multiplier: 1.0,
                constant: 50.0),
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 24.0)
            ])

    }
    
    private func addConstraintsForTextView()  {
        self.addConstraints([
            NSLayoutConstraint(
                item: infoTextView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 12.0),
            NSLayoutConstraint(
                item: self,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: infoTextView,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 15.0),
            NSLayoutConstraint(
                item: titleLabel,
                attribute:  NSLayoutAttribute.Bottom,
                relatedBy: .Equal,
                toItem: infoTextView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 8.0)
            ,
            NSLayoutConstraint(
                item: startButton,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: infoTextView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 8.0)
            ])
    }
    
    private func addConstraintsForStartButton()  {
        self.addConstraints([
            NSLayoutConstraint(
                item: startButton,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 15.0),
            NSLayoutConstraint(
                item: self,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: startButton,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 15.0),
            NSLayoutConstraint(
                item: startButton,
                attribute:  NSLayoutAttribute.Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 48.0)
            ,
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: .Equal,
                toItem: startButton,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 41.0)
            ])
    }
}
