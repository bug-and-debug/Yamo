//
//  GetToKnowMeOnboardingViewController.swift
//  Yamo
//
//  Created by Vlad Buhaescu on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import Mantle

private let MinimumNumberOfRatedCards = 5

enum GetToKnowMeStyle : Int {
    case OnBoarding
    case SideMenu
    case MapOverlay
}

class GetToKnowMeOnboardingViewController: UIViewController, SideMenuChildViewController, UIPageViewControllerDelegate, RatingsViewDelegate, GetToKnowMePageViewControllerDelegate {
    
    weak var onboardingDelegate: LaunchNavigationViewControllerDelegate?
    
    var getToKnowMeStyle: GetToKnowMeStyle = .OnBoarding
    
    var venueResults : [VenueSearchSummary]?
    
    // MARK: - Private properties
    
    private let ratingsView : RatingsView = RatingsView()
    
    private let overlayView = GetToKnowMeOverlayView(frame: CGRect.zero)
    private let tapOnOverlayGesture = UITapGestureRecognizer()
    
    private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(UserServiceDefaultLocationLatitude, UserServiceDefaultLocationLongitude)
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)

    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttributedTitle(NSLocalizedString("Get To Know Me", comment: ""))
        
        self.pageViewController.delegate = self
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.view.addConstraints(self.contentConstrains())
        
        self.currentViewController.delegate = self
        self.nextViewController.delegate = self
        self.tempViewController.delegate = self
        
        self.ratingsView.starsCount = 5;
        self.ratingsView.delegate = self
        self.ratingsView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(ratingsView)
        self.view.addConstraints(self.ratingStarsViewConstriants())
        self.ratingsView.evenlySpaceStars()
        
        // Get and store user location for later usage
        UserService.sharedInstance().currentLocationForUser { (location, _) in
            self.currentLocation = location.coordinate
        }
        
        switch self.getToKnowMeStyle {
        case .OnBoarding:
            self.setupOnboardingUI()
        case .SideMenu:
            self.nextButton.hidden = true
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init()
        case .MapOverlay:
            self.navigationItem.hidesBackButton = false
            self.nextButton.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.artWorks.count == 0 {
            self.fetchSuggestions(presentPageAfterLoad: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.getToKnowMeStyle == .SideMenu && self.currentImageIndex > 0 {
    
            NSNotificationCenter.defaultCenter().postNotificationName(UserServiceGetToKnowMeRatingChangedNotification, object: nil)
        }
    }
    
    // MARK: - View Configuration
    
    private func setupOnboardingUI()  {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init()
        
        let textAttributes = [NSUnderlineStyleAttributeName: 1,
                              NSForegroundColorAttributeName: UIColor.yamoDarkGray()]
        let attributedTitle = NSAttributedString(string: NSLocalizedString("Finish", comment: ""),
                                                 attributes: textAttributes)
        
        self.nextButton.setAttributedTitle(attributedTitle, forState: .Normal)
        self.nextButton.userInteractionEnabled = false
        self.nextButton.enabled = false
        self.nextButton.alpha = 0.5
        self.nextButton.bringToFront()
        
        self.tapOnOverlayGesture.addTarget(self, action: #selector(removeView))
        self.tapOnOverlayGesture.numberOfTapsRequired = 1
        self.overlayView.startButton.addGestureRecognizer(tapOnOverlayGesture)
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.overlayView)
        
        self.view.addConstraints([
            NSLayoutConstraint(
                item: self.overlayView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: self.overlayView,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: self.overlayView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: self.overlayView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0)
            ])
    }
    
    @objc private func removeView()  {
        self.overlayView.removeFromSuperview()
    }
    
    // MARK: Constraints
    
    private func contentConstrains() -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(
                item: self.pageViewController.view,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: self.pageViewController.view,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: self.pageViewController.view,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: self.pageViewController.view,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0)
        ]
    }
    
    private func ratingStarsViewConstriants() -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint.init(
                item: self.ratingsView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: -56
            ),
            NSLayoutConstraint.init(
                item: self.ratingsView,
                attribute:.CenterX,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint.init(
                item: self.view,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self.ratingsView,
                attribute: .Width,
                multiplier: 1.0,
                constant: 163
            ),
            NSLayoutConstraint.init(
                item: self.ratingsView,
                attribute:.Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: 26
            )]
    }
    
    // MARK: Side Menu Titles
    
    var featureAvailability: SideMenuItemAvailability {
        return .RequiresSubscription
    }
    
    var preferredTitle: String! {
        get {
            return NSLocalizedString("Get To Know Me", comment: "")
        }
    }
    
    var preferredPremiumTitle: String! {
        get {
            return NSLocalizedString("Get To Know Me", comment: "")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func next(sender: AnyObject) {
        
        if let button = sender as? UIButton {
            
            button.enabled = false
        }
        
        if self.getToKnowMeStyle == .OnBoarding {
            self.fetchSuggestionsResults({ (error) in
                
                if let button = sender as? UIButton {
        
                    button.enabled = true
                }
                
                if let error = error {
                    
                    print("Error completing GTKM: \(error) ")
                }
                
            })
        }
    }
    
    // MARK: - Pages
    
    private var currentViewController = GetToKnowMePageViewController()
    private var nextViewController = GetToKnowMePageViewController()
    private var tempViewController = GetToKnowMePageViewController() // For prefetching
    
    private var artWorks = [ArtWork]()
    
    private var currentImageIndex: Int = 0
    
    private func presentCurrentPage() {
        guard self.artWorks.count > 0 else {
            UIAlertController.showAlert(inViewController: self,
                                        withTitle: NSLocalizedString("No Suggestions", comment: ""),
                                        message: NSLocalizedString("There are no suggestions for you just now, please try again later.", comment: ""),
                                        cancelButtonTitle: NSLocalizedString("Ok", comment: ""),
                                        destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (_, _, _) in
                                            if self.getToKnowMeStyle == .OnBoarding {
                                                self.finishViewController()
                                            }
            })
            return
        }
        
        if self.currentImageIndex >= self.artWorks.count {
            self.currentImageIndex = 0
        }
        
        if let _ = self.nextViewController.artWork {
            let temp = self.currentViewController
            self.currentViewController = self.nextViewController
            self.nextViewController = temp
        } else {
            let currentArtWork = self.artWorks[self.currentImageIndex]
            self.currentViewController.artWork = currentArtWork
        }
        
        // Prefetching in the temp view controller
        self.tempViewController.artWork = nil
        
        var nextImageIndex = self.currentImageIndex + 1
        
        if nextImageIndex >= self.artWorks.count {
            nextImageIndex = 0
        }
        
        let nextArtWork = self.artWorks[nextImageIndex]
        
        self.tempViewController.artWork = nextArtWork
        
        // disable the star rating, will enable once the next page diaplayed
        self.ratingsView.userInteractionEnabled = false
        
        // delay half seconds and push to current view controller
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.pageViewController.setViewControllers([self.currentViewController], direction: .Forward, animated: true) { (finished) in
                guard finished else {
                    return
                }
                
                self.ratingsView.resetEmptyStars()
                
                // get the prefetched temp view to next view
                let temp = self.nextViewController
                self.nextViewController = self.tempViewController
                self.tempViewController = temp
                
                self.ratingsView.userInteractionEnabled = true
                
                print("Get to know me page shown with current index \(self.currentImageIndex) and next index \(nextImageIndex)")
            }
        }
        
        // fetch in advance if artwork is 3 pages till the end
        if self.currentImageIndex == self.artWorks.count - 3 {
            self.fetchSuggestions(presentPageAfterLoad: false)
        }
    }
    
    // MARK: - GetToKnowMePageViewControllerDelegate
    
    func getToKnowMePageDidFailedLoading(controller: GetToKnowMePageViewController) {
        guard controller == self.currentViewController else {
            return
        }
        
        UIAlertController.showAlert(inViewController: self,
                                    withTitle: NSLocalizedString("Error", comment: ""),
                                    message: NSLocalizedString("Could not load the suggestion at this time, would you like to try again?", comment: ""),
                                    cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                                    destructiveButtonTitle: nil,
                                    otherButtonTitles: [NSLocalizedString("Retry", comment: ""), NSLocalizedString("Skip", comment: "")],
                                    tapBlock: { (_, action, _) in
                                        if action.style == .Cancel && self.getToKnowMeStyle == .OnBoarding {
                                            self.finishViewController()
                                        } else if action.title == NSLocalizedString("Retry", comment: "") {
                                            controller.reloadImage()
                                        } else if action.title == NSLocalizedString("Skip", comment: "") {
                                            self.currentImageIndex += 1
                                            self.presentCurrentPage()
                                        }
        })
    }
    
    // MARK: - RatingsViewDelegate
    
    private var ratedImagesCount: Int = 0
    
    func ratingsViewDidSelectedStar(selectedStar: Int) {
        // Post result to the server, if failed just ignore it
        if let uuidOfArtWork = self.currentViewController.artWork?.uuid.integerValue {
            let cardReply : CardReplyDTO = CardReplyDTO.init(artWorkID: uuidOfArtWork, rating: ratingsView.getSelectedRating())
            
            do {
                let parametrs: [NSObject : AnyObject] = try MTLJSONAdapter.JSONDictionaryFromModel(cardReply)
                
                APIClient.sharedInstance().postRateForCard(parametrs, successBlock: { (response) in
                    
                    }, failureBlock: { (theError, errorCode, stringError) in
                        print("failed with error \(theError.description) code \(errorCode)")
                })
            } catch {
                print("failed converting card reply object to json")
            }
            
            if self.getToKnowMeStyle == .OnBoarding {
                self.ratedImagesCount += 1
            }
        }
        
        // Handles the count and presnts next page
        self.currentImageIndex += 1
        
        self.presentCurrentPage()
        
        // Enable onboarding next button when exceeds the minimum number of rated cards
        if self.getToKnowMeStyle == .OnBoarding && (self.ratedImagesCount == self.artWorks.count || self.ratedImagesCount >= MinimumNumberOfRatedCards) {
            self.nextButton.userInteractionEnabled = true
            self.nextButton.enabled = true
            self.nextButton.alpha = 1
        }
    }
    
    // MARK: - Networking
    
    private var currentTimestamp = NSDate()
    
    func fetchSuggestions(presentPageAfterLoad presentPageAfterLoad: Bool) {
        if presentPageAfterLoad {
            self.showIndicator(true)
        }
        
        APIClient.sharedInstance().getToKnowMeSuggestionWithTimeStamp(self.currentTimestamp, successBlock: { (response) in
            if presentPageAfterLoad {
                self.showIndicator(false)
            }
            
            if var results = response as? [ArtWork] where results.count > 0 {
                self.artWorks.appendContentsOf(results)
                
                results.sortInPlace({ (first, second) -> Bool in
                    
                    if (first.updated.compare(second.updated) == .OrderedDescending) {
                        
                        return true
                    }
                    
                    return false
                })
                
                self.currentTimestamp = results.last!.created
                print("fetched \(results.count) suggestions makes total count \(self.artWorks.count)")
            } else {
                print("no more suggestions which total count \(self.artWorks.count)")
            }
            
            if presentPageAfterLoad {
                self.presentCurrentPage()
            }
            
        }) { (error, statusCode, context) in
            print("\(error) \(statusCode) \(context)")
            
            if presentPageAfterLoad {
                self.showIndicator(false)
            }
        }
    }
    
    func fetchSuggestionsResults(completion: ((error: NSError?) -> Void)?) {
        self.showIndicator(true)
        
        let location = self.currentLocation
        let filterSearchDTO = FilterSearchDTO()
        filterSearchDTO.latitude = location.latitude
        filterSearchDTO.longitude = location.longitude
        filterSearchDTO.miles = UserServiceDefaultSearchMilesRadius
        
        APIClient.sharedInstance().venueFilterSearchForMapWithFilterSearchDTO(filterSearchDTO, successBlock: { (result: [AnyObject]?) in
            
            guard let exhibitions = result as? [VenueSearchSummary] else {
                
                if let completion = completion {
                    
                    completion(error: nil)
                }
                
                return
            }
            
            self.venueResults = exhibitions
            self.finishViewController()
            
            print("Number of venues: \(exhibitions.count)")
            
            self.showIndicator(false)

            if let completion = completion {
                
                completion(error: nil)
            }
            
        }) { (error, statusCode, context) in
            
            
            print("\(error) \(statusCode) \(context)")
            self.finishViewController()
            self.showIndicator(false)

            if let completion = completion {
                
                completion(error: error)
            }
        }
    }
    
    func finishViewController() {
        if let delegate = self.onboardingDelegate {
            delegate.viewControllerDidFinish(self)
        } else {
            if let nextViewController = SubscriptionFlowCoordinator().nextViewForCurrentViewController(self) {
                self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
