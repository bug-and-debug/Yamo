//
//  ExhibitionInfoTableViewController.swift
//  Yamo
//
//  Created by Hungju Lu on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

@objc public protocol ExhibitionInfoViewControllerDelegate: class {
    
    func exhibitionInfoViewControllerDidPullDown(viewController: ExhibitionInfoViewController)
}

public class ExhibitionInfoViewController: UIViewController, ExhibitionInfoDataControllerDelegate {

    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var v_topbar: UIView!
    
    @IBOutlet weak var topbar_height: NSLayoutConstraint!
    var venueSummary: VenueSearchSummary? {
    
        didSet {
            
            self.dataController.venueSummary = venueSummary
            self.venueUUID = venueSummary?.uuid
        }
    }
    
    var venueUUID: NSNumber? {
        didSet {
         
            if (self.venueSummary != nil) {
                
                self.dataController.venueSummary = self.venueSummary
            }
        }
    }
    
    var scrollViewShouldScroll: Bool = true {
        didSet {
            if let tableView = self.tableView {
                tableView.scrollEnabled = scrollViewShouldScroll.boolValue
            }
        }
    }
    
    var estimatedExhibitionSummaryHeight: CGFloat {
        if let venueSummary = self.venueSummary {
            return self.dataController.estimateHeightForSummaryCell(venueSummary);
        } else {
            return ExhibitionInfoSummaryCellDefaultHeight
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    public weak var delegate:ExhibitionInfoViewControllerDelegate?
    
    private let dataController = ExhibitionInfoDataController()
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ExhibitionInfoViewController.handleUserTypeDidChange),
                                                         name: UserServiceUserTypeChangedNotification,
                                                         object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAttributedTitle(NSLocalizedString("Exhibition Info", comment: ""))
        
        self.tableView.scrollEnabled = self.scrollViewShouldScroll
        
        self.dataController.initializeDataController(tableView: self.tableView, venueSummary: self.venueSummary, venueUUID: self.venueUUID)
        
        self.dataController.delegate = self
        
        self.handleUserTypeDidChange()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.setNavigationBarStyleOpaque()
        
        self.dataController.reloadData()
        
        self.showUpArrow(false, animated: false);
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBarHidden = false;
    }
    
    func exhibitionShouldEnableScroll(enable: Bool) {
        self.scrollViewShouldScroll = enable
    }
    
    func handleUserTypeDidChange() {
        
        self.dataController.userIsGuest = UserService.sharedInstance().loggedInUser.userType == UserRoleType.Guest
    }
    
    func showUpArrow(shown: Bool, animated: Bool) {
        
        if animated {
            
            UIView .animateWithDuration(0.3, animations: { 
                
                self.upArrowImageView.alpha = shown ? 1.0 : 0.0
            })
            
        } else {
            
            self.upArrowImageView.alpha = shown ? 1.0 : 0.0
        }
    }
    
    func showTopbar(shown: Bool, animated: Bool) {

        self.view.layoutIfNeeded()
        
        var h:CGFloat = 0.0;
        if shown {
            h = 60.0;
            v_topbar.hidden = false;
            
        } else {
            h = 0.0
            v_topbar.hidden = true;
        }
        
        UIView.animateWithDuration(Double(0.1), animations: {
            self.topbar_height.constant = h;
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(position: CGPoint, animated: Bool) {
        
        self.tableView.setContentOffset(position, animated: animated)
    }
    
    // MARK: - ExhibitionInfoDataControllerDelegate
    
    func exhibitionInfoDataController(dataController: ExhibitionInfoDataController, didRequireShowingPhotoWithIndex index: Int, inAllPhotos allPhotoURLs: [String]) {
        let controller = PhotoViewerViewController()
        controller.photoURLs = allPhotoURLs
        controller.currentIndex = index
        
        let navigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func exhibitionInfoDataController(dataController: ExhibitionInfoDataController, didRequireRouteToVenue venue: Venue) {
        let step = RouteStep()
        step.sequenceOrder = NSNumber(integer: 0)
        step.venue = venue
        
        let route = Route()
        route.steps = [step]
        if let loggedInUser = UserService.sharedInstance().loggedInUser {
            route.userId = loggedInUser.uuid
        }
        
        let controller = RoutePlannerViewController(route: route)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func exhibitionInfoDataController(dataController: ExhibitionInfoDataController, didSelectSimilarVenueWithId venueId: NSNumber) {
        
        let exhibitionInfoViewController = ExhibitionInfoViewController(nibName: "ExhibitionInfoViewController", bundle: nil)
        exhibitionInfoViewController.venueUUID = venueId
        self.navigationController?.pushViewController(exhibitionInfoViewController, animated: true)
        /*
         
         ExhibitionInfoViewController *exhibitionInfoViewController = [[ExhibitionInfoViewController alloc] initWithNibName:@"ExhibitionInfoViewController" bundle:nil];
         exhibitionInfoViewController.venueUUID = notification.associatedVenue;
         
         [self.navigationController pushViewController:exhibitionInfoViewController animated:YES];
 */
    }
    
    func exhibitionInfoDataControllerDidPullDown(dataController: ExhibitionInfoDataController) {
        
        guard let unwrappedDelgate = self.delegate else {
            return
        }
        
        self.exhibitionShouldEnableScroll(false)
        unwrappedDelgate.exhibitionInfoViewControllerDidPullDown(self)
    }
    
    func exhibitionInfoDataControllerDidRequireShowingAlert(alert: UIAlertController) {
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func exhibitionInfoDataControllerDidStartFetchingVenue(dataController: ExhibitionInfoDataController) {
        self.showIndicator(true)
    }
    
    func exhibitionInfoDataControllerDidEndFetchingVenue(dataController: ExhibitionInfoDataController) {
        self.showIndicator(false)
    }
    
    func exhibitionInfoDataControllerShareVenue(dataController: ExhibitionInfoDataController) {
        
        // image to share
        //let image = UIImage(named: "Image")
        let text = (self.venueSummary?.name)! + " at " + (self.venueSummary?.galleryName)! + " gallery. Find out more on the gowithYamo app https://itunes.apple.com/gb/app/gowithyamo/id1131183289?mt=8"
        
        // set up activity view controller
        let dataToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
    }
}
