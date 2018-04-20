//
//  ExhibitionInfoDataController.swift
//  Yamo
//
//  Created by Hungju Lu on 25/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import CoreLocation
import UIAlertController_LOCExtensions
import Flurry_iOS_SDK

enum AttributeContext: Int {
    
    case Default, EntryFee
}

struct ExhibitionInfoDetailData {
    var detailString = ""
    var context = AttributeContext.Default
    
    init(detailString: String, context: AttributeContext) {
        
        self.detailString = detailString
        self.context = context
    }
}

let ExhibitionSimilarExhibitionsSection = 1

@objc protocol ExhibitionInfoDataControllerDelegate: class {
    
    func exhibitionInfoDataController(dataController: ExhibitionInfoDataController, didRequireRouteToVenue venue: Venue)
    func exhibitionInfoDataController(dataController: ExhibitionInfoDataController, didRequireShowingPhotoWithIndex: Int, inAllPhotos: [String])
    func exhibitionInfoDataController(dataController: ExhibitionInfoDataController, didSelectSimilarVenueWithId venueId: NSNumber)
    func exhibitionInfoDataControllerDidPullDown(dataController: ExhibitionInfoDataController)
    func exhibitionInfoDataControllerDidRequireShowingAlert(alert: UIAlertController)
    func exhibitionInfoDataControllerDidStartFetchingVenue(dataController: ExhibitionInfoDataController)
    func exhibitionInfoDataControllerDidEndFetchingVenue(dataController: ExhibitionInfoDataController)
    func exhibitionInfoDataControllerShareVenue(dataController: ExhibitionInfoDataController);
}

class ExhibitionInfoDataController: NSObject, UITableViewDataSource, UITableViewDelegate, ExhibitionInfoCellDelegate, ExhibitionInfoPhotoWallDataControllerDelegate {
    
    weak var delegate:ExhibitionInfoDataControllerDelegate?
    let dateFormatter = NSDateFormatter()
    
    var userIsGuest = true {
        
        didSet {
            
            self.cachedHeightForRow[1] = self.userIsGuest ? 0 : ExhibitionInfoFavouriteCellDefaultHeight;
            
            if self.tableView != nil {
                self.reloadData()
            }
        }
    }
    
    var venueSummary: VenueSearchSummary? {
        
        didSet {
            
            if let summary = self.venueSummary {
                self.venueUUID = summary.uuid
            }
        }
    }
    
    var venueUUID: NSNumber? {
        
        didSet {
            
            if self.tableView != nil {
                
                self.reloadData()
            }
        }
    }
    
    private var tableView: UITableView!
    
    private var exhibitionData: Venue?
    
    // MARK: - Sub data controllers
    
    private var photoWallDataController: ExhibitionInfoPhotoWallDataController!
    
    // MARK: - Cache data
    
    private var cachedHeightForRow: [Int: CGFloat] =
        [0: ExhibitionInfoSummaryCellDefaultHeight,
         1: ExhibitionInfoFavouriteCellDefaultHeight,
         2: ExhibitionInfoSlideshowCellDefaultHeight,
         3: ExhibitionInfoDetailsCellDefaultHeight,
         4: ExhibitionInfoMapCellDefaultHeight,
         5: ExhibitionInfoPhotoWallCellDefaultHeight]
    
    private var dataUpdatedFlagForRow: [Int: Bool] =
        [0: false,
         1: false,
         2: false,
         3: false,
         4: false,
         5: false]
    
    private var cachedExhibitionInfoSlideshowCurrentPageIndex: Int = 0
    
    private var cachedExhibitionInfoDetailsAboutExpended: Bool = false
    
    private var cachedExhibitionInfoDetailsSelectionState: ExhibitionInfoDetailsSelectionState = .Details
    
    // MARK: - Initialize
    
    override init() {
        super.init()
        
        self.photoWallDataController = ExhibitionInfoPhotoWallDataController()
        self.photoWallDataController.delegate = self
    }
    
    func initializeDataController(tableView tableView: UITableView, venueSummary: VenueSearchSummary?, venueUUID: NSNumber?) {
        self.tableView = tableView
        self.venueSummary = venueSummary
        
        if let summary = venueSummary {
            self.venueUUID = summary.uuid
        } else {
            self.venueUUID = venueUUID
        }
        
        self.dateFormatter.dateStyle = .LongStyle
        self.dateFormatter.timeStyle = .NoStyle
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 1, 1))
        
        // register table view cell classes
        tableView.registerNib(UINib(nibName: ExhibitionInfoSummaryCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExhibitionInfoSummaryCellNibName)
        
        tableView.registerNib(UINib(nibName: ExhibitionInfoFavouriteCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExhibitionInfoFavouriteCellNibName)
        
        tableView.registerNib(UINib(nibName: ExhibitionInfoSlideshowCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExhibitionInfoSlideshowCellNibName)
        
        tableView.registerNib(UINib(nibName: ExhibitionInfoDetailsCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExhibitionInfoDetailsCellNibName)
        
        tableView.registerNib(UINib(nibName: ExhibitionInfoMapCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExhibitionInfoMapCellNibName)
        
        tableView.registerNib(UINib(nibName: ExhibitionInfoPhotoWallCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExhibitionInfoPhotoWallCellNibName)
        
        tableView.registerNib(UINib(nibName: ExhibitionSimilarVenueHeaderViewNibName, bundle: nil),
                              forHeaderFooterViewReuseIdentifier: ExhibitionSimilarVenueHeaderViewNibName)
        
        tableView.registerNib(UINib(nibName: ExhibitionSimilarVenueTableViewCellNibName, bundle: nil),
                              forCellReuseIdentifier: ExhibitionSimilarVenueTableViewCellNibName)
        
        self.reloadData()
    }
    
    // MARK: - Load
    
    func reloadData() {
        guard self.venueSummary != nil || self.venueUUID != nil else {
            return
        }
        self.tableView.reloadData()
        
        if self.venueSummary != nil && self.venueSummary?.exhibitionInfoData != nil {
            self.updateWithExhibitionData((self.venueSummary?.exhibitionInfoData)!)
        } else {
            APIClient.sharedInstance().venueToGetSingleVenueWithId(self.venueUUID,
                                                                   beforeBlock: {
                                                                    self.delegate?.exhibitionInfoDataControllerDidStartFetchingVenue(self)
                }, afterBlock: {
                    
                    self.delegate?.exhibitionInfoDataControllerDidEndFetchingVenue(self)
                }, withSuccessBlock: { (element) in
                    
                    guard let exhibition = element as? Venue else {
                        return
                    }
                    
                    self.updateWithExhibitionData(exhibition)
                    
            }) { (error, statusCode, context) in
                
                if statusCode != 409 {
                    let alert = UIAlertController(title: NSLocalizedString("Failed", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default, handler: nil))
                    self.delegate?.exhibitionInfoDataControllerDidRequireShowingAlert(alert)
                }
            }
        }
    }
    
    func updateWithExhibitionData(exhibition: Venue) {
        
        self.exhibitionData = exhibition
        
        self.photoWallDataController.photoURLs = exhibition.associatedImageUrls
        
        // initial height
        let state = self.cachedExhibitionInfoDetailsSelectionState
        
        var about = NSLocalizedString("No description", comment: "No description for venue")
        if let venueDescription = exhibition.venueDescription {
            about = venueDescription
        }
        
        let details: [ExhibitionInfoDetailData] = self.detailsForExhibition(exhibition)
        
        if exhibition.spaceImageUrls.count == 0 {
            self.cachedHeightForRow[2] = 0.0
        } else {
            self.cachedHeightForRow[2] = ExhibitionInfoSlideshowCellDefaultHeight
        }
        
        self.cachedExhibitionInfoSlideshowCurrentPageIndex = 0
        
        self.cachedHeightForRow[3] = ExhibitionInfoDetailsCell.initialSize(state: state, about: about, aboutExpended: self.cachedExhibitionInfoDetailsAboutExpended, details: details).height
        self.cachedHeightForRow[5] = ExhibitionInfoPhotoWallCell.initialSize(countOfPhotos: exhibition.associatedImageUrls.count).height
        
        // Force update all the rows
        for (key, _) in self.dataUpdatedFlagForRow {
            self.dataUpdatedFlagForRow[key] = true
        }
        
        self.cachedExhibitionInfoSlideshowCurrentPageIndex = 0
        self.cachedExhibitionInfoDetailsAboutExpended = false
        self.cachedExhibitionInfoDetailsSelectionState = .Details
        
        self.tableView.reloadData()
    }
    
    // MARK: - UIScrollViewDelegate
    
    var tapLocationYPosition : CGFloat = CGFloat.max
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        let tapLocation = scrollView.panGestureRecognizer.locationInView(scrollView);
        tapLocationYPosition = tapLocation.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 0 && tapLocationYPosition < ExhibitionInfoSummaryCellDefaultHeight) {
            
            self.delegate?.exhibitionInfoDataControllerDidPullDown(self)
        }
    }
    
    // MARK: - Table view cell helper
    
    // MARK: Information
    
    func tableViewCellForDataRow(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ExhibitionInfoSummaryCellNibName) as? ExhibitionInfoSummaryCell {
                cell.delegate = self
                cell.clipsToBounds = true
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ExhibitionInfoFavouriteCellNibName) as? ExhibitionInfoFavouriteCell {
                cell.delegate = self
                cell.clipsToBounds = true
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ExhibitionInfoSlideshowCellNibName) as? ExhibitionInfoSlideshowCell {
                cell.delegate = self
                cell.clipsToBounds = true
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ExhibitionInfoDetailsCellNibName) as? ExhibitionInfoDetailsCell {
                cell.delegate = self
                cell.clipsToBounds = true
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ExhibitionInfoMapCellNibName) as? ExhibitionInfoMapCell {
                cell.delegate = self
                cell.clipsToBounds = true
                return cell
            }
        case 5:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ExhibitionInfoPhotoWallCellNibName) as? ExhibitionInfoPhotoWallCell {
                cell.delegate = self
                cell.clipsToBounds = true
                return cell
            }
        default:
            break
        }
        
        // all else situations
        return UITableViewCell()
    }
    
    func updateInformationCellForIndexPath(cell: UITableViewCell, exhibition: Venue, indexPath: NSIndexPath) {
        var dataUpdated: Bool = false
        if let updated = self.dataUpdatedFlagForRow[indexPath.row] {
            dataUpdated = updated
        }
        self.dataUpdatedFlagForRow[indexPath.row] = false
        
        switch indexPath.row {
        case 0:
            if let cell = cell as? ExhibitionInfoSummaryCell {
                
                let nameAndLocation = self.nameAndLocationForVenue(exhibition)
                
                cell.configureView(tags: exhibition.displayTags, exhibitionName: nameAndLocation.name, location: nameAndLocation.location)
            }
        case 1:
            if let cell = cell as? ExhibitionInfoFavouriteCell {
                cell.configureView(favorited: exhibition.favouriteUsersTapped)
            }
        case 2:
            if let cell = cell as? ExhibitionInfoSlideshowCell {
                cell.configureView(photoURLs: exhibition.spaceImageUrls, currentPageIndex: self.cachedExhibitionInfoSlideshowCurrentPageIndex)
            }
        case 3:
            if let cell = cell as? ExhibitionInfoDetailsCell {
                
                var about = NSLocalizedString("No description", comment: "No description for venue")
                if let venueDescription = exhibition.venueDescription {
                    about = venueDescription
                }
                
                let details: [ExhibitionInfoDetailData] = self.detailsForExhibition(exhibition)
                
                cell.configureView(dataUpdated: dataUpdated,
                                   state: self.cachedExhibitionInfoDetailsSelectionState,
                                   about: about,
                                   aboutExpended: self.cachedExhibitionInfoDetailsAboutExpended,
                                   details: details)
            }
        case 4:
            if let cell = cell as? ExhibitionInfoMapCell {
                cell.configureView(dataUpdated: dataUpdated, coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(exhibition.latitude), CLLocationDegrees(exhibition.longitude)))
            }
        case 5:
            if let cell = cell as? ExhibitionInfoPhotoWallCell {
                cell.configureView(dataUpdated: dataUpdated, dataController: self.photoWallDataController)
            }
        default:
            break
        }
    }
    
    // MARK: Similar exhibitions
    
    func tableViewCellForSimilarExhibition(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
    
        let similarExhibition = self.similarExhibitions()[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(ExhibitionSimilarVenueTableViewCellNibName) as? ExhibitionSimilarVenueTableViewCell {
            
            let nameAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 17.5),
                                      NSForegroundColorAttributeName: UIColor.yamoBlack(),
                                      NSKernAttributeName: NSNumber.kernValueWithStyle(KernValueStyle.Regular, fontSize: 17.5)]
            let nameAttributedString = NSAttributedString(string: similarExhibition.name, attributes: nameAttributes)            
            cell.exhibitionNameLabel.attributedText = nameAttributedString
            
            // Configure location label
            let locationAttachment = NSTextAttachment()
            let locationImage = UIImage(named: "icon location 1 1")
            locationAttachment.image = locationImage
            let locationAttachmentAttributedString = NSAttributedString(attachment: locationAttachment)
            
            let locationAttributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 12.0),
                                      NSForegroundColorAttributeName: UIColor.yamoDarkGray(),
                                      NSKernAttributeName: NSNumber.kernValueWithStyle(KernValueStyle.Regular, fontSize: 12.0)]
            let locationAttributedString = NSAttributedString(string: similarExhibition.galleryName, attributes: locationAttributes)
            
            let combinedLocationAttributedString = NSMutableAttributedString(attributedString: locationAttachmentAttributedString)
            combinedLocationAttributedString.appendAttributedString(NSAttributedString(string: "  "))
            combinedLocationAttributedString.appendAttributedString(locationAttributedString)
            
            cell.exhibitionLocationNameLabel.attributedText = combinedLocationAttributedString
            
            let placeholderImage = UIImage(named: "YamoPlaceholder")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            
            cell.placeholderContentView.image = placeholderImage
            
            if similarExhibition.imageUrl != nil {
                if let imageUrl = NSURL.init(string: similarExhibition.imageUrl) where similarExhibition.imageUrl.characters.count > 0{
                    cell.contentImageView.setImageWithURL(imageUrl, placeholderImage: nil)
                    cell.placeholderContentView.hidden = true

                } else {
                    cell.placeholderContentView.hidden = false
                    
                    cell.contentImageView.image = nil
                }
            } else {
                cell.placeholderContentView.hidden = false
                cell.contentImageView.image = nil
            }
            

            return cell
        }
        
        return UITableViewCell()
    }
    
    func updateSimilarVenueCellForIndexPath(cell: UITableViewCell, exhibition: Venue, indexPath: NSIndexPath) {
        
    }
    
    func similarExhibitions() -> [VenueSearchSummary] {
        
        if let exhibition = self.exhibitionData {
            if exhibition.recommended != nil {
                return exhibition.recommended
            }
        }
        return []
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Note: Modification from Oct 2016 - Change requests from Yamo
        // No longer shows the similar exhibitions
        // return 2
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return self.similarExhibitions().count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return self.tableViewCellForDataRow(tableView, indexPath: indexPath)
        case 1:
            return self.tableViewCellForSimilarExhibition(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let exhibition = self.exhibitionData else {
            
            if indexPath.section == 0 && indexPath.row == 0 {
                
                guard let venueSummary = self.venueSummary else {
                    
                    return
                }
                
                if let cell = cell as? ExhibitionInfoSummaryCell {
                    
                    var nameAndLocation = (name: "", location: "")
                    
                    if let venueSummary = self.venueSummary  {
                        
                        if venueSummary.name != nil {
                            nameAndLocation.name = venueSummary.name
                        }
                        
                        if venueSummary.galleryName != nil {
                            nameAndLocation.location = venueSummary.galleryName
                        }
                    }
                    
                    cell.configureView(tags: venueSummary.displayTags, exhibitionName: nameAndLocation.name, location: nameAndLocation.location)
                }
            }
            
            return
        }
        
        switch indexPath.section {
        case 0:
            self.updateInformationCellForIndexPath(cell, exhibition: exhibition, indexPath: indexPath)
        case 1:
            self.updateSimilarVenueCellForIndexPath(cell, exhibition: exhibition, indexPath: indexPath)
        default:
            break;
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 3:
                if let cell = cell as? ExhibitionInfoDetailsCell {
                    self.cachedExhibitionInfoDetailsSelectionState = cell.currentSelectionState
                }
            default:
                break
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                if self.venueSummary != nil {
                    return estimateHeightForSummaryCell(self.venueSummary!)
                }
                
                return UITableViewAutomaticDimension
            }
        
            return self.cachedHeightForRow[indexPath.row]!
            
        case 1:
            
            return UITableViewAutomaticDimension
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return self.cachedHeightForRow[indexPath.row]!
        case 1:
            return ExhibitionSimilarVenueTableViewCellEstimatedHeight
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == ExhibitionSimilarExhibitionsSection {
            return true
        }
        
        return false
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == ExhibitionSimilarExhibitionsSection {
            return indexPath
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == ExhibitionSimilarExhibitionsSection {
            
            let selectedSimilarExhibition = self.similarExhibitions()[indexPath.row]
            self.delegate?.exhibitionInfoDataController(self, didSelectSimilarVenueWithId: selectedSimilarExhibition.uuid)
        }
    }
    
    // MARK: UITableView Header
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == ExhibitionSimilarExhibitionsSection && self.similarExhibitions().count > 0) {
            let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(ExhibitionSimilarVenueHeaderViewNibName)
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == ExhibitionSimilarExhibitionsSection && self.similarExhibitions().count > 0) {
            return ExhibitionSimilarVenueHeaderViewHeight
        } else {
            return 0.1
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: - ExhibitionInfoCellDelegate
    
    func exhibitionInfoCellDidRequireCacheState(cell: ExhibitionInfoCell) {
        if let cell = cell as? ExhibitionInfoSlideshowCell {
            self.cachedExhibitionInfoSlideshowCurrentPageIndex = cell.currentPageIndex
        }
        
        if let cell = cell as? ExhibitionInfoDetailsCell {
            self.cachedExhibitionInfoDetailsSelectionState = cell.currentSelectionState
            self.cachedExhibitionInfoDetailsAboutExpended = cell.aboutExpended
        }
    }
    
    func exhibitionInfoCell(cell: ExhibitionInfoCell, didChangedFavorited favorited: Bool) {
        guard let venueUUID = self.venueUUID else {
            return
        }
        
        if !favorited {
            
            APIClient.sharedInstance().venueMarkFavoriteWithId(venueUUID, withSuccessBlock: {
                //hans modified
                Flurry.logEvent("Like-Exhibition");
                //
                self.exhibitionData?.favouriteUsersTapped = true
                
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
                
                }, failureBlock: { (error, statusCode, _) in
                    
                    if statusCode != 409 {
                        let alert = UIAlertController(title: NSLocalizedString("Failed", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default, handler: nil))
                        self.delegate?.exhibitionInfoDataControllerDidRequireShowingAlert(alert)
                    }
            })
        } else {
            APIClient.sharedInstance().venueMarkUnfavoriteWithId(venueUUID, withSuccessBlock: {
                
                self.exhibitionData?.favouriteUsersTapped = false
                
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
                
                }, failureBlock: { (error, statusCode, context) in
                    
                    if statusCode != 409 {
                        let alert = UIAlertController(title: NSLocalizedString("Failed", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default, handler: nil))
                        self.delegate?.exhibitionInfoDataControllerDidRequireShowingAlert(alert)
                    }
            })
        }
    }
    
    func exhibitionInfoCell(cell: ExhibitionInfoCell, didChangedContentSize size: CGSize) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            self.cachedHeightForRow[indexPath.row] = size.height
            self.dataUpdatedFlagForRow[indexPath.row] = true
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func exhibitionInfoCellDidRequireRoute(cell: ExhibitionInfoCell) {
        guard let exhibitionData = self.exhibitionData else {
            return
        }
        
        self.delegate?.exhibitionInfoDataController(self, didRequireRouteToVenue: exhibitionData)
    }
    
    func shareExhibitionInfo() {
        self.delegate?.exhibitionInfoDataControllerShareVenue(self)
    }
    
    // MARK: - ExhibitionInfoPhotoWallDataControllerDelegate
    
    func exhibitionInfoPhotoWallDataController(dataController: ExhibitionInfoPhotoWallDataController, didRequireShowingPhotoWithIndex index: Int, inAllPhotos allPhotoURLs: [String]) {
        self.delegate?.exhibitionInfoDataController(self, didRequireShowingPhotoWithIndex: index, inAllPhotos: allPhotoURLs)
    }
    
    //MARK: - Helper
    
    func estimateHeightForSummaryCell(venueSummary: VenueSearchSummary) -> CGFloat {
        let height = ExhibitionInfoSummaryCell.estimatedHeightForVenueName(venueSummary.name)
        return height
    }
    
    func nameAndLocationForVenue(exhibition: Venue) -> (name: String, location: String) {
        var nameAndLocation = (name: "", location: "")
        
        if (exhibition.name != nil) {
            nameAndLocation.name = exhibition.name
        }
        
        if (exhibition.galleryName != nil) {
            nameAndLocation.location = exhibition.galleryName
        }
        
        if let venueSummary = self.venueSummary {
            
            if venueSummary.name != nil {
                nameAndLocation.name = venueSummary.name
            }
            
            if venueSummary.galleryName != nil {
                nameAndLocation.location = venueSummary.galleryName
            }
        }
        
        return nameAndLocation
    }
    
    func detailsForExhibition(exhibition: Venue) -> [ExhibitionInfoDetailData] {
        var details = [ExhibitionInfoDetailData]()
        
        var displayFullAddress = ""
        
        //if let name = exhibition.name {
        //    displayFullAddress = displayFullAddress + name
        //}
        
        if let address = exhibition.address {
            displayFullAddress = displayFullAddress.characters.count > 0 ? "\(displayFullAddress)\n\(address)" : address
        }
        
        details.append(ExhibitionInfoDetailData(detailString: displayFullAddress, context:.Default))
        
        var displayWebsite = ""
        if let website = exhibition.website {
            displayWebsite = website
        }

        details.append(ExhibitionInfoDetailData(detailString: displayWebsite, context:.Default))

        var displayOpeningTime = ""
        if let openingTime = exhibition.openingTimes {
            displayOpeningTime = openingTime
        }

        details.append(ExhibitionInfoDetailData(detailString: displayOpeningTime, context:.Default))

        var displayFee = ""
        if let fee = exhibition.fee {
            displayFee = fee.stringValue
        }

        details.append(ExhibitionInfoDetailData(detailString: displayFee, context:.EntryFee))
        
        let finalDateString = self.prepareStartAndEndDate(forExhibition: exhibition)

        if finalDateString.characters.count > 0 {
            
            details.append(ExhibitionInfoDetailData(detailString: finalDateString, context:.Default))
        }

        return details
    }
    
    func prepareStartAndEndDate(forExhibition exhibition: Venue) -> String {
        
        var finalDateString = ""
        var startDateString = ""
        var endDateString = ""
        let date = NSDate()
        var exhibitionIsActive = false
        
        if let startDate = exhibition.startDate {
            
            if startDate.compare(date) == .OrderedAscending {
                
                exhibitionIsActive = true
            }
            else {
                
                startDateString = self.dateFormatter.stringFromDate(startDate)
            }
        }
        
        if let endDate = exhibition.endDate {
            
            endDateString = self.dateFormatter.stringFromDate(endDate)
        }
        
        if startDateString.characters.count > 0 && endDateString.characters.count > 0 {
            
            
            finalDateString = "\(startDateString) - \(endDateString)" // e.g. "August 2, 2016 - August 3, 2016"
        }
        else if exhibitionIsActive && endDateString.characters.count > 0 {
            
            finalDateString = "Until \(endDateString)" // e.g. "Until August 3, 2016"
            
        }
        else if startDateString.characters.count > 0 {
            
            finalDateString = startDateString // e.g. "August 2, 2016"
        }
        else if endDateString.characters.count > 0 {
            
            finalDateString = endDateString // e.g. "August 3, 2016"
        }
        
        return finalDateString
    }
    
    
}
