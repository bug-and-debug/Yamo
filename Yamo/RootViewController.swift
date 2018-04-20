//
//  RootViewController.swift
//  Yamo
//
//  Created by Mo Moosa on 26/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//  This class is designed to switch between your preferred
//  authentication screen (e.g. a Login screen) and your 
//  preferred rootviewcontroller (e.g. a UITabBarController)
//

import UIKit


enum RootViewControllerOption: Int {
    
    case MainApp, Onboarding
}

class RootViewController: UIViewController, LaunchNavigationManagerDelegate, SideMenuMainViewControllerDelegate {
    
    @IBOutlet weak var launchImageView: UIImageView!
    var onboardingManager = LaunchNavigationManager()
    var sideMenuMainViewController = MainViewController()
    var exploreViewController: ExploreViewController!;
    var firstLaunch = false
    
    func mainViewControllers() -> [UIViewController] {
        
        var viewControllers = [UIViewController]()
        
        let navigationBlock = { (viewController: UIViewController, title: String) -> () in
            viewController.setAttributedTitle(title)
            viewControllers.append(viewController)
        }
        
        navigationBlock(MyProfileViewController(), NSLocalizedString("Profile", comment: ""))
        /* ------- hans modified ------ */
        navigationBlock(exploreViewController, NSLocalizedString("Explore", comment: ""));
        //navigationBlock(ExploreViewController(nibName: "ExploreViewController", bundle: nil), NSLocalizedString("Explore", comment: ""))
        /* ------------------------- */
        navigationBlock(ActivityViewController(), NSLocalizedString("Activity", comment: ""))
        
        let GetToKnowMeVC = GetToKnowMeOnboardingViewController(nibName: "GetToKnowMeOnboardingViewController", bundle: nil)
        GetToKnowMeVC.getToKnowMeStyle = .SideMenu
        
        navigationBlock(GetToKnowMeVC,"Get To Know Me")
        
        return viewControllers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        //hans modified
        //self.setupLaunchImageView()
        self.switchToState(.Onboarding)
        
        self.instantiateMainAppViews()
        
        CoreDataOrganizeService.organizeModelWithClass(TempPlace.self)
    }
    
    //hans modified
    func setExploreType(type: Int) {
        print("------- explore type -------");
        print(type);
        print("----------------------------");
        self.exploreViewController = ExploreViewController(nibName: "ExploreViewController", bundle: nil);
        self.exploreViewController.setExploreType(type);
    }
    
    private func instantiateLoginViews() {
        self.onboardingManager.popToRootViewControllerAnimated(false)
        self.onboardingManager = LaunchNavigationManager()
        self.onboardingManager.launchManagerDelegate = self        
    }
    
    private func instantiateMainAppViews() {
        // assing a new main view controller when login shows
        self.sideMenuMainViewController = MainViewController()
        self.sideMenuMainViewController.delegate = self
        self.sideMenuMainViewController.viewControllers = self.mainViewControllers()
    }
    
    func switchToState(state: RootViewControllerOption) {
        
        switch state {
            
        case .MainApp:
            self.removeChildViewControllerIfNecessary(self.onboardingManager)
            self.displayChildViewController(self.sideMenuMainViewController)
            
        case .Onboarding:
            
            self.removeChildViewControllerIfNecessary(self.sideMenuMainViewController)
            
            self.instantiateLoginViews()
            self.instantiateMainAppViews()
            
            self.displayChildViewController(self.onboardingManager)
            
            self.onboardingManager.startFromViewController(self)
        }
    }
    
    func displayChildViewController(viewController: UIViewController) {
        
        self.addChildViewController(viewController)
        viewController.view.frame = self.view.bounds
        
        self.view.addSubview(viewController.view)
        
        self.view.addConstraints([
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: viewController.view,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: viewController.view,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: viewController.view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(
                item: self.view,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: viewController.view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0)
            ])

        viewController.didMoveToParentViewController(self)
        
    }
    
    func removeChildViewControllerIfNecessary(viewController: UIViewController?) {
        
        if let viewController = viewController {
            
            viewController.view.removeFromSuperview()
            viewController.didMoveToParentViewController(nil)
        }
    }
    
    func setupLaunchImageView() {
        var imagesArray : Array <UIImage> = Array()
        
        for i in 0...55 {
            
            let image : UIImage? = UIImage(named: "YAMO_MARK_000" + String(format: "%02d", i))
            
            if let unwrappedImage = image {
                imagesArray.append(unwrappedImage)
            }
        }
        
        self.launchImageView.animationImages = imagesArray
        self.launchImageView.animationDuration = 3.0
        self.launchImageView.animationRepeatCount = 1
        self.launchImageView.startAnimating()
        NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(RootViewController.finishedLaunchAnimation(_:)), userInfo: nil, repeats: false)
    }
    
    func finishedLaunchAnimation(timer : NSTimer) {
        timer.invalidate()
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.launchImageView.alpha = 0.0
        }
        
        self.switchToState(.Onboarding)
    }

    // MARK: LaunchNavigationManagerDelegate
    
    func launchNavigationManagerDidFinish(launchNavigationManager: LaunchNavigationManager) {
        
        self.switchToState(.MainApp)
    }
    
    // MARK: SideMenuMainViewControllerDelegate
    
    func sideMenuMainViewControllerDidSelectLogoutButton(sideMenuMainViewController: SideMenuMainViewController) {
        
        UserService.sharedInstance().didLogout()
        
        self.switchToState(.Onboarding)
    }
}
