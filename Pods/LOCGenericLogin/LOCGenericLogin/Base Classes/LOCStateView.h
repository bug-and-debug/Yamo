//
//  LOCStateView.h
//  GenericLogin
//
//  Created by Peter Su on 25/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCBaseView.h"

@protocol LOCStateViewDelegate <NSObject>

- (UIView *)topView;
- (UIView *)middleView;
- (UIView *)bottomView;

- (NSArray<UITextField *> *)formTextFields;
- (NSArray<UIButton *> *)formValidatedButtons;

- (NSDictionary *)formValuesWithKeys;

@end

@interface LOCStateView : LOCBaseView <LOCStateViewDelegate>

@end
