//
//  APIClient+MyProfile.h
//  Yamo
//
//  Created by Dario Langella on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (MyProfile)

- (void)getUserProfileWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)editUserProfileWithEditedObject:(NSDictionary*)parameters
                           successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                           failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)getUserProfileWithUserID:(NSNumber*)userID
                    successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                    failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)followUserWithID:(NSNumber*)userID
            successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
            failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)unFollowUserWithID:(NSNumber*)userID
              successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

@end
