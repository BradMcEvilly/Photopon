//
//  PhotoponUsersTableViewCellController.m
//  Photopon
//
//  Created by Bradford McEvilly on 5/12/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//
/*
#import "PhotoponUsersTableViewCellController.h"
#import "PhotoponFollowersTableViewDataSource.h"
#import "PhotoponFollowingTableViewDataSource.h"
#import "PhotoponPhotoponsTableViewDataSource.h"
#import "PhotoponRedeemedTableViewDataSource.h"
#import "PhotoponUsersTableViewController.h"
#import "PhotoponDetailViewController.h"
#import "PhotoponUITableViewCell.h"
#import "PhotoponAppDelegate.h"
#import "DateUtils.h"

#import "PhotoponProfileViewController.h"
#import "PhotoponTabBarViewController.h"

#import "PhotoponActivityTableViewDataSource.h"
#import "PhotoponFeedItemModalViewController.h"
#import "PhotoponTableViewControllerSubclass.h"
#import "PhotoponFeedItemsTableViewController.h"
#import "PhotoponFeedItemsTableViewDataSource.h"
#import "PhotoponFeedItemActivityTableViewController.h"
*/

@implementation PhotoponUsersTableViewCellController
/*
@synthesize photoponUserCell = photoponUserCell_;
//@synthesize photoponUsersTableViewCellController = photoponUsersTableViewCellController_;
// profile info objects - person
@synthesize photoponBtnProfileImagePerson;
@synthesize photoponBtnProfileNamePerson;
@synthesize photoponBtnFollow;

@synthesize photoponUserTitle;
@synthesize isFollowing;
@synthesize controller = controller_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //if (self.photoponUserModel) {
            
        //}
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    @try
    {
        
        NSLog(@"PhotoponUsersTableViewCellController :: viewDidLoad :: @try{ ");
        [self.photoponBtnProfileNamePerson setTitle:self.photoponUserModel.fullname forState:UIControlStateNormal];
        [self.photoponBtnProfileNamePerson setTitle:self.photoponUserModel.fullname forState:UIControlStateSelected];
        [self.photoponBtnProfileNamePerson setTitle:self.photoponUserModel.fullname forState:UIControlStateHighlighted];
        
        //[self.photoponBtnProfileNamePerson.titleLabel setText:self.photoponUserModel.fullname];
        [self.photoponBtnProfileImagePerson setImageWithURL:[NSURL URLWithString:self.photoponUserModel.profilePictureUrl]];
        
        NSString *followStr = [[NSString alloc] initWithString:@"1"];
        
        if ([self.photoponUserModel.didFollowString isEqualToString:followStr]) {
            [self.photoponBtnFollow setSelected:YES];
        }else{
            [self.photoponBtnFollow setSelected:NO];
        }
        [followStr release];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"PhotoponUsersTableViewCellController :: viewDidLoad :: @catch (NSException *exception) ");
        
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        
        
        return;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog(@"PhotoponUsersTableViewCellController :: viewDidLoad :: @finally ");
        NSLog( @"In finally block");
        
    }
    
    [self setIsAccessibilityElement:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    [self.photoponBtnProfileNamePerson setTitle:self.photoponUserModel.fullname forState:UIControlStateNormal];
    [self.photoponBtnProfileNamePerson setTitle:self.photoponUserModel.fullname forState:UIControlStateSelected];
    [self.photoponBtnProfileNamePerson setTitle:self.photoponUserModel.fullname forState:UIControlStateHighlighted];
    
    //[self.photoponBtnProfileNamePerson.titleLabel setText:self.photoponUserModel.fullname];
    [self.photoponBtnProfileImagePerson setImageWithURL:[NSURL URLWithString:self.photoponUserModel.profilePictureUrl]];
    
    NSString *followStr = [[NSString alloc] initWithString:@"1"];
    
    if ([self.photoponUserModel.didFollowString isEqualToString:followStr]) {
        [self.photoponBtnFollow setSelected:YES];
    }else{
        [self.photoponBtnFollow setSelected:NO];
    }
    [followStr release];
        
}

- (void)viewDidUnload
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}





// Profile Info Button Handlers
-(IBAction)photoponBtnProfileImagePersonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    PhotoponProfileViewController *photoponProfileViewController = [[[PhotoponProfileViewController alloc] initWithUserModel:self.photoponUserModel] retain];
    
    [appDelegate.photoponTabBarViewController.viewDeckController toggleRightViewAnimated:YES];
    
    [appDelegate.photoponTabBarViewController showNestedDetailViewController:photoponProfileViewController];
    
}

-(IBAction)photoponBtnProfileNamePersonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    PhotoponProfileViewController *photoponProfileViewController = [[[PhotoponProfileViewController alloc] initWithUserModel:self.photoponUserModel] retain];
    
    [appDelegate.photoponTabBarViewController.viewDeckController toggleRightViewAnimated:YES];
    
    [appDelegate.photoponTabBarViewController showNestedDetailViewController:photoponProfileViewController];
    
}

-(IBAction)photoponBtnFollowHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"CALLING:    if ([self.photoponUserModel didFollowBool]) {");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    
    NSString *followStr = [[NSString alloc] initWithString:@"1"];
    NSString *unfollowStr = [[NSString alloc] initWithString:@"0"];
    
    /*
    if ([self.photoponUserModel.didFollowString isEqualToString:followStr]) {
        [self.photoponBtnFollow setSelected:YES];
    }else{
        [self.photoponBtnFollow setSelected:NO];
    }
    [followStr release];
    * /
    
    if ([self.photoponUserModel.didFollowString isEqualToString:followStr]) {
        
        [self.photoponBtnFollow setSelected:NO];
        
        // update local client model
        [self.photoponUserModel setDidFollowBool:NO];
        [self.photoponUserModel setDidFollowString:unfollowStr];
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"CALLING:    if ([self.photoponUserModel didFollowBool]) {");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // then send event to server method bp.postUnlike
        // bp.postUnlike
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
            
            [self.controller.photoponFeedItemsTableViewDataSource syncPhotoponUnfollowWithIndexPath:self.photoponIndexPath success:^{
                
                // silence is golden
                
                
                
                
            } failure:^(NSError *error) {
                
                [self.photoponBtnFollow setSelected:YES];
                // update local client model
                [self.photoponUserModel setDidFollowBool:YES];
                [self.photoponUserModel setDidFollowString:followStr];
                
            }];
            
        });
        
    }else{
        
        [self.photoponBtnFollow setSelected:YES];
        
        // update local client model
        [self.photoponUserModel setDidFollowBool:YES];
        [self.photoponUserModel setDidFollowString:followStr];
        
        // then send event to server method bp.postLike
        // bp.postLike
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
            
            [self.controller.photoponFeedItemsTableViewDataSource syncPhotoponFollowWithIndexPath:self.photoponIndexPath success:^{
                
                // silence is golden
                
            } failure:^(NSError *error) {
                
                [self.photoponBtnFollow setSelected:NO];
                // update local client model
                [self.photoponUserModel setDidFollowBool:NO];
                [self.photoponUserModel setDidFollowString:unfollowStr];
                
                
            }];
            
        });
        
    }
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            END END END", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    

}

-(void)dealloc{
    
    [photoponUserCell_ release];
    // profile info objects - person
    [photoponBtnProfileImagePerson release];
    [photoponBtnProfileNamePerson release];
    [photoponBtnFollow release];
    [photoponUserTitle release];
    
    [isFollowing release];
    
    [super dealloc];
}*/

@end
