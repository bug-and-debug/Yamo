//
//  ExploreListViewController.swift
//  Yamo
//
//  Created by Hungju Lu on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
let kMinScaleMeters: CGFloat = 50.0
let kMaxScaleMeters: CGFloat = 100000.0
let kDefaultScaleMeters: CGFloat = 500.0

protocol ExploreListViewControllerDelegate: class {
    
    func exploreListViewControllerDidPressSearchButton(viewController: ExploreListViewController)
    func exploreListViewControllerDidPressMapButton(viewController: ExploreListViewController)
    func exploreListViewController(controller: ExploreListViewController, didUpdateToNewLocation location: CLLocation, zoomLevel: UInt, shouldClearCache: Bool)
    func exploreListViewControllerConsultParentForData() -> [VenueSearchSummary]?
    func exploreListViewController(controller: ExploreListViewController, didSelectedVenue venue: VenueSearchSummary)
}

class ExploreListViewController: UIViewController, ExploreListDataControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goToMapButton: UIButton!
    
    weak var delegate:ExploreListViewControllerDelegate?
    
    private var dataController: ExploreListDataController?
    
    var prevNewCoordinate: CLLocationCoordinate2D?
    
    var currentScaleMeters: CGFloat = kDefaultScaleMeters
    
    var currentDate: NSDate?
    
    var exploreType: Int!;
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.dataController = ExploreListDataController()
        self.dataController!.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hans modified
        Flurry.logEvent("Browse-Exhibition");
        //
        self.dataController?.initializeDataController(tableView: self.tableView)
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        self.locationManager.delegate = self
        
        self.prevNewCoordinate = nil
        
        if PermissionRequestLocation.sharedInstance.currentStatus != .SystemPromptAllowed {
            
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            
            self.locationManager.startUpdatingLocation()
        }
        
        if exploreType == 2 {
            goToMapButton.hidden = true;
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBarHidden = true;
        if self.exploreType == 2 {
            NSNotificationCenter.defaultCenter().postNotificationName(UserServiceRefreshExhibitionsNotification, object: nil)
        }
    }
    
    func setExploreType(type: Int) {
        exploreType = type;
        self.dataController?.setExploreType(type);
    }
    
    // MARK: Public
    
    internal func shouldUpdateDataController() {
        
        self.dataController?.setupData(self.delegate?.exploreListViewControllerConsultParentForData())
    }
    
    // MARK: - Location
    
    let locationManager = CLLocationManager()

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if PermissionRequestLocation.sharedInstance.currentStatus == .SystemPromptAllowed {
            
            if status == .AuthorizedWhenInUse {
                manager.startUpdatingLocation()
            } else {
                manager.requestWhenInUseAuthorization()
            }
        } else {
            
            // use default location
            
            let location = CLLocationCoordinate2DMake(UserServiceDefaultLocationLatitude, UserServiceDefaultLocationLongitude)
            
            self.didUpdateLocationCoordinate(location, shouldClearCache: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        manager.stopUpdatingLocation()
        
        var bIsNewLocation:Bool = true
        if self.prevNewCoordinate != nil {
            if (self.prevNewCoordinate?.latitude == newLocation.coordinate.latitude && self.prevNewCoordinate?.longitude == newLocation.coordinate.longitude) {
                bIsNewLocation = false
            }
        }
        
        if bIsNewLocation {
            self.prevNewCoordinate = newLocation.coordinate
            self.didUpdateLocationCoordinate(newLocation.coordinate, shouldClearCache: true)
        }
    }
    
    func didUpdateLocationCoordinate(coordinate: CLLocationCoordinate2D, shouldClearCache: Bool) {
        
        let scaleMeters = min(max(kDefaultScaleMeters, kMinScaleMeters), kMaxScaleMeters)
        let zoomLevel: Int = Int(scaleMeters) / 1000
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        self.delegate?.exploreListViewController(self, didUpdateToNewLocation:location, zoomLevel: UInt(zoomLevel), shouldClearCache: shouldClearCache)
    }
    
    // MARK: - ExploreListDataControllerDelegate
    
    func exploreListDataController(controller: ExploreListDataController, didSelectVenue venue: VenueSearchSummary) {
        
//        self.delegate?.exploreListViewController(self, didSelectedVenue: venue)
        
        // Note: Modification from Sep 2016 - Change requests from Yamo
        let controller = ExhibitionInfoViewController(nibName: "ExhibitionInfoViewController", bundle: nil)
        controller.venueSummary = venue
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getCurrentDateFromCalendar() -> NSDate {
        return self.currentDate!
    }
    
    @IBAction func handleDidPressGoToSearchButton(sender: AnyObject) {
        
        self.delegate?.exploreListViewControllerDidPressSearchButton(self)
    }
    
    @IBAction func handleDidPressGoToMapButton(sender: AnyObject) {
        
        self.delegate?.exploreListViewControllerDidPressMapButton(self)
    }
}
