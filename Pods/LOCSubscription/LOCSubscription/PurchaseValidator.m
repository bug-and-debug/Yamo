//
//  PurcahseValidator.m
//  Locassa
//
//  Absctract.
//  This calss sends receipt to the server and says
//  is purchase valid.
//
//  Created by Boris Yurkevich on 10/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PurchaseValidator.h"
#import "StoreObserver.h"

@interface PurchaseValidator() <SKRequestDelegate>
@property (strong, nonatomic) SKPaymentTransaction *transaction;
@end

@implementation PurchaseValidator

- (void)validateTransaction:(SKPaymentTransaction *)aTransaction {
    
    // Save transaction for later so we can finish it
    self.transaction = aTransaction;
    
    NSURL *receiptURL = nil;
    NSBundle *bundle = [NSBundle mainBundle];
    receiptURL = [bundle appStoreReceiptURL];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:receiptURL.path];
    
    if (fileExists == YES) {
        // App Store Receipt now exists
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        
        NSString *base64String = [receipt base64EncodedStringWithOptions:0];
        
        // Should finish transaction when receipt delivered.
        if ([self.receiptSender respondsToSelector:@selector(sendReceipt:forTransaction:)]) {
            [self.receiptSender sendReceipt:base64String forTransaction:self.transaction];
        }
        
    } else {
        // Receipt retrival. Something went wrong while obtaining the receipt,
        // maybe the user did not successfully enter it's credentials
        [[StoreObserver sharedInstance] purchaseFailedForTransaction:self.transaction
                                                         withMessage:nil];
    }
}

@end
