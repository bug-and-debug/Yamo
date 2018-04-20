//
//  APIClient+GetToKnowMe.m
//  Yamo
//
//  Created by Vlad Buhaescu on 17/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient+GetToKnowMe.h"
#import "ArtWork.h"
#import "InlineModel.h"
#import "ResponseDTO.h"

static NSString * const GetToKnowMeSuggestions = @"/card/suggestions?timestamp=%lld";
static NSString * const GetToKnowMeRate = @"/card/rate";

@implementation APIClient (GetToKnowMe)

- (void)getToKnowMeSuggestionWithTimeStamp:(NSDate *)timestamp
                              successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *path;
    if (timestamp) {
        NSNumber *timeInterval = @([timestamp timeIntervalSince1970] * 1000);
        path = [NSString stringWithFormat:GetToKnowMeSuggestions, timeInterval.longLongValue];
    }
    else {
        path = [NSString stringWithFormat:GetToKnowMeSuggestions, (long long)0];
    }
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:path
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseGetToKnowMeSuggestionResponse:response
                                                                     successBlock:successBlock
                                                                     failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)postRateForCard:(NSDictionary*)parameters
           successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
           failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:GetToKnowMeRate
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseRateArtWorkResponse:response
                                                           successBlock:successBlock
                                                           failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}



#pragma mark - Parse

+ (void)parseGetToKnowMeSuggestionResponse:(NSArray *)response
                              successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        NSError *parseError = nil;
        NSArray *artWorks = [MTLJSONAdapter modelsOfClass:ArtWork.class fromJSONArray:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(artWorks);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not an array of ArtWork", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
    }
}

+ (void)parseRateArtWorkResponse:(NSDictionary *)response
                    successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                    failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        ResponseDTO *responseMTL = [MTLJSONAdapter modelOfClass:[ResponseDTO class] fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(responseMTL);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a user", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
    }
}
//
@end
