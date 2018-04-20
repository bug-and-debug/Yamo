//
//  EditPlacesDataController.h
//  Yamo
//
//  Created by Peter Su on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesDataController.h"

@class TempPlace;

@protocol EditPlacesDataControllerDelegate <PlacesDataControllerDelegate>

- (void)editPlacesDataControllerDidSelectPlace:(TempPlace *)tempPlace;

@end

@interface EditPlacesDataController : PlacesDataController

@property (nonatomic, weak) id<EditPlacesDataControllerDelegate> delegate;

@end
