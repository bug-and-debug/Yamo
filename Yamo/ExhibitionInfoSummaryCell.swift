//
//  ExhibitionInfoInfoCell.swift
//  Yamo
//
//  Created by Hungju Lu on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import UIColor_LOCExtensions

let ExhibitionInfoSummaryCellNibName = "ExhibitionInfoSummaryCell"
public let ExhibitionInfoSummaryCellDefaultHeight: CGFloat = 115.0

class ExhibitionInfoSummaryCell: ExhibitionInfoCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    // MARK: - View Configuration
    
    func configureView(tags tags: NSArray, exhibitionName: String, location: String) {
        // Setup tags label
        
        let tagsToDisplayLimit = 5
        
        let combinedCategoryAttributedString = NSMutableAttributedString()
        let arrayOfTags = NSMutableArray.init(array: orderArrayOfTagsWithArray(tags as! Array<Tag>))
        
        if arrayOfTags.isValidArray() {
            
            for tag in arrayOfTags {
                combinedCategoryAttributedString.appendAttributedString(self.generateAttributedStringForTag(tag as! Tag))
                
                if arrayOfTags.indexOfObject(tag) == tagsToDisplayLimit - 1 {
                    
                    break
                }
                combinedCategoryAttributedString.appendAttributedString(NSAttributedString(string: "  "))
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        combinedCategoryAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, combinedCategoryAttributedString.length))
        
        self.categoryLabel.attributedText = combinedCategoryAttributedString
        
        // Configure name label
        let nameParagraphStyle = NSMutableParagraphStyle()
        nameParagraphStyle.lineHeightMultiple = ParagraphStyleLineHeightMultipleForHeader
        let nameAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 19.0),
                              NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 19.0),
                              NSForegroundColorAttributeName: UIColor.yamoText(),
                              NSParagraphStyleAttributeName: nameParagraphStyle]
        self.nameLabel.attributedText = NSAttributedString(string: exhibitionName, attributes: nameAttributes)
        
        // Configure location label
        let locationAttachment = NSTextAttachment()
        let locationImage = UIImage(named: "icon location 1 1")
        locationAttachment.image = locationImage
        let locationAttachmentAttributedString = NSAttributedString(attachment: locationAttachment)
        
        let locationAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 12.0),
                                  NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 12.0),
                                  NSForegroundColorAttributeName: UIColor.yamoDarkGray()]
        let locationAttributedString = NSAttributedString(string: location, attributes: locationAttributes)
        
        let combinedLocationAttributedString = NSMutableAttributedString(attributedString: locationAttachmentAttributedString)
        combinedLocationAttributedString.appendAttributedString(NSAttributedString(string: "  "))
        combinedLocationAttributedString.appendAttributedString(locationAttributedString)
        
        self.locationLabel.attributedText = combinedLocationAttributedString
        
        self.locationLabel.hidden = location.characters.count == 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleNotification), name: UserServiceShowShareButtonNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleNotification), name: UserServiceHideShareButtonNotification, object: nil)
    }
    
    // MARK: Helper
    
    class func estimatedHeightForVenueName(exhibitionName: String) -> CGFloat {
        
        let nameParagraphStyle = NSMutableParagraphStyle()
        nameParagraphStyle.lineHeightMultiple = ParagraphStyleLineHeightMultipleForHeader
        let nameAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 19.0),
                              NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 19.0),
                              NSForegroundColorAttributeName: UIColor.yamoText(),
                              NSParagraphStyleAttributeName: nameParagraphStyle]
        let attributedText = NSAttributedString(string: exhibitionName, attributes: nameAttributes)
        
        let size = CGSizeMake(UIScreen.mainScreen().bounds.size.width - (15.0 * 2), CGFloat.max) // 15.0 * 2 is the gapping from the storyboard
        let bounds = attributedText.boundingRectWithSize(size, options: [.UsesLineFragmentOrigin], context: nil)
        let height = bounds.height > 24.0 ? bounds.height : 24.0
        
        return height + CGFloat(11 + 18 + 4 + 8 + 18 + 5 + 1) // the rest element heights from storyboard
    }
    
    func orderArrayOfTagsWithArray(array: Array <Tag>) -> Array<Tag> {
        
        let tempMutableArray = NSMutableArray.init(array: array)
        let highestToLowest = NSSortDescriptor(key: "priority", ascending: false)
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        tempMutableArray.sortUsingDescriptors([highestToLowest, nameSortDescriptor])
        return tempMutableArray.copy() as! Array<Tag>
    }
    
    func generateAttributedStringForTag(tag: Tag) -> NSAttributedString {
        
        guard let stringTitle = tag.name else {
            
            return NSAttributedString()
        }
        
        var color = UIColor.lightGrayColor()
        
        if let colorString = tag.hexColour {
            
            if let newColor = UIColor.init(hexString: colorString) {
                
                color = newColor
            }
        }
        
        let attributes : [String : AnyObject] = [NSForegroundColorAttributeName : color,
                                                       NSFontAttributeName : UIFont.preferredFontForStyle(.GraphikRegular, size: 12.0),
                                                       NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 12.0),]
        let attributedString = NSAttributedString.init(string: stringTitle, attributes: attributes)
        return attributedString.mutableCopy() as! NSAttributedString
    }
    
    func handleNotification(notification: NSNotification) {
        
        if (notification.name == UserServiceShowShareButtonNotification) {
            self.shareButton.hidden = false
        } else if (notification.name == UserServiceHideShareButtonNotification) {
            self.shareButton.hidden = true
        }
    }
    @IBAction func clickedOnShareButton(sender: AnyObject) {
        
        self.delegate?.shareExhibitionInfo!()
        
    }
}
