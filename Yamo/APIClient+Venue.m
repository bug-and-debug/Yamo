//
//  APIClient+Venue.m
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient+Venue.h"
#import "Venue.h"
#import "VenueSearchSummary.h"
#import "Route.h"
#import "Place.h"
#import "SavePlaceDTO.h"
#import "RouteDTO.h"
#import "SearchDTO.h"
#import "TagGroup.h"
#import "FilterSearchDTO.h"
#import "ResponseDTO.h"

static NSString * const VenuePathGetSingleRoute = @"venue/route/%@";
static NSString * const VenuePathGetSingleVenue = @"venue/%@";
static NSString * const VenuePathGetVenueSummaries = @"venue/list";
static NSString * const VenuePathListPlaces = @"venue/place/list";
static NSString * const VenuePathFavorite = @"venue/%@/favourite";
static NSString * const VenuePathSavePlace = @"venue/place/save";
static NSString * const VenuePathSaveRoute = @"venue/route/save";
static NSString * const VenuePathSearchVenues = @"venue/search";
static NSString * const VenuePathListTagGroup = @"venue/tag/group/list";
static NSString * const VenuePathFilterSearchForMap = @"venue/filter/searchV2";
static NSString * const VenuePathFilterSearchForList = @"venue/filter/searchV3";
static NSString * const VenuePathFilterFavourites = @"venue/filter/favourite";

@implementation APIClient (Venue)

- (void)venueGetSingleRoute:(NSNumber *)routeId
           withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
               failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *path = [NSString stringWithFormat:VenuePathGetSingleRoute, routeId];
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:path
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForRoute:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueToGetSingleVenueWithId:(NSNumber *)venueId
                        beforeBlock:(LOCApiClientBeforeLoadBlockType)beforeBlock
                         afterBlock:(LOCApiClientAfterLoadBlockType)afterBlock
                   withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                       failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *path = [NSString stringWithFormat:VenuePathGetSingleVenue, venueId];
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:path
                             parameters:nil
                             beforeLoad:beforeBlock
                              afterLoad:afterBlock
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForVenue:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueListPlacesWithSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                           failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock
                             afterBlock:(LOCApiClientAfterLoadBlockType)afterBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {

        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:VenuePathListPlaces
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:afterBlock
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForPlaces:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueMarkFavoriteWithId:(NSNumber *)venueId
               withSuccessBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *path = [NSString stringWithFormat:VenuePathFavorite, venueId];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:path
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForVenue:response withSuccessBlock:^(NSArray * _Nullable elements) {
                                        
                                        if (successBlock) {
                                            successBlock();
                                        }
                                        
                                    } failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueMarkUnfavoriteWithId:(NSNumber *)venueId withSuccessBlock:(LOCApiClientSuccessEmptyBlockType)successBlock failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *path = [NSString stringWithFormat:VenuePathFavorite, venueId];
        
        [sessionManager requestWithType:LOCNetworkRequestTypeDelete
                                   path:path
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForVenue:response withSuccessBlock:^(NSArray * _Nullable elements) {
                                        
                                        if (successBlock) {
                                            successBlock();
                                        }
                                        
                                    } failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueSavePlace:(SavePlaceDTO *)savePlaceDTO
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:savePlaceDTO error:nil];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:VenuePathSavePlace
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForPlace:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}

- (void)venueSaveRoute:(RouteDTO *)saveRouteDTO
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:saveRouteDTO error:nil];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:VenuePathSaveRoute
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForRoute:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueEditRoute:(RouteDTO *)saveRouteDTO
           withRouteId:(NSNumber *)routeId
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {

    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *path = [NSString stringWithFormat:VenuePathGetSingleRoute, routeId];
        NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:saveRouteDTO error:nil];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:path
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForRoute:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueDeleteRouteWithId:(NSNumber *)routeId
                  successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *path = [NSString stringWithFormat:VenuePathGetSingleRoute, routeId];
        
        [sessionManager requestWithType:LOCNetworkRequestTypeDelete
                                   path:path
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseStandardResponse:response successBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueSearchVenuesWithSearchDTO:(SearchDTO *)searchDTO
                          successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
    
        NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:searchDTO error:nil];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:VenuePathSearchVenues
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForVenues:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueListTagGroupsWithSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:VenuePathListTagGroup
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForTagGroups:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueFilterSearchForMapWithFilterSearchDTO:(FilterSearchDTO *)filterSearchDTO
                                successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:filterSearchDTO error:nil];
        parameters = [self cleaupFilterSearchDTOParameters:parameters];
        NSLog(@"Parameters: %@", parameters);
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:VenuePathFilterSearchForMap
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForVenueSearchSummaries:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)getFavorites:(FilterSearchDTO *)filterSearchDTO
        successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
        failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock
{
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:filterSearchDTO error:nil];
        parameters = [self cleaupFilterSearchDTOParameters:parameters];
        NSLog(@"Parameters: %@", parameters);
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:VenuePathFilterFavourites
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForVenueSearchSummaries:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)venueFilterSearchForListWithFilterSearchDTO:(FilterSearchDTO *)filterSearchDTO
                                      successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                                      failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:filterSearchDTO error:nil];
        parameters = [self cleaupFilterSearchDTOParameters:parameters];
        NSLog(@"Parameters: %@", parameters);
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:VenuePathFilterSearchForList
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForVenueSearchSummaries:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (NSDictionary *)cleaupFilterSearchDTOParameters:(NSDictionary *)parameters {
    
    NSMutableDictionary *mutableDictionary = parameters.mutableCopy;
    
    if (mutableDictionary[@"search"] && [mutableDictionary[@"search"] isEqual:[NSNull null]]) {
        [mutableDictionary removeObjectForKey:@"search"];
    }
    
    if (mutableDictionary[@"tagIds"]) {
    
        NSArray *tagIds = mutableDictionary[@"tagIds"];
        if ([tagIds isKindOfClass:NSArray.class]) {
            if (tagIds.count == 0) {
                [mutableDictionary removeObjectForKey:@"tagIds"];
            }
        }
    }
    
    return mutableDictionary;
}

- (void)venueDeleteRouteWithRouteId:(NSNumber *)routeId
                                successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *URLPath = [NSString stringWithFormat:VenuePathGetSingleRoute, routeId];

    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeDelete
                                   path:URLPath
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseResponseForResponseDTO:response withSuccessBlock:successBlock failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

#pragma mark - Parser

- (void)parseResponseForRoute:(NSDictionary *)response
             withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        Route *route = [MTLJSONAdapter modelOfClass:Route.class fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(route);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, -1, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a route", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }
}

- (void)parseResponseForVenueSearchSummaries:(id)response
                            withSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        NSArray *responseArray = (NSArray *)response;
        
        NSError *parseError = nil;
        
        NSArray *venueSummaries = [MTLJSONAdapter modelsOfClass:[VenueSearchSummary class] fromJSONArray:responseArray error:&parseError];
        
        if (failureBlock && parseError) {
            
            failureBlock(parseError, -1, @"Could not parse venueSummaries response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                
                successBlock(venueSummaries);
            }
            else {
                
                if (failureBlock) {
                    
                    failureBlock(parseError, -1, @"Could not parse venueSummaries response.");
                }
            }
        }
    }
    else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not an array of venue summaries.", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }

}


- (void)parseResponseForVenue:(NSDictionary *)response
             withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        Venue *venue = [MTLJSONAdapter modelOfClass:Venue.class fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(venue);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, -1, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a venue", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }
}

- (void)parseResponseForPlace:(NSDictionary *)response
             withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        
        Place *place = [MTLJSONAdapter modelOfClass:Place.class fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(place);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, -1, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a place", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }
}

- (void)parseResponseForVenues:(NSArray *)response
              withSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        NSError *parseError = nil;
        NSArray <Venue *> *venues = [MTLJSONAdapter modelsOfClass:Venue.class fromJSONArray:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(venues);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, -1, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not an array of venues", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }
}

- (void)parseResponseForPlaces:(NSArray *)response
              withSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        NSError *parseError = nil;
        
        NSArray<Place *> *places = [MTLJSONAdapter modelsOfClass:Place.class fromJSONArray:response error:&parseError];;
        
        if (failureBlock && parseError) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(places);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, -1, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not an array of places", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }
}

- (void)parseResponseForTagGroups:(NSArray *)response
                 withSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                     failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        NSError *parseError = nil;
        
        NSArray<TagGroup *> *tagGroups = [MTLJSONAdapter modelsOfClass:TagGroup.class fromJSONArray:response error:&parseError];;
        
        if (failureBlock && parseError) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(tagGroups);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, -1, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not an array of places", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }
}

- (void)parseResponseForResponseDTO:(NSDictionary *)response
             withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock  {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        ResponseDTO *route = [MTLJSONAdapter modelOfClass:ResponseDTO.class fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(route);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, -1, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a route", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, -1, @"Could not parse response");
        }
    }
}


@end
