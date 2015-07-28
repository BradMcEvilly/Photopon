//
//  PhotoponAccountProfileViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 5/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//


#import "PhotoponAccountProfileViewController.h"
#import "PhotoponMediaCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "PhotoponLoadMoreCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotoponProfileHeaderView.h"
#import "PhotoponTabBarController.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponUsersViewController.h"
#import "PhotoponSnipsViewController.h"

typedef enum {
    PhotoponUserActionButtonBlockUser,
    PhotoponUserActionButtonReportSpam,
} PhotoponUserActionButton;

@interface PhotoponAccountProfileViewController()
@property (nonatomic, strong) PhotoponProfileHeaderView *headerView;
@end

@implementation PhotoponAccountProfileViewController
@synthesize headerView;
@synthesize user;

#pragma mark - Initialization

#pragma mark - UIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self = [super initWithEntityName:kPhotoponMediaClassKey];
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self.imageViews = [[NSArray alloc] initWithObjects:self.headerView.photoponBtnProfileImage, nil];
        [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:211.0f green:214.0f blue:219.0f alpha:1.0f]];
    
    
    [self.view setFrame:CGRectMake( (CGFloat)[UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    if (!self.user) {
        if (!self.rootObject)
            [NSException raise:NSInvalidArgumentException format:@"user cannot be nil"];
        else
            self.user = [PhotoponUserModel modelWithDictionary:self.rootObject];
    }
    
    UIButton *rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([self.user.identifier isEqualToString:[PhotoponUserModel currentUser].identifier]) {
        
        [rightNavButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnSignOut.png"] forState:UIControlStateNormal];
        [rightNavButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnSignOut.png"] forState:UIControlStateHighlighted];
        [rightNavButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnSignOut.png"] forState:UIControlStateSelected];
        [rightNavButton setFrame:CGRectMake( 0.0f, 0.0f, 64.0f, 30.0f)];
        [rightNavButton addTarget:self action:@selector(signOutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        [rightNavButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnOpen.png"] forState:UIControlStateNormal];
        [rightNavButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnOpen.png"] forState:UIControlStateHighlighted];
        [rightNavButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnOpen.png"] forState:UIControlStateSelected];
        [rightNavButton setFrame:CGRectMake( 0.0f, 0.0f, 64.0f, 30.0f)];
        [rightNavButton addTarget:self action:@selector(reportBlockUserAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //[signOutButton setTitle:@"Back" forState:UIControlStateNormal];
    //[signOutButton setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    //[[signOutButton titleLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
    //[signOutButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBack.png"] forState:UIControlStateNormal];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBackSelected.png"] forState:UIControlStateHighlighted];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavButton];
    
    
    
    [self initTitleLabelWithText:[[NSString alloc] initWithFormat:@"%@ %@", self.user.firstName, self.user.lastName]];
    
    
    
    
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    /*
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake( 0.0f, 0.0f, 52.0f, 32.0f)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [[backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f)];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBack.png"] forState:UIControlStateNormal];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBackSelected.png"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    */
    
    /*
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 222.0f)];
    [self.headerView setBackgroundColor:[UIColor clearColor]]; // should be clear, this will be the container for our avatar, photo count, follower count, following count, and so on
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    //[texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLeather.png"]]];
    self.tableView.backgroundView = texturedBackgroundView;
    
    UIView *profilePictureBackgroundView = [[UIView alloc] initWithFrame:CGRectMake( 94.0f, 38.0f, 132.0f, 132.0f)];
    [profilePictureBackgroundView setBackgroundColor:[UIColor darkGrayColor]];
    profilePictureBackgroundView.alpha = 0.0f;
    CALayer *layer = [profilePictureBackgroundView layer];
    layer.cornerRadius = 10.0f;
    layer.masksToBounds = YES;
    [self.headerView addSubview:profilePictureBackgroundView];
    
    PhotoponImageView *profilePictureImageView = [[PhotoponImageView alloc] initWithFrame:CGRectMake( 94.0f, 38.0f, 132.0f, 132.0f)];
    [self.headerView addSubview:profilePictureImageView];
    [profilePictureImageView setContentMode:UIViewContentModeScaleAspectFill];
    layer = [profilePictureImageView layer];
    layer.cornerRadius = 10.0f;
    layer.masksToBounds = YES;
    profilePictureImageView.alpha = 0.0f;
    UIImageView *profilePictureStrokeImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 88.0f, 34.0f, 143.0f, 143.0f)];
    profilePictureStrokeImageView.alpha = 0.0f;
    //[profilePictureStrokeImageView setImage:[UIImage imageNamed:@"ProfilePictureStroke.png"]];
    [self.headerView addSubview:profilePictureStrokeImageView];
    
    
    PhotoponFile *imageFile = [self.user objectForKey:kPhotoponUserAttributesProfilePictureUrlKey];
    if (imageFile) {
        [profilePictureImageView setFile:imageFile];
        [profilePictureImageView loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                [UIView animateWithDuration:0.200f animations:^{
                    profilePictureBackgroundView.alpha = 1.0f;
                    profilePictureStrokeImageView.alpha = 1.0f;
                    profilePictureImageView.alpha = 1.0f;
                }];
            }
        }];
    }
    
    UIImageView *photoCountIconImageView = [[UIImageView alloc] initWithImage:nil];
    //[photoCountIconImageView setImage:[UIImage imageNamed:@"IconPics.png"]];
    [photoCountIconImageView setFrame:CGRectMake( 26.0f, 50.0f, 45.0f, 37.0f)];
    [self.headerView addSubview:photoCountIconImageView];
    
    UILabel *photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 94.0f, 92.0f, 22.0f)];
    [photoCountLabel setTextAlignment:UITextAlignmentCenter];
    [photoCountLabel setBackgroundColor:[UIColor clearColor]];
    [photoCountLabel setTextColor:[UIColor whiteColor]];
    [photoCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [photoCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [photoCountLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [self.headerView addSubview:photoCountLabel];
    
    UIImageView *followersIconImageView = [[UIImageView alloc] initWithImage:nil];
    //[followersIconImageView setImage:[UIImage imageNamed:@"IconFollowers.png"]];
    [followersIconImageView setFrame:CGRectMake( 247.0f, 50.0f, 52.0f, 37.0f)];
    [self.headerView addSubview:followersIconImageView];
    
    UILabel *followerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 226.0f, 94.0f, self.headerView.bounds.size.width - 226.0f, 16.0f)];
    [followerCountLabel setTextAlignment:UITextAlignmentCenter];
    [followerCountLabel setBackgroundColor:[UIColor clearColor]];
    [followerCountLabel setTextColor:[UIColor whiteColor]];
    [followerCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [followerCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [followerCountLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self.headerView addSubview:followerCountLabel];
    
    UILabel *followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 226.0f, 110.0f, self.headerView.bounds.size.width - 226.0f, 16.0f)];
    [followingCountLabel setTextAlignment:UITextAlignmentCenter];
    [followingCountLabel setBackgroundColor:[UIColor clearColor]];
    [followingCountLabel setTextColor:[UIColor whiteColor]];
    [followingCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [followingCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [followingCountLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self.headerView addSubview:followingCountLabel];
    
    UILabel *userDisplayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 176.0f, self.headerView.bounds.size.width, 22.0f)];
    [userDisplayNameLabel setTextAlignment:UITextAlignmentCenter];
    [userDisplayNameLabel setBackgroundColor:[UIColor clearColor]];
    [userDisplayNameLabel setTextColor:[UIColor whiteColor]];
    [userDisplayNameLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [userDisplayNameLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [userDisplayNameLabel setText:[self.user objectForKey:kPhotoponUserAttributesFullNameKey]];
    [userDisplayNameLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [self.headerView addSubview:userDisplayNameLabel];
    
    [photoCountLabel setText:@"0 photopons"];
    
    /*
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:kPAPPhotoUserKey equalTo:self.user];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [photoCountLabel setText:[NSString stringWithFormat:@"%d photo%@", number, number==1?@"":@"s"]];
            [[PAPCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
        }
    }];
    * /
    
    [followerCountLabel setText:@"0 followers"];
    
    /*
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowerCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowerCount whereKey:kPAPActivityToUserKey equalTo:self.user];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [followerCountLabel setText:[NSString stringWithFormat:@"%d follower%@", number, number==1?@"":@"s"]];
        }
    }];
    * /
    
    NSDictionary *followingDictionary = [[PhotoponUserModel currentUser] objectForKey:@"following"];
    [followingCountLabel setText:@"0 following"];
    if (followingDictionary) {
        [followingCountLabel setText:[NSString stringWithFormat:@"%d following", [[followingDictionary allValues] count]]];
    }
    
    /*
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [queryFollowingCount whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [queryFollowingCount whereKey:kPAPActivityFromUserKey equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [followingCountLabel setText:[NSString stringWithFormat:@"%d following", number]];
        }
    }];
    * /
    
    if (![[self.user objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
        UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loadingActivityIndicatorView startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
        
        /*
        // check if the currentUser is following this user
        PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kPAPActivityClassKey];
        [queryIsFollowing whereKey:kPhotoponActivityTypeKey equalTo:kPAPActivityTypeFollow];
        [queryIsFollowing whereKey:kPhotoponActivityToUserKey equalTo:self.user];
        [queryIsFollowing whereKey:kPhotoponActivityFromUserKey equalTo:[PFUser currentUser]];
        [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error && [error code] != kPFErrorCacheMiss) {
                NSLog(@"Couldn't determine follow relationship: %@", error);
                self.navigationItem.rightBarButtonItem = nil;
            } else {
                if (number == 0) {
                    [self configureFollowButton];
                } else {
                    [self configureUnfollowButton];
                }
            }
        }];
         * /
    }
     */
}

- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
        /*
    if(self.user.didFollowBool)
        [self.headerView.photoponBtnProfileFollowing setSelected:YES];
    else
        [self.headerView.photoponBtnProfileFollowing setSelected:NO];
         */
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
    
    NSURL *profilePicFocusURL = [[NSURL alloc] initWithString:self.user.profilePictureUrl];
    
    return profilePicFocusURL;
    
    
    /*
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
     */
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

#pragma mark - PhotoponQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super objectsDidLoad:error];
        
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!weakSelf.headerView) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"          if (!weakSelf.headerView");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            weakSelf.headerView = [PhotoponProfileHeaderView photoponProfileHeaderViewWithUserModel:weakSelf.user];
            [weakSelf.headerView setDelegate:weakSelf];
            
            
            weakSelf.imageViews = [[NSArray alloc] initWithObjects:weakSelf.headerView.photoponProfilePicImageView, nil];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"self.user.identifier = %@", weakSelf.user.identifier);
            NSLog(@"[PhotoponUserModel currentUser].identifier = %@", [PhotoponUserModel currentUser].identifier);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            if ([weakSelf.user.identifier isEqualToString:[PhotoponUserModel currentUser].identifier]) {
                [weakSelf.headerView.photoponBtnProfileSnips setHidden:NO];
                [weakSelf.headerView.photoponBtnProfileFollowing setHidden:YES];
                [weakSelf.headerView.photoponBtnProfileFollowing setAlpha:0.0f];
                [weakSelf.headerView.photoponBtnProfileFollowing setEnabled:NO];
                [weakSelf.headerView setNeedsDisplay];
            }else{
                [weakSelf.headerView.photoponBtnProfileSnips setHidden:YES];
                [weakSelf.headerView.photoponBtnProfileFollowing setHidden:NO];
                [weakSelf.headerView.photoponBtnProfileFollowing setAlpha:0.0f];
                [weakSelf.headerView.photoponBtnProfileFollowing setEnabled:NO];
                if(weakSelf.user.didFollowBool)
                    [weakSelf.headerView.photoponBtnProfileFollowing setSelected:YES];
                else
                    [weakSelf.headerView.photoponBtnProfileFollowing setSelected:NO];
                
                [weakSelf.headerView setNeedsDisplay];
            }

        }
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    });
    
}
/*
- (NSString *)queryForTable {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PhotoponLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PhotoponLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleGray;
        //cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
*/

#pragma mark - ()

- (void)followButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
    
    [self configureUnfollowButton];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [PhotoponUtility followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (error) {
            [weakSelf configureFollowButton];
        }
    }];
}

- (void)unfollowButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
    
    [self configureFollowButton];
    
    [PhotoponUtility unfollowUserEventually:self.user];
}

- (void)reportBlockUserAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    //[appDelegate logOut];
    
    
    
    __weak __typeof(&*self)weakSelf = self;
    
    void (^showActionSheetBlock)() = ^{
        
        PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
        
        UIActionSheet *sheet;
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:[weakSelf buttonTitleForButtonIndex:PhotoponUserActionButtonBlockUser], [weakSelf buttonTitleForButtonIndex:PhotoponUserActionButtonReportSpam], nil];
        
        [sheet showFromTabBar:appDelegate.tabBarController.tabBar];
        
        
    };
    
    showActionSheetBlock();
}


- (NSString *)buttonTitleForButtonIndex:(NSUInteger)buttonIndex
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    switch (buttonIndex) {
        case PhotoponUserActionButtonBlockUser:
            return NSLocalizedString(@"Block User", nil);
            
        case PhotoponUserActionButtonReportSpam:
            return NSLocalizedString(@"Report for Spam", nil);
            
        default:
            return nil;
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        //self.completionBlock(nil, nil);
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self blockUser]; //self.completionBlock(nil, @{ UIImagePickerControllerOriginalImage : self.lastPhoto, UIImagePickerControllerEditedImage : self.lastPhoto });
            break;
            
        case 1:
            [self reportSpam]; // showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            return;
            
        default:
            break;
    }
}

- (void)reportSpam{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (void)blockUser{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (void)signOutButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    [appDelegate logOut];
}

- (void)backButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureFollowButton {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Follow" style:UIBarButtonItemStyleBordered target:self action:@selector(followButtonAction:)];
    [[PhotoponCache sharedCache] setFollowStatus:NO user:self.user];
}

- (void)configureUnfollowButton {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Unfollow" style:UIBarButtonItemStyleBordered target:self action:@selector(unfollowButtonAction:)];
    [[PhotoponCache sharedCache] setFollowStatus:YES user:self.user];
}




#pragma mark - PhotoponProfileHeaderView Delegate

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileStatsPhotopons:(PhotoponUIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileStatsFollowers:(PhotoponUIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponProfileHeaderView *photoponProfileHeaderView
    
    PhotoponUsersViewController *photoponUsersViewController = [[PhotoponUsersViewController alloc] initWithRootObject:self.user.dictionary];
    
    
    [photoponUsersViewController.methodParams setObject:kPhotoponAPIMethodGetFollowers forKey:kPhotoponMethodNameKey];
    
    [photoponUsersViewController initTitleLabelWithText:@"Followers"];
    [self.navigationController pushViewController:photoponUsersViewController animated:YES];
    
}

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileStatsFollowing:(PhotoponUIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponUsersViewController *photoponUsersViewController = [[PhotoponUsersViewController alloc] initWithRootObject:self.user.dictionary];
    
    [photoponUsersViewController.methodParams setObject:kPhotoponAPIMethodGetFollowers forKey:kPhotoponMethodNameKey];
    
    
    
    [photoponUsersViewController initTitleLabelWithText:@"Following"];
    
    [self.navigationController pushViewController:photoponUsersViewController animated:YES];
    
}

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapFollowUserButton:(UIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    
    
    PhotoponUserModel *photoponUserModel = [(PhotoponMediaModel*)[self objectAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]] user];
    //PhotoponUserModel *photoponUserModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    if ([photoponUserModel didFollowBool]) {
        
        [button setSelected:NO];
        
        // update local client model
        //[photoponMediaModel setDidLikeBool:NO];
        
        [photoponUserModel userDidUnfollow:button];
        
        
    }else{
        
        [button setSelected:YES];
        
        [photoponUserModel userDidFollow:button];
        
    }
    
    NSMutableArray *testarr = [[NSMutableArray alloc] initWithArray:self.objects];
    
    if (photoponUserModel.dictionary) {
        [testarr replaceObjectAtIndex:button.tag withObject:photoponUserModel.dictionary];
    }
    
    self.objects = [[NSMutableArray alloc] initWithArray:testarr];
    
}

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileSnips:(UIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    PhotoponSnipsViewController *photoponSnipsViewController = [[PhotoponSnipsViewController alloc] initWithRootObject:nil];// initWithStyle:UITableViewStylePlain];
    */
    PhotoponSnipsViewController *photoponSnipsViewController = [[PhotoponSnipsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    //[photoponSnipsViewController.methodParams setObject:kPhotoponAPIMethodGetFollowers forKey:kPhotoponMethodNameKey];
    
    [photoponSnipsViewController initTitleLabelWithText:@"Snips"];
    [self.navigationController pushViewController:photoponSnipsViewController animated:YES];
    
}

@end