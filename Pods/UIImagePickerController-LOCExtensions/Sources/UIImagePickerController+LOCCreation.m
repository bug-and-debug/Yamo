//
//  UIImagePickerController+LOCCreation.m
//  UIImagePickerController-LOCExtensions
//
//  Created by Hungju Lu on 22/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIImagePickerController+LOCCreation.h"
#import "UIImagePickerController+LOCValidation.h"

@implementation UIImagePickerController (LOCCreation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (UIImagePickerController *)controllerForCameraWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate canEdit:(BOOL)canEdit {
    UIImagePickerControllerSourceType sourceType = -1;
   
    if ([self hasCamera]){
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = delegate;
    imagePicker.allowsEditing = canEdit;
    imagePicker.sourceType = sourceType;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    return imagePicker;
}

+ (UIImagePickerController *)controllerForLibraryWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate canEdit:(BOOL)canEdit {
    UIImagePickerControllerSourceType sourceType = -1;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = delegate;
    imagePicker.allowsEditing = canEdit;
    imagePicker.sourceType = sourceType;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    return imagePicker;
}

+ (void)presentPickerForController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)controller canEdit:(BOOL)canEdit {
    BOOL hasCamera = [UIImagePickerController hasCamera];
    BOOL hasLibrary = [UIImagePickerController hasLibrary];
    if (hasCamera && hasLibrary) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [UIImagePickerController controllerForCameraWithDelegate:controller canEdit:canEdit];
            [controller presentViewController:picker animated:YES completion:nil];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [UIImagePickerController controllerForLibraryWithDelegate:controller canEdit:canEdit];
            [controller presentViewController:picker animated:YES completion:nil];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        
        [controller presentViewController:actionSheet animated:YES completion:nil];
    }
    else if (hasCamera) {
        UIImagePickerController *picker = [UIImagePickerController controllerForCameraWithDelegate:controller canEdit:canEdit];
        [controller presentViewController:picker animated:YES completion:nil];
    }
    else if (hasLibrary) {
        UIImagePickerController *picker = [UIImagePickerController controllerForLibraryWithDelegate:controller canEdit:canEdit];
        [controller presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Camera Found."
                                                                       message:@"Your device does not appear to have a valid camera source"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

@end
