//
//  XHTabBar.m
//  Youchi
//
//  Created by Admin on 29/5/17.
//  Copyright © 2017 Hans. All rights reserved.
//

#import "XHTabBar.h"

#define TabBarBackgroundColor   RGBCOLOR(248,248,248)
#define NumMark_W_H             20
#define PointMark_W_H           12

static const float scale = 0.55f;

#pragma mark-@interface XHTabBarButton
@implementation XHTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = TabBarBackgroundColor;
    }
    
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat newX = 0;
    CGFloat newY =5;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height*scale-newY;
    return CGRectMake(newX, newY, newWidth, newHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat newX = 0;
    CGFloat newY = contentRect.size.height*scale;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height-contentRect.size.height*scale;
    return CGRectMake(newX, newY, newWidth, newHeight);
}

@end

#pragma mark-@interface XHTabBar
@implementation XHTabBar
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
        [self initData];
        [self initTabBar];
    }
    return self;
}

- (instancetype)initWithControllerArray:(NSArray *)controllerArray titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray selImageArray:(NSArray *)selImageArray height:(CGFloat )height
{
    self = [super init];
    if (self)
    {
        
        self.controllerArray =controllerArray;
        self.viewControllers = controllerArray;
        self.titleArray = titleArray;
        self.imageArray = imageArray;
        self.selImageArray = selImageArray;
        self.tabBarHeight = height;
        
        [self  initTabBar];
        
    }
    return self;
}

- (void)initData
{
  
}

- (void)initTabBar
{
    //hans nodified
    //[self createControllerBycontrollerArrayay:self.controllerArray];
    [self createTabBarView];
    [self setTabBarLine];
}

- (void)createControllerBycontrollerArrayay:(NSArray *)controllerArrayay
{
    if(controllerArrayay.count==0) NSLog(@"no controllers");
    NSMutableArray *tabBarArr = [[NSMutableArray alloc]init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    for (NSString *storyboardId in controllerArrayay)
    {
        UIViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
        [tabBarArr addObject:nav];
        
    }
    self.viewControllers = tabBarArr;
}

- (void)setTabBarLine
{
    if (self.tabBarHeight>49.0)
    {
        [self.tabBar setShadowImage:[[UIImage alloc] init]];
        [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self.tabBarView addSubview:lineLabel];
    }
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineLabel.backgroundColor = COLOR_LINE;
    [self.tabBarView addSubview:lineLabel];
}

- (void)createTabBarView
{
    if(!self.tabBarHeight||self.tabBarHeight<49.0) self.tabBarHeight=49.0;
    
    self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0,49.0-self.tabBarHeight,[UIScreen mainScreen].bounds.size.width,self.tabBarHeight)];
    [self.tabBar addSubview:self.tabBarView];
    
    if(self.selImageArray.count==0) NSLog(@"no sel images");
    if(self.imageArray.count==0) NSLog(@"no normal images");
    if(self.titleArray.count==0) NSLog(@"no titles");
    
    int num = (int)self.controllerArray.count;
    for(int i=0;i<num;i++)
    {
        XHTabBarButton *button = [[XHTabBarButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/num*i, 0, [UIScreen mainScreen].bounds.size.width/num,self.tabBarHeight)];
        button.tag = 1000+i;
        [button setTitleColor:TABBAR_TITLE_NORMAL_COLOR forState:UIControlStateNormal];
        [button setTitleColor:TABBAR_TITLE_SEL_COLOR forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:TABBAR_TITLE_FONT_SIZE];
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.selImageArray[i]] forState:UIControlStateSelected];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarView  addSubview:button];
        if (i==0)
        {
            button.selected=YES;
            self.seleBtn = button;
        }

        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width/2.0+6, 3, NumMark_W_H, NumMark_W_H)];
        numLabel.layer.masksToBounds = YES;
        numLabel.layer.cornerRadius = 10;
        numLabel.backgroundColor = [UIColor redColor];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:13];
        numLabel.tag = 1010+i;
        numLabel.hidden = YES;
        [button addSubview:numLabel];
    }
}

- (void)buttonAction:(UIButton *)button {
    
    NSInteger index = button.tag-1000;
    [self showControllerIndex:index];
    
}

- (void)showControllerIndex:(NSInteger)index
{
    if(index >= self.controllerArray.count)
    {
        NSLog(@"controller index overflow");
        return;
    }
    
    self.seleBtn.selected = NO;
    UIButton *button = (UIButton *)[self.tabBarView viewWithTag:1000+index];
    button.selected = YES;
    self.seleBtn = button;
    self.selectedIndex=index;
}

- (void)showBadgeMark:(NSInteger)badge index:(NSInteger)index
{
    if(index >= self.controllerArray.count)
    {
        NSLog(@"controller index overflow");
        return;
    }
    
    UILabel *numLabel = (UILabel *)[self.tabBarView viewWithTag:1010+index];
    numLabel.hidden=NO;
    CGRect nFrame = numLabel.frame;
    if(badge<=0)
    {
        [self hideMarkIndex:index];
    }
    else
    {
        if(badge>0&&badge<=9)
        {
            nFrame.size.width = NumMark_W_H;
        }
        else if (badge>9&&badge<=19)
        {
            nFrame.size.width = NumMark_W_H+5;
        }
        else
        {
            nFrame.size.width = NumMark_W_H+10;
        }
        nFrame.size.height = NumMark_W_H;
        numLabel.frame = nFrame;
        numLabel.layer.cornerRadius = NumMark_W_H/2.0;
        numLabel.text = [NSString stringWithFormat:@"%ld",badge];
        if(badge>99)
        {
            numLabel.text =@"99+";
        }
    }
}

- (void)showPointMarkIndex:(NSInteger)index
{
    if(index >= self.controllerArray.count)
    {
        NSLog(@"controller index overflow");
        return;
    }
    UILabel *numLabel = (UILabel *)[self.tabBarView viewWithTag:1010+index];
    numLabel.hidden=NO;
    CGRect nFrame = numLabel.frame;
    nFrame.size.height=PointMark_W_H;
    nFrame.size.width = PointMark_W_H;
    numLabel.frame = nFrame;
    numLabel.layer.cornerRadius = PointMark_W_H/2.0;
    numLabel.text = @"";
}

-(void)hideMarkIndex:(NSInteger)index
{
    if(index >= self.controllerArray.count)
    {
        NSLog(@"controller index overflow");
        return;
    }
    
    UILabel *numLabel = (UILabel *)[self.tabBarView viewWithTag:1010+index];
    numLabel.hidden = YES;
}

@end
