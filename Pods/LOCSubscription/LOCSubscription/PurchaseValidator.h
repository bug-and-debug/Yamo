//
//  PurcahseValidator.h
//  Locassa
//
//  Absctract.
//  This calss sends receipt to the server and says
//  is purchase valid.
//
//  Created by Boris Yurkevich on 10/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SKPaymentTransaction;

@protocol PurchaseValidatorDelegate <NSObject>

@required
- (void)sendReceipt:(NSString *)receipt
     forTransaction:(SKPaymentTransaction *)transaction;

@end

@class SKPaymentTransaction;

@interface PurchaseValidator : NSObject

@property (weak, nonatomic) id <PurchaseValidatorDelegate> receiptSender;

- (void)validateTransaction:(SKPaymentTransaction *)aTransaction;

@end
