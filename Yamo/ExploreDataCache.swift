//
//  ExploreDataCache.swift
//  Yamo
//
//  Created by Mo on 12/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import CoreLocation

let panningThreshold = 0.4
let minimumDifference: UInt = 2

class ExploreDataCache: NSObject {
    var venueSummariesForMap: [VenueSearchSummary]?
    var venueSummariesForList: [VenueSearchSummary]?
    var venueExhibitionsForList: [Venue] = []
    var hasFetched = false
    var lastFetchedLocation = CLLocation()
    var fetchDistanceInMiles: Double = 0
    var previousZoomLevel: UInt = 0
    var debugMode = false
    
    func cacheIsValid(forLocation location: CLLocation, zoomLevel: UInt) -> Bool{
        
        var isValid = self.hasFetched
        
        let distance = location.distanceFromLocation(self.lastFetchedLocation) / Double(metersToMiles)
        let difference = max(zoomLevel, previousZoomLevel) - min(zoomLevel, previousZoomLevel)
        
        if distance > self.fetchDistanceInMiles * panningThreshold {
        
            if debugMode {
                
                print("invalidating cache due to distance: \(distance) > \(self.fetchDistanceInMiles * panningThreshold)")
            }
            
            isValid = false
        }
        else if difference > minimumDifference {
            
            if debugMode {
                
                print("invalidating cache due to difference: \(difference)")
            }
            
            isValid = false
        }
        else if difference >= minimumDifference && distance > self.fetchDistanceInMiles * (panningThreshold * 0.5) {
            
            if debugMode {
                
                print("invalidating cache due to difference & distance: \(distance) > \(self.fetchDistanceInMiles * (panningThreshold * 0.5)) and \(difference) > 1")
            }
            
            isValid = false
        }
        
        return isValid
    }
}
