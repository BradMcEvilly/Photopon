//
//  PhotoponTimelineViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 5/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponTimelineViewController.h"
#import "PhotoponMediaHeaderInfoView.h"
#import "PhotoponAccountProfileViewController.h"
#import "PhotoponMediaDetailsViewController.h"
#import "PhotoponMediaDetailHeaderInfoView.h"
#import "PhotoponUtility.h"
#import "PhotoponLoadMoreCell.h"
#import "PhotoponMediaCell.h"
#import "PhotoponMediaModel.h"
#import "PhotoponMediaFooterInfoView.h"
#import "PhotoponUIButton+AFNetworking.h"
#import "PhotoponMediaFooterCell.h"
#import "PhotoponMediaCaptionCell.h"
#import "PhotoponMediaFullCell.h"
#import "PhotoponImageView.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoponUsersViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "PhotoponMediaFlatCell.h"
#import "PhotoponOfferOverlayView.h"
#import "DateUtils.h"


@interface PhotoponTimelineViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableSet *reusableSectionFooterViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionFooterQueries;

@property (nonatomic, strong) AFHTTPRequestOperation *af_imageRequestOperation;

@end

@implementation PhotoponTimelineViewController
@synthesize reusableSectionHeaderViews;
@synthesize reusableSectionFooterViews;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries;
@synthesize outstandingSectionFooterQueries;

#pragma mark - Initialization

- (void)dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponTabBarControllerDidFinishEditingPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponUtilityUserFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponPhotoDetailsViewControllerUserSnippedUnsnippedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponUtilityUserSnippedUnsnippedPhotoCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponPhotoDetailsViewControllerUserDeletedPhotoNotification object:nil];
    
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
        [self.methodParams setObject:@"media_models" forKey:kPhotoponMethodReturnedModelsKey];
        [self.methodParams setObject:@"bp.getMyGallery" forKey:kPhotoponMethodNameKey];
        
        
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
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
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        //self.reusableSectionFooterViews = [NSMutableSet setWithCapacity:3];
        
        
        self.shouldReloadOnAppear = NO;
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style entityName:kPhotoponMediaClassName];
    if (self) {
        
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
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
        
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionFooterViews = [NSMutableSet setWithCapacity:3];
        
        self.shouldReloadOnAppear = NO;
        
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; // PFQueryTableViewController reads this in viewDidLoad -- would prefer to throw this in init, but didn't work
    
    [super viewDidLoad];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLeather.png"]];
    self.tableView.backgroundView = texturedBackgroundView;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishPhoto:) name:PhotoponTabBarControllerDidFinishEditingPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowingChanged:) name:PhotoponUtilityUserFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidDeletePhoto:) name:PhotoponPhotoDetailsViewControllerUserDeletedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikePhoto:) name:PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikePhoto:) name:PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSnipOrUnsnipPhoto:) name:PhotoponPhotoDetailsViewControllerUserSnippedUnsnippedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSnipOrUnsnipPhoto:) name:PhotoponUtilityUserSnippedUnsnippedPhotoCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCommentOnPhoto:) name:PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:nil];
}

/*
- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
    
}*/

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 1;
    /*
    NSInteger rows = self.objects.count;
    if (self.paginationEnabled && rows != 0)
        rows++;
    return rows;
     */
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    return nil;
    /*
    if (section == self.objects.count) {
        // Load More section
        return nil;
    }
    
    / *
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 8.0f)];
    [headerView setBackgroundColor:TABLE_VIEW_BACKGROUND_COLOR];
    return headerView;
    
    / *
    PhotoponMediaHeaderInfoView *headerView = [self dequeueReusableSectionHeaderView];
    
    if (!headerView) {
        //headerView = [[PhotoponMediaHeaderInfoView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:PAPPhotoHeaderButtonsDefault];
        
        headerView = [PhotoponMediaHeaderInfoView photoponMediaHeaderInfoViewWithName:[[NSString alloc] initWithFormat:@"%@", @"Brad McEvilly"] imageURL:nil createdDate:[[NSString alloc] initWithFormat:@"%@", @"Just now"] expirationDate:[[NSString alloc] initWithFormat:@"%@", @"12/77/2344"]];
        
        headerView.delegate = self;
        [self.reusableSectionHeaderViews addObject:headerView];
    }
    
    PhotoponMediaModel *photo = [self.objects objectAtIndex:section];
    //[headerView setPhoto:photo];
    headerView.tag = section;
    [headerView.photoponBtnProfileImagePerson setTag:section];
    [headerView.photoponBtnProfileNamePerson setTag:section];
    
    
    NSDictionary *attributesForPhoto = [[PhotoponCache sharedCache] attributesForMedia:photo];
    
    
    /*
    if (attributesForPhoto) {
        [headerView setLikeStatus:[[PhotoponCache sharedCache] isPhotoLikedByCurrentUser:photo]];
        [headerView.likeButton setTitle:[[[PhotoponCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
        [headerView.commentButton setTitle:[[[PhotoponCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
        
        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
            [UIView animateWithDuration:0.200f animations:^{
                headerView.likeButton.alpha = 1.0f;
                headerView.commentButton.alpha = 1.0f;
            }];
        }
    } else {
        headerView.likeButton.alpha = 0.0f;
        headerView.commentButton.alpha = 0.0f;
        
        @synchronized(self) {
            // check if we can update the cache
            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:[NSNumber numberWithInt:section]];
            if (!outstandingSectionHeaderQueryStatus) {
                
                / *
                PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(self) {
                        [self.outstandingSectionHeaderQueries removeObjectForKey:[NSNumber numberWithInt:section]];
                        
                        if (error) {
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
                        
                        if (headerView.tag != section) {
                            return;
                        }
                        
                        [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:photo]];
                        [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
                        [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
                        
                        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                headerView.likeButton.alpha = 1.0f;
                                headerView.commentButton.alpha = 1.0f;
                            }];
                        }
                    }
                }];
                 * /
            }
        }
    }* /
    
    return headerView;
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (section == self.objects.count) {
        return 0.0f;
    }
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return nil;
    /*
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 8.0f)];
    [footerView setBackgroundColor:TABLE_VIEW_BACKGROUND_COLOR];
    return footerView;
    */
}
/*
- (PhotoponMediaFooterInfoView *)tableView:(UITableView *)tableView viewForMediaFooterInfoInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (section == self.objects.count) {
        // Load More section
        return nil;
    }
    
    PhotoponMediaFooterInfoView *footerView = [self dequeueReusableSectionFooterView];
    
    if (!footerView) {
        //headerView = [[PhotoponMediaHeaderInfoView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:PAPPhotoHeaderButtonsDefault];
        
        
        
        
        footerView = [PhotoponMediaFooterInfoView photoponMediaFooterInfoViewWithMediaModel:(PhotoponMediaModel*)[self objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]]];
        
        footerView.delegate = self;
        [self.reusableSectionFooterViews addObject:footerView];
    }
    
    PhotoponMediaModel *photo = [self.objects objectAtIndex:section];
    //[headerView setPhoto:photo];
    footerView.tag = section;
    [footerView.photoponBtnActionsLike setTag:section];
    [footerView.photoponBtnActionsComment setTag:section];
    [footerView.photoponBtnActionsSnip setTag:section];
    [footerView.photoponBtnStatsLikes setTag:section];
    [footerView.photoponBtnStatsComments setTag:section];
    [footerView.photoponBtnStatsSnips setTag:section];
    
    NSDictionary *attributesForPhoto = [[PhotoponCache sharedCache] attributesForMedia:photo];
    
    
    /*
     if (attributesForPhoto) {
     [headerView setLikeStatus:[[PhotoponCache sharedCache] isPhotoLikedByCurrentUser:photo]];
     [headerView.likeButton setTitle:[[[PhotoponCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
     [headerView.commentButton setTitle:[[[PhotoponCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
     
     if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
     [UIView animateWithDuration:0.200f animations:^{
     headerView.likeButton.alpha = 1.0f;
     headerView.commentButton.alpha = 1.0f;
     }];
     }
     } else {
     headerView.likeButton.alpha = 0.0f;
     headerView.commentButton.alpha = 0.0f;
     
     @synchronized(self) {
     // check if we can update the cache
     NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:[NSNumber numberWithInt:section]];
     if (!outstandingSectionHeaderQueryStatus) {
     
     / *
     PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     @synchronized(self) {
     [self.outstandingSectionHeaderQueries removeObjectForKey:[NSNumber numberWithInt:section]];
     
     if (error) {
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
     
     if (headerView.tag != section) {
     return;
     }
     
     [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:photo]];
     [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
     [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
     
     if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
     [UIView animateWithDuration:0.200f animations:^{
     headerView.likeButton.alpha = 1.0f;
     headerView.commentButton.alpha = 1.0f;
     }];
     }
     }
     }];
     * /
     }
     }
     }* /
    
    return footerView;
    
    
    
    //UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 16.0f)];
    //return footerView;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (section == self.objects.count) {
        return 0.0f;
    }
    return 0.0f;
}

- (NSString*)rowHeightCacheKeyForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponMediaModel * object = [self objectAtIndexPath:indexPath];
    return [NSString stringWithFormat:@"row_height_%@", object.entityKey];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.row >= self.objects.count || [self isSearchResultsTableView:tableView]) {
        // Load More Section
        return 44.0f;
    }
    
    CGFloat ht = [(NSNumber*)[[EGOCache globalCache] objectForKey:[self rowHeightCacheKeyForRowAtIndexPath:indexPath]] floatValue];
    
    if (ht)
        return ht;
    
    NSNumber *htNumber = [[NSNumber alloc] initWithFloat:445.0f]; //(445.0f + [PhotoponBaseTextCell heightForCellWithName:[[self objectAtIndexPath: indexPath] caption] contentString:[self captionTextForRowAtIndexPath:indexPath]] -32.0f)];
    
    [[EGOCache globalCache] setObject:htNumber forKey:[self rowHeightCacheKeyForRowAtIndexPath:indexPath]];
    
    return [htNumber floatValue];
    
    
    
    /*
    if (44.0f >= [PhotoponMediaCaptionCell heightForCellWithName:@"" contentString:[self captionTextForRowAtIndexPath:indexPath]])
        return 44.0f;
    
    
    switch (indexPath.row) {
        case 0:
            return [PhotoponMediaCaptionCell heightForCellWithName:@"" contentString:[self captionTextForRowAtIndexPath:indexPath]];
            break;
        case 1:
            return 309.0f;
            break;
        case 2:
            return 70.0f; // [self tableView:tableView footerCellForRowAtIndexPath:indexPath object:object];
            break;
        case 3:
            return 20.0f; // [self tableView:tableView spacerCellForRowAtIndexPath:indexPath object:object];
            break;
            
        default:
            break;
    }
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"------------>           0.0f ROW HEIGHT WARNING!!!");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    */
    
    
    
    
    //return 467.0f;
    
}

-(NSString*)captionTextForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[self objectAtIndexPath:indexPath] objectForKey:kPhotoponMediaAttributesCaptionKey];
    
    //[cell setFrame:CGRectMake(0.0f, 0.0f, 320.0f, [PhotoponMediaCaptionCell heightForCellWithName:@"" contentString:@"#Test 123 @bradmcevilly"])];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        PhotoponMediaModel *pMediaMod = [self objectAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
        
        [pMediaMod.dictionary setObject:[[NSNumber alloc] initWithInt:indexPath.row] forKey:@"tag"];
        
        PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[self objectAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]]];
        
        //[weakSelf.navigationController pushViewController:detailViewController animated:YES];
        
        [weakSelf.navigationController pushPhotoponViewController:detailViewController];
        
    });
    
    
    /*
    if (indexPath.row==1) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (indexPath.section == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    }
     */
    
    
    
    
}

-(void)userButtonTapped:(id)sender
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    int tag = [(UIButton *)sender tag];
    NSLog(@"tapped button in cell at row %i", tag);
    
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PhotoponMediaModel *media = [weakSelf objectAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        [weakSelf shouldPresentAccountViewForUser:media.user];
        
    });

    
}

-(void)likeButtonTapped:(id)sender
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    PhotoponUIButton *button = (PhotoponUIButton*)sender;
    
    
    int tag = [(UIButton *)sender tag];
    
    NSLog(@"tapped button in cell at row %i", tag);
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    PhotoponMediaModel *photoponMediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]];
    
    
    
    if ([photoponMediaModel didLikeBool]) {
        
        [button setSelected:NO];
        
        // update local client model
        //[photoponMediaModel setDidLikeBool:NO];
        
        [photoponMediaModel userDidUnlike:button];
        
        
    }else{
        
        [button setSelected:YES];
        
        [photoponMediaModel userDidLike:button];
        
    }
    
    NSMutableArray *testarr = [[NSMutableArray alloc] initWithArray:self.objects];
    
    [testarr replaceObjectAtIndex:button.tag withObject:photoponMediaModel.dictionary];
    
    self.objects = [[NSMutableArray alloc] initWithArray:testarr];

    
    
}

-(void)snipButtonTapped:(id)sender
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    
    PhotoponUIButton *button = (PhotoponUIButton*)sender;
    
    int tag = [button tag];
    NSLog(@"tapped button in cell at row %i", tag);
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    PhotoponMediaModel *photoponMediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    if (photoponMediaModel.didSnipBool) {
        
        [button setSelected:NO];
        
        [photoponMediaModel userDidUnsnip:button];
        
    }else{
        
        [button setSelected:YES];
        
        [photoponMediaModel userDidSnip:button];
        
    }
    
    NSMutableArray *testarr = [[NSMutableArray alloc] initWithArray:self.objects];
    
    [testarr replaceObjectAtIndex:button.tag withObject:photoponMediaModel.dictionary];
    
    self.objects = [[NSMutableArray alloc] initWithArray:testarr];
    
    
}

-(void)commentButtonTapped:(id)sender
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int tag = [(UIButton *)sender tag];
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] animated:YES];
    
    
    
    //PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    
    PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[self objectAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]]];
    
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:detailViewController];

    
}

-(void)likersButtonTapped:(id)sender
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int tag = [(UIButton *)sender tag];
    NSLog(@"tapped button in cell at row %i", tag);
    
    
    PhotoponMediaModel *mediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]];
    
    PhotoponUsersViewController *photoponUsersViewController = [[PhotoponUsersViewController alloc] initWithRootObject:mediaModel.dictionary];
    
    [photoponUsersViewController.methodParams setObject:kPhotoponAPIMethodGetLikes forKey:kPhotoponMethodNameKey];
    
    [photoponUsersViewController initTitleLabelWithText:@"Likers"];
    
    //[self.navigationController pushViewController:photoponUsersViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:photoponUsersViewController];
}

-(void)snippersButtonTapped:(id)sender
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int tag = [(UIButton *)sender tag];
    NSLog(@"tapped button in cell at row %i", tag);
    
    PhotoponMediaModel *mediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]];
    
    PhotoponUsersViewController *photoponUsersViewController = [[PhotoponUsersViewController alloc] initWithRootObject:mediaModel.dictionary];
    
    [photoponUsersViewController.methodParams setObject:kPhotoponAPIMethodGetSnips forKey:kPhotoponMethodNameKey];
    
    [photoponUsersViewController initTitleLabelWithText:@"Snippers"];
    
    //[self.navigationController pushViewController:photoponUsersViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:photoponUsersViewController];
}

-(void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead,   long long totalBytesExpectedToRead))block{
    [self.af_imageRequestOperation setDownloadProgressBlock:block];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PhotoponMediaFullCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([self tableViewCellIsNextPageCellAtIndexPath:indexPath]) {
        return;
    }
    
    
    
    //[super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    //if (indexPath.section == self.objects.count && self.paginationEnabled) {
        // Load More Cell
      //  [self loadNextPage];
    //}
    
    
    
    // Post process results
    //dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PhotoponMediaModel *object = [weakSelf objectAtIndexPath:indexPath];
        
        // cache the next row height in background
        if (![weakSelf tableViewCellIsNextPageCellAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section]]) {
            CGFloat h = [weakSelf tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section]];
        }
        
        
    });
}

#pragma mark - PFQueryTableViewController

- (NSString *)queryForTable {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [followingActivitiesQuery whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [followingActivitiesQuery whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    followingActivitiesQuery.limit = 1000;
    
    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromFollowedUsersQuery whereKey:kPAPPhotoUserKey matchesKey:kPAPActivityToUserKey inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyExists:kPAPPhotoPictureKey];
    
    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromCurrentUserQuery whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
    [photosFromCurrentUserQuery whereKeyExists:kPAPPhotoPictureKey];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
    [query includeKey:kPAPPhotoUserKey];
    [query orderByDescending:@"createdAt"];
    
    // A pull-to-refresh should always trigger a network request.
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    / *
     This query will result in an error if the schema hasn't been set beforehand. While Parse usually handles this automatically, this is not the case for a compound query such as this one. The error thrown is:
     
     Error: bad special key: __type
     
     To set up your schema, you may post a photo with a caption. This will automatically set up the Photo and Activity classes needed by this query.
     
     You may also use the Data Browser at Parse.com to set up your classes in the following manner.
     
     Create a User class: "User" (if it does not exist)
     
     Create a Custom class: "Activity"
     - Add a column of type pointer to "User", named "fromUser"
     - Add a column of type pointer to "User", named "toUser"
     - Add a string column "type"
     
     Create a Custom class: "Photo"
     - Add a column of type pointer to "User", named "user"
     
     You'll notice that these correspond to each of the fields used by the preceding query.
     */
    
    return nil;
}

- (void)objectsDidLoad:(NSError *)error {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super objectsDidLoad:error];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
}

- (PhotoponMediaModel *)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // overridden, since we want to implement sections
    if (indexPath.row < self.objects.count) {
        return [PhotoponMediaModel modelWithDictionary: [self.objects objectAtIndex:indexPath.row]];
    }
    
    return nil;
}
/*
- (void)configureCaptionCell:(PhotoponMediaCaptionCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [cell setFrame:CGRectMake(0.0f, 0.0f, 320.0f, [PhotoponMediaCaptionCell heightForCellWithName:@"" contentString:@"#Test 123 @bradmcevilly"])];
    
    [cell setContentText:@"#Test 123 @bradmcevilly"];
    
    cell.tag = indexPath.section;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
}

- (void)configureFooterCell:(PhotoponMediaFooterCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    cell.photoponMediaFooterInfoView.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
}

- (void)configureSpacerCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //cell.tag = indexPath.section;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    
    [cell setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)];
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
 */

- (void)configureFlatCell:(PhotoponMediaFlatCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    cell.tag = indexPath.row;
    
    cell.tag = indexPath.row;
    cell.photoponBtnMediaOverlay.tag = indexPath.row;
    cell.delegate = self;
    
    [cell.photoponBtnProfileImagePerson addTarget:self action:@selector(userButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoponBtnProfileImagePerson.tag = indexPath.row;
    
    [cell.photoponBtnProfileNamePerson addTarget:self action:@selector(userButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoponBtnProfileNamePerson.tag = indexPath.row;
    
    [cell.photoponBtnStatsSnips addTarget:self action:@selector(snippersButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoponBtnStatsSnips.tag = indexPath.row;
    
    [cell.photoponBtnStatsLikes addTarget:self action:@selector(likersButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoponBtnStatsLikes.tag = indexPath.row;

    [cell.photoponBtnStatsComments addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoponBtnStatsComments.tag = indexPath.row;

    [cell.photoponBtnActionsLike addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoponBtnActionsLike.tag = indexPath.row;

    [cell.photoponBtnActionsSnip addTarget:self action:@selector(snipButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoponBtnActionsSnip.tag = indexPath.row;

    
    

    cell.photoponOfferOverlayView.alpha = 0.0f;
    //[cell.photoponMediaCell.imageView setAlpha:0.0f];
    //cell.photoponMediaHeaderInfoView.delegate = self;
    //cell.photoponMediaFooterInfoView.delegate = self;
    //cell.photoponMediaCaptionCell.delegate = self;
    
    
    cell.photoponMediaModel = object;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    //[cell.photoponMainView removeFromSuperview];
    //[cell.photoponMainView setBackgroundColor:[UIColor clearColor]];
    
    //[cell.contentView setBackgroundColor:[UIColor clearColor]];
    //[cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    //[cell.accessoryView setBackgroundColor:[UIColor clearColor]];
    
    //[cell.contentView addSubview:cell.photoponMainView];
    
    
    
    
    //[DateUtils GMTDateTolocalDate:[DateUtils localDateToGMTDate:[NSDate date]]];
    
    
    
    [cell.photoponLabelProfileSubtitlePerson setText:[NSString stringWithFormat:@"%@", [DateUtils createdDateString:object.createdTime]]]; // [DateUtils GMTDateTolocalDate:object.createdTime]]]];
    
    [cell.photoponExpirationDate setText:object.coupon.expirationTextString];
    
    
    
    /*
     //[cell.photoponMediaHeaderInfoView.photoponLabelProfileSubtitlePerson setText:[NSString stringWithFormat:@"%@", [DateUtils createdDateString:[DateUtils GMTDateTolocalDate:[PhotoponUtility photoponDateWithString:object.createdTime]]]]]; // [DateUtils GMTDateTolocalDate:object.createdTime]]]];
     
     if ([object.coupon.expirationString isEqualToString:[PhotoponUtility photoponDateStringWith8CouponsDateString:kPhotoponNullDBDateFieldString]]) {
     [cell.photoponMediaHeaderInfoView.photoponExpirationDate setText:@"N/A"];
     }else{
     [cell.photoponMediaHeaderInfoView.photoponExpirationDate setText:[object.coupon.expiration stringWithFormat:kPhotoponDateTextFormat]];
     }*/
     
     //[NSString stringWithFormat:@"%@ %@" weakObject]
     [cell.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", object.user.firstName, object.user.lastName] forState:UIControlStateNormal];
     [cell.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", object.user.firstName, object.user.lastName] forState:UIControlStateHighlighted];
     [cell.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", object.user.firstName, object.user.lastName] forState:UIControlStateSelected];
     
     NSURL *linkURLProfilePic = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", kPhotoponContentBase, object.user.profilePictureUrl]];
     
     UIImage *placeHolderImgProfilePic = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
     
     //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
     
     
     
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       object.user.profilePictureUrl = %@", object.user.profilePictureUrl);
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       object.user.profilePictureUrl FULL = %@", [NSString stringWithFormat:@"%@%@", kPhotoponContentBase, object.user.profilePictureUrl]);
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     __weak __typeof(&*cell)weakCell = cell;
     __weak __typeof(&*object)weakObject = object;
     
     
     NSData *someData = [[EGOCache globalCache] dataForKey:[NSString stringWithFormat:@"pComData_%@", object.entityKey]];
     
     if (!someData) {
     
     [cell.photoponBtnProfileImagePerson.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLProfilePic] placeholderImage:placeHolderImgProfilePic success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
     
     //[weakCell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson setImage:image forState:UIControlStateNormal];
     
     //UIImage* img = image;
     
     
     
     //UIImage* smallImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:6 interpolationQuality:kCGInterpolationLow];
     
     
     //dispatch_async(dispatch_get_main_queue(), ^{
     
     //UIImageJPEGRepresentation(image, 0.9f);
     
     
     [weakCell fadeInView:weakCell.photoponOfferOverlayView];
     
     [[EGOCache globalCache] setData:UIImageJPEGRepresentation(image, 0.9f) forKey:[NSString stringWithFormat:@"pComData_%@", object.entityKey]];
     
     [weakCell.photoponBtnProfileImagePerson.imageView setImage:image];
     
     //});
     
     //[weakCell fadeInView];
     
     //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
     
     //[PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 80.0f) mediaModel:object];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
     
     //});
     
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
     
     //
     
     }];
     }else{
     
     [cell.photoponBtnProfileImagePerson.imageView setImage:[UIImage imageWithData:someData]];
     
     }
     
     
     
     
     
     
     
     
     //[cell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView];
     
     //dispatch_async(dispatch_get_main_queue(), ^{
     
     if (object.caption)
         [cell.photoponOfferOverlayView.photoponPersonalMessage setText:object.caption];
     else
         [cell.photoponOfferOverlayView.photoponPersonalMessage setText:@""];
     
     //});
     
     @try {
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"-------->            object.value = %@", object.value);
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     //[cell setDetail:[[NSString alloc] initWithFormat:@"%@", object.coupon.details] offerValue:[[NSString alloc] initWithFormat:@"%@", object.value] personalMessage:[[NSString alloc] initWithFormat:@"%@", object.caption]];
     
         
         [cell.photoponOfferOverlayView.photoponOfferDetails setText:object.coupon.details];
         [cell.photoponOfferOverlayView.photoponOfferValue setText:object.value];
         [cell.photoponOfferOverlayView.photoponPersonalMessage setText:object.caption];
         
     
     
     }
     @catch (NSException *exception) {
     
         [cell.photoponOfferOverlayView.photoponOfferDetails setText:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row]];
         [cell.photoponOfferOverlayView.photoponOfferValue setText:[[NSString alloc] initWithFormat:@"%@", @"save $24"]];
         [cell.photoponOfferOverlayView.photoponPersonalMessage setText:[[NSString alloc] initWithFormat:@"%@", object.caption]];
         
     //[cell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", @"save $24"] personalMessage:[[NSString alloc] initWithFormat:@"%@", object.caption]];
     
     }
     @finally {
     // silence is golden
     
     }
     
     //dispatch_async(dispatch_get_main_queue(), ^{
     
     //[cell.photoponMediaCaptionCell setUpWithText:@"Which casual kicks are @your #style"];
     
     
     
     //if (weakObject.user) {
     
     
     
     
     
     if (object.linkURL) {
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       object.linkURL = %@", object.linkURL);
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     NSURL *linkURL = [[NSURL alloc] initWithString:object.linkURL];
     
     
     
     UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
     
     //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
     
     /*
     self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL:linkURL]];
     
     [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     // success
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       [AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL SUCCESS = %@", object.linkURL);
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     // failed
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       [AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL FAIL = %@", object.linkURL);
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     }];
     */
     
     if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]) {
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     UIImage *timelineImg = [PhotoponUtility timelineImageFromImageCacheKey:object.entityKey];
     [cell.imageView setImage:timelineImg];
     
     }else{
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]  }else{  ");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     
     [cell.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURL] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
     
     [weakCell.imageView setImage:image];
     [weakCell fadeInView];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
     
     [PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 0.8f) mediaModel:weakObject];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
     
     });
     
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
     
     }];
     }
     
     
     //[cell.photoponMediaCell.imageView setImageWithURL:linkURL placeholderImage:placeHolderImg];
     
     
     
     //cell.photoponMediaCell.imageView = testImgView;
     }
     
     
     
     
     cell.photoButton.tag                              = indexPath.row;
     cell.photoponBtnActionsComment.tag      = indexPath.row;
     cell.photoponBtnActionsLike.tag         = indexPath.row;
     cell.photoponBtnActionsSnip.tag         = indexPath.row;
     cell.photoponBtnStatsComments.tag       = indexPath.row;
     cell.photoponBtnStatsLikes.tag          = indexPath.row;
     cell.photoponBtnStatsSnips.tag          = indexPath.row;
     cell.photoponBtnProfileNamePerson.tag   = indexPath.row;
     cell.photoponBtnProfileImagePerson.tag  = indexPath.row;
     
     
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     [cell setBackgroundColor:[UIColor clearColor]];
     
     [cell setAccessoryType:UITableViewCellAccessoryNone];
     
     [cell.photoponBtnActionsLike setSelected:object.didLikeBool];
     [cell.photoponBtnActionsSnip setSelected:object.didSnipBool];
     
     [cell.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", object.likeCount] forState:UIControlStateNormal];
     [cell.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", object.likeCount] forState:UIControlStateHighlighted];
     [cell.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", object.likeCount] forState:UIControlStateSelected];
     
     [cell.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", object.snipCount] forState:UIControlStateNormal];
     [cell.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", object.snipCount] forState:UIControlStateHighlighted];
     [cell.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", object.snipCount] forState:UIControlStateSelected];
     
     [cell.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", object.commentCount] forState:UIControlStateNormal];
     [cell.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", object.commentCount] forState:UIControlStateHighlighted];
     [cell.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", object.commentCount] forState:UIControlStateSelected];
    
    
    
    
     //});
     //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     //PhotoponMediaModel *object = [self objectAtIndexPath:indexPath];
     
     //dispatch_async(dispatch_get_main_queue(), ^{
     
     
     
     /*
     if (!object.coupon.details)
     [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", @"save $24"]];
     else
     [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", object.coupon.details]];
     */
    
    //[cell.photoponMediaCaptionCell setContentText:cell.photoponMediaModel.caption]; //@"Which casual kicks are your #style"];
    
    
    //cell.photoponMediaCell.offerOverlay.text = object.coupon.details;
    
    
    //[cell.photoponMediaCell.imageView setImageWithURL:linkURL];
    /*
     NSURLRequest *req = [[NSURLRequest alloc] initWithURL:linkURL];
     [cell.photoponMediaCell.imageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"PhotoponPlaceholderMediaPhoto.png"] success:^(NSURLRequest *request, NSHTTPURLResponse   *response, id JSON){
     
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"---->       [cell.photoponMediaCell.imageView setImageWithURLRequest:req SUCCESS SUCCESS");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     /*
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
     }];*/
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
    
    
    
    
    //});
    
    
    //
    
    
    //});
    //});
    

    
    
    if ([[PhotoponUserModel currentUser].identifier isEqualToString: cell.photoponMediaModel.user.identifier]) {
        [self configureCurrentUserCell:cell];
    }
    
    
}

- (void)configureCurrentUserCell:(PhotoponMediaFlatCell*)cell {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [cell.photoponBtnActionsLike setEnabled:NO];
    [cell.photoponBtnActionsSnip setEnabled:NO];
}

//- (void)configureCell:(PhotoponMediaFullCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
- (void)configureCell:(PhotoponMediaFlatCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponMediaModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Post process results
    //dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    
    return [self configureFlatCell:cell atIndexPath:indexPath withObject:object];
    
    
    
    
    
    
    
    
    
    
    
    
    
    cell.tag = indexPath.row;
    cell.photoponBtnMediaOverlay.tag = indexPath.row;
    cell.delegate = self;
    
    
    cell.photoponOfferOverlayView.alpha = 0.0f;
    //[cell.photoponMediaCell.imageView setAlpha:0.0f];
    //cell.photoponMediaHeaderInfoView.delegate = self;
    //cell.photoponMediaFooterInfoView.delegate = self;
    //cell.photoponMediaCaptionCell.delegate = self;
    
    
    cell.photoponMediaModel = object;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    //[cell.photoponMainView removeFromSuperview];
    //[cell.photoponMainView setBackgroundColor:[UIColor clearColor]];
    
    //[cell.contentView setBackgroundColor:[UIColor clearColor]];
    //[cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    //[cell.accessoryView setBackgroundColor:[UIColor clearColor]];
    
    //[cell.contentView addSubview:cell.photoponMainView];
    
    
    
    
    //[DateUtils GMTDateTolocalDate:[DateUtils localDateToGMTDate:[NSDate date]]];
    
    
    
    //[cell.photoponMediaHeaderInfoView.photoponLabelProfileSubtitlePerson setText:[NSString stringWithFormat:@"%@", [DateUtils createdDateString:object.createdTime]]]; // [DateUtils GMTDateTolocalDate:object.createdTime]]]];
    
    //[cell.photoponMediaHeaderInfoView.photoponExpirationDate setText:object.coupon.expirationTextString];
    
    
    
    /*
    //[cell.photoponMediaHeaderInfoView.photoponLabelProfileSubtitlePerson setText:[NSString stringWithFormat:@"%@", [DateUtils createdDateString:[DateUtils GMTDateTolocalDate:[PhotoponUtility photoponDateWithString:object.createdTime]]]]]; // [DateUtils GMTDateTolocalDate:object.createdTime]]]];
    
    if ([object.coupon.expirationString isEqualToString:[PhotoponUtility photoponDateStringWith8CouponsDateString:kPhotoponNullDBDateFieldString]]) {
        [cell.photoponMediaHeaderInfoView.photoponExpirationDate setText:@"N/A"];
    }else{
        [cell.photoponMediaHeaderInfoView.photoponExpirationDate setText:[object.coupon.expiration stringWithFormat:kPhotoponDateTextFormat]];
    }* /
    
    //[NSString stringWithFormat:@"%@ %@" weakObject]
    [cell.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", object.user.firstName, object.user.lastName] forState:UIControlStateNormal];
    [cell.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", object.user.firstName, object.user.lastName] forState:UIControlStateHighlighted];
    [cell.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson setTitle:[NSString stringWithFormat:@"%@ %@", object.user.firstName, object.user.lastName] forState:UIControlStateSelected];
    
    NSURL *linkURLProfilePic = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", kPhotoponContentBase, object.user.profilePictureUrl]];
    
    UIImage *placeHolderImgProfilePic = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
    
    //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
    
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       object.user.profilePictureUrl = %@", object.user.profilePictureUrl);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       object.user.profilePictureUrl FULL = %@", [NSString stringWithFormat:@"%@%@", kPhotoponContentBase, object.user.profilePictureUrl]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*cell)weakCell = cell;
    __weak __typeof(&*object)weakObject = object;
    
    
    NSData *someData = [[EGOCache globalCache] dataForKey:[NSString stringWithFormat:@"pComData_%@", object.entityKey]];
    
    if (!someData) {
        
    [cell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLProfilePic] placeholderImage:placeHolderImgProfilePic success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        //[weakCell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson setImage:image forState:UIControlStateNormal];
        
        //UIImage* img = image;
        
        
        
        //UIImage* smallImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:6 interpolationQuality:kCGInterpolationLow];
        
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        
        //UIImageJPEGRepresentation(image, 0.9f);
        
        
        [weakCell fadeInView:weakCell.photoponOfferOverlayView];
        
        [[EGOCache globalCache] setData:UIImageJPEGRepresentation(image, 0.9f) forKey:[NSString stringWithFormat:@"pComData_%@", object.entityKey]];
        
        [weakCell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImage:image];
        
        //});
        
        //[weakCell fadeInView];
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //[PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 80.0f) mediaModel:object];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
        
        //});
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        //
        
    }];
    }else{
        
        [cell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImage:[UIImage imageWithData:someData]];
        
    }
    
    
    
    
    
    
    
    
    //[cell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView];
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        
        if (object.caption)
            [cell.photoponMediaCaptionCell setUpWithText:object.caption];
        else
            [cell.photoponMediaCaptionCell setUpWithText:@""];
        
    //});
    
    @try {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            object.value = %@", object.value);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@", object.coupon.details] offerValue:[[NSString alloc] initWithFormat:@"%@", object.value] personalMessage:[[NSString alloc] initWithFormat:@"%@", object.caption]];
        
        
        
    }
    @catch (NSException *exception) {
        
        [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", @"save $24"] personalMessage:[[NSString alloc] initWithFormat:@"%@", object.caption]];
    
    }
    @finally {
        // silence is golden
        
    }

    //dispatch_async(dispatch_get_main_queue(), ^{
        
        //[cell.photoponMediaCaptionCell setUpWithText:@"Which casual kicks are @your #style"];
        
        
        
        //if (weakObject.user) {
        
        
        
        
        
        if (object.linkURL) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"---->       object.linkURL = %@", object.linkURL);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSURL *linkURL = [[NSURL alloc] initWithString:object.linkURL];
            
            
            
            UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
            
            //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
            
            /*
             self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL:linkURL]];
             
             [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
             // success
             
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"---->       [AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL SUCCESS = %@", object.linkURL);
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             
             
             
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // failed
             
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"---->       [AFHTTPRequestOperation alloc] initWithRequest:[PhotoponUtility imageRequestWithURL FAIL = %@", object.linkURL);
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             
             }];
             * /
            
            if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]) {
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"---->       if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]");
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                UIImage *timelineImg = [PhotoponUtility timelineImageFromImageCacheKey:object.entityKey];
                [cell.photoponMediaCell.imageView setImage:timelineImg];
                
            }else{
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"---->       if ([PhotoponUtility doesHaveCachedTimelineImage:object.entityKey]  }else{  ");
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                [cell.photoponMediaCell.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURL] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
                    
                    [weakCell.photoponMediaCell.imageView setImage:image];
                    [weakCell fadeInView];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        
                        [PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 0.8f) mediaModel:weakObject];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
                        
                    });
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                    
                }];
            }
            
            
            //[cell.photoponMediaCell.imageView setImageWithURL:linkURL placeholderImage:placeHolderImg];
            
            
            
            //cell.photoponMediaCell.imageView = testImgView;
        }
    
    
    
    
    cell.photoponMediaCell.photoButton.tag                              = indexPath.row;
    cell.photoponMediaFooterInfoView.photoponBtnActionsComment.tag      = indexPath.row;
    cell.photoponMediaFooterInfoView.photoponBtnActionsLike.tag         = indexPath.row;
    cell.photoponMediaFooterInfoView.photoponBtnActionsSnip.tag         = indexPath.row;
    cell.photoponMediaFooterInfoView.photoponBtnStatsComments.tag       = indexPath.row;
    cell.photoponMediaFooterInfoView.photoponBtnStatsLikes.tag          = indexPath.row;
    cell.photoponMediaFooterInfoView.photoponBtnStatsSnips.tag          = indexPath.row;
    cell.photoponMediaHeaderInfoView.photoponBtnProfileNamePerson.tag   = indexPath.row;
    cell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.tag  = indexPath.row;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    [cell.photoponMediaFooterInfoView.photoponBtnActionsLike setSelected:object.didLikeBool];
    [cell.photoponMediaFooterInfoView.photoponBtnActionsSnip setSelected:object.didSnipBool];
    
    [cell.photoponMediaFooterInfoView.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", object.likeCount] forState:UIControlStateNormal];
    [cell.photoponMediaFooterInfoView.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", object.likeCount] forState:UIControlStateHighlighted];
    [cell.photoponMediaFooterInfoView.photoponBtnStatsLikes setTitle:[NSString stringWithFormat:@"%i likes", object.likeCount] forState:UIControlStateSelected];
    
    [cell.photoponMediaFooterInfoView.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", object.snipCount] forState:UIControlStateNormal];
    [cell.photoponMediaFooterInfoView.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", object.snipCount] forState:UIControlStateHighlighted];
    [cell.photoponMediaFooterInfoView.photoponBtnStatsSnips setTitle:[NSString stringWithFormat:@"%i snips", object.snipCount] forState:UIControlStateSelected];
    
    [cell.photoponMediaFooterInfoView.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", object.commentCount] forState:UIControlStateNormal];
    [cell.photoponMediaFooterInfoView.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", object.commentCount] forState:UIControlStateHighlighted];
    [cell.photoponMediaFooterInfoView.photoponBtnStatsComments setTitle:[NSString stringWithFormat:@"%i comments", object.commentCount] forState:UIControlStateSelected];
    
    //});
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //PhotoponMediaModel *object = [self objectAtIndexPath:indexPath];
    
        //dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            /*
             if (!object.coupon.details)
             [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", @"save $24"]];
             else
             [cell.photoponMediaCell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.row] offerValue:[[NSString alloc] initWithFormat:@"%@", object.coupon.details]];
             */
            
            //[cell.photoponMediaCaptionCell setContentText:cell.photoponMediaModel.caption]; //@"Which casual kicks are your #style"];
            
            
            //cell.photoponMediaCell.offerOverlay.text = object.coupon.details;
            
            
            //[cell.photoponMediaCell.imageView setImageWithURL:linkURL];
            /*
             NSURLRequest *req = [[NSURLRequest alloc] initWithURL:linkURL];
             [cell.photoponMediaCell.imageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"PhotoponPlaceholderMediaPhoto.png"] success:^(NSURLRequest *request, NSHTTPURLResponse   *response, id JSON){
             
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"---->       [cell.photoponMediaCell.imageView setImageWithURLRequest:req SUCCESS SUCCESS");
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             /*
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
             }];*/
            
            //dispatch_async(dispatch_get_main_queue(), ^{
                //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                
                

                
            //});
            
            
            //
            
            
        //});
    //});
    
}

- (UITableViewCell *)newCellWithObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    
    return [self newFlatCellWithObject:object];
    
    NSString *cellIdentifier = @"_PhotoponMediaFullCellIdentifier";
    
    PhotoponMediaFullCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [PhotoponMediaFullCell photoponMediaFullCell:self];// alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_gradient_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
        //[cell setBackgroundView:imageView];
        //[cell setBackgroundColor:[UIColor clearColor]];
        
    }else{
        //[cell prepareForReuse];
    }
    
    //[cell.contentView setAlpha:0.0f];
    
    return cell;
    
    
}

- (UITableViewCell *)newFlatCellWithObject:(id)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSString *cellIdentifier = @"_PhotoponMediaFlatCellIdentifier";
    
    PhotoponMediaFlatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [PhotoponMediaFlatCell photoponMediaFlatCell:self];// alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_gradient_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
        //[cell setBackgroundView:imageView];
        //[cell setBackgroundColor:[UIColor clearColor]];
        
    }else{
        //[cell prepareForReuse];
    }
    
    //[cell.contentView setAlpha:0.0f];
    
    return cell;
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

/*
- (UITableViewCell *)newCell {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    NSString *cellIdentifier = @"_PhotoponMediaCellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PhotoponMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_gradient_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
        //[cell setBackgroundView:imageView];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    return cell;
}

- (PhotoponMediaFooterCell *)tableView:(UITableView *)tableView footerCellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponMediaModel *)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *CellIdentifier = @"_PhotoponMediaFooterCellIdentifier";
    
    PhotoponMediaFooterCell *footerCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (footerCell == nil) {
        
        footerCell = [PhotoponMediaFooterCell photoponMediaFooterCell];// alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //[footerCell setBackgroundColor:[UIColor clearColor]];
        
        //footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //footerCell.userInteractionEnabled = NO;
        
        //[footerCell setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 70.0f)];
        //[footerCell addSubview:[self tableView:tableView viewForMediaFooterInfoInSection:indexPath.section]];
    }
    
    [self configureFooterCell:footerCell atIndexPath:indexPath withObject:object];
    
    return footerCell;
}
                      
                      

- (PhotoponMediaCaptionCell *)tableView:(UITableView *)tableView captionCellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponMediaModel *)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *CellIdentifier = @"_PhotoponMediaCaptionCellIdentifier";
    
    PhotoponMediaCaptionCell *captionCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (captionCell == nil) {
        
        captionCell = [PhotoponMediaCaptionCell photoponMediaCaptionCell];// alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //[footerCell setBackgroundColor:[UIColor clearColor]];
        
        //footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //footerCell.userInteractionEnabled = NO;
        
        //[footerCell setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 70.0f)];
        //[footerCell addSubview:[self tableView:tableView viewForMediaFooterInfoInSection:indexPath.section]];
    }
    
    [self configureCaptionCell:captionCell atIndexPath:indexPath withObject:object];
    
    return captionCell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView spacerCellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponMediaModel *)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *CellIdentifier = @"_PhotoponMediaSpacerCellIdentifier";
    
    UITableViewCell *spacerCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (spacerCell == nil) {
        spacerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    [self configureSpacerCell:spacerCell atIndexPath:indexPath withObject:object];
    
    return spacerCell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponMediaModel *)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    } else {
        
        switch (indexPath.row) {
            case 0:
                return [self tableView:tableView captionCellForRowAtIndexPath:indexPath object:object];
                break;
            case 2:
                return [self tableView:tableView footerCellForRowAtIndexPath:indexPath object:object];
                break;
            case 3:
                return [self tableView:tableView spacerCellForRowAtIndexPath:indexPath object:object];
                break;
                
            default:
                break;
        }
        
        PhotoponMediaCell *cell = (PhotoponMediaCell *)[self newCell];
        
        / *
        if (cell == nil) {
            cell = [[PhotoponMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.photoButton addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        * /
        
        
        if (object) {
            
            /*
            cell.imageView.file = [object objectForKey:kPhotoponMediaAttributesLinkURLKey];
            
            // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
            if ([cell.imageView.file isDataAvailable]) {
                [cell.imageView loadInBackground];
            }
             * /
        }
        
        
        [self configureCell:cell atIndexPath:indexPath withObject:object];
        
        return cell;
    }
}* /

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PhotoponLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PhotoponLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleGray;
        cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
    
}*/



#pragma mark - PhotoponTimelineViewController

- (PhotoponMediaHeaderInfoView *)dequeueReusableSectionHeaderView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    for (PhotoponMediaHeaderInfoView *sectionHeaderView in self.reusableSectionHeaderViews) {
        if (!sectionHeaderView.superview) {
            // we found a section header that is no longer visible
            return sectionHeaderView;
        }
    }
    
    return nil;
}

- (PhotoponMediaFooterInfoView *)dequeueReusableSectionFooterView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    for (PhotoponMediaFooterInfoView *sectionFooterView in self.reusableSectionFooterViews) {
        if (!sectionFooterView.superview) {
            // we found a section footer that is no longer visible
            return sectionFooterView;
        }
    }
    
    return nil;
}


#pragma mark - PAPPhotoFooterViewDelegate

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateCroppedImageViewWithImage:) withObject:[[PhotoponMediaModel newPhotoponDraft] croppedImage] waitUntilDone:NO];
	} else {
		[self updateCroppedImageViewWithImage:[[PhotoponMediaModel newPhotoponDraft] croppedImage]];
	}*/
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PhotoponMediaModel *media = [weakSelf objectAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
        [weakSelf shouldPresentAccountViewForUser:media.user];
        
    });
    
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

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapLikePhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[photoHeaderView shouldEnableLikeButton:NO];
    
    BOOL liked = !button.selected;
    //[photoHeaderView setLikeStatus:liked];
    
    NSString *originalButtonTitle = button.titleLabel.text;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *likeCount = [numberFormatter numberFromString:button.titleLabel.text];
    if (liked) {
        likeCount = [NSNumber numberWithInt:[likeCount intValue] + 1];
        [[PhotoponCache sharedCache] incrementLikerCountForPhoto:photo];
    } else {
        if ([likeCount intValue] > 0) {
            likeCount = [NSNumber numberWithInt:[likeCount intValue] - 1];
        }
        [[PhotoponCache sharedCache] decrementLikerCountForPhoto:photo];
    }
    
    [[PhotoponCache sharedCache] setPhotoIsLikedByCurrentUser:photo liked:liked];
    
    [button setTitle:[numberFormatter stringFromNumber:likeCount] forState:UIControlStateNormal];
    
    
    /*
    if (liked) {
        [PhotoponUtility likePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
            PhotoponMediaHeaderView *actualHeaderView = (PhotoponMediaHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableLikeButton:YES];
            [actualHeaderView setLikeStatus:succeeded];
            
            if (!succeeded) {
                [actualHeaderView.likeButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    } else {
        [PhotoponUtility unlikePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
            PhotoponMediaHeaderView *actualHeaderView = (PhotoponMediaHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableLikeButton:YES];
            [actualHeaderView setLikeStatus:!succeeded];
            
            if (!succeeded) {
                [actualHeaderView.likeButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    }*/
}

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapCommentOnPhotoButton:(UIButton *)button  photo:(PhotoponMediaModel *)photo {
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0] animated:YES];
    
    
    PhotoponMediaModel *pMediaMod = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    [pMediaMod.dictionary setObject:[[NSNumber alloc] initWithInt:button.tag] forKey:@"tag"];
    
    PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]]];
    
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:detailViewController];
    
}


#pragma mark - ()

- (NSIndexPath *)indexPathForObject:(PhotoponMediaModel *)targetObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    for (int i = 0; i < self.objects.count; i++) {
        PhotoponMediaModel *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    
    return nil;
}

- (void)userDidLikeOrUnlikePhoto:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidSnipOrUnsnipPhoto:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidCommentOnPhoto:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidDeletePhoto:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // refresh timeline after a delay
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    __weak __typeof(&*self)weakSelf = self;
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [weakSelf loadObjects];
    });
}

- (void)userDidPublishPhoto:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    //[self loadObjects];
    
}

- (void)userFollowingChanged:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"User following changed.");
    self.shouldReloadOnAppear = YES;
}

- (void)didTapOnPhotoAction:(UIButton *)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] animated:YES];
    
    //PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[self objectAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    [detailViewController.headerView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]])];
    
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:detailViewController];
    
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self loadObjects];
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

/*
- (NSString *)entityName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return kPhotoponMediaClassKey;
    
}*/

- (NSDate *)lastSyncDate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.pmm lastTimelineSync];
}

#pragma mark - PhotoponMediaFooterInfoViewDelegate
/*
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0] animated:YES];
    
    PhotoponAccountProfileViewController *detailViewController = [[PhotoponAccountProfileViewController alloc] initWithStyle:UITableViewStylePlain];
    
    detailViewController.user = [(PhotoponMediaModel*)[self objectAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]] user];
    
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:detailViewController];
    
}
*/
 
/**
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    PhotoponMediaModel *photoponMediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    
    
    if ([photoponMediaModel didLikeBool]) {
        
        [button setSelected:NO];
        
        // update local client model
        //[photoponMediaModel setDidLikeBool:NO];
        
        [photoponMediaModel userDidUnlike:button];
        
        
    }else{
        
        [button setSelected:YES];
        
        [photoponMediaModel userDidLike:button];
        
    }
    
    NSMutableArray *testarr = [[NSMutableArray alloc] initWithArray:self.objects];
    
    [testarr replaceObjectAtIndex:button.tag withObject:photoponMediaModel.dictionary];
    
    self.objects = [[NSMutableArray alloc] initWithArray:testarr];
    
}

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    PhotoponMediaModel *photoponMediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    if (photoponMediaModel.didSnipBool) {
        
        [button setSelected:NO];
        
        [photoponMediaModel userDidUnsnip:button];
        
    }else{
        
        [button setSelected:YES];
        
        [photoponMediaModel userDidSnip:button];
        
    }
    
    NSMutableArray *testarr = [[NSMutableArray alloc] initWithArray:self.objects];
    
    [testarr replaceObjectAtIndex:button.tag withObject:photoponMediaModel.dictionary];
    
    self.objects = [[NSMutableArray alloc] initWithArray:testarr];
    
}

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[button tag] inSection:0] animated:YES];
    
    
    
    //PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    
    PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]]];
    
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:detailViewController];
    
    
    
    /*
    if (indexPath.row < self.objects.count) {
        PFObject *activity = [self.objects objectAtIndex:indexPath.row];
        if ([activity objectForKey:kPAPActivityPhotoKey]) {
            PAPPhotoDetailsViewController *detailViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:[activity objectForKey:kPAPActivityPhotoKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        } else if ([activity objectForKey:kPAPActivityFromUserKey]) {
            PAPAccountViewController *detailViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
            [detailViewController setUser:[activity objectForKey:kPAPActivityFromUserKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    } else if (self.paginationEnabled) {
        // load more
        [self loadNextPage];
    }
    */
    
}



/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapStatsLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponMediaModel *mediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    PhotoponUsersViewController *photoponUsersViewController = [[PhotoponUsersViewController alloc] initWithRootObject:mediaModel.dictionary];
    
    [photoponUsersViewController.methodParams setObject:kPhotoponAPIMethodGetLikes forKey:kPhotoponMethodNameKey];
    
    [photoponUsersViewController initTitleLabelWithText:@"Likers"];
    
    //[self.navigationController pushViewController:photoponUsersViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:photoponUsersViewController];
    
}

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapStatsSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponMediaModel *mediaModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    PhotoponUsersViewController *photoponUsersViewController = [[PhotoponUsersViewController alloc] initWithRootObject:mediaModel.dictionary];
    
    [photoponUsersViewController.methodParams setObject:kPhotoponAPIMethodGetSnips forKey:kPhotoponMethodNameKey];
    
    [photoponUsersViewController initTitleLabelWithText:@"Snippers"];
    
    //[self.navigationController pushViewController:photoponUsersViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:photoponUsersViewController];
    
}

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapStatsCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0] animated:YES];
    
    //PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]]];
    
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    [self.navigationController pushPhotoponViewController:detailViewController];
    
}

#pragma mark - PhotoponMediaFullCellDelegate methods

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapMediaButton:(UIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0] animated:YES];
        
        PhotoponMediaModel *pMediaMod = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
        
        [pMediaMod.dictionary setObject:[[NSNumber alloc] initWithInt:button.tag] forKey:@"tag"];
        
        PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithMedia:[self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]]];
        
        //[weakSelf.navigationController pushViewController:detailViewController animated:YES];
        
        [weakSelf.navigationController pushPhotoponViewController:detailViewController];
        
    });
        
    
}

@end