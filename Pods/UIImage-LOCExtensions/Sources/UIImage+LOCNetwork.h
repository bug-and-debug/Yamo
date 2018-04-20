//
//  UIImage+LOCUtilities.h
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LOCNetwork)

#pragma mark - utilities
+ (void)downloadImageAtUrl:(NSString *)url completion:(void(^)(UIImage *aImage))aBlock;

@end
