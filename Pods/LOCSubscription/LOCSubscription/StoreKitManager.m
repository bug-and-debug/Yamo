//
//  StoreKitManager.m
//  Locassa
//
//  Abstract:
//  Retrieves product information from the App Store using SKRequestDelegate,
//    SKProductsRequestDelegate,SKProductsResponse, and SKProductsRequest.
//    Notifies its observer with a list of products available for sale along with
//    a list of invalid product identifiers. Logs an error message if the product
//    request failed.
//
//  Created by Mo Moosa on 04/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PremiumModel.h"
#import "StoreKitManager.h"

NSString * const IAPProductRequestNotification = @"IAPProductRequestNotification";

@interface StoreKitManager () <SKRequestDelegate, SKProductsRequestDelegate>

@property (nonatomic) SKProductsRequest *request;

@end


@implementation StoreKitManager


#pragma mark - Initialization

+ (StoreKitManager *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static StoreKitManager * storeManagerSharedInstance;
    
    dispatch_once(&onceToken, ^{
        storeManagerSharedInstance = [StoreKitManager new];
    });
    return storeManagerSharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    if (self != nil) {
        _availableProducts = [[NSMutableArray alloc] initWithCapacity:0];
        _invalidProductIds = [[NSMutableArray alloc] initWithCapacity:0];
        _productRequestResponse = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark Request information

// Fetch information about your products from the App Store.
- (void)fetchProductInformationForIds:(NSArray *)productIds {
    self.productRequestResponse = [[NSMutableArray alloc] initWithCapacity:0];
    // Create a product request object and initialize it with our product identifiers
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIds]];
    request.delegate = self;
    
    // Send the request to the App Store
    [request start];
}

RequestProductsCompletionHandler _completionHandler;
SKProductsRequest * _productsRequest;

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    _completionHandler = [completionHandler copy];
    
    // Load the product identifiers fron ProductIds.plist
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"ProductIds"
                                              withExtension:@"plist"];
    NSArray *productIds = [NSArray arrayWithContentsOfURL:plistURL];
    NSSet *set = [NSSet setWithArray:productIds];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

#pragma mark - SKProductsRequestDelegate

// Used to get the App Store's response to your request and notifies your observer
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    PremiumModel *model = nil;
    
    // The products array contains products whose identifiers have been recognized by the App Store.
    // As such, they can be purchased. Create an "AVAILABLE PRODUCTS" model object.
    if ((response.products).count > 0) {
        model = [[PremiumModel alloc] initWithName:@"AVAILABLE PRODUCTS" elements:response.products];
        [self.productRequestResponse addObject:model];
        self.availableProducts = [NSMutableArray arrayWithArray:response.products];
    }
    
    // The invalidProductIdentifiers array contains all product identifiers not recognized by the App Store.
    // Create an "INVALID PRODUCT IDS" model object.
    if ((response.invalidProductIdentifiers).count > 0) {
        
        model = [[PremiumModel alloc] initWithName:@"INVALID PRODUCT IDS" elements:response.invalidProductIdentifiers];
        [self.productRequestResponse addObject:model];
        self.invalidProductIds = [NSMutableArray arrayWithArray:response.invalidProductIdentifiers];
    }
    
    self.status = IAPProductRequestResponse;
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPProductRequestNotification
                                                        object:self];
    
    if (_completionHandler) {
        _productsRequest = nil;
        NSArray * skProducts = response.products;
        _completionHandler(YES, skProducts);
        _completionHandler = nil;
    }
}

#pragma mark SKRequestDelegate method

// Called when the product request failed.
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    self.status = IAPRequestFailed;
    self.errorMessage = error.localizedDescription;
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPProductRequestNotification
                                                        object:self];
    
    NSLog(@"Product Request Failed: %@", error.localizedDescription);
}

@end
