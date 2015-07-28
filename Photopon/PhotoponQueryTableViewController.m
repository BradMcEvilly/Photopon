	//
//  PhotoponQueryTableViewController.m
//  PhotoponParser
//
//  Created by Denis Berton on 22/09/12.
//  Copyright (c) 2012 Denis Berton. All rights reserved.
//

#import "PhotoponQueryTableViewController.h"
#import "PhotoponTableViewCell.h"
#import "PhotoponModelManager.h"
#import "PhotoponMediaModel.h"
#import "PhotoponApplicationKey.h"
#import "PhotoponModel.h"
#import "PhotoponAppDelegate.h"
#import "MBProgressHUD.h"
#import "PhotoponInfoView.h"
#import "PhotoponNestedDetailViewController.h"
#import <unistd.h>
#import "PhotoponUsersTableViewCell.h"
#import "SoundUtil.h"
#import "PhotoponSearchTableViewCell.h"
#import "PhotoponMediaCaptionCell.h"
#import "PhotoponTimelineViewController.h"
#import "PhotoponAccountProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ResizeAdditions.h"
#import "PhotoponTabBarController.h"
#import "UITabBarController+hidable.h"
#import "PhotoponFeaturedUsersViewController.h"

#define SEARCH_HEADER_FRAME_DRFAULT CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)
#define SEARCH_HEADER_FRAME_ACTIVE CGRectMake(0.0f, 0.0f, 320.0f, 88.0f)

#define SEARCH_HEADER_BOUNDS_DRFAULT CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)
#define SEARCH_HEADER_BOUNDS_ACTIVE CGRectMake(0.0f, 0.0f, 320.0f, 88.0f)

static CGFloat const kMaxAngle = 0.1;
static CGFloat const kMaxOffset = 20;

static NSString *searchCellIdentifier = @"_PhotoponSearchTableViewCellIdentifier";

NSTimeInterval const PhotoponTableViewControllerRefreshTimeoutPages = 300; // 5 minutes

@interface PhotoponQueryTableViewController () <MBProgressHUDDelegate> {
    
}

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSUInteger currentOffset;
//@property (nonatomic, strong, readwrite) NSMutableArray *objects;
@property (nonatomic, strong, readwrite) NSMutableArray *searchObjects;
@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *searchOverlayContainer;
@property (nonatomic, strong) UIButton *searchOverlay;
@property (nonatomic, assign) BOOL searchTextChanged;
@property (nonatomic, strong) NSMutableArray * orSkip;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIView *noResultsView;

- (void)configureNoResultsView;
- (void)configureNoSearchResultsView;

@end

@interface PhotoponQueryTableNextPageCell : PhotoponTableViewCell
@property (nonatomic, strong) UIActivityIndicatorView *activityAccessoryView;
@end


@implementation PhotoponQueryTableViewController{
    PhotoponModelManager *_pmm;
    NSString *_methodName;
    UIView *noResultsView;
    BOOL didPlayPullSound;
    BOOL didTriggerRefresh;
    BOOL _isSyncing;
    
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
    NSArray*            _allWords;
    NSArray*            _filteredWords;
    NSString*           _currentFilter;
    dispatch_queue_t    _searchQueue;
}

//@synthesize pmm;
@synthesize HUD;
@synthesize photoponBackgroundImageNameString;
@synthesize photoponBackgroundImageView;
@synthesize photoponBackgroundImage;
@synthesize rootObject;
@synthesize noResultsView;
@synthesize methodParams;
@synthesize emptyTableImageName;
@synthesize hasMore;
@synthesize currentOffset;
@synthesize objects;
@synthesize searchBar;
@synthesize lastSync;
@synthesize hasSearchBarNumber;
@synthesize searchTypeNumber;
@synthesize searchObjects;
@synthesize searchOverlayContainer;
@synthesize searchOverlay;
@synthesize searchMethodParams;

@synthesize asyncSearchTypingTimer;

@synthesize searchHeader;

@synthesize loadTimer;

-(void)dealloc{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if([self.tableView observationInfo])
        [self.tableView removeObserver:self forKeyPath:@"contentOffset"];

    self.objects = nil;
    self.HUD = nil;
    
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //self.objects = nil;
    
}

-(NSString*)identifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponModelIdentifierKey];
}
/*
-(NSString*)searchMethodName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
    return (NSString*)[self.searchMethodParams objectForKey:kPhotoponMethodNameSearchScopeKey];
}*/

-(NSString*)entityName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponEntityNameKey];
}

-(NSString*)methodName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponMethodNameKey];
}

-(NSString*)methodNameSearch{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSString alloc] initWithFormat:@"bp.search%@", (NSString*)[self.methodParams objectForKey:kPhotoponMethodSearchScopeKey]];
}

-(NSString*)methodSearchText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponMethodSearchTextKey];
}
 
-(NSString*)methodReturnedModelsKey{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponMethodReturnedModelsKey];
}

-(NSString*) className{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.methodParams) {
        return [self.methodParams objectForKey:kPhotoponEntityNameKey];
    }else{
        return self.entityName;
    }
}

-(void)setHasSearchBarBool:(BOOL)hasSearchBarBool{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setHasSearchBarNumber: [[NSNumber alloc] initWithBool:hasSearchBarBool]];
}

-(BOOL)hasSearchBarBool{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.hasSearchBarNumber boolValue];
}


/*
-(void)setSearchType:(PhotoponSearchTableType)searchType{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setSearchTypeNumber: [[NSNumber alloc] initWithInt:searchType]];
    
    if (self.searchBar.text.length==0)
        return;
    
    self.searchTextChanged = YES;
    [self loadObjects];
}

-(PhotoponSearchTableType)searchType{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    return (PhotoponSearchTableType)[self.searchTypeNumber intValue];
}

-(void) setClassName:(NSString *)className_{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.methodParams setObject:className_ forKey:kPhotoponEntityNameKey];
}

-(NSString*) keyToDisplay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.displayedTitleKey;
}

-(void) setKeyToDisplay:(NSString *)keyToDisplay_{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.displayedTitleKey = keyToDisplay_;
}
/*
- (id)initWithStyle:(UITableViewStyle)otherStyle{
    return [self initWithStyle:otherStyle];
}
*/


+ (float)randomFloatBetween:(float)smallNumber andMax:(float)bigNumber
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    float diff = bigNumber - smallNumber;
    
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void)addSomeRandomTransformOnThumbnailViews
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    for(UIView *view in self.imageViews)
    {
        CGFloat angle;
        NSInteger offsetX;
        NSInteger offsetY;
        
        angle = [PhotoponQueryTableViewController randomFloatBetween:-kMaxAngle andMax:kMaxAngle];
        offsetX = (NSInteger)[PhotoponQueryTableViewController randomFloatBetween:-kMaxOffset andMax:kMaxOffset];
        offsetY = (NSInteger)[PhotoponQueryTableViewController randomFloatBetween:-kMaxOffset andMax:kMaxOffset];
        view.transform = CGAffineTransformMakeRotation(angle);
        view.center = CGPointMake(view.center.x + offsetX, view.center.y + offsetY);
        
        // This is going to avoid crispy edges.
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
}
/*
#pragma mark - ASMediaFocusDelegate
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return ((UIImageView *)view).image;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.parentViewController.view.bounds;
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.parentViewController;
}

- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.rootObject && [(NSString*)[self.rootObject objectForKey:kPhotoponEntityNameKey] isEqualToString:kPhotoponUserClassName]) {
        
        //NSURL *focusPicURL = [
        
        //return
    }
    
    NSString *path;
    NSString *name;
    NSInteger index;
    NSURL *url;
    
    if(self.tableView == nil)
    {
        index = ([self.imageViews indexOfObject:view] + 1);
    }
    else
    {
        index = view.tag;
    }
    
    // Here, images are accessed through their name "1f.jpg", "2f.jpg", …
    name = [NSString stringWithFormat:@"%df", index];
    path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    
    url = [NSURL fileURLWithPath:path];
    
    return url;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *title;
    
    title = [NSString stringWithFormat:@"Image %@", [self mediaFocusManager:mediaFocusManager mediaURLForView:view].lastPathComponent];
    
    return @"Of course, you can zoom in and out on the image.";
}
*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(![keyPath isEqualToString:@"contentOffset"])
        return;
    
    CGPoint newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
    
    if (newValue.y > oldValue.y && newValue.y > -65.0f) {
        didPlayPullSound = NO;
    }
    
    if(newValue.y == oldValue.y) return;
    
    
    if(newValue.y <= -65.0f && newValue.y < oldValue.y && ![self isSyncing] && !didPlayPullSound && !didTriggerRefresh) {
        // triggered
        [SoundUtil playPullSound];
        didPlayPullSound = YES;
    }
    
}

- (BOOL)isSyncing {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.isLoading;
}

-(void)initTitleLabelWithText:(NSString*)title{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // this will appear as the title in the navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor grayColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(title, @"");
    [label sizeToFit];
    
}

- (void)loadObjects{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	[self reloadInBackground];
}

- (void)loadNextPage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isLoading) {
        return;
    }
    [self appendNextPageWithFinishCallback:^(NSError *error){
        
    }];
}

- (void)showEmptyTableWithImageName:(NSString*)imageName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // this should be overridden but if it's not then show a generic empty message view
    if (!imageName) {
        // set default image
        imageName = [[NSString alloc] initWithFormat:@"%@", @"PhotoponEmptyTable.png" ];
    }
    
    NSLog(@"Table is empty");
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.tableView.bounds];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:imageView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}

- (void)viewDidLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    _searchQueue = dispatch_queue_create( "com.photopon.searchfilter", DISPATCH_QUEUE_SERIAL);
    [self.tableView setBackgroundColor:[UIColor colorWithRed:211.0f green:214.0f blue:219.0f alpha:1.0f]];
    
    [self.searchBar setShowsScopeBar:NO];
    
    //[self.searchBar sizeToFit];
    
    
    
    //[self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self initHUD];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //[self configureNoResultsView];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    if(self.pullToRefreshEnabled){
        if (self.refreshHeaderView == nil) {
            Photopon_EGORefreshTableHeaderView *egoView = [[Photopon_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
            egoView.delegate = (id)self;
            [self.tableView addSubview:egoView];
            self.refreshHeaderView = egoView;
        }
        [self.refreshHeaderView refreshLastUpdatedDate];
    }
    
    [self reloadInBackground];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    NSLog(@"Total number of rows = %d ", [self.objects count]);
    
    if (rootObject) {
        
        UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateNormal];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateHighlighted];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateSelected];
        [signOutButton setFrame:CGRectMake( 0.0f, 0.0f, 39.0f, 30.0f)];
        [signOutButton addTarget:self action:@selector(backButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:signOutButton];
        
    }
    
    /*
     
    if ([self.objects count] == 0)
    {
        [self configureNoResultsView];
        //[self showEmptyTableWithImageName:@"PhotoponEmptyTable@2x.png"];
        
    }
    else
    {
        [self.tableView setBackgroundView:nil];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView setBackgroundColor:[UIColor clearColor]];
    }
    //return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    * /
    
    if(self.scrollView)
    {
        self.scrollView.contentSize = self.contentView.bounds.size;
    }
    
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = (id)self;
    
    // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
    [self.mediaFocusManager installOnViews:self.imageViews];
    
    [self addSomeRandomTransformOnThumbnailViews];
    */
    
}
- (void)viewDidUnload {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if([self.tableView observationInfo])
        [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    
    [super viewDidUnload];
    
    self.refreshHeaderView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 1;
}

- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.searchBar becomeFirstResponder];
    
    if ([self hasSearchBar] && self.searchBar.text.length>0) {
        NSLog(@"[self.searchBar becomeFirstResponder];");
        [self.searchBar becomeFirstResponder];
    }
    
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:hidden animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.searchBar becomeFirstResponder];
    
    if ([self hasSearchBar] && self.searchBar.text.length>0) {
        NSLog(@"[self.searchBar becomeFirstResponder];");
        [self.searchBar becomeFirstResponder];
    }
    
    [super viewDidAppear:animated];
    
    
    
    
    
    //PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    //[appDelegate.tabBarController setTabBarHidden:hidden animated:NO];
    
    
    /*
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    if( appDelegate.connectionAvailable == NO ) return; //do not start auto-synch if connection is down
    
    
    NSDate *lastSynced = [self lastSyncDate];
    if (lastSynced == nil || ABS([lastSynced timeIntervalSinceNow]) > PhotoponTableViewControllerRefreshTimeout) {
        // If table is at the original scroll position, simulate a pull to refresh
        if (self.tableView.contentOffset.y == 0) {
            [self simulatePullToRefresh];
        } else {
            // Otherwise, just update in the background
            [self reloadInBackground];
        }
    }
     */
}

- (void)simulatePullToRefresh {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(!_refreshHeaderView) return;
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y = - 65.0f;
    [self.tableView setContentOffset:offset];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
        return [self tableViewNextPageCell:tableView];
    }
    
    //UITableViewCell *cell = [self newCell];
    
    UITableViewCell *cell = [self newCellWithObject:object];
    
    if (IS_IPAD || self.tableView.isEditing) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell atIndexPath:indexPath withObject:object];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (UITableViewCell *)resultsTableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponSearchTableViewCell *cell = [self newSearchCellWithObject:object];
    
    
    if (IS_IPAD || self.tableView.isEditing) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureSearchCell:cell atIndexPath:indexPath withObject:object];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void) backButtonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (PhotoponSearchTableViewCell *)newSearchCellWithObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    PhotoponSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    
    if (cell == nil) {
        cell = [PhotoponSearchTableViewCell photoponSearchResultsTableViewCellWithContentText:nil imageName:nil];
    }
    return cell;
}

- (UITableViewCell *)newCell{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (cell == nil) {
        
    	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[self cellNibName] owner:self options:nil];
    	cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    /*
     // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
     NSString *cellIdentifier = [NSString stringWithFormat:@"_PTable_%@_Cell", [self.methodParams objectForKey:kPhotoponEntityNameKey]];
     UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }*/
    
    return cell;
}


- (UITableViewCell *)newCellWithObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (cell == nil) {
        
        //[tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"cell"];
        //tvc = [tableView dequeueReusableCellWithIdentifier: @"cell"];
        
    	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[self cellNibName] owner:self options:nil];
    	cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    /*
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    NSString *cellIdentifier = [NSString stringWithFormat:@"_PTable_%@_Cell", [self.methodParams objectForKey:kPhotoponEntityNameKey]];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }*/
    
    return cell;
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PhotoponModel *)object{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
        return [self tableViewNextPageCell:tableView];
    }
    
    
    static NSString *identifier = @"PhotoponModelTableCell";
    PhotoponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhotoponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.displayedTitleKey.length > 0) {
        cell.textLabel.text = [object objectForKey:self.displayedTitleKey];
    }
    if (self.displayedImageKey.length > 0) {
        cell.imageView.image = [UIImage imageWithData:[object objectForKey:self.displayedImageKey]];
    }
    
    
    
    return cell;
}
*/
- (id)objectAtIndexPath:(NSIndexPath *)indexPath{
	return [self.objects objectAtIndex:indexPath.row];
}

- (id)searchObjectAtIndexPath:(NSIndexPath *)indexPath{
	return [self.searchObjects objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
        return [self tableViewNextPageCell:tableView];
    }
	else{
        return [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
	}
}

-(PhotoponModelManager*)pmm{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!_pmm) {
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (_pmm) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        _pmm = [[PhotoponModelManager alloc] init];
    }
    
    
    return _pmm;
    
    
    
    /*
    
    if (_pmm) {
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (_pmm) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        return _pmm;
    }
    if (self.rootObject) {
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self.rootObject) {          TRUE TRUE TRUE", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        _pmm = [[PhotoponModelManager alloc] init];
    }else{
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self.rootObject) {          FALSE FALSE FALSE", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        _pmm = [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] pmm];
    }
    return _pmm;
     */
}

- (void)objectsWillLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (void)objectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    if (self.objects.count==0)
        [self configureNoResultsView];
}

- (void)searchObjectsWillLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.tableView beginUpdates];
    //[self.tableView endUpdates];
}

- (void)searchObjectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	/*
    if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    */
    
    
    //if (self.searchObjects==0)
        //[self configureNoSearchResultsView];
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.tabBarController setTabBarHidden:NO animated:NO];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    /*
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    CGFloat differenceFromLast = lastContentOffset - currentOffset;
    lastContentOffset = currentOffset;
    
    
    
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self expand];
    }
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self contract];
    }
    */
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(Photopon_EGORefreshTableHeaderView*)view{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDate *lastSynced = [self lastSyncDate];
    if (lastSynced == nil || ABS([lastSynced timeIntervalSinceNow]) > PhotoponTableViewControllerRefreshTimeoutPages) {
        [self loadObjects];
        [noResultsView removeFromSuperview];
        didTriggerRefresh = YES;
    }
}

+ (UITableViewCell*)callToActionCellWithActionText:(NSString*)actionText{
    
    
    
    
    
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(Photopon_EGORefreshTableHeaderView*)view{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	return self.isLoading; 
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(Photopon_EGORefreshTableHeaderView*)view{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	return [self lastSyncDate];
}

//  PhotoponQueryTableViewController implementation (modified)
//
//  PhotoponQueryTableViewController.m
//  PhotoponModelManager
//

- (id)initWithRootObject:(NSMutableDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithStyle:UITableViewStylePlain rootObject:_rootObject];
    if (self) {

    }
    return self;
}

- (id)initWithEntityName:(NSString *)entityName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithStyle:UITableViewStylePlain entityName:entityName];
    if (self) {

    }
    return self;
}

/**
 Initializes a new query table for the specified entity
 @param style The table view style
 @param rootObject The root dictionary displayed in the table
 @return The initialized query table
 */

- (id)initWithStyle:(UITableViewStyle)style rootObject:(NSMutableDictionary *)_rootObject{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        
        //self.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = NO;
        
        self.rootObject = _rootObject;
    
        self.objectsPerPage = 10;
        [self updateCurrentOffset:0];
        
        self.hasSearchBarBool = NO;
        
        self.methodParams = [[NSMutableDictionary alloc] init];
        [self.methodParams setObject:[rootObject objectForKey:kPhotoponEntityNameKey] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[rootObject objectForKey:kPhotoponModelIdentifierKey] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        //[self.methodParams setObject:[NSNumber numberWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        hidden = NO;
        
        // set defaults
        [self.methodParams setObject:kPhotoponAPIReturnedMediaModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:kPhotoponSearchScopePeople forKey:kPhotoponMethodSearchScopeKey];
        [self.methodParams setObject:self.methodNameSearch forKey:kPhotoponMethodNameSearchKey];
        
        self.objects = [NSMutableArray new];
        self.searchObjects = [NSMutableArray new];
        
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
        
        // Search bar
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        //[self.searchBar setShowsCancelButton:YES animated:YES];
        [self.searchBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundSearchBar.png"]];
        self.searchBar.delegate = (id)self;
        
        // make sure delegates are still set
        self.searchDisplayController.delegate = self;
        
        self.searchBar.placeholder = NSLocalizedString(kPhotoponPlaceholderSearchField, nil);
        
        // Don't show the scope bar or cancel button until editing begins
        
        [self.searchBar setShowsScopeBar:YES];
        
        self.searchDisplayController.searchResultsDelegate = self;
        //[self.searchDisplayController.searchContentsController setWantsFullScreenLayout:YES];
        
        //[candySearchBar sizeToFit];
        
        
        //[self.searchBar setScopeButtonTitles:[[NSArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopePeople], [[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopeHashtags], nil]];
        
        // Don't show the scope bar or cancel button until editing begins
        //[self.searchBar setShowsScopeBar:YES];
        //[self.searchBar sizeToFit];
        
        [self.searchBar setScopeBarBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundScopeBar.png"]];
        
        [self.searchBar setScopeButtonTitles:[[NSArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopePeople], [[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopeHashtags], nil]];
        
        
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       3");
        
        // Search overlay container
        searchOverlayContainer = [[UIView alloc] initWithFrame:CGRectZero];
        
        // Search overlay
        self.searchOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        [self.searchOverlay addTarget:self action:@selector(dismissOverlay:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    NSLog(@"PhotoponQueryTableViewController initWithStyle       4");
    
    return self;
}

- (void)updateCurrentOffset:(NSUInteger)curOffset{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.currentOffset = curOffset;
    [self.methodParams setObject:[NSNumber numberWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];    
}

- (id)initWithStyle:(UITableViewStyle)style entityName:(NSString *)entityName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        self.methodParams = [[NSMutableDictionary alloc] init];
        
        self.objectsPerPage = 10;
        [self updateCurrentOffset:0];
        
        self.hasSearchBarBool = NO;
        
        hidden = NO;
        
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.methodParams setObject:[[NSString alloc] initWithString: entityName] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:uidString forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        // redundant - now handled by updateCurrentOffset method
        //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"media_models"] forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:kPhotoponSearchScopePeople forKey:kPhotoponMethodSearchScopeKey];
        [self.methodParams setObject:self.methodNameSearch forKey:kPhotoponMethodNameSearchKey];
        
        self.objects = [NSMutableArray new];
        self.searchObjects = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
        
        // Search bar
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        //[self.searchBar setShowsCancelButton:YES animated:YES];
        [self.searchBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundSearchBar.png"]];
        self.searchBar.delegate = (id)self;
        
        // make sure delegates are still set
        self.searchDisplayController.delegate = self;
        
        self.searchBar.placeholder = NSLocalizedString(kPhotoponPlaceholderSearchField, nil);
        
        //[self.searchBar setScopeButtonTitles:[[NSArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopePeople], [[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopeHashtags], nil]];
        
        // Don't show the scope bar or cancel button until editing begins
        //[self.searchBar setShowsScopeBar:YES];
        
        [self.searchBar setShowsScopeBar:YES];
        
        //[self.searchBar sizeToFit];
        
        [self.searchBar setScopeBarBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundScopeBar.png"]];
        
        [self.searchBar setScopeButtonTitles:[[NSArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopePeople], [[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopeHashtags], nil]];
        

        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       3");
        
        // Search overlay container
        searchOverlayContainer = [[UIView alloc] initWithFrame:CGRectZero];
        
        // Search overlay
        self.searchOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        [self.searchOverlay addTarget:self action:@selector(dismissOverlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSLog(@"PhotoponQueryTableViewController initWithStyle       4");
    
    return self;
}

- (void)processSearchQueryResults:(NSArray *)results error:(NSError *)error callback:(void (^)(NSError *error))callback {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.loadTimer invalidate];
    
    NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"query results not processed on main queue");
    
    self.isLoading = NO;
    
    /*
    if (results != nil && ![results isKindOfClass:[NSArray class]]) {
        [NSException raise:NSInternalInconsistencyException
                    format:NSLocalizedString(@"Query did not return a result NSArray or nil", nil)];
        return;
    } else if ([results isKindOfClass:[NSArray class]]) {
        for (id object in results) {
            if (!([object isKindOfClass:[PhotoponModel class]] || [object isKindOfClass:[NSDictionary class]])) {
                [NSException raise:NSInternalInconsistencyException
                            format:NSLocalizedString(@"Query results contained invalid objects", nil)];
                return;
            }
        }
    }
    
    
    
    / *
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Results", nil)
     message:[NSString stringWithFormat:@"Count: %i", results.count]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
     [alert show];
     * /
    if (results.count > 0)
		self.searchObjects = [NSMutableArray arrayWithArray:results];
    
    //self.currentOffset += results.count;
    [self.methodParams setObject:[NSNumber numberWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
    self.hasMore = (results.count == self.objectsPerPage);
    self.isLoading = NO;
    
    
    
    [SoundUtil playRollupSound];
    //didTriggerRefresh = NO;
    
    //self.tableView.userInteractionEnabled = YES;
    
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Poor network connection", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
    // Post process results
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self postProcessSearchResults];
        
        dispatch_async(q, ^{
            
            [self searchObjectsWillLoad];
            
			[self.tableView reloadData];
            
            [self searchObjectsDidLoad:error];
            
            if (callback != NULL) {
                callback(error);
            }
        });
    });
    */
    
}

- (void)processQueryResults:(NSArray *)results error:(NSError *)error callback:(void (^)(NSError *error))callback {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.loadTimer invalidate];
    
    // double check for now - needs to be rethought and done right
    if (self.noResultsView.window) {
        [self.noResultsView removeFromSuperview];
    }
    
    NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"query results not processed on main queue");
    
    
    
    if (results != nil && ![results isKindOfClass:[NSArray class]]) {
        [NSException raise:NSInternalInconsistencyException
                    format:NSLocalizedString(@"Query did not return a result NSArray or nil", nil)];
        return;
    } else if ([results isKindOfClass:[NSArray class]]) {
        for (id object in results) {
            if (!([object isKindOfClass:[PhotoponModel class]] || [object isKindOfClass:[NSDictionary class]])) {
                [NSException raise:NSInternalInconsistencyException
                            format:NSLocalizedString(@"Query results contained invalid objects", nil)];
                return;
            }
        }
    }
    
    
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Results", nil)
                                                    message:[NSString stringWithFormat:@"Count: %i", results.count]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
    */
    if (results.count > 0) {
        // temp fix
		[self.objects addObjectsFromArray:results];
        //self.objects = [NSMutableArray arrayWithArray:results];
    }
    
    [self updateCurrentOffset:self.currentOffset+results.count];
    
    self.hasMore = (results.count == self.objectsPerPage);
    self.isLoading = NO;
    
    [SoundUtil playRollupSound];
    didTriggerRefresh = NO;
    
    self.tableView.userInteractionEnabled = YES;
    
    if (error != nil) {
        
        //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
    }
    __weak __typeof(&*self)weakSelf = self;
    // Post process results
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [weakSelf postProcessResults];
        
        dispatch_async(q, ^{
            
            [weakSelf objectsWillLoad];
            
			[weakSelf.tableView reloadData];
            
            [weakSelf objectsDidLoad:error];
            
            if (callback != NULL) {
                callback(error);
            }
        });
    });
    
    
    
}



- (void)appendNextPageWithFinishCallback:(void (^)(NSError *error))callback {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    callback = [callback copy];
    
    self.isLoading = YES;
    self.tableView.userInteractionEnabled = NO;
    
    
    
    
    
    
    
    
    
    /**************************************************/
    /**************************************************/
    /****           IMPORTANT           ***************/
    /**************************************************/
    /**************************************************/
    /****       TEMPORARY FIX ONLY      ***************/
    /**************************************************/
    /**************************************************/
    // 
    if([[self entityName] isEqualToString:kPhotoponHashtagClassName] || [[self entityName] isEqualToString:kPhotoponMentionClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponCouponClassName){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if(![self hasSearchBar] && !self.searchBar.text.length>0){
            
            NSError *error = nil;
            [self processQueryResults:[[NSArray alloc] initWithArray:[self defaultHashTagResults]] error:error callback:callback];
            
            //return;
        }
    }
    
    //NSString *queryText = self.searchBar.text;
    
    NSArray *params = [[NSArray alloc] initWithArray:[self paramsForTable]];
    
    NSDictionary *config;
    
    /* Form search query for text if possible
    if ([self hasSearchBar] && self.methodSearchText.length > 0) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([self hasSearchBar] && queryText.length > 0) {       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        params = [[NSArray alloc] initWithArray:[self paramsForSearchTable]];
        
        config = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self.methodNameSearch, kPhotoponMethodNameKey,
                                params, kPhotoponMethodParamsKey, nil];
        
        //self.tableView.userInteractionEnabled = YES;
        
        [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            //NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            NSDictionary *returnData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [[NSArray alloc] initWithArray:[self fakeUserResults]], self.methodReturnedModelsKey,
                                        nil];
            
            [self processSearchQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
    }*/
    
    config = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              self.methodName, kPhotoponMethodNameKey,
              params, kPhotoponMethodParamsKey, nil];
    
    if([[self entityName] isEqualToString:kPhotoponMediaClassKey]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponMediaClassKey){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // IMPORTANT: First we have to check if this timeline table is contained in a detail view controller
        //            If it is, we need to pass the userID to the sync method
        //            Otherwise, we can just call the standard timeline sync method which uses the currentUser
        
        [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            // temporarily fake results
            NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            //[returnData objectForKey:self.methodReturnedModelsKey];
            
            //NSDictionary *returnData = [[NSDictionary alloc] initWithObjectsAndKeys: [[NSArray alloc] initWithArray:[self fakeMediaResultsArray]], self.methodReturnedModelsKey, nil];
            
            
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"-------->        returnData = %@", returnData);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            [self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
            //[self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
    }
    
    if([[self entityName] isEqualToString:kPhotoponActivityClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponMediaClassKey){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // IMPORTANT: First we have to check if this timeline table is contained in a detail view controller
        //            If it is, we need to pass the userID to the sync method
        //            Otherwise, we can just call the standard timeline sync method which uses the currentUser
        
        [self.pmm syncNewsWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            // temporarily fake results
            //NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            //[returnData objectForKey:self.methodReturnedModelsKey];
            
            
            NSDictionary *returnData = [[NSDictionary alloc] initWithObjectsAndKeys: [[NSArray alloc] initWithArray:[self fakeActivityResults]], self.methodReturnedModelsKey, nil];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"-------->        returnData = %@", returnData);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
            //[self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
    }
    
    
    if([[self entityName] isEqualToString:kPhotoponCommentClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponMediaClassKey){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // IMPORTANT: First we have to check if this timeline table is contained in a detail view controller
        //            If it is, we need to pass the userID to the sync method
        //            Otherwise, we can just call the standard timeline sync method which uses the currentUser
        
        [self.pmm syncCommentsWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            // temporarily fake results
            NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            //[returnData objectForKey:self.methodReturnedModelsKey];
            
            //NSDictionary *returnData = [[NSDictionary alloc] initWithObjectsAndKeys: [[NSArray alloc] initWithArray:[self fakeMediaResultsArray]], self.methodReturnedModelsKey, nil];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"-------->        returnData = %@", returnData);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *arr = (NSArray*)[returnData objectForKey:self.methodReturnedModelsKey];
            
            //[self processQueryResults:[self reversedArrayWithArray:arr] error:error callback:callback];
            [self processQueryResults:arr error:error callback:callback];
            
            //[self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncHomeWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
    }
    
    if([[self entityName] isEqualToString:kPhotoponUserClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponMediaClassKey){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // IMPORTANT: First we have to check if this timeline table is contained in a detail view controller
        //            If it is, we need to pass the userID to the sync method
        //            Otherwise, we can just call the standard timeline sync method which uses the currentUser
        
        [self.pmm syncModelsWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncModelsWithConfig success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            NSDictionary *returnData;
            
            
            // temporary local hack until the remote API method is written and available for use
            
            if ([[self class] isKindOfClass:[PhotoponFeaturedUsersViewController class]]){
                
                returnData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            [[NSArray alloc] initWithArray:[self fakeUserResults]], self.methodReturnedModelsKey,
                                            nil];
                
            }else{
                
                // temporarily fake results
                returnData = (NSDictionary*)responseInfo;
            }
            
            //NSDictionary *returnData = [[NSDictionary alloc] initWithObjectsAndKeys: [[NSArray alloc] initWithArray:[self fakeUserResults]], self.methodReturnedModelsKey, nil];
            
            [self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncModelsWithConfig success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
    }
    
    if([[self entityName] isEqualToString:kPhotoponCouponClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponCouponClassName){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            //NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            NSArray *returnData = [[NSArray alloc] initWithArray: (NSArray*)responseInfo];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"----------->        returnData = %@", returnData);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [self processQueryResults:returnData error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
    }
    
    /*
    if([[self entityName] isEqualToString:kPhotoponHashtagClassName] || [[self entityName] isEqualToString:kPhotoponMentionClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponCouponClassName){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
    
        NSError *error = nil;
        
        
        
        [self processQueryResults:[[NSArray alloc] init] error:error callback:callback];
        return;
    
        / *
        if ([[self class] isKindOfClass:[PhotoponExploreViewController class]])
            
        }
        
        
        [self.pmm syncModelsWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncModelsWithConfig success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            // temporarily fake results
            NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            //NSDictionary *returnData = [[NSDictionary alloc] initWithObjectsAndKeys: [[NSArray alloc] initWithArray:[self fakeUserResults]], self.methodReturnedModelsKey, nil];
            
            [self processQueryResults:(NSArray*)[returnData objectForKey:self.methodReturnedModelsKey] error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncModelsWithConfig success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
        
        * /
    
        
        /*
        
        [self processQueryResults:[[NSArray alloc] init] error:error callback:callback];
        return;
        
        
        / *
        [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            //NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            NSArray *returnData = [[NSArray alloc] initWithArray: (NSArray*)responseInfo];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"----------->        returnData = %@", returnData);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [self processQueryResults:returnData error:error callback:callback];
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [self processQueryResults:emptyArray error:error callback:callback];
            
        }];
         * /
        
        
    }
    */
    
    
    /** Otherwise, call next page method based on entityName
     */
    if([PhotoponApplicationKey isPhotoponUserKey:self.entityName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if([PhotoponApplicationKey isPhotoponUserKey:self.entityName]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponGeoPointKey:self.entityName]){
       
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponGeoPointKey:self.entityName]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
        
        
    }
    else if([PhotoponApplicationKey isPhotoponMediaModelKey:self.entityName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponMediaModelKey:self.entityName]){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    }
    else if([PhotoponApplicationKey isPhotoponCommentModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponCommentModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponCouponModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponCouponModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponTagModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponTagModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    else if([PhotoponApplicationKey isPhotoponActivityModelKey:[self entityName]]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if([PhotoponApplicationKey isPhotoponActivityModelKey:[self entityName]]){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // on success, process results
        //[self processQueryResults:results error:error callback:callback];
    }
    
    
    
    /*
    [self.pmm findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        
        //self.currentOffset =
        [self processQueryResults:results error:error callback:callback];
        
    }];
     */
    
    
    
    //NSAssert(q != nil, @"method cannot be nil");
    
    //self.currentOffset;
    //self.objectsPerPage;
    
    /*
    if (mr != nil) {
        [q performMapReduce:mr inBackgroundWithBlock:^(id result, NSError *error) {
            self.orSkip = q.orSkip;
            [self processQueryResults:result error:error callback:callback];
        }];
    } 
    else {
        [q findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            self.orSkip = q.orSkip;
            [self processQueryResults:results error:error callback:callback];
        }];
    }*/
}

- (NSArray *)reversedArrayWithArray:(NSArray*)arr {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:arr.count];
    NSEnumerator *enumerator = [arr reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (NSArray*)fakeMediaResultsArray{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    @property (readonly) NSString* identifier;
    @property (readonly) PhotoponGeoPointModel * coordinate;
    @property (readonly) NSString* value;
    @property (readonly) NSString *cost;
    
    @property (readonly) NSNumber* monetaryValue;
    @property (readonly) NSNumber* socialValue;
    @property (readonly) NSString* caption;
    @property (readonly) NSString* linkURL;
    @property (readonly) NSUInteger likeCount;
    @property (readonly) NSUInteger commentCount;
    @property (readonly) NSUInteger snipCount;
    @property (readonly) PhotoponUserModel* user;
    @property (readonly) PhotoponCouponModel* coupon;
    
    //@property (readonly) PhotoponPlace* place;
    //@property (readonly) PhotoponCouponModel* coupon;
    //@property (readonly) PhotoponImageModel* image;
    
    @property (readonly) NSString* couponId;
    //@property (nonatomic,strong) PhotoponImageModel* image;
    
    @property (readonly) NSString* thumbURL;
    @property (readonly) NSString* imageMidURL;
    @property (readonly) NSString* imageLargeURL;
    @property (readonly) NSString* locationIdentifier;
    @property (readonly) NSString* locationLatitude;
    @property (readonly) NSString* locationLongitude;
    @property (readonly) NSDate* createdTime;
    @property (readonly) NSDictionary* users;
    @property (readonly) NSDictionary* tags;
    */
    
    NSMutableArray *fakeMediaArr = [[NSMutableArray alloc] init];
    
    int i;
    
    for (i = 0; i<12; i++) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponMediaAttributesIdentifierKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"Caption"] forKey:kPhotoponMediaAttributesCaptionKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesLikeCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesCommentCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesSnipCountKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesMonetaryValueKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesSnippersKey];
        [dict setObject:[[NSNumber alloc] initWithInt:1] forKey:kPhotoponMediaAttributesSocialValueKey];
        [dict setObject:[[NSDictionary alloc] init] forKey:kPhotoponMediaAttributesTagsKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesThumbURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesUserKey];
        [dict setObject:[[NSDictionary alloc] init] forKey:kPhotoponMediaAttributesUsersKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesValueTitleKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLocationLongitudeKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLocationLatitudeKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLocationIdentifierKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLinkURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesLikersKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesImageMidURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesImageLargeURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesDidSnipKey];
        [dict setObject:[[NSNumber alloc] initWithBool:YES] forKey:kPhotoponMediaAttributesDidSnipBoolKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesDidLikeKey];
        [dict setObject:[[NSNumber alloc] initWithBool:YES] forKey:kPhotoponMediaAttributesDidLikeBoolKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCreatedTimeKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCouponKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCostKey];
        //[dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCoordinateKey];
        //[dict setObject:[[NSString alloc] initWithFormat:@"%@", @"0"] forKey:kPhotoponMediaAttributesCommentersKey];
        
        [fakeMediaArr addObject:dict];
        
    }
    
    //return [NSArray arrayWithArray:fakeMediaArr];
    
    return fakeMediaArr;
    
}

- (NSArray*)fakeSearchResultsArray{
    
    NSMutableArray *fakeResultsArr = [[NSMutableArray alloc] init];
    
    int i;
    
    for (i = 0; i<20; i++) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponUserAttributesAlreadyAutoFollowedFacebookFriendsKey];
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
        
        [fakeResultsArr addObject:dict];
        
    }
    
    return fakeResultsArr;
    
}

- (NSArray*)fakeActivityResults{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
     @property (readonly) NSString* identifier;
     @property (readonly) NSString* fullname;
     @property (readonly) NSString* username;
     @property (readonly) NSString* firstName;
     @property (readonly) NSString* lastName;
     @property (readonly) NSString* email;
     @property (readonly) NSString* bio;
     @property (readonly) NSString* website;
     @property (readonly) NSString* profilePictureUrl;
     @property (readonly) NSString* profileCoverPictureUrl;
     @property (readonly) NSNumber* followedByCount;
     @property (readonly) NSNumber* followersCount;
     @property (readonly) NSNumber* redeemCount;
     @property (readonly) NSNumber* mediaCount;
     @property (readonly) NSNumber* score;
     
     @property (readonly) NSString* followedByCountString;
     @property (readonly) NSString* followersCountString;
     @property (readonly) NSString* redeemCountString;
     @property (readonly) NSString* mediaCountString;
     @property (readonly) NSString* scoreString;
     @property (readonly) NSString *didFollowString;
     
     @property (readonly) NSString* twitterID;
     @property (readonly) NSString* facebookID;
     @property (readonly) NSString* instagramID;
     
     @property (nonatomic) BOOL didFollowBool;
     @property (readonly) NSNumber *didFollow;
     
     
     
     */
    
    
    NSMutableArray *fakeActivityArr = [[NSMutableArray alloc] init];
    /*
    int i;
    
    for (i = 0; i<20; i++) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponActivityAttributesIdentifierKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponActivityAttributesMediaIdentifierKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponActivityAttributesThumbnailURLKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponActivityAttributesTitleKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponActivityAttributesTypeKey];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponActivityAttributesUserIdentifierKey];
                [fakeActivityArr addObject:dict];
        
    }
    
    //return [NSArray arrayWithArray:fakeMediaArr];
    */
    return fakeActivityArr;
    
}

- (NSArray*)fakeUserResults{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
     @property (readonly) NSString* identifier;
     @property (readonly) NSString* fullname;
     @property (readonly) NSString* username;
     @property (readonly) NSString* firstName;
     @property (readonly) NSString* lastName;
     @property (readonly) NSString* email;
     @property (readonly) NSString* bio;
     @property (readonly) NSString* website;
     @property (readonly) NSString* profilePictureUrl;
     @property (readonly) NSString* profileCoverPictureUrl;
     @property (readonly) NSNumber* followedByCount;
     @property (readonly) NSNumber* followersCount;
     @property (readonly) NSNumber* redeemCount;
     @property (readonly) NSNumber* mediaCount;
     @property (readonly) NSNumber* score;
     
     @property (readonly) NSString* followedByCountString;
     @property (readonly) NSString* followersCountString;
     @property (readonly) NSString* redeemCountString;
     @property (readonly) NSString* mediaCountString;
     @property (readonly) NSString* scoreString;
     @property (readonly) NSString *didFollowString;
     
     @property (readonly) NSString* twitterID;
     @property (readonly) NSString* facebookID;
     @property (readonly) NSString* instagramID;
     
     @property (nonatomic) BOOL didFollowBool;
     @property (readonly) NSNumber *didFollow;

     
     
     */
    
    NSMutableArray *fakeUserArr = [[NSMutableArray alloc] init];
    
    int i;
    
    for (i = 0; i<20; i++) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"123"] forKey:kPhotoponUserAttributesAlreadyAutoFollowedFacebookFriendsKey];
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

- (NSArray*)defaultHashTagResults{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
     @property (readonly) NSString* identifier;
     @property (readonly) NSString* fullname;
     @property (readonly) NSString* username;
     @property (readonly) NSString* firstName;
     @property (readonly) NSString* lastName;
     @property (readonly) NSString* email;
     @property (readonly) NSString* bio;
     @property (readonly) NSString* website;
     @property (readonly) NSString* profilePictureUrl;
     @property (readonly) NSString* profileCoverPictureUrl;
     @property (readonly) NSNumber* followedByCount;
     @property (readonly) NSNumber* followersCount;
     @property (readonly) NSNumber* redeemCount;
     @property (readonly) NSNumber* mediaCount;
     @property (readonly) NSNumber* score;
     
     @property (readonly) NSString* followedByCountString;
     @property (readonly) NSString* followersCountString;
     @property (readonly) NSString* redeemCountString;
     @property (readonly) NSString* mediaCountString;
     @property (readonly) NSString* scoreString;
     @property (readonly) NSString *didFollowString;
     
     @property (readonly) NSString* twitterID;
     @property (readonly) NSString* facebookID;
     @property (readonly) NSString* instagramID;
     
     @property (nonatomic) BOOL didFollowBool;
     @property (readonly) NSNumber *didFollow;
     
     
     
     */
    
    NSMutableArray *defaultHashTagResultsArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dictEmpty = [[NSMutableDictionary alloc] init];
    [dictEmpty setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
    [defaultHashTagResultsArr addObject:dictEmpty];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSString alloc] initWithFormat:@"%@", @"foodporn"] forKey:kPhotoponHashTagAttributesContentKey];
    [defaultHashTagResultsArr addObject:dict];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setObject:[[NSString alloc] initWithFormat:@"%@", @"chicken"] forKey:kPhotoponHashTagAttributesContentKey];
    [defaultHashTagResultsArr addObject:dict1];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setObject:[[NSString alloc] initWithFormat:@"%@", @"happyhour"] forKey:kPhotoponHashTagAttributesContentKey];
    [defaultHashTagResultsArr addObject:dict2];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    [dict3 setObject:[[NSString alloc] initWithFormat:@"%@", @"restaurant"] forKey:kPhotoponHashTagAttributesContentKey];
    [defaultHashTagResultsArr addObject:dict3];
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
    [dict4 setObject:[[NSString alloc] initWithFormat:@"%@", @"bar"] forKey:kPhotoponHashTagAttributesContentKey];
    [defaultHashTagResultsArr addObject:dict4];
    
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc] init];
    [dict5 setObject:[[NSString alloc] initWithFormat:@"%@", @"beer"] forKey:kPhotoponHashTagAttributesContentKey];
    [defaultHashTagResultsArr addObject:dict5];
    
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc] init];
    [dict6 setObject:[[NSString alloc] initWithFormat:@"%@", @"delicious"] forKey:kPhotoponHashTagAttributesContentKey];
    [defaultHashTagResultsArr addObject:dict6];
    
    return defaultHashTagResultsArr;
    
}

- (void)reloadInBackground {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![appDelegate validateDeviceConnection]) {
        return;
    }
    
    if (self.currentOffset>0)
        [self showHUDWithStatusText:@"Refreshing"];
    else
        [self showHUDWithStatusText:@"Loading"];
    
    NSMutableDictionary *timerUserInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"currentUserID", [PhotoponUserModel currentUser].identifier, nil];
    
    self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleReloadInBackgroundTimeout) userInfo:timerUserInfo repeats:NO];
    
    [noResultsView removeFromSuperview];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self reloadInBackgroundWithBlock:^(NSError *error){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self reloadInBackgroundWithBlock:^(NSError *error){ ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //[self configureNoResultsView];// removeFromSuperview];
        
        [weakSelf hideHud];
        
    }];
     
}

- (void)handleReloadInBackgroundTimeout {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    //self.isLoading = NO;
    
    NSError *error;
    
    [self processQueryResults:[[NSArray alloc] init] error:error callback:nil];
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    
    dispatch_async(q, ^{
    
        [weakSelf updateHUDWithStatusText:@"Request timed out" mode:MBProgressHUDModeText];
        [weakSelf hideHudAfterDelay:1.0];
        [weakSelf configureNoResultsView];
    
    });
    
}

- (void)showSearchBar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    self.searchHeader = [[UIView alloc] initWithFrame:SEARCH_HEADER_FRAME_ACTIVE];
    
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bounds", nil)
                                                    message:[NSString stringWithFormat:@"x = %f y = %f width = %f height = %f", self.searchBar.bounds.origin.x, self.searchBar.bounds.origin.y, self.searchBar.bounds.size.width, self.searchBar.bounds.size.height]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
    
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Frame", nil)
                                                    message:[NSString stringWithFormat:@"x = %f y = %f width = %f height = %f", self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchBar.frame.size.width, self.searchBar.frame.size.height]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert2 show];
    */
    
    [self.searchHeader setBounds: SEARCH_HEADER_BOUNDS_DRFAULT];
    
    [self.searchHeader addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = self.searchHeader;
    
}

- (void)hideSearchBar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.tableView.tableHeaderView = nil;
}

- (void)reloadInBackgroundWithBlock:(void (^)(NSError *error))block {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (self.isLoading) {
        return;
    }
	
    // Display search bar if necessary
    if ([self hasSearchBar]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([self hasSearchBar]) { ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
        //self.tableView.tableHeaderView = self.searchHeader;
    } else {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([self hasSearchBar]) { ... }  else { ... ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //[self.searchOverlayContainer removeFromSuperview];
        self.tableView.tableHeaderView = nil;
    }
    
    self.hasMore = NO;
    
    [self updateCurrentOffset:0];
    [self.searchObjects removeAllObjects];
	[self.objects removeAllObjects];
	[self.tableView reloadData];
    [self appendNextPageWithFinishCallback:block];
    
}

- (void)reloadInBackgroundIfSearchTextChanged {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    
    if (self.searchTextChanged) {
        
        self.searchTextChanged = NO;
        [self reloadInBackground];
    }
}

- (void)postProcessResults {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.lastSync = [NSDate date];
    [self.methodParams setObject:self.lastSync forKey:kPhotoponLastSyncDate];
    
    // redundant
    //[self objectsDidLoad:nil];
}

- (void)postProcessSearchResults {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.lastSync = [NSDate date];
    [self.methodParams setObject:self.lastSync forKey:kPhotoponLastSyncDate];
    
    [self searchObjectsDidLoad:nil];
}

- (NSObject *)tableQueryMapReduce {
    return nil;
}

- (BOOL)hasSearchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.hasSearchBarBool;
}

- (void)loadNextPageWithNextPageCell:(PhotoponQueryTableNextPageCell *)cell {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isLoading) {
        return;
    }
    [cell.activityAccessoryView startAnimating];
    [cell setNeedsLayout];
    
    [self appendNextPageWithFinishCallback:^(NSError *error){
        
        [cell.activityAccessoryView stopAnimating];
        [cell setNeedsLayout];
        
    }];
    
}

#pragma mark UITableViewDelegate & Related

- (BOOL)tableViewCellIsNextPageCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (self.hasMore && (indexPath.row == self.objects.count));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self isSearchResultsTableView:tableView])
        return self.searchObjects.count;
    
    return self.objects.count + (self.hasMore ? 1 : 0);
}

- (BOOL) isSearchResultsTableView:(UITableView*)tableView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return tableView==[self resultsTableView];
}

- (UITableView*)resultsTableView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return self.searchDisplayController.searchResultsTableView;
    
}

- (UITableViewCell *)resultsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //id object = [self searchObjectAtIndexPath:indexPath];
    return [self resultsTableView:tableView cellForRowAtIndexPath:indexPath object:[self searchObjectAtIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self isSearchResultsTableView:tableView])
        return [self resultsTableView:tableView cellForRowAtIndexPath:indexPath];
    
    //id object = [self objectAtIndexPath:indexPath];
    return [self tableView: tableView cellForRowAtIndexPath:indexPath object:[self objectAtIndexPath:indexPath]];
}


- (PhotoponTableViewCell *)tableViewNextPageCell:(UITableView *)tableView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *identifier = @"PhotoponQueryTableNextPageCell";
    PhotoponQueryTableNextPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhotoponQueryTableNextPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%i more ...", nil), self.objectsPerPage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
        PhotoponQueryTableNextPageCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        [self loadNextPageWithNextPageCell:cell];
    }
    else {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath object:[self.objects objectAtIndex:indexPath.row]];
    }
    */
    
    
    if ([self isSearchResultsTableView:tableView]) {
        
        [self tableView:tableView didSelectRowAtIndexPath:indexPath object:[self.objects objectAtIndex:indexPath.row]];

        //[self performSegueWithIdentifier: @"showRecipeDetail" sender: self];
    }


}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(PhotoponUITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
        PhotoponQueryTableNextPageCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        [self loadNextPageWithNextPageCell:cell];
    }
 
}
* /

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
        //PhotoponQueryTableNextPageCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        //cell = (PhotoponQueryTableNextPageCell*)cell;
        //[(PhotoponQueryTableNextPageCell*)cell.activityAccessoryView startAnimating];
        //if ( self.hasMore){
            //[self loadNextPageWithNextPageCell:cell];
        //}else{
            //[cell.activityAccessoryView startAnimating];
            //cell.textLabel.text = @"All Items Loaded";
        //}
        [self loadNextPageWithNextPageCell:(PhotoponQueryTableNextPageCell*)cell];
        return;
    }
    [self tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath withObject:[self objectAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self configureCell:cell atIndexPath:indexPath withObject:object];
    
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.row == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
        return;
    }
    //PhotoponNestedDetailViewController *photoponNestedDetailViewController = [[PhotoponNestedDetailViewController alloc] initWithNibName:@"PhotoponNestedDetailViewController" bundle:nil];
    
    PhotoponNestedDetailViewController *photoponNestedDetailViewController = [[PhotoponNestedDetailViewController alloc] initWithRootObject:(NSDictionary*)object];
    //[self.navigationController pushViewController:photoponNestedDetailViewController animated:YES];
    [self.navigationController pushPhotoponViewController:photoponNestedDetailViewController];
}

#pragma mark UISearchBarDelegate & Overlay

- (void)dismissOverlay:(UIButton *)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.searchBar resignFirstResponder];
    
    [self cancelAsyncSearchTimerIfNecessary];
    
    //[sender removeFromSuperview];
    
    [self reloadWithSearchTextInBackground];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.searchBar resignFirstResponder];
    
    [self cancelAsyncSearchTimerIfNecessary];
    
    //if (self.searchOverlayContainer.window)
        //[self.searchOverlayContainer removeFromSuperview];
    
    
    [self reloadWithSearchTextInBackground];
    
    //[self reloadInBackgroundIfSearchTextChanged];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self.searchBar.delegate = (id)self;
    
    //[aSearchBar endEditing:YES];
    
    //self.searchBar = aSearchBar;
    
    
    self.searchBar.delegate = self;
    
    self.searchDisplayController.delegate = self;
    
    self.searchDisplayController.searchBar.delegate = self;
    
    [self.searchBar.inputAccessoryView becomeFirstResponder];
    
    
    [self.searchBar endEditing:YES];
    
    //[self.searchDisplayController.searchBar resignFirstResponder];
    
    //[aSearchBar becomeFirstResponder];
    
    [self.searchBar resignFirstResponder];
    
    
    //[self.searchBar resignFirstResponder];
    
    [self cancelAsyncSearchTimerIfNecessary];
    
    //if (self.searchOverlayContainer.window)
        //[self.searchOverlayContainer removeFromSuperview];
    
    
    
    [self removeSearchOverlay];
    
    [self.searchBar resignFirstResponder];
    
    
    //if (self.noResultsView.window)
        //[self.noResultsView removeFromSuperview];
    
    //[self reloadWithSearchTextInBackground];
    
    //[self reloadInBackgroundIfSearchTextChanged];
    
    
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //[aSearchBar setShowsScopeBar:YES];
    //[aSearchBar sizeToFit];
    
    [self addSearchOverlayForSearchBar:aSearchBar];
    
}

- (void) addSearchOverlayForSearchBar:(UISearchBar *)aSearchBar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGRect bounds = self.tableView.bounds;
    CGRect barBounds = aSearchBar.bounds;
    
    CGRect overlayFrame = CGRectMake(CGRectGetMinX(bounds),
                                     CGRectGetMaxY(barBounds),
                                     CGRectGetWidth(barBounds),
                                     CGRectGetHeight(bounds));// - CGRectGetHeight(barBounds));
    
    searchOverlayContainer.frame = overlayFrame;
    
    self.searchOverlay.frame = CGRectMake(0.0f, 0.0f, 320.0f, self.searchOverlayContainer.frame.size.height);
    
    [self.searchOverlayContainer addSubview:self.searchOverlay];
    
    [self.tableView addSubview:self.searchOverlayContainer];
}

- (void) removeSearchOverlay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.searchOverlayContainer.window)
        [self.searchOverlayContainer removeFromSuperview];
    
    //if (self.noResultsView.window)
        //[self.noResultsView removeFromSuperview];
    
    
    
    /*
     CGRect bounds = self.tableView.bounds;
     CGRect barBounds = aSearchBar.bounds;
     
     CGRect overlayFrame = CGRectMake(CGRectGetMinX(bounds),
     CGRectGetMaxY(barBounds),
     CGRectGetWidth(barBounds),
     CGRectGetHeight(bounds) - CGRectGetHeight(barBounds));
     
     self.searchOverlay.frame = overlayFrame;
     [self.tableView addSubview:self.searchOverlay];
     */
}


- (void) addSearchOverlayContainerForSearchBar:(UISearchBar *)aSearchBar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}


- (void) removeSearchOverlayContainer{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.searchOverlayContainer.window)
        [self.searchOverlayContainer removeFromSuperview];
    
    if (self.noResultsView.window)
        [self.noResultsView removeFromSuperview];
    
    
    
    /*
    CGRect bounds = self.tableView.bounds;
    CGRect barBounds = aSearchBar.bounds;
    
    CGRect overlayFrame = CGRectMake(CGRectGetMinX(bounds),
                                     CGRectGetMaxY(barBounds),
                                     CGRectGetWidth(barBounds),
                                     CGRectGetHeight(bounds) - CGRectGetHeight(barBounds));
    
    self.searchOverlay.frame = overlayFrame;
    [self.tableView addSubview:self.searchOverlay];
     */
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)aSearchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    /* Hide the search bar until user scrolls up
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + aSearchBar.bounds.size.height;
    [[self tableView] setBounds:newBounds];
    */
    
    
    
    //aSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Button",@"Titles",@"Go",@"Here",nil];
    
    aSearchBar.showsScopeBar = YES;
    
    [aSearchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.searchHeader.frame = SEARCH_HEADER_FRAME_ACTIVE;
    
    self.searchHeader.bounds = SEARCH_HEADER_BOUNDS_ACTIVE; //CGRectMake(0.0f, 0.0f, self.searchBar.frame.size.width, self.searchBar.frame.size.height + self.searchBar.scopeBarBackgroundImage.size.height);
    
    
    
    
    
    //[self.searchHeader setFrame:CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchBar.frame.size.width, self.searchBar.frame.size.height + self.searchBar.scopeBarBackgroundImage.size.height)];
    
    //self.searchHeader.bounds =CGRectMake(0.0f, 0.0f, self.searchBar.frame.size.width, self.searchBar.frame.size.height + self.searchBar.scopeBarBackgroundImage.size.height);
    
    
    
    //self.searchHeader.bounds = CGRectMake(self.searchBar.bounds.origin.x, self.searchBar.bounds.origin.y, self.searchBar.bounds.size.width, self.searchBar.bounds.size.height + self.searchBar.scopeBarBackgroundImage.size.height);
    
    //[self.searchHeader setBounds: CGRectMake(0.0f, -20.0f, self.searchHeader.bounds.size.width, 88.0f)];
    
    
    [aSearchBar sizeToFit];
    
    //self.searchHeader.bounds =CGRectMake(0.0f, 0.0f, self.searchBar.frame.size.width, self.searchBar.frame.size.height + self.searchBar.scopeBarBackgroundImage.size.height);
    
    
    //self.tableView.contentOffset = CGPointMake(0, 44);
    
    return YES;
    
    
    
    
    
    /*
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [aSearchBar setShowsCancelButton:YES animated:YES];
    aSearchBar.showsScopeBar = YES;
    
    //[aSearchBar sizeToFit];
    
    return YES;*/
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)aSearchBar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isLoading)
        return NO;
    
    //self.tableView.contentOffset = CGPointMake(0, 0);
    
    //[self.searchHeader setBounds: CGRectMake(0.0f, 0.0f, self.searchHeader.bounds.size.width, 44.0f)];
    
    
    [aSearchBar setShowsCancelButton:NO animated:YES];
    searchBar.showsScopeBar = NO;
    
    
    
    self.searchHeader = [[UIView alloc] initWithFrame:SEARCH_HEADER_FRAME_ACTIVE];
    
    [self.searchHeader setBounds: SEARCH_HEADER_BOUNDS_DRFAULT];
    
    
    
    
    
    //[self.searchHeader setBounds: self.searchBar.bounds];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [searchBar sizeToFit];
    
    
    
    
    /*
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + aSearchBar.bounds.size.height;
    [self.tableView.tableHeaderView setBounds:newBounds];
    */
    
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)someSearchText {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    //[self.searchObjects removeAllObjects];
    
    [self configureNewSearchWithText:someSearchText searchScope:nil];
    
    if (self.searchBar.text.length==0)
        [self.noResultsView removeFromSuperview];
        
    
    
}

- (void) cancelAsyncSearchTimerIfNecessary{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.asyncSearchTypingTimer)
        [self.asyncSearchTypingTimer invalidate];
    
}

- (void)configureNewSearchWithText:(NSString*)text searchScope:(NSString*)scope {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self cancelAsyncSearchTimerIfNecessary];
    
    [self configureNoSearchResultsView];
    
    NSMutableDictionary *timerUserInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"currentUserID", [PhotoponUserModel currentUser].identifier, nil];
    
    self.asyncSearchTypingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(handleSearchWithTextInBackground) userInfo:timerUserInfo repeats:NO];
    
    
    
    if ((scope!=nil) && (scope.length>0))
        [self.methodParams setObject:scope forKey:kPhotoponMethodSearchScopeKey];
    
    
    [self.methodParams setObject:text forKey:kPhotoponMethodSearchTextKey];
    //self.searchTextChanged = YES;
    
    
    //[self loadObjects];
    
    //[self reloadInBackgroundIfSearchTextChanged];
    
}

- (void)handleSearchWithTextInBackground {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self reloadWithSearchTextInBackground];
}

- (void)reloadWithSearchTextInBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self.isLoading = YES;
    
    // interferes with searchbar button action handling
    //self.tableView.userInteractionEnabled = NO;
    
    // make sure delegates are still set
    self.searchBar.delegate = self;
    self.searchDisplayController.delegate = self;
    __weak __typeof(&*self)weakSelf = self;
    // Post process results
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    dispatch_async(_searchQueue, ^{
        
    //NSString *queryText = self.searchBar.text;
    
    NSArray *params = [[NSArray alloc] initWithArray:[self paramsForSearchTable]];
    
    NSMutableDictionary *config;
    
    // Form search query for text if possible
    if ([weakSelf hasSearchBar] && weakSelf.methodSearchText.length > 0) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([self hasSearchBar] && queryText.length > 0) {       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        params = [[NSArray alloc] initWithArray:[self paramsForSearchTable]];
        
        config = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                  weakSelf.methodNameSearch, kPhotoponMethodNameKey,
                  params, kPhotoponMethodParamsKey, nil];
        
        //self.tableView.userInteractionEnabled = YES;
        //__weak __typeof(&*self)weakSelf = self;
        [weakSelf.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSError *error = nil;
            
            //NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            NSMutableDictionary *returnData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        [[NSArray alloc] initWithArray:[weakSelf fakeUserResults]], weakSelf.methodReturnedModelsKey,
                                        nil];
            
            // make sure delegates are still set
            weakSelf.searchBar.delegate = weakSelf;
            weakSelf.searchDisplayController.delegate = weakSelf;
            
            
            
            dispatch_async(q, ^{
                
                [weakSelf processSearchQueryResults:(NSArray*)[returnData objectForKey:weakSelf.methodReturnedModelsKey] error:error callback:^(NSError *error){
                    
                }];
                
            });
            
            
            
        }failure:^(NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncSearchTextWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSArray *emptyArray = [[NSArray alloc] init];
            
            [weakSelf processQueryResults:emptyArray error:error callback:^(NSError *error){
                
            }];
            
        }];
        
    }
        
    });
    
}

- (void)configureNoResultsView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![self isViewLoaded]) return;
    
    NSLog(@"configureNoResultsView 1");
    
    [self.noResultsView removeFromSuperview];
    
    if (self.objects && [self.objects count] == 0 && !self.isLoading) {
        // Show no results view.
        
        NSLog(@"configureNoResultsView 2");
        
        NSString *ttl = NSLocalizedString(@"No %@ yet", @"A string format. The '%@' will be replaced by the relevant type of object, posts, pages or comments.");
        
        ttl = [NSString stringWithFormat:ttl, @"items"];
        
        NSString *msg = @"";
        //if ([self userCanCreateEntity]) {
            //msg = NSLocalizedString(@"Why not create one?", @"A call to action to create a post or page.");
        //}
        
        
        
        self.noResultsView = [PhotoponInfoView PhotoponInfoViewWithTitle:ttl
                                                     message:msg
                                                cancelButton:nil];
        
        
        
        [self.tableView addSubview:self.noResultsView];
    }
     
}

- (void)configureNoSearchResultsView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![self isViewLoaded]) return;
    
    if (self.searchObjects && [self.searchObjects count] == 0 && !self.isLoading) {
        
        [self.noResultsView removeFromSuperview];
        
        
        
        
        
        // Show no results view.
        NSString *ttl = [[NSString alloc] initWithFormat:@"No Results"];
        self.noResultsView = [PhotoponInfoView PhotoponInfoViewWithTitle:ttl
                                                                 message:nil
                                                            cancelButton:nil];
        
        
        //CGRect bounds = self.tableView.bounds;
        //CGRect barBounds = self.searchBar.bounds;
        
        /*CGRect overlayFrame = CGRectMake(CGRectGetMinX(bounds),
                                         CGRectGetMaxY(barBounds),
                                         CGRectGetWidth(barBounds),
                                         CGRectGetHeight(bounds) - CGRectGetHeight(barBounds));
        * /
        
        self.noResultsView.frame = CGRectMake(0.0f, self.searchOverlayContainer.frame.origin.y-100.0f, self.searchOverlayContainer.frame.size.width, self.searchOverlayContainer.frame.size.height);//self.searchOverlay.bounds;
        
        [self.noResultsView setBounds:CGRectMake(0.0f, -100.0f, self.searchOverlayContainer.frame.size.width, self.searchOverlayContainer.frame.size.height)];
        */
        
        [self.searchOverlayContainer addSubview:self.noResultsView];
        
        self.noResultsView.frame = CGRectMake(0.0f, self.searchOverlayContainer.frame.origin.y-88.0f, self.searchOverlayContainer.frame.size.width, self.searchOverlayContainer.frame.size.height);//self.searchOverlay.bounds;
        
        [self.noResultsView setBounds:CGRectMake(0.0f, -88.0f, self.searchOverlayContainer.frame.size.width, self.searchOverlayContainer.frame.size.height)];
        
        
        //[self.searchOverlayContainer addSubview:self.noResultsView];
    }
    
}

- (void)tableView:(UITableView*)tableView configureNoResultsCell:(UITableViewCell*)noResultsCell {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    /*
    if (![self isViewLoaded]) return;
    
    [self.noResultsView removeFromSuperview];
    
    if (self.objects && [self.objects count] == 0 && !self.isLoading) {
        // Show no results view.
        
        NSString *ttl = NSLocalizedString(@"No %@ yet", @"A string format. The '%@' will be replaced by the relevant type of object, posts, pages or comments.");
        ttl = [NSString stringWithFormat:ttl, [[self entityName] lowercaseString]];
        
        NSString *msg = @"";
        //if ([self userCanCreateEntity]) {
        msg = NSLocalizedString(@"Why not create one?", @"A call to action to create a post or page.");
        //}
        
        self.noResultsView = [PhotoponInfoView PhotoponInfoViewWithTitle:ttl
                                                                 message:msg
                                                            cancelButton:nil];
        
        [self.tableView addSubview:self.noResultsView];
    }*/
    
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)aSearchText scope:(NSString*)scope
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	
    
    
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    
    
    
    //[self.searchObjects removeAllObjects];
    
    [self configureNewSearchWithText:aSearchText searchScope:scope];
    
    
    
    /*
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [self.objects filteredArrayUsingPredicate:predicate];
    
    if(![scope isEqualToString:@"All"]) {
        // Further filter the array with the scope
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    
    self.searchObjects = [NSMutableArray arrayWithArray:tempArray];*/
    
    
}


#pragma mark - UISearchDisplayController Delegate Methods



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
/*
- (BOOL) searchDisplayController: (UISearchDisplayController *) controller
shouldReloadTableForSearchString: (NSString *) filter
{
    // we'll key off the _currentFilter to know if the search should proceed
    @synchronized (self)
    {
        _currentFilter = [filter copy];
    }
    
    dispatch_async( _searchQueue, ^{
        
        NSDate* start = [NSDate date];
        
        // quit before we even begin?
        if ( ![self isCurrentFilter: filter] )
            return;
        
        // we're going to search, so show the indicator (may already be showing)
        [_activityIndicatorView performSelectorOnMainThread: @selector( startAnimating )
                                                 withObject: nil
                                              waitUntilDone: NO];
        
        NSMutableArray* filteredWords = [NSMutableArray arrayWithCapacity: _allWords.count];
        
        // only using a NSPredicate here because of the SO question...
        NSPredicate* p = [NSPredicate predicateWithFormat: @"SELF CONTAINS[cd] %@", filter];
        
        // this is a slow search... scan every word using the predicate!
        [_allWords enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            
            // check if we need to bail every so often:
            if ( idx % 100 == 0 )
            {
                *stop = ![self isCurrentFilter: filter];
                if (*stop)
                {
                    NSTimeInterval ti = [start timeIntervalSinceNow];
                    NSLog( @"interrupted search after %.4lf seconds", -ti);
                    return;
                }
            }
            
            // check for a match
            if ( [p evaluateWithObject: obj] )
            {
                [filteredWords addObject: obj];
            }
        }];
        
        // all done - if we're still current then update the UI
        if ( [self isCurrentFilter: filter] )
        {
            NSTimeInterval ti = [start timeIntervalSinceNow];
            NSLog( @"completed search in %.4lf seconds.", -ti);
            
            dispatch_sync( dispatch_get_main_queue(), ^{
                
                _filteredWords = filteredWords;
                [controller.searchResultsTableView reloadData];
                [_activityIndicatorView stopAnimating];
            });
        }
    });
    
    return FALSE;
}
*/

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self addSearchOverlayForSearchBar:controller.searchBar];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self removeSearchOverlay];
    
    
    
    [tableView setBackgroundColor:TABLE_VIEW_BACKGROUND_COLOR];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
}







#pragma mark - TextView delegate

/*
 This needs to be defined so we can set isEditing before keyboardWillShow is called, or the textView doesn't get positioned
 The calling order is:
 * textViewShouldBeginEditing:
 * keyboardWillShow:
 * textViewDidBeginEditing:
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)aTextView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self incrementCharactersChangedForAutosaveBy:MAX(range.length, text.length)];
    return YES;
}

- (void)textViewDidChange:(UITextView *)aTextView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //_hasChangesToAutosave = YES;
    //[self autosaveContent];
    
    //[self refreshButtons];
    
    
    //[textViewPlaceHolderField removeFromSuperview];
    
    /*
    NSError *error = nil;
    NSRegularExpression *hashtagRegex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
    NSArray *hashtagMatches = [hashtagRegex matchesInString:aTextView.text options:0 range:NSMakeRange(0, aTextView.text.length)];
    for (NSTextCheckingResult *hashtagMatch in hashtagMatches) {
        NSRange hashtagWordRange = [hashtagMatch rangeAtIndex:1];
        NSString* hashtagWord = [aTextView.text substringWithRange:hashtagWordRange];
        
        [self configureNewSearchWithText:hashtagWord searchScope:kPhotoponSearchScopeHashtags];
        
        NSLog(@"Found tag %@", hashtagWord);
    }
    
    return;
    
    NSRegularExpression *peopleRegex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    NSArray *peopleMatches = [peopleRegex matchesInString:aTextView.text options:0 range:NSMakeRange(0, aTextView.text.length)];
    for (NSTextCheckingResult *peopleMatch in peopleMatches) {
        NSRange peopleWordRange = [peopleMatch rangeAtIndex:1];
        NSString* peopleWord = [aTextView.text substringWithRange:peopleWordRange];
        
        [self configureNewSearchWithText:peopleWord searchScope:kPhotoponSearchScopeHashtags];
        
        NSLog(@"Found tag %@", peopleWord);
    }*/
}

- (void)textViewDidEndEditing:(UITextView *)aTextView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    
    /*
     if([aTextView.text isEqualToString:@""]) {
     //[aTextView addSubview:textViewPlaceHolderField];
     }
     
     
     isEditing = NO;
     _hasChangesToAutosave = YES;
     [self autosaveContent];
     [self autosaveRemote];
     
     [self refreshButtons];
     */
}




#pragma mark - HUD methods

- (void) initHUD {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:appDelegate.navController.view];
	[appDelegate.navController.view addSubview:HUD];
	HUD.delegate = (id)self;
    HUD.labelText = @"Logging In";
	//HUD.minSize = CGSizeMake(140.f, 115.f);
    
}

- (void) showHUD {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [HUD show:YES];
}

- (void) showHUDWithStatusText:(NSString*)status {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!status || status.length==0) {
        status = @"Loading";
    }
    HUD.labelText = status;
	
    HUD.removeFromSuperViewOnHide = NO;
    
    [self showHUD];
    
}

- (void) showHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (!status || status.length==0) {
        status = @"Loading";
    }
    HUD.mode = mode;
    HUD.labelText = status;
	HUD.removeFromSuperViewOnHide = NO;
    
    [self showHUD];
    
}

-(void) hideHud{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [HUD hide:YES];
}

-(void) hideHudAfterDelay:(float)delay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [HUD hide:YES afterDelay:delay];
}

- (void) updateHUDWithStatusText:(NSString*)status{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //sleep(2);
    
    
    
    if ([status isEqualToString:@"Complete"]) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"You're Logged In!";
        [HUD hide:YES afterDelay:1.0];
    }else{
        // Switch to determinate mode
        //HUD.mode = MBProgressHUDModeDeterminate;
        
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = status;
        //sleep(2);
    }
}

- (void) updateHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //sleep(2);
    
    HUD.mode = mode;
    
    if ([status isEqualToString:@"Complete"]) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"You're Logged In!";
        [HUD hide:YES afterDelay:1.0];
    }else{
        // Switch to determinate mode
        //HUD.mode = MBProgressHUDModeDeterminate;
        
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = status;
        //sleep(2);
    }
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}



//
/**
 ----------------------------------------------------
 Save this feature for future update down road
 ----------------------------------------------------
 ****************************************************
 
#pragma mark - The Magic!

-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    [appDelegate.tabBarController setTabBarHidden:YES
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

-(void)contract
{
    if(!hidden)
        return;
    
    hidden = NO;
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    [appDelegate.tabBarController setTabBarHidden:NO
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}
*/



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    //NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //[self contract];
    return YES;
}

- (NSMutableArray *)paramsForSearchTable{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
                               [self.methodParams objectForKey:kPhotoponMethodSearchTextKey],
                               nil];
    
    return params;
}

#define AssertSubclassMethod() NSAssert(false, @"You must override %@ in a subclass", NSStringFromSelector(_cmd))
#define AssertNoBlogSubclassMethod() NSAssert(self.blog, @"You must override %@ in a subclass if there is no blog", NSStringFromSelector(_cmd))

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreturn-type"

- (NSMutableArray *)paramsForTable{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Params:
    //  1). UserID      - so we know whos gallery to load
    //  2). MaxObjects  - so we don't receive more than
    //NSArray *params = [NSArray arrayWithObjects:self.pmm.currentUser.identifier, [NSNumber numberWithInt:self.currentOffset], nil];
    
    // temp fix until brian uploads updated php server file
    //NSArray *params =  [NSArray arrayWithObjects:self.pmm.currentUser.identifier, [NSNumber numberWithInt:self.currentOffset+self.objectsPerPage], nil];
    
    AssertSubclassMethod();
}

- (NSDate *)lastSyncDate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.methodParams objectForKey:kPhotoponLastSyncDate];// self.lastSync;
    
    //AssertSubclassMethod();
}

- (NSString*) cellIdentifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //static NSString *cellReuseID = @"CustomTableCell";
    //return cellReuseID;
    
    AssertSubclassMethod();
    
}

- (NSString*) cellNibName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //static NSString *cellNib = @"CustomTableViewCell";
    //return cellNib;
    
    AssertSubclassMethod();
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}

- (void)configureSearchCell:(PhotoponSearchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Defaults to people and hashtags
    //cell = (PhotoponSearchTableViewCell*)cell;
    
    cell.photoponBtnResultCellImage.tag = indexPath.row;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPHONE) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}


// SEARCHBAR

- (void) configureSearchBarForTableType:(PhotoponSearchTableType)type{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

//- (void)setPhotoponSearchCell:(UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state;

- (void)setImage:(UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (icon) {
        case UISearchBarIconBookmark:
            iconImage = [UIImage imageNamed:@"PhotoponSearchBarIconClear.png"];
            break;
        case UISearchBarIconClear:
            iconImage = [UIImage imageNamed:@"PhotoponSearchBarIconClear.png"];
            break;
        case UISearchBarIconResultsList:
            iconImage = [UIImage imageNamed:@"PhotoponSearchBarIconClear.png"];
            break;
        case UISearchBarIconSearch:
            iconImage = [UIImage imageNamed:@"PhotoponSearchBarIconSearch.png"];
            break;
        default:
            break;
    }
    
}








- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    if ([string isEqualToString:@"#"]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //if we only try and resignFirstResponder on textField or searchBar,
    //the keyboard will not dissapear (at least not on iPad)!
    //[self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.searchBar afterDelay: 0.1];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //if (textField.tag == 1) {
        //UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        //[passwordTextField becomeFirstResponder];
    //}
    //else {
        //[textField resignFirstResponder];
    //}
    return YES;
}


#pragma PhotoponMediaCaptionCellDelegate Methods

/*!
 Sent to the delegate when the hashtag is tapped
 @param text - the hashtag associated with this action
 */
- (void)photoponMediaCaptionCell:(PhotoponMediaCaptionCell *)photoponMediaCaptionCell didTapHashtagText:(NSString *)hashtagText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableDictionary *hashtagDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 kPhotoponHashtagClassName, kPhotoponEntityNameKey,
                                 @"null", kPhotoponModelIdentifierKey,
                                 nil];
    
    PhotoponTimelineViewController *photoponTimelineViewController = [[PhotoponTimelineViewController alloc] initWithRootObject:hashtagDict];
    
    [photoponTimelineViewController.methodParams setObject:kPhotoponAPIMethodGetMyGallery forKey:kPhotoponMethodNameKey];
    
    [photoponTimelineViewController.methodParams setObject:hashtagText forKey:kPhotoponMethodFilterKey];
    
    [photoponTimelineViewController initTitleLabelWithText:hashtagText];

    //[self.navigationController pushViewController:photoponTimelineViewController animated:YES];
    [self.navigationController pushPhotoponViewController:photoponTimelineViewController];
}

/*!
 Sent to the delegate when the hashtag is tapped
 @param mentionText - the mentioned username text associated with this action
 */
- (void)photoponMediaCaptionCell:(PhotoponMediaCaptionCell *)photoponMediaCaptionCell didTapMentionText:(NSString *)mentionText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableDictionary *hashtagDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 kPhotoponMentionClassName, kPhotoponEntityNameKey,
                                 nil];
    
    PhotoponAccountProfileViewController *photoponAccountProfileViewController = [[PhotoponAccountProfileViewController alloc] initWithRootObject:hashtagDict];
    
    [photoponAccountProfileViewController.methodParams setObject:kPhotoponAPIMethodGetProfileInfo forKey:kPhotoponMethodNameKey];
    
    [photoponAccountProfileViewController.methodParams setObject:mentionText forKey:kPhotoponMethodFilterKey];
    
    [photoponAccountProfileViewController initTitleLabelWithText:mentionText];
    
    //[self.navigationController pushViewController:photoponAccountProfileViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:photoponAccountProfileViewController];
}

/*!
 Sent to the delegate when the hashtag is tapped
 @param linkText - the http link (url string) associated with this action
 */
- (void)photoponMediaCaptionCell:(PhotoponMediaCaptionCell *)photoponMediaCaptionCell didTapLinkText:(NSString *)linkText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // web vc here
    
}



@end



@implementation PhotoponQueryTableNextPageCell
//DKSynthesize(activityAccessoryView)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIActivityIndicatorView *accessoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        accessoryView.hidesWhenStopped = YES;
        
        self.activityAccessoryView = accessoryView;
        
        [self.contentView addSubview:self.activityAccessoryView];
        
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return self;
}

- (void)layoutSubviews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    
    // Center text label
    UIFont *font = self.textLabel.font;
    NSString *text = self.textLabel.text;
    
    CGRect bounds = self.bounds;
    CGSize textSize = [text sizeWithFont:font
                                forWidth:CGRectGetWidth(bounds)
                           lineBreakMode:UILineBreakModeTailTruncation];
    CGSize spinnerSize = self.activityAccessoryView.frame.size;
    CGFloat padding = 10.0;
    
    BOOL isAnimating = self.activityAccessoryView.isAnimating;
    
    CGRect textFrame = CGRectMake((CGRectGetWidth(bounds) - textSize.width - (isAnimating ? spinnerSize.width - padding : 0)) / 2.0,
                                  (CGRectGetHeight(bounds) - textSize.height) / 2.0,
                                  textSize.width,
                                  textSize.height);
    
    self.textLabel.frame = CGRectIntegral(textFrame);
    
    if (isAnimating) {
        CGRect spinnerFrame = CGRectMake(CGRectGetMaxX(textFrame) + padding,
                                         (CGRectGetHeight(bounds) - spinnerSize.height) / 2.0,
                                         spinnerSize.width,
                                         spinnerSize.height);
        
        self.activityAccessoryView.frame = spinnerFrame;
    }
}


#pragma mark - Subclass methods

- (BOOL)userCanCreateEntity {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	return NO;
}





@end
