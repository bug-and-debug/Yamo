//
//  UITextField+LOCLoginForm.m
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UITextField+LOCLoginForm.h"
#import <objc/runtime.h>

@implementation UITextField (LOCLoginForm)

- (NSString *)LOCLoginFormKey {
    return objc_getAssociatedObject(self, @selector(LOCLoginFormKey));
}

- (void)setLOCLoginFormKey:(NSString *)LOCLoginFormKey {
    objc_setAssociatedObject(self, @selector(LOCLoginFormKey), LOCLoginFormKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
