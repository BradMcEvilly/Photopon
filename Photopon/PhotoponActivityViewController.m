//
//  PhotoponActivityViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 5/8/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponActivityViewController.h"
//#import "PhotoponSettingsActionSheetDelegate.h"
#import "PhotoponActivityCell.h"
#import "PhotoponAccountProfileViewController.h"
#import "PhotoponMediaDetailsViewController.h"
#import "PhotoponBaseTextCell.h"
#import "PhotoponLoadMoreCell.h"
#import "PhotoponSettingsButtonItem.h"
//#import "PhotoponFindFriendsViewController.h"
//#import "MBProgressHUD.h"
#import "PhotoponActivityModel.h"
#import "PhotoponConstants.h"

@interface PhotoponActivityViewController ()
//@property (nonatomic, strong) PhotoponSettingsActionSheetDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, strong) UIView *blankTimelineView;
@end

@implementation PhotoponActivityViewController

//@synthesize settingsActionSheetDelegate;
@synthesize lastRefresh;
@synthesize blankTimelineView;

#pragma mark - Initialization

- (void)dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponAppDelegateApplicationDidReceiveRemoteNotification object:nil];
}

- (id)initWithRootObject:(NSMutableDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithRootObject:_rootObject];
    if (self) {
        
        [self.methodParams setObject:[_rootObject objectForKey:kPhotoponModelIdentifierKey] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set defaults
        [self.methodParams setObject:kPhotoponAPIReturnedActivityModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:kPhotoponAPIMethodGetActivity forKey:kPhotoponMethodNameKey];
        
        //self.outstandingSectionFooterQueries = [NSMutableDictionary dictionary];
        
        // The className to query on
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // The number of objects to show per page
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionFooterViews = [NSMutableSet setWithCapacity:3];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style entityName:kPhotoponActivityClassName];
    if (self) {
        
        @synchronized(self) {
            //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
            NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
            if (!currentUserID || !currentUserID.length>0) {
                currentUserID = [[NSString alloc] initWithFormat:@"%@", (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]];
            }
            [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
            [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        }
        
        // set api method vars
        [self.methodParams setObject:kPhotoponActivityClassName forKey:kPhotoponEntityNameKey];
        
        [self.methodParams setObject:kPhotoponAPIReturnedActivityModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:kPhotoponAPIMethodGetActivity forKey:kPhotoponMethodNameKey];
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionFooterViews = [NSMutableSet setWithCapacity:3];
        
        
    }
    return self;
}
/*
- (id)initWithRootObject:(NSMutableDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithRootObject:_rootObject];
    if (self) {
        
        [self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set defaults
        [self.methodParams setObject:kPhotoponAPIReturnedActivityModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:kPhotoponAPIMethodGetActivity forKey:kPhotoponMethodNameKey];
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style];
    if (self) {
        
        // The className to query on
        [self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        
        // set api method vars
        [self.methodParams setObject:kPhotoponActivityClassName forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:kPhotoponAPIReturnedActivityModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:kPhotoponAPIMethodGetActivity forKey:kPhotoponMethodNameKey];
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        
        
        // The className to query on
        //self.parseClassName = kPhotoponActivityClassKey;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // The number of objects to show per page
        //self.objectsPerPage = 15;
        
        
        
        
        
    }
    return self;
}
*/

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        // Use the new iOS 6 refresh control.
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = refreshControl;
        //[self.refreshControl setBackgroundColor:[UIColor colorWithRed:198.0f/255.0f green:200.0f/255.0f blue:202.0f/255.0f alpha:0.3f]];
        [self.refreshControl setBackgroundColor:[UIColor clearColor]];
        self.refreshControl.tintColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
        [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.pullToRefreshEnabled = NO;
    }
    
    
    /*
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
    */
    
    
    self.tableView.backgroundColor = TABLE_VIEW_BACKGROUND_COLOR;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    
    // Add Settings button
    self.navigationItem.rightBarButtonItem = [[PhotoponSettingsButtonItem alloc] initWithTarget:self action:@selector(settingsButtonAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveRemoteNotification:) name:PhotoponAppDelegateApplicationDidReceiveRemoteNotification object:nil];
    
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ActivityFeedBlank.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(24.0f, 113.0f, 271.0f, 140.0f)];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];
    
    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserDefaultsActivityFeedViewControllerLastRefreshKey];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        // Use the new iOS 6 refresh control.
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = refreshControl;
        
        //[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLeather.png"]]
        [self.refreshControl setBackgroundColor:[UIColor clearColor]];
        
        self.refreshControl.tintColor = [UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
        [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.pullToRefreshEnabled = NO;
    }
    
    [self initTitleLabelWithText:@"News"];
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
    
}
/*
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.row < self.objects.count) {
        PhotoponActivityModel *object = [self.objects objectAtIndex:indexPath.row];
        NSString *activityString = [PhotoponActivityViewController stringForActivityType:(NSString*)[object objectForKey:kPhotoponActivityAttributesTypeKey]];
        
        PhotoponUserModel *user = (PhotoponUserModel*)[object objectForKey:kPhotoponActivityAttributesFromUserKey];
        NSString *nameString = NSLocalizedString(@"Someone", nil);
        if (user && [user objectForKey:kPhotoponUserAttributesFullNameKey] && [[user objectForKey:kPhotoponUserAttributesFullNameKey] length] > 0) {
            nameString = [user objectForKey:kPhotoponUserAttributesFullNameKey];
        }
        
        return [PhotoponActivityCell heightForCellWithName:nameString contentString:activityString];
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.objects.count) {
        PhotoponActivityModel *activity = [self.objects objectAtIndex:indexPath.row];
        if ([activity objectForKey:kPhotoponActivityAttributesPhotoKey]) {
            PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[activity objectForKey:kPhotoponActivityAttributesPhotoKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        } else if ([activity objectForKey:kPhotoponActivityAttributesFromUserKey]) {
            PhotoponAccountProfileViewController *detailViewController = [[PhotoponAccountProfileViewController alloc] initWithStyle:UITableViewStylePlain];
            [detailViewController setUser:[activity objectForKey:kPhotoponActivityAttributesFromUserKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    } else if (self.paginationEnabled) {
        // load more
        [self loadNextPage];
    }
}

#pragma mark - PhotoponQueryTableViewController

- (NSMutableArray *)paramsForTable{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Params:
    //  1). UserID      - so we know whos gallery to load
    //  2). MaxObjects  - so we don't receive more than
    /*NSArray *params =  [NSArray arrayWithObjects:
     self.identifier,
     (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
     nil];
     * /

    // temp fix until brian uploads updated php server file
    NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
                               self.identifier,
                               [[NSNumber alloc] initWithInt:
                                [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]  +
                                [[self.methodParams objectForKey:kPhotoponObjectsPerPageKey] integerValue]],
                               nil];
    
    return params;
    
}

- (void)objectsDidLoad:(NSError *)error {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super objectsDidLoad:error];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
    
    lastRefresh = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kPhotoponUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[MBProgressHUD hideHUDForView:self.view animated:NO];
    
    /*
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        self.navigationController.tabBarItem.badgeValue = nil;
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
        
        NSUInteger unreadCount = 0;
        for (PhotoponActivityModel *activity in self.objects) {
            if ([lastRefresh compare:[activity createdAt]] == NSOrderedAscending && ![[activity objectForKey:kPhotoponActivityTypeKey] isEqualToString:kPhotoponActivityTypeJoined]) {
                unreadCount++;
            }
        }
        
        if (unreadCount > 0) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
    }
     * /
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponActivityModel *)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *CellIdentifier = @"ActivityCell";
    
    PhotoponActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PhotoponActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    [cell setActivity:object];
    
    if ([lastRefresh compare:[object createdAt]] == NSOrderedAscending) {
        [cell setIsNew:YES];
    } else {
        [cell setIsNew:NO];
    }
    
    [cell hideSeparator:(indexPath.row == self.objects.count - 1)];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PhotoponLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PhotoponLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - PhotoponActivityCellDelegate Methods

- (void)cell:(PhotoponActivityCell *)cellView didTapActivityButton:(PhotoponActivityModel *)activity {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Get image associated with the activity
    PhotoponMediaModel *photo = [activity objectForKey:kPhotoponActivityAttributesPhotoKey];
    
    // Push single photo view controller
    PhotoponMediaDetailsViewController *photoViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:photo];
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)cell:(PhotoponBaseTextCell *)cellView didTapUserButton:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Push account view controller
    PhotoponAccountProfileViewController *accountViewController = [[PhotoponAccountProfileViewController alloc] initWithStyle:UITableViewStylePlain];
    //[accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}


#pragma mark - PhotoponActivityFeedViewController

+ (NSString *)stringForActivityType:(NSString *)activityType {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([activityType isEqualToString:kPhotoponActivityAttributesTypeLike]) {
        return NSLocalizedString(@"liked your photo", nil);
    } else if ([activityType isEqualToString:kPhotoponActivityAttributesTypeFollow]) {
        return NSLocalizedString(@"started following you", nil);
    } else if ([activityType isEqualToString:kPhotoponActivityAttributesTypeComment]) {
        return NSLocalizedString(@"commented on your photo", nil);
    } else if ([activityType isEqualToString:kPhotoponActivityAttributesTypeJoined]) {
        return NSLocalizedString(@"joined Anypic", nil);
    } else {
        return nil;
    }
}

*/












- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Post process results
    //dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (NSString*) cellIdentifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *cellReuseID = @"_PhotoponMediaFlatCellIdentifier";
    return cellReuseID;
}

- (NSString*) cellNibName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *cellNib = @"PhotoponMediaFlatCell";
    return cellNib;
}

/*
 - (void)configureCell:(PhotoponMediaFullCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 /*
 if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
 return;
 }* /
 
 // Post process results
 //dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
 //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 
 
 
 @try {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"-------->            object.value = %@", object.value);
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", object.value]];
 
 }
 @catch (NSException *exception) {
 [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", @"save $24"]];
 }
 @finally {
 // silence is golden
 }
 
 /*
 if (!object.coupon.details)
 [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", @"save $24"]];
 else
 [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", object.coupon.details]];
 * /
 
 //[cell.photoponMediaCaptionCell setContentText:cell.photoponMediaModel.caption]; //@"Which casual kicks are your #style"];
 
 if (object.caption)
 [cell.photoponMediaCaptionCell setUpWithText:object.caption];
 else
 [cell.photoponMediaCaptionCell setUpWithText:@""];
 
 //cell.photoponMediaCell.offerOverlay.text = object.coupon.details;
 
 
 
 //[cell.photoponMediaCaptionCell setUpWithText:@"Which casual kicks are @your #style"];
 
 if (object.linkURL) {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"---->       object.linkURL = %@", object.linkURL);
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 NSURL *linkURL = [[NSURL alloc] initWithString:object.linkURL];
 UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
 //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
 [cell.photoponMediaCell.imageView setImageWithURL:linkURL placeholderImage:placeHolderImg];
 //cell.photoponMediaCell.imageView = testImgView;
 }
 
 
 //[cell.photoponMediaCell.imageView setImageWithURL:linkURL];
 /*
 NSURLRequest *req = [[NSURLRequest alloc] initWithURL:linkURL];
 [cell.photoponMediaCell.imageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"PhotoponPlaceholderMediaPhoto.png"] success:^(NSURLRequest *request, NSHTTPURLResponse   *response, id JSON){
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"---->       [cell.photoponMediaCell.imageView setImageWithURLRequest:req SUCCESS SUCCESS");
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 / *
 AFJSONRequestOperation *operation = [AFJSONRequestOperation
 JSONRequestOperationWithRequest:request
 success:^(NSURLRequest *request, NSHTTPURLResponse   *response, id JSON) {
 //[self parseDictionary:JSON];
 //isLoading = NO;
 [self.tableView reloadData];
 
 } failure:^(NSURLRequest *request,   NSHTTPURLResponse *response, NSError *error, id JSON) {
 NSLog(@"Error: %@", error);
 //[self showNetworkError];
 //isLoading = NO;
 [self.tableView reloadData];
 }];
 
 //operation setAcceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
 * /
 //[queue addOperation:operation];
 
 }failure:^(NSURLRequest *request, NSHTTPURLResponse   *response, id JSON){
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"---->       }failure:^(NSURLRequest *request, NSHTTPURLResponse   *response, id JSON){ FAILURE FAILURE");
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 }];* /
 
 cell.photoponMediaCell.photoButton.tag = indexPath.row;
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 [cell setBackgroundColor:[UIColor clearColor]];
 
 [cell setAccessoryType:UITableViewCellAccessoryNone];
 
 
 //dispatch_async(q, ^{
 
 
 //[cell setNeedsLayout];
 
 //[cell fadeInView];
 
 //[cell setNeedsDisplay];
 
 //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 
 //[cell fadeInView];
 
 //});
 //});
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"cell.photoponMediaCaptionCell = %@", cell.photoponMediaCaptionCell.contentLabel.text);
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 //});
 
 }*/

- (UITableViewCell *)newCellWithObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    
    NSString *cellIdentifier = @"_PhotoponActivityCellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];//[PhotoponMediaFullCell photoponMediaFullCell:self];// alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_gradient_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
        //[cell setBackgroundView:imageView];
        //[cell setBackgroundColor:[UIColor clearColor]];
        
    }else{
        //[cell prepareForReuse];
    }
    
    //[cell.contentView setAlpha:0.0f];
    
    return cell;
    
    
}

- (NSMutableArray *)paramsForTable{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     if (self.rootObject) {
     if ([[self.rootObject objectForKey:kPhotoponEntityNameKey] isEqualToString:kPhotoponHashtagClassName]) {
     NSMutableArray *params =  [NSArray arrayWithObjects:
     self.identifier,
     (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
     nil];
     return params;
     }
     }
     */
    
    
    // Params:
    //  1). UserID      - so we know whos gallery to load
    //  2). MaxObjects  - so we don't receive more than
    NSMutableArray *params =  [NSArray arrayWithObjects:
                               self.identifier,
                               (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
                               nil];
    
    
    
    // temp fix until brian uploads updated php server file
    /*NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
     self.identifier,
     [[NSNumber alloc] initWithInt:
     [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]  +
     [[self.methodParams objectForKey:kPhotoponObjectsPerPageKey] integerValue]],
     nil];
     */
    return params;
}



#pragma mark - ()

- (void)settingsButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    settingsActionSheetDelegate = [[PhotoponSettingsActionSheetDelegate alloc] initWithNavigationController:self.navigationController];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:settingsActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"My Profile", nil), NSLocalizedString(@"Find Friends", nil), NSLocalizedString(@"Log Out", nil), nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
     */
}

- (void)inviteFriendsButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponFindFriendsViewController *detailViewController = [[PhotoponFindFriendsViewController alloc] init];
    //[self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)applicationDidReceiveRemoteNotification:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self loadObjects];
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self loadObjects];
}

@end