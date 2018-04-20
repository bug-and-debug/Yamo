//
//  ExploreViewController.swift
//  Yamo
//
//  Created by Boris Yurkevich on 25/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import LOCPermissions_Swift
import Flurry_iOS_SDK

private enum ExploreViewState {
    case Map
    case List
}

let metersToMiles: Double = 1609.344
let defaultZoomLevel: UInt = 20

class ExploreViewController: UIViewController, SideMenuChildViewController, CLLocationManagerDelegate, ExploreDataControllerDelegate, ExploreMapViewControllerDelegate, ExploreListViewControllerDelegate, MapPlacesViewControllerDelegate, HelpOverlayViewControllerDelegate, SearchViewControllerDelegate, CalendarViewControllerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    /* --------- hans added --------- */
    @IBOutlet weak var lbl_favorite: UILabel!;
    @IBOutlet weak var v_favorite: UIView!;
    @IBOutlet weak var v_favorite_height: NSLayoutConstraint!;
    
    @IBOutlet weak var btn_date: UIButton!;
    @IBOutlet weak var btn_search: UIButton!;
    @IBOutlet weak var btn_close: UIButton!;
    //hans modified
    private var exploreType: Int?;
    
    private var spinner = UIActivityIndicatorView()
    private var currentViewState: ExploreViewState = .List
    private var currentChildViewController: UIViewController?
    private var exploreMapViewController = ExploreMapViewController(nibName: "ExploreMapViewController", bundle: nil)
    private var exploreListViewController = ExploreListViewController(nibName: "ExploreListViewController", bundle: nil)
    private var calendarViewController = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
    private let dataController: ExploreDataController = ExploreDataController()
    private var firstAppearance = true
    private var dateButton: UIButton!
    private let dateFormatter = NSDateFormatter()
    
    @IBAction func closeFullExhibition(sender: AnyObject) {
        exploreMapViewController.closeFullExhibition();
    }
    var currentDate = NSDate()
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    let overlayForGetToKnowMe = OverlayForGetToKnowMe()
    var animationDurationForView = NSTimeInterval()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleNotification), name: UserServiceUserTypeChangedNotification, object: nil)
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleNotification), name: UserServiceGetToKnowMeRatingChangedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleNotification), name: UserServiceRefreshExhibitionsNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleNotification), name: UserServiceNoInternetConnectionNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
        
        self.navigationController?.navigationBarHidden = true;
        self.btn_search.hidden = false;
        self.btn_close.hidden = true;
        
        if self.exploreType == 1 {
            /*
            dateButton = UIButton(type: .Custom)
            dateButton.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
            dateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            dateButton.setTitle(self.dateFormatter.stringFromDate(currentDate), forState: .Normal)
            dateButton.addTarget(self, action: #selector(self.clickOnDateButton), forControlEvents: .TouchUpInside)
            self.navigationItem.titleView = dateButton
            
            
            let btn_search: UIButton = UIButton()
            btn_search.setImage(UIImage(named: "search_icon"), forState: .Normal)
            btn_search.frame = CGRectMake(0, 0, 30, 30)
            btn_search.addTarget(self, action: #selector(self.gotoSearch), forControlEvents: .TouchUpInside)
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: btn_search), animated: true)
             */
            btn_date.setTitle(self.dateFormatter.stringFromDate(currentDate), forState: .Normal);
            btn_date.addTarget(self, action: #selector(self.clickOnDateButton), forControlEvents: .TouchUpInside);
            btn_search.addTarget(self, action: #selector(self.gotoSearch), forControlEvents: .TouchUpInside);
            
            
            self.v_favorite_height.constant = 0;
            self.v_favorite.hidden = true;
        }
        else if self.exploreType == 2 {
            btn_date.setTitle("Favourites", forState: .Normal)
        }
        
        self.edgesForExtendedLayout = .None
        
        // Setup Spinner
        self.spinner.activityIndicatorViewStyle = .Gray
        self.spinner.hidesWhenStopped = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.spinner)
        
        self.calendarViewController.delegate = self
        self.exploreListViewController.currentDate = currentDate
        self.exploreMapViewController.currentDate = currentDate
        
        self.displayView(state: self.currentViewState)
        self.dataController.delegate = self
        self.setupLocationPermission()
        
        // Might need to move this
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppearance {
            
            self.showHelpOverlayIfNeeded()
        }
        
        firstAppearance = false
    }
    
    func setExploreType(type: Int) {
        self.exploreType = type;
        exploreListViewController.setExploreType(self.exploreType!);
        self.dataController.setExploreType(type);
    }
    
    func gotoSearch() {
        print("goto search page");
        self.filterIconPressed();
    }
    
    
    // MARK : Help Overlay
    
    func showHelpOverlayIfNeeded() {
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("YamoHasLaunchedOnce"))  {
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "YamoHasLaunchedOnce")
            setupHelpOverlay()
            
        } else {
            
            if let dateLastShown = NSUserDefaults.standardUserDefaults().valueForKey("lastShownDate") {
                
                let x = NSDate().weeksAfterDate(dateLastShown as! NSDate)
                
                if  x > 1 {
                    self.getToKnowMeOverlaySetup()
                    let shownDate = NSDate()
                    NSUserDefaults.standardUserDefaults().setValue(shownDate, forKey: "lastShownDate")
                }
                
            } else {
                
                self.getToKnowMeOverlaySetup()
                let shownDate = NSDate()
                NSUserDefaults.standardUserDefaults().setValue(shownDate, forKey: "lastShownDate")
            }
            
        }
    }
    
    //MARK: Overlay setup
    
    func getToKnowMeOverlaySetup() {
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
        return
        
//        overlayForGetToKnowMe.translatesAutoresizingMaskIntoConstraints = false
//        overlayForGetToKnowMe.alpha = 0
//        view.addSubview(overlayForGetToKnowMe)
//        
//        UIView.animateWithDuration(0.5) {
//            self.overlayForGetToKnowMe.alpha = 1
//        }
//        
//        view.addConstraints([
//            NSLayoutConstraint(
//                item:overlayForGetToKnowMe
//                , attribute:NSLayoutAttribute.Top
//                , relatedBy:NSLayoutRelation.Equal
//                , toItem:view
//                , attribute:NSLayoutAttribute.Top
//                , multiplier:1.0
//                , constant:0
//            ),
//            NSLayoutConstraint(
//                item:overlayForGetToKnowMe
//                , attribute:NSLayoutAttribute.Leading
//                , relatedBy:NSLayoutRelation.Equal
//                , toItem:view
//                , attribute:NSLayoutAttribute.Leading
//                , multiplier:1.0
//                , constant:0
//            ),
//            NSLayoutConstraint(
//                item:overlayForGetToKnowMe
//                , attribute:NSLayoutAttribute.Trailing
//                , relatedBy:NSLayoutRelation.Equal
//                , toItem:view
//                , attribute:NSLayoutAttribute.Trailing
//                , multiplier:1.0
//                , constant:0
//            )
//            ])
//        
//        overlayForGetToKnowMe.addTheElements()
//        overlayForGetToKnowMe.dismissButtonForOverlay.addTarget(self, action: #selector(dismissOverlay), forControlEvents: UIControlEvents.TouchUpInside)
//        overlayForGetToKnowMe.getToKnowMeButton.addTarget(self, action: #selector(segueToGTKM), forControlEvents: UIControlEvents.TouchUpInside)
    }

    // Note: Modification from Sep 2016 - Change requests from Yamo
//    func segueToGTKM()  {
//        
//        guard UserService.sharedInstance().loggedInUser.userType == .Standard || UserService.sharedInstance().loggedInUser.userType == .Admin else {
//            
//            PaywallNavigationController.presentPaywall(inViewController: self, paywallDelegate: self)
//            
//            return
//        }
//        
//        let getToKnowMeVC = GetToKnowMeOnboardingViewController(nibName: "GetToKnowMeOnboardingViewController", bundle: nil)
//        getToKnowMeVC.getToKnowMeStyle = .MapOverlay
//        self.navigationController?.pushViewController(getToKnowMeVC, animated: true)
//    }
    
    func dismissOverlay()  {
        
        UIView.animateWithDuration(0.5, animations: {
            self.overlayForGetToKnowMe.alpha = 0.0
        }) { (finished) in
            if finished {
                self.overlayForGetToKnowMe.removeFromSuperview()
            }
        }
    }
    
    func dimissHelp(controller: UIViewController!) {
        
        if let dateLastShown = NSUserDefaults.standardUserDefaults().valueForKey("lastShownDate") {
            
            let x = NSDate().weeksAfterDate(dateLastShown as! NSDate)
            
            if  x > 1 {
                self.getToKnowMeOverlaySetup()
                let shownDate = NSDate()
                NSUserDefaults.standardUserDefaults().setValue(shownDate, forKey: "lastShownDate")
            }
            
        }
        
        if let exploreMapViewController = self.currentChildViewController as? ExploreMapViewController {
            
            exploreMapViewController.shouldShowImageForMap = false
        }
    }
    
    // MARK: - View Configuration
    
    private func setupHelpOverlay() {
        
        if let exploreMapViewController = self.currentChildViewController as? ExploreMapViewController {
            
            exploreMapViewController.shouldShowImageForMap = true
            
        }
        
        let helpOverlayVC = HelpOverlayViewController()
        helpOverlayVC.modalPresentationStyle = .Custom
        helpOverlayVC.modalTransitionStyle = .CrossDissolve
        helpOverlayVC.delegate = self
        // Setting X - Y - Width - Height for buttons based on Device Screen
        let standardMaskDiameter : CGFloat = 44
        // let navigationBarOffset : CGFloat = (self.navigationController != nil ? 64.0 : 0.0)
        
        let paddingNavBarItem = helpOverlayVC.view.frame.height == 736 ? standardMaskDiameter * 0.28 : standardMaskDiameter * 0.18
        
        // Setting Mask for BarButtons
        // Note: Modification from Sep 2016 - Change requests from Yamo
        // let sideIcon = CGRectMake(paddingNavBarItem - 1, 19, standardMaskDiameter, standardMaskDiameter)
        let filterIcon = CGRectMake(helpOverlayVC.view.frame.width - paddingNavBarItem - standardMaskDiameter + 1, 72, standardMaskDiameter, standardMaskDiameter)
        
        // Setting Mask for Bottons on bottom
        // let locationIcon =  CGRectMake(8 ,helpOverlayVC.view.frame.height - (standardMaskDiameter + 8), standardMaskDiameter, standardMaskDiameter)
        let listIcon = CGRectMake(helpOverlayVC.view.frame.width - (standardMaskDiameter + 8),helpOverlayVC.view.frame.height - (standardMaskDiameter + 8), standardMaskDiameter, standardMaskDiameter)
        
        // Setting Mask for Button in the center
        // let centerIcon = CGRectMake((self.view.bounds.size.width - standardMaskDiameter) * 0.5, ((self.view.bounds.size.height - standardMaskDiameter) * 0.5) + navigationBarOffset, standardMaskDiameter, standardMaskDiameter);
        
        var views = Array<UIView>()
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
        // let menuView = helpOverlayVC.cutOutViews([NSValue(CGRect: sideIcon)], withCornerRadius: 30, title: NSLocalizedString("Menu", comment: "Help Overlay"), detail: NSLocalizedString("Click the top left hamburger icon to access the main menu.", comment: "Help Overlay"))
        let searchView = helpOverlayVC.cutOutViews([NSValue(CGRect: filterIcon)], withCornerRadius: 30, title: NSLocalizedString("Search and filter", comment: "Help Overlay"), detail: NSLocalizedString("Click the top right lens icon to access the filters and search exhibitions.", comment: "Help Overlay"))
        // let locationView = helpOverlayVC.cutOutViews([NSValue(CGRect: locationIcon)], withCornerRadius: 30, title: NSLocalizedString(NSLocalizedString("Location", comment: "Help Overlay"), comment: "Help Overlay"), detail: NSLocalizedString("Touch the location icon in the bottom left hand corner to put your current location at the centre of your search results.", comment: "Help Overlay"))
        // let listModeView = helpOverlayVC.cutOutViews([NSValue(CGRect: listIcon)], withCornerRadius: 30, title: NSLocalizedString("Go to list mode", comment: "Help Overlay"), detail: NSLocalizedString("Touch the bottom right hamburger icon to access list view.", comment: "Help Overlay"))
        let mapModeView = helpOverlayVC.cutOutViews([NSValue(CGRect: listIcon)], withCornerRadius: 30, title: NSLocalizedString("Go to map mode", comment: "Help Overlay"), detail: NSLocalizedString("Touch the bottom right map icon to access map view.", comment: "Help Overlay"))
        // let centerView = helpOverlayVC.cutOutViews([NSValue(CGRect: centerIcon)], withCornerRadius: 30, title: NSLocalizedString("Change your location", comment: "Help Overlay"), detail: NSLocalizedString("Touch the dot in the centre of the map to change your location.", comment: "Help Overlay"))
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
        // views.append(menuView)
        views.append(searchView)
        // views.append(locationView)
        // views.append(listModeView)
        views.append(mapModeView)
        // views.append(centerView)
        
        helpOverlayVC.cutouts = views as [AnyObject]
        
        presentViewController(helpOverlayVC, animated: true, completion: nil)
    }
    
    private func displayView(state state: ExploreViewState) {
        
        if let controller = self.currentChildViewController {
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
        
        self.currentChildViewController = nil
        
        var controllerToAdd: UIViewController
        var viewToAdd: UIView
        var options: UIViewAnimationOptions
        switch state {
        case .Map:
            
            self.animationDurationForView = 0.3
            exploreMapViewController.delegate = self
            exploreMapViewController.animationDuration = self.animationDurationForView
            controllerToAdd = exploreMapViewController
            viewToAdd = controllerToAdd.view
            options = .TransitionFlipFromLeft
            
            
        case .List:
            
            self.animationDurationForView = 0.0
            exploreListViewController.delegate = self
            exploreListViewController.shouldUpdateDataController()
            controllerToAdd = exploreListViewController
            viewToAdd = controllerToAdd.view
            options = .TransitionFlipFromRight
        }
        
        self.currentChildViewController = controllerToAdd
        self.addChildViewController(controllerToAdd)
        
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        viewToAdd.hidden = true
        
        self.containerView.addSubview(viewToAdd)
        self.containerView.pinView(viewToAdd)
        
        UIView.transitionWithView(self.containerView, duration: 0.6, options: options, animations: {
            viewToAdd.hidden = false
        }) { (finished) in
            
        }
        
        self.currentViewState = state
    }
    
    // MARK: - Actions
    
    func clickOnDateButton(button: UIButton) {
        self.presentViewController(calendarViewController, animated: false, completion: nil)
    }
    
    func filterIconPressed() {
        
        var searchText = ""
        if let dtoSearchString = self.dataController.filterSearchDTO?.search {
            searchText = dtoSearchString
        }
        
        let controller = SearchViewController(currentSearchText: searchText)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func crossIconPressed(sender: UIBarButtonItem) {
        
        self.exploreMapViewController.mapViewState = .Hidden        
    }
    
    // MARK: Notifications
    
    func handleNotification(notification: NSNotification) {
        
        if (notification.name == UserServiceRefreshExhibitionsNotification) {
            
            // Need to remove the annotations on the map as well
            self.dataController.invalidateCache()
            //self.updateChild()
            self.removeMapAnnotations()
            
            //self.spinner.startAnimating()
            UserService.sharedInstance().currentLocationForUser({ (location, _) in
                self.updateDataForLocation(location, miles: 100 * 1000 / metersToMiles, zoomLevel: 20, shouldClearCache: false)
            })
        } else if (notification.name == UserServiceNoInternetConnectionNotification) {
            UIAlertController.showAlert(inViewController: self,
                                        withTitle: NSLocalizedString("Error", comment: ""),
                                        message: NSLocalizedString("Seems you are not connected to Internet", comment: ""),
                                        cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                                        destructiveButtonTitle: NSLocalizedString("Try Again", comment: ""),
                                        otherButtonTitles: nil,
                                        tapBlock: { (_, action, _) in
                                            if action.style == .Destructive {
                                                NSNotificationCenter.defaultCenter().postNotificationName(UserServiceRefreshExhibitionsNotification, object: nil)
                                            }
            })
        }
    }
    
    // MARK: - Helpers
    
    func setupLocationPermission() {
        
        if PermissionRequestLocation.sharedInstance.currentStatus != .SystemPromptAllowed && PermissionRequestLocation.sharedInstance.currentStatus != .DidNotAsk  {
            
            PermissionRequestLocation.sharedInstance.requestPermission(inViewController: self) { (outcome, userInfo) in
                
                self.spinner.startAnimating()
                UserService.sharedInstance().currentLocationForUser({ (location, _) in
                    
                    self.updateDataForLocation(location, miles: 100 * 1000 / metersToMiles, zoomLevel: 20, shouldClearCache: false)
                })
            }
        } else {
            
            self.spinner.startAnimating()
            UserService.sharedInstance().currentLocationForUser({ (location, _) in
                
                self.updateDataForLocation(location, miles: 100 * 1000 / metersToMiles, zoomLevel: 20, shouldClearCache: false)
            })
        }
    }
    
    func updateDataForLocation(location: CLLocation, miles: Double, zoomLevel: UInt, shouldClearCache: Bool) {
        
        self.spinner.startAnimating()
        

        
        self.dataController.refreshDataForLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, miles: miles, zoomLevel: zoomLevel, shouldClearCache: false)
        
        if currentChildViewController is ExploreListViewController {
            guard let exploreListViewController = currentChildViewController as! ExploreListViewController? else {
                return
            }
            exploreListViewController.prevNewCoordinate = location.coordinate
        }
    }
    
    func updateChild() {
        
        // Notify map and list that new data is available
        if currentChildViewController is ExploreListViewController {
            guard let exploreListViewController = currentChildViewController as! ExploreListViewController? else {
                return
            }
            exploreListViewController.shouldUpdateDataController()
        }
        
        if currentChildViewController is ExploreMapViewController {
            guard let exploreMapViewController = currentChildViewController as! ExploreMapViewController? else {
                return
            }
            exploreMapViewController.shouldUpdateDataController()
        }
    }
    
    func removeMapAnnotations() {
        
        if currentChildViewController is ExploreMapViewController {
            guard let exploreMapViewController = currentChildViewController as! ExploreMapViewController? else {
                return
            }
            exploreMapViewController.removeMapAnnotations()
        }
    }
    
    // MARK: ExploreDataControllerDelegate
    
    func exploreDataControllerDidFetchNewData(controller: ExploreDataController) {
        self.updateChild()
        
        // Update Spinner
        self.spinner.stopAnimating()
    }
    
    func exploreDataControllerDidStartFetchingVenue(controller: ExploreDataController) {
        self.showIndicator(true)
    }
    
    func exploreDataControllerDidEndFetchingVenue(controller: ExploreDataController) {
        self.showIndicator(false)
        
    }
    
    func exploreLoadDataDidFinished(count: Int) {
        lbl_favorite.text = NSString.localizedStringWithFormat("%d Favourites", count) as String;
    }
    
    func exploreDataControllerDidRequireShowingAlert(alert: UIAlertController) {
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: ExploreMapViewControllerDelegate
    
    func exploreMapViewController(viewController: ExploreMapViewController!, didUpdateToNewLocation location: CLLocation!, zoomLevel: UInt, shouldClearCache: Bool) {
        
        // self.updateDataForLocation(location, miles: Double(viewController.currentScaleMeters) / metersToMiles, zoomLevel: zoomLevel, shouldClearCache: shouldClearCache)
        self.updateDataForLocation(location, miles: 100 * 1000 / metersToMiles, zoomLevel: zoomLevel, shouldClearCache: shouldClearCache)
    }
    
    func exploreMapViewControllerDidPressShareButton(viewController: ExploreMapViewController!) {
        
        self.filterIconPressed()
    }
    
    func exploreMapViewControllerDidPressListButton(viewController: ExploreMapViewController!) {
        
        self.displayView(state: .List)
    }
    
    func exploreMapViewControllerDidShowFullExhibition(viewController: ExploreMapViewController!) {
        
        self.btn_search.hidden = true;
        self.btn_close.hidden = false;
    }
    
    func exploreMapViewControllerDidHideFullExhibition(viewController: ExploreMapViewController!) {
        
        self.btn_search.hidden = false;
        self.btn_close.hidden = true;
    }
    
    func exploreMapViewControllerConsultParentForData(viewController: ExploreMapViewController!) -> [VenueSearchSummary]! {
        
        if let venueSummaries = self.dataController.venuesDataForMap {
            return venueSummaries
        } else {
            return []
        }
    }
    
    func exploreMapViewControllerDidPresentedFullExhibitionDetails(venueSearchSummary: VenueSearchSummary!) {
        //guard let venueSummary = venueSearchSummary else {
        //    return
        //}
        
        let animation = CATransition()
        animation.duration = 0.1
        animation.type = kCATransitionFade
        
        self.navigationController?.navigationBar.layer.addAnimation(animation, forKey: "ExploreFade")
        
        NSNotificationCenter.defaultCenter().postNotificationName(UserServiceShowShareButtonNotification, object: nil)
        
        //self.setAttributedTitle(venueSummary.name)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "IcondarkXdisabled"), style: .Plain, target: self, action: #selector(crossIconPressed(_:)))
    }
    
    func exploreMapViewControllerDidExitFullExhibitionDetails() {
        
        let animation = CATransition()
        animation.duration = 0.1
        animation.type = kCATransitionFade
        
        self.navigationController?.navigationBar.layer.addAnimation(animation, forKey: "ExploreFade")
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // MARK: ExploreListViewControllerDelegate
    
    func exploreListViewControllerDidPressSearchButton(viewController: ExploreListViewController) {
        
        self.filterIconPressed()
    }
    
    func exploreListViewControllerDidPressMapButton(viewController: ExploreListViewController) {
        
        self.displayView(state: .Map)
    }
    
    func exploreListViewController(controller: ExploreListViewController, didUpdateToNewLocation location: CLLocation, zoomLevel: UInt, shouldClearCache: Bool) {
        
        // self.updateDataForLocation(location, miles: Double(controller.currentScaleMeters) / metersToMiles, zoomLevel: zoomLevel, shouldClearCache: shouldClearCache)
        self.updateDataForLocation(location, miles: 100 * 1000 / metersToMiles, zoomLevel: zoomLevel, shouldClearCache: shouldClearCache)
    }
    
    func exploreListViewControllerConsultParentForData() -> [VenueSearchSummary]? {
        
        return self.dataController.venuesDataForList
    }
    
    func exploreListViewController(controller: ExploreListViewController, didSelectedVenue venue: VenueSearchSummary) {
        
        self.displayView(state: .Map)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.61 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.exploreMapViewController.selectVenue(venue)
        }
    }
    
    // MARK: MapPlacesViewControllerDelegate
    
    func mapPlacesViewController(controller: MapPlacesViewController!, didSelectLocation location: RoutePlannerInterface!) {
        
        let newLocation = CLLocation(latitude: location.coordinate().latitude, longitude: location.coordinate().longitude)
        
        self.updateDataForLocation(newLocation, miles: 100 * 1000 / metersToMiles, zoomLevel: 50, shouldClearCache: false)
    }
    
    // MARK: - Side Menu Titles
    
    var featureAvailability: SideMenuItemAvailability {
        return .AlwaysAvailable
    }
    
    var preferredTitle: String! {
        get {
            return NSLocalizedString("Explore", comment: "")
        }
    }
    
    var preferredPremiumTitle: String! {
        get {
            return NSLocalizedString("Explore", comment: "")
        }
    }
    
    // MARK: - SearchViewControllerDelegate
    
    func searchViewController(controller: SearchViewController!, currentFilter filterSearchDTO: FilterSearchDTO!, didModify: Bool) {
        
        self.dataController.filterSearchDTO = filterSearchDTO
        
        if didModify {
            // Need to remove the annotations on the map as well
            self.dataController.invalidateCache()
            self.updateChild()
            self.removeMapAnnotations()
        }
        
        self.spinner.startAnimating()
        UserService.sharedInstance().currentLocationForUser({ (location, _) in
            self.updateDataForLocation(location, miles: 100 * 1000 / metersToMiles, zoomLevel: 20, shouldClearCache: false)
        })
        
    }
    
    // MARK: - CalendarViewControllerDelegate
    
    func setCurrentDateFromCalendar(date: NSDate) {
        //hans modified
        Flurry.logEvent("Calendar");
        //
        self.currentDate = date
        btn_date.setTitle(self.dateFormatter.stringFromDate(self.currentDate), forState: .Normal)
        
        self.exploreListViewController.currentDate = self.currentDate
        self.exploreMapViewController.currentDate = self.currentDate
        self.updateChild()
    }
}

extension ExploreViewController: PaywallNavigationViewControllerDelegate {
    
    func paywallDidFinishedSubscription(hasSubscription: Bool) {
        
        self.dismissViewControllerAnimated(true) {
            
            guard hasSubscription == true else {
                
                return
            }
            
            self.dismissOverlay()
            let getToKnowMeVC = GetToKnowMeOnboardingViewController(nibName: "GetToKnowMeOnboardingViewController", bundle: nil)
            getToKnowMeVC.getToKnowMeStyle = .MapOverlay
            self.navigationController?.pushViewController(getToKnowMeVC, animated: true)
        }
    }
    
}
