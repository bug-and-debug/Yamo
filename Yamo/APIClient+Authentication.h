//
//  APIClient+Authentication.h
//  Yamo
//
//  Created by Mo Moosa on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (Authentication)

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)authenticationCreateGuestUserBeforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                      afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                   successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)authenticationConnectWithFacebookWithFacebookToken:(NSString *)facebookToken
                                                facebookId:(NSString *)facebookId
                                                     email:(NSString *)email
                                                beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                                 afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                              successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)logoutWithSuccessBlock:(LOCApiClientSuccessEmptyBlockType)successBlock failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)authenticationSignupWithFirstName:(NSString *)firstName
                                 lastName:(NSString *)lastName
                                    email:(NSString *)emailAddress
                                 password:(NSString *)password
                             imageContent:(NSString *)imageContent
                               beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                             successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)authenticateToGetUserWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)authenticationRecoverPasswordForEmail:(NSString *)email
                                   beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                    afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                 successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)authenticationValidateRecoverPasswordCodeForEmail:(NSString *)email
                                               secretCode:(NSString *)secretCode
                                               beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                                afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                             successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)authenticationResetPasswordForEmail:(NSString *)email
                                newPassword:(NSString *)password
                                 secretCode:(NSString *)secretCode
                                 beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                  afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                               successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                               failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;


@end
