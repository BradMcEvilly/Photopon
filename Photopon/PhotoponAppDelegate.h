//
//  PhotoponAppDelegate.h
//  Photopon
//
//  Created by Brad McEvilly on 5/5/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PhotoponTabBarController.h"
#import "PhotoponComLoginViewController.h"
#import "PhotoponLogInViewController.h"
#import "PhotoponWelcomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PhotoponComApi.h"
#import "PhotoponUserModel.h"
#import "FUIAlertView.h"


@class PhotoponLogInViewController;
@class PhotoponComLoginViewController;
@class MBProgressHUD;
@class Reachability;
@class PhotoponModelManager;
@class PhotoponHomeViewController;
@class PhotoponExploreViewController;
@class PhotoponActivityViewController;
@class PhotoponAccountProfileViewController;
@class PhotoponCoordinateModel;
@class PhotoponNavigationViewController;
@class PhotoponHowItWorksIntroPageViewController;
@class PhotoponHowItWorksTutorialViewController;
@class PhotoponSnipTutorialViewController;
@class PhotoponExplanationLocationServicesViewController;

@interface PhotoponAppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDataDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, FUIAlertViewDelegate>{
    BOOL isPcomAuthenticated;
    BOOL isUploadingPost;
    
    PhotoponUserModel *photoponUserModel;
    
    //Background tasks
    UIBackgroundTaskIdentifier bgTask;
    
}

//@property (nonatomic, strong) MBProgressHUD *hud;

@property (readonly, nonatomic, strong) PhotoponModelManager *pmm;

@property (strong, nonatomic) UIImageView* profileImageView;

@property (nonatomic) BOOL isUserLoggedIn;

@property (nonatomic, unsafe_unretained) BOOL isPcomAuthenticated;

@property (nonatomic, unsafe_unretained) BOOL isUploadingPost;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Instagram *instagram;

@property (nonatomic, strong) PhotoponTabBarController *tabBarController;
@property (nonatomic, strong) PhotoponNavigationViewController *navController;

@property (nonatomic, readonly) int networkStatus;
@property (nonatomic, strong) PhotoponWelcomeViewController *welcomeViewController;
@property (readonly , nonatomic, strong) PhotoponLogInViewController *loginViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) PhotoponComApi *pComApi;

@property (nonatomic, strong) PhotoponUserModel *photoponUserModel;

@property (strong, nonatomic) FBSession *session;

//Connection Reachability variables
@property (nonatomic, strong) Reachability *internetReachability, *pcomReachability, *currentPhotoponReachability;
@property (nonatomic, assign) BOOL connectionAvailable, pcomAvailable, currentPhotoponAvailable;

@property (nonatomic, strong) PhotoponHomeViewController *homeViewController;
@property (nonatomic, strong) PhotoponExploreViewController *exploreViewController;
@property (nonatomic, strong) PhotoponActivityViewController *activityViewController;
@property (nonatomic, strong) PhotoponAccountProfileViewController *profileViewController;

@property (nonatomic, strong) PhotoponHowItWorksIntroPageViewController *photoponHowItWorksIntroPageViewController;
@property (nonatomic, strong) PhotoponHowItWorksTutorialViewController *photoponHowItWorksTutorialViewController;
@property (nonatomic, strong) PhotoponSnipTutorialViewController *photoponSnipTutorialViewController;
@property (nonatomic, strong) PhotoponExplanationLocationServicesViewController *photoponExplanationLocationServicesViewController;

@property (nonatomic, strong) PhotoponCoordinateModel *photoponCoordinateModel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isUpdatingLocation;
@property (nonatomic, strong) NSNumber *isUpdatingLocationNumber;


@property (nonatomic) BOOL shouldShowHowItWorks;
@property (nonatomic, retain) NSNumber *shouldShowHowItWorksNumber;

@property (nonatomic) BOOL shouldShowNewComp;
@property (nonatomic, retain) NSNumber *shouldShowNewCompNumber;

// Snip Tutorial
@property (nonatomic) BOOL shouldShowSnipTutorial;
@property (nonatomic, retain) NSNumber *shouldShowSnipTutorialNumber;

- (NSString *)applicationDocumentsDirectory;
- (NSString *)applicationUserAgent;

+ (PhotoponAppDelegate *)sharedPhotoponApplicationDelegate;

- (BOOL)isTall;

- (void) appDidBeginFacebookLogIn:(UITapGestureRecognizer *)recognizer;

- (void)presentLoginViewController;
- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)presentTabBarController;

/**
 * FIRST TIME USERS
 */
- (void)presentHowItWorksIfNecessary;
- (void)presentTutorialHowItWorks;
- (void)dismissTutorialHowItWorks;
- (void)presentTutorialSnip;
- (void)dismissTutorialSnip;
- (void)presentExplanationLocationServicesWithAlert;
- (void)presentExplanationLocationServices;
- (void)dismissExplanationLocationServices;

- (void)logIn;
- (void)logOut;

- (void)logInViewController:(PhotoponLogInViewController *)logInController didLogInUser:(PhotoponUserModel *)user;
- (void)logInViewController:(PhotoponLogInViewController *)logInController didLogInPhotoponUser:(PhotoponUserModel *)user;

- (void)applicationDidLogInPhotoponUser;

- (void)facebookRequestDidLoad:(id)result;
- (void)facebookRequestDidFailWithError:(NSError *)error;

- (void)saveContext;

- (void)registerForPushNotifications;
- (void)sendApnsToken;
- (void)unregisterApnsToken;
- (void)openNotificationScreenWithOptions:(NSDictionary *)remoteNotif;

- (BOOL)validateDeviceConnection;



#pragma Photopon Alert View

- (void)photoponAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText;

- (void)photoponAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText otherButtonTitle:(NSString*)otherButtonTitleText;

- (void)photoponAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText otherButtonTitleStrings:(NSMutableArray*)titleStrings;

- (void)photoponBlackTranslucentAlertViewWithTitle:(NSString*)titleText message:(NSString*)messageText cancelButtonTitle:(NSString*)cancelButtonTitleText otherButtonTitleStrings:(NSMutableArray*)titleStrings;


#pragma Location Manager
- (float)photoponLatitude;
- (float)photoponLongitude;
//- (BOOL)isUpdatingLocation;
//- (void)setIsUpdatingLocation:(BOOL)isUpdating;
- (void)switchLocationManagerOn;
- (void)switchLocationManagerOff;


@end
