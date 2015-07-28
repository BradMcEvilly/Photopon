//
//  PhotoponQueryPageViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 8/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponQueryPageViewController.h"
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
#import "PhotoponTimelineViewController.h"
#import "PhotoponAccountProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ResizeAdditions.h"
#import "PhotoponTabBarController.h"
//#import "UITabBarController+hidable.h"
#import "PhotoponFeaturedUsersViewController.h"
#import "Photopon8CouponsModel.h"
#import "PhotoponOfferActivityPageViewController.h"
#import "StyledPageControl.h"

static CGFloat const kMaxAngle = 0.1;
static CGFloat const kMaxOffset = 20;

NSTimeInterval const PhotoponTableViewControllerRefreshTimeout = 300; // 5 minutes

@interface PhotoponQueryPageViewController () <MBProgressHUDDelegate> {
    
}

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSUInteger currentOffset;
//@property (nonatomic, strong, readwrite) NSMutableArray *objects;
@property (nonatomic, strong) NSMutableArray * orSkip;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIView *noResultsView;

- (void)configureNoResultsView;

@end

@implementation PhotoponQueryPageViewController{
    
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
    dispatch_queue_t    _workQueue;

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
@synthesize lastSync;
//@synthesize photoponPagesContainerView;
//@synthesize photoponPagesScrollView;
//@synthesize photoponActivityPagesScrollView;
//@synthesize photoponPageControl;
//@synthesize photoponActivityPageControl;
@synthesize controllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityName:(NSString*)entityName
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        self.methodParams = [[NSMutableDictionary alloc] init];
        
        self.objectsPerPage = 40;
        [self updateCurrentOffset:0];
        
        hidden = NO;
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [self.methodParams setObject:[[NSString alloc] initWithString: entityName] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // redundant - now handled by updateCurrentOffset method
        //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedCouponModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        
        self.objects = [NSMutableArray new];
        
        //self.controllers = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithCoder:aDecoder entityName:kPhotoponCouponClassName];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder entityName:(NSString*)entityName
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        self.methodParams = [[NSMutableDictionary alloc] init];
        
        self.objectsPerPage = 40;
        [self updateCurrentOffset:0];
        
        hidden = NO;
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.methodParams setObject:[[NSString alloc] initWithString: entityName] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // redundant - now handled by updateCurrentOffset method
        //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedCouponModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        
        self.objects = [NSMutableArray new];
        
        //self.controllers = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
    }
    return self;
}


-(void)dealloc{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.objects = nil;
    self.HUD = nil;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
}

-(NSString*)identifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.methodParams objectForKey:kPhotoponModelIdentifierKey];
}

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
        
        angle = [PhotoponQueryPageViewController randomFloatBetween:-kMaxAngle andMax:kMaxAngle];
        offsetX = (NSInteger)[PhotoponQueryPageViewController randomFloatBetween:-kMaxOffset andMax:kMaxOffset];
        offsetY = (NSInteger)[PhotoponQueryPageViewController randomFloatBetween:-kMaxOffset andMax:kMaxOffset];
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
 * /
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
    
}*/


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

- (void)viewDidLoad{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    [self setUpEmptyPageViewControllers];
    
    
    [self.photoponPagesScrollView setBackgroundColor:[UIColor clearColor]]; //colorWithRed:211.0f green:214.0f blue:219.0f alpha:1.0f]];
    
    [self.photoponActivityPagesScrollView setBackgroundColor:[UIColor clearColor]];
    
    [self initHUD];
    
    //[self configureNoResultsView];
    
    
}

- (void)viewDidUnload {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidUnload];
    
    //self.refreshHeaderView = nil;
    
    
}

/*
- (void)setUpPhotoponObjects{
    
    
    [self reloadInBackground];
    
    NSLog(@"Total number of rows = %d ", [self.objects count]);
    
    / *
    if (rootObject) {
        
        UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateNormal];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateHighlighted];
        [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateSelected];
        [signOutButton setFrame:CGRectMake( 0.0f, 0.0f, 39.0f, 30.0f)];
        [signOutButton addTarget:self action:@selector(backButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:signOutButton];
        
    }* /
    
}
*/

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
    
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:hidden animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    
    //[self reloadInBackground];
    
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

- (void) backButtonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
    
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


- (NSDictionary*)dictionaryAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.objects objectAtIndex:indexPath.row];
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
    
    if (self.objects==0)
        [self configureNoResultsView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (IBAction)photoponToolBarBtnRefresh:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDate *lastSynced = [self lastSyncDate];
    if (lastSynced == nil || ABS([lastSynced timeIntervalSinceNow]) > PhotoponTableViewControllerRefreshTimeout) {
        [self loadObjects];
        
        // spoofponView
        [noResultsView removeFromSuperview];
        didTriggerRefresh = YES;
    }
}

//  PhotoponQueryTableViewController implementation (modified)
//
//  PhotoponQueryTableViewController.m
//  PhotoponModelManager
//

- (id)initWithRootObject:(NSDictionary*)_rootObject {
    
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

- (id)initWithStyle:(UITableViewStyle)style rootObject:(NSDictionary *)_rootObject{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        
        //self.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = NO;
        
        self.rootObject = _rootObject;
        
        self.objectsPerPage = 16;
        [self updateCurrentOffset:0];
        
        self.methodParams = [[NSMutableDictionary alloc] init];
        [self.methodParams setObject:[rootObject objectForKey:kPhotoponEntityNameKey] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[rootObject objectForKey:kPhotoponModelIdentifierKey] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        //[self.methodParams setObject:[NSNumber numberWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        hidden = NO;
        
        // set defaults
        [self.methodParams setObject:kPhotoponAPIReturnedCouponModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        
        self.objects = [NSMutableArray new];
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
    
    self = [super init];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        self.methodParams = [[NSMutableDictionary alloc] init];
        
        self.objectsPerPage = 16;
        [self updateCurrentOffset:0];
        
        hidden = NO;
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [self.methodParams setObject:[[NSString alloc] initWithString: entityName] forKey:kPhotoponEntityNameKey];
        
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        
        // redundant - now handled by updateCurrentOffset method
        //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedCouponModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        
        self.objects = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
        
    }
    NSLog(@"PhotoponQueryTableViewController initWithStyle       4");
    
    return self;
}

- (void)processQueryResults:(NSArray *)results error:(NSError *)error callback:(void (^)(NSError *error))callback {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"query results not processed on main queue");
    
    
    
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Offers Found!", nil)
     message:[NSString stringWithFormat:@"Count: %i", results.count]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
     [alert show];
     */
    
    
    
    //self.photoponPagesScrollView = [[FireUIPagedScrollView alloc] initWithFrame:pagesScrollViewFrame];
    
    
    //self.photoponPagesScrollView.pageControl = self.photoponPageControl;
    
    
    
    if (results.count > 0) {
        
		[self.objects addObjectsFromArray:results];
    
    }
    else{
        
        // no coupons alert
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOffersViewControllerDidFindNoCoupons object:nil];
        
    }
    
    
    //}
    
    [self swapPaginationScrollViews];
    [self setUpPageViewControllers];
    
    
    
    //[self updateCurrentOffset:self.currentOffset+results.count];
    [self updateCurrentOffset:self.currentOffset+results.count];
    
    self.hasMore = (results.count == self.objectsPerPage);
    self.isLoading = NO;
    
    [SoundUtil playRollupSound];
    
    didTriggerRefresh = NO;
    
    
    if (error != nil) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
    }
    
    
    
    __weak __typeof(&*self)weakSelf = self;
    
    // Post process results
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [weakSelf postProcessResults];
        
        dispatch_async(q, ^{
            
            [weakSelf objectsWillLoad];
            
            [weakSelf maximizeRootPaginationScrollViewAlpha];
            
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
    
    NSArray *params = [[NSArray alloc] initWithArray:[self paramsForTable]];
    
    NSDictionary *config = [[NSDictionary alloc] initWithObjectsAndKeys:
              self.methodName, kPhotoponMethodNameKey,
              params, kPhotoponMethodParamsKey, nil];
    
    
    if([[self entityName] isEqualToString:kPhotoponCouponClassName]){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if(self.entityName == kPhotoponCouponClassName){    ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            
            
            
            //dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
            //dispatch_async(q, ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidReceiveLocalOffers object:nil userInfo:nil];
                
                NSError *error = nil;
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
                
            
            //});
                
                
                
                
                
                
            //[self.photoponActivityPagesScrollView setUserInteractionEnabled:NO];
            
            // notify HUDS inside activity scroll view pages
            
            
        }failure:^(NSError *error){
            
            
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.pmm syncOffersWithConfig:config success:^(NSArray *responseInfo){       FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            NSArray *emptyArray = [[NSArray alloc] init];
            [self processQueryResults:emptyArray error:error callback:callback];
            
            
        }];
    }
    
    
}

- (void)maximizeRootPaginationScrollViewAlpha{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponPagesScrollView.userInteractionEnabled = YES;
    
    [self.photoponPagesScrollView setAlpha:1.0f];
    [self.photoponPageControl setAlpha:1.0f];
}

- (void)minimizeRootPaginationScrollViewAlpha{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponPagesScrollView.userInteractionEnabled = NO;
    
    [self.photoponPagesScrollView setAlpha:0.0f];
    [self.photoponPageControl setAlpha:0.0f];    
}

- (void)maximizeActivityPaginationScrollViewAlpha{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponActivityPagesScrollView.userInteractionEnabled = YES;
    
    [self.photoponActivityPagesScrollView setAlpha:1.0f];
    [self.photoponActivityPageControl setAlpha:1.0f];
    
}

- (void)minimizeActivityPaginationScrollViewAlpha{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self.photoponActivityPagesScrollView.userInteractionEnabled = NO;
    
    [self.photoponActivityPagesScrollView setAlpha:0.0f];
    [self.photoponActivityPageControl setAlpha:0.0f];
}

- (void)swapPaginationScrollViews{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.photoponPagesScrollView.isHidden) {
        
        [self minimizeRootPaginationScrollViewAlpha];
        
        //[self.photoponActivityPagesScrollView setHidden:YES];
        // [self.photoponActivityPageControl setHidden:YES];
        
        [self.photoponPageControl setHidden:NO];
        [self.photoponPagesScrollView setHidden:NO];
        
    }else{
        
        //[self maximizeRootPaginationScrollViewAlpha];
        
        [self maximizeActivityPaginationScrollViewAlpha];
        
        [self.photoponActivityPageControl setHidden:NO];
        [self.photoponActivityPagesScrollView setHidden:NO];
        [self.photoponPagesScrollView setHidden:YES];
        [self.photoponPageControl setHidden:YES];
    }
}

- (void)reloadInBackground {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    if (self.isLoading)
        return;
    
    
    
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![appDelegate validateDeviceConnection]) {
        return;
    }
    
    
    
    
    
    
    
    
    NSDictionary *timerUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"currentUserID", [PhotoponUserModel currentUser].identifier, nil];
    
    // allow 2 seconds more than PhotoponQueryTableViewController allows before timing out to accomodate building pages in memory
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:25.0f target:self selector:@selector(handleReloadInBackgroundTimeout) userInfo:timerUserInfo repeats:NO];
    
    [self swapPaginationScrollViews];
    
    [noResultsView removeFromSuperview];
    
    [self reloadInBackgroundWithBlock:^(NSError *error){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self reloadInBackgroundWithBlock:^(NSError *error){ ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [timer invalidate];
        
        
        
        [self.photoponActivityPageControl setHidden:YES];
        [self.photoponActivityPagesScrollView setHidden:YES];
        [self maximizeRootPaginationScrollViewAlpha];
        
        
        
        
        //[self configureNoResultsView];// removeFromSuperview];
        
        //[self hideHud];
        
        //[self removePhotoponToolTipOverlay];
        
    }];
}

- (void)handleReloadInBackgroundTimeout {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidReceiveLocalOffers object:nil userInfo:nil];
    
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(q, ^{
        
        [weakSelf showHUDWithStatusText:@"Request timed out" mode:MBProgressHUDModeText];
        
        [weakSelf hideHudAfterDelay:1.0];
        
        [weakSelf configureNoResultsView];
        
        
        
    });
}

- (void)reloadInBackgroundWithBlock:(void (^)(NSError *error))block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isLoading) {
        return;
    }
	   
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            if ([self hasSearchBar]) { ... }  else { ... ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    //[self.photoponToolTipOverlay removeFromSuperview];
    
    //if (self.photoponPagesScrollView.window)
        //[self.photoponPagesScrollView removeFromSuperview];
    
    //[self.photoponPagesScrollView setHidden:YES];
    
    
    
    //CGRect pagesScrollViewFrame = CGRectMake(self.photoponPagesScrollView.frame.origin.x, self.photoponPagesScrollView.frame.origin.y, self.photoponPagesScrollView.frame.size.width, self.photoponPagesScrollView.frame.size.height);
    
    //self.photoponPagesScrollView = nil;
    
    
    
    
    
    
    
    
    
    //if (!self.photoponToolTipOverlay.window)
        //[self addPhotoponToolTipOverlay:self.photoponPagesScrollView];
    
    
    
    //[self.photoponPagesContainerView addSubview:self.photoponPagesScrollView];
    
    //dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [weakSelf.photoponPagesScrollView removeAllPages];
        [weakSelf.objects removeAllObjects];
        
        //[self postProcessResults];
        
        weakSelf.hasMore = NO;
        [weakSelf updateCurrentOffset:0];
        [weakSelf appendNextPageWithFinishCallback:block];
        
    });
}

//- (UIView*)photoponPagesContainerView{
    
    
    
    
//}

- (void)postProcessResults {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.lastSync = [NSDate date];
    [self.methodParams setObject:self.lastSync forKey:kPhotoponLastSyncDate];
}

- (NSObject *)tableQueryMapReduce {
    return nil;
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
    
    return self.objects.count + (self.hasMore ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //id object = [self objectAtIndexPath:indexPath];
    return [self tableView: tableView cellForRowAtIndexPath:indexPath object:[self objectAtIndexPath:indexPath]];
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
    
    [self tableView:tableView didSelectRowAtIndexPath:indexPath object:[self.objects objectAtIndex:indexPath.row]];
    
    
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


/*
#pragma PhotoponToolTipOverlay

- (void) addPhotoponToolTipOverlay:(UIView *)targetView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    CGRect bounds = self.photoponPagesScrollView.bounds;
    CGRect barBounds = targetView.bounds;
    
    CGRect overlayFrame = CGRectMake(CGRectGetMinX(bounds),
                                     CGRectGetMaxY(barBounds),
                                     CGRectGetWidth(barBounds),
                                     CGRectGetHeight(bounds));// - CGRectGetHeight(barBounds));
    
    self.photoponToolTipOverlay.frame = overlayFrame;
     * /
    
    [targetView addSubview:self.photoponToolTipOverlay];
    
}

- (void) removePhotoponToolTipOverlay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.photoponToolTipOverlay.window)
        [self.photoponToolTipOverlay removeFromSuperview];
}
*/

- (void)configureNoResultsView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
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
        
        [self.view addSubview:self.noResultsView];
    }
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
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
    HUD.labelText = @"Please wait";
	
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

- (NSDate *)lastSyncDate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.methodParams objectForKey:kPhotoponLastSyncDate];// self.lastSync;
}

#define AssertSubclassMethod() NSAssert(false, @"You must override %@ in a subclass", NSStringFromSelector(_cmd))
#define AssertNoBlogSubclassMethod() NSAssert(self.blog, @"You must override %@ in a subclass if there is no blog", NSStringFromSelector(_cmd))

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreturn-type"

- (id)objectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}


- (void)setUpEmptyPageViewControllers{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int i;
    int iMax = 5;
    
    for (i=0; i< iMax; i++)
        [self.photoponActivityPagesScrollView addPagedViewController:[[PhotoponOfferActivityPageViewController alloc] initWithNibName:@"PhotoponOfferActivityPageViewController" bundle:nil]];
}

- (void)setUpPageViewControllers{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
    /*
     int i;
     
     for (i=0; i<self.objects.count; i++) {
     
     [self.photoponPagesScrollView addPagedViewController:[[PhotoponO alloc] initWithNibName:@"PhotoponIntroFirstPageViewController" bundle:nil] ];
     
     
     }
     // Add Photopon Intro Page 1
     [self.photoponIntroScrollView addPagedViewController:[[PhotoponIntroFirstPageViewController alloc] initWithNibName:@"PhotoponIntroFirstPageViewController" bundle:nil] ];
     
     // Add Photopon Intro Page 2
     [self.photoponIntroScrollView addPagedViewController:[[PhotoponIntroSecondPageViewController alloc] initWithNibName:@"PhotoponIntroSecondPageViewController" bundle:nil] ];
     
     // Add Photopon Intro Page 3
     [self.photoponIntroScrollView addPagedViewController:[[PhotoponIntroThirdPageViewController alloc] initWithNibName:@"PhotoponIntroThirdPageViewController" bundle:nil] ];
     */
}

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

#pragma Subclass UIView's


/*
- (UIView*)photoponPagesContainerView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}

- (FireUIPagedScrollView*)photoponPagesScrollView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}

- (FireUIPagedScrollView*)photoponActivityPagesScrollView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}

- (UIPageControl*)photoponActivityPageControl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}

- (UIPageControl*)photoponPageControl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AssertSubclassMethod();
}
*/



/*
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
* /
 
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
*/


- (NSUInteger)supportedInterfaceOrientations {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPHONE) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskAll;
}

@end
