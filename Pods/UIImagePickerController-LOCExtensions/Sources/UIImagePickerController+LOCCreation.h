//
//  UIImagePickerController+LOCCreation.h
//  UIImagePickerController-LOCExtensions
//
//  Created by Hungju Lu on 22/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImagePicker_actionSheetButtonTags) {
    ImagePicker_actionSheetButtonTags_camera,
    ImagePicker_actionSheetButtonTags_library
};

@interface UIImagePickerController (LOCCreation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImagePickerController *)controllerForCameraWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate canEdit:(BOOL)canEdit;
+ (UIImagePickerController *)controllerForLibraryWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate canEdit:(BOOL)canEdit;

+ (void)presentPickerForController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)controller canEdit:(BOOL)canEdit;

@end
