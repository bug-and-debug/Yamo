//
//  ArtWork.h
//  Yamo
//
//  Created by Vlad Buhaescu on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ArtWork : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *artWorkDescription;
@property (nonatomic, strong) NSString *imageUrlArtWork;
//tags (Array[Tag], optional),
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *venueUuid;

@end
