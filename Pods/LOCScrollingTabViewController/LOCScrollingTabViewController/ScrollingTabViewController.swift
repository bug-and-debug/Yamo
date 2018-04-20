//
//  ScrollingTabViewController.swift
//  LOCScrollingTabViewController
//
//  Created by Mo Moosa on 07/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

@objc public protocol ScrollingTabViewControllerDelegate {
    
    func scrollingTabViewControllerDidSelectViewController(scrollingTabViewController: ScrollingTabViewController, selectedViewController: UIViewController)
    
    func tabsShouldHaveDynamicWidth() -> Bool
    func tabsMarginForDynamicWidth() -> CGFloat
}

@objc public class ScrollingTabViewController: UIViewController, ScrollingTabMenuViewDelegate, UIScrollViewDelegate {
    
    var menuView = ScrollingTabMenuView()
    var currentIndex = 0
    public let contentScrollView = UIScrollView()
    var isUpdating = false
    var initialViewControllerIndex = 0
    
    public private(set) var selectedViewController: UIViewController?
    public var delegate: ScrollingTabViewControllerDelegate?
    
    /// If set this, it will ignore the `selectedFont` and `selectedColor`
    public var selectedTextAttributes: [String: AnyObject]? {
        
        didSet {
            
            if let selectedTextAttributes = selectedTextAttributes {
                
                self.menuView.selectedTextAttributes = selectedTextAttributes
            }
        }
    }
    
    /// If set this, it will ignore the `normalFont` and `normalColor`
    public var normalTextAttributes: [String: AnyObject]? {
        
        didSet {
            
            if let normalTextAttributes = normalTextAttributes {
                
                self.menuView.normalTextAttributes = normalTextAttributes
            }
        }
    }
    
    public var selectedColor: UIColor? {
        
        didSet {
            
            if let selectedColor = selectedColor {
                
                self.menuView.selectedColor = selectedColor
            }
        }
    }
    
    public var selectedFont: UIFont? {
        
        didSet {
            
            if let selectedFont = selectedFont {
                
                self.menuView.selectedFont = selectedFont
            }
        }
    }
    
    public  var normalColor: UIColor? {
        
        didSet {
            
            if let normalColor = normalColor {
                
                self.menuView.selectedColor = normalColor
            }
        }
    }
    
    public var normalFont: UIFont? {
        
        didSet {
            
            if let normalFont = normalFont {
                
                self.menuView.normalFont = normalFont
            }
        }
    }
    
    public var viewControllers = [UIViewController]() {
        
        willSet {
            
            for viewController in self.viewControllers {
                
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
            }
            
            self.selectedViewController = nil
            
        }
        
        didSet {
            
            if self.viewControllers.count > 0 {
                
                self.layoutViewControllers()
                var menuItems = [ScrollingTabMenuItem?]()
                
                for viewController in self.viewControllers {
                    
                    if let title = viewController.title {
                        
                        menuItems.append(ScrollingTabMenuItem(title: title))
                    }
                }
                
                self.menuView.menuItems = menuItems
                
                self.scrollMenuDidSelectItemAtIndex(self.menuView, index: 0)
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuView.translatesAutoresizingMaskIntoConstraints = false
        self.contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.menuView)
        self.view.addSubview(self.contentScrollView)
        
        self.menuView.delegate = self
        self.contentScrollView.pagingEnabled = true
        self.contentScrollView.scrollEnabled = false
        self.contentScrollView.delegate = self
        self.contentScrollView.scrollsToTop = false
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.menuView, attribute: .Leading, relatedBy: .Equal , toItem:self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.menuView, attribute: .Top, relatedBy: .Equal , toItem:self.view, attribute: .Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.menuView, attribute: .Trailing, relatedBy: .Equal , toItem:self.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.menuView, attribute: .Bottom, relatedBy: .Equal , toItem:self.contentScrollView, attribute: .Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.menuView, attribute: .Height, relatedBy: .Equal , toItem:nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44.0)
            ])
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.contentScrollView, attribute: .Leading, relatedBy: .Equal , toItem:self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.contentScrollView, attribute: .Bottom, relatedBy: .Equal , toItem:self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.contentScrollView, attribute: .Trailing, relatedBy: .Equal , toItem:self.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0),
            ])
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.menuView.setNeedsLayout()
        self.menuView.layoutIfNeeded()
    }
    
    // MARK: Layout
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.layoutViewControllers()
    }
    
    public func layoutViewControllers() {
        
        self.contentScrollView.removeConstraints(self.contentScrollView.constraints)
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * CGFloat(self.viewControllers.count),
                                                        self.contentScrollView.frame.size.height)

        self.view.addConstraints([
            NSLayoutConstraint(item: self.contentScrollView, attribute: .Height, relatedBy: .Equal , toItem:self.view, attribute: .Height, multiplier: 1.0, constant: -44.0),
            NSLayoutConstraint(item: self.contentScrollView, attribute: .Width, relatedBy: .Equal , toItem:self.view, attribute: .Width, multiplier: 1.0, constant: 0.0)])
        
        for (index, viewController) in self.viewControllers.enumerate() {
            
            viewController.view.removeFromSuperview()
            
            if viewController.view.superview == nil {
                
                self.contentScrollView.addSubview(viewController.view)
            }
            
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.contentScrollView.addConstraints([NSLayoutConstraint(item: self.contentScrollView, attribute: .Top, relatedBy: .Equal, toItem: viewController.view, attribute: .Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.contentScrollView, attribute: .Bottom, relatedBy: .Equal, toItem: viewController.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: viewController.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.contentScrollView.frame.size.width),
                NSLayoutConstraint(item: viewController.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.contentScrollView.frame.size.height)])
            
            if viewController == self.viewControllers.first {
                
                self.contentScrollView.addConstraint(NSLayoutConstraint(item: self.contentScrollView, attribute: .Leading, relatedBy: .Equal, toItem: viewController.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
            }
            else {
                
                let previousViewController = self.viewControllers[index - 1]
                
                self.contentScrollView.addConstraint(NSLayoutConstraint(item: previousViewController.view, attribute: .Trailing, relatedBy: .Equal, toItem: viewController.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                
                if viewController == self.viewControllers.last {
                    
                    self.contentScrollView.addConstraint(NSLayoutConstraint(item: self.contentScrollView, attribute: .Trailing, relatedBy: .Equal, toItem: viewController.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                }
            }
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
    }
    
    public func selectViewController(viewController: UIViewController) {
        
        guard self.viewControllers.contains(viewController) else {
            
            print("Warning: \(self) instance has been passed a viewController to select that it does not contain.")
            return
        }
        
        if let index = self.viewControllers.indexOf(viewController) {
            
            self.menuView.selectItemAtIndex(index, animated: false)
            
            self.scrollMenuDidSelectItemAtIndex(self.menuView, index: index)
        }
    }
    
    func selectViewControllerAtIndex(index: Int) {
        
        guard index <= self.viewControllers.count else {
            
            print("Warning: \(self) instance has been passed an out-of-bounds index to select")
            return
        }
        //        var viewController = UIViewController()
        //
        //        if index > self.viewControllers.count {
        //            viewController = self.viewControllers[0]
        //        } else if index == -1 {
        //            viewController = self.viewControllers[self.viewControllers.count]
        //        }
        
        let viewController = self.viewControllers[index]
        
        viewController.willMoveToParentViewController(self)
        
        self.addChildViewController(viewController)
        
        viewController.didMoveToParentViewController(self)
        
        self.selectedViewController = viewController
        
        self.delegate?.scrollingTabViewControllerDidSelectViewController(self, selectedViewController: viewController)
    }
    
    // MARK: UIViewController Management
    
    func scrollToChildViewControllerAtIndex(index: Int, animated: Bool) {
        
        self.isUpdating = true;
        
        let animationBlock = {
            
            self.contentScrollView.contentOffset = CGPointMake(CGFloat(index) * self.contentScrollView.frame.size.width, 0.0)
            self.updateScrollIndicatorPositionForContentScrollView(self.contentScrollView, animated: false)
            let frame = self.menuView.frameForLabelAtIndex(index)
            
            self.menuView.setIndicatorFrame(frame, animated: true)
            
        }
        
        let completionBlock: (Bool) -> Void = {
            (finished: Bool) -> Void in
            
            if finished {
                
                self.isUpdating = false
            }
        }
        
        if animated {
            
            UIView.animateWithDuration(0.5, animations: animationBlock, completion: completionBlock)
        }
        else {
            
            animationBlock()
            completionBlock(true)
        }
        
        self.selectViewControllerAtIndex(index)
        self.currentIndex = index
        
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard self.isUpdating == false else {
            
            return
        }
        
        self.updateScrollIndicatorPositionForContentScrollView(scrollView, animated: false)
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        guard currentIndex != self.currentIndex else {
            
            return
        }
        
        self.currentIndex = currentIndex
        
        self.selectViewControllerAtIndex(self.currentIndex)
        
        self.menuView.selectItemAtIndex(self.currentIndex, animated: true)
        
    }
    
    // MARK: - ScrollingTabMenuViewDelegate
    
    func scrollMenuDidSelectItemAtIndex(scrollMenu: ScrollingTabMenuView, index: Int) {
        
        self.scrollToChildViewControllerAtIndex(index, animated: true)
    }
    
    func tabsShouldHaveDynamicWidth() -> Bool {
        return delegate!.tabsShouldHaveDynamicWidth()
    }
    
    func tabsMarginForDynamicWidth() -> CGFloat {
        return delegate!.tabsMarginForDynamicWidth()
    }
    
    
    func updateScrollIndicatorPositionForContentScrollView(contentScrollView: UIScrollView, animated: Bool) {
        
        // With dynamic tabs width prevent tabs shifting when 
        // tabs total width takes less space than screen width.
        if delegate?.tabsShouldHaveDynamicWidth() == true {
            return
        }
        
        let oldXPoint = CGFloat(self.currentIndex) * contentScrollView.frame.size.width
        
        // Create a ratio that can be used to update the scrollMenuView's position based on the contentScrollView
        
        let ratio = (contentScrollView.contentOffset.x - oldXPoint) / contentScrollView.frame.size.width
        
        let isGoingForward = contentScrollView.contentOffset.x > oldXPoint
        
        let targetIndex = (isGoingForward ? self.currentIndex + 1 : self.currentIndex - 1)
        
        var nextItemXOffset: CGFloat = 1.0
        var currentItemXOffset: CGFloat = 1.0
        let itemWidth = self.menuView.scrollView.contentSize.width - self.menuView.scrollView.frame.size.width
        
        nextItemXOffset = itemWidth * CGFloat(targetIndex) / CGFloat((self.menuView.menuItems.count - 1))
        
        currentItemXOffset = itemWidth * CGFloat(self.currentIndex) / CGFloat((self.menuView.menuItems.count - 1))
        
        
        guard targetIndex >= 0 && targetIndex < self.viewControllers.count else {
            
            return
        }
        
        var indicatorUpdateRatio: CGFloat = ratio
        var offset = self.menuView.scrollView.contentOffset
        
        if isGoingForward {
            
            // It helps when I comment this out completly
            // Figure this out next morning.
            
            offset.x = (nextItemXOffset - currentItemXOffset) * ratio + currentItemXOffset
            self.menuView.scrollView .setContentOffset(offset, animated: animated)
            
            indicatorUpdateRatio = indicatorUpdateRatio * 1
            
            self.menuView.setIndicatorFrame(indicatorUpdateRatio, isNextItem: isGoingForward, index: self.currentIndex)
        }
        else {
            
            offset.x = currentItemXOffset - (nextItemXOffset - currentItemXOffset) * ratio
            
            self.menuView.scrollView.setContentOffset(offset, animated: animated)
            
            indicatorUpdateRatio = indicatorUpdateRatio * -1
            
            self.menuView.setIndicatorFrame(indicatorUpdateRatio, isNextItem: isGoingForward, index: targetIndex)
        }
    }
}
