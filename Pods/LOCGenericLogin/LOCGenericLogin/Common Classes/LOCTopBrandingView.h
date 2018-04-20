//
//  LOCTopBrandingView.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCBaseView.h"

@interface LOCTopBrandingView : LOCBaseView

@property (nonatomic, strong) UIImage *brandLogoImage;

- (void)updateImageVerticalPadding:(CGFloat)padding;

@end
