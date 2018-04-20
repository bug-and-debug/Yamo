//
//  UIImagePickerController+LOCValidation.m
//  UIImagePickerController-LOCExtensions
//
//  Created by Hungju Lu on 22/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIImagePickerController+LOCValidation.h"

@implementation UIImagePickerController (LOCValidation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)hasLibrary
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

@end
