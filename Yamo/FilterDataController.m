//
//  FilterDataController.m
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterDataController.h"
#import "FilterSwitchTableViewCell.h"
#import "FilterTagsTableViewCell.h"
#import "FilterSliderTableViewCell.h"
#import "APIClient+Venue.h"
#import "FilterItem.h"
#import "TagGroup.h"

#import "FilterTagsCollectionViewCell.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "NSNumber+Yamo.h"

#define FilterItemDefaultSelectionPopular [[NSMutableArray alloc] initWithObjects:@NO, nil]
#define FilterItemDefaultSelectionTags [[NSMutableArray alloc] init]
#define FilterItemDefaultSelectionPrice [[NSMutableArray alloc] initWithObjects:@(0), nil]


@interface FilterDataController () <UITableViewDataSource, UITableViewDelegate, FilterTableViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *filterItems;
@property (nonatomic, strong) NSMutableDictionary *tagsRowHeights; // key: filterItem.filterName, value: NSNumber of CGFloat
@end

@implementation FilterDataController

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        
        self.tagsRowHeights = [[NSMutableDictionary alloc] init];
        
        [self initializeTableView:tableView];
    }
    return self;
}

- (void)initializeTableView:(UITableView *)tableView {
    
    self.tableView = tableView;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.dataSource = self;
    tableView.delegate = self;
        
    [tableView registerNib:[UINib nibWithNibName:@"FilterSwitchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FilterSwitchTableViewCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"FilterTagsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FilterTagsTableViewCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"FilterSliderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FilterSliderTableViewCellIdentifier];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)reloadData {
    
    [self reloadDataWithResetToDefault:NO];
}

- (void)reloadDataWithResetToDefault:(BOOL)resetToDefault {
    
    self.userChangedFilterItems = resetToDefault;
    
    NSArray *cachedFilterItems = [self loadCachedFilterItems];

    [[APIClient sharedInstance] venueListTagGroupsWithSuccessBlock:^(NSArray * _Nullable elements) {
        
        self.filterItems = [self filterItemsWithCachedFilterItems:cachedFilterItems
                                                 fetchedTagGroups:elements
                                                   resetToDefault:resetToDefault];
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        self.filterItems = [self filterItemsWithCachedFilterItems:cachedFilterItems
                                                 fetchedTagGroups:nil
                                                   resetToDefault:resetToDefault];
        
        [self.tableView reloadData];
    }];

}

- (NSArray *)filterItemsWithCachedFilterItems:(NSArray *)cachedFilterItems
                             fetchedTagGroups:(NSArray *)fetchedTagGroups
                               resetToDefault:(BOOL)resetToDefault {
 
    NSMutableArray *filterItems = [[NSMutableArray alloc] init];
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
//    // --------
//    // Popular
//    NSPredicate *popularPredicate = [NSPredicate predicateWithFormat:@"filterName == %@", NSLocalizedString(@"Popular", nil)];
//    FilterItem *cachedPopularItem = [[cachedFilterItems filteredArrayUsingPredicate:popularPredicate] firstObject];
//    if (cachedPopularItem && !resetToDefault) {
//        
//        [filterItems addObject:cachedPopularItem];
//    }
//    else {
//        
//        FilterItem *popularItem = [[FilterItem alloc] init];
//        popularItem.filterName = NSLocalizedString(@"Popular", nil);
//        popularItem.filterDescription = NSLocalizedString(@"Show only popular exhibitions", nil);
//        popularItem.type = FilterItemTypeSwitch;
//        popularItem.filterOptions = @[@YES, @NO];
//        popularItem.filterSelection = FilterItemDefaultSelectionPopular;
//        popularItem.multipleSelection = NO;
//        [filterItems addObject:popularItem];
//    }
    
    // --------
    // Tag Groups
    if (fetchedTagGroups) {
        
        for (TagGroup *tagGroup in fetchedTagGroups) {
            
            NSArray *sortedTags = [tagGroup.tags sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(priority)) ascending:NO]]];
            NSArray *sortedTagNames = [sortedTags valueForKey:NSStringFromSelector(@selector(name))];
            NSArray *sortedTagIds = [sortedTags valueForKey:NSStringFromSelector(@selector(uuid))];
            
            FilterItem *tagGroupItem = [[FilterItem alloc] init];
            tagGroupItem.filterName = NSLocalizedString(tagGroup.name, nil);
            tagGroupItem.type = FilterItemTypeTags;
            tagGroupItem.sourceId = tagGroup.uuid;
            tagGroupItem.filterOptions = sortedTagIds;
            tagGroupItem.filterOptionsDisplayNames = sortedTagNames;
            tagGroupItem.multipleSelection = YES;
            [filterItems addObject:tagGroupItem];
            
            // Fill in the selection from the cached filter items if have one
            NSPredicate *tagsPredicate = [NSPredicate predicateWithFormat:@"type == %@ && sourceId == %@", @(FilterItemTypeTags), tagGroup.uuid];
            FilterItem *cachedTagsFilterItem = [[cachedFilterItems filteredArrayUsingPredicate:tagsPredicate] firstObject];
            if (cachedTagsFilterItem && !resetToDefault) {
                
                NSMutableSet *cachedSelection = [[NSMutableSet alloc] initWithArray:cachedTagsFilterItem.filterSelection];
                [cachedSelection intersectSet:[NSSet setWithArray:sortedTagIds]];
                
                tagGroupItem.filterSelection = [[cachedSelection allObjects] mutableCopy];
            }
            else {
                
                tagGroupItem.filterSelection = FilterItemDefaultSelectionTags;
            }
            
            // Default row expended height
            self.tagsRowHeights[tagGroup.name] = @(FilterTagsTableViewCellExpandedHeight);
        }
    }
    else if (cachedFilterItems) {

        NSPredicate *tagsPredicate = [NSPredicate predicateWithFormat:@"type == %@", @(FilterItemTypeTags)];
        NSArray *cachedTagsFilterItems = [cachedFilterItems filteredArrayUsingPredicate:tagsPredicate];

        if (resetToDefault) {
            
            for (FilterItem *item in cachedTagsFilterItems) {
                item.filterSelection = FilterItemDefaultSelectionTags;
            }
        }
        
        if (cachedTagsFilterItems) {
            [filterItems addObjectsFromArray:cachedTagsFilterItems];
        }
    }

    // Note: Modification from Sep 2016 - Change requests from Yamo
//    // --------
//    // Price Range
//    NSPredicate *priceRangePredicate = [NSPredicate predicateWithFormat:@"filterName == %@", NSLocalizedString(@"Price Range", nil)];
//    FilterItem *cachedPriceRangeItem = [[cachedFilterItems filteredArrayUsingPredicate:priceRangePredicate] firstObject];
//    if (cachedPriceRangeItem && !resetToDefault) {
//        
//        [filterItems addObject:cachedPriceRangeItem];
//    }
//    else {
//        
//        FilterItem *priceRangeItem = [[FilterItem alloc] init];
//        priceRangeItem.filterName = NSLocalizedString(@"Price Range", nil);
//        priceRangeItem.filterDescription = @"";
//        priceRangeItem.type = FilterItemTypeSlider;
//        
//        // the options will be £0 ~ £20
//        NSMutableArray *priceRangeFilterOptions = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0; i < 3; i++) {
//            [priceRangeFilterOptions addObject:@(i)];
//        }
//        priceRangeItem.filterOptions = priceRangeFilterOptions;
//        priceRangeItem.filterSelection = FilterItemDefaultSelectionPrice;
//        priceRangeItem.multipleSelection = NO;
//        [filterItems addObject:priceRangeItem];
//    }
    
    return filterItems;
}

- (void)resetFilter {
    
    self.selectedIndexPath = nil;
    [self removeCachedFilterItems];
    [self reloadDataWithResetToDefault:YES];
}

- (FilterSearchDTO *)currentFilterSearchDTO {
    FilterSearchDTO *dto = [[FilterSearchDTO alloc] init];
    
    NSMutableArray *tagIds = [[NSMutableArray alloc] init];
    
    for (FilterItem *item in self.filterItems) {
     
        // Hard coded for popular and price
        switch (item.type) {
                // Note: Modification from Sep 2016 - Change requests from Yamo
//            case FilterItemTypeSwitch:
//    
//                dto.mostPopular = [item.filterSelection.firstObject boolValue];
//                
//                break;
            case FilterItemTypeTags:
                
                [tagIds addObjectsFromArray:item.filterSelection];
                
                break;
                // Note: Modification from Sep 2016 - Change requests from Yamo
//            case FilterItemTypeSlider:
//                
//                dto.priceFilter = [item.filterSelection.firstObject integerValue] + 1;
//                
//                break;
            default:
                break;
        }
    }
    
    dto.tagIds = tagIds;
    
    return dto;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterItem *filterItem = self.filterItems[indexPath.row];
    NSString *cellIdentifier;
    
    switch (filterItem.type) {
        case FilterItemTypeSwitch:
            cellIdentifier = FilterSwitchTableViewCellIdentifier;
            break;
        case FilterItemTypeTags:
            cellIdentifier = FilterTagsTableViewCellIdentifier;
            break;
        case FilterItemTypeSlider:
            cellIdentifier = FilterSliderTableViewCellIdentifier;
            break;
        default:
            cellIdentifier = @"Cell";
            break;
    }
    
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (filterItem.type == FilterItemTypeTags) {
        FilterTagsTableViewCell *filterTagsCell = (FilterTagsTableViewCell *)cell;
        [filterTagsCell setCollectionViewDataSourceDelegate:self forIndex:indexPath.row];
        CGFloat expectedHeight = [filterTagsCell heightForCell];
        self.tagsRowHeights[filterItem.filterName] = @(expectedHeight + FilterTagsTableViewCellDefaultHeight);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![cell isKindOfClass:[FilterTableViewCell class]]) {
        return;
    }
    
    
    FilterItem *filterItem = self.filterItems[indexPath.row];
    FilterTableViewCell *filterCell = (FilterTableViewCell *)cell;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    filterCell.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:filterItem.filterName attributes:attributes];
    filterCell.filterItem = filterItem;
    filterCell.isExpanded = [self.selectedIndexPath isEqual:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterItem *filterItem = self.filterItems[indexPath.row];
    
    switch (filterItem.type) {
        case FilterItemTypeSwitch:
            return [self.selectedIndexPath isEqual:indexPath] ? FilterSwitchTableViewCellExpandedHeight : FilterSwitchTableViewCellDefaultHeight;
        case FilterItemTypeTags:
            return [self.selectedIndexPath isEqual:indexPath] ? [self.tagsRowHeights[filterItem.filterName] floatValue] : FilterTagsTableViewCellDefaultHeight + 1; // 1 being the min height for the collection view so it can calculate it's internal content size
        case FilterItemTypeSlider:
            return [self.selectedIndexPath isEqual:indexPath] ? FilterSliderTableViewCellExpandedHeight : FilterSliderTableViewCellDefaultHeight;
        default:
            return 0.0;
    }
}

#pragma mark - Cell Button Delegate

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil) {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [self.tableView beginUpdates];
    
    BOOL selectingSelectedIndexPath = NO;
    
    if (self.selectedIndexPath) {
        
        selectingSelectedIndexPath = [self.selectedIndexPath isEqual:indexPath];
        
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        [self tableView:self.tableView didDeselectRowAtIndexPath:self.selectedIndexPath];
    }
    
    if (!selectingSelectedIndexPath) {
        
        self.selectedIndexPath = indexPath;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    if (self.selectedIndexPath) {
        
        self.selectedIndexPath = nil;

        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    [self.tableView endUpdates];
}

#pragma mark - FilterTableViewCellDelegate

- (void)filterTableViewCellDidTappedAccessoryButton:(FilterTableViewCell *)cell {
    
    [self.tableView beginUpdates];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    BOOL selectingSelectedIndexPath = NO;
    
    if (self.selectedIndexPath) {
        
        selectingSelectedIndexPath = [self.selectedIndexPath isEqual:indexPath];
        
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        [self tableView:self.tableView didDeselectRowAtIndexPath:self.selectedIndexPath];
    }
    
    if (!selectingSelectedIndexPath) {
        
        self.selectedIndexPath = indexPath;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
    [self.tableView endUpdates];
}

- (void)filterTableViewCellDidChangedSelection:(FilterTableViewCell *)cell {
    
    self.userChangedFilterItems = YES;
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    FilterItem *filterItem = self.filterItems[collectionView.tag];
    return filterItem.filterOptions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterTagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    FilterItem *filterItem = self.filterItems[collectionView.tag];
    
    NSString *tag = filterItem.filterOptionsDisplayNames[indexPath.item];
    NSNumber *tagId = filterItem.filterOptions[indexPath.item];
    
    UIColor *color = [filterItem.filterSelection containsObject:tagId] ? [UIColor yamoOrange] : [UIColor yamoDarkGray];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0],
                                  NSForegroundColorAttributeName: color };
    
    NSAttributedString *attributedTag = [[NSAttributedString alloc] initWithString:tag attributes:attributes];
    
    cell.label.attributedText = attributedTag;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterTagsCollectionViewCell *tempCell;
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"FilterTagsCollectionViewCell" owner:nil options:nil];
    for (UIView *nibView in nibViews) {
        if ([nibView isKindOfClass:[FilterTagsCollectionViewCell class]]) {
            tempCell = (FilterTagsCollectionViewCell *)nibView;
        }
    }
    
    tempCell.label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width -
    (((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.left +
     ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.right);
    
    FilterItem *filterItem = self.filterItems[collectionView.tag];
    NSString *tag = filterItem.filterOptionsDisplayNames[indexPath.item];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0] };
    NSAttributedString *attributedTag = [[NSAttributedString alloc] initWithString:tag attributes:attributes];
    tempCell.label.attributedText = attributedTag;
    
    CGSize size = [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    FilterItem *filterItem = self.filterItems[collectionView.tag];
    NSString *tag = filterItem.filterOptions[indexPath.item];
    NSMutableArray *selection = filterItem.filterSelection.mutableCopy;
    
    if (!selection) {
        selection = [[NSMutableArray alloc] init];
    }
    
    if ([selection containsObject:tag]) {
        [selection removeObject:tag];
    } else {
        [selection addObject:tag];
    }
    
    filterItem.filterSelection = selection;
    
    [UIView performWithoutAnimation:^{
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
    
    self.userChangedFilterItems = YES;
}

#pragma mark - Indicator Image

- (void)rotateView:(UIView *)viewToRotate OfDegrees:(CGFloat)degrees withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        viewToRotate.transform = CGAffineTransformMakeRotation((degrees * M_PI / 180.0));
        
    } completion:nil];
}

#pragma mark - Persisting

- (void)cacheFilterItems {
    
    NSString *path = [self pathForCacheFile];
    
    if (![NSKeyedArchiver archiveRootObject:self.filterItems toFile:path]) {
        NSLog(@"Cache file failed");
    }
}

- (void)removeCachedFilterItems {
    
    NSError *error = nil;
    NSString *path = [self pathForCacheFile];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"Remove cache failed");
    }
}

- (NSArray *)loadCachedFilterItems {
    NSString *path = [self pathForCacheFile];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

- (NSString *)pathForCacheFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSString *path = [applicationSupportDirectory stringByAppendingPathComponent:(NSString *)FilterItemsCacheFileName];
    return path;
}


@end
