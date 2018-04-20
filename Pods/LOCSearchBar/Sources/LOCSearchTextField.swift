//
//  LOCSearchTextField.swift
//  LOCSearchBar
//
//  Created by Hungju Lu on 24/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

private let DefaultPadding: CGFloat = 10.0
private let DefaultMediumPadding: CGFloat = 15.0
private let DefaultSearchBarIconImageName = "searchbar-icon"
private let DefaultMediumFont = UIFont(name: "Avenir-Medium", size: 15.0)
private let DefaultMediumObliqueFont = UIFont(name: "Avenir-MediumOblique", size: 15.0)
private let DefaultPlaceholderColour = UIColor.lightGrayColor()
private let DefaultPlaceholder = "Search"

@objc public enum LOCSearchBarAccessoryImagePosition: Int {
    case Left
    case Right
}

public class LOCSearchTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialise()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialise()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.initialise()
    }
    
    public override func clearButtonRectForBounds(bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRectForBounds(bounds)
        return CGRectOffset(originalRect, -DefaultPadding, 0)
    }
    
    // MARK: - Properties
    
    override public var placeholder: String?{
        didSet{
            self.customisePlaceholder()
        }
    }
    
    override public var font: UIFont? {
        didSet {
            self.customisePlaceholder()
        }
    }
    
    /// The image places on the left or right side of the search bar
    public var accessoryImage: UIImage? {
        didSet {
            self.updateSearchIcon()
        }
    }
    
    /// The position for the accessory Image
    public var accessoryImagePosition: LOCSearchBarAccessoryImagePosition = .Left {
        didSet {
            self.updateSearchIcon()
        }
    }
    
    /// The colour of the placeholder text
    public var placeholderColour: UIColor? {
        didSet {
            self.customisePlaceholder()
        }
    }
    
    /// The font of the placeholder text
    public var placeholderFont: UIFont? {
        didSet {
            self.customisePlaceholder()
        }
    }
    
    /**
     Convenience method for setting placeholder appearance
     
     - parameter placeholder: the text of placeholder
     - parameter colour:      the colour of placeholder text
     - parameter font:        the font of placeholder text
     */
    public func setPlaceholder(placeholder: String, colour: UIColor = DefaultPlaceholderColour, font: UIFont? = DefaultMediumObliqueFont) {
        self.placeholder = placeholder
        self.placeholderColour = colour
        self.placeholderFont = font
        self.customisePlaceholder()
    }

    // MARK: - Helpers
    
    private func initialise() {
        self.leftView = self.searchIcon()
        self.leftViewMode = .Always
        self.rightViewMode = .Always
        self.borderStyle = .None
        self.font = DefaultMediumFont
        self.returnKeyType = .Search
        self.clearButtonMode = .Always
        self.customisePlaceholder()
    }
    
    private func searchIcon() -> UIView {
        var image: UIImage?
        
        if let searchImage = self.accessoryImage {
            image = searchImage
        } else {
            // to access the default image from the Resources.bundle file in cocoapods
            let frameworkBundle = NSBundle(forClass: LOCSearchTextField.self)
            if let resourceBundlePath = frameworkBundle.pathForResource("LOCSearchBarResources", ofType: "bundle"),
                let resourceBundle = NSBundle(path: resourceBundlePath) {
                    image = UIImage(named: DefaultSearchBarIconImageName, inBundle: resourceBundle, compatibleWithTraitCollection: nil)
            } else {
                image = UIImage(named: DefaultSearchBarIconImageName)
            }
        }
        
        let searchIcon = UIImageView(image: image)
        searchIcon.contentMode = .ScaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let rect = CGRectMake(0, 0, searchIcon.frame.size.width + DefaultMediumPadding + DefaultPadding, self.frame.size.height)
        let leftView = UIView(frame: rect)
        leftView.addSubview(searchIcon)
        
        leftView.addConstraint(NSLayoutConstraint(item: searchIcon,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: leftView,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0.0))
        
        leftView.addConstraint(NSLayoutConstraint(item: searchIcon,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: leftView,
            attribute: .Leading,
            multiplier: 1.0,
            constant: DefaultMediumPadding))
        
        return leftView
    }
    
    private func updateSearchIcon() {
        switch self.accessoryImagePosition {
        case .Left:
            self.leftView = self.searchIcon()
            self.rightView = nil
        case .Right:
            self.leftView = nil
            self.rightView = self.searchIcon()
        }
    }
    
    private func customisePlaceholder() {
        var theColour: UIColor
        
        if let c = self.placeholderColour {
            theColour = c
        } else {
            theColour = UIColor.lightGrayColor()
        }
        
        var theFont: UIFont?
        
        if let f = self.placeholderFont {
            theFont = f
        } else {
            theFont = DefaultMediumObliqueFont
        }
        
        var thePlaceholder: String
        
        if let p = self.placeholder {
            thePlaceholder = p
        } else {
            thePlaceholder = DefaultPlaceholder
        }
        
        var theAttributes: [String: AnyObject] = [NSForegroundColorAttributeName: theColour]
        
        if let f = theFont {
            theAttributes[NSFontAttributeName] = f
        }
        
        self.attributedPlaceholder = NSAttributedString(string: thePlaceholder, attributes: theAttributes)
    }
}
