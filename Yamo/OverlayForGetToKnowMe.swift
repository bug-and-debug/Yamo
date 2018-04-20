//
//  OverlayForGetToKnowMe.swift
//  Yamo
//
//  Created by Vlad Buhaescu on 24/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

class OverlayForGetToKnowMe: UIView {
    
    private  var titleLabel = UILabel()
    private  let mainDescriptionLabel = UILabel()
    let dismissButtonForOverlay = UIButton(type: UIButtonType.System)
    var getToKnowMeButton = UIButton(type: UIButtonType.System)
    
    private  let crossDismissImage = "Iconwhite menuX"
    private  let mainTitleString = "Want the most accurate suggestions?"
    private  let mainDescription = "Rate more art in Get To Know Me to improve your suggested exhibitions."
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.yamoGoldenBrownWithTransparency()
        
    }
    
    func addTheElements() {
        self.addDismissButton()
        self.addGetToKnowMeButton()
        self.addTitleLabel()
        self.addMainDescriptionLabel()
        
    }
    
    private func addDismissButton()  {
        
        dismissButtonForOverlay.translatesAutoresizingMaskIntoConstraints = false
        dismissButtonForOverlay.setBackgroundImage(UIImage.init(named: crossDismissImage), forState: UIControlState.Normal)
        
        self.addSubview(dismissButtonForOverlay)
        self.addConstraints([
            NSLayoutConstraint.init(item:dismissButtonForOverlay
                , attribute: NSLayoutAttribute.Top
                , relatedBy: NSLayoutRelation.Equal
                , toItem: self
                , attribute:NSLayoutAttribute.Top
                , multiplier: 1.0
                , constant: 10
            ),
            NSLayoutConstraint.init(item: self
                , attribute: NSLayoutAttribute.Trailing
                , relatedBy: NSLayoutRelation.Equal
                , toItem: dismissButtonForOverlay
                , attribute:NSLayoutAttribute.Trailing
                , multiplier: 1.0
                , constant: 10
            ),
            NSLayoutConstraint.init(item:dismissButtonForOverlay
                , attribute: NSLayoutAttribute.Height
                , relatedBy: NSLayoutRelation.Equal
                , toItem: nil
                , attribute:NSLayoutAttribute.NotAnAttribute
                , multiplier: 1.0
                , constant: 30
            ),
            NSLayoutConstraint.init(item:dismissButtonForOverlay
                , attribute: NSLayoutAttribute.Width
                , relatedBy: NSLayoutRelation.Equal
                , toItem: nil
                , attribute:NSLayoutAttribute.NotAnAttribute
                , multiplier: 1.0
                , constant: 30
            )])
        
    }
    
    
    private func addTitleLabel() {
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 19.0),
                          NSForegroundColorAttributeName: UIColor.whiteColor(),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 19.0)]
        let attributedString = NSAttributedString(string: mainTitleString, attributes: attributes)
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        self.addConstraints([
            NSLayoutConstraint.init(item:titleLabel
                , attribute: NSLayoutAttribute.Top
                , relatedBy: NSLayoutRelation.Equal
                , toItem: self
                , attribute:NSLayoutAttribute.Top
                , multiplier: 1.0
                , constant: 10
            ),
            NSLayoutConstraint.init(item: dismissButtonForOverlay
                , attribute: NSLayoutAttribute.Leading
                , relatedBy: NSLayoutRelation.Equal
                , toItem: titleLabel
                , attribute:NSLayoutAttribute.Trailing
                , multiplier: 1.0
                , constant: 10
            ),
            NSLayoutConstraint.init(item: titleLabel
                , attribute: NSLayoutAttribute.Leading
                , relatedBy: NSLayoutRelation.Equal
                , toItem: self
                , attribute:NSLayoutAttribute.Leading
                , multiplier: 1.0
                , constant: 30
            ),
            NSLayoutConstraint.init(item:titleLabel
                , attribute: NSLayoutAttribute.Height
                , relatedBy: NSLayoutRelation.Equal
                , toItem: nil
                , attribute:NSLayoutAttribute.NotAnAttribute
                , multiplier: 1.0
                , constant: 50
            )])
    }
    
    private func addMainDescriptionLabel() {
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14),
                          NSForegroundColorAttributeName: UIColor.whiteColor(),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14)]
        let attributedString = NSAttributedString(string: mainDescription, attributes: attributes)
        
        mainDescriptionLabel.attributedText = attributedString
        mainDescriptionLabel.textAlignment = NSTextAlignment.Center
        mainDescriptionLabel.numberOfLines = 0
        mainDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mainDescriptionLabel)
        self.addConstraints([
            NSLayoutConstraint.init(item:titleLabel
                , attribute: NSLayoutAttribute.Bottom
                , relatedBy: NSLayoutRelation.Equal
                , toItem: mainDescriptionLabel
                , attribute:NSLayoutAttribute.Top
                , multiplier: 1.0
                , constant: -20
            ),
            NSLayoutConstraint.init(item: self
                , attribute: NSLayoutAttribute.Trailing
                , relatedBy: NSLayoutRelation.Equal
                , toItem: mainDescriptionLabel
                , attribute:NSLayoutAttribute.Trailing
                , multiplier: 1.0
                , constant: 10
            ),
            NSLayoutConstraint.init(item:mainDescriptionLabel
                , attribute: NSLayoutAttribute.Leading
                , relatedBy: NSLayoutRelation.Equal
                , toItem: self
                , attribute:NSLayoutAttribute.Leading
                , multiplier: 1.0
                , constant: 30
            ),
            NSLayoutConstraint.init(item: getToKnowMeButton
                , attribute: NSLayoutAttribute.Top
                , relatedBy: NSLayoutRelation.Equal
                , toItem: mainDescriptionLabel
                , attribute:NSLayoutAttribute.Bottom
                , multiplier: 1.0
                , constant: 30
            )
            ])
    }
    
    private func addGetToKnowMeButton() {
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        
        let richText = NSMutableAttributedString(string: "Get to know me",
                                                 attributes: [ NSParagraphStyleAttributeName: style ,
                                                    NSFontAttributeName : UIFont.preferredFontForStyle(.GraphikMedium, size: 14),
                                                    NSKernAttributeName : NSNumber.kernValueWithStyle(.Regular, fontSize: 14),
                                                    NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        getToKnowMeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        getToKnowMeButton.setAttributedTitle(richText, forState: UIControlState.Normal)
        getToKnowMeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(getToKnowMeButton)
        self.addConstraints([
            NSLayoutConstraint.init(item:self
                , attribute: NSLayoutAttribute.Bottom
                , relatedBy: NSLayoutRelation.Equal
                , toItem:getToKnowMeButton
                , attribute:NSLayoutAttribute.Bottom
                , multiplier: 1.0
                , constant: 20
            ),
            NSLayoutConstraint.init(item:getToKnowMeButton
                , attribute: NSLayoutAttribute.CenterX
                , relatedBy: NSLayoutRelation.Equal
                , toItem: self
                , attribute:NSLayoutAttribute.CenterX
                , multiplier: 1.0
                , constant: 0
            )
            ,
            NSLayoutConstraint.init(item:getToKnowMeButton
                , attribute: NSLayoutAttribute.Height
                , relatedBy: NSLayoutRelation.Equal
                , toItem: nil
                , attribute:NSLayoutAttribute.NotAnAttribute
                , multiplier: 1.0
                , constant: 30
            )
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
