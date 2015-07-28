//
//  PhotoponUsersViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/12/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponUsersViewController.h"
#import "PhotoponFindFriendsCell.h"
#import "PhotoponUserModel.h"
#import "PhotoponUsersTableViewCell.h"
#import "UIImage+ResizeAdditions.h"
#import "PhotoponAccountProfileViewController.h"

@interface PhotoponUsersViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@end

@implementation PhotoponUsersViewController

@synthesize shouldReloadOnAppear;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoponUtilityUserFollowingChangedNotification object:nil];
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithRootObject:(NSMutableDictionary*)_rootObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithRootObject:_rootObject];
    if (self) {
        
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
        
        // The className to query on
        [self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // set api method vars
        [self.methodParams setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedUserModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        // bp.getFollowers by default
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIMethodGetFollowers] forKey:kPhotoponMethodNameKey];
        //[self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"bp.getFollowing"] forKey:kPhotoponMethodNameKey];
        
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
        
        self.shouldReloadOnAppear = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidFollowOrUnfollowUser:) name:PhotoponUtilityUserFollowingChangedNotification object:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:211.0f green:214.0f blue:219.0f alpha:1.0f]];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
    self.tableView.backgroundView = texturedBackgroundView;
    
    
	// Do any additional setup after loading the view.
    
}

- (void)userDidFollowOrUnfollowUser:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
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
    
    // Params:
    //  1). UserID      - so we know whos gallery to load
    //  2). MaxObjects  - so we don't receive more than
    /*NSArray *params =  [NSArray arrayWithObjects:
     self.identifier,
     (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
     nil];
     */
    
    
    NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
                               self.identifier,
                               [[NSNumber alloc] initWithInt:
                                [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]],
                               nil];
    
    
    
    
    /*
     
    NSArray *paramsArrExtra = [NSArray arrayWithObjects:[NSString stringWithString:(NSString*)[self.photoponFeedItemsTableViewController.photoponModelDictionary objectForKey:@"identifier"]], [NSNumber numberWithInt:num], nil];
    
    */
    
    /* temp fix until brian uploads updated php server file
    NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
                               self.identifier,
                               [[NSNumber alloc] initWithInt:
                                [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]  +
                                [[self.methodParams objectForKey:kPhotoponObjectsPerPageKey] integerValue]],
                               nil];
    */
    return params;
}


 - (NSString *)entityName {
 
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
     return kPhotoponUserClassName;
    
 }

- (NSDate *)lastSyncDate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.pmm lastTimelineSync];
}


#pragma mark - PhotoponUsersTableViewCellDelegate methods

- (void)photoponUsersTableViewCell:(PhotoponUsersTableViewCell *)photoponUsersTableViewCell didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[button tag] inSection:0] animated:YES];
    
    PhotoponUserModel *usr = [self objectAtIndexPath:[NSIndexPath indexPathForRow:[button tag] inSection:0]];
    [self shouldPresentAccountViewForUser:usr];
    
    /*
    PhotoponAccountViewController *detailViewController = [PhotoponAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    [detailViewController setUser:[activity objectForKey:kPAPActivityFromUserKey]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
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
    }*/

    
}

/*!
 Sent to the delegate when the like photo button is tapped
 @param photo the PFObject for the photo that is being liked or disliked
 */

- (void)photoponUsersTableViewCell:(PhotoponUsersTableViewCell *)photoponUsersTableViewCell didTapFollowUserButton:(UIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    PhotoponUserModel *leader = [self objectAtIndexPath:[NSIndexPath indexPathForRow:[button tag] inSection:0]];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    PhotoponUserModel *photoponUserModel = [self objectAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    photoponUserModel.leader = leader;
    
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
    [testarr replaceObjectAtIndex:button.tag withObject:photoponUserModel.dictionary];
    self.objects = [[NSMutableArray alloc] initWithArray:testarr];
}

/*

- (UITableViewCell *)newCell {
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    NSString *cellIdentifier = @"_PhotoponUserCellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [PhotoponUsersTableViewCell photoponUsersTableViewCellWithUserModel:nil];// initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell_gradient_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
        //[cell setBackgroundView:imageView];
        
        [cell setBackgroundColor:[UIColor clearColor]];
    
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PhotoponUserModel *)object {
    static NSString *CellIdentifier = @"_PhotoponUsersTableViewCellIdentifier";
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    } else {
                
        PhotoponUsersTableViewCell *cell = (PhotoponUsersTableViewCell *)[self newCell];
        
        
        
        if (cell == nil) {
            cell = [[PhotoponUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.photoponBtnUserName addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //[cell setDetail:[[NSString alloc] initWithFormat:@"%@ %i", @"testing details here", indexPath.section] offerValue:[[NSString alloc] initWithFormat:@"%@", @"$24"]];
        
        cell.photoponBtnProfileFollowing.tag = indexPath.section;
        cell.photoponBtnUserImage.tag = indexPath.section;
        cell.photoponBtnUserName.tag = indexPath.section;
        
        if (object) {
            
            / *
             cell.imageView.file = [object objectForKey:kPhotoponMediaAttributesLinkURLKey];
             
             // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
             if ([cell.imageView.file isDataAvailable]) {
             [cell.imageView loadInBackground];
             }
             * /
        }
        
        [cell setBackgroundColor:TABLE_VIEW_CELL_BACKGROUND_COLOR];
        
        
        
        
        
        
        
        
        
        
        
        
        [cell.photoponBtnUserName setTitle:[[NSString alloc] initWithFormat:@"%@ %@", object.firstName, object.lastName] forState:UIControlStateNormal];// = [[NSString alloc] initWithFormat:@"%@ %@", view.photoponUserModel.firstName, view.photoponUserModel.lastName];
        
        [cell.photoponBtnProfileFollowing setSelected:NO];
        
        //UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        
        
        [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
        //self.tableView.backgroundView = texturedBackgroundView;
        
        
        if([object.didFollowString boolValue])
            [cell.photoponBtnProfileFollowing setSelected:YES];
        
        
        
        return cell;
    }
}
*/

- (void)shouldPresentAccountViewForUser:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAccountProfileViewController *photoponAccountProfileViewController = [[PhotoponAccountProfileViewController alloc] initWithRootObject:user.dictionary];
    
    [photoponAccountProfileViewController.methodParams setObject:kPhotoponAPIMethodGetProfileInfo forKey:kPhotoponMethodNameKey];
    
    //[self.navigationController pushViewController:photoponAccountProfileViewController animated:YES];
    
    
    
    [self.navigationController pushPhotoponViewController:photoponAccountProfileViewController];
    
}

#pragma mark - () PhotoponUser override

- (PhotoponUserModel *)objectAtIndexPath:(NSIndexPath *)indexPath{
	return [PhotoponUserModel modelWithDictionary:[self.objects objectAtIndex:indexPath.row]];
}

- (NSIndexPath *)indexPathForObject:(PhotoponUserModel *)targetObject {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    for (int i = 0; i < self.objects.count; i++) {
        PhotoponUserModel *object = [PhotoponUserModel modelWithDictionary:[self.objects objectAtIndex:i]];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    
    return nil;
}

- (void)configureCell:(PhotoponUsersTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponUserModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    cell.photoponBtnUserName.tag = indexPath.row;
    cell.photoponBtnUserImage.tag = indexPath.row;
    cell.photoponBtnProfileFollowing.tag = indexPath.row;
    
    [cell.photoponBtnUserName setTitle:@"tttt tt" forState:UIControlStateNormal];
    [cell.photoponBtnUserImage.imageView setImageWithURL:[NSURL URLWithString:object.profilePictureUrl] placeholderImage:[UIImage imageNamed:@"PhotoponPlaceholderProfileMedium.png"]];
    
    //[NSString stringWithFormat:@"%@ %@" weakObject]
    [cell.photoponBtnUserName setTitle:[NSString stringWithFormat:@"%@ %@", object.firstName, object.lastName] forState:UIControlStateNormal];
    [cell.photoponBtnUserName setTitle:[NSString stringWithFormat:@"%@ %@", object.firstName, object.lastName] forState:UIControlStateHighlighted];
    [cell.photoponBtnUserName setTitle:[NSString stringWithFormat:@"%@ %@", object.firstName, object.lastName] forState:UIControlStateSelected];
    
    NSURL *linkURLProfilePic = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", kPhotoponContentBase, object.profilePictureUrl]];
    
    UIImage *placeHolderImgProfilePic = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
    
    //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
    
    if (object.didFollowBool) {
        [cell.photoponBtnProfileFollowing setSelected:YES];
    }else{
        [cell.photoponBtnProfileFollowing setSelected:NO];
    }
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       object.profilePictureUrl = %@", object.profilePictureUrl);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       object.profilePictureUrl FULL = %@", [NSString stringWithFormat:@"%@%@", kPhotoponContentBase, object.profilePictureUrl]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*cell)weakCell = cell;
    //__weak __typeof(&*object)weakObject = object;
    
    
    [cell.photoponBtnUserImage.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLProfilePic] placeholderImage:placeHolderImgProfilePic success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        //[weakCell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson setImage:image forState:UIControlStateNormal];
        
        //UIImage* img = image;
        
        
        
        UIImage* smallImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];
        
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [weakCell.photoponBtnUserImage.imageView setImage:smallImage];
        
        //});
        
        //[weakCell fadeInView];
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //[PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 80.0f) mediaModel:object];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
        
        //});
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
    }];
    
    if(object.didFollowBool)
        [cell.photoponBtnProfileFollowing setSelected:YES];
    else
        [cell.photoponBtnProfileFollowing setSelected:NO];
    
}

- (PhotoponUsersTableViewCell *)newCellWithObject:(PhotoponUserModel*)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    NSString *cellIdentifier = [NSString stringWithFormat:@"_PhotoponUsersTableViewCellIdentifier"];
    PhotoponUsersTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [PhotoponUsersTableViewCell photoponUsersTableViewCellWithUserModel:object];
        cell.delegate = self;
    }
    return cell;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
