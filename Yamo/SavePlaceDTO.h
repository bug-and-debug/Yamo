//
//  SavePlaceDTO.h
//  Yamo
//
//  Created by Peter Su on 13/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "PlaceType.h"

@interface SavePlaceDTO : MTLModel <MTLJSONSerializing>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic) PlaceType type;
@property (nonatomic, strong, readonly) NSNumber *placeType;

@end
