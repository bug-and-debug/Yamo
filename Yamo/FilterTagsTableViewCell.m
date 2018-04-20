//
//  FilterTagsCell.m
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterTagsTableViewCell.h"
#import "FilterTagsCollectionViewLayout.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"

const CGFloat FilterTagsTableViewCellExpandedHeight = 160.0f;
const CGFloat FilterTagsTableViewCellDefaultHeight = 45.0f;

@interface FilterTagsTableViewCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation FilterTagsTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource>)dataSourceDelegate
                                   forIndex:(NSInteger)index {
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FilterTagsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    
    FilterTagsCollectionViewLayout *layout = [[FilterTagsCollectionViewLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 15.0, 35.0, 15.0);
    
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.tag = index;
    [self.collectionView reloadData];
}

- (CGFloat)heightForCell {
    
    [self.collectionView layoutIfNeeded];
    return [self.collectionView.collectionViewLayout collectionViewContentSize].height;
}

@end
