//
//  ScrollingChildTabItem.h
//  Yamo
//
//  Created by Dario Langella on 24/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollingChildTabItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign, getter=isEmpty) BOOL empty;


@end
