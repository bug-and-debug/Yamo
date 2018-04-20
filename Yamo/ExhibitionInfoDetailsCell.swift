//
//  ExhibitionInfoDetailsCell.swift
//  Yamo
//
//  Created by Hungju Lu on 24/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import UIImage_LOCExtensions
import UIView_LOCExtensions


let ExhibitionInfoDetailsCellNibName = "ExhibitionInfoDetailsCell"
let ExhibitionInfoDetailsCellDefaultHeight: CGFloat = 300.0

private let AboutDetailsButtonHeight: CGFloat = 45.0
private let AboutTopMargin: CGFloat = 15.0
private let DetailsLeadingTrailingMargin: CGFloat = 15.0
private let DetailLabelTopMargin: CGFloat = 12.0
private let DetailSeparatorHeight: CGFloat = 1.0
private let DetailSeparatorMargin: CGFloat = 9.0

public enum ExhibitionInfoDetailsSelectionState {
    case Details
    case About
}

class ExhibitionInfoDetailsCell: ExhibitionInfoCell, UITextViewDelegate {
    
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var currentSelectionState: ExhibitionInfoDetailsSelectionState = .Details
    var aboutExpended: Bool = false
    
    private var aboutTextHeight: CGFloat = 160.0
    private var viewConfigured: Bool = false
    private var detailsHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoDimGray()]
        
        let attributedDetailTitle = NSAttributedString(string: NSLocalizedString("Details", comment: ""), attributes: attributes)
        let attributedAboutTitle = NSAttributedString(string: NSLocalizedString("About", comment: ""), attributes: attributes)
        
        self.detailsButton.setAttributedTitle(attributedDetailTitle, forState: .Normal)
        self.aboutButton.setAttributedTitle(attributedAboutTitle, forState: .Normal)
        
        self.detailsButton.setBackgroundImage(UIImage.init(color: UIColor.yamoLightGray()), forState: .Normal)
        self.aboutButton.setBackgroundImage(UIImage.init(color: UIColor.yamoLightGray()), forState: .Normal)
        
        self.detailsButton.setBackgroundImage(UIImage.init(color: UIColor.whiteColor()), forState: .Selected)
        self.aboutButton.setBackgroundImage(UIImage.init(color: UIColor.whiteColor()), forState: .Selected)
        
        let readMoreAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                                  NSForegroundColorAttributeName: UIColor.yamoDarkGray(),
                                  NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                                  NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedReadMore = NSAttributedString(string: NSLocalizedString("Read more", comment: ""), attributes: readMoreAttributes)
        self.readMoreButton.setAttributedTitle(attributedReadMore, forState: .Normal)
        self.readMoreButton.hidden = true
    }
    
    // MARK: - Class method
    
    class func initialSize(state state: ExhibitionInfoDetailsSelectionState, about: String, aboutExpended: Bool, details: [ExhibitionInfoDetailData]) -> CGSize {
        let cellWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let expectedSubviewWidth = cellWidth - (DetailsLeadingTrailingMargin * 2)
        
        switch state {
        case .Details:
            var totalHeight: CGFloat = DetailSeparatorMargin + AboutDetailsButtonHeight
            
            for i in 0..<details.count {
                let detailData = details[i]
                
                if detailData.detailString.characters.count > 0 {
                    let attributedString = self.detailAttributedString(text: detailData.detailString)
                    let height = attributedString.boundingRectWithSize(CGSizeMake(expectedSubviewWidth - 10, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil).height + 10
                    
                    totalHeight += DetailLabelTopMargin + height
                    
                    if i < details.count - 1 {
                        totalHeight += DetailSeparatorHeight + DetailSeparatorMargin
                    } else {
                        totalHeight += DetailSeparatorMargin
                    }
                }
            }
            
            return CGSizeMake(cellWidth, totalHeight)
            
        case .About:
            
            let attributedAboutString = ExhibitionInfoDetailsCell.aboutAttributedString(text: about)
            let aboutTextHeight = attributedAboutString.boundingRectWithSize(CGSizeMake(expectedSubviewWidth, CGFloat.max),
                                                                             options: [.UsesLineFragmentOrigin, .UsesFontLeading, .UsesDeviceMetrics],
                                                                             context: nil).height
            
            // AboutTopMargin is the top margin of the label, 39 is the bottom margin, 45 is the switch button height, and 10 here
            // is a magic number to make the text stand still in the same position
            let aboutTextMargins = AboutTopMargin + 39 + 45 + 10;
            
            var height: CGFloat = ExhibitionInfoDetailsCellDefaultHeight
            if aboutExpended {
                height = aboutTextHeight + aboutTextMargins
            } else {
                let defaultHeight = ExhibitionInfoDetailsCellDefaultHeight
                let defaultAboutTextHeight = defaultHeight - aboutTextMargins
                height = (aboutTextHeight < defaultAboutTextHeight) ? aboutTextHeight : defaultAboutTextHeight
                height += aboutTextMargins
            }
            
            return CGSizeMake(cellWidth, height)
        }
    }
    
    private class func aboutAttributedString(text text: String) -> NSAttributedString {
        let aboutParagraphStyle = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForText).mutableCopy() as! NSMutableParagraphStyle
        aboutParagraphStyle.paragraphSpacingBefore = 8.0
        let aboutAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                               NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                               NSForegroundColorAttributeName: UIColor.yamoDarkGray(),
                               NSParagraphStyleAttributeName: aboutParagraphStyle]
        let aboutAttributedString = NSAttributedString(string: text, attributes: aboutAttributes)
        return aboutAttributedString
    }
    
    private class func detailAttributedString(text text: String) -> NSAttributedString {
        let attributes = self.detailsAttributes()
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    private class func detailAttributedStringForEntryFee(text text: String) -> NSAttributedString {
        let attributes = self.detailsAttributes()
        let fee = Float(text)
        var attributedString: NSAttributedString?
        
        if fee == 0 {
            
            attributedString  = NSAttributedString(string: NSLocalizedString("Free", comment: ""), attributes: attributes)
        }
        else {
            
           attributedString  = NSAttributedString(string: String(format: "£%.2f", fee!), attributes: attributes)
        }
        
        return attributedString!
    }
    
    class func detailsAttributes() -> [String : AnyObject] {
        let paragraphStyle = NSParagraphStyle.preferredParagraphStyleForLineHeightMultipleStyle(.ForText)
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoDarkGray(),
                          NSParagraphStyleAttributeName: paragraphStyle]
        
        return attributes
    }
    
    // MARK: - View Configuration
    
    func configureView(dataUpdated dataUpdated: Bool, state: ExhibitionInfoDetailsSelectionState, about: String, aboutExpended: Bool, details: [ExhibitionInfoDetailData]) -> CGSize {
        self.aboutExpended = aboutExpended
        
        self.currentSelectionState = state
        
        switch state {
        case .Details:
            self.aboutButton.selected = false
            self.detailsButton.selected = true
            self.aboutTextView.alpha = 0.0
            self.readMoreButton.alpha = 0.0
            self.detailsContainerView.alpha = 1.0
        case .About:
            self.aboutButton.selected = true
            self.detailsButton.selected = false
            self.aboutTextView.alpha = 1.0
            self.readMoreButton.alpha = 1.0
            self.detailsContainerView.alpha = 0.0
        }
        
        let cellWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let expectedSubviewWidth = cellWidth - (DetailsLeadingTrailingMargin * 2)
        let attributedAboutString = ExhibitionInfoDetailsCell.aboutAttributedString(text: about)
        self.aboutTextView.textContainerInset = UIEdgeInsetsMake(7, 0, 0, 0) // Default is UIEdgeInsetsMake(8, 0, 8, 0)
        self.aboutTextView.textContainer.lineFragmentPadding = 0

        self.aboutTextHeight = CGRectIntegral(attributedAboutString.boundingRectWithSize(CGSizeMake(expectedSubviewWidth - 10, CGFloat.max),
            options: [.UsesLineFragmentOrigin],
            context: nil)).size.height + 10
        if !self.viewConfigured || dataUpdated {
            
            // configure about texts
            self.aboutTextView.attributedText = attributedAboutString
            
            // configure detail container view by inserting subviews
            self.detailsHeight = DetailSeparatorMargin
            
            for view in self.detailsContainerView.subviews {
                view.removeFromSuperview()
            }
            
            for i in 0..<details.count {
                let detailData = details[i]
                print(detailData)
                if detailData.detailString.characters.count > 0 {
                    // label
                    var attributedString = ExhibitionInfoDetailsCell.detailAttributedString(text: detailData.detailString)
                    
                    if detailData.context == .EntryFee {
                        attributedString = ExhibitionInfoDetailsCell.detailAttributedStringForEntryFee(text: detailData.detailString)
                    } else {
                        attributedString = ExhibitionInfoDetailsCell.detailAttributedString(text: detailData.detailString)
                    }
                    
                    let height = attributedString.boundingRectWithSize(CGSizeMake(expectedSubviewWidth - 10, CGFloat.max),
                                                                       options: [.UsesLineFragmentOrigin, .UsesFontLeading],
                                                                       context: nil).height + 10
                    let frame = CGRectMake(DetailsLeadingTrailingMargin, self.detailsHeight, expectedSubviewWidth, height)
                    let textView = UITextView(frame: frame)
                    textView.scrollEnabled = false
                    textView.editable = false
                    textView.contentInset = UIEdgeInsetsZero
                    textView.textContainerInset = UIEdgeInsetsMake(7, 0, 0, 0) // Default is UIEdgeInsetsMake(8, 0, 8, 0)
                    textView.textContainer.lineFragmentPadding = 0
                    textView.attributedText = attributedString
                    textView.dataDetectorTypes = [.PhoneNumber, .Link]
                    
                    self.detailsContainerView.addSubview(textView)
                    self.detailsHeight += DetailLabelTopMargin + height
                    
                    if i < details.count - 1 {
                        // separator
                        let separator = UIView(frame: CGRectMake(0, self.detailsHeight, cellWidth, DetailSeparatorHeight))
                        separator.backgroundColor = UIColor.yamoLightGray()
                        
                        self.detailsContainerView.addSubview(separator)
                        self.detailsHeight += DetailSeparatorHeight + DetailSeparatorMargin
                    } else {
                        self.detailsHeight += DetailSeparatorMargin
                    }
                }
            }
            
            self.updateHeight()
            
            self.viewConfigured = true
        }
        
        // AboutTopMargin is the top margin of the label, 39 is the bottom margin, and 10 here
        // is a magic number to make the text stand still in the same position
        let aboutTextMargins = AboutTopMargin + 39 + self.buttonHeightConstraint.constant + 10;
        let defaultHeight = ExhibitionInfoDetailsCellDefaultHeight
        let defaultAboutTextHeight = defaultHeight - aboutTextMargins
        self.readMoreButton.hidden = aboutExpended || (self.aboutTextHeight < defaultAboutTextHeight)
        
        return CGSizeMake(CGRectGetWidth(self.frame), self.buttonHeightConstraint.constant + self.detailsHeight)
    }
    
    private func updateHeight() {
        
        self.delegate?.exhibitionInfoCellDidRequireCacheState?(self)
        
        let width = CGRectGetWidth(self.frame)
        
        if self.detailsButton.selected {
            
            let height = self.buttonHeightConstraint.constant + self.detailsHeight
            self.delegate?.exhibitionInfoCell?(self, didChangedContentSize: CGSizeMake(width, height))
            
        } else if self.aboutButton.selected {
            
            // AboutTopMargin is the top margin of the label, 39 is the bottom margin, and 10 here
            // is a magic number to make the text stand still in the same position
            let aboutTextMargins = AboutTopMargin + 39 + self.buttonHeightConstraint.constant + 10;
            
            if self.aboutExpended {
                
                let height = self.aboutTextHeight + aboutTextMargins
                self.delegate?.exhibitionInfoCell?(self, didChangedContentSize: CGSizeMake(width, height))
                
            } else {
                
                let defaultHeight = ExhibitionInfoDetailsCellDefaultHeight
                let defaultAboutTextHeight = defaultHeight - aboutTextMargins
                var height = (self.aboutTextHeight < defaultAboutTextHeight) ? self.aboutTextHeight : defaultAboutTextHeight
                height += aboutTextMargins
                
                self.delegate?.exhibitionInfoCell?(self, didChangedContentSize: CGSizeMake(width, height))
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func detailsButtonPressed(sender: UIButton) {
        if self.currentSelectionState == .Details {
            return
        }
        
        self.currentSelectionState = .Details
        
        self.detailsButton.selected = true
        self.aboutButton.selected = false
        
        self.detailsContainerView.alpha = 1.0
        self.aboutTextView.alpha = 0.0
        self.readMoreButton.alpha = 0.0
        
        self.updateHeight()
    }
    
    @IBAction func aboutButtonPressed(sender: AnyObject) {
        if self.currentSelectionState == .About {
            return
        }
        
        self.currentSelectionState = .About
        
        self.detailsButton.selected = false
        self.aboutButton.selected = true
        
        self.detailsContainerView.alpha = 0.0
        self.aboutTextView.alpha = 1.0
        self.readMoreButton.alpha = 1.0
        
        self.updateHeight()
    }
    
    @IBAction func readMoreButtonPressed(sender: AnyObject) {
        self.aboutExpended = true
        self.readMoreButton.hidden = true
        
        self.updateHeight()
    }
}
