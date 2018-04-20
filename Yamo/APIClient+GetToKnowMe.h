//
//  APIClient+GetToKnowMe.h
//  Yamo
//
//  Created by Vlad Buhaescu on 17/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (GetToKnowMe)

- (void)getToKnowMeSuggestionWithTimeStamp:(NSDate *)timestamp
                              successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)postRateForCard:(NSDictionary*)parameters
           successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
           failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

@end
