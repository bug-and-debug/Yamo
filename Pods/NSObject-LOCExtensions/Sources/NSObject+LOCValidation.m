//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSObject+LOCValidation.h"

@implementation NSObject (LOCValidation)

#pragma mark - validation
+ (BOOL)object:(NSObject *)object1 isEqual:(NSObject *)object2 {
	BOOL result;
	if (object1 && object2)
	{
		result = [object1 isEqual:object2];
	}
	else
	{
		result = (object1 == object2);
	}
	return result;
}

-(BOOL)isValidObject {
    return (self && ![self isEqual:[NSNull null]]);
}

- (BOOL)isValidString {
    return NO;
}

- (BOOL)isValidDictionary {
    return NO;
}

- (BOOL)isValidArray {
    return NO;
}

@end
