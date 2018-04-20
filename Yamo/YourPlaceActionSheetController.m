//
//  YourPlaceActionSheetController.m
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlaceActionSheetController.h"
#import "YourPlaceOptionTableViewCell.h"

@interface YourPlaceActionSheetController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray<YourPlaceOption *> *dataSource;

@end

@implementation YourPlaceActionSheetController

- (instancetype)initWithTableView:(UITableView *)tableView {
    
    if (self = [super init]) {
        
        self.tableView = tableView;
        self.dataSource = [self generateDataSource];
        
        [self setupTableView];
        
        [self.tableView reloadData];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(YourPlaceOptionTableViewCell.class) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass(YourPlaceOptionTableViewCell.class)];
}

#pragma mark - Data

- (NSArray<YourPlaceOption *> *)generateDataSource {
    
    return @[ [[YourPlaceOption alloc] initWithType:YourPlaceOptionTypeHome],
              [[YourPlaceOption alloc] initWithType:YourPlaceOptionTypeWork],
              ];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YourPlaceOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YourPlaceOptionTableViewCell.class) forIndexPath:indexPath];
    
    YourPlaceOption *option = self.dataSource[indexPath.row];
    [cell populateCellForData:option];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(yourPlaceActionSheetController:didSelectEditOptionType:)]) {
        YourPlaceOptionType selectedOptionType = self.dataSource[indexPath.row].type;
        [self.delegate yourPlaceActionSheetController:self didSelectEditOptionType:selectedOptionType];
    }
}

@end
