//
//  ExploreListDataController.swift
//  Yamo
//
//  Created by Hungju Lu on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit


protocol ExploreListDataControllerDelegate: class {
    
    func exploreListDataController(controller: ExploreListDataController, didSelectVenue venue: VenueSearchSummary)
    func getCurrentDateFromCalendar() -> NSDate
}

class ExploreListDataController: NSObject, UITableViewDataSource, UITableViewDelegate {

    weak var delegate:ExploreListDataControllerDelegate?

    private var tableView: UITableView!
    
    private var exhibitionData: [VenueSearchSummary]? = []
    
    private var venueData: [Venue]? = []
    
    private var refreshControl: UIRefreshControl!
    
    private var exploreType: Int!;
    
    // MARK: - Initialization
    
    func initializeDataController(tableView tableView: UITableView) {
        self.setupTableView(tableView)
    }
    
    func setExploreType(type: Int) {
        self.exploreType = type;
    }
    
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .None
        tableView.allowsSelection = true
        
        tableView.estimatedRowHeight = ExploreListCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        // register table view cell classes
        tableView.registerNib(UINib(nibName: ExploreListCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExploreListCellNibName)
        
        self.reloadData()
    }
    
    internal func setupData(data: [VenueSearchSummary]?) {
        self.exhibitionData?.removeAll()
        
        let currentDate = self.delegate?.getCurrentDateFromCalendar()
        if currentDate == nil || data == nil {
            self.exhibitionData = data
        } else {
            self.exhibitionData = []
            for venue in data! {
                var isVenueAdded = true
                if venue.exhibitionInfoData != nil  {
                    if let endDate = venue.exhibitionInfoData.endDate {
                        if currentDate!.compare(endDate) == NSComparisonResult.OrderedDescending {
                            isVenueAdded = false
                        }
                    }
                }
                if isVenueAdded {
                    self.exhibitionData?.append(venue)
                }
            }
        }

        guard let tableView = self.tableView else {
            return;
        }
        
        tableView.reloadData()

    }
    
    func refresh(sender:AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(UserServiceRefreshExhibitionsNotification, object: nil)
        if refreshControl.refreshing {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Load
    
    func reloadData() {
        self.tableView.reloadData()
    }    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let exhibitionData = self.exhibitionData else {
            return 0
        }
        
        return exhibitionData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("------------- type --------\(self.exploreType)");
        if let cell = tableView.dequeueReusableCellWithIdentifier(ExploreListCellNibName) {
            
            if let cell = cell as? ExploreListCell, let exhibitionData = self.exhibitionData {
                let exhibition = exhibitionData[indexPath.row]
                
                //print("---------------------------\n");
                //print(exhibition);
                //print("----------------------------\n");
                let galleryName = (exhibition.galleryName != nil) ? exhibition.galleryName : ""
                                
                cell.configureView(tags: exhibition.displayTags,
                                   exhibitionName: exhibition.name,
                                   location: galleryName,
                                   relevanceRate: NSNumber(double: Double(exhibition.mapRelevance)),
                                   distance: NSNumber(double: Double(exhibition.distance)),
                                   exploreType: self.exploreType);
                
                if let url = exhibition.imageUrl {
                    cell.configureBackgroundImage(withURL: url)
                }
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return ExploreListCellDefaultHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let exhibitionData = self.exhibitionData {
            let exhibition = exhibitionData[indexPath.row]
            return ExploreListCellDefaultHeight + estimatedHeightForVenueName(exhibition.name) - 24.0
        }
        
        return ExploreListCellDefaultHeight
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let exhibitionData = self.exhibitionData {
            let exhibition = exhibitionData[indexPath.row]
            self.delegate?.exploreListDataController(self, didSelectVenue: exhibition)
            
            NSNotificationCenter.defaultCenter().postNotificationName(UserServiceShowShareButtonNotification, object: nil)
        }
    }
    
    func estimatedHeightForVenueName(exhibitionName: String) -> CGFloat {
        
        let nameParagraphStyle = NSMutableParagraphStyle()
        nameParagraphStyle.lineHeightMultiple = ParagraphStyleLineHeightMultipleForHeader
        let nameAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.TrianonCaptionExtraLight, size: 19.0),
                              NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 19.0),
                              NSForegroundColorAttributeName: UIColor.yamoText(),
                              NSParagraphStyleAttributeName: nameParagraphStyle]
        let attributedText = NSAttributedString(string: exhibitionName, attributes: nameAttributes)
        
        let size = CGSizeMake(UIScreen.mainScreen().bounds.size.width - (15.0 * 2), CGFloat.max) // 15.0 * 2 is the gapping from the storyboard
        let bounds = attributedText.boundingRectWithSize(size, options: [.UsesLineFragmentOrigin], context: nil)
        let height = bounds.height > 24.0 ? bounds.height : 24.0
        
        return height // + CGFloat(11 + 18 + 4 + 8 + 18 + 5 + 1) // the rest element heights from storyboard
    }
}
