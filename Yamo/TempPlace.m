//
//  TempPlace.m
//  Yamo
//
//  Created by Peter Su on 03/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "TempPlace.h"
@import MTLModel_LOCExtensions;

@implementation TempPlace

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ @"latitude" : @"lat",
                                                                           @"longitude" : @"lon" }];
    return propertyMappings;
}

+ (NSValueTransformer *)storeDateJSONTransformer {
    return [self iso8601ToDateTransformer];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return NSStringFromClass([TempPlace class]);
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObjects:NSStringFromSelector(@selector(uuid)), nil];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ }];
    return propertyMappings;
}

#pragma mark - RoutePlannerInterface

- (NSString *)displayName {
    return self.locationName;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

#pragma mark - CoreDataOrganizable

+ (NSFetchRequest *)fetchRequestForPurging {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TempPlace class])];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(storeDate)) ascending:NO]];
    fetchRequest.fetchOffset = NumberOfRecentPlaces;
    
    return fetchRequest;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    
    return [self isEqualToTempPlace:object];
}

- (BOOL)isEqualToTempPlace:(TempPlace *)otherPlace {
    
    if ([self.locationName isEqualToString:otherPlace.locationName] &&
        self.latitude == otherPlace.latitude
        && self.longitude == otherPlace.longitude) {
        
        return YES;
    }
    
    return NO;
}

@end
