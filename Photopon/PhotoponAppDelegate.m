//
//  PhotoponAppDelegate.m
//  Photopon
//
//  Created by Brad McEvilly on 5/5/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PhotoponAppDelegate.h"
#import "Reachability.h"
#import "PhotoponWelcomeViewController.h"
#import "PhotoponLogInViewController.h"
#import "PhotoponHomeViewController.h"
#import "PhotoponExploreViewController.h"
#import "PhotoponActivityViewController.h"
#import "PhotoponMediaDetailsViewController.h"
#import "PhotoponAccountProfileViewController.h"

#import "PhotoponHowItWorksTutorialViewController.h"
#import "PhotoponExplanationLocationServicesViewController.h"
#import "PhotoponSnipTutorialViewController.h"

#import "PhotoponComApi.h"
#import "SoundUtil.h"
#import "SFHFKeychainUtils.h"
#import <Crashlytics/Crashlytics.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PhotoponNavigationBar.h"
#import "PhotoponConstants.h"

#import "PhotoponModelManager.h"
#import "PhotoponCoordinateModel.h"
#import "PhotoponNavigationViewController.h"
#import "PhotoponUITextField.h"
#import "PhotoponUtility.h"
#import "iRate.h"

// FLAT UI KIT
#import "UIColor+FlatUI.h"
#import "UISlider+FlatUI.h"
#import "UIStepper+FlatUI.h"
#import "UITabBar+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIProgressView+FlatUI.h"
#import "FUISegmentedControl.h"
#import "UIPopoverController+FlatUI.h"
#import "PhotoponHowItWorksIntroPageViewController.h"


//#import "PhotoponUserModel.h"

@interface PhotoponAppDelegate () {
    NSMutableData *_data;
    BOOL firstLaunch;
}



//@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@property (nonatomic, strong) NSNumber *isUserLoggedInNumber;

- (void)setupAppearance;
- (BOOL)shouldProceedToMainInterface:(PhotoponUserModel *)user;
- (BOOL)handleActionURL:(NSURL *)url;
@end

@implementation PhotoponAppDelegate{
    PhotoponModelManager *_pmm;
    PhotoponLogInViewController *_loginViewController;
    //MBProgressHUD *_hud;
}

@synthesize isPcomAuthenticated;
@synthesize isUploadingPost;

@synthesize session = _session;

@synthesize instagram = _instagram;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize window;
@synthesize navController;
@synthesize tabBarController;
@synthesize networkStatus;

@synthesize homeViewController;
@synthesize activityViewController;
@synthesize welcomeViewController;
//@synthesize loginViewController;

@synthesize photoponHowItWorksIntroPageViewController;
@synthesize photoponHowItWorksTutorialViewController;
@synthesize photoponSnipTutorialViewController;
@synthesize photoponExplanationLocationServicesViewController;

//@synthesize hud;
@synthesize autoFollowTimer;

@synthesize hostReach;
@synthesize internetReach;
@synthesize wifiReach;

@synthesize pComApi;
@synthesize photoponUserModel;

@synthesize connectionAvailable, pcomAvailable, currentPhotoponAvailable, pcomReachability, internetReachability, currentPhotoponReachability;

//@synthesize pmm;
//@synthesize profileViewController;

@synthesize photoponCoordinateModel;
@synthesize locationManager;
@synthesize isUpdatingLocationNumber;

@synthesize profileImageView;
@synthesize shouldShowNewCompNumber;
@synthesize shouldShowSnipTutorialNumber;

@synthesize shouldShowHowItWorksNumber;

+ (void)initialize
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //configure iRate
    //[iRate sharedInstance].applicationBundleID          = kAppStoreURL;
    [iRate sharedInstance].appStoreID                   = kAppStoreID;
    [iRate sharedInstance].message                      = kAppReviewMessage;
    [iRate sharedInstance].onlyPromptIfLatestVersion    = YES;
    [iRate sharedInstance].daysUntilPrompt              = 4;
    [iRate sharedInstance].usesUntilPrompt              = 8;
    
    
    
    //enable preview mode
    //[iRate sharedInstance].previewMode = YES;
    
}

+ (PhotoponAppDelegate *)sharedPhotoponApplicationDelegate {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)isTall{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    return [PhotoponUtility isTallScreen];
}

- (void)customizeAppearance{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    // Customing the segmented control
    UIImage *segmentSelected =
    [[UIImage imageNamed:@"PhotoponSegmentedControl_On.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentUnselected =
    [[UIImage imageNamed:@"PhotoponSegmentedControl_Off.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentSelectedUnselected =
    [UIImage imageNamed:@"PhotoponSegmentedControl_On-Off.png"];
    UIImage *segUnselectedSelected =
    [UIImage imageNamed:@"PhotoponSegmentedControl_Off-On.png"];
    UIImage *segmentUnselectedUnselected =
    [UIImage imageNamed:@"PhotoponSegmentedControl_Off-Off.png"];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance]
     setDividerImage:segUnselectedSelected
     forLeftSegmentState:UIControlStateNormal
     rightSegmentState:UIControlStateSelected
     barMetrics:UIBarMetricsDefault];
    
    [[UISearchBar appearance] setScopeBarButtonBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal];
    [[UISearchBar appearance] setScopeBarButtonBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected];
    
    [[UISearchBar appearance] setScopeBarButtonDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal];
    [[UISearchBar appearance] setScopeBarButtonDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal];
    [[UISearchBar appearance] setScopeBarButtonDividerImage:segUnselectedSelected
     forLeftSegmentState:UIControlStateNormal
     rightSegmentState:UIControlStateSelected];
    
    
    
    
    if (IS_IPAD) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite-768.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UITableView appearance] setBackgroundColor:TABLE_VIEW_BACKGROUND_COLOR]; //[UIColor colorWithRed:211.0f green:214.0f blue:219.0f alpha:1.0f]];
    
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[[UITableViewCell appearance] setSelectedMentionTextColor:TABLE_VIEW_CELL_ON_TEXT_COLOR];
    //[[UITableViewCell appearance] setSelectedLinkTextColor:TABLE_VIEW_CELL_ON_TEXT_COLOR];
    //[[UITableViewCell appearance] setTitleColor:TABLE_VIEW_CELL_OFF_TEXT_COLOR forState:UIControlStateNormal];
    //[[UITableViewCell appearance] setTitleColor:TABLE_VIEW_CELL_ON_TEXT_COLOR forState:UIControlStateHighlighted];
    //[[UITableViewCell appearance] setTitleColor:TABLE_VIEW_CELL_ON_TEXT_COLOR forState:UIControlStateSelected];
    
    [[UITableViewCell appearance] setBackgroundColor:TABLE_VIEW_BACKGROUND_COLOR];
    
    
    // Customing text field
    UIImage *textFieldBackgroundImage =
    [[UIImage imageNamed:@"PhotoponTextField.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 5.0, 15.0, 5.0)];
    
    //[[UITextField appearance] setTextField:[[[PhotoponUITextField alloc]]];// setBackground:textFieldBackgroundImage];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:textFieldBackgroundImage forState:UIControlStateNormal];
    //[[UISearchBar appearance] setSearchScopes:[[NSArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopePeople], [[NSString alloc] initWithFormat:@"%@", kPhotoponSearchScopeHashtags], nil]];
    
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    SEGMENTED_CONTROL_OFF_TEXT_COLOR, UITextAttributeTextColor,
                                                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                    [NSValue valueWithCGSize:CGSizeZero], UITextAttributeTextShadowOffset,
                                                                    [UIFont boldSystemFontOfSize:13.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    SEGMENTED_CONTROL_ON_TEXT_COLOR, UITextAttributeTextColor,
                                                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                    [NSValue valueWithCGSize:CGSizeZero], UITextAttributeTextShadowOffset,
                                                                    [UIFont boldSystemFontOfSize:13.0], UITextAttributeFont,nil] forState:UIControlStateHighlighted];
    
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    SEGMENTED_CONTROL_ON_TEXT_COLOR, UITextAttributeTextColor,
                                                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                    [NSValue valueWithCGSize:CGSizeZero], UITextAttributeTextShadowOffset,
                                                                    [UIFont boldSystemFontOfSize:12.0], UITextAttributeFont,nil] forState:UIControlStateSelected];
    
    
    
    // Customing the bar button item
    UIImage *barButtonItemImageOn =
    [[UIImage imageNamed:@"PhotoponBarButtonItem_On.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *barButtonItemImageOff =
    [[UIImage imageNamed:@"PhotoponBarButtonItem_Off.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonItemImageOff
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonItemImageOn
                                            forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonItemImageOn
                                            forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    BAR_BUTTON_ITEM_OFF_TEXT_COLOR, UITextAttributeTextColor,
                                                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                    [NSValue valueWithCGSize:CGSizeZero], UITextAttributeTextShadowOffset,
                                                                    [UIFont boldSystemFontOfSize:13.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void) initFirstTimeUserChecksHowItWorks{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.shouldShowHowItWorks       = NO;
    
    /**
     *  Show how it works if new user
     */
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pcom_show_hiw_preference"] == nil) {
        self.shouldShowHowItWorks = YES;
    }

}

- (void) initFirstTimeUserChecks{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.shouldShowNewComp          = NO;
    self.shouldShowSnipTutorial     = NO;
    
    /**
     *  Show new composition if new user
     */
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pcom_show_new_comp_preference"] == nil) {
        //NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_username_preference"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_show_new_comp_preference"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         self.shouldShowNewComp = YES;
    }
    
    /**
     *  Show snip tutorial if new user
     */
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pcom_show_snip_tutorial_preference"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_show_snip_tutorial_preference"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.shouldShowSnipTutorial = YES;
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self initFirstTimeUserChecksHowItWorks];
    
    [self customizeAppearance];
    
#ifdef TESTING
    /* deprecated:
    //[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    //[TestFlight takeOff:@"23074a714132bade12c3b86d6630f6ab_MTExMjA1MjAxMi0wNy0xNyAxMjowMzozNy4zNjc3NDM"];
    //[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    */
    
    [TestFlight takeOff:@"6353f5aa-ee4e-4d1d-a8f6-ffc46b736dc5"];
    
#endif
    
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            FONT FAMILIES - BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
            
        }
    }
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            FONT FAMILIES - END", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    /*
    // DEBUG
    [PhotoponUserModel logOut];
    [self.session closeAndClearTokenInformation];
    return YES;
    */
    
    [self setUpLocationManager];
    
    [FBProfilePictureView class];
    
    [Crashlytics startWithAPIKey:@"9ba682883df8a46fb2bd7866606f565c7473f659"];
    
    [PhotoponParser setApplicationId:kPhotoponComXMLRPCUrl clientKey:@"66e5977931c7e48aa89c9da0ae5d3ffdff7f1a58e6819cbea062dda1fa050296"];
    
    NSError *error;
    
    [SFHFKeychainUtils storeUsername:kPhotoponGuestUsername andPassword:@"F3CrRi64IaOS4KdE84tCB594Fr3CrErG875TaOS8Kd093v84XirZ1YxD" forServiceName:@"Photopon.com" updateExisting:YES error:&error];
    
    [PhotoponMediaModel clearNewPhotoponDraft];
    
    // init isloggedin - defsaults to NO
    //self.isUserLoggedIn = NO;//[PhotoponUserModel isLoggedIn];
    //self.isUserLoggedIn = [PhotoponUserModel isLoggedIn];
    //_loginViewController = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidLogInFacebookUser) name:PhotoponAppDelegateApplicationDidLogInFacebookUserNotification object:nil];
    
    /*
    // send logged in Photopon user notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidAttemptLogIn:) name:PhotoponAppDelegateApplicationDidAttemptLogInNotification object:nil];
    // add logged in FB user observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidLogInFacebookUser:) name:PhotoponAppDelegateApplicationDidLogInFacebookUserNotification object:nil];
    
    // send logged in Photopon user notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidLogInPhotoponUser:) name:PhotoponAppDelegateApplicationDidLogInPhotoponUserNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidCompleteLogIn:) name:PhotoponAppDelegateApplicationDidCompleteLogInNotification object:nil];
    */
    
    
    /*
    [self.hud showWhileExecuting:@selector(logOut) onTarget:self withObject:nil animated:YES];
    
    [self.hud showWhileExecuting:@selector(presentTabBarController) onTarget:self withObject:nil animated:YES];
    
    [self.hud showWhileExecuting:@selector(loginViewFetchedUserInfo:user:) onTarget:self.loginViewController withObject:nil animated:YES];
    
    [self.hud showWhileExecuting:@selector(checkIfUserExistsInBackground) onTarget:self.loginViewController withObject:nil animated:YES];
    */
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self setupReachability];
    
    
    
    [self setupUserAgent];
    
    
    self.instagram = [[Instagram alloc] initWithClientId:kInstagramAppID
                                                delegate:nil];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor clearColor];
    
    self.welcomeViewController = [[PhotoponWelcomeViewController alloc] init];
    
    self.navController = [[PhotoponNavigationViewController alloc] initWithRootViewController:self.welcomeViewController];
    self.navController.navigationBarHidden = YES;
    
    /*
    self.hud = [[MBProgressHUD alloc] initWithView:self.navController.view];
    [self.navController.view addSubview:self.hud];
    self.hud.labelText = @"Initializing";
    */
    
    
    self.window.rootViewController = self.navController;
    
    
    
    //[self.window addSubview:self.hud];
    
    
    
    
    [self.window makeKeyAndVisible];
    
    //self.hud = [MBProgressHUD showHUDAddedTo:self.navController.presentedViewController.view animated:NO];//[[MBProgressHUD alloc] initWithWindow:self.window];//[MBProgressHUD showHUDAddedTo:window animated:NO];
    
    return YES;
}

- (void)presentTutorialHowItWorks{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponHowItWorksIntroPageViewController) {
        if (IS_IPAD) {
            self.photoponHowItWorksIntroPageViewController = [[PhotoponHowItWorksIntroPageViewController alloc] initWithNibName:@"PhotoponHowItWorksIntroPageViewController-iPad" bundle:nil];
        }else{
            self.photoponHowItWorksIntroPageViewController = [[PhotoponHowItWorksIntroPageViewController alloc] initWithNibName:@"PhotoponHowItWorksIntroPageViewController" bundle:nil];
        }
    }
    
    [self.navController pushViewController:self.photoponHowItWorksIntroPageViewController animated:YES];
    
    /*
    if (!self.photoponHowItWorksTutorialViewController) {
        self.photoponHowItWorksTutorialViewController = [[PhotoponHowItWorksTutorialViewController alloc] initWithNibName:@"PhotoponHowItWorksTutorialViewController" bundle:nil];
    }
    
    [self.navController pushViewController:self.photoponHowItWorksTutorialViewController animated:YES];
    */
}

- (void)dismissTutorialHowItWorks{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_username_preference"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_show_hiw_preference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.photoponHowItWorksIntroPageViewController dismissViewControllerAnimated:NO completion:^{
        [self.navController popViewControllerAnimated:YES];
    }];
    
    
    
    /*
    if (![NSThread isMainThread]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            NOT ON MAIN THREAD", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self performSelectorOnMainThread:@selector(dismissTutorialSnipOnMainThread) withObject:[[PhotoponMediaModel newPhotoponDraft] croppedImage] waitUntilDone:NO];
	} else {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            YES, IS ON MAIN THREAD", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
		[self dismissTutorialHowItWorks];
	}
     */
}

- (void)presentTutorialSnip{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    if (!self.photoponSnipTutorialViewController) {
        self.photoponSnipTutorialViewController = [[PhotoponSnipTutorialViewController alloc] initWithNibName:@"PhotoponSnipTutorialViewController" bundle:nil];
        
        
        
    }
    /*
    if (!self.photoponExplanationLocationServicesViewController) {
        self.photoponExplanationLocationServicesViewController = [[PhotoponExplanationLocationServicesViewController alloc] initWithNibName:@"PhotoponExplanationLocationServicesViewController" bundle:nil];
    }
    */
    [self.tabBarController presentViewController:self.photoponSnipTutorialViewController animated:YES completion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self.tabBarController presentViewController:self.photoponSnipTutorialViewController animated:YES completion:^{", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        /*
        [self.photoponSnipTutorialViewController presentViewController:self.photoponExplanationLocationServicesViewController animated:YES completion:^{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.tabBarController presentViewController:self.photoponSnipTutorialViewController animated:YES completion:^{", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            
        }];
        */
        
    }];
    
    
}

- (void)dismissTutorialSnip{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            NOT ON MAIN THREAD", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self performSelectorOnMainThread:@selector(dismissTutorialSnipOnMainThread) withObject:[[PhotoponMediaModel newPhotoponDraft] croppedImage] waitUntilDone:NO];
	} else {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            YES, IS ON MAIN THREAD", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
		[self dismissTutorialSnipOnMainThread];
	}
}

- (void)dismissTutorialSnipOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    [self.tabBarController dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self.tabBarController.navigationController dismissViewControllerAnimated:YES completion:^{", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self switchLocationManagerOn];
        self.photoponSnipTutorialViewController = nil;
    }];
    */
    
    [self.tabBarController dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self.tabBarController.navigationController dismissViewControllerAnimated:YES completion:^{", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self presentExplanationLocationServices];
        self.photoponSnipTutorialViewController = nil;
        
    }];
}

- (void)presentExplanationLocationServicesWithAlert{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if (!self.photoponExplanationLocationServicesViewController) {
        self.photoponExplanationLocationServicesViewController = [[PhotoponExplanationLocationServicesViewController alloc] initWithNibName:@"PhotoponExplanationLocationServicesViewController" bundle:nil];
    }
    
    [self.navController presentViewController:self.photoponExplanationLocationServicesViewController animated:YES completion:^{
        
        UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                             message:[NSString stringWithFormat:@"To re-enable, please go to Settings and turn on Location Service for this app."]
                                                            delegate:[PhotoponAppDelegate sharedPhotoponApplicationDelegate]
                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                   otherButtonTitles:nil];
        [alertCheck show];
        
    }];*/
    
}

- (void)presentExplanationLocationServices{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponExplanationLocationServicesViewController) {
        self.photoponExplanationLocationServicesViewController = [[PhotoponExplanationLocationServicesViewController alloc] initWithNibName:@"PhotoponExplanationLocationServicesViewController" bundle:nil];
    }
    
    [self.welcomeViewController presentViewController:self.photoponExplanationLocationServicesViewController animated:YES completion:nil];
    
}

- (void)dismissExplanationLocationServices{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    
    [self.welcomeViewController dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self.tabBarController.navigationController dismissViewControllerAnimated:YES completion:^{", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        self.photoponExplanationLocationServicesViewController = nil;
        [self presentTabBarController];
        
    }];
}

-(BOOL) isUserLoggedIn{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.isUserLoggedInNumber boolValue];
    //return [PhotoponUserModel isLoggedIn];
}

-(void) setIsUserLoggedIn:(BOOL)isUserLoggedIn{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.isUserLoggedInNumber = [[NSNumber alloc] initWithBool:isUserLoggedIn];
}

- (void)applicationDidLogInPhotoponUser {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self.hud.labelText = NSLocalizedString(@"Preparing Feeds", nil);
    //[self.hud showWhileExecuting:@selector(presentTabBarController) onTarget:self withObject:nil animated:NO];
    
}

- (void)applicationDidLogInFacebookUser {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"--------->          [PhotoponUtility facebookProfilePicLinkURL] = %@", [PhotoponUtility facebookProfilePicLinkURL]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self.profileImageView = [[UIImageView alloc] init];
    
    
    [self.window addSubview:self.profileImageView];
    
    [self.profileImageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:[PhotoponUtility facebookProfilePicLinkURL]] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            self.profileImageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:[PhotoponUtility facebookProfilePicLinkURL]] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){ SUCCESS SUCCESS", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //[weakSelf.profileImageView setImage:image];
        [PhotoponUtility processFacebookProfilePictureData: image];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            self.profileImageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:[PhotoponUtility facebookProfilePicLinkURL]] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){ FAIL FAIL FAIL", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
    }];
    
}
/*

- (void)applicationDidAttemptLogIn{
 
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
    //[MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
 
    self.hud = [MBProgressHUD showHUDAddedTo:self.navController.visibleViewController.view animated:NO];
    self.hud.dimBackground = YES;
    self.hud.labelText = NSLocalizedString(@"Loading", nil);
    
    
}

- (void)applicationDidCompleteLogIn{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
    [MBProgressHUD hideHUDForView:self.navController.visibleViewController.view animated:YES];
    
    self.isUserLoggedIn = YES;
    
}*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[EGOCache globalCache] removeCacheForKey:kPhotoponUserAttributesCurrentUserKey];
    
    
    //Keep the app alive in the background if we are uploading a post, currently only used for quick photo posts
    UIApplication *app = [UIApplication sharedApplication];
    if (!isUploadingPost && [app respondsToSelector:@selector(endBackgroundTask:)]) {
        if (bgTask != UIBackgroundTaskInvalid) {
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }
    }
    
    if ([app respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]) {
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            // Synchronize the cleanup call on the main thread in case
            // the task actually finishes at around the same time.
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid)
                {
                    [app endBackgroundTask:bgTask];
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        }];
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    // Clear badge and update installation, required for auto-incrementing badges.
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PhotoponInstallation currentInstallation] saveInBackground];
    }
    
    // Clears out all notifications from Notification Center.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
    
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    
    
    
    //[FBAppCall handleDidBecomeActive];
    
    
    [FBAppCall handleDidBecomeActiveWithSession:FBSession.activeSession];
    
    [[FBSession activeSession] handleDidBecomeActive];
    
    
    
    // Clear notifications badge and update server
    //[self setAppBadge];
    //[[PhotoponComApi sharedApi] syncPushNotificationInfo];
    
    //[FBAppCall handleDidBecomeActiveWithSession:self.session];
    /*
    PhotoponUserModel *c = [PhotoponUserModel currentUser];
    
    NSString *uidStr = c.identifier;
    
    if (uidStr) {
        [[EGOCache globalCache] setString:c.identifier forKey:kPhotoponUserAttributesCurrentUserKey];
    }*/
    
    
}

- (void)setAppBadge {
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
    //[self setAppBadge];
    
    //[self.session close];
    [FBSession.activeSession close];
}

- (void)saveContext
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark - Open Url


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([url.scheme isEqualToString:@"fb315234305202948"])
    {
        
        return [FBSession.activeSession handleOpenURL:url];
        
        //return YES;
        
    }else if ([url.scheme isEqualToString:@"ig80d6a189f8d04baf95cc83792f0a70dd"]){
        
        return [self.instagram handleOpenURL:url];
        
        
    }else {
        // do what you want
        return YES;
    }
    
    /*
     NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
     if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
     [[UIApplication sharedApplication] openURL:instagramURL];
     }
     */
    
    //return [self.instagram handleOpenURL:url];
    
    
}
/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}
*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    withSession:FBSession.activeSession
                    fallbackHandler:^(FBAppCall *call) {
                        
                        NSLog(@"In fallback handler");
                    
                    }];
}

/*
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([url.scheme isEqualToString:@"fb315234305202948"])
    {
        
        //[FBSession.activeSession handleOpenURL:url];
        
        return [FBAppCall handleOpenURL:url
               sourceApplication:sourceApplication
                 fallbackHandler:^(FBAppCall *call) {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fallback Alert"
                                                                     message:@"In fallback handler"
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                           otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                     [alert show];
                     
                 }];
        
    }else if ([url.scheme isEqualToString:@"ig80d6a189f8d04baf95cc83792f0a70dd"]){
        
        return [self.instagram handleOpenURL:url];
        
    }else {
        // do what you want
        return YES;
    }
    
}
* /
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Photopon" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Photopon.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         * /
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}
*/
#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)applicationUserAgent {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
}

- (void)setupUserAgent {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Keep a copy of the original userAgent for use with certain webviews in the app.
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *defaultUA = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"version_preference"];
    NSString *appUA = [NSString stringWithFormat:@"p-iphone/%@ (%@ %@, %@) Mobile",
                       appVersion,
                       [[UIDevice currentDevice] systemName],
                       [[UIDevice currentDevice] systemVersion],
                       [[UIDevice currentDevice] model]
                       ];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys: appUA, @"UserAgent", defaultUA, @"DefaultUserAgent", appUA, @"AppUserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

/*
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    

    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}*/

- (BOOL)isPhotoponReachable {
    
    NSLog(@"%@ :: %@------------->    ", self, NSStringFromSelector(_cmd));
    return self.networkStatus != NotReachable;

}

- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //self.loginViewController = nil;
    
    
    
    /*
    if (self.tabBarController) {
        if (self.tabBarController.view.window) {
            [self.tabBarController.view removeFromSuperview];
        }
        self.tabBarController = nil;
    }*/
    
    //loginViewController.fields = PFLogInFieldsFacebook;
    //self.loginViewController.facebookPermissions = @[ @"user_about_me" ];
    
    
    //[self.welcomeViewController.navigationController pushViewController:self.loginViewController animated:NO];
    
    [self.welcomeViewController.navigationController pushPhotoponViewController:self.loginViewController];
    
    
    
}

- (void) presentHowItWorksIfNecessary{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.shouldShowHowItWorks) {
        [self presentTutorialHowItWorks];
        self.shouldShowHowItWorks = NO;
    }
}

#pragma mark - PhotoponLoginViewController

/*
- (MBProgressHUD*)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.navController.view];
        [self.navController.view addSubview:_hud];
        _hud.mode = MBProgressHUDModeText;
    }
    return _hud;
}

- (void)setHud:(MBProgressHUD *)hud{
    if (_hud) {
        [_hud removeFromSuperview];
        _hud = nil;
    }
    _hud = hud;
}
*/
- (PhotoponLogInViewController*)loginViewController{
    if (!_loginViewController) {
        
        if(IS_IPAD)
            _loginViewController = [[PhotoponLogInViewController alloc] initWithNibName:@"PhotoponLogInViewController-iPad" bundle:nil];
        else
            _loginViewController = [[PhotoponLogInViewController alloc] initWithNibName:@"PhotoponLogInViewController" bundle:nil];
    }
    return _loginViewController;
}

- (void)setLogInViewController:(PhotoponLogInViewController*)logInViewController{
    _loginViewController = logInViewController;//[[PhotoponLogInViewController alloc] initWithNibName:@"PhotoponLogInViewController" bundle:nil];
}

- (void)logInViewController:(PhotoponLogInViewController *)logInController didLogInUser:(PhotoponUserModel *)user {
    
}

- (void)logInViewController:(PhotoponLogInViewController *)logInController didLogInPhotoponUser:(PhotoponUserModel *)user {    
    
}



/*
- (void)logInViewController:(PhotoponLogInViewController *)logInController didLogInUser:(PhotoponUserModel *)user {
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    if (![self shouldProceedToMainInterface:user]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.navController.presentedViewController.view animated:YES];
        self.hud.labelText = NSLocalizedString(@"Loading", nil);
        self.hud.dimBackground = YES;
    }
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self facebookRequestDidLoad:result];
        } else {
            [self facebookRequestDidFailWithError:error];
        }
    }];
}
*/
- (void)presentLoginViewController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    

    [self presentLoginViewControllerAnimated:NO];
    
}

- (void)presentSignupViewControllerAnimated:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)presentSignupViewController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    [self presentSignupViewControllerAnimated:NO];
}

- (void)presentTabBarController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //self.hud.dimBackground = YES;
    //self.hud.labelText = NSLocalizedString(@"Fetching Lists", nil);
    
    //self.hud.labelText = NSLocalizedString(@"Organizing Feeds", nil);
    /*
    if (self.isUserLoggedIn) {
        return;
    }
    */
    
    
    
    self.tabBarController = nil;
    
    if (!self.tabBarController) {
        self.tabBarController = [[PhotoponTabBarController alloc] init];
    }
    
    //self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController animated:NO];
    self.homeViewController = [[PhotoponHomeViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc]init];
    
    [myLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    
    
    
    self.exploreViewController = [[PhotoponExploreViewController alloc] initWithStyle:UITableViewStylePlain]; //initWithNibName:@"PhotoponExploreViewController" bundle:nil];
    
    
    
    //[self.homeViewController setFirstLaunch:firstLaunch];
    self.activityViewController = [[PhotoponActivityViewController alloc] initWithStyle:UITableViewStylePlain];
    
    self.profileViewController = [[PhotoponAccountProfileViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // initWithNibName:@"PhotoponAccountProfileViewController" bundle:nil];
    
    self.profileViewController.user = [PhotoponUserModel currentUser];
    
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    UINavigationController *exploreNavigationController = [[UINavigationController alloc] initWithRootViewController:self.exploreViewController];
    UINavigationController *emptyNavigationController = [[UINavigationController alloc] init];
    UINavigationController *activityFeedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.activityViewController];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:self.profileViewController];
    
    /*
    [PhotoponUtility addBottomDropShadowToNavigationBarForNavigationController:homeNavigationController];
    [PhotoponUtility addBottomDropShadowToNavigationBarForNavigationController:emptyNavigationController];
    [PhotoponUtility addBottomDropShadowToNavigationBarForNavigationController:activityFeedNavigationController];
    */
    
    
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] init];// initWithTitle:@"Home" image:nil tag:0];
    
    [homeTabBarItem setTag:0];
    
    [homeTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"PhotoponTabBarIconHome-on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"PhotoponTabBarIconHome.png"]];
    [homeTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateNormal];
    [homeTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateSelected];
    homeTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    UITabBarItem *exploreFeedTabBarItem = [[UITabBarItem alloc] init];// initWithTitle:@"Explore" image:nil tag:1];
    
    [exploreFeedTabBarItem setTag:1];
    
    [exploreFeedTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"PhotoponTabBarIconExplore-on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"PhotoponTabBarIconExplore.png"]];
    [exploreFeedTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateNormal];
    [exploreFeedTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateSelected];
    exploreFeedTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UITabBarItem *activityFeedTabBarItem = [[UITabBarItem alloc] init];// initWithTitle:@"News" image:nil tag:3];
    
    [activityFeedTabBarItem setTag:3];
    
    [activityFeedTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"PhotoponTabBarIconNews-on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"PhotoponTabBarIconNews.png"]];
    [activityFeedTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateNormal];
    [activityFeedTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateSelected];
    activityFeedTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    
    UITabBarItem *profileFeedTabBarItem = [[UITabBarItem alloc] init]; //initWithTitle:@"Profile" image:nil tag:4];
    
    [profileFeedTabBarItem setTag:4];
    
    [profileFeedTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"PhotoponTabBarIconProfile-on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"PhotoponTabBarIconProfile.png"]];
    [profileFeedTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateNormal];
    [profileFeedTabBarItem setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] } forState:UIControlStateSelected];
    profileFeedTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    
    [homeNavigationController setTabBarItem:homeTabBarItem];
    [exploreNavigationController setTabBarItem:exploreFeedTabBarItem];
    [activityFeedNavigationController setTabBarItem:activityFeedTabBarItem];
    [profileNavigationController setTabBarItem:profileFeedTabBarItem];
    
    
    
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[ homeNavigationController, exploreNavigationController, emptyNavigationController, activityFeedNavigationController, profileNavigationController];
    
    //self.tabBarController.viewControllers = @[ homeNavigationController, emptyNavigationController, profileNavigationController];
    
    
    
    [self.navController setViewControllers:@[ self.welcomeViewController, self.tabBarController ] animated:NO];
    
    NSTimer *howItWorksCheckTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(presentHowItWorksIfNecessary) userInfo:nil repeats:NO];
    
    
    
    
    //self.hud.labelText = NSLocalizedString(@"Building Pages", nil);
    /*
    // keep it clean
    if (self.loginViewController) {
        if (self.loginViewController.view.window) {
            [self.welcomeViewController.navigationController popViewControllerAnimated:NO];
        }
        //self.loginViewController = nil;
    }*/
    
    
    
    /*
    self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
    self.hud.dimBackground = YES;
    self.hud.labelText = NSLocalizedString(@"Building Lists", nil);
    */
    
    //PhotoponNavigationBar * photoponNavigationBar = (PhotoponNavigationBar*)self.navController.navigationBar;
    
    //[photoponNavigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBar.png"] forBarMetrics:nil];
    
    
    
    /*
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    */
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}



- (void) presentPhotoponPickerController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self photoponAlertViewWithTitle:@"Alert example" message:@"test" cancelButtonTitle:@"OK"];
    
    
    
    [self.tabBarController newPhotopon:nil];
        
        
        
        
        /*
        [UIView animateWithDuration:0.5f animations:^{
            
            viewController.view.alpha = 1.0f;
            
            //[self.presentedViewController.navigationController pushViewController:viewController animated:NO];
            
            //[self pushViewController:viewController animated:NO];
            
            
            self.photoponPlaceholderNewPhotoponOverlayImageView.alpha = 0.0f;
            
            
        } completion:^(BOOL finished) {
            
            if(finished){
                
                
                
            }
            
        }];*/
    
    
    
    
    //[self.navController newPhotopon:nil];
    
}

- (void) downloadFacebookProfilePicture{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PhotoponUserModel currentUser] objectForKey:kPhotoponUserAttributesFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
    
    
    
}

//- (void)

- (void) downloadFacebookProfilePictureUrl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?redirect=false", [[PhotoponUserModel currentUser] objectForKey:kPhotoponUserAttributesFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
}

#pragma mark - Remote Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [PhotoponPush storeDeviceToken:newDeviceToken];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    [[PhotoponInstallation currentInstallation] saveInBackground];
    
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if ([error code] != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
	}
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        // Track app opens due to a push notification being acknowledged while the app wasn't active.
        //[PhotoponAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    if ([PhotoponUserModel currentUser]) {
        if ([self.tabBarController viewControllers].count > PhotoponActivityTabBarItemIndex) {
            UITabBarItem *tabBarItem = [[self.tabBarController.viewControllers objectAtIndex:PhotoponActivityTabBarItemIndex] tabBarItem];
            
            NSString *currentBadgeValue = tabBarItem.badgeValue;
            
            if (currentBadgeValue && currentBadgeValue.length > 0) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
                NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
                tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
            } else {
                tabBarItem.badgeValue = @"1";
            }
        }
    }
    //*/
}
 
- (void)openNotificationScreenWithOptions:(NSDictionary *)remoteNotif{
 
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    

}

-(void)loadStuff:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

-(BOOL) shouldShowHowItWorks{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (BOOL)[self.shouldShowHowItWorksNumber boolValue];
}

-(void) setShouldShowHowItWorks:(BOOL)shouldShowHowItWorks{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.shouldShowHowItWorksNumber = [[NSNumber alloc] initWithBool:shouldShowHowItWorks];
}

-(BOOL) shouldShowNewComp{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (BOOL)[self.shouldShowNewCompNumber boolValue];
}

-(void) setShouldShowNewComp:(BOOL)shouldShowNewComp{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.shouldShowNewCompNumber = [[NSNumber alloc] initWithBool:shouldShowNewComp];
}

-(BOOL) shouldShowSnipTutorial{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    return (BOOL)[self.shouldShowNewCompNumber boolValue];
}

-(void) setShouldShowSnipTutorial:(BOOL)shouldShowSnipTutorial{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.shouldShowSnipTutorialNumber = [[NSNumber alloc] initWithBool:shouldShowSnipTutorial];
}

#pragma mark Photopon Lifecycle

- (void)logIn{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.welcomeViewController updateHUDWithStatusText:@"Complete"];
    
    [self initFirstTimeUserChecks];
    
    if (self.shouldShowSnipTutorial){
        [self presentExplanationLocationServices];
    }else{
        [self switchLocationManagerOn];
        [self presentTabBarController];
    }
        
}

- (void)logOut {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    @synchronized(self) {
    
    [self switchLocationManagerOn];
    [self.loginViewController logOut];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserAttributesCurrentUserKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserAttributesIdentifierKey];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserAttributesFacebookIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserAttributesFacebookAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // clear cache
    [[PhotoponCache sharedCache] clear];
    
    
    self.pComApi = [PhotoponComApi sharedApi];
    [self.pComApi signOut];
    
    [[EGOCache globalCache] clearCache];
    
    
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    //[[PhotoponInstallation currentInstallation] removeObjectForKey:kPhotoponInstallationUserKey];
    //[[PhotoponInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    //[PhotoponQuery shared clear];
    
    
    
    
    // Log out & clear cache & FB token info
    
    
    
    // clear out cached data, view controllers, etc
    
        /*
        self.homeViewController = nil;
        self.activityViewController = nil;
        self.exploreViewController = nil;
        self.profileViewController = nil;
        */
    [PhotoponUserModel logOut];
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navController popToRootViewControllerAnimated:NO];
    });
    
    //[self.welcomeViewController loadView];
    
    //[self presentLoginViewController];
    
    //if (self.tabBarController.view.window)
        //[self.tabBarController.view removeFromSuperview];
    
    
        
        
    
    //self.tabBarController = nil;
    /*
    [self.homeViewController.view removeFromSuperview];
    [self.activityViewController.view removeFromSuperview];
    [self.exploreViewController.view removeFromSuperview];
    [self.profileViewController.view removeFromSuperview];
    * /
    
    self.homeViewController = nil;
    self.activityViewController = nil;
    self.exploreViewController = nil;
    self.profileViewController = nil;
     
    */
        
    }
    
}


- (void)photoponAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleText message:messageText delegate:self cancelButtonTitle:cancelButtonTitleText otherButtonTitles: nil];
    [alertView show];
    
    /*
    NSString *testTitle = [[NSString alloc] initWithFormat:@"TEST TITLE"];
    NSString *testMessage = [[NSString alloc] initWithFormat:@"TEST MESSAGE"];
    NSString *testCancelTitle = [[NSString alloc] initWithFormat:@"CANCEL TITLE"];
    NSString *testOtherTitle = [[NSString alloc] initWithFormat:@"OTHER TITLE"];
    
    
    
    /
     *
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:testTitle message:testMessage delegate:self.navController cancelButtonTitle:testCancelTitle otherButtonTitles:testOtherTitle, nil];
    
    alertView.delegate = self.navController;
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = PHOTOPON_BLUE_COLOR;
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
    */
}

- (void)photoponAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText otherButtonTitle:(NSString*)otherButtonTitleText {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleText message:messageText delegate:self cancelButtonTitle:cancelButtonTitleText otherButtonTitles:otherButtonTitleText, nil];
    [alertView show];
    
    /*
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:titleText message:messageText delegate:nil cancelButtonTitle:cancelButtonTitleText otherButtonTitles:otherButtonTitleText, nil];
    
    alertView.delegate = self;
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = PHOTOPON_BLUE_COLOR;
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
    */
}

- (void)photoponAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText otherButtonTitleStrings:(NSMutableArray*)titleStrings {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleText message:messageText delegate:self cancelButtonTitle:cancelButtonTitleText otherButtonTitles: nil];
    [alertView show];
    
    /*
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:titleText message:messageText delegate:nil cancelButtonTitle:cancelButtonTitleText otherButtonTitles:@"OK", nil];
    
    [alertView setButtons:titleStrings];
    
    alertView.delegate = self;
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = PHOTOPON_BLUE_COLOR;
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
     */
    
}

- (void)photoponBlackTranslucentAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText otherButtonTitleStrings:(NSMutableArray*)titleStrings {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleText message:messageText delegate:self cancelButtonTitle:cancelButtonTitleText otherButtonTitles: nil];
    [alertView show];
    
    /*
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:titleText message:messageText delegate:nil cancelButtonTitle:cancelButtonTitleText otherButtonTitles:@"OK", nil];
    
    [alertView setButtons:titleStrings];
    
    alertView.delegate = self;
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = PHOTOPON_BLUE_COLOR;
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
     */
    
}

- (IBAction)showAlertView:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Hello" message:@"This is an alert view" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Do Something", nil];
    
    alertView.delegate = self;
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

#pragma mark - ()

- (void)setupAppearance {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    [[UIAlertView appearance] setTitleTextAttributes:@{
                                                      UITextAttributeTextColor: [UIColor cloudsColor],
                                                      UITextAttributeFont: [UIFont boldFlatFontOfSize:16]
     } forState:UIControlStateNormal];
    
    [[UIAlertView appearance] setBackgroundColor:PHOTOPON_BLUE_COLOR];
    [[UIAlertView appearance] setDefaultButtonColor:[UIColor cloudsColor]];
    [[UIAlertView appearance] setDefaultButtonShadowColor:[UIColor asbestosColor]];
    [[UIAlertView appearance] setDefaultButtonFont:[UIFont boldFlatFontOfSize:16]];
    [[UIAlertView appearance] setDefaultButtonTitleColor:[UIColor asbestosColor]];
    [[[UIAlertView appearance] messageLabel] setTextColor:[UIColor cloudsColor]];
    [[[UIAlertView appearance] messageLabel] setFont:[UIFont flatFontOfSize:14]];
    [[[UIAlertView appearance] titleLabel] setTextColor:[UIColor cloudsColor]];
    [[[UIAlertView appearance] titleLabel] setFont:[UIFont boldFlatFontOfSize:16]];
    [[[UIAlertView appearance] alertContainer] setBackgroundColor:PHOTOPON_BLUE_COLOR];
    [[[UIAlertView appearance] backgroundOverlay] setBackgroundColor:[[UIColor cloudsColor] colorWithAlphaComponent:0.8]];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    */
    //[UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.498f green:0.388f blue:0.329f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor: [UIColor blackColor],
                          UITextAttributeTextShadowColor: [UIColor clearColor],// colorWithWhite:0.0f alpha:0.750f],
                         UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]
     }];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"BackgroundNavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBar.png"] forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBarSelected.png"] forState:UIControlStateHighlighted];
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"ButtonBack.png"]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"ButtonBackSelected.png"]
                                                      forState:UIControlStateSelected
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor: [UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f],
                          UITextAttributeTextShadowColor: [UIColor colorWithWhite:0.0f alpha:0.750f],
                         UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]
     } forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:32.0f/255.0f green:19.0f/255.0f blue:16.0f/255.0f alpha:1.0f]];
}

-(PhotoponModelManager *)pmm{
    if (_pmm == nil) {
        _pmm = [PhotoponModelManager sharedManager];
    }
    return _pmm;
}

- (void)monitorReachability {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostname:kPhotoponComXMLRPCUrl];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

- (BOOL)validateDeviceConnection{
    // present HUD if no connection
    if (!self.connectionAvailable) {
        [self.welcomeViewController initHUD];
        [self.welcomeViewController showHUDWithStatusText:@"A connection failure occurred" mode:MBProgressHUDModeText];
        [self.welcomeViewController hideHudAfterDelay:1.0f];
    }
    return self.connectionAvailable;
}

- (void)handlePush:(NSDictionary *)launchOptions {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // If the app was launched in response to a push notification, we'll handle the payload here
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:remoteNotificationPayload];
        
        if (![PhotoponUserModel currentUser]) {
            return;
        }
        
        // If the push notification payload references a photo, we will attempt to push this view controller into view
        NSString *photoObjectId = [remoteNotificationPayload objectForKey:kPhotoponPushPayloadPhotoObjectIdKey];
        if (photoObjectId && photoObjectId.length > 0) {
            [self shouldNavigateToPhoto:[PhotoponModel objectWithoutDataWithClassName:kPhotoponMediaClassKey objectId:photoObjectId]];
            return;
        }
        
        // If the push notification payload references a user, we will attempt to push their profile into view
        NSString *fromObjectId = [remoteNotificationPayload objectForKey:kPhotoponPushPayloadFromUserObjectIdKey];
        if (fromObjectId && fromObjectId.length > 0) {
            /*
            PhotoponQuery *query = [PhotoponUserModel query];
            query.cachePolicy = kPhotoponCachePolicyCacheElseNetwork;
            [query getObjectInBackgroundWithId:fromObjectId block:^(PhotoponModel *user, NSError *error) {
                if (!error) {
                    UINavigationController *homeNavigationController = self.tabBarController.viewControllers[PhotoponHomeTabBarItemIndex];
                    self.tabBarController.selectedViewController = homeNavigationController;
                    
                    PhotoponAccountViewController *accountViewController = [[PhotoponAccountViewController alloc] initWithStyle:UITableViewStylePlain];
                    accountViewController.user = (PhotoponUserModel *)user;
                    [homeNavigationController pushViewController:accountViewController animated:YES];
                }
            }];
             */
        }
    }
}

- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
    //[MBProgressHUD hideHUDForView:self.homeViewController.view animated:NO];
    [self.homeViewController loadObjects];
}

- (BOOL)shouldProceedToMainInterface:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([PhotoponUtility userHasValidFacebookData:[PhotoponUserModel currentUser]]) {
        [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
        [self presentTabBarController];
        
        [self.navController dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    
    return NO;
}

- (BOOL)handleActionURL:(NSURL *)url {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.tabBarController) {
        return NO;
    }
    
    if ([[url host] isEqualToString:kPhotoponLaunchURLHostTakePicture]) {
        if ([PhotoponUserModel currentUser]) {
            return [self.tabBarController shouldPresentPhotoCaptureController];
        }
    } else {
        if ([[url fragment] rangeOfString:@"^pic/[A-Za-z0-9]{10}$" options:NSRegularExpressionSearch].location != NSNotFound) {
            NSString *photoObjectId = [[url fragment] substringWithRange:NSMakeRange(4, 10)];
            if (photoObjectId && photoObjectId.length > 0) {
                [self shouldNavigateToPhoto:[PhotoponModel objectWithoutDataWithClassName:kPhotoponMediaClassKey objectId:photoObjectId]];
                return YES;
            }
        }
    }
    
    return NO;
}

// Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    networkStatus = [curReach currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        NSLog(@"Network not reachable.");
        
        //[self.welcomeViewController showHUDWithStatusText:@"A connection failure occurred"];
        //[self.welcomeViewController hideHudAfterDelay:2.0f];
        
        //[self.hud show:YES];
        //self.hud.labelText = NSLocalizedString(@"Network not reachable.", nil);
        //[self.hud hide:YES afterDelay:3.0];
    }
    
    if ([self isPhotoponReachable] && [PhotoponUserModel currentUser] && self.homeViewController.objects.count == 0) {
        NSLog(@"Network is reachable.");
        
        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
        [self.homeViewController loadObjects];
        
        
        
    }
}

- (void)setupReachability {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    // Set the pcom availability to YES to avoid issues with lazy reachibility notifier
    self.pcomAvailable = YES;
    // Same for general internet connection
    self.connectionAvailable = YES;
    
    // allocate the internet reachability object
    internetReachability = [Reachability reachabilityForInternetConnection];
    
    self.connectionAvailable = [internetReachability isReachable];
    // set the blocks
    internetReachability.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Internet connection is back");
        
        //[self.welcomeViewController showHUDWithStatusText:@"A connection failure occurred" mode:MBProgressHUDModeText];
        //[self.welcomeViewController hideHudAfterDelay:2.0f];
        
        self.connectionAvailable = YES;
    };
    internetReachability.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"No internet connection");
        self.connectionAvailable = NO;
    };
    // start the notifier which will cause the reachability object to retain itself!
    [internetReachability startNotifier];
    
    // allocate the P.com reachability object
    pcomReachability = [Reachability reachabilityWithHostname:@"photopon.com"];
    // set the blocks
    pcomReachability.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Connection to Photopon.com is back");
        self.pcomAvailable = YES;
    };
    pcomReachability.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"No connection to Photopon.com");
        self.pcomAvailable = NO;
    };
    // start the notifier which will cause the reachability object to retain itself!
    [pcomReachability startNotifier];
#pragma clang diagnostic pop
}

- (void)shouldNavigateToPhoto:(PhotoponModel *)targetPhoto {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.tabBarController) {
        return;
    }
    
    for (PhotoponModel *photo in self.homeViewController.objects) {
        if ([photo.objectId isEqualToString:targetPhoto.objectId]) {
            targetPhoto = photo;
            break;
        }
    }
    
    // if we have a local copy of this photo, this won't result in a network fetch
    [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PhotoponModel *object, NSError *error) {
        if (!error) {
            UINavigationController *homeNavigationController = [[self.tabBarController viewControllers] objectAtIndex:PhotoponHomeTabBarItemIndex];
            [self.tabBarController setSelectedViewController:homeNavigationController];
            
            //PhotoponMediaDetailsViewController *detailViewController = [[PhotoponMediaDetailsViewController alloc] initWithPhoto:object];
            //[homeNavigationController pushViewController:detailViewController animated:YES];
        }
    }];
}

- (void)facebookRequestDidLoad:(id)result {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    PhotoponUserModel *user = [PhotoponUserModel currentUser];
    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
            }
        }
        
        // cache friend data
        [[PhotoponCache sharedCache] setFacebookFriends:facebookIds];
        
        if (user) {
            if (![user objectForKey:kPhotoponUserAttributesAlreadyAutoFollowedFacebookFriendsKey]) {
                //self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                firstLaunch = YES;
                
                [user setObject:@YES forKey:kPhotoponUserAttributesAlreadyAutoFollowedFacebookFriendsKey];
                NSError *error = nil;
                
                /*
                if (![self shouldProceedToMainInterface:user]) {
                    [self logOut];
                    return;
                }
                */
                // find common Facebook friends already using Anypic
                //PFQuery *facebookFriendsQuery = [PhotoponUserModel query];
                //[facebookFriendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookIds];
                
                /*
                // auto-follow Parse employees
                PFQuery *autoFollowAccountsQuery = [PhotoponUserModel query];
                [autoFollowAccountsQuery whereKey:kPAPUserFacebookIDKey containedIn:kPhotoponAutoFollowAccountFacebookIds];
                
                // combined query
                PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:autoFollowAccountsQuery,facebookFriendsQuery, nil]];
                
                NSArray *anypicFriends = [query findObjects:&error];
                
                if (!error) {
                    [anypicFriends enumerateObjectsUsingBlock:^(PhotoponUserModel *newFriend, NSUInteger idx, BOOL *stop) {
                        PhotoponModel *joinActivity = [PhotoponModel objectWithClassName:kPAPActivityClassKey];
                        [joinActivity setObject:user forKey:kPAPActivityFromUserKey];
                        [joinActivity setObject:newFriend forKey:kPAPActivityToUserKey];
                        [joinActivity setObject:kPAPActivityTypeJoined forKey:kPAPActivityTypeKey];
                        
                        PFACL *joinACL = [PFACL ACL];
                        [joinACL setPublicReadAccess:YES];
                        joinActivity.ACL = joinACL;
                        
                        // make sure our join activity is always earlier than a follow
                        [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [PAPUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                                // This block will be executed once for each friend that is followed.
                                // We need to refresh the timeline when we are following at least a few friends
                                // Use a timer to avoid refreshing innecessarily
                                if (self.autoFollowTimer) {
                                    [self.autoFollowTimer invalidate];
                                }
                                
                                self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
                            }];
                        }];
                    }];
                }
                
                if (![self shouldProceedToMainInterface:user]) {
                    [self logOut];
                    return;
                }
                
                if (!error) {
                    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
                    if (anypicFriends.count > 0) {
                        self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
                        self.hud.dimBackground = YES;
                        self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                    } else {
                        [self.homeViewController loadObjects];
                    }
                }
                 */
            }
            
            [user saveEventually];
        } else {
            NSLog(@"No user session found. Forcing logOut.");
            //[self logOut];
        }
    } else {
        //self.hud.labelText = NSLocalizedString(@"Creating Profile", nil);
        
        if (user) {
            NSString *facebookName = result[@"name"];
            if (facebookName && [facebookName length] != 0) {
                [user setObject:facebookName forKey:kPhotoponUserAttributesFullNameKey];
            } else {
                [user setObject:@"Someone" forKey:kPhotoponUserAttributesFullNameKey];
            }
            
            NSString *facebookId = result[@"id"];
            if (facebookId && [facebookId length] != 0) {
                [user setObject:facebookId forKey:kPhotoponUserAttributesFacebookIDKey];
            }
            
            [user saveEventually];
        }
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"Facebook error: %@", error);
    
    if ([PhotoponUserModel currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            //[self logOut];
        }
    }
}





















/*
 // OLD STUFF
 
 
 #pragma mark - Push Notification delegate
 
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 // Send the deviceToken to our server...
 NSString *myToken = [[[[deviceToken description]
 stringByReplacingOccurrencesOfString: @"<" withString: @""]
 stringByReplacingOccurrencesOfString: @">" withString: @""]
 stringByReplacingOccurrencesOfString: @" " withString: @""];
 
 NSLog(@"Registered for push notifications and stored device token: %@", myToken);
 
 // Store the token
 NSString *previousToken = [[NSUserDefaults standardUserDefaults] objectForKey:kApnsDeviceTokenPrefKey];
 if (![previousToken isEqualToString:myToken]) {
 [[NSUserDefaults standardUserDefaults] setObject:myToken forKey:kApnsDeviceTokenPrefKey];
 [self sendApnsToken];
 }
 }
 
 - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 NSLog(@"Failed to register for push notifications: %@", error);
 [[NSUserDefaults standardUserDefaults] removeObjectForKey:kApnsDeviceTokenPrefKey];
 }
 
 // The notification is delivered when the application is running
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 NSLog(@"didReceiveRemoteNotification: %@", userInfo);
 application.applicationIconBadgeNumber = 0;
 /*
 {
 aps =     {
 alert = "New comment on test from maria";
 badge = 1;
 sound = default;
 };
 "blog_id" = 16841252;
 "comment_id" = 571;
 }* /
 
 //You can determine whether an application is launched as a result of the user tapping the action button or
 //whether the notification was delivered to the already-running application by examining the application state.
 switch (application.applicationState) {
 case UIApplicationStateActive:
 NSLog(@"app state UIApplicationStateActive"); //application is in foreground
 [[PhotoponComApi sharedApi] checkForNewUnseenNotifications];
 [[PhotoponComApi sharedApi] syncPushNotificationInfo];
 [SoundUtil playNotificationSound];
 break;
 case UIApplicationStateInactive:
 NSLog(@"app state UIApplicationStateInactive"); //application is in bg and the user tapped the view button
 [self openNotificationScreenWithOptions:userInfo];
 break;
 case UIApplicationStateBackground:
 NSLog(@" app state UIApplicationStateBackground"); //?? doh!
 break;
 default:
 break;
 }
 }
 
 - (void)registerForPushNotifications {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 if (isPcomAuthenticated) {
 [[UIApplication sharedApplication]
 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
 UIRemoteNotificationTypeSound |
 UIRemoteNotificationTypeAlert)];
 }
 }
 
 - (void)sendApnsToken{
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 }
 - (void)unregisterApnsToken{
 
 }
 */



#pragma Location Manager

-(float)photoponLatitude{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return photoponCoordinateModel.coordinate.latitude;
}

-(float)photoponLongitude{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return photoponCoordinateModel.coordinate.longitude;
}

- (BOOL)isUpdatingLocation {
    //NSLog(@"||*****||");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[self isUpdatingLocationNumber] boolValue];
}

- (void)setIsUpdatingLocation:(BOOL)isUpdating {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.isUpdatingLocationNumber = [[NSNumber alloc] initWithBool:isUpdating];
    
    //[self setIsUpdatingLocationNumber:[NSNumber numberWithBool:isUpdating]];
}

- (void)setUpLocationManager{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponCoordinateModel)
        self.photoponCoordinateModel = [[PhotoponCoordinateModel alloc] init];
    
    if (!self.locationManager) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"--------->              if (!locationManager) { ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
}

- (void)switchLocationManagerOn{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.locationManager)
        [self setUpLocationManager];
    
    [self.locationManager startUpdatingLocation];
    self.isUpdatingLocation = YES;
    
    //[self setIsUpdatingLocation:YES];
    
}

- (void)switchLocationManagerOff{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [locationManager stopUpdatingLocation];
    [self setIsUpdatingLocation:NO];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    @try {
        //
        [self photoponAlertViewWithTitle:@"Location Mgr Error" message:[error localizedDescription] cancelButtonTitle:@"Need Help?" otherButtonTitle:@"OK"];
        
    }
    @catch (NSException *exception) {
        //
        
    }
    @finally {
        //
    }
    
    //self photoponAlertViewWithTitle:@"" message: cancelButtonTitle:@"OK"
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Mgr Error"
                                                    message:[error localizedDescription]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [alert show];
    */
    
    
    
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if (self.shouldShowNewComp){
        NSTimer *autoPickerTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(presentPhotoponPickerController) userInfo:nil repeats:NO];
        self.shouldShowNewComp = NO;
        
    }*/
    
    //[locationManager startUpdatingLocation];
	// If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0)
    {
		if (![self isUpdatingLocation]) {
			return;
		}
		self.isUpdatingLocation = NO;
		CLLocationCoordinate2D coordinate = newLocation.coordinate;
        
#if FALSE // Switch this on/off for testing location updates
		// Factor values (YMMV)
		// 0.0001 ~> whithin your zip code (for testing small map changes)
		// 0.01 ~> nearby cities (good for testing address label changes)
		double factor = 0.001f;
		coordinate.latitude += factor * (rand() % 100);
		coordinate.longitude += factor * (rand() % 100);
#endif
        // rewritten from below
        [self.photoponCoordinateModel setCoordinate:coordinate];
	}

}




@end
