//
//  OnboardingContentViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 21/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import UIColor_LOCExtensions

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var titleText: String?
    var contentText: String?
    var onboardingImages = [UIImage]()
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var onboardingImageVIew: UIImageView!
    
    @IBOutlet weak var topContentViewConstraint: NSLayoutConstraint!
    init(title: String?, message: String?, onboardingImages: [UIImage]?) {
        super.init(nibName: "OnboardingContentViewController", bundle: nil)
        
        self.titleText = title
        self.contentText = message
        
        if let onboardingImages = onboardingImages {
            
            self.onboardingImages = onboardingImages
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
    }
    
    func setupAppearance() {
        
        topContentViewConstraint.constant =  UIScreen.mainScreen().bounds.height < 568 ? 10 : 50
        self.contentImageView.animationDuration = Double(self.onboardingImages.count) * 1.5
        self.contentImageView.animationRepeatCount = 0
        self.contentImageView.animationImages = self.onboardingImages
        
        self.contentImageView.startAnimating()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        let titleParagraphStyle = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForHeader)
        
        let contentParagraphStyle = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForText)
        
        if let titleText = self.titleText {
            let attrString = NSMutableAttributedString(string: titleText)
            attrString.addAttribute(NSParagraphStyleAttributeName, value:titleParagraphStyle, range:NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.yamoTextDarkGray(), range:NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value:UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 23), range:NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSKernAttributeName, value:NSNumber.kernValueWithStyle(.Regular, fontSize: 23), range:NSMakeRange(0, attrString.length))
            self.titleLabel.attributedText=attrString
        }
        
        if let contentText = self.contentText {
            let attrString = NSMutableAttributedString(string: contentText)
            attrString.addAttribute(NSParagraphStyleAttributeName, value:contentParagraphStyle, range:NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.yamoGray(), range:NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value:UIFont.preferredFontForStyle(.GraphikRegular, size: 17), range:NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSKernAttributeName, value:NSNumber.kernValueWithStyle(.Regular, fontSize: 17), range:NSMakeRange(0, attrString.length))
            self.contentLabel.attributedText = attrString
        }
    }
}
