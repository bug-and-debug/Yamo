//
//  ScrollingChildTabViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 29/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ScrollingChildTabViewController.h"
#import "PlacesTableViewCell.h"
#import "ProfileTableViewCell.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSParagraphStyle+Yamo.h"
#import "Medium.h"
#import "VenueSummary.h"
#import "RouteSummary.h"
#import "UserSummary.h"
#import "NoContentView.h"
#import "APIClient+Venue.h"
#import "ScrollingChildTabItem.h"
#import "APIClient+User.h"
#import "UserService.h"
#import "OtherProfileViewController.h"
#import "UIViewController+Network.h"
#import "Tag.h"
#import "UIColor+Tools.m"
#import "NSNumber+Yamo.h"
@import UIView_LOCExtensions;
@import LOCSearchBar;
@import UIColor_LOCExtensions;

@interface ScrollingChildTabViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ProfileTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NoContentView *noContentView;

@property (nonatomic, strong) NSMutableArray *arrayOfObjects;
@property (weak, nonatomic) IBOutlet LOCSearchTextField *searchTextField;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;

@property (nonatomic) BOOL searchMode;
@property (nonatomic) NoContentViewType noContentViewType;

typedef void(^fetchComplete)(BOOL);


@end

@implementation ScrollingChildTabViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(ScrollingChildTabViewType)type {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.type = type;
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.type == ScrollingChildTabViewTypePlaces || self.type ==  ScrollingChildTabViewTypeFriendsFollowers || self.type ==  ScrollingChildTabViewTypeFriendsFollowing ||  self.type ==  ScrollingChildTabViewTypeRoutes) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileTableViewCell"];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"PlacesTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    
    [self.view setClipsToBounds:YES];
    [self setSearchBar];
    [self setSectionIndexUI];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 55.0;
    
    [self setupNoContentView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)reloadWithDataSource:(NSMutableArray *)dataSource {
    
    self.arrayOfObjects = [[NSMutableArray alloc] init];
    self.arrayOfObjects = dataSource;
    
    [self setDataSourceForTableView];
    [self.tableView reloadData];
}

- (void)setupNoContentView {
    
    self.noContentViewType = NoContentViewTypeNotSpecified;
    switch (self.type) {
        case ScrollingChildTabViewTypeFriendsFollowers: {
            self.noContentViewType = NoContentViewTypeOtherProfileNoContentForFriendsFollowers;
            break;
        }
        case ScrollingChildTabViewTypeFriendsFollowing: {
            self.noContentViewType = NoContentViewTypeOtherProfileNoContentForFriendsFollowing;
            break;
        }
        case ScrollingChildTabViewTypePlaces: {
            self.noContentViewType = NoContentViewTypeOtherProfileNoContentForGetToKnowMe;
            break;
        }
        case ScrollingChildTabViewTypeRoutes: {
            self.noContentViewType = NoContentViewTypeOtherProfileNoContentForRoutes;
            break;
        }
        case ScrollingChildTabViewTypeVenues: {
            self.noContentViewType = NoContentViewTypeOtherProfileNoContentForVenues;
            break;
        }
        default:
            break;
    }
    
    self.noContentView = [[NoContentView alloc] initWithWithNoContentType:self.noContentViewType];
    self.noContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.noContentView];
    
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeTop toView:self.searchTextField];
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeLeading toView:self.tableView];
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeTrailing toView:self.tableView];
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeBottom toView:self.tableView];
}

- (void)updateNoContentViewVisibility {
    
    NSUInteger totalNumberOfRows = 0;
    totalNumberOfRows += self.dataSource.count;
    self.noContentView.hidden = totalNumberOfRows > 0;
}

#pragma mark - SetDataSource for TableView

- (void) setDataSourceForTableView{
    
    self.dataSource = [self setItemsFromMutableDictionary:[self dictionaryWithIndexForElementsInArray:self.arrayOfObjects]];
    [self setSectionTitlesForDatasource];

}

- (NSMutableArray *) checkKeysAndReorderInArray:(NSMutableArray *) array {

    for (int index = 0 ; index < array.count ; index++) {
        
        if ([[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:index]title] isEqualToString:@"Most popular"] || [[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:index]title] isEqualToString:@"Popular routes"]) {
            id object = nil;
            object = [array objectAtIndex:index];
            [array removeObjectAtIndex:index];
            [array insertObject:object atIndex:0];
        }
        
        if ([[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:index]title] isEqualToString:@"#"]) {
            id object = nil;
            object = [array objectAtIndex:index];
            [array removeObjectAtIndex:index];
            [array insertObject:object atIndex:array.count];
        }

    }
    return array;
    
}

#pragma mark - setDictionary of Object

- (void)setSectionTitlesForDatasource {
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [self.dataSource sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.dataSource = [self checkKeysAndReorderInArray:self.dataSource];
}


- (NSMutableArray *)setItemsFromMutableDictionary:(NSMutableDictionary *)mutableDictionary{
    
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
    
    for (id key in mutableDictionary){
        
        ScrollingChildTabItem *item = [[ScrollingChildTabItem alloc] init];
        
        item.title = key;
        item.data = [[mutableDictionary objectForKey:key] mutableCopy];
        
        [tempMutableArray addObject:item];
    }
    
    NSLog(@"%@", [tempMutableArray description]);
    return tempMutableArray;
}

- (NSMutableDictionary *)dictionaryWithIndexForElementsInArray:(NSMutableArray *)elements
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSCharacterSet *charSet = [NSCharacterSet letterCharacterSet];
    
    for (id object in elements) {
        
        if ([object isKindOfClass:[VenueSummary class]]) {
            
            VenueSummary *venue = object;
            
            if (venue.popularVenue) {
                NSString *key = @"Most popular";
                NSMutableArray *value = result[key];
                if (value == nil) {
                    result[key] = [NSMutableArray arrayWithObject:object];
                } else {
                    result[key] = [value arrayByAddingObject:object];
                }
            }
            else
            {
                NSString *key = [charSet characterIsMember:[venue.name characterAtIndex:0]]  ? [[venue.name substringToIndex:1] uppercaseString] : @"#";
                NSMutableArray *value = result[key];
                if (value == nil) {
                    result[key] = [NSMutableArray arrayWithObject:object];
                } else {
                    result[key] = [value arrayByAddingObject:object];
                }
            }
        }
        else if ([object isKindOfClass:[RouteSummary class]]) {
            RouteSummary *route = object;
            if (route.popularRoute) {
                NSString *key = @"Popular routes";
                NSMutableArray *value = result[key];
                if (value == nil) {
                    result[key] = [NSMutableArray arrayWithObject:object];
                } else {
                    result[key] = [value arrayByAddingObject:object];
                }
            }
            else
            {
                NSString *key = [charSet characterIsMember:[route.name characterAtIndex:0]] ? [[route.name substringToIndex:1] uppercaseString] : @"#";
                NSMutableArray *value = result[key];
                if (value == nil) {
                    result[key] = [NSMutableArray arrayWithObject:object];
                } else {
                    result[key] = [value arrayByAddingObject:object];
                }
            }
        }
        else if ([object isKindOfClass:[Medium class]]){
            Medium *medium = object;
            NSString *key = [charSet characterIsMember:[medium.title characterAtIndex:0]] ? [[medium.title substringToIndex:1] uppercaseString] : @"#";
            NSMutableArray *value = result[key];
            if (value == nil) {
                result[key] = [NSMutableArray arrayWithObject:object];
            } else {
                result[key] = [value arrayByAddingObject:object];
            }
        }
        else if ([object isKindOfClass:[UserSummary class]]) {
            UserSummary *friend = object;
                NSString *key = [charSet characterIsMember:[friend.username characterAtIndex:0]] ? [[friend.username substringToIndex:1] uppercaseString] : @"#";
                NSMutableArray *value = result[key];
                if (value == nil) {
                    result[key] = [NSMutableArray arrayWithObject:object];
                } else {
                    result[key] = [value arrayByAddingObject:object];
                }
        }
    }
    
    return result ;
}

//- (NSString *)coventInIndexFromString:(NSString *)string {
//
//
//
//}

#pragma mark - set UI

- (void) setSectionIndexUI {
    
    if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        self.tableView.sectionIndexColor = [UIColor yamoDarkGray];
        self.tableView.sectionIndexTrackingBackgroundColor = [UIColor whiteColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    }
}

- (void)setSearchBar {
    
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                            NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0],
                                            NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0]};
    
    [self setShadowForView:self.searchTextField];
    self.searchTextField.textColor = [UIColor darkGrayColor];
    self.searchTextField.font = self.searchTextField.placeholderFont = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0];
    self.searchTextField.accessoryImage = [UIImage imageNamed:@"LegacyIconlightlistsearch"];
    self.searchTextField.accessoryImagePosition = LOCSearchBarAccessoryImagePositionLeft;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search", nil) attributes:placeholderAttributes];
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.searchTextField.delegate = self;
}

- (void) setShadowForView:(UIView *)view {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, view.frame.size.width, 3.0f)];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.4f;
    view.layer.shadowRadius = 3.0;
    view.layer.shadowPath = shadowPath.CGPath;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    [self updateNoContentViewVisibility];
    return self.searchMode ? 1 : [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchMode) {
        return self.filteredDataSource.count;
    }
    else {
        
        NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:section]data];
        return [sectionDataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSParagraphStyle *style = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForHeader];
    
    if (self.type == ScrollingChildTabViewTypePlaces ||
        self.type ==  ScrollingChildTabViewTypeFriendsFollowers ||
        self.type ==  ScrollingChildTabViewTypeFriendsFollowing ||
        self.type ==  ScrollingChildTabViewTypeRoutes) {
        
        ProfileTableViewCell *cell = (ProfileTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell" forIndexPath:indexPath];
    
        if (self.searchMode) {
            
            NSString *textLabel;
            
            if ([self.filteredDataSource [indexPath.row] isKindOfClass:[RouteSummary class]] ) {
                textLabel = [self.filteredDataSource [indexPath.row] name];
            }
            else if ([self.filteredDataSource [indexPath.row] isKindOfClass:[Medium class]] )
            {
                textLabel = [self.filteredDataSource [indexPath.row] title];
                
            }
            else if ([self.filteredDataSource [indexPath.row] isKindOfClass:[UserSummary class]] )
            {
                textLabel = [self.filteredDataSource [indexPath.row] username];

                if (![[[[UserService sharedInstance] loggedInUser] uuid ] isEqual:[self.filteredDataSource [indexPath.row] uuid]]) {
                    cell.cellStyle = ProfileCellStyleAccessoryButton;
                    cell.addFriendButton.selected = self.filteredDataSource [indexPath.row] ? YES : NO;
                    cell.profileCellDelegate=self;
                }
            }
            
            if (textLabel.length) {
                NSMutableAttributedString *titleAttributedText = [[NSMutableAttributedString alloc] initWithString:textLabel];
                [titleAttributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSFontAttributeName value:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f] range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSKernAttributeName value:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f] range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor yamoDarkGray] range:NSMakeRange(0, [titleAttributedText length])];
                cell.titleLabel.attributedText = titleAttributedText;
            }
            
            return cell;
        }
        else {
            
            NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data];
            NSString *textLabel;
            
            if ([[sectionDataSource objectAtIndex:indexPath.row] isKindOfClass:[RouteSummary class]]) {
                
                textLabel = [[sectionDataSource objectAtIndex:indexPath.row] name];
            }
            else if ([[sectionDataSource objectAtIndex:indexPath.row] isKindOfClass:[Medium class]]) {
                
                textLabel = [[sectionDataSource objectAtIndex:indexPath.row] title];
            }
            else if ([[sectionDataSource objectAtIndex:indexPath.row] isKindOfClass:[UserSummary class]]) {
                
                UserSummary *object = [sectionDataSource objectAtIndex:indexPath.row];
                
                textLabel = object.username;
                
                NSNumber *loggedInUserUUID = [[[UserService sharedInstance] loggedInUser] uuid];
                
                if (![object.uuid isEqualToNumber:loggedInUserUUID]) {
                    cell.cellStyle = ProfileCellStyleAccessoryButton;
                    cell.profileCellDelegate = self;
                    
                    cell.addFriendButton.selected = object.following;
                }
            }

            if (textLabel.length) {
                NSMutableAttributedString *titleAttributedText = [[NSMutableAttributedString alloc] initWithString:textLabel];
                [titleAttributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSFontAttributeName value:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f] range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSKernAttributeName value:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f] range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor yamoDarkGray] range:NSMakeRange(0, [titleAttributedText length])];
                cell.titleLabel.attributedText = titleAttributedText;
            }
            return cell;
        }
    }
    else {
        
        PlacesTableViewCell *cell = (PlacesTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        if (self.searchMode) {
            
            NSString *textLabel;
            NSArray *tags;

            
            if ([self.filteredDataSource [indexPath.row] isKindOfClass:[VenueSummary class]]) {
                textLabel = [self.filteredDataSource [indexPath.row] name];
                tags = [self orderArrayOfTagsWithArray:[(VenueSummary *) self.filteredDataSource[indexPath.row] displayTags]] ;

            }
            if (textLabel.length) {
                NSMutableAttributedString *titleAttributedText = [[NSMutableAttributedString alloc] initWithString:textLabel];
                [titleAttributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSFontAttributeName value:[UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:19.0f] range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor yamoBlack] range:NSMakeRange(0, [titleAttributedText length])];
                [titleAttributedText addAttribute:NSKernAttributeName value:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:19.9] range:NSMakeRange(0, [titleAttributedText length])];
                cell.titleLabel.attributedText = titleAttributedText;
            }
            
            if (tags) {
                cell.tagsLabel.attributedText = [self generateAttributedStringForTags:tags];
            }
            
            return cell;
            
        }
        else {
            
            NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data];
            NSString *textLabel;
            NSArray *tags;
            
            
            if ([[sectionDataSource objectAtIndex:indexPath.row] isKindOfClass:[VenueSummary class]]) {
                textLabel = [[sectionDataSource objectAtIndex:indexPath.row] name];
                tags = [self orderArrayOfTagsWithArray:[(VenueSummary *)[sectionDataSource objectAtIndex:indexPath.row] displayTags]];
            }
            
            NSMutableAttributedString *titleAttributedText = [[NSMutableAttributedString alloc] initWithString:textLabel];
            [titleAttributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [titleAttributedText length])];
            [titleAttributedText addAttribute:NSFontAttributeName value:[UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:19.0f] range:NSMakeRange(0, [titleAttributedText length])];
            [titleAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor yamoBlack] range:NSMakeRange(0, [titleAttributedText length])];
            [titleAttributedText addAttribute:NSKernAttributeName value:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:19.9] range:NSMakeRange(0, [titleAttributedText length])];
            cell.titleLabel.attributedText = titleAttributedText;

            if (tags) {
                cell.tagsLabel.attributedText = [self generateAttributedStringForTags:tags];
            }
            
            
            return cell;
        }
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.searchMode ? @"" :  [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:section]title];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, tableView.frame.size.width, 18)];
    
    NSString *string;
    if (self.searchMode) {
        string = self.filteredDataSource.count > 0 ? [NSString stringWithFormat:@"%lu matches", (unsigned long)self.filteredDataSource.count] : @"No matches";
    }
    
    else {
        string =  [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:section]title];
    }
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                  NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    label.attributedText = attributedString;
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor yamoDarkGray]];
    return view;
}

- (NSMutableArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    // ★
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataSource];
    NSMutableArray *arrayOfKeys = [[NSMutableArray alloc] init];

    
    for (int i = 0; i<array.count; i++) {
        
        NSString *key =  [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:i]title];
        
        if ([key isEqualToString:@"Most popular"] || [key isEqualToString:@"Popular routes"])
            key = @"★";
        
        [arrayOfKeys addObject:key];
    }
    return self.searchMode ? [NSMutableArray array] : arrayOfKeys;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (self.searchMode) {
//        
//        if ([self.filteredDataSource [indexPath.row] isKindOfClass:[UserSummary class]] ) {
//            
//            UserSummary *user = self.filteredDataSource [indexPath.row];
//            OtherProfileViewController *otherVC = [[OtherProfileViewController alloc] initWithNibName:@"OtherProfileViewController" bundle:nil];
//            otherVC.uuid = user.uuid;
//            otherVC.username = user.username;
//            [self.navigationController pushViewController:otherVC animated:YES];
//        }
//        
//    } else {
//    
//        NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data];
//        
//        if ([[sectionDataSource objectAtIndex:indexPath.row] isKindOfClass:[UserSummary class]] ){
//            
//            UserSummary *user = [sectionDataSource objectAtIndex:indexPath.row];
//            NSLog(@"follow?%@",[user description]);
//            OtherProfileViewController *otherVC = [[OtherProfileViewController alloc] initWithNibName:@"OtherProfileViewController" bundle:nil];
//            otherVC.uuid = user.uuid;
//            otherVC.username = user.username;
//            [self.navigationController pushViewController:otherVC animated:YES];
//        }
//        
//    
//    }
    
    
    if (!self.searchMode) {
        
        NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data];
        
        switch (self.type) {
            case ScrollingChildTabViewTypeFriendsFollowers: {
                
                UserSummary *userSummary = sectionDataSource[indexPath.row];
                
                if ([self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectUser:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectUser:userSummary];
                }
                break;
            }
            case ScrollingChildTabViewTypeFriendsFollowing: {
                
                UserSummary *userSummary = sectionDataSource[indexPath.row];
                
                if ([self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectUser:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectUser:userSummary];
                }
                break;
            }

            case ScrollingChildTabViewTypeRoutes: {
                self.noContentViewType = NoContentViewTypeOtherProfileNoContentForRoutes;
                
                RouteSummary *routeSummary = sectionDataSource[indexPath.row];
                if ([routeSummary isKindOfClass:RouteSummary.class] && [self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectRoute:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectRoute:routeSummary];
                }
                break;
            }
            case ScrollingChildTabViewTypeVenues: {
                self.noContentViewType = NoContentViewTypeOtherProfileNoContentForVenues;
                
                VenueSummary *venueSummary = sectionDataSource[indexPath.row];
                if ([venueSummary isKindOfClass:VenueSummary.class] && [self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectVenue:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectVenue:venueSummary];
                }
                break;
            }
            default:
                break;
        }
    }
    else {
        
        switch (self.type) {
            case ScrollingChildTabViewTypeFriendsFollowing: {
                
                UserSummary *userSummary = self.filteredDataSource [indexPath.row];
                                            
                if ([self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectUser:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectUser:userSummary];
                }
                break;
            }
            case ScrollingChildTabViewTypeFriendsFollowers: {
                
                UserSummary *userSummary = self.filteredDataSource [indexPath.row];
                
                if ([self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectUser:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectUser:userSummary];
                }
                break;
            }

            case ScrollingChildTabViewTypeRoutes: {
                self.noContentViewType = NoContentViewTypeOtherProfileNoContentForRoutes;
                
                RouteSummary *routeSummary = self.filteredDataSource [indexPath.row];
                if ([routeSummary isKindOfClass:RouteSummary.class] && [self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectRoute:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectRoute:routeSummary];
                }
                break;
            }
            case ScrollingChildTabViewTypeVenues: {
                self.noContentViewType = NoContentViewTypeOtherProfileNoContentForVenues;
                
                VenueSummary *venueSummary = self.filteredDataSource [indexPath.row];
                if ([venueSummary isKindOfClass:VenueSummary.class] && [self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didSelectVenue:)]) {
                    [self.delegate scrollingChildTabViewController:self didSelectVenue:venueSummary];
                }
                break;
            }
            default:
                break;
        }

    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == ScrollingChildTabViewTypeRoutes) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.searchMode) {
            // Delete object
            [self deletePlaceWithId:[self.filteredDataSource [indexPath.row] uuid] inTableView:tableView atIndexPath:indexPath];
        }
        else {
            
            NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data];
            [self deletePlaceWithId:[[sectionDataSource objectAtIndex:indexPath.row] uuid] inTableView:tableView atIndexPath:indexPath];
            
        }
    }
}

#pragma mark - Helper

- (NSArray *) orderArrayOfTagsWithArray:(NSArray *) array{
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] initWithArray:array];
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO];
    NSSortDescriptor *alphabeticalOrder = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray * finishedSort = [NSArray arrayWithObjects:highestToLowest, alphabeticalOrder, nil];
    [tempMutableArray sortUsingDescriptors:finishedSort];
    return [tempMutableArray copy];
}

- (NSAttributedString *)generateAttributedStringForTags:(NSArray<Tag *> *) tags {
    
    NSInteger tagsToDisplayLimit = 5;
    // Setup tags label
    NSMutableAttributedString *combinedCategoryAttributedString = [[NSMutableAttributedString alloc] init];
    
    if (tags.count > 0) {
        
        for (Tag *tag in tags) {
            [combinedCategoryAttributedString appendAttributedString:[self generateAttributedStringForTag:tag]];
            
            if ([tags indexOfObject:tag] == tagsToDisplayLimit - 1) {
                break;
            }
            [combinedCategoryAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [combinedCategoryAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, combinedCategoryAttributedString.length)];
    
    return combinedCategoryAttributedString;
}

- (NSAttributedString *) generateAttributedStringForTag:(Tag *)tag {
    
    NSLog(@"%@", tag.description);
    
    UIColor *color = [UIColor yamoLightGray];
    
    if (tag.hexColour.length) {
    
        color = [[UIColor alloc] initWithHexString:tag.hexColour];
    }
    
    NSLog(@"%@", color);
    NSString *string = tag.name;
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color,
                             NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f],
                             NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f]};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    
    return attrStr;
}

#pragma mark - Delete object for the server

- (void) deletePlaceWithId:(NSNumber *)uuid inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    [[APIClient sharedInstance] venueDeleteRouteWithRouteId:uuid successBlock:^(id _Nullable element) {
        
        NSLog(@"Response %@", element);
        
        [self deleteRouteWithId:uuid atIndexPath:indexPath];
        [self deleteObjectFromTheDatasourceWithId:uuid atIndexPath:indexPath];
        [self.delegate reloadAllData];
        
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
    }];
}

#pragma mark - deleteObjectInDataSource

- (void) deleteRouteWithId:(NSNumber *) uuid atIndexPath:(NSIndexPath *)indexPath {
    
//    NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data];
    
    for (RouteSummary *routeSummary in [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data]) {
        
        if (routeSummary.uuid == uuid) {
            [[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data] removeObjectAtIndex:indexPath.row];
            break;
        }
        
    }
    
    for (RouteSummary *routeSummary in self.filteredDataSource) {
        
        if (routeSummary.uuid == uuid) {
            [self.filteredDataSource removeObjectAtIndex:indexPath.row];
            break;
        }
        
    }
}

- (void) deleteObjectFromTheDatasourceWithId:(NSNumber *)uuid atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchMode) {
        
        NSMutableArray *toDelete = [NSMutableArray array];
        
        for (ScrollingChildTabItem *item in self.dataSource) {
            
            for (id rowObject in item.data) {
                
                if ([rowObject isKindOfClass:[RouteSummary class]]) {
                    
                    RouteSummary *routeSummary = (RouteSummary *)rowObject;
                
                    if ([uuid isEqualToNumber:routeSummary.uuid]) {
                        
                        [item.data removeObject:routeSummary];
                        
                        if (item.data.count == 0) {
                            
                            [toDelete addObject:item];
                        }
                        
                        break;
                    }
                }
                else {
                    
                    NSLog(@"ScrollingChildTabViewController was passed an object to delete that isn't a RouteSummary");
                }
                
            }
            
        }

        if (toDelete.count > 0) {
            [self.dataSource removeObjectsInArray:toDelete];
        }
        
        if(self.filteredDataSource.count == 0)
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        
    } else {
        if ([(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section] isEmpty]){
            [self.dataSource removeObjectAtIndex:indexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *output = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.filteredDataSource = [[NSMutableArray alloc] init];
    NSPredicate *resultPredicate;
    
    if (self.dataSource.count > 0) {
    
        if ([[[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:0] data] objectAtIndex:0] isKindOfClass:[VenueSummary class]] || [[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:0] data].firstObject isKindOfClass:[RouteSummary class]])
        {
            resultPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", output];
        }
        else if ([[[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:0] data] objectAtIndex:0] isKindOfClass:[Medium class]] )
        {
            resultPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", output];
        }
        else if ([[[(ScrollingChildTabItem *)[self.dataSource objectAtIndex:0] data] objectAtIndex:0] isKindOfClass:[UserSummary class]] )
        {
            resultPredicate = [NSPredicate predicateWithFormat:@"username CONTAINS[cd] %@", output];
        }
        else
        {
            resultPredicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", output];
        }
        
        //filteredArrayUsingPredicate:resultPredicate
        
        for (ScrollingChildTabItem *scrollItem in self.dataSource)
            [self.filteredDataSource addObjectsFromArray:[scrollItem.data filteredArrayUsingPredicate:resultPredicate]];
        
        self.searchMode = [output length] != 0;
        [self reloadData];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.searchMode = [textField.text length] != 0;
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self clearTextField];
    return NO;
}

- (void) clearTextField {
    self.searchMode = NO;
    self.searchTextField.text = @"";
    [self.tableView reloadData];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)textFieldDidChange:(UITextField *)sender {
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:sender.text attributes:attributes];
    
    sender.attributedText = attributedString;
}

#pragma mark - Profile Cell delegates


-(void) didPressButtonFollow:(ProfileTableViewCell *)cell{
    
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];;
    UserSummary *user;
    
    if (self.searchMode) {
        user = self.filteredDataSource [indexPath.row];
    } else {
        NSMutableArray *sectionDataSource = [(ScrollingChildTabItem *)[self.dataSource objectAtIndex:indexPath.section]data];
        user = [sectionDataSource objectAtIndex:indexPath.row];
    }
   
    if ([user isKindOfClass:[UserSummary class]]) {
        
        if (!user.following) {
            [self followUserWithID:user indexPath:indexPath];
        }
        else {
            [self unfollowUserWithID:user indexPath:indexPath];
        }
    }
    
}

#pragma mark - API requests

- (void) followUserWithID:(UserSummary *)user indexPath:(NSIndexPath *) indexPath {
    
    [self showIndicator:YES];
    
    [[APIClient sharedInstance] followUserWithUserID:user.uuid andSuccessBlock:^(id  _Nullable element) {
        
        [self showIndicator:NO];
        
        user.following = YES;
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didFollowedUser:)]) {
            [self.delegate scrollingChildTabViewController:self didFollowedUser:user];
        }
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        [self showIndicator:NO];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void) unfollowUserWithID:(UserSummary *)user indexPath:(NSIndexPath *) indexPath {
    
    [self showIndicator:YES];
    
    [[APIClient sharedInstance] unfollowUserWithUserID:user.uuid andSuccessBlock:^(id  _Nullable element) {
        
        [self showIndicator:NO];
        
        user.following = NO;
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.delegate respondsToSelector:@selector(scrollingChildTabViewController:didUnfollowedUser:)]) {
            [self.delegate scrollingChildTabViewController:self didUnfollowedUser:user];
        }
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        [self showIndicator:NO];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

@end
