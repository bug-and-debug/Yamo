//
//  PremiumModel.h
//  Locassa
//
//  Abstract:
//  Model class to represent a product/purchase.
//
//  Created by Boris Yurkevich on 09/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import Foundation;
@import StoreKit;

@interface PremiumModel : NSObject

// Products/Purchases are organized by category
// Although we have just one product, tere's 2 categories:
// Available products and invalid products
@property (nonatomic, copy) NSString *categoryName;
//  List of products/purchases
@property (nonatomic) NSArray *elements;

// Create a model object
-(PremiumModel *)initWithName:(NSString *)name
                     elements:(NSArray *)elements NS_DESIGNATED_INITIALIZER;

@end
