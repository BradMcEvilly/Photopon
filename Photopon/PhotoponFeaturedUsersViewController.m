//
//  PhotoponFeaturedUsersViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 8/20/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponFeaturedUsersViewController.h"
#import "PhotoponFeaturedUserCell.h"
#import "UIImage+ResizeAdditions.h"
#import "PhotoponUserModel.h"
#import "PhotoponAccountProfileViewController.h"
#import "PhotoponConstants.h"

static NSString *pFeaturedUserCellIdentifier = @"_PhotoponFeaturedUserCellIdentifier";

@interface PhotoponFeaturedUsersViewController ()

@end

@implementation PhotoponFeaturedUsersViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style entityName:kPhotoponMediaClassName];
    if (self) {
        
        
        // The className to query on
        [self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        
        
        // set api method vars
        [self.methodParams setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"user_models"] forKey:kPhotoponMethodReturnedModelsKey];
        // bp.getFollowers by default
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", @"bp.getFollowers"] forKey:kPhotoponMethodNameKey];
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
*/
- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
/*
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    
    
    CGFloat incrementVal = 80.0f;
    CGFloat product = incrementVal * 32.0f;
    CGRect tableViewFrame = CGRectMake(0.0f, 0.0f, 100.0f, product);
    
    self.tableView.frame = tableViewFrame;
    self.tableView.bounds = CGRectMake(0.0f, 0.0f, 100.0f, 480.0f);
    
    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.transform = rotateTable;
    self.tableView.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
    self.tableView.allowsSelection = YES;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    */
}

- (void)didReceiveMemoryWarning
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)objectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGFloat incrementVal = 80.0f;
    CGFloat product = incrementVal * 32.0f;
    CGRect tableViewFrame = CGRectMake(0.0f, 0.0f, 100.0f, product);
    
    self.tableView.frame = tableViewFrame;
    self.tableView.bounds = CGRectMake(0.0f, 0.0f, 100.0f, 480.0f);
    
    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.transform = rotateTable;
    self.tableView.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
    self.tableView.allowsSelection = YES;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
}*/

/*
- (PhotoponModel *)objectAtIndexPath:(NSIndexPath *)indexPath{
	return [PhotoponModel modelWithDictionary:[self.objects objectAtIndex:indexPath.row]];
}
*/

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 5.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 5.0f)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 5.0f)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}
*/
/*
- (id)objectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.section == 0) {
        return [self userObjectAtIndex:indexPath];
    }
	return [PhotoponModel modelWithDictionary:[self.objects objectAtIndex:indexPath.row]];
}

- (PhotoponUserModel*)userObjectAtIndex:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}
*/
- (void)configureCell:(PhotoponFeaturedUserCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(PhotoponUserModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    cell.photoponBtnProfileImagePerson.tag = indexPath.row;
    //[cell.photoponBtnProfileImagePerson setAlpha:0.0f];
    cell.photoponUserModel = object;
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       object.profilePictureUrl = %@", object.profilePictureUrl);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       object.profilePictureUrl FULL = %@", [NSString stringWithFormat:@"%@%@", kPhotoponContentBase, object.profilePictureUrl]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*cell)weakCell = cell;
    //__weak __typeof(&*object)weakObject = object;
    
    
    NSURL *linkURLProfilePic = [[NSURL alloc] initWithString:object.profilePictureUrl];
    
    UIImage *placeHolderImgProfilePic = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderProfileMedium.png"];
    
    [cell.photoponBtnProfileImagePerson.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLProfilePic] placeholderImage:placeHolderImgProfilePic success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        //[weakCell.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson setImage:image forState:UIControlStateNormal];
        
        //UIImage* img = image;
        
        
        
        UIImage* smallImage = [image thumbnailImage:80 transparentBorder:0 cornerRadius:6 interpolationQuality:kCGInterpolationLow];
        
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [weakCell.photoponBtnProfileImagePerson.imageView setImage:smallImage];
        
        
        //});
        
        //[weakCell fadeInView];
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //[PhotoponUtility cacheTimelineImageData:UIImageJPEGRepresentation(image, 80.0f) mediaModel:object];// processFacebookProfilePictureData: UIImageJPEGRepresentation(image, 100.0f)];
        
        //});
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
    }];
}

- (PhotoponFeaturedUserCell *)newCellWithObject:(PhotoponUserModel*)object {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    PhotoponFeaturedUserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:pFeaturedUserCellIdentifier];
    if (cell == nil) {
        cell = [PhotoponFeaturedUserCell photoponFeaturedUserCell:self];
    }
    
    return cell;
}

#pragma PhotoponFeaturedUserCellDelegate methods

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponFeaturedUserCell:(PhotoponFeaturedUserCell *)photoponFeaturedUserCell didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[button tag] inSection:0] animated:YES];
    
    PhotoponUserModel *usr = [self objectAtIndexPath:[NSIndexPath indexPathForRow:[button tag] inSection:0]];
    [self shouldPresentAccountViewForUser:usr];
}

@end
