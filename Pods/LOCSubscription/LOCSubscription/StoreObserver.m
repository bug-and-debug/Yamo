/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Implements the SKPaymentTransactionObserver protocol. Handles purchasing and restoring products
 as well as downloading hosted content using paymentQueue:updatedTransactions: and paymentQueue:updatedDownloads:,
 respectively. Provides download progress information using SKDownload's progres. Logs the location of the downloaded
 file using SKDownload's contentURL property.
 */


#import "StoreObserver.h"
#import "PurchaseValidator.h"

NSString * const IAPPurchaseNotification = @"IAPPurchaseNotification";

@interface StoreObserver () <PurchaseValidatorDelegate>

@end

@implementation StoreObserver

+ (StoreObserver *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static StoreObserver * storeObserverSharedInstance;
    
    dispatch_once(&onceToken, ^{
        storeObserverSharedInstance = [[StoreObserver alloc] init];
    });
    return storeObserverSharedInstance;
}


- (instancetype)init {
    
    self = [super init];
    if (self != nil) {
        _productsPurchased = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}


#pragma mark - Make a purchase

// Create and add a payment request to the payment queue
-(void)buy:(SKProduct *)product {
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma mark - Has purchased products

// Returns whether there are purchased products
- (BOOL)hasPurchasedProducts {
    
    // productsPurchased keeps track of all our purchases.
    // Returns YES if it contains some items and NO, otherwise
    return (self.productsPurchased.count > 0);
}


#pragma mark - SKPaymentTransactionObserver methods

// Called when there are trasactions in the payment queue
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState ) {
                
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStateDeferred: {
                // Do not block your UI. Allow the user to continue using your app.
                self.status = IAPPurchaseDeferred;
                
                NSString *productName = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Thank you. Please wait for your family member to authorise this purchase. Continue to use %@.", @"Purchase status alert on transaction deferred"), productName];
                self.message = message;
                [[NSNotificationCenter defaultCenter] postNotificationName:IAPPurchaseNotification
                                                                    object:self];
                break;
            }
                // The purchase was successful
            case SKPaymentTransactionStatePurchased: {
                
                self.purchasedID = transaction.payment.productIdentifier;
                [self.productsPurchased addObject:transaction];
                
                // Persist receipt on our server
                PurchaseValidator *validator = [PurchaseValidator new];
                validator.receiptSender = self;
                [validator validateTransaction:transaction];
                break;
            }
                // There are restored products
            case SKPaymentTransactionStateRestored: {
                
                // Never called assuming subscription is managed by server.
                // There's no restore button. Leaving it here in case
                // App Store would call this automatically during normal
                // purhcase.
                
                self.purchasedID = transaction.payment.productIdentifier;
                
                // Server should already have a receipt, no need to send it again
                [self completeTransaction:transaction forStatus:IAPRestoredSucceeded];
                break;
            }
                // The transaction failed
            case SKPaymentTransactionStateFailed: {
                [self purchaseFailedForTransaction:transaction
                                       withMessage:nil];
                break;
            }
            default:
                break;
        }
    }
}

- (void)purchaseFailedForTransaction:(SKPaymentTransaction *)transaction
                         withMessage:(NSString * _Nullable)message {
    
    // Build nice error message without (nil)
    // Note alert is not displayed when Upsell subscription view controller is not
    // displayed.
    NSString *errorMessage;
    if (transaction.error.localizedDescription && message) {
        // Full error
        errorMessage = [NSString stringWithFormat:@"%@ %@",transaction.error.localizedDescription, message];
    } else if (transaction.error.localizedDescription) {
        errorMessage = transaction.error.localizedDescription;
    } else if (message) {
        errorMessage = message;
    } else {
        errorMessage = NSLocalizedString(@"Your purchase was not finished. Please try again later. Contact us if problem persists.", @"Purchase alert body");
    }
    self.message = errorMessage;
    
    if (transaction.error.code == SKErrorPaymentCancelled) {
        self.status = IAPPurchaseCancelled;
    } else {
        self.status = IAPPurchaseFailed;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPPurchaseNotification
                                                        object:self];
}


// Logs all transactions that have been removed from the payment queue
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    
    for(SKPaymentTransaction * transaction in transactions) {
        NSLog(@"%@ was removed from the payment queue.", transaction.payment.productIdentifier);
    }
}


// Called when an error occur while restoring purchases. Notify the user about the error.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    if (error.code != SKErrorPaymentCancelled) {
        self.status = IAPRestoredFailed;
        self.message = error.localizedDescription;
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPPurchaseNotification
                                                            object:self];
    }
}


// Called when all restorable transactions have been processed by the payment queue
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
    // All restorable transactions have been processed by the payment queue.
    self.status = IAPRestoredSucceeded;
    self.message = NSLocalizedString(@"Your purchase restored successfully.", @"Purchase Status");
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPPurchaseNotification
                                                        object:self];
}


#pragma mark - Complete transaction

// Notify the user about the purchase process. Start the download process if status is
// IAPDownloadStarted. Finish all transactions, otherwise.
- (void)completeTransaction:(SKPaymentTransaction *_Nonnull)transaction
                  forStatus:(IAPPurchaseNotificationStatus)status {
    
    if (status != IAPPurchaseSucceeded && status != IAPPurchaseUpgradeFailed) {
        NSLog(@"🚫 Never call completeTransaction: when purchase is not successful.");
        return;
    }
    
    self.status = status;
    //Do not send any notifications when the user cancels the purchase
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Notify customer
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPPurchaseNotification
                                                            object:self];
    } else {
        self.status = IAPPurchaseCancelled;
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPPurchaseNotification
                                                            object:self];
    }
    
    // Removes transaciton from queue
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - PurchaseValidatorDelegate

- (void)sendReceipt:(NSString *)receipt
     forTransaction:(SKPaymentTransaction *)transaction {
    
    if ([self.delegate respondsToSelector:@selector(storeObserverShouldValidateReceipt:forTransaction:completionBlock:failureBlock:)]) {
        
        [self.delegate storeObserverShouldValidateReceipt:receipt
                                           forTransaction:transaction
                                          completionBlock:^{
                                              
                                              [[StoreObserver sharedInstance] completeTransaction:transaction
                                                                                        forStatus:IAPPurchaseSucceeded];
                                          } failureBlock:^(NSInteger errorCode, NSString *errorMessage) {
                                              
                                              StoreObserver *storeObserver = [StoreObserver sharedInstance];
                                              storeObserver.message = errorMessage;
                                              [storeObserver completeTransaction:transaction
                                                                       forStatus:IAPPurchaseUpgradeFailed];
                                          }];
    } else {
        StoreObserver *storeObserver = [StoreObserver sharedInstance];
        storeObserver.message = @"";
        [storeObserver completeTransaction:transaction
                                 forStatus:IAPPurchaseUpgradeFailed];
    }
}

@end
