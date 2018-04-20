//
//  LOCApiBlockDefinitions.h
//  LOCManagers
//
//  Created by Peter Su on 11/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@class LOCSessionManager;

typedef void (^ _Nullable LOCApiClientSuccessEmptyBlockType)(void);
typedef void (^ _Nullable LOCApiClientSuccessArrayBlockType)(NSArray * _Nullable elements);
typedef void (^ _Nullable LOCApiClientSuccessArrayPaginatedBlockType)(NSArray * _Nullable elements, BOOL isLast);
typedef void (^ _Nullable LOCApiClientSuccessSingleBlockType)(id _Nullable element);
typedef void (^ _Nullable LOCApiClientErrorBlockType)(NSError * _Nonnull error);
typedef void (^ _Nullable LOCApiClientErrorWithContextBlockType)(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context);
typedef void (^ _Nullable LOCApiClientBeforeLoadBlockType)(void);
typedef void (^ _Nullable LOCApiClientAfterLoadBlockType)(void);

typedef void (^ _Nonnull LOCApiClientSessionManagerBlock)(LOCSessionManager * _Nonnull sessionManager);
