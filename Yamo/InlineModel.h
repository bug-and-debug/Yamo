//
//  InlineModel.h
//  Yamo
//
//  Created by Vlad Buhaescu on 17/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "ArtWork.h"

@interface InlineModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSArray <ArtWork *> *artWorks;
@end
