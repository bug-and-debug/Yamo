//
//  Notification.m
//  Yamo
//
//  Created by Dario Langella on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "Notification.h"
@import MTLModel_LOCExtensions;

@implementation Notification

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[  ]
                                                             dictionary:@{ }];
    return propertyMappings;
}

+ (NSValueTransformer *)typeJSONTransformer {
    NSDictionary *types = @{
                            @"CURRENT_LOCATION_SUGGESTION" : @(NotificationTypeCurrentLocationSuggestion),
                            @"GET_TO_KNOW_ME_REMINDER" : @(NotificationTypeGetToKnowMe),
                            @"EXHIBITION_SUGGESTION" : @(NotificationTypeExibition),
                            @"FACEBOOK_FRIEND_JOINED" : @(NotificationTypeFacebookFriend),
                            @"UNSPECIFIED" : @(NotificationTypeUnspecified),
                            };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:types
                                                            defaultValue:@(NotificationTypeUnspecified)
                                                     reverseDefaultValue:@(NotificationTypeUnspecified)];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self timestampToDateTransformer];
}

#pragma mark - Helper

+ (NSString *)displayTextForNotification:(Notification *)notification {
    
    NSString *displayUser = notification.userText ? notification.userText : @"";
    NSString *displayVenue = notification.venueText ? notification.venueText : @"";
    NSString *displayExhibition = notification.altText ? notification.altText : @"";
    
    switch (notification.type) {
        case NotificationTypeFacebookFriend: {
            
            return [NSString stringWithFormat:NSLocalizedString(@"Your Facebook friend %@ just joined Yamo!", nil), displayUser];
        }
        case NotificationTypeCurrentLocationSuggestion: {
            
            return [NSString stringWithFormat:NSLocalizedString(@"We've found a few exhibitions for you! Check out %@ at the %@", nil), displayExhibition, displayVenue];

        }
        case NotificationTypeExibition: {
            
            return [NSString stringWithFormat:NSLocalizedString(@"A great exhibition for you! Check out %@ at the %@", nil), displayExhibition, displayVenue];
        }
        case NotificationTypeGetToKnowMe: {
            
            return [NSString stringWithFormat:NSLocalizedString(@"We'd like to get to know you better so we can provide accurate suggestions.", nil)];
        }
        default:
            return @"";
    }
}

@end
