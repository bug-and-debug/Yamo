//
//  UIView+LOCRotation.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LOCRotation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - rotation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)rotateTo0;
- (void)rotateTo45;
- (void)rotateTo90;
- (void)rotateTo135;
- (void)rotateTo180;
- (void)rotateTo225;
- (void)rotateTo270;
- (void)rotateTo315;

/*-----------------------------------------------------------------------------------------------------*/

- (void)rotate45;
- (void)rotate90;
- (void)rotate135;
- (void)rotate180;
- (void)rotate225;
- (void)rotate270;
- (void)rotate315;
- (void)rotate360;

/*-----------------------------------------------------------------------------------------------------*/

- (void)rotateToAngle:(float)degrees;

/*-----------------------------------------------------------------------------------------------------*/

- (void)rotate:(float)degrees;

/*-----------------------------------------------------------------------------------------------------*/

- (UIImage *)rotateImage:(UIImage *)image
                 degrees:(int)degrees;

@end
