//
//  ExploreListCell.swift
//  Yamo
//
//  Created by Hungju Lu on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

let ExploreListCellNibName = "ExploreListCell"
let ExploreListCellDefaultHeight: CGFloat = 298.0

class ExploreListCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel1: UILabel!
    @IBOutlet weak var categoryLabel2: UILabel!
    @IBOutlet weak var categoryLabel3: UILabel!
    @IBOutlet weak var categoryLabel4: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var relevanceRateLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageOverlay: UIView!
    /* -------- hans added --------- */
    @IBOutlet weak var btn_favorite: UIButton!;
    @IBOutlet weak var btn_favorite_sel: UIButton!;
    /* ----------------------------- */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundImageOverlay.hidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundImageView.image = UIImage()
        self.backgroundImageOverlay.hidden = true
    }
    
    // MARK: - View Configuration
    
    func configureView(tags tags: NSArray, exhibitionName: String, location: String, relevanceRate: NSNumber, distance: NSNumber, exploreType: Int) {
        
        let tagsToDisplayLimit = 4
        // Setup tags label
        let arrayOfTags = NSMutableArray.init(array: orderArrayOfTagsWithArray(tags as! Array<Tag>))
        
        var categoryLables: [UILabel]? = [categoryLabel1, categoryLabel2, categoryLabel3, categoryLabel4]
        
        for categoryLable in categoryLables! {
            categoryLable.hidden = true
        }
        
        if arrayOfTags.isValidArray() {
            
            for tag in arrayOfTags {
                let combinedCategoryAttributedString = NSMutableAttributedString()
                combinedCategoryAttributedString.appendAttributedString(NSAttributedString(string: "  "))
                combinedCategoryAttributedString.appendAttributedString(self.generateAttributedStringForTag(tag as! Tag))
                
                if arrayOfTags.indexOfObject(tag) == tagsToDisplayLimit - 1{
                    break
                }
                combinedCategoryAttributedString.appendAttributedString(NSAttributedString(string: "  "))
                
                let selCategoryLabel = categoryLables![arrayOfTags.indexOfObject(tag)]
                selCategoryLabel.hidden = false
                
                selCategoryLabel.attributedText = combinedCategoryAttributedString
                
                selCategoryLabel.frame = CGRect(x: selCategoryLabel.frame.origin.x, y: selCategoryLabel.frame.origin.y,
                                                width: selCategoryLabel.intrinsicContentSize().width, height: selCategoryLabel.frame.size.height)
                
                for constraint in selCategoryLabel.constraints {
                    if constraint.identifier == "CategoryWidth" {
                        constraint.constant = selCategoryLabel.intrinsicContentSize().width
                    }
                }
                
                let rectShape = CAShapeLayer()
                rectShape.bounds = selCategoryLabel.frame
                rectShape.position = selCategoryLabel.center
                rectShape.path = UIBezierPath(roundedRect: selCategoryLabel.bounds, byRoundingCorners: .TopRight, cornerRadii:
                    CGSize(width: 20, height: 20)).CGPath
                
                selCategoryLabel.layer.mask = rectShape
            }
        }
        
        // Configure name label
        let nameParagraphStyle = NSMutableParagraphStyle()
        nameParagraphStyle.lineHeightMultiple = ParagraphStyleLineHeightMultipleForHeader
        let nameAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 19.0),
                              NSForegroundColorAttributeName: self.backgroundImageOverlay.hidden ? UIColor.yamoText() : UIColor.yamoGray(),
                              NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 19.0),
                              NSParagraphStyleAttributeName: nameParagraphStyle]
        self.nameLabel.attributedText = NSAttributedString(string: exhibitionName, attributes: nameAttributes)
        
        // Configure location label
        let locationAttachment = NSTextAttachment()
        let locationImage = UIImage(named: "icon location 1 1")
        locationAttachment.image = locationImage
        let locationAttachmentAttributedString = NSAttributedString(attachment: locationAttachment)
        
        let locationAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 12.0),
                                  NSForegroundColorAttributeName: self.backgroundImageOverlay.hidden ? UIColor.yamoDarkGray() : UIColor.yamoGray(),
                                  NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 12.0)]
        let locationAttributedString = NSAttributedString(string: location, attributes: locationAttributes)
        
        let combinedLocationAttributedString = NSMutableAttributedString(attributedString: locationAttachmentAttributedString)
        combinedLocationAttributedString.appendAttributedString(NSAttributedString(string: "  "))
        combinedLocationAttributedString.appendAttributedString(locationAttributedString)
        
        self.locationLabel.attributedText = combinedLocationAttributedString
        
        self.locationLabel.hidden = location.characters.count == 0
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
//        // Configure relevance rate label
//        let numberFormatter = NSNumberFormatter()
//        numberFormatter.numberStyle = .PercentStyle
//        // Percent style expects value to be between 0 and 1, where as the relevance value from the server comes back with a value
//        // between 0 and 100.
//        let relevanceValue = NSNumber(double: relevanceRate.doubleValue / 100)
//        let rateString = numberFormatter.stringFromNumber(relevanceValue)!
//        let rateAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 12.0),
//                              NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 12.0),
//                              NSForegroundColorAttributeName: UIColor.orangeColor()]
//        let rateAttributedString = NSAttributedString(string: rateString, attributes: rateAttributes)
//        
//        self.relevanceRateLabel.attributedText = rateAttributedString
        
        // Configure the distance
        let distanceKilometers = distance.doubleValue / 1000.0
        let distanceString = String(format: "%.1fkm", distanceKilometers)
        
        let distanceAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 12.0),
                              NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 12.0),
                              NSForegroundColorAttributeName: UIColor.orangeColor()]
        let distanceAttributedString = NSMutableAttributedString(string: distanceString, attributes: distanceAttributes)
        self.relevanceRateLabel.attributedText = distanceAttributedString
        
        // Default background image view image
        self.configureBackgroundImage(withImage: UIImage(named: "Placeholder")!)
        
        if(exploreType == 1 || exploreType == 2) {
            btn_favorite.hidden = true;
            btn_favorite_sel.hidden = true;
        }
    }
    
    func configureBackgroundImage(withURL urlString: String) {
        
        if let url = NSURL(string: urlString) {
        
            let urlRequest = NSURLRequest(URL: url)
            
            if let image = AFImageDownloader.defaultInstance().imageCache?.imageforRequest(urlRequest, withAdditionalIdentifier: urlString) {
                
                self.configureBackgroundImage(withImage: image)
                
            } else {
                
                self.backgroundImageView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { (_, _, image) in
                    
                    self.configureBackgroundImage(withImage: image)
                    
                    }, failure: { (_, _, _) in
                        NSLog("Could not load image for list cell")
                })
            }
        }
    }
    
    private func configureBackgroundImage(withImage image: UIImage) {
        self.backgroundImageView.image = image
        self.backgroundImageOverlay.hidden = false
        
        if let nameAttributedText = self.nameLabel.attributedText?.mutableCopy() as? NSMutableAttributedString {
            
            nameAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.yamoGray(), range: NSMakeRange(0, nameAttributedText.length))
            self.nameLabel.attributedText = nameAttributedText
        }
        
        if let locationAttributedText = self.nameLabel.attributedText?.mutableCopy() as? NSMutableAttributedString {
            
            locationAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.yamoText(), range: NSMakeRange(0, locationAttributedText.length))
            self.nameLabel.attributedText = locationAttributedText
        }
    }
    
    //MARK: Helper
    
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
        
        let dictOfAttributes : [String : AnyObject] = [NSForegroundColorAttributeName : color,
                                                       NSFontAttributeName : UIFont.preferredFontForStyle(.GraphikRegular, size: 12.0),
                                                       NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 12.0)]
        let attrStr = NSAttributedString.init(string: stringTitle, attributes: dictOfAttributes)
        return attrStr.mutableCopy() as! NSAttributedString
    }

}
