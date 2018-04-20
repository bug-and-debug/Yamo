//
//  ExploreDataController.swift
//  Yamo
//
//  Created by Peter Su on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit

protocol ExploreDataControllerDelegate: class {
    
    func exploreDataControllerDidFetchNewData(controller: ExploreDataController)
    func exploreLoadDataDidFinished(count: Int)
    func exploreDataControllerDidStartFetchingVenue(controller: ExploreDataController)
    func exploreDataControllerDidEndFetchingVenue(controller: ExploreDataController)
    func exploreDataControllerDidRequireShowingAlert(alert: UIAlertController)
}

let minimumNumberOfMiles: Double = 5
let maximumNumberOfMiles: Double = 200
let venueLoadUnit: Int = 8
let latitudeKey = "latitude"
let longitudeKey = "longitude"
let milesKey = "miles"
let zoomLevelKey = "zoomLevel"
let shouldClearCacheKey = "shouldClearCache"

class ExploreDataController: NSObject {
    
    weak var delegate:ExploreDataControllerDelegate?
    var isCurrentlyRequestingNewData = false
    var filterSearchDTO: FilterSearchDTO?
    var venueLoadPageCount: Int!
    var loadVenuesCount: Int!
    var exploreType: Int!;
    
    internal var venuesDataForMap: [VenueSearchSummary]?
    internal var venuesDataForList: [VenueSearchSummary]?
    internal var venuesExhibitionData: [Venue]?
    
    var queuedRequestParameters = [[String: AnyObject]]()
    var debugMode = true
    var bIsShowConnectionAlert = false
    let exploreDataCache = ExploreDataCache()
    
    func getDTO() -> FilterSearchDTO {
        if let filterDTO = self.filterSearchDTO {
            return filterDTO
        } else if let dto = FilterHelper.cachedFilterSearchDTO() {
            return dto
        } else {
            return FilterSearchDTO()
        }
    }
    
    func invalidateCache(){
        self.venuesDataForMap = []
        self.venuesDataForList = []
        self.venuesExhibitionData = []
        self.exploreDataCache.hasFetched = false
        self.bIsShowConnectionAlert = false
    }
    
    func setExploreType(type: Int) {
        self.exploreType = type;
    }
    
    // MARK: - Load
    
    func refreshDataForLatitude(latitude: Double, longitude: Double, miles: Double, zoomLevel: UInt, shouldClearCache: Bool) {
    
        // This method will make the initial call for the given parameters but a) queue up one additional request and
        // b) cache the response in the exploreDataCache. It does this so that if the user is continuously zooming in
        // and out or panning around we only make a small handful of network 
        
        let cappedMiles = min(max(miles, minimumNumberOfMiles), maximumNumberOfMiles)
    
        guard isCurrentlyRequestingNewData == false else {
            
            // We're not going to make a new network call in this case because the ExploreDataController is busy. 
            // Instead we store the parameters and make a new request when the EDC is free again.
            
            let parameters = [latitudeKey: NSNumber(double: latitude), longitudeKey: NSNumber(double: longitude), milesKey: NSNumber(double: cappedMiles), zoomLevelKey: NSNumber(unsignedInteger: zoomLevel)]
            
            if self.queuedRequestParameters.isEmpty {
                
                self.queuedRequestParameters.append(parameters)
                
                if debugMode {
                    print("ExploreDataController is busy: will store this request to call after.")
                }
            }
            else {
                
                // Here we've swapped out the queued request for the new one because it's no longer relevant.
                
                self.queuedRequestParameters.removeLast()
                self.queuedRequestParameters.append(parameters)
                
                if debugMode {
                    print("ExploreDataController is busy: the existing queued request will be replaced with the newest request.")
                    
                }
            }
            
            return
        }

        self.isCurrentlyRequestingNewData = true
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        self.exploreDataCache.fetchDistanceInMiles = Double(cappedMiles)
        
        if self.exploreDataCache.cacheIsValid(forLocation: location, zoomLevel: zoomLevel) && !shouldClearCache {

            // Again we don't make a network call here, we simply return the cache as it has been deemed valid for the
            // parameters.
            
            self.venuesDataForMap = self.exploreDataCache.venueSummariesForMap
            self.venuesDataForList = self.exploreDataCache.venueSummariesForList
          
            if self.debugMode,
                let cachedVenuesForMap = self.venuesDataForMap,
                let cachedVenuesForList = self.venuesDataForList {
                
                print("Fetched [cached] \(cachedVenuesForMap.count) exhibitions for map")
                print("Fetched [cached] \(cachedVenuesForList.count) exhibitions for list")
            }
            
            self.delegate?.exploreDataControllerDidFetchNewData(self)
            
            self.isCurrentlyRequestingNewData = false
            
            for venue in self.venuesDataForList! {
                self.getVenue(venue.uuid)
            }
            
            return
        }
        
        let dto = self.getDTO()
        dto.latitude = latitude
        dto.longitude = longitude
        dto.miles = cappedMiles
        
        let serviceGroup = dispatch_group_create()
        
        var imageUrlStringsToCache = Set<String>()
        
        let successBlock = { (element: [AnyObject]?, forMap: Bool, forList: Bool) in
            
            guard let exhibitions = element as? [VenueSearchSummary] else {
                self.delegate?.exploreDataControllerDidFetchNewData(self)
                return
            }
            
            /* ---- hans modified ----- */
            print("----------- exhibitions -------------\(exhibitions.count)");
            self.delegate?.exploreLoadDataDidFinished(exhibitions.count);
            /* ------------------------ */
            
            for venue in exhibitions {
                // Update the location, not relies on the server
                let venueLoacation = CLLocation(latitude: venue.latitude, longitude: venue.longitude)
                venue.distance = CGFloat(venueLoacation.distanceFromLocation(CLLocation(latitude: latitude, longitude: longitude)))
                
                if let urlString = venue.imageUrl {
                    imageUrlStringsToCache.insert(urlString)
                }
            }
            
            let sortedExhibitions = exhibitions.sort({ (first, second) -> Bool in
                return first.distance < second.distance
            })
            
            if forMap {
                self.venuesDataForMap = sortedExhibitions
                self.exploreDataCache.venueSummariesForMap = self.venuesDataForMap
                
                if self.debugMode {
                    print("Fetched \(exhibitions.count) exhibitions for maps [\(miles) miles]")
                }
            }
            
            if forList {
                self.venuesDataForList = sortedExhibitions
                self.exploreDataCache.venueSummariesForList = self.venuesDataForList
                
                if self.debugMode {
                    print("Fetched \(exhibitions.count) exhibitions for list [\(miles) miles]")
                }
            }
            
            self.venueLoadPageCount = 0
            self.getVenuesWithPageCounter()
            
            //for venue in self.venuesDataForList! {
            //    self.getVenue(venue.uuid)
            //}
            
            dispatch_group_leave(serviceGroup)
        }
        
        // Fetch maps data
        dispatch_group_enter(serviceGroup)
        
        print("-------- data controller --------\(self.exploreType)");
        
        if self.exploreType == 1 {
            APIClient.sharedInstance().venueFilterSearchForMapWithFilterSearchDTO(dto, successBlock: { (element) in
                successBlock(element, true, true)
            }) { (error, statusCode, context) in
                print("%@ %ld %@", error, statusCode, context)
                self.showConnectionAlert()
                dispatch_group_leave(serviceGroup)
            }
        } else if self.exploreType == 2 {
            APIClient.sharedInstance().getFavorites(dto, successBlock: { (element) in
                successBlock(element, true, true)
            }) { (error, statusCode, context) in
                print("%@ %ld %@", error, statusCode, context)
                self.showConnectionAlert()
                dispatch_group_leave(serviceGroup)
            }
        }
        
        // Fetch list data
        /*dispatch_group_enter(serviceGroup)
        APIClient.sharedInstance().venueFilterSearchForListWithFilterSearchDTO(dto, successBlock: { (element) in
            successBlock(element, false, true)
        }) { (error, statusCode, context) in
            print("%@ %ld %@", error, statusCode, context)
            self.showConnectionAlert()
            dispatch_group_leave(serviceGroup)
        }*/
        
        // Wait for both maps and list data fetched
        dispatch_group_notify(serviceGroup, dispatch_get_main_queue()) {
            
            self.isCurrentlyRequestingNewData = false
            
            if !self.checkForQueuedRequests() {
                
                self.exploreDataCache.hasFetched = true
                self.exploreDataCache.lastFetchedLocation = location
                self.exploreDataCache.previousZoomLevel = zoomLevel
                
                self.delegate?.exploreDataControllerDidFetchNewData(self)
            }
        }
        
        dispatch_group_notify(serviceGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            // Preloads the images
            for urlString in imageUrlStringsToCache {
                guard let url = NSURL(string: urlString) else {
                    continue;
                }
                
                let request = NSURLRequest(URL: url)
                if let _ = AFImageDownloader.defaultInstance().imageCache?.imageforRequest(request, withAdditionalIdentifier: urlString) {
                } else {
                    AFImageDownloader.defaultInstance().downloadImageForURLRequest(request, success: { (_, _, image) in
                        AFImageDownloader.defaultInstance().imageCache?.addImage(image, forRequest: request, withAdditionalIdentifier: urlString)
                        }, failure: nil)
                }
            }
        }
    }
    
    func getVenuesWithPageCounter() {
    
        if self.venuesDataForList?.count < venueLoadPageCount * venueLoadUnit {
            return
        }
    
        var loadCount = 0
        if self.venuesDataForList?.count > (venueLoadPageCount + 1) * venueLoadUnit {
            loadCount = (venueLoadPageCount + 1) * venueLoadUnit
        } else {
            loadCount = (self.venuesDataForList?.count)!
        }
        
        loadVenuesCount = loadCount - venueLoadPageCount * venueLoadUnit
        venueLoadPageCount = venueLoadPageCount + 1
        
        var i = loadCount - loadVenuesCount
        while i < loadCount {
            let venue = self.venuesDataForList?[i]
            getVenue(venue?.uuid)
            i = i + 1
        }
    }
    
    func getVenue(venueUUID: NSNumber?) {
        guard venueUUID != nil else {
            return
        }
        
        if let exhibition = getCachedVenue(venueUUID!) {
            self.updateExhibionInVenuesDataForList(exhibition)
        } else {
            APIClient.sharedInstance().venueToGetSingleVenueWithId(venueUUID,
                                                                   beforeBlock: {
                                                                    self.delegate?.exploreDataControllerDidStartFetchingVenue(self)
                }, afterBlock: {
                    
                    self.delegate?.exploreDataControllerDidEndFetchingVenue(self)
                }, withSuccessBlock: { (element) in
                    
                    guard let exhibition = element as? Venue else {
                        return
                    }
                    
                    //print("getVenue \(exhibition.galleryName)")
                    
                    if self.getCachedVenue(exhibition.uuid) == nil {
                        self.exploreDataCache.venueExhibitionsForList.append(exhibition)
                    }
                    
                    self.updateExhibionInVenuesDataForList(exhibition)
                    
            }) { (error, statusCode, context) in
                
                if statusCode != 409 {
                    let alert = UIAlertController(title: NSLocalizedString("Failed", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default, handler: nil))
                    self.delegate?.exploreDataControllerDidRequireShowingAlert(alert)
                }
            }
        }
    }
    
    func updateExhibionInVenuesDataForList(exhibition: Venue) {
        
        if loadVenuesCount > 0 {
            loadVenuesCount = loadVenuesCount - 1
            if loadVenuesCount == 0 {
                self.delegate?.exploreDataControllerDidFetchNewData(self)
                self.getVenuesWithPageCounter()
            }
        }
        
        var count = 0
        for venue in self.venuesDataForList! {
            if venue.uuid == exhibition.uuid {
                venue.exhibitionInfoData = exhibition
                self.venuesDataForList![count] = venue
                break
            }
            count = count + 1
        }
    }
    
    func getCachedVenue(venueUUID: NSNumber) -> Venue! {
        
        let cachedVenueExhibitions = self.exploreDataCache.venueExhibitionsForList
        
        for exhibition in cachedVenueExhibitions {
            if exhibition.uuid == venueUUID {
                return exhibition
            }
        }
        
        return nil
        
    }
    
    func showConnectionAlert() {
        if !bIsShowConnectionAlert {
            bIsShowConnectionAlert = true
            NSNotificationCenter.defaultCenter().postNotificationName(UserServiceNoInternetConnectionNotification, object: nil)
        }
    }
    
    func checkForQueuedRequests() -> Bool {
        
        guard queuedRequestParameters.count > 0 else {
            return false
        }
        guard let dict = self.queuedRequestParameters.first else {
            // We have no queued requests - there's no point in continuing.
            return false
        }
        
        var shouldClearCache = false
        
        if let latitude = dict[latitudeKey] as? NSNumber,
            let longitude = dict[longitudeKey] as? NSNumber,
            let miles = dict[milesKey] as? NSNumber,
            let zoomLevel = dict[zoomLevelKey] as? NSNumber {
            
            if let shouldClear = dict[shouldClearCacheKey] as? NSNumber {
                shouldClearCache = shouldClear.boolValue
            }
            
            if debugMode {
                print("ExploreDataController is now running a queued request.")
            }
            
           self.refreshDataForLatitude(latitude.doubleValue, longitude: longitude.doubleValue, miles: miles.doubleValue, zoomLevel: zoomLevel.unsignedIntegerValue, shouldClearCache: shouldClearCache)
        }
        
        self.queuedRequestParameters.removeLast()
        
        return true
    }
}

