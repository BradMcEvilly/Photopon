//
//  PhotoponSnipsViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 9/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponSnipsViewController.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponTabBarController.h"
#import "PhotoponUploadHeaderView.h"

@interface PhotoponSnipsViewController ()

@end

@implementation PhotoponSnipsViewController

@synthesize uploadHeaderView;

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

- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:211.0f green:214.0f blue:219.0f alpha:1.0f]];
    
    
    //[self.activityImageView setFrame:CGRectMake( (CGFloat)[UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
    
    
    //[self.view setFrame:CGRectMake( (CGFloat)[UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    
    //UIImage *photoponTitleImage = [UIImage imageNamed:@"PhotoponLogoNavBar.png"];
    
    UIImageView *photoponTitleImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoponLogoNavBar.png"]];
    //[self.navigationController.navigationBar addSubview:photoponTitleImageView];
    [self.navigationItem setTitleView:photoponTitleImageView];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void) addUploadHeader{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.tableView beginUpdates];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!weakSelf.uploadHeaderView) {
            weakSelf.uploadHeaderView = [PhotoponUploadHeaderView initPhotoponUploadHeaderView];
            [weakSelf.uploadHeaderView setDelegate:weakSelf];
            
            [[[PhotoponMediaModel newPhotoponDraft] photoponMediaImageFile] setPhotoponUploadHeaderView:self.uploadHeaderView];
        }
        
        NSLog(@"UploadHeaderView init here");
        
        weakSelf.tableView.tableHeaderView = weakSelf.uploadHeaderView;
        
    });
    
    [weakSelf.tableView endUpdates];
    
}

- (void) removeUploadHeaderReload:(BOOL)reload{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.tableView beginUpdates];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf.tableView.tableHeaderView = nil;
        
        if (weakSelf.uploadHeaderView) {
            [weakSelf.uploadHeaderView removeFromSuperview];
            weakSelf.uploadHeaderView = nil;
            [weakSelf.uploadHeaderView setDelegate:weakSelf];
        }
        
        [weakSelf.tableView endUpdates];
        
        if (reload)
            [weakSelf reloadInBackground];
    });
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
    
}
/*
 -(void)viewDidAppear:(BOOL)animated{
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 
 PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
 
 
 //if (appDelegate.pmm.isSyncingHome) {
 //    return;
 //appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
 //appDelegate.hud.labelText = NSLocalizedString(@"Loading", nil);
 
 //}
 
 
 
 
 //[appDelegate.hud show:YES];
 
 
 
 }*/

-(void)willReloadViewWithData{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // dismiss HUD
    
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
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - PhotoponUploadHeaderViewDelegate methods

- (void)photoponUploadHeaderView:(PhotoponUploadHeaderView *)photoponUploadHeaderView didTapCancelUploadButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self removeUploadHeaderReload:NO];
    [PhotoponMediaModel clearNewPhotoponDraft];
}

- (void)photoponUploadHeaderView:(PhotoponUploadHeaderView *)photoponUploadHeaderView didTapRetryUploadButton:(UIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.tableView beginUpdates];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [photoponUploadHeaderView setupDefaultNeedsDisplay:YES];
        
        [[PhotoponMediaModel newPhotoponDraft] uploadWithSuccess:^{
            
            [weakSelf removeUploadHeaderReload:YES];
            
        }failure:^(NSError*error){
            
            //[[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] uploadHeaderView] configureFailedView];
            //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] uploadHeaderView].photoponMediaPhotoUploadStatus.text = @"Failed";
            
            [self.uploadHeaderView configureFailedView];
            self.uploadHeaderView.photoponMediaPhotoUploadStatus.text = @"Failed";
            
            NSLog(@"=---------->        ERROR DESCRIPTION: %@", error.description);
            
        }];
        
        [weakSelf.tableView endUpdates];
        
    });
    
}


@end
