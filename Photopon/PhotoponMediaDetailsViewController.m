//
//  PhotoponMediaDetailsViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaDetailsViewController.h"

#import "PhotoponBaseTextCell.h"
#import "PhotoponActivityCell.h"
#import "PhotoponMediaDetailFooterView.h"
#import "PhotoponMediaDetailHeaderView.h"
#import "PhotoponConstants.h"
#import "PhotoponAccountProfileViewController.h"
#import "PhotoponLoadMoreCell.h"
#import "PhotoponUtility.h"
#import "PhotoponCommentModel.h"
#import "PhotoponCouponModel.h"
#import "PhotoponMediaModel.h"
#import "PhotoponMediaCell.h"
#import "PhotoponMediaDetailHeaderInfoView.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponUserModel.h"
#import "PhotoponRedeemViewController.h"
#import "DateUtils.h"
#import "PhotoponOfferOverlayView.h"

enum ActionSheetTags {
    MainActionSheetTag = 0,
    ConfirmDeleteActionSheetTag = 1
};

@interface PhotoponMediaDetailsViewController ()
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, assign) BOOL likersQueryInProgress;
@end

static const CGFloat kPhotoponCellInsetWidth = 6.0f;


@implementation PhotoponMediaDetailsViewController

@synthesize commentTextField;
@synthesize media, headerView;
@synthesize heightNumber;

#pragma mark - Initialization

- (void)dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.media];
}

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
        
        
        
        [self.methodParams setObject:[_rootObject objectForKey:kPhotoponModelIdentifierKey] forKey:kPhotoponModelIdentifierKey];
        
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        
        // set defaults
        [self.methodParams setObject:kPhotoponAPIReturnedCommentModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:kPhotoponAPIMethodGetComments forKey:kPhotoponMethodNameKey];
        
        
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
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style entityName:kPhotoponCommentClassName];
    if (self) {
        
        @synchronized(self) {
            //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
            NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
            if (!currentUserID || !currentUserID.length>0) {
                currentUserID = [[NSString alloc] initWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]]];
            }
            [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
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

- (id)initWithMedia:(PhotoponMediaModel *)aMedia {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithRootObject:aMedia.dictionary];
    if (self) {
        // The className to query on
        
        @synchronized(self) {
            //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
            NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
            if (!currentUserID || !currentUserID.length>0) {
                currentUserID = [[NSString alloc] initWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]]];
            }
            [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
            [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        }
        
        [self.methodParams setObject:kPhotoponCommentClassName forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:aMedia.identifier forKey:kPhotoponCommentAttributesIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set defaults
        [self.methodParams setObject:kPhotoponAPIMethodGetComments forKey:kPhotoponMethodNameKey];
        [self.methodParams setObject:kPhotoponAPIReturnedCommentModelsKey forKey:kPhotoponMethodReturnedModelsKey];
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of comments to show per page
        self.objectsPerPage = 30;
        
        self.media = aMedia;
        
        self.likersQueryInProgress = NO;
        
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoponLogoNavBar.png"]];
    //self.navigationItem.hidesBackButton = YES;
    
    UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateNormal];
    [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateHighlighted];
    [signOutButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"] forState:UIControlStateSelected];
    [signOutButton setFrame:CGRectMake( 0.0f, 0.0f, 39.0f, 30.0f)];
    [signOutButton addTarget:self action:@selector(backButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:signOutButton];
    
    
    
    /*
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake( 0.0f, 0.0f, 52.0f, 32.0f);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    backButton.titleEdgeInsets = UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBack.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"ButtonBackSelected.png"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    */
    // Set table view properties
    
    
    
    // Set table header
    self.headerView = [PhotoponMediaDetailHeaderInfoView photoponMediaDetailHeaderInfoView:self.media];
    self.headerView.delegate = self;
    
    
    CGRect hFrame = CGRectMake(0.0f, 0.0f, 320.0f, 499.0f);
    [self.headerView setFrame:hFrame];
    
    //self.headerView.photoponMediaCaptionCell.delegate = self;
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---------->         BEFORE  [self.heightNumber floatValue] = %f", [self.heightNumber floatValue]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.tableView.tableHeaderView = self.headerView;
    
    
    
    self.heightNumber = (NSNumber*)[[EGOCache globalCache] objectForKey:[self headerHeightCacheKey]];
    
    if (!self.heightNumber) {
        self.heightNumber = [[NSNumber alloc] initWithFloat:499.0f]; //(445.0f + [PhotoponBaseTextCell heightForCellWithName:nil contentString:self.media.caption])];
    }
    
    // //
    
    CGFloat ht = [self.heightNumber floatValue];
    
    
    [self.headerView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, ht)];
    [self.tableView.tableHeaderView setFrame:hFrame];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---------->         AFTER  [self.heightNumber floatValue] = %f", [self.heightNumber floatValue]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Set table footer
    PhotoponMediaDetailFooterView *footerView = [[PhotoponMediaDetailFooterView alloc] initWithFrame:CGRectMake(0.0f, [self.heightNumber floatValue], 320.0f, 44.0f)]; //[PhotoponMediaDetailFooterView rectForView]];
    commentTextField = footerView.commentField;
    commentTextField.delegate = self;
    self.tableView.tableFooterView = footerView;
    
    //self.tableView.tableFooterView
    //
    
    if (NSClassFromString(@"UIActivityViewController")) {
        // Use UIActivityViewController if it is available (iOS 6 +)
        
        
        UIButton *activityOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [activityOpenButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnOpen.png"] forState:UIControlStateNormal];
        [activityOpenButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnOpen.png"] forState:UIControlStateHighlighted];
        [activityOpenButton setImage:[UIImage imageNamed:@"PhotoponNavBarBtnOpen.png"] forState:UIControlStateSelected];
        [activityOpenButton setFrame:CGRectMake( 0.0f, 0.0f, 39.0f, 30.0f)];
        [activityOpenButton addTarget:self action:@selector(activityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityOpenButton];
        
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(activityButtonAction:)];
    } else if ([self currentUserOwnsPhoto]) {
        
        // Else we only want to show an action button if the user owns the photo and has permission to delete it.
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonAction:)];
    }
    
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
    
    
    // DATES
    [self.headerView.photoponMediaHeaderInfoView.photoponLabelProfileSubtitlePerson setText:[NSString stringWithFormat:@"%@", [DateUtils createdDateString:self.media.createdTime]]];       // [DateUtils GMTDateTolocalDate:object.createdTime]]]];
    [self.headerView.photoponMediaHeaderInfoView.photoponExpirationDate setText:self.media.coupon.expirationTextString];
    
    //[self.headerView.photoponMediaCell.offerOverlay.photoponPlaceDetails setText:self.media.coupon.place.name];
    //self.headerView.photoponMediaCell.offerOverlay.sourceImage = self.media.coupon.place.offerSourceImageURL];
    
    
    
    
    //[cell.photoponMediaHeaderInfoView.photoponLabelProfileSubtitlePerson setText:[NSString stringWithFormat:@"%@", [DateUtils createdDateString:[DateUtils GMTDateTolocalDate:[PhotoponUtility photoponDateWithString:object.createdTime]]]]]; // [DateUtils GMTDateTolocalDate:object.createdTime]]]];
    
    [self.headerView.photoponMediaFooterInfoView.photoponBtnActionsLike setSelected:self.media.didLikeBool];
    [self.headerView.photoponMediaFooterInfoView.photoponBtnActionsSnip setSelected:self.media.didSnipBool];
    
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", self.media.likeCount] forState:UIControlStateNormal];
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", self.media.likeCount] forState:UIControlStateHighlighted];
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", self.media.likeCount] forState:UIControlStateSelected];
    
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", self.media.snipCount] forState:UIControlStateNormal];
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", self.media.snipCount] forState:UIControlStateHighlighted];
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", self.media.snipCount] forState:UIControlStateSelected];
    
    
    
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", self.media.commentCount] forState:UIControlStateNormal];
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", self.media.commentCount] forState:UIControlStateHighlighted];
    [self.headerView.photoponMediaFooterInfoView.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", self.media.commentCount] forState:UIControlStateSelected];
    
    // Register to be notified when the keyboard will be shown to scroll the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedPhoto:) name:PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.media];
    
    
    [self.tableView.tableHeaderView setFrame:hFrame];
    
    
    //UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    //texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]];
    //self.tableView.backgroundView = texturedBackgroundView;
    
    //self.tableView.bounds = self.tableView.frame;
}

- (void) configureViewModeDefault{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
}

- (NSString*)headerHeightCacheKey{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponMediaModel * object = self.media;
    return [NSString stringWithFormat:@"row_height_%@", object.entityKey];
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    
    //[self.headerView reloadLikeBar];
    
    // we will only hit the network if we have no cached data for this photo
    BOOL hasCachedLikers = [[PhotoponCache sharedCache] attributesForMedia:self.media] != nil;
    if (!hasCachedLikers) {
        //[self loadLikers];
        
        
        
    }
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    @synchronized(self) {
        
        if (indexPath.row < self.objects.count) { // A comment row
            PhotoponCommentModel *object = [self objectAtIndexPath:indexPath];
            
            if (object) {
                NSString *commentString = object.content;
                
                PhotoponUserModel *commentAuthor = object.user;// (PhotoponUserModel *)[object objectForKey:kPhotoponActivityFromUserKey];
                
                NSString *nameString = @"";
                if (commentAuthor) {
                    nameString = commentAuthor.fullname;
                }
                
                return [PhotoponBaseTextCell heightForCellWithName:nameString contentString:commentString cellInsetWidth:kPhotoponCellInsetWidth];
            }
        }
    }
    
    // The pagination row
    return 44.0f;
}

- (PhotoponCommentModel *)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    // overridden, since we want to implement sections
    if (indexPath.row < self.objects.count) {
        return [PhotoponCommentModel modelWithDictionary: [self.objects objectAtIndex:indexPath.row]];
    }
    
    return nil;
}

#pragma mark - PFQueryTableViewController

/*
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kPAPActivityPhotoKey equalTo:self.photo];
    [query includeKey:kPAPActivityFromUserKey];
    [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];
    [query orderByAscending:@"createdAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}
 */



- (void)objectsDidLoad:(NSError *)error {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[super objectsDidLoad:error];
    
    
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
    
    if(self.pullToRefreshEnabled)
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    
    [self.headerView.photoponMediaCell setDetail:self.media.coupon.details offerValue:self.media.value personalMessage:self.media.caption];
    
    [self.headerView.photoponMediaCell setPlaceName:self.media.coupon.place.name placeDistance:[[NSString alloc] initWithFormat:@"%@", @""] offerSourceImageURL:self.media.coupon.place.offerSourceImageURL];
    
    //[self.headerView reloadLikeBar];
    [self loadLikers];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponMediaModel *)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    PhotoponBaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PhotoponBaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.cellInsetWidth = kPhotoponCellInsetWidth;
        cell.delegate = self;
    }
    
    [cell setUser:[object objectForKey:kPhotoponActivityFromUserKey]];
    [cell setContentText:[object objectForKey:kPhotoponActivityContentKey]];
    [cell setDate:[object createdAt]];
    
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *CellIdentifier = @"NextPage";
    
    PhotoponLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PhotoponLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cellInsetWidth = kPhotoponCellInsetWidth;
        cell.hideSeparatorTop = YES;
    }
    
    return cell;
}

- (void)configureCell:(PhotoponBaseTextCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponCommentModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [cell setUser:object.user];
    [cell setContentText:object.content];
    [cell setDate:object.createdAt];
    
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
}

- (UITableViewCell *)newCellWithObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    PhotoponBaseTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PhotoponBaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.cellInsetWidth = kPhotoponCellInsetWidth;
        cell.delegate = self;
    }
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return NO;
    
    [self showHUDWithStatusText:@"Sending..."];
    
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0 && self.media.user) {
        
        NSMutableDictionary *commentDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            trimmedComment, kPhotoponCommentAttributesContentKey,
                                            [PhotoponUserModel currentUser].dictionary, kPhotoponCommentAttributesUserKey,
                                            self.media.identifier, kPhotoponCommentAttributesMediaIDKey,
                                            [NSDate date], kPhotoponCommentAttributesCreatedTimeKey,
                                            nil];
        
        PhotoponCommentModel *comment = [[PhotoponCommentModel alloc] initWithAttributes:commentDict forEntityName:kPhotoponCommentClassName];
        
        
        
        
        //[comment setObject:trimmedComment forKey:kPhotoponActivityContentKey]; // Set comment text
        //[comment setObject:[self.media objectForKey:kPhotoponMediaAttributesUsersKey] forKey:kPhotoponActivityToUserKey]; // Set toUser
        //[comment setObject:[PhotoponUserModel currentUser] forKey:kPhotoponActivityFromUserKey]; // Set fromUser
        //[comment setObject:kPhotoponActivityTypeComment forKey:kPhotoponActivityTypeKey];
        //[comment setObject:self.media forKey:kPhotoponActivityPhotoKey];
        
        NSArray *parameters = [appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:comment.mediaID, self.media.user.identifier, comment.content, nil]];
        
        PhotoponACL *ACL = [PhotoponACL ACLWithUser:[PhotoponUserModel currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setWriteAccess:YES forUser:self.media.user];
        //comment.ACL = ACL;
        
        
        
        //[self.tableView reloadData];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        int i;
        
        for (i =self.objects.count; i <=[self.tableView numberOfRowsInSection:0]; i++) {
            
            NSIndexPath *iPath = [NSIndexPath indexPathForRow:i inSection:0];
            [arr addObject:iPath];
        }
        
        [super.objects insertObject:commentDict atIndex:self.objects.count];
        
        // update your array before calling insertRowsAtIndexPaths: method
        [self.tableView insertRowsAtIndexPaths:arr
                              withRowAnimation:UITableViewRowAnimationBottom];
        
        [self.tableView reloadData];
        
        NSDictionary *commentInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"comment", comment.dictionary, nil];
        
        [[PhotoponCache sharedCache] incrementCommentCountForPhoto:self.media];
        
        // If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleCommentTimeout:) userInfo:@{@"comment": commentInfo} repeats:NO];
        
        [self.pmm.api callMethod:kPhotoponAPIMethodPostComment parameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray *responseObject){
            
            [timer invalidate];
            
            NSLog(@"PhotoponFeedItemsTableViewDataSource :: syncPhotoponLikeWithSuccess :: callMethodWithParams:@'bp.postComment' params:parameters withSuccess:^(NSArray *responseObject){");
            //NSDictionary *returnData = (NSDictionary*)[responseObject retain];
            NSLog(@"PhotoponFeedItemsTableViewDataSource :: syncPhotoponLikeWithSuccess :: returnData = (NSDictionary*)[responseObject retain];");
            
            /*
             UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"SYNC RESPONSE:"
             message:@"SUCCESS"
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
             alert3.tag = 10;
             [alert3 autorelease];
             [alert3 show];
             */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:self.media userInfo:@{@"comments": @(self.objects.count + 1)}];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [timer invalidate];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"PhotoponFeedItemsTableViewDataSource :: syncPhotoponLikeWithSuccess :: FAILED FAILED FAILED     ");
            NSLog(@"||*****||");
            NSLog(@"||*****||");
            NSLog(@"||*****||               FAILURE DESCRIPTION:        ");
            NSLog(@"||*****||");
            NSLog(@"||*****||       %@", [error localizedDescription]);
            NSLog(@"||*****||");
            NSLog(@"||*****||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            //[photoponCommentsTableViewController_ removeNewCommentCell];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:GetMyPhotoponsFailed object:self userInfo:(NSDictionary*)error];
            
            if (error && error.code == kPhotoponErrorObjectNotFound) {
                [[PhotoponCache sharedCache] decrementCommentCountForPhoto:self.media];
                
                [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Could not post comment" message:@"This photo is no longer available" cancelButtonTitle:nil otherButtonTitle:@"OK"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:self.media userInfo:@{@"comments": @(self.objects.count + 1)}];
            
            
            /*
            UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"Comment Failed!"
                                                             message:[error localizedDescription]
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            alert3.tag = 10;
            [alert3 show];*/
            
        }];
        
        /*
        [comment saveEventually:^(BOOL succeeded, NSError *error) {
            [timer invalidate];
         
            if (error && error.code == kPhotoponErrorObjectNotFound) {
                [[PhotoponCache sharedCache] decrementCommentCountForPhoto:self.media];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not post comment", nil) message:NSLocalizedString(@"This photo is no longer available", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
         
            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:self.media userInfo:@{@"comments": @(self.objects.count + 1)}];
            
            //[MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self loadObjects];
        }];
         */
    }
    
    [textField setText:@""];
    return [textField resignFirstResponder];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (actionSheet.tag == MainActionSheetTag) {
        [self activityButtonAction:actionSheet];
        /*
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            // prompt to delete
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this photo?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, delete photo", nil) otherButtonTitles:nil];
            actionSheet.tag = ConfirmDeleteActionSheetTag;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        } else {
            [self activityButtonAction:actionSheet];
        }*/
        
    } /*else if (actionSheet.tag == ConfirmDeleteActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            [self shouldDeletePhoto];
        }
    }*/
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [commentTextField resignFirstResponder];
}


#pragma mark - PAPBaseTextCellDelegate

- (void)cell:(PhotoponBaseTextCell *)cellView didTapUserButton:(PhotoponUserModel *)aUser {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self shouldPresentAccountViewForUser:aUser];
}


#pragma mark - PAPPhotoDetailsHeaderViewDelegate

-(void)photoDetailsHeaderView:(PhotoponMediaDetailHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self shouldPresentAccountViewForUser:user];
}

- (void)actionButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    actionSheet.tag = MainActionSheetTag;
    actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Delete Photo", nil)];
    if (NSClassFromString(@"UIActivityViewController")) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Share Photo", nil)];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)activityButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (NSClassFromString(@"UIActivityViewController")) {
        // TODO: Need to do something when the photo hasn't finished downloading!
        /*
        if ([[self.photo objectForKey:kPhotoponMediaPictureKey] isDataAvailable]) {
            [self showShareSheet];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[self.photo objectForKey:kPAPPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    [self showShareSheet];
                }
            }];
        }
         */
        
        [self showShareSheet];
        
    }
}

#pragma mark - ()

- (void) showShareSheet{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
    
    /*
     // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
     if ([[[PhotoponUserModel currentUser] objectId] isEqualToString:[[self.photo objectForKey:kPhotoponMediaAttributesUserKey] objectId]] && [self.objects count] > 0) {
     PhotoponMediaModel *firstActivity = self.objects[0];
     if ([[[firstActivity objectForKey:kPhotoponActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kPhotoponMediaUserKey] objectId]]) {
     NSString *commentString = [firstActivity objectForKey:kPhotoponActivityContentKey];
     [activityItems addObject:commentString];
     }
     }
     */
    
    
    
    UIImage *i = [self.headerView.photoponMediaCell screenshot];//self.headerView.photoponMediaCell.imageView.image;
    
    [activityItems addObject:i];
    [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.photopon.com/"]]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
    
}

/*
- (void)showShareSheet {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //[self.navigationController presentViewController:activityViewController animated:YES completion:nil];
    
    
    
    / *
    NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
    
    / *
        // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
        if ([[[PhotoponUserModel currentUser] objectId] isEqualToString:[[self.photo objectForKey:kPhotoponMediaAttributesUserKey] objectId]] && [self.objects count] > 0) {
            PhotoponMediaModel *firstActivity = self.objects[0];
            if ([[[firstActivity objectForKey:kPhotoponActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kPhotoponMediaUserKey] objectId]]) {
                NSString *commentString = [firstActivity objectForKey:kPhotoponActivityContentKey];
                [activityItems addObject:commentString];
            }
        }
        * /
    
    
    
    
    [activityItems addObject:[PhotoponMediaModel takeScreenshot:] croppedImage]];
    [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.photopon.com/"]]];
        
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
    
    
    / *
    
    [[self.photo objectForKey:kPhotoponMediaAttributesLinkURLKey] loadInBackground:^(UIImage *data, NSError *error) {
        if (!error) {
            NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
            
            // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
            if ([[[PhotoponUserModel currentUser] objectId] isEqualToString:[[self.photo objectForKey:kPhotoponMediaAttributesUserKey] objectId]] && [self.objects count] > 0) {
                PhotoponMediaModel *firstActivity = self.objects[0];
                if ([[[firstActivity objectForKey:kPhotoponActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kPhotoponMediaUserKey] objectId]]) {
                    NSString *commentString = [firstActivity objectForKey:kPhotoponActivityContentKey];
                    [activityItems addObject:commentString];
                }
            }
            
            [activityItems addObject:[UIImage imageWithData:data]];
            [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.photopon.com/#pic/%@", self.photo.objectId]]];
            
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
        }
    }];* /
    
}*/

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(q, ^{
        
        [weakSelf updateHUDWithStatusText:@"Request timed out" mode:MBProgressHUDModeText];
        
        [weakSelf hideHudAfterDelay:1.0];
        
        //[self configureNoResultsView];
        
    });
    
    /*
    //[MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
     */
    
}

- (void)shouldPresentAccountViewForUser:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAccountProfileViewController *accountViewController = [[PhotoponAccountProfileViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:user];
    //[self.navigationController pushViewController:accountViewController animated:YES];
    [self.navigationController pushPhotoponViewController:accountViewController];
    
    
    
}

- (void)backButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userLikedOrUnlikedPhoto:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.headerView reloadLikeBar];
    
}

- (void)keyboardWillShow:(NSNotification*)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}

- (void)loadLikers {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.likersQueryInProgress) {
        return;
    }
    
    self.likersQueryInProgress = YES;
    
    /*
    PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likersQueryInProgress = NO;
        if (error) {
            [self.headerView reloadLikeBar];
            return;
        }
        
        NSMutableArray *likers = [NSMutableArray array];
        NSMutableArray *commenters = [NSMutableArray array];
        
        BOOL isLikedByCurrentUser = NO;
        
        for (PFObject *activity in objects) {
            if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike] && [activity objectForKey:kPAPActivityFromUserKey]) {
                [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
            } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment] && [activity objectForKey:kPAPActivityFromUserKey]) {
                [commenters addObject:[activity objectForKey:kPAPActivityFromUserKey]];
            }
            
            if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
                    isLikedByCurrentUser = YES;
                }
            }
        }
        
        [[PAPCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
        [self.headerView reloadLikeBar];
    }];
     */
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self loadObjects];
}

- (BOOL)currentUserOwnsPhoto {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.media.user.identifier isEqualToString:[PhotoponUserModel currentUser].identifier];
}

- (void)shouldDeletePhoto {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    // Delete all activites related to this photo
    PFQuery *query = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [query whereKey:kPAPActivityPhotoKey equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        
        // Delete photo
        [self.photo deleteEventually];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPPhotoDetailsViewControllerUserDeletedPhotoNotification object:[self.photo objectId]];
    [self.navigationController popViewControllerAnimated:YES];
     */
    
}

- (NSArray *)paramsForTable {
    
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
    NSArray *params =  [NSArray arrayWithObjects:
                        self.media.identifier,
                        [NSNumber numberWithInt:
                         [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]  +
                         [[self.methodParams objectForKey:kPhotoponObjectsPerPageKey] integerValue]],
                        self.media.user.identifier,
                        nil];
    
    
    
    return params;

}

#pragma mark - PhotoponMediaDetailHeaderInfoViewDelegate methods

- (void)photoponMediaDetailHeaderInfoView:(PhotoponMediaDetailHeaderInfoView *)photoponMediaDetailHeaderInfoView didTapRedeemButton:(UIButton *)button user:(PhotoponMediaModel *)aMedia{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponRedeemViewController *photoponRedeemViewController = [[PhotoponRedeemViewController alloc] initWithCouponModel:aMedia.coupon];
    
    [self.navigationController pushViewController:photoponRedeemViewController animated:YES];
    
    
}


@end