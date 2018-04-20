/*
 
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Implements the SKPaymentTransactionObserver protocol. Handles purchasing and restoring products
 as well as downloading hosted content using paymentQueue:updatedTransactions: and paymentQueue:updatedDownloads:,
 respectively. Provides download progress information using SKDownload's progres. Logs the location of the downloaded
 file using SKDownload's contentURL property.
 
 */

@import StoreKit;

extern NSString *_Nonnull const IAPPurchaseNotification;

@protocol StoreObserverDelegate;

@interface StoreObserver : NSObject <SKPaymentTransactionObserver>

typedef NS_ENUM(NSInteger, IAPPurchaseNotificationStatus) {
    
    IAPPurchaseFailed = 0, // Indicates that the purchase was unsuccessful
    IAPPurchaseSucceeded = 1, // Indicates that the purchase was successful
    IAPRestoredFailed = 2, // Indicates that restoring products was unsuccessful
    IAPRestoredSucceeded = 3, // Indicates that restoring products was successful
    IAPDownloadStarted = 4, // Indicates that downloading a hosted content has started
    IAPDownloadInProgress = 5, // Indicates that a hosted content is currently being downloaded
    IAPDownloadFailed = 6,  // Indicates that downloading a hosted content failed
    IAPDownloadSucceeded = 7, // Indicates that a hosted content was successfully downloaded
    IAPPurchaseDeferred = 9, // Indicates that user needs permission from a family owner
    IAPPurchaseCancelled = 1001, // Indicates that user taps on cancel button
    IAPPurchaseUpgradeFailed = 1002 // Server get receipt but something wrong with it
};
// 1000 and up is Locassa namespace in case Apple introduces new errror statuses.

@property (nonatomic) IAPPurchaseNotificationStatus status;

// Keep track of all purchases
@property (nonatomic, strong) NSMutableArray *_Nonnull productsPurchased;
// Keep track of all restored purchases
@property (nonatomic, strong) NSMutableArray *_Nonnull productsRestored;

@property (nonatomic, copy) NSString *_Nonnull message;

// Keep track of the purchased/restored product's identifier
@property (nonatomic, copy) NSString *_Nonnull purchasedID;

@property (nonatomic, weak) id <StoreObserverDelegate> _Nullable delegate;


-(BOOL)hasPurchasedProducts;

+ (StoreObserver *_Nonnull)sharedInstance;
// Implement the purchase of a product
-(void)buy:(SKProduct *_Nonnull)product;

// Only call this on successful purchase
- (void)completeTransaction:(SKPaymentTransaction *_Nonnull)transaction
                  forStatus:(IAPPurchaseNotificationStatus)status;

- (void)purchaseFailedForTransaction:(SKPaymentTransaction *_Nonnull)transaction
                         withMessage:(NSString * _Nullable)message;

@end


@protocol StoreObserverDelegate <NSObject>

- (void)storeObserverShouldValidateReceipt:(NSString * _Nonnull)receipt
                            forTransaction:(SKPaymentTransaction * _Nonnull)transaction
                           completionBlock:(void (^ _Nullable)())completionBlock
                              failureBlock:(void (^ _Nullable)(NSInteger errorCode, NSString * _Nonnull errorMessage))failureBlock;

@end

