//
//  PhotoponLogInViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 5/9/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponLogInViewController.h"
#import "PhotoponComLoginViewController.h"
#import "PhotoponAppDelegate.h"
#import "XMLSignupViewController.h"
#import "PhotoponComApi.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PhotoponConstants.h"
#import "PhotoponLogoSplashViewController.h"
#import "PhotoponUIButton+AFNetworking.h"

#import "SFHFKeychainUtils.h"

#import "UIView+Bounce.h"
#import "UIView+Pop.h"

#import <CoreLocation/CoreLocation.h>
#import <unistd.h>

@interface PhotoponLogInViewController ()


@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickFriends;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickPlace;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (strong, nonatomic) FBLoginView *loginview;

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;

@end

@implementation PhotoponLogInViewController

@synthesize delegate;

@synthesize photoponSplashContainerView;

@synthesize pComApi = _pComApi;

@synthesize photoponTabBarBtnShareBlue;

@synthesize photoponLogoSplashContainerView;
@synthesize photoponLogoSplashViewController;
@synthesize buttonPostStatus = _buttonPostStatus;
@synthesize buttonPostPhoto = _buttonPostPhoto;
@synthesize buttonPickFriends = _buttonPickFriends;
@synthesize buttonPickPlace = _buttonPickPlace;
@synthesize loggedInUser = _loggedInUser;
@synthesize profilePic = _profilePic;

@synthesize profilePhotoImageView;
@synthesize profilePhotoImage;
@synthesize profileFirstName;
@synthesize profileLastName;
@synthesize profileEmail;
@synthesize profileFacebookID;
@synthesize profilePassword;

@synthesize photoponEmailSignup;
@synthesize photoponFacebookSignup;
@synthesize photoponBtnLogoCamera;
@synthesize photoponBtnLogoText;
@synthesize photoponLogin;

@synthesize xmlSignupViewController;
@synthesize photoponComLoginViewController;

@synthesize labelFirstName;
@synthesize profileAge;
@synthesize profileSex;
@synthesize profileBirthdayDate;
@synthesize profileUsername;

@synthesize facebookLoginImageView;
@synthesize facebookLoginContainerView;

@synthesize facebookProfileImage;
@synthesize facebookProfileImageViewTest;

@synthesize loginview;

@synthesize parametersFinal;

- (void)logOut{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] switchLocationManagerOff];
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)logIn{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponAppDelegateApplicationDidLogInFacebookUserNotification object:self];
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] logIn];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    }
    return self;
}

- (void)fadeInView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.6];
    self.photoponSplashContainerView.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:0.6];
    self.photoponSplashContainerView.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    self.photoponBackgroundImageNameString = [[NSString alloc] initWithFormat:@"%@", ([PhotoponUtility isTallScreen])?@"Default-568h@2x.png":@"Default@2x.png"];
    
    self.photoponBackgroundImage = [UIImage imageNamed:self.photoponBackgroundImageNameString];
    [self.photoponBackgroundImageView setImage:self.photoponBackgroundImage];
    
    // Custom initialization
    self.photoponFacebookSignup.delegate = self;
    self.photoponBtnLogoCamera.delegate = self;
    self.photoponBtnLogoText.delegate = self;
    
    
    
    
    
    /*
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            nil];
    
    if (!appDelegate.session.isOpen) {
        
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] initWithAppID:kFacebookAppID permissions:permissions defaultAudience:FBSessionLoginBehaviorWithFallbackToWebView urlSchemeSuffix:nil tokenCacheStrategy:nil];
        
        
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                
                // we recurse here, in order to update buttons and labels
                [self sessionStateChanged:session state:status error:error];
                
                
                
                //[self updateView];
            }];
        }
    }
    */
    
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //self.photoponLogoSplashViewController = [[PhotoponLogoSplashViewController alloc] initWithNibName:@"PhotoponLogoSplashViewController" bundle:nil];
    //[self.photoponLogoSplashViewController.view setFrame:CGRectMake(0.0f, 0.0f, 152.0f, 140.0f)];
    //[self.photoponLogoSplashContainerView addSubview:self.photoponLogoSplashViewController.view];
    
    /*
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:NO];
    appDelegate.hud.labelText = NSLocalizedString(@"Contacting Facebook", nil);
    [appDelegate.hud show:YES];
     */
    
    // Create Login View so that the app will be granted "status_update" permission.
    //self.loginview = [[FBLoginView alloc] init];
    
    
    //UIView *v = [[UIView alloc] initWithFrame:loginview.frame];
    
    //[v setBackgroundColor:[UIColor clearColor]];
    
    //[loginview addSubview:v];
    /*
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    //[singleFingerTap setCancelsTouchesInView:NO];
    //singleFingerTap setCancelsTouchesInView:<#(BOOL)#>
    
    [singleFingerTap setDelaysTouchesBegan:YES];
    
    [loginview addGestureRecognizer:singleFingerTap];
    
    
    

    
    
    
    BOOL isTall = NO;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height >= 568)
        isTall = YES;
    
    if(isTall)
        loginview.frame = CGRectMake(38.0f, 381.0f+88.0f, 246.0f, 48.0f); // add 88 to accomodate iPhone 5 height
    else
        loginview.frame = CGRectMake(38.0f, 381.0f, 246.0f, 48.0f);
        
    UIImage *photoponFacebookLoginImage = [UIImage imageNamed:@"PhotoponButtonFacebookLogin@2x.png"];
    self.facebookLoginImageView = [[UIImageView alloc] initWithFrame:loginview.frame];
    [self.facebookLoginImageView setImage:photoponFacebookLoginImage];
    
    
    
    //loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    
    loginview.delegate = self;
    
    [loginview addSubview:self.facebookLoginImageView];
    [self.view addSubview:loginview];
    */
    
    /*
    if((![self.pComApi.username isEqualToString:@""]) && (![self.pComApi.password isEqualToString:@""]))
		[self.pComApi authenticateWithSuccess:nil failure:nil];
    */
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponSplashContainerView setAlpha:0.0f];
    
    //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] presentHowItWorksIfNecessary];
    
    
    
    /*
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *aToken = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesFacebookAccessTokenKey];
    
    if (aToken && aToken.length>0) {
        [self openSessionWithAllowLoginUI:YES];
    }
    */
    /*
    [self.photoponBtnLogoCamera setAlpha:1.0f];
    [self.photoponFacebookSignup setAlpha:1.0f];
    [self.photoponBtnLogoText setAlpha:1.0f];
     * /
    
    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popOpenView:) userInfo:self.photoponBtnLogoCamera repeats:NO];
    NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(popOpenView:) userInfo:self.photoponBtnLogoText repeats:NO];
    NSTimer *timer3 = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(popOpenView:) userInfo:self.photoponFacebookSignup repeats:NO];
    */
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self fadeInView];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.photoponSplashContainerView setAlpha:0.0f];
    
    
}

-(void)popOpenView:(NSTimer*)aTimer{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [(PhotoponUIButton*)[aTimer userInfo] popOpen:48.0f target:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    [self.photoponBtnLogoCamera setHidden:YES];
    [self.photoponFacebookSignup setHidden:YES];
    [self.photoponBtnLogoText setHidden:YES];
    */
    /*
    [self.photoponBtnLogoCamera setAlpha:0.0f];
    [self.photoponFacebookSignup setAlpha:0.0f];
    [self.photoponBtnLogoText setAlpha:0.0f];
     */
    
}


/*
- (void)handleGesture{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //[appDelegate.welcomeViewController showHUDWithStatusText:@"Connecting"];
    
    
}*/

/*
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [appDelegate.welcomeViewController showHUDWithStatusText:@"Connecting"];
    
    
    
    /*
    dispatch_async( dispatch_get_main_queue(), ^{
            
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication]delegate];
        appDelegate.hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:NO];
        appDelegate.hud.labelText = NSLocalizedString(@"Contacting Facebook", nil);
        [appDelegate.hud show:YES];

    });
    
 
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponAppDelegateApplicationDidAttemptLogInNotification object:nil userInfo:nil];
    * /
}*/































- (BOOL)openActiveSession{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *accessToken = [FBSession activeSession].accessTokenData.accessToken;
    if (!accessToken)
        return NO;
    
    return [[FBSession activeSession] openFromAccessTokenData:[FBSession activeSession].accessTokenData completionHandler:^(FBSession *session,
                                                           FBSessionState state,
                                                           NSError *error) {
        
        [self sessionStateChanged:session
                            state:state
                            error:error];
        
        
    }];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    [appDelegate.welcomeViewController showHUDWithStatusText:@"Signing On"];
    

    
    NSArray *readPermissions = @[@"email",@"friends_birthday",@"friends_likes",@"friends_interests",@"user_birthday",@"user_interests",@"user_likes",@"user_location"];
    
    return [FBSession openActiveSessionWithReadPermissions:readPermissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
    
    
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (state) {
        case FBSessionStateOpen: {
            // We have a valid session
            NSLog(@"User session found");
            if (FBSession.activeSession.isOpen) {
                [FBRequestConnection
                 startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                   id<FBGraphUser> user,
                                                   NSError *error) {
                     if (!error) {
                         NSLog(@"accessToken: %@ userID: %@",[FBSession activeSession].accessTokenData.accessToken,user.id);
                         self.profileFacebookID = user.id;
                         [[NSUserDefaults standardUserDefaults] setValue:user.first_name  forKey:@"first_name"];
                         [[NSUserDefaults standardUserDefaults] setValue:user.last_name  forKey:@"last_name"];
                         
                         NSString *accessToken = [FBSession activeSession].accessTokenData.accessToken;
                         if (accessToken) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationFacebookLoginProcess object:nil];
#ifdef TESTING
    [TestFlight passCheckpoint:@"fbDidLogin"];
#endif
                             PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
                             [appDelegate.welcomeViewController showHUDWithStatusText:@"Building Profile"];
                             
                             NSError *error;
                             
                             
                             [self processFacebookUserInfo:user andAccessToken:accessToken];
                             //[self submitFacebookUserID:user.id andAccessToken:accessToken];
                         }
                         else {
                             NSLog(@"no access token for userID: %@",user.id);
                             [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationFacebookLoginFailed object:nil];
#ifdef TESTING
    [TestFlight passCheckpoint:@"fbDidNotLogin"];
#endif
                             PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
                             [appDelegate.welcomeViewController showHUDWithStatusText:@"Login Failed"];
                         }
                     }
                     else {
                         //handle error retrieving User ID
                         NSLog(@"error retrieving User ID [%@]",[error localizedDescription]);
                         [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationFacebookLoginFailed object:nil];
                         PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
                         [appDelegate.welcomeViewController showHUDWithStatusText:@"Login Failed"];
                         [appDelegate.welcomeViewController hideHudAfterDelay:2];
                         
                     }
                 }];
            } else {
                [FBSession setActiveSession:session];
            }
            
            // Pre-fetch and cache the friends for the friend picker as soon as possible to improve
            // responsiveness when the user tags their friends.
            FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            [cacheDescriptor prefetchAndCacheForSession:session];
        }
            break;
        case FBSessionStateClosed: {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
        case FBSessionStateClosedLoginFailed: {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PhotoponNotificationFacebookSessionStateChanged
     object:session];
    
    if (error) {
        NSLog(@"Facebook Error %@", error);
    }
}


















#pragma mark - FBLoginViewDelegate


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
        
    /*
    [self.photoponSplashContainerView setAlpha:0.0f];
    
    // first get the buttons set for login mode
    self.buttonPostPhoto.enabled = YES;
    self.buttonPostStatus.enabled = YES;
    self.buttonPickFriends.enabled = YES;
    self.buttonPickPlace.enabled = YES;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
    
     */
     
}

- (void)saveInBackgroundWithBlock:(PhotoponBooleanResultBlock)block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    block = [block copy];
    /*
    
    dispatch_queue_t q = dispatch_get_main_queue();
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
        BOOL ret = [self checkIfUserExistsInBackground];
		[self setValue:[NSNumber numberWithBool:ret] forKey:kPhotoponHasBeenFetchedKey];
        if (block != NULL) {
            dispatch_async(q, ^{
                block(ret, error);
            });
        }
    });
     */
}

- (void)processFacebookUserInfo:(id<FBGraphUser>)user andAccessToken:(NSString *)accessToken {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            dispatch_async( dispatch_get_main_queue(), ^{   [appDelegate.welcomeViewController updateHUDWithStatusText Retrieving", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    [appDelegate.welcomeViewController updateHUDWithStatusText:@"Retrieving Info"];
    
    [[NSUserDefaults standardUserDefaults] setValue:user.id forKey:[[NSString alloc] initWithFormat:@"%@", kPhotoponUserAttributesFacebookIDKey]];
    [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:[[NSString alloc] initWithFormat:@"%@", kPhotoponUserAttributesFacebookAccessTokenKey]];
    
    
    
    //[[NSUserDefaults standardUserDefaults] setValue:self.profileFacebookID forKey:kPhotoponUserAttributesFacebookIDKey];
    
    
    
    @try {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@                    @try {  ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // here we use helper properties of FBGraphUser to dot-through to first_name and
        // id properties of the json response from the server; alternatively we could use
        // NSDictionary methods such as objectForKey to get values from the my json object
        self.profileFirstName = user.first_name;
        self.profileLastName = user.last_name;
        //self.profileSex = user.gender;
        self.profileBirthdayDate = user.birthday;
        
        //self.profileUsername = user.username; //[[NSString alloc] initWithFormat:@"%@", user.username];
        //self.profileUsername = @"";
        
        
        /*
         UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"FB Email:"
         message:[NSString stringWithFormat:@"%@", [user objectForKey:@"email"]]
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         [alert1 show];
         */
        
        self.profileEmail = [user objectForKey:@"email"];
        
        
         if (self.profileEmail) {
             // overwrite with email address to abide by Photopon nomenclature
             self.profileUsername = self.profileEmail;
         }else{
             if (!self.profileUsername) {
                 //exit(nil);
                 return;
             }
             self.profileEmail = [[NSString alloc] initWithFormat:@"%@@facebook.com", self.profileUsername];
             self.profileUsername = self.profileEmail;
         }
        
        /*
         if (!self.profileEmail) {
         
         [self getUserEmail];
         
         / *
         // Download user's profile picture
         NSURL *graphProfileEmailURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/email", [[PhotoponUserModel currentUser] objectForKey:kPhotoponUserAttributesFacebookIDKey]]];
         NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:graphProfileEmailURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
         [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
         * /
         
         if (!self.profileEmail) {
         
         self.profileEmail = [[NSString alloc] initWithFormat:@"%@@facebook.com", self.profileUsername];
         
         }
         
         }*/
        
        
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email: ", @"")
         message:self.profileEmail
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"OK", @"")
         otherButtonTitles:nil];
         [alert show];
         */
        
        
        // setting the profileID property of the FBProfilePictureView instance
        // causes the control to fetch and display the profile picture for the user
        self.profilePic.profileID = user.id;
        self.profileFacebookID = [[NSString alloc] initWithFormat:@"%@", user.id];
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UserData: ", @"")
         message:[NSString stringWithFormat:@"fbid=%@, un=%@, email=%@, pw=%@, ", self.profileFacebookID, self.profileUsername, self.profileEmail, self.profilePassword]
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"OK", @"")
         otherButtonTitles:nil];
         [alert show];
         */
        
        self.loggedInUser = user;
        
        
        
        
    }
    @catch (NSException * e) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@                    @catch {  ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"Exception: %@", e);
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Facebook Login Error." message:nil cancelButtonTitle:@"OK"];

        self.profileFacebookID = [[NSString alloc] initWithFormat:@"%@", user.id];
        
    }
    @finally {
        NSLog(@"finally");
        
    }
    

        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self checkIfUserExistsInBackground]", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSString *username = [[NSUserDefaults standardUserDefaults] setObject:self.profileUsername forKey:kPhotoponUserAttributesUsernameKey: objectForKey:@"pcom_username_preference"];
    
    //NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey: objectForKey:@"pcom_username_preference"];
    
    appDelegate.pmm.username = [[NSString alloc] initWithString:self.profileUsername];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.profileUsername forKey:kPhotoponUserAttributesUsernameKey];  //:@"pcom_username_preference"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self checkIfUserExistsInBackground];
    
}

-(void)getUserEmail
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary <FBGraphUser> *user, NSError *error){
        if (!error) {
            self.profileEmail = [user objectForKey:@"email"];
            NSLog(@"email : %@", self.profileEmail);
        }
    }];
}
/*
- (void) request:(FBRequest*)request didLoad:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        if (!self.profileEmail) {
            self.profileEmail = [result objectForKey: @"email"];
        }        
    }
}
*/
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[loginView setAlpha:1.0f];
    
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
    self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
    self.buttonPostPhoto.enabled = NO;
    self.buttonPickFriends.enabled = NO;
    self.buttonPickPlace.enabled = NO;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];
    
    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
    
    
    
    //
    
    
    
    //[self cacheFacebookUser];
    
    //[self checkIfUserExistsInBackground];
    
    //PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    //[appDelegate presentTabBarController];
    
    
    
    //dispatch_release(myBackgroundQ);
    
    
    
    /*
    if ([self profilePicViewImage:profilePhotoImageView]) {
        self.profilePhotoImage = self.profilePhotoImage
    }
     */
    
}

-(void) checkIfUserExistsInBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    [appDelegate.welcomeViewController updateHUDWithStatusText:@"Building Profile"];
    
    /*
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:appDelegate.navController.presentedViewController.view animated:YES];
    appDelegate.hud.labelText = NSLocalizedString(@"Building Profile", nil);
    appDelegate.hud.dimBackground = YES;
    */
    // bp.syncFBUser
    
    //self.pComApi = [PhotoponComApi sharedApi];
    
    
    //[appDelegate logInViewController:self didLogInPhotoponUser:[PhotoponUserModel currentUser]];
    
    //NSString *buttonText, *footerText, *email, *username, *firstname, *lastname, *facebookid, *birthday, *sex, *password, *passwordconfirm;
    
    // ------------------------------------------------- //
    // validate objects
    // ------------------------------------------------- //
    if (!self.profileFacebookID) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@                if (!self.profileFacebookID) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // first try logging into fb again
        
        // then resort to this
        self.profileFacebookID = [[NSString alloc] initWithFormat:@"%@", @""];
        
        
    }
    
    
    
    
    if (!self.profileSex) {
        self.profileSex = [[NSString alloc] initWithFormat:@"%@", @""];
    }
    
    if (!self.profileBirthdayDate) {
        self.profileBirthdayDate = [[NSString alloc] initWithFormat:@"%@", @""];
    }
    
    // secret client pw
    
    self.profilePassword = [[NSString alloc] initWithFormat:@"%@", @"F3CrRi64IaOS4KdE84tCB594Fr3CrErG875TaOS8Kd093v84XirZ1YxD"];
    
    [appDelegate.pmm storePassword:self.profilePassword forUsername:self.profileUsername];
    
    
    
    NSArray *paramSignupCredentialsArray = [[NSArray alloc] initWithObjects:self.profileUsername, self.profilePassword, nil];//, [NSArray arrayWithObjects: email, firstname, lastname, facebookid, sex, birthday];
    NSArray *paramSignupAdditionalArray = [[NSArray alloc] initWithObjects:self.profileEmail, self.profileFirstName, self.profileLastName, self.profileFacebookID, self.profileBirthdayDate, self.profileSex, nil];
    
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithArray:paramSignupCredentialsArray];
    
    [parameters addObject:paramSignupAdditionalArray];
    
    self.parametersFinal = [[NSArray alloc] initWithArray:parameters];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                [self.pComApi photoponSyncFacebookUserWithInfo   - PRE CALL - ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.pComApi = [PhotoponComApi sharedApi];
    
    
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UserData Used: ", @"")
                                                    message:[NSString stringWithFormat:@"fbid=%@, un=%@, email=%@, pw=%@, ", self.profileFacebookID, self.profileUsername, self.profileEmail, self.profilePassword]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    */
    
    
    __weak __typeof(&*self)weakSelf = self;
    
    [[PhotoponComApi sharedApi] photoponSyncFacebookUserWithInfo: self.parametersFinal withSuccess:^(NSArray *responseInfo) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        [self.pComApi photoponSyncFacebookUserWithInfo      SUCCESS SUCCESS SUCCESS!!! ", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [weakSelf logIn];
        
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [[PhotoponUserModel currentUser] changeUserName:self.profileUsername];
            
            [appDelegate presentTabBarController];
            
            
            //NSError *error;
            //[SFHFKeychainUtils storeUsername:self.profileUsername andPassword:@"F3CrRi64IaOS4KdE84tCB594Fr3CrErG875TaOS8Kd093v84XirZ1YxD" forServiceName:@"Photopon.com" updateExisting:YES error:&error];
            
            //[SFHFKeychainUtils storeUsername:kPhotoponGuestUsername andPassword:@"F3CrRi64IaOS4KdE84tCB594Fr3CrErG875TaOS8Kd093v84XirZ1YxD" forServiceName:@"Photopon.com" updateExisting:YES error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [appDelegate presentTabBarController];
            });
        });
        */
        
        
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
            [appDelegate presentTabBarController];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
            
                
            
            });
        });
         */
        
        
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@        [pComApi syncFacebookUserInfo   success {    dispatch_sync( [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] applicationDidLogInPhotoponUser]    ", weakSelf, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] applicationDidLogInPhotoponUser];
            
            
            
            
            //[appDelegate applicationDidLogInPhotoponUser];
            
        //});
     
        
        
        
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"if (self.photo!=nil) {       ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponAppDelegateApplicationDidLogInPhotoponUserNotification object:nil userInfo:nil];
        
        //[self signIn:nil];
        
        //[appDelegate logInViewController:self didLogInUser:[PhotoponUserModel currentUser]];
        
        
        
        
        /*
        [self uploadMediaWithSuccess:^{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"[self uploadMediaWithSuccess:^{");
            NSLog(@"");
            NSLog(@"------------>   SUCCESS SUCCESS SUCCESS ");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         
            / *
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
             message:NSLocalizedString(@"Success!", @"")
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"OK", @"")
             otherButtonTitles:nil];
             [alert show];
             [alert release];
             * /
        }
        failure:^(NSError *error) {
                                 
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"[self uploadMediaWithSuccess:^{");
             NSLog(@"");
             NSLog(@"------------>   FAILURE FAILURE FAILURE ");
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             
             / *
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
              message:[error description]
              delegate:self
              cancelButtonTitle:NSLocalizedString(@"OK", @"")
              otherButtonTitles:nil];
              [alert show];
              [alert release];
              * /
        }];
        */
        
        
        
        
        
        
        NSLog(@"--------->");
        NSLog(@"-------------------------------------------------------------");
        NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
        NSLog(@"CREATE ACCOUNT SUCCESS!!!");
        NSLog(@"-------------------------------------------------------------");
        NSLog(@"--------->");
        
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //[appDelegate.photoponSplashScreenViewController dismissViewControllerAnimated:YES completion:nil];
        
        //[appDelegate.navigationController popViewControllerAnimated:YES];
        
        
        //[appDelegate carryOnThen];
        
        //[appDelegate showLoggedIn];
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        [pComApi syncFacebookUserInfo....       FAILURE FAILURE FAILURE", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
        [appDelegate.welcomeViewController updateHUDWithStatusText:@"Login Failed"];
        
        [appDelegate.welcomeViewController hideHudAfterDelay:3.0f];
        
        
        
        /*
        // temp fix for debugging only
        dispatch_async( dispatch_get_main_queue(), ^{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@        [pComApi syncFacebookUserInfo   failure{    dispatch_sync( [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] applicationDidLogInPhotoponUser]    ", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] applicationDidLogInPhotoponUser];
            
            //[appDelegate applicationDidLogInPhotoponUser];
            
        });
        */
        if (error) {
            
            //
        }
        
        
        //[self setFooterText:[error localizedDescription]];
        //[self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
        /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Registration failed!", @"")
                                                            message:[error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                  otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        alertView.tag = 20;
        [alertView show];
        
        //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
        */
        
    }];
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                [self.pComApi photoponSyncFacebookUserWithInfo   - POST CALL - ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}
     
- (void)uploadMediaWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
}

-(void) registerUserInBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

/*  
 *  Send user object to photopon server to check if user exists & sync Facebook/Email/Instagram Info
 *  if the user does not exist
 */
-(void) syncUserInfoInBackground{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}
/*
-(void) cacheFacebookUser{
    
    // first check if facebook user is registered
    // if facebook id exists
    
    
    
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"currentUser"];
    [[EGOCache globalCache] setString:self.profileFacebookID forKey:@"facebookID"];
    [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%@ %@", self.profileFirstName, self.profileLastName]  forKey:@"fullname"];
    [[EGOCache globalCache] setString:self.profileEmail forKey:@"username"];
    [[EGOCache globalCache] setString:self.profileFirstName forKey:@"firstName"];
    [[EGOCache globalCache] setString:self.profileLastName forKey:@"lastName"];
    [[EGOCache globalCache] setString:self.profileEmail forKey:@"email"];
    [[EGOCache globalCache] setString:@"" forKey:@"bio"];
    [[EGOCache globalCache] setString:@"" forKey:@"website"];
    [[EGOCache globalCache] setString:@"" forKey:@"profilePictureUrl"];
    [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%@ %@", self.profileFirstName, self.profileLastName] forKey:@"facebookProfilePictureUrl"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"profileCoverPictureUrl"];
    / *
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followedByCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"redeemCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"mediaCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"score"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"didFollow"];
 * /
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"mediaCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followersCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followedByCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"redeemCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"scoreString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"didFollowString"];
    
    
}*/

-(void) cacheInstagramUser{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // first check if facebook user is registered
    // if facebook id exists
    
    
    
    
    /*
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"currentUser"];
    [[EGOCache globalCache] setString:self.profileFacebookID forKey:@"facebookID"];
    [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%@ %@", self.profileFirstName, self.profileLastName]  forKey:@"fullname"];
    [[EGOCache globalCache] setString:self.profileEmail forKey:@"username"];
    [[EGOCache globalCache] setString:self.profileFirstName forKey:@"firstName"];
    [[EGOCache globalCache] setString:self.profileLastName forKey:@"lastName"];
    [[EGOCache globalCache] setString:self.profileEmail forKey:@"email"];
    [[EGOCache globalCache] setString:@"" forKey:@"bio"];
    [[EGOCache globalCache] setString:@"" forKey:@"website"];
    [[EGOCache globalCache] setString:@"" forKey:@"profilePictureUrl"];
    [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%@ %@", self.profileFirstName, self.profileLastName] forKey:@"facebookProfilePictureUrl"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"profileCoverPictureUrl"];
    /*[[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followedByCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"redeemCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"mediaCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"score"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"didFollow"];
     * /
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"mediaCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followersCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followedByCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"redeemCountString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"scoreString"];
    [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"didFollowString"];
    */
    
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (void)extractProfilePhoto{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.profilePhotoImage = [self profilePicViewImage:self.profilePic];
    
    if (self.profilePhotoImage) {
        [self.facebookProfileImageViewTest setImage:self.profilePhotoImage];
    }
    
}

- (UIImage*)profilePicViewImage:(FBProfilePictureView *)profilePic{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Get the subviews of the view
    NSArray *subviews = [profilePic subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0)
        return nil;
    
    for (UIView *subview in subviews) {
        NSLog(@"%@", subview);
        
        if ([subview class] == [UIImageView class]) {
            // return image from subview
            UIImageView *subviewImageView = (UIImageView*)subview;
            return subviewImageView.image;
        }
    }
    return nil;
}




/*
#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    self.buttonPostPhoto.enabled = YES;
    self.buttonPostStatus.enabled = YES;
    self.buttonPickFriends.enabled = YES;
    self.buttonPickPlace.enabled = YES;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    
    
    @try {
        // here we use helper properties of FBGraphUser to dot-through to first_name and
        // id properties of the json response from the server; alternatively we could use
        // NSDictionary methods such as objectForKey to get values from the my json object
        self.profileFirstName = user.first_name;
        self.profileLastName = user.last_name;
        //self.profileEmail = user.
        // setting the profileID property of the FBProfilePictureView instance
        // causes the control to fetch and display the profile picture for the user
        self.profilePic.profileID = user.id;
        self.profileFacebookID = user.id;
        self.loggedInUser = user;
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        NSLog(@"finally");
    }
    /*
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.profileFirstName = user.first_name;
    self.profileLastName = user.last_name;
    //self.profileEmail = user.
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    self.profilePic.profileID = user.id;
    self.profileFacebookID = user.id;
    self.loggedInUser = user;
     * /

    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
    self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
    self.buttonPostPhoto.enabled = NO;
    self.buttonPickFriends.enabled = NO;
    self.buttonPickPlace.enabled = NO;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];
    
    self.profilePic.profileID = nil;
    self.profileFirstName = nil;
    self.loggedInUser = nil;
    self.profileFacebookID = nil;
    
}



- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}
 */

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}


/*
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             
                                             
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

-(void)sessionStateChanged:(FBSession*)session state:(FBSessionState)state error:(NSError*)error{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    / *
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FB User"
                                                    message:[NSString stringWithFormat:@"FName: %@", @""]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [alert show];

    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"FB Session"
                                                    message:[NSString stringWithFormat:@"Session.isOpen: %c", session.isOpen]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [alert1 show];

    * /
}*/

#pragma mark Action Handlers

- (void)tableView:(UITableView *)tableView buttonView:(PhotoponUIButton *)button handleTouchUpInside:(id)sender{
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)buttonViewDidTouchUpInside{
    
}
/*
-(IBAction)photoponFacebookSignupHandler:(id)sender{
    
    [self buttonViewDidTouchUpInside:sender];
    
}*/

-(void) buttonViewDidTouchUpInside:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||sgr||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    /*
    */
}
     
/*
//- //(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
*/

-(IBAction)photoponFacebookSignupHandler:(id)sender{
    
    //[self fadeOutView];
    
    [(PhotoponUIButton*)sender popOpen:22.0f];
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![appDelegate validateDeviceConnection]) {
        return;
    }
    
    [appDelegate.welcomeViewController initHUD];
    
    [appDelegate.welcomeViewController showHUDWithStatusText:@"Connecting"];
    
    [self openSessionWithAllowLoginUI:YES];
    
    /*
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (FBSession.activeSession.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [FBSession.activeSession closeAndClearTokenInformation];
        
    } else {
        if (FBSession.activeSession.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            FBSession.activeSession = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            
            [self sessionStateChanged:session state:status error:error];
            
            //[self updateView];
        
        }];
    }
    
    
    / *
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            nil];
    
    if (!appDelegate.session.isOpen) {
        
        NSLog(@"0");
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];// initWithAppID:kFacebookAppID permissions:permissions urlSchemeSuffix:nil tokenCacheStrategy:nil];
        
        //appDelegate.session = [[FBSession alloc] initWithAppID:kFacebookAppID permissions:permissions urlSchemeSuffix:nil tokenCacheStrategy:nil];
        
        if (FBSession.activeSession.isOpen) {
            NSLog(@"1");
        }
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            
            NSLog(@"2");
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                
                NSLog(@"3");
                
                [self sessionStateChanged:session
                                    state:status
                                    error:error];
                
                
                // we recurse here, in order to update buttons and labels
                //[self updateView];
                
                
                
                //[FBSession setActiveSession:appDelegate.session];
                
                
                
                //self.profileFirstName = [[FBSession activeSession] valueForKey:@"user"];
                
                
                /*
                self.profileLastName = user.last_name;
                //self.profileEmail = user.
                // setting the profileID property of the FBProfilePictureView instance
                // causes the control to fetch and display the profile picture for the user
                self.profilePic.profileID = user.id;
                self.profileFacebookID = user.id;
                self.loggedInUser = user;

                * /
                
            }];
        }
    }
     */
    
}

-(IBAction)photoponEmailSignupHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.xmlSignupViewController = [[XMLSignupViewController alloc] initWithNibName:@"XMLSignupViewController" bundle:nil];
    
    [self presentSemiViewController:xmlSignupViewController];
    
    //[self presentViewController:xmlSignupViewController animated:YES completion:nil];
    
}

-(IBAction)photoponLoginHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponComLoginViewController = [[PhotoponComLoginViewController alloc] initWithNibName:@"PhotoponComLoginViewController" bundle:nil];
    
    //[self presentViewController:self.photoponComLoginViewController animated:YES completion:nil];
    [self presentSemiViewController:self.photoponComLoginViewController];
    
}



- (void)didReceiveMemoryWarning
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:alertTitle message:alertMsg cancelButtonTitle:@"OK"];
    
}

- (void)signIn:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    
    //PhotoponUserModel *u = [[PhotoponUserModel alloc] initWithAttributes:nil];
    
    [self.pComApi setUsername:self.profileUsername
                     password:self.profilePassword
                      success:^{
                          
                          
                          
                      }
                      failure:^(NSError *error) {
                          
                          
                          
                      }];
    
}


@end
