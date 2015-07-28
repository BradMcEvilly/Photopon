//
//  PhotoponLogInViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/9/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponUserModel.h"
#import "XMLSignupViewController.h"
#import "PhotoponComLoginViewController.h"
#import "PhotoponLogInViewController.h"
#import "PhotoponBaseUIViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PhotoponUIButton.h"


//@class PhotoponUIButton;
@class PhotoponComLoginViewController;
@class XMLSignupViewController;
@class PhotoponComApi;
@class PhotoponLogoSplashViewController;


//@class PhotoponUIButton;

@protocol PhotoponLogInViewControllerDelegate;

@interface PhotoponLogInViewController : PhotoponBaseUIViewController <UITextFieldDelegate, UINavigationControllerDelegate, PhotoponUIButtonDelegate>{
    IBOutlet UIView *photoponSplashContainerView;
    PhotoponComApi *pComApi;
}

@property (nonatomic, strong) PhotoponComApi *pComApi;

@property (strong, nonatomic) FBSession *session;

/*! @name Configuring Log In Behaviors */
/// The delegate that responds to the control events of PFLogInViewController.

@property (nonatomic, weak) id<PhotoponLogInViewControllerDelegate> delegate;

@property(nonatomic,strong) IBOutlet UIView *photoponSplashContainerView;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponTabBarBtnShareBlue;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponFacebookSignup;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnLogoCamera;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnLogoText;
@property (nonatomic, strong) IBOutlet UILabel *photoponPrivacyReassuranceLabel;
@property (nonatomic, strong) NSString *photoponPrivacyReassuranceString;
@property (nonatomic, strong) IBOutlet UIButton *photoponEmailSignup;
@property (nonatomic, strong) IBOutlet UIButton *photoponLogin;
@property (nonatomic, strong) XMLSignupViewController *xmlSignupViewController;
@property (nonatomic, strong) PhotoponComLoginViewController *photoponComLoginViewController;
@property (nonatomic, strong) UIImageView *profilePhotoImageView;
@property (nonatomic, strong) UIImage *profilePhotoImage;

@property (nonatomic, strong) NSString *profileFirstName;
@property (nonatomic, strong) NSString *profileLastName;
@property (nonatomic, strong) NSString *profileEmail;
@property (nonatomic, strong) NSString *profileSex;
@property (nonatomic, strong) NSString *profileFacebookID;

@property (nonatomic, strong) NSNumber *profileAge;

@property (nonatomic, strong) NSString *profileBirthdayDate;
@property (nonatomic, strong) NSString *profilePassword;
@property (nonatomic, strong) NSString *profileUsername;

@property (nonatomic, strong) UIImageView *facebookLoginImageView;
@property (nonatomic, strong) UIView *facebookLoginContainerView;

@property (nonatomic, strong) IBOutlet UIView *photoponLogoSplashContainerView;
@property (nonatomic, strong) PhotoponLogoSplashViewController *photoponLogoSplashViewController;

@property (nonatomic, strong) IBOutlet UIImageView *facebookProfileImageViewTest;
@property (nonatomic, strong) UIImageView *facebookProfileImage;

@property (nonatomic, strong) NSString * html;
@property (nonatomic, strong) NSNumber * remoteStatusNumber;
@property (nonatomic) PhotoponModelRemoteStatus remoteStatus;

@property (nonatomic, strong) NSArray *parametersFinal;

-(void)uploadMediaWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

-(void)fadeInView;
-(void)fadeOutView;
-(void)fadeInMainView;
-(void)fadeOutMainView;
-(void)fadeInSignupView;
-(void)fadeOutSignupView;
-(void)fadeInLoginView;
-(void)fadeOutLoginView;

-(void)popOpenView:(NSTimer*)aTimer;

- (BOOL)openActiveSession;
-(void) checkIfUserExistsInBackground;

//-(IBAction)buttonViewDidTouchUpInside:(id)sender;

-(IBAction)photoponFacebookSignupHandler:(id)sender;
-(IBAction)photoponEmailSignupHandler:(id)sender;
-(IBAction)photoponLoginHandler:(id)sender;

//- (void)handleGesture;
//- (void)handleSingleTap:(UIGestureRecognizer*)recognizer;
//- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

- (void)logIn;
- (void)logOut;

@end


@protocol PhotoponLogInViewControllerDelegate <NSObject>
@optional

/*! @name Customizing Behavior */

/*!
 Sent to the delegate to determine whether the log in request should be submitted to the server.
 @param username the username the user tries to log in with.
 @param password the password the user tries to log in with.
 @result a boolean indicating whether the log in should proceed.
 */
- (BOOL)logInViewController:(PhotoponLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password;

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PhotoponLogInViewController *)logInController didLogInUser:(PhotoponUserModel *)user;

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PhotoponLogInViewController *)logInController didFailToLogInWithError:(NSError *)error;

/// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PhotoponLogInViewController *)logInController;

- (void)loginViewFetchedUserInfoWithHUD:(NSArray*)params;

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user;

@end

