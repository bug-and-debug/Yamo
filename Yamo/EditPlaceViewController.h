//
//  EditPlaceViewController.h
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlaceType.h"

@interface EditPlaceViewController : PlacesViewController

+ (_Nonnull instancetype)editPlacesViewControllerEditingType:(PlaceType)placeType;

@end
