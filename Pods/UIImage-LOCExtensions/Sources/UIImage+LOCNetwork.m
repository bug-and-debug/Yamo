//
//  UIImage+LOCUtilities.m
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIImage+LOCNetwork.h"
#import "UIImage+LOCResize.h"
@import NSFileManager_LOCExtensions;
@import NSString_LOCExtensions;

@implementation UIImage (LOCNetwork)

+ (void)downloadImageAtUrl:(NSString *)url completion:(void(^)(UIImage *aImage))aBlock {
    NSURL *imageURL = [NSURL URLWithString:url];
    NSString *cachedImagePath = [[NSFileManager applicationSupportDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"images/%@.png", [url md5String]]];
    [NSFileManager createPath:cachedImagePath];
    __block BOOL isCachedImage;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData;
        imageData = [NSData dataWithContentsOfFile:cachedImagePath];
        isCachedImage = (imageData != nil);
        
        if(!imageData) {
            imageData = [NSData dataWithContentsOfURL:imageURL];
            if(imageData) {
                NSError *error = nil;
                if([imageData writeToFile:cachedImagePath options:NSDataWritingAtomic error:&error]) {
                    //NSLog(@"Image cached: %@", cachedImagePath);
                } else {
                    //NSLog(@"Cannot cache image: %@", error);
                }
            }
        }
        CGSize maxSize = CGSizeMake(300, 300);
        dispatch_async(dispatch_get_main_queue(), ^{
            if(imageData) {
                UIImage *profileImage = [UIImage imageWithData:imageData];
                if (profileImage.size.height > maxSize.height && !isCachedImage) {
                    profileImage = [profileImage resizeproportionallyToHeight:maxSize.height];
                }
                if (profileImage.size.width > maxSize.width && !isCachedImage)  {
                    profileImage = [profileImage resizeproportionallyToWidth:maxSize.width];
                }
                if(aBlock) {
                    aBlock(profileImage);
                }
            } else {
                if(aBlock) {
                    aBlock(nil);
                }
            }
        });
    });
}

@end
