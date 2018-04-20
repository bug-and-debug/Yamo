# Deprecated

Deprecated in favour of `LOCSubscription-Siwft`


# README #

This README document steps are necessary to get your In-App Purchase up and running.

### What is this repository for? ###

* Auto renewable subscription with StoreKit
* Has a recommended option to validate receipt on the server
* Used in Vesta and Camra
* Version 0.0.6
* Requires iOS 8

### How do I get set up? ###

You will need acces to iTunes Connect. Create IAP (In-App Purchase)  product in iTunes Connect. Copy product identifier into the `ProductIds.plist.` Example project includes this plist.

Add following to your `Podfile`

	source 'https://bitbucket.org/locassa/specs'

	platform :ios, '8.0'
	pod 'LOCSubscription'
	
Run `pod install`

Look into the Example folder to get an idea how to use this subscription. You will need to create your own View Controller with a buy button.

Note although Apple recommends for auto renewable subscriptions to have a restore purchase button, normally server manages subscription, hence, restore is not needed. This is reflected in this component. When user tries to use the same iTunes and App Store ID for the different whatever project you're working on account, transaction will be finished and appropriate alert is presented. E.g. *Upgrade Failed. The Apple ID account was already used to promote another account.*

#### Server Side Receipt Validation. ####

Server side receipt validation is recommended by Apple and provides benefits. Not just it is more secure and guarantees only legit purchases but also, even more imporant, it gives server real subscription expiration date from the receipt. Watch this [WWDC video](https://developer.apple.com/videos/play/wwdc2012-308/) to learn more.

Make sure your server developer is familiar with the following [material.](https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Introduction.html)

Generate shared secret in iTunes Connect and provide your developer with it. Shared secret must be stored on server.

Store receipts on sever. Make sure a database field can fit it. Receipt can have  ~7 000 characters.

If you decide to use server side validation, you will need to handle a network request to send a receipt to your server. You can get a receipt string and StoreKit transaction by setting `receiptSender` delegate for the `PurchaseValidator` and conforming to the `PurchaseValidatorDelegate` protocol.

Finish transaction when receipt delivered to a server. Even if receipt is not valid, expired etc., still finish transaction. When something went wrong with a receipt and you know that server is not going to ulock a product — use `IAPPurchaseUpgradeFailed` transaction state and give customer an appropriate error alert. Look into the Example project to get this alert.

Here is a sample code Locassa uses in Vesta. You will need somehitng like this in you class which conforms to the `PurchaseValidatorDelegate.`

	// Send JSON to the server
    [VestaApiClient userPromoteWithOnSuccess:^(UserSubscription * _Nullable subscription) {
        
        	// When server returns subscription objects this means
        	// receipt was validated sucesfully
        	[[StoreObserver sharedInstance] completeTransaction:self.transaction
                                                  forStatus:IAPPurchaseSucceeded];
        
    	} onError:^(NSError * _Nonnull error) {
    
       	 if (error) {
            
            	// Extract our message from the error
            	NSError *jsonError = nil;
            	NSDictionary *errorDisctionary = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
            	if (!jsonError) {
            
                	// Several erorrs can occur e.g. customer subscribed on
                	// another Vesta account, we need to finish transaction.
                	// Otherwise receipt will be sent again.
                	//
                	// However if server tells us at least
                	// something we know that server has receipt.
                	// Even if receipt is not valid we still need to finish
                	// the trnasaction.
                	// Server is reponcible for the final subscription activation.
                
                	StoreObserver *storeObserver = [StoreObserver sharedInstance];
                	storeObserver.message = errorDisctionary[@"message"];
                	[storeObserver completeTransaction:self.transaction
                                         forStatus:IAPPurchaseUpgradeFailed];
            	} else {
                	// Can't send receipt to our server. Will try again later with error
                	[[StoreObserver sharedInstance] purchaseFailedForTransaction:self.transaction
                                                                 withMessage:error.localizedDescription];
            }
        	} else {
            	// Can't send receipt to our server. Will try again later without error
            	[[StoreObserver sharedInstance] purchaseFailedForTransaction:self.transaction
                                                             withMessage:nil];
        }
        
        
    	} receipt:receiptContainer];

### Contribution guidelines. ###

Before modifying this code make sure you are familar with the [StoreKitSuite](https://developer.apple.com/library/ios/samplecode/sc1991/Introduction/Intro.html) 
LOCSubscription is simplified StoreKitSuite. Apple sample project should have all the extras you might want from the your IAP, for example, downlaodable products.

You can review, change this code and you can add tests. If you need to work on something else in the IAP area, for example, consumable purchases, I recommend you to fork this coponent. For example, we don't want you to add restore purcahse button to keep it reusable with projects that need a subscription.

### Further reading. ###

* [In-App Purchase for Developers](https://developer.apple.com/in-app-purchase/)
*  Watch [WWDC video](https://developer.apple.com/videos/play/wwdc2012-308/) about server side receipt validation

### Who do I talk to? ###

Contact developers.

Component creator:
[boris.yurkevich@locassa.com](mailto:boris.yurkevich@locassa.com)
[boris.yurkevich@gmail.com](mailto:boris.yurkevich@gmail.com) 

Team leader:
Jose Fernandez
[jose.fernandez@locassa.com](mailto:jose.fernandez@locassa.com)

When coponent creator is not avalible:
Mo Moossa
[mo.moosa@locassa.com](mailto:mo.moosa@locassa.com)