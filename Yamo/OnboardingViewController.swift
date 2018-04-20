//
//  OnboardingViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 21/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import Mantle

enum OnBoardingViewState {
    case OnBoardingViewStateIncomplete
    case OnBoardingViewStateComplete
};

class OnboardingViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    let pageControl = UIPageControl()
    let finishButtonHeightAndPadding = 100.0
    var onboardingViewControllers = [UIViewController]()
    var selectedViewController: UIViewController?
    var finishButton =  UIButton(type: .Custom)
    var opacityImage = UIImageView()
    
    var state: OnBoardingViewState = .OnBoardingViewStateIncomplete {
        
        didSet {
            
            switch state {
                
            case .OnBoardingViewStateComplete:
                
                self.finishButton.hidden = false
                
            case .OnBoardingViewStateIncomplete:
                self.finishButton.hidden = true
            }
        }
    }
    
    weak var onboardingDelegate: LaunchNavigationViewControllerDelegate?
    
    typealias CompletionBlock = Void -> Void
    var completion: CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAttributedTitle(NSLocalizedString("Features", comment: ""))
        
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.opaque = true
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 2.5)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        
        
        let finishAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                                NSForegroundColorAttributeName: UIColor.whiteColor(),
                                NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0)]
        let finishAttributedString = NSAttributedString(string: NSLocalizedString("Get started", comment: ""), attributes: finishAttributes)
        
        self.finishButton.setBackgroundImage(UIImage.init(named: "Buttonyellowactive"), forState: .Normal)
        self.finishButton.setAttributedTitle(finishAttributedString, forState: .Normal)
        self.finishButton.translatesAutoresizingMaskIntoConstraints = false
        self.finishButton.addTarget(self, action: #selector(self.handleSkipButtonTap(_:)), forControlEvents: .TouchUpInside)
        
        self.edgesForExtendedLayout = .None
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.numberOfPages = self.onboardingViewControllers.count
        self.pageControl.pageIndicatorTintColor = UIColor.yamoDarkGray()
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageViewController.view.backgroundColor = UIColor.clearColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.yamoYellow()
        
        self.opacityImage.translatesAutoresizingMaskIntoConstraints=false
        self.opacityImage.image = UIImage.init(named: "Opacity bottom")
        self.opacityImage.userInteractionEnabled = true
        self.pageViewController.view.addSubview(self.opacityImage)
        
        self.opacityImage.bringToFront()
        self.opacityImage.addSubview(self.pageControl)
        self.opacityImage.addSubview(self.finishButton)
        
        self.view.addConstraints([
            
            NSLayoutConstraint(
                item: self.pageControl,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.opacityImage,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.pageControl,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.opacityImage,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.pageControl,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: 10.0),
            
            NSLayoutConstraint(
                item: self.opacityImage,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.pageControl,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 20.0),
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.pageViewController.view,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.pageViewController.view,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.pageViewController.view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.pageViewController.view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.finishButton,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.opacityImage,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 15.0),
            
            NSLayoutConstraint(
                item: self.opacityImage,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.finishButton,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 15.0),
            
            NSLayoutConstraint(
                item: self.pageControl,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.finishButton,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 13.0),
            
            
            NSLayoutConstraint(
                item: self.opacityImage,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.pageViewController.view,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.opacityImage,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.pageViewController.view,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.opacityImage,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: 120.0),
            
            NSLayoutConstraint(
                item: self.pageViewController.view,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.opacityImage,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0)
            
            ])
        
        self.finishButton.addConstraint(NSLayoutConstraint(
            item: self.finishButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 48.0)
        )
        
        
        let skipButtonImage = UIImage.init(named: "IcondarkXdisabled")?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: skipButtonImage, style: .Plain, target: self, action: #selector(self.handleSkipButtonTap(_:)))
        
        // Do any additional setup after loading the view.
        
        if let viewController = self.onboardingViewControllers.first {
            
            self.pageViewController.setViewControllers([viewController], direction: .Forward, animated: true, completion: nil)
        }
        
        self.state = .OnBoardingViewStateIncomplete
        
        //        let pageControl = UIPageControl.appearance()
        //        pageControl.pageIndicatorTintColor = UIColor.yamoDarkGray()
        //        pageControl.backgroundColor = UIColor.clearColor()
        //        self.pageViewController.view.backgroundColor = UIColor.clearColor()
        //        pageControl.currentPageIndicatorTintColor = UIColor.yamoTeal()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    func handleSkipButtonTap(sender: AnyObject?) {
        
        self.showIndicator(true)
        
        APIClient.sharedInstance().authenticationCreateGuestUserBeforeLoad(nil, afterLoad: nil, successBlock: { (element) in
            
            self.showIndicator(false)
            
            self.onboardingDelegate?.viewControllerDidFinish(self)
            
        }) { (error, status, context) in
            
            self.showIndicator(false)
            
            UIAlertController.showAlert(inViewController: self,
                                        withTitle: NSLocalizedString("Error", comment: ""),
                                        message: NSLocalizedString("Something went wrong, please try again later.", comment: ""),
                                        cancelButtonTitle: NSLocalizedString("Ok", comment: ""),
                                        destructiveButtonTitle: nil,
                                        otherButtonTitles: nil,
                                        tapBlock: nil)
        }
        
        
    }
    
    // MARK: - UIPageViewControllerDatasource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let index = self.onboardingViewControllers.indexOf(viewController) where viewController != onboardingViewControllers.first {
            
            return self.onboardingViewControllers[index - 1]
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let index = self.onboardingViewControllers.indexOf(viewController) where viewController != onboardingViewControllers.last {
            
            return self.onboardingViewControllers[index + 1]
        }
        
        return nil
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
        let pageContentView = pendingViewControllers.first as! OnboardingContentViewController
        self.pageControl.currentPage = self.onboardingViewControllers.indexOf(pageContentView)!
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        
        if !completed {
            let pageContentView = previousViewControllers.first as! OnboardingContentViewController
            self.pageControl.currentPage = self.onboardingViewControllers.indexOf(pageContentView)!
        }
        
        guard let pageContentView = self.pageViewController.viewControllers?.first else {
            
            return
        }
        
        if pageContentView === self.onboardingViewControllers.last {
            if completed {
                if state == .OnBoardingViewStateIncomplete {
                    state = .OnBoardingViewStateComplete
                }
            }
            
        }
    }
    
    
}
