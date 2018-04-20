//
//  ScrollingTabMenuView.swift
//  LOCScrollingTabViewController
//
//  Created by Mo Moosa on 07/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

@objc public class ScrollingTabMenuItem: NSObject {
    
    var title: String?
    
    init(title: String) {

        super.init()
        
        self.title = title
    }
}

@objc protocol ScrollingTabMenuViewDelegate {
    
    func scrollMenuDidSelectItemAtIndex(scrollMenu: ScrollingTabMenuView, index: Int)
    func tabsShouldHaveDynamicWidth() -> Bool
    func tabsMarginForDynamicWidth() -> CGFloat
}

let ScrollingTabMenuViewItemSize = CGSizeMake(110.0, 30.0)
let ScrollingTabMenuViewIndicatorSize = CGSizeMake(100.0, 3.0)
let ScrollingTabMenuViewMargin: CGFloat = 10.0
let ScrollingTabMenuViewMinimumNumberOfItemsForScrolling = 3

@objc public class ScrollingTabMenuView: UIView {
    
    public let scrollView = UIScrollView()
    public let scrollViewContentView = UIView()
    public let tapGestureRecognizer = UITapGestureRecognizer()
    public let indicator = UIView()
    public var selectedIndex: Int?
    public var selectedColor = UIColor.blackColor()
    public var selectedFont = UIFont.boldSystemFontOfSize(15.0)
    public var normalColor = UIColor.grayColor()
    public var normalFont = UIFont.systemFontOfSize(15.0)
    public var selectedTextAttributes: [String: AnyObject]?
    public var normalTextAttributes: [String: AnyObject]?
    public let divider = UIView()

    var menuItems = [ScrollingTabMenuItem?]() {
        
        willSet {
            
            for currentView in self.menuViews {
                
                /// Effectively overwrite any previous menu items.
                
                currentView?.removeFromSuperview()
            }
        }
        
        didSet {

            var frame = CGRectMake(0.0,
                0.0,
                ScrollingTabMenuViewItemSize.width,
                ScrollingTabMenuViewItemSize.height)
            
            /// Create one label for each menuItem.
            
            for item in menuItems {
                
                guard let menuItem = item else {
                    
                    continue
                }
                
                guard let title = menuItem.title else {
                    
                    continue
                }
                
                var textAttributes = [String: AnyObject]()
                if let normalTextAttributes = self.normalTextAttributes {
                    textAttributes = normalTextAttributes
                } else {
                    textAttributes = [NSFontAttributeName:self.normalFont, NSForegroundColorAttributeName: self.normalColor]
                }
                
                if delegate?.tabsShouldHaveDynamicWidth() == true {
                    
                    if let string: NSString = menuItem.title {
                        let size = string.sizeWithAttributes(textAttributes)
                        
                        // Values are fractional — we should take the ceilf to get equivalent values
                        // http://stackoverflow.com/a/18897897/1162044
                        let adjustedSize = CGSizeMake(CGFloat(ceilf(Float(size.width))), CGFloat(ceilf(Float(size.height))))
                        
                        let margin = self.delegate?.tabsMarginForDynamicWidth()
                        let widthWithMargin = adjustedSize.width + (margin! * 2)
                        
                        frame = CGRectMake(0.0,
                                           0.0,
                                           widthWithMargin,
                                           ScrollingTabMenuViewItemSize.height)
                    }
                }
                
                let label = UILabel(frame: frame)

                let attributedString = NSAttributedString(string: title, attributes: textAttributes)
                label.attributedText = attributedString
                label.textAlignment = .Center
                label.adjustsFontSizeToFitWidth = true
                self.scrollView.addSubview(label)
                
                self.menuViews.append(label)
            }
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            /// Show the first item as selected - call this method with your own preferred value.

            self.selectItemAtIndex(0, animated: false)
        }
    }
    
    private var menuViews = [UIView?]()
    weak var delegate: ScrollingTabMenuViewDelegate?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.scrollView)
        
        self.addConstraints([
            NSLayoutConstraint(item: self.scrollView, attribute: .Leading, relatedBy: .Equal , toItem:self, attribute: .Leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.scrollView, attribute: .Top, relatedBy: .Equal , toItem:self, attribute: .Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.scrollView, attribute: .Trailing, relatedBy: .Equal , toItem:self, attribute: .Trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.scrollView, attribute: .Bottom, relatedBy: .Equal , toItem:self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
            ])
        
        self.tapGestureRecognizer.addTarget(self, action: #selector(ScrollingTabMenuView.handleTapGesture(_:)))
        self.scrollView.addGestureRecognizer(self.tapGestureRecognizer)
        
        self.divider.backgroundColor = UIColor.clearColor()
        self.insertSubview(self.divider, atIndex: 0)
        
        self.indicator.frame = CGRectMake(ScrollingTabMenuViewMargin,
            self.bounds.size.height - ScrollingTabMenuViewIndicatorSize.height,
            ScrollingTabMenuViewIndicatorSize.width,
            ScrollingTabMenuViewIndicatorSize.height)
        
        self.scrollView.addSubview(self.indicator)
        
        self.indicator.backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        let dividerHeight: CGFloat = 1.0
        
        self.divider.frame = CGRectMake(0.0,
            self.bounds.size.height - dividerHeight,
            self.bounds.size.width,
            dividerHeight)
        
        var itemWidth = ScrollingTabMenuViewItemSize.width
        var margin = ScrollingTabMenuViewMargin
        
        // ScrollingTabMenuViewMinimumNumberOfItemsForScrolling is a threshold for whether or not the scrollView
        // should actually scroll. The default value is 3, meaning that if this view has 4 or more menuItems it
        // will scroll.
        
        if self.menuViews.count <= ScrollingTabMenuViewMinimumNumberOfItemsForScrolling {
            
            itemWidth = self.bounds.size.width / CGFloat(self.menuViews.count)
            margin = ScrollingTabMenuViewMargin
        }
        
        if margin > 0 && self.bounds.size.height - ScrollingTabMenuViewIndicatorSize.height > 0 && itemWidth > 0 && ScrollingTabMenuViewIndicatorSize.height > 0 {
        
        self.indicator.frame = CGRectMake(margin,
            self.bounds.size.height - ScrollingTabMenuViewIndicatorSize.height,
            itemWidth,
            ScrollingTabMenuViewIndicatorSize.height)
        }
        else {
            self.indicator.frame = CGRectMake(40, 30, 50, 10)
            self.indicator.backgroundColor = UIColor.clearColor()
        }
        
        var xOffset = margin
        var totalWidth = xOffset
        let yOffset = (self.scrollView.bounds.size.height - ScrollingTabMenuViewItemSize.height) * 0.5
        
        for view in self.menuViews {
            
            if let menuView = view {
                
                var width = ScrollingTabMenuViewItemSize.width
                if delegate?.tabsShouldHaveDynamicWidth() == true {
                    width = menuView.frame.size.width
                }
                
                menuView.frame = CGRectMake(xOffset, yOffset,  width, ScrollingTabMenuViewItemSize.height)
                xOffset += menuView.frame.size.width + margin
                totalWidth += menuView.frame.size.width + margin
            }
        }
        
        if totalWidth < self.scrollView.bounds.size.width {
            
            margin = 0.0
            xOffset = margin
            
            for view in self.menuViews {
                
                if let menuView = view {
                    
                    var width = itemWidth
                    if delegate?.tabsShouldHaveDynamicWidth() == true {
                        width = menuView.frame.size.width
                    }
                    
                    menuView.frame = CGRectMake(xOffset, yOffset, width, ScrollingTabMenuViewItemSize.height)
                    xOffset += menuView.frame.size.width + margin
                }
            }

        }
        self.scrollView.contentSize = CGSizeMake(xOffset, self.scrollView.frame.size.height)
    }
    
    // MARK: Setters
    
    func setIndicatorFrame(ratio: CGFloat, isNextItem: Bool, index: Int) {
        
        /// This method focuses on updating the frame of the indicator view based on the current scroll point/
        /// selection.
        
        let indexAsFloat = CGFloat(index)
        
        var xPoint: CGFloat = 0.0
        
        if isNextItem {
            
            let minimumXPoint = (ScrollingTabMenuViewMargin + ScrollingTabMenuViewItemSize.width) * ratio
            
            let indexFrame = (indexAsFloat * ScrollingTabMenuViewItemSize.width) + ((indexAsFloat + 1) * ScrollingTabMenuViewMargin)
            
            xPoint = minimumXPoint + indexFrame
        }
        else {
            
            let minimumXPoint = (ScrollingTabMenuViewMargin + ScrollingTabMenuViewItemSize.width) * (1 - ratio)
            
            let indexFrame = (indexAsFloat * ScrollingTabMenuViewItemSize.width) + ((indexAsFloat + 1) * ScrollingTabMenuViewMargin)
            
            xPoint = minimumXPoint + indexFrame
        }
        
        // TODO: Bounds checks
        
        self.indicator.frame = CGRectMake(xPoint,
            self.indicator.frame.origin.y,
            self.indicator.frame.size.width,
            self.indicator.frame.size.height);
    }
    
    func handleTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let point = tapGestureRecognizer.locationInView(self.scrollView)
        
        
        
        for (index, view) in self.menuViews.enumerate() {
            
            if let menuView = view {
                
                if CGRectContainsPoint(menuView.frame, point) {
                    
                    guard index != self.selectedIndex else {
                        
                        // There's no point in refreshing the UI for the same selection
                        
                        break
                    }
                    
                    self.selectItemAtIndex(index, animated: true)
                    
                    self.delegate?.scrollMenuDidSelectItemAtIndex(self, index: index)
                    
                    break
                    
                }
            }
        }
    }
    
    func selectItemAtIndex(index: Int, animated: Bool) {
        
        var oldLabel: UILabel?
        var newLabel: UILabel?
        var newLabelIndex: Int?
        
        for (labelIndex, view) in self.menuViews.enumerate() {
            
            guard let menuItem = menuItems[labelIndex],
                let title = menuItem.title else {
                    
                    continue
            }
            
            if let label = view as? UILabel {
                
                if labelIndex == index {
                    
                    // Item has been selected
                    var textAttributes = [String: AnyObject]()
                    if let normalTextAttributes = self.selectedTextAttributes {
                        textAttributes = normalTextAttributes
                    } else {
                        textAttributes = [NSFontAttributeName:self.selectedFont, NSForegroundColorAttributeName: self.selectedColor]
                    }
                    
                    let attributedString = NSAttributedString(string: title, attributes: textAttributes)
                    label.attributedText = attributedString
                    
                    newLabel = label
                    newLabelIndex = labelIndex
                }
                else {
                    // Item has not been selected
                    
                    var textAttributes = [String: AnyObject]()
                    if let normalTextAttributes = self.normalTextAttributes {
                        textAttributes = normalTextAttributes
                    } else {
                        textAttributes = [NSFontAttributeName:self.normalFont, NSForegroundColorAttributeName: self.normalColor]
                    }
                    
                    let attributedString = NSAttributedString(string: title, attributes: textAttributes)
                    label.attributedText = attributedString
                    
                    oldLabel = label
                }
            }
        }
        
        if let newLabel = newLabel, let oldLabel = oldLabel {
        
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                }, completion: { (completed) -> Void in
                    
            })
            
            newLabel.alpha = 0.5
            oldLabel.alpha = 0.5
            
            let animationBlock = {

                if let selectedColor = self.selectedTextAttributes?[NSForegroundColorAttributeName] as? UIColor {
                    newLabel.textColor = selectedColor
                } else {
                    newLabel.textColor = self.selectedColor
                }
                
                if let normalColor = self.normalTextAttributes?[NSForegroundColorAttributeName] as? UIColor {
                    oldLabel.textColor = normalColor
                } else {
                    oldLabel.textColor = self.normalColor
                }
                
                newLabel.alpha = 1.0
                oldLabel.alpha = 1.0
            }
            
            let completionBlock: (Bool) -> Void = {
                (finished:Bool) -> Void in

                if finished {
                    
                    if let newLabelIndex = newLabelIndex {
                        
                        self.selectedIndex = newLabelIndex
                    }
                }
            }
            
            if animated {
                
                UIView.animateWithDuration(0.3, animations: animationBlock, completion: completionBlock)
            }
            else {
                
                animationBlock()
                completionBlock(true)
            }
        }
    }
    
    func frameForLabelAtIndex(index: Int) -> CGRect {

        if let label = self.menuViews[index] {

            return label.frame
        }
        
        return CGRectZero
    }
    
    func setIndicatorFrame(frame: CGRect, animated: Bool) {
        
        var indicatorFrame = self.indicator.frame
        
        indicatorFrame.origin.x = frame.origin.x
        
        let animationBlock = {

            self.indicator.frame = indicatorFrame
        }
     
        if animated {
            
            UIView.animateWithDuration(0.5, animations: animationBlock)
        }
        else {
            
            animationBlock()
        }
    }
}
