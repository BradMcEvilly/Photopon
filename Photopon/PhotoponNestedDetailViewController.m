//
//  PhotoponNestedDetailViewController.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/30/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//
 
//#import "IIViewDeckController.h"

#import "PhotoponAppDelegate.h"
#import "PhotoponNestedDetailViewController.h"
#import "PhotoponTabBarController.h"

#import "PhotoponUserModel.h"
#import "PhotoponMediaModel.h"
#import "PhotoponCoordinateModel.h"
#import "PhotoponCouponModel.h"
#import "PhotoponTagModel.h"
#import "PhotoponImageModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponCommentModel.h"
#import "PhotoponAlertModel.h"

#import "PhotoponNavigationBar.h"

#define PHOTOPON_DETAIL_VIEW_TYPE_PROFILE
/*
@interface PhotoponNestedDetailViewController () <IIViewDeckControllerDelegate>


@property (nonatomic, retain) IBOutlet UILabel* counterLabel;
@property (nonatomic, retain) IBOutlet UILabel* disabledLabel;

@end
*/
@implementation PhotoponNestedDetailViewController

@synthesize scrollView;
@synthesize photoponDetailViewType;
@synthesize isTabBarController;

//@synthesize counterLabel = _counterLabel;
//@synthesize disabledLabel = _disabledLabel;

@synthesize photoponUserModel;
@synthesize photoponMediaModel;
@synthesize photoponCoordinateModel;
@synthesize photoponCouponModel;
@synthesize photoponTagModel;
@synthesize photoponImageModel;
@synthesize photoponPlaceModel;
@synthesize photoponCommentModel;
@synthesize photoponAlertModel;

@synthesize backBarButton;

@synthesize backNavButton;
@synthesize rightNavButton;

- (void) awakeFromNib{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"==============================================================");
    NSLog(@"PhotoponNestedDetailViewController :: awakeFromNib");
    NSLog(@"==============================================================");
    self.isTabBarController = [NSNumber numberWithBool:NO];
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSLog(@"==============================================================");
        NSLog(@"PhotoponNestedDetailViewController :: initWithNibName");
        NSLog(@"==============================================================");
        
        self.isTabBarController = [NSNumber numberWithBool:NO];
        
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
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[appDelegate.photoponTabBarViewController resetPhotoponNavigationBarFrame];
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if (IS_IPAD) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite-768.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    UIImage *imageBack=[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"];
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.bounds = CGRectMake( 0, 0, imageBack.size.width, imageBack.size.height );    
    [buttonBack setBackgroundImage:imageBack forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backNavButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItemBack = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    
    self.navigationItem.leftBarButtonItem = barButtonItemBack;
    /*
    // VIEWDECK NAVIGATION SETUP - RIGHT VIEW CONTROLLER NAV ITEM
    UIImage *image=[UIImage imageNamed:@"PhotoponNavBarBtnSave.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveHandler:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] retain];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    [self.navigationItem setTitle:@"Settings"];
    */
    
    
    
    
    /*
    [_counterLabel setText:[NSString stringWithFormat:@"%d", self.navigationController.viewControllers.count]];
    self.title = _counterLabel.text;
    if (self.viewDeckController)
        [_disabledLabel setText:(self.navigationController.viewControllers.count % 2 != 0 ? @"right disabled" : @"")];
    else
        [_disabledLabel setText:@"no viewdeck"];
    
    */
    
    
    
    
    NSLog(@"==============================================================");
    NSLog(@"PhotoponNestedDetailViewController :: viewDidLoad end");
    NSLog(@"==============================================================");
    
}

/*
-(BOOL)viewDeckControllerWillOpenRightView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
 
    / *
    switch ([self.photoponDetailViewType intValue]) {
        case PhotoponDetailControllerTypeProfilePerson:
            return YES;
            break;
        case PhotoponDetailControllerTypePhotopon:
            return NO;
            break;
        case PhotoponDetailControllerTypeProfilePlace:
            return YES;
            break;
        default:
            return NO;
            break;
    }
    * /
    
    switch ([self.photoponDetailViewType intValue]) {
        case PhotoponDetailControllerTypeProfilePerson:
            return YES;
            break;
        default:
            return NO;
            break;
    }
    
}

-(BOOL)viewDeckControllerWillCloseRightView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated {
    
    NSLog(@"==============================================================");
    NSLog(@"PhotoponNestedDetailViewController :: viewDeckControllerWillOpenRightView");
    NSLog(@"==============================================================");
    / *
    if ([self.isTabBarController boolValue]) {
        return NO;
    }
    * /
    
    switch ([self.photoponDetailViewType intValue]) {
        case PhotoponDetailControllerTypeProfilePerson:
            return YES;
            break;
        case PhotoponDetailControllerTypePhotopon:
            return NO;
            break;
        case PhotoponDetailControllerTypeProfilePlace:
            return YES;
            break;
        default:
            return NO;
            break;
    }
     * /
    
    switch ([self.photoponDetailViewType intValue]) {
        case PhotoponDetailControllerTypeProfilePerson:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

-(BOOL)viewDeckControllerWillOpenLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated{
    
    NSLog(@"==============================================================");
    NSLog(@"PhotoponNestedDetailViewController :: viewDeckControllerWillOpenLeftView");
    NSLog(@"==============================================================");
    
    
    //return [self.isTabBarController boolValue];    
    return NO;

}

-(BOOL)viewDeckControllerWillCloseLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated{
    
    NSLog(@"==============================================================");
    NSLog(@"PhotoponNestedDetailViewController :: viewDeckControllerWillCloseLeftView");
    NSLog(@"==============================================================");
    
    //return [self.isTabBarController boolValue];    
    return NO;
}

- (void)openContentDetailViewController:(id)sender {
    
    NSLog(@"==============================================================");
    NSLog(@"PhotoponNestedDetailViewController :: viewDeckControllerWillCloseLeftView");
    NSLog(@"==============================================================");
    
    PhotoponNestedDetailViewController* deeperController = [[PhotoponNestedDetailViewController alloc] initWithNibName:@"PhotoponNestedDetailViewController" bundle:nil];
    [self.navigationController pushViewController:deeperController animated:YES];
    

}


- (IBAction)goOnPressed:(id)sender {
    PhotoponNestedDetailViewController* deeperController = [[PhotoponNestedDetailViewController alloc] initWithNibName:@"PhotoponNestedDetailViewController" bundle:nil];
    [self.navigationController pushViewController:deeperController animated:YES];
}

- (IBAction)replaceLeftPressed:(id)sender {
    
    NSLog(@"==============================================================");
    NSLog(@"PhotoponNestedDetailViewController :: replaceLeftPressed");
    NSLog(@"==============================================================");
    
    if (!self.viewDeckController)
        return;
    
    PhotoponMoreTableViewController* leftController = [[PhotoponMoreTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    CGFloat red = (CGFloat)((arc4random() % 256) / 255.0);
    CGFloat green = (CGFloat)((arc4random() % 256) / 255.0);
    CGFloat blue = (CGFloat)((arc4random() % 256) / 255.0);
    leftController.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    self.viewDeckController.leftController = leftController;
    
}


- (IBAction)replaceRightPressed:(id)sender {
    
    
    if (!self.viewDeckController)
        return;
    
    PhotoponProfileInfoPanelViewController* rightController = [[PhotoponProfileInfoPanelViewController alloc] initWithNibName:@"PhotoponProfileInfoPanelViewController" bundle:nil];
    
    CGFloat red = (CGFloat)((arc4random() % 256) / 255.0);
    CGFloat green = (CGFloat)((arc4random() % 256) / 255.0);
    CGFloat blue = (CGFloat)((arc4random() % 256) / 255.0);
    rightController.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    self.viewDeckController.rightController = rightController;
     
}

- (IBAction)rightNavButtonHandler:(id)sender{
    [self.viewDeckController toggleRightViewAnimated:YES];
}
*/
- (IBAction)backNavButtonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];    
}











/*
 @implementation PhotoponNestedDetailViewController
 
 @synthesize level;
 @synthesize levelLabel;
 
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 self.level = 0;
 }
 return self;
 }
 
 #pragma mark - View lifecycle
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 self.levelLabel.text = [NSString stringWithFormat:@"Level %d", self.level];
 }
 
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 if (self.level == 1) {
 [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
 self.viewDeckController.view.frame = [[UIScreen mainScreen] applicationFrame];
 [self.viewDeckController.view setNeedsDisplay]; // .frame = self.viewDeckController.view.bounds;
 }
 }
 
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 if (self.level == 1) {
 [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
 self.viewDeckController.view.frame = [[UIScreen mainScreen] applicationFrame];
 [self.viewDeckController.view setNeedsDisplay]; // .frame = self.viewDeckController.view.bounds;
 }
 }
 
 - (void)hideOrShow {
 [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].isStatusBarHidden withAnimation:UIStatusBarAnimationSlide];
 }
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 // Return YES for supported orientations
 return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
 }
 
 - (IBAction)pressedGoDeeper:(id)sender {
 PhotoponNestedDetailViewController* photoponNestedDetailViewController = [[PhotoponNestedDetailViewController alloc] initWithNibName:@"PhotoponNestedDetailViewController" bundle:nil];
 photoponNestedDetailViewController.level = self.level + 1;
 
 [self.navigationController pushViewController:photoponNestedDetailViewController animated:YES];
 }
 
 @end
 */


-(void)dealloc{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}



@end


