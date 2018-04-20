//
//  APIClient+Venue.h
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient.h"

@class RouteDTO;
@class SavePlaceDTO;
@class SearchDTO;
@class FilterSearchDTO;

@interface APIClient (Venue)

- (void)venueGetSingleRoute:(NSNumber *)routeId
           withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
               failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueToGetSingleVenueWithId:(NSNumber *)venueId
                        beforeBlock:(LOCApiClientBeforeLoadBlockType)beforeBlock
                         afterBlock:(LOCApiClientAfterLoadBlockType)afterBlock
                   withSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                       failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueListPlacesWithSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                           failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock
                             afterBlock:(LOCApiClientAfterLoadBlockType)afterBlock;

- (void)venueMarkFavoriteWithId:(NSNumber *)venueId
               withSuccessBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueMarkUnfavoriteWithId:(NSNumber *)venueId
                 withSuccessBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                     failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueSavePlace:(SavePlaceDTO *)savePlaceDTO
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueSaveRoute:(RouteDTO *)saveRouteDTO
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueEditRoute:(RouteDTO *)saveRouteDTO
           withRouteId:(NSNumber *)routeId
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueDeleteRouteWithId:(NSNumber *)routeId
                  successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueSearchVenuesWithSearchDTO:(SearchDTO *)searchDTO
                          successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueListTagGroupsWithSuccessBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueFilterSearchForMapWithFilterSearchDTO:(FilterSearchDTO *)filterSearchDTO
                                      successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                                      failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)getFavorites:(FilterSearchDTO *)filterSearchDTO
                                      successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                                      failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueFilterSearchForListWithFilterSearchDTO:(FilterSearchDTO *)filterSearchDTO
                                       successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                                       failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)venueDeleteRouteWithRouteId:(NSNumber *)routeId
                        successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                        failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

@end
