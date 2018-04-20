//
//  DataPurgeService.h
//  Yamo
//
//  Created by Hungju Lu on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import CoreData;

@protocol CoreDataOrganizable <NSObject>

@required

/**
 *  The fetch results fetched from this fetch request will be deleted during
 *  the organization.
 *
 *  @return A fetch request which will be used during the organization.
 */
+ (NSFetchRequest *)fetchRequestForPurging;

@end

@interface CoreDataOrganizeService : NSObject

+ (void)organizeModelWithClass:(Class)aClass;

@end
