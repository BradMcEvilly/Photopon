//
//  PhotoponExploreViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 5/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponExploreViewController.h"
#import "PhotoponCollectionViewCell.h"
#import "PhotoponFeaturedUsersViewController.h"
#import "PhotoponHashTagTableViewController.h"
#import "PhotoponSectionHeaderView.h"
#import "PhotoponModel.h"
#import "PhotoponUserModel.h"
#import "PhotoponMediaModel.h"
#import "PhotoponSearchTableViewCell.h"

static NSString *mFullCellIdentifier = @"_PhotoponMediaFullCellIdentifier";
static NSString *featuredUsersContainerCellIdentifier = @"_FeaturedUsersContainerCellIdentifier";


@interface PhotoponExploreViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) PhotoponFeaturedUsersViewController *photoponFeaturedUsersViewController;
@end

@implementation PhotoponExploreViewController


- (id)initWithRootObject:(NSMutableDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithRootObject:_rootObject];
    if (self) {
        
        /*
         NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
         
         if (currentUserID && currentUserID.length>0) {
         [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
         }*/
        
        
        
        [self.methodParams setObject:kPhotoponHashtagClassName forKey:kPhotoponEntityNameKey];
        
        [self.methodParams setObject:[_rootObject objectForKey:kPhotoponModelIdentifierKey] forKey:kPhotoponModelIdentifierKey];
        
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedHashTagModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIMethodGetTrendingHashTags] forKey:kPhotoponMethodNameKey];
        
        
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
        
        
        self.shouldReloadOnAppear = NO;
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style entityName:kPhotoponHashtagClassName];
    if (self) {
        
        @synchronized(self) {
            /*
            //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
            NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
            if (!currentUserID || !currentUserID.length>0) {
                currentUserID = [[NSString alloc] initWithFormat:@"%@", (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]];
            }*/
            
            //[self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
            
            
        }
        
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        // set api method vars
        [self.methodParams setObject:kPhotoponHashtagClassName forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedHashTagModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        
        
        
        
        // temporary fix
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIMethodGetTrendingHashTags] forKey:kPhotoponMethodNameKey];
        
        
        
        
        
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
        
        self.shouldReloadOnAppear = NO;
        
    }
    return self;
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/


/*
-(id) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        // Custom initialization
        
        @synchronized(self) {
            
            // The className to query on
            [self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
            [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        }
        
        // set api method vars
        [self.methodParams setObject:kPhotoponMediaClassKey forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"media_models"] forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"bp.getMyGallery"] forKey:kPhotoponMethodNameKey];
        
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
        
    }
    return self;
    
}
*/

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponSectionHeaderView *photoponSectionHeaderView = [PhotoponSectionHeaderView photoponSectionHeaderViewWithSectionTitle:[self titleForHeaderInSection:section]];
    
    return photoponSectionHeaderView;
    
    
    
}

- (NSString*)titleForHeaderInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (section) {
        case 0:
            return @"Featured Users";
            break;
        case 1:
            return @"Photopons";
            break;
            
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 22.0f;
    
}

/*
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (section) {
        case 0:{
            CGFloat incrementVal = 16.0f;
            CGFloat product = incrementVal * 42.0f;
            CGRect tableViewFrame = CGRectMake(0.0f, 0.0f, 76.0f, product);
            //self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
            
            self.tableView.frame = tableViewFrame;
            self.tableView.bounds = CGRectMake(0.0f, 0.0f, 76.0f, 280.0f);
            
            //photoponTableFooterViewController_ = [[[PhotoponTableFooterViewController alloc] initWithNibName:@"PhotoponTableFooterViewController" bundle:nil] retain];
            
            //[tableView setTableFooterView:photoponTableFooterViewController_.view];
            
            CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
            self.tableView.transform = rotateTable;
            self.tableView.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height);
            
            //tableViewCell.contentArray = [arrays objectAtIndex:indexPath.section];
            //tableViewCell.horizontalTableView.allowsSelection = YES;
            self.tableView.allowsSelection = YES;
            [self.tableView setBackgroundColor:[UIColor clearColor]];
            [self.view setBackgroundColor:[UIColor clearColor]];
        }
        break;
        
 
        default:
            break;
    }
    
    
    
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGFloat f = 100.0f;
    CGFloat defaultHeight = 44.0f;
    
    switch (indexPath.section) {
        case 0:
        {
            return f;
        }
            break;
        case 1:
        {
            //[self.activityImageButton setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
            //return [UIScreen mainScreen].bounds.size.height - 140.0f;
            return defaultHeight;
        }
            break;
            
        default:
            break;
    }
    
    return defaultHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 2;
}

- (UITableView*)tableViewForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(indexPath.section == 0){
        
        PhotoponFeaturedUsersViewController *photoponFeaturedUsersViewController = [[PhotoponFeaturedUsersViewController alloc] initWithStyle:UITableViewStylePlain];
        
        return photoponFeaturedUsersViewController.tableView;
    }
    
    
    /*
    if(indexPath.section == 1){
        
        PhotoponHashTagTableViewController *photoponHashTagTableViewController = [[PhotoponHashTagTableViewController alloc] initWithStyle:UITableViewStylePlain];
        return photoponHashTagTableViewController.tableView;
    }
    */
    
    return nil;
}

/*
- (id)initWithRootObject:(NSMutableDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithRootObject:_rootObject];
    if (self) {
        
        self.hasSearchBarBool = YES;
        
        [self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set defaults
        // set api method vars
        [self.methodParams setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
        
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedUserModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        // bp.getFollowers by default
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIMethodGetFollowers] forKey:kPhotoponMethodNameKey];
        //[self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"bp.getFollowing"] forKey:kPhotoponMethodNameKey];
        
        
        
        
        //self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
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
        //self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        
        self.shouldReloadOnAppear = NO;
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style entityName:kPhotoponUserClassName];
    if (self) {
        
        self.hasSearchBarBool = YES;
        
        // The className to query on
        [self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set api method vars
        [self.methodParams setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"coupon_models"] forKey:kPhotoponMethodReturnedModelsKey];
        // bp.getFollowers by default
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"bp.getFollowers"] forKey:kPhotoponMethodNameKey];
        //[self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"bp.getFollowing"] forKey:kPhotoponMethodNameKey];
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        
        
        self.pullToRefreshEnabled = NO;
        
        /*
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        * /
        
        
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        self.shouldReloadOnAppear = NO;
    }
    return self;
}*/


- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.collectionView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; // PFQueryTableViewController reads this in viewDidLoad -- would prefer to throw this in init, but didn't work
    
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:TABLE_VIEW_BACKGROUND_COLOR]; //[UIColor colorWithRed:211.0f green:214.0f blue:219.0f alpha:1.0f]];
    
    
    /*
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]];
    self.tableView.backgroundView = texturedBackgroundView;
    */
    
    
    
    [self initTitleLabelWithText:@"Explore"];
    
    
    /*
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
    */
    
    
    
    
    
    //[self initTitleLabelWithText:@"Explore"];
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
        [self.methodParams setObject:@"media_models" forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:@"bp.getMyGallery" forKey:kPhotoponMethodNameKey];
        
        
        
        //self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
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
        //self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        
        //self.shouldReloadOnAppear = NO;
        
    }
    return self;
}
*/

- (void)objectsWillLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)objectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	//if(self.pullToRefreshEnabled)
        //[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    //if (self.objects==0)
        //[self configureNoResultsView];
    
}

- (void)searchObjectsWillLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super searchObjectsWillLoad];
    
}

- (void)searchObjectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super searchObjectsDidLoad:error];
    
	/*
     if(self.pullToRefreshEnabled)
     [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
     */
    //if (self.searchObjects==0)
        //[self configureNoSearchResultsView];
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.tabBarController setTabBarHidden:NO animated:NO];
    
}

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
     */
    
    // temp fix until brian uploads updated php server file
    NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
                               self.identifier,
                               [[NSNumber alloc] initWithInt:
                                [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]  +
                                [[self.methodParams objectForKey:kPhotoponObjectsPerPageKey] integerValue]],
                               nil];
    
    return params;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self showSearchBar];
}

- (void)configureCell:(PhotoponSearchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponUserModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.section==0) {
        //[self configureFeaturedUsersTableContainerCell:cell atIndexPath:indexPath];
        return;
    }
    
    NSString *contentText = [object.dictionary objectForKey:kPhotoponSearchResultItemTitleKey];
    
    NSString *imageName = [self.methodParams objectForKey:kPhotoponMethodSearchScopeKey];
    
    
    [cell.photoponBtnResultCellImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"PhotoponTableViewCellIcon%@", imageName]] forState:UIControlStateNormal];
    [cell.photoponBtnResultCellImage setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [cell.photoponBtnResultCellImage setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    
    cell.photoponBtnResultCellImage.titleLabel.text = contentText;
    
}


- (NSMutableArray*) featuredUsersArray{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray *fakeUserArr = [[NSMutableArray alloc] init];
    
    int i;
    
    for (i = 0; i<20; i++) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"167"] forKey:kPhotoponUserAttributesAlreadyAutoFollowedFacebookFriendsKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesBioKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesCurrentUserKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesDidFollowStringKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesEmailKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesFacebookAccessTokenKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesFacebookFriendsKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesFacebookIDKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesFirstNameKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesFollowedByCountStringKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesFollowersCountStringKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesFullNameKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesIdentifierKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesInstagramIDKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesIsFollowedByCurrentUserKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesLastNameKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesMediaCountStringKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesProfileCoverPictureUrlKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesProfilePictureUrlKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesRedeemCountStringKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesScoreStringKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesTwitterIDKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesUsernameKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponUserAttributesWebsiteKey];
        
        [dict setObject:[[NSNumber alloc] initWithBool:YES] forKey:kPhotoponUserAttributesDidFollowKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponUserAttributesFollowersCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponUserAttributesMediaCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponUserAttributesRedeemCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponUserAttributesPhotoCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponUserAttributesFollowedByCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponUserAttributesScoreKey];
        
        [fakeUserArr addObject:dict];
        
    }
    
    //return [NSArray arrayWithArray:fakeMediaArr];
    
    return fakeUserArr;
    
}

- (void)configureFeaturedUsersTableContainerCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponFeaturedUsersViewController = (PhotoponFeaturedUsersViewController*)[self tableViewForRowAtIndexPath:indexPath];
    [cell.contentView addSubview:self.photoponFeaturedUsersViewController.view];
    
    
    
}

- (PhotoponModel *)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    if (indexPath.section==0) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[self.objects objectAtIndex:indexPath.row]];
        
        dict
        
    }
    */
    // overridden, since we want to implement sections
    
    if (indexPath.row < self.objects.count) {
        
        PhotoponModel *m = [PhotoponModel modelWithDictionary: [self.objects objectAtIndex:indexPath.row]];
        /*
        if (indexPath.section==0)
            [m.dictionary setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
        */
        
        return m;
         
    }
    
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self isSearchResultsTableView:tableView])
        return self.searchObjects.count;
    
    // otherwise, we have the default table for this table view controller
    // Default table is broken into 2 sections - users & hashtags
    if (section==0)
        return 1;
    
    // compensate for the 1 we borrowed for the single-row section (in section 1 - which holds our featured user table)
    return self.objects.count-1;
}

/*
- (void)configureCell:(PhotoponSearchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    cell.tag = indexPath.row;
    cell.delegate = self;
    
    
    [cell.photoponMediaCell.imageView setAlpha:0.0f];
    cell.photoponMediaHeaderInfoView.delegate = self;
    cell.photoponMediaFooterInfoView.delegate = self;
    cell.photoponMediaCaptionCell.delegate = self;
    
    cell.photoponMediaModel = object;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
 * /

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
*/

- (UITableViewCell *)newCellWithObject:(PhotoponModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    if ([[object.dictionary objectForKey:kPhotoponEntityNameKey] isEqualToString:kPhotoponUserClassName]) {
        // return an empty cell to hold the horizontal featured user table
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:featuredUsersContainerCellIdentifier];
    }
    
    PhotoponSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:mFullCellIdentifier];
    
    if (cell == nil) {
        cell = [PhotoponSearchTableViewCell photoponSearchResultsTableViewCellWithContentText:[object.dictionary objectForKey:kPhotoponHashTagAttributesContentKey] imageName:@"PhotoponTableViewCellIconHashtags.png"];
    }
    
    return cell;
}



/*
- (void)configureCell:(PhotoponTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object{
 
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
    PhotoponMediaModel *photoponMediaModel = [PhotoponMediaModel modelWithDictionary:object];
 
 
    / *cell.post = apost;
 
     if (cell.post.remoteStatus == Photopo) {
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     } else {
     cell.selectionStyle = UITableViewCellSelectionStyleBlue;
     }* /
}
/ *
- (UICollectionViewCell *)newCell {
 
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    NSString *cellIdentifier = @"_PhotoponMediaCellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PhotoponMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_gradient_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
        [cell setBackgroundView:imageView];
    }
    return cell;
}
*/





- (void)didReceiveMemoryWarning
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
