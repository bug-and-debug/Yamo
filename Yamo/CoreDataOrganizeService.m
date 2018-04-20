//
//  DataPurgeService.m
//  Yamo
//
//  Created by Hungju Lu on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "CoreDataOrganizeService.h"
#import "CoreDataStore.h"

@implementation CoreDataOrganizeService

+ (void)organizeModelWithClass:(Class)aClass {
    
    if (![aClass conformsToProtocol:@protocol(CoreDataOrganizable)]) {
        return;
    }
    
    Class<CoreDataOrganizable> organizableClass = (Class<CoreDataOrganizable>)aClass;
    NSManagedObjectContext *bmoc = [CoreDataStore sharedInstance].backgroundManagedObjectContext;
    
    NSFetchRequest *fetchRequest = [organizableClass fetchRequestForPurging];
    fetchRequest.entity = [NSEntityDescription entityForName:fetchRequest.entityName inManagedObjectContext:bmoc];
    
    [bmoc performBlockAndWait:^{
        NSArray *fetchedResults = [bmoc executeFetchRequest:fetchRequest error:NULL];
        
        if (fetchedResults && fetchedResults.count > 0) {
            
            for (NSManagedObject *obj in fetchedResults) {
                [[CoreDataStore sharedInstance] deleteEntity:obj inManagedObjectContext:bmoc];
            }
            
            [[CoreDataStore sharedInstance] saveDataIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
                NSLog(@"Old %@ purged.", NSStringFromClass(aClass));
            }];
        }
    }];
}

@end
