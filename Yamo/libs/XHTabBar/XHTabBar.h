//
//  XHTabBar.h
//  Youchi
//
//  Created by Admin on 29/5/17.
//  Copyright © 2017 Hans. All rights reserved.
//

@interface XHTabBarButton : UIButton
{
    
}

@end

@interface XHTabBar : UITabBarController
{
    
}
@property(nonatomic,strong)UIButton *seleBtn;
@property(nonatomic,strong)UIView *tabBarView;
@property(nonatomic,assign)CGFloat tabBarHeight;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *selImageArray;
@property(nonatomic,strong)NSArray *controllerArray;

- (instancetype)initWithControllerArray:(NSArray *)controllerArray titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray selImageArray:(NSArray *)selImageArray height:(CGFloat )height;
- (void)showControllerIndex:(NSInteger)index;
- (void)showBadgeMark:(NSInteger)badge index:(NSInteger)index;
- (void)showPointMarkIndex:(NSInteger)index;
- (void)hideMarkIndex:(NSInteger)index;
@end

