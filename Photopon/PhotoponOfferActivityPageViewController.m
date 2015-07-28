//
//  PhotoponOfferActivityPageViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 8/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponOfferActivityPageViewController.h"
#import "MBProgressHUD.h"



static NSString *tapInstructionText = @"TAP to EDIT";
static NSString *swipeInstructionTextLeft = @"SWIPE";
static NSString *swipeInstructionTextRight = @"TO CHANGE COUPON";
static NSString *locatingCouponsStatusText = @"Locating Coupons";

@interface PhotoponOfferActivityPageViewController () <MBProgressHUDDelegate> {
    
}

//@property (nonatomic, assign) BOOL hasMore;
//@property (nonatomic, assign) NSUInteger currentOffset;
//@property (nonatomic, strong, readwrite) NSMutableArray *objects;
//@property (nonatomic, strong) NSMutableArray * orSkip;


@property (nonatomic, strong) MBProgressHUD *HUD;

//@property (nonatomic, strong) UIView *noResultsView;

- (void)configureNoResultsView;

@end



@implementation PhotoponOfferActivityPageViewController

@synthesize HUD;

@synthesize photoponProgressHUDContainer;

@synthesize photoponStatusText;

@synthesize photoponSwipeLabelLeft;
@synthesize photoponSwipeLabelLeftText;
@synthesize photoponSwipeLabelRight;
@synthesize photoponSwipeLabelRightText;
@synthesize photoponTapLabel;
@synthesize photoponTapLabelText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Photopon offers stuff
        
        //self.photoponStatusText = [[NSString alloc] initWithFormat:@"%@", @"Loading Coupons"];
        
        self.photoponStatusText = nil;
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalOffers:) name:PhotoponNotificationDidReceiveLocalOffers object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    self.photoponTapLabel.text = tapInstructionText;
    self.photoponSwipeLabelLeft.text = swipeInstructionTextLeft;
    self.photoponSwipeLabelRight.text = swipeInstructionTextRight;
    
    [self initHUD];
    [self showHUD];
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
    
    //if (self.HUD.isHidden)
        //[self showHUD];
    
    //[self showHUD];
    
    
    
    
    /*
    loadingHUD.mode = MBProgressHUDModeCustomView;
    loadingHUD.labelText = nil;
    loadingHUD.detailsLabelText = nil;
    UIView *customView = [[UIView alloc] initWithFrame:self.view.bounds]; // Set a size
    // Add stuff to view here
    loadingHUD.customView = customView;
    [HUD show:YES];
    */
    
    
    
    
    
    
    
    self.photoponTapLabel.text = tapInstructionText;
    self.photoponSwipeLabelLeft.text = swipeInstructionTextLeft;
    self.photoponSwipeLabelRight.text = swipeInstructionTextRight;
    
    if ([self.HUD.detailsLabelText isEqualToString:locatingCouponsStatusText]) {
        if (self.photoponStatusText && self.photoponStatusText.length>0)
            [self updateHUDWithStatusText:self.photoponStatusText];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalOffers:) name:PhotoponNotificationDidReceiveLocalOffers object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    
    self.photoponTapLabel.text = tapInstructionText;
    self.photoponSwipeLabelLeft.text = swipeInstructionTextLeft;
    self.photoponSwipeLabelRight.text = swipeInstructionTextRight;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // addObserver:self selector:@selector(didReceiveLocalOffers:) name:PhotoponNotificationDidReceiveLocalOffers object:nil];
    
}

- (void)didReceiveLocalOffers:(NSNotification*)note{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self updateHUDWithStatusText:@"Finishing"];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCropImage:) name:PhotoponNotificationDidCropImage object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidCropImage object:nil userInfo:nil];
    
}

#pragma mark - HUD methods

- (void) initHUD {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.photoponProgressHUDContainer];
	[self.photoponProgressHUDContainer addSubview:HUD];
	HUD.delegate = self;
    
    if (self.photoponStatusText && self.photoponStatusText.length>0)
        HUD.labelText = self.photoponStatusText;
    else
        HUD.labelText = locatingCouponsStatusText;
    
    
    
    
    
    /*
    HUD.labelText = @"PLEASE WAIT";
    HUD.detailsLabelText = @"Loading Coupons";
     */
    
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
        status = locatingCouponsStatusText;
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
        status = locatingCouponsStatusText;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
