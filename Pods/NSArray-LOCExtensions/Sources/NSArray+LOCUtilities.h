//
//  NSArray+LOCUtilities.h
//  NSArray-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LOCUtilities)

- (id)randomObject;
- (NSArray *)cleanup;
- (NSArray *)arrayFromObjectsCollectedWithBlock:(id(^)(id object))block;

@end
