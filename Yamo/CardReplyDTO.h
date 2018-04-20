//
//  CardReplyDTO.h
//  Yamo
//
//  Created by Vlad Buhaescu on 20/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CardReplyDTO : MTLModel <MTLJSONSerializing>

@property  NSInteger artWorkId;
@property  NSInteger rating;

- (instancetype)initWithArtWorkID:(NSInteger)artWorkId
                           rating:(NSInteger)rating;

@end
