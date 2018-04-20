//
//  MTLModel+Mock.h
//
//  Created by Peter Su on 17/01/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import Mantle;

@interface MTLModel (LOCMock)

#pragma mark - Random Generators

+ (NSNumber *)randomNSNumber;
+ (BOOL)randomBOOL;
+ (NSString *)randomStringWithLength:(NSInteger)len;
+ (NSString *)randomName;
+ (NSString *)randomSurname;
+ (NSString *)randomLocation;
+ (long)randomLatitude;
+ (long)randomLongitude;
+ (NSString *)randomVideoURL;
+ (NSString *)randomImageURL;
+ (NSDate *)randomDate;

@end
