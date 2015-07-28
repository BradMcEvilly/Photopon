//
//  PhotoponNewPhotoponOverlayViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 8/26/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//


#import "PhotoponMediaModel.h"
#import <MessageUI/MessageUI.h>
//#import <MessageUI/MFMessageComposeViewController.h>
//#import "PhotoponOffersTableViewController.h"
#import "PhotoponCouponModel.h"
#import "Photopon8CouponsModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponNewPhotoponShareViewController.h"
//#import "PhotoponOffersTableViewController.h"
#import "PhotoponOfferOverlayView.h"
#import "PhotoponOfferPageViewController.h"
#import "PhotoponCouponModel.h"
#import "MBProgressHUD.h"
#import "PhotoponNewPhotoponOverlayViewController.h"
#import "PhotoponNewPhotoponTagCouponViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoponTabBarController.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponNavigationViewController.h"
#import "PhotoponNewPhotoponPickerController.h"
#import "PhotoponOfferActivityPageViewController.h"
#import "PhotoponUIImagePickerController.h"
#import "PhotoponNewPhotoponConstants.h"
#import "PhotoponNewPhotoponShutterViewController.h"
#import "PhotoponNewPhotoponOffersViewController.h"
#import "UIViewController+Photopon.h"
#import "PhotoponNewPhotoponUtility.h"
#import "PhotoponNewPhotoponConstants.h"
#import "StyledPageControl.h"

static NSString *photoponDirectionalPromptCreationText = @"choose coupon & take photo";
static NSString *photoponDirectionalPromptConfirmationText = @"now it's time to share!";

//#define SHUTTER_TOP_FRAME_DEFAULT_IPAD CGRectMake(0.0f, 0.0f, 320.0f, 160.0f)

@interface PhotoponNewPhotoponOverlayViewController()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate> {
    
}

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSUInteger currentOffset;
//@property (nonatomic, strong, readwrite) NSMutableArray *objects;
@property (nonatomic, strong) NSMutableArray * orSkip;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIView *noResultsView;

@property(nonatomic,copy) PhotoponTagCouponCompletionBlock completionBlock;
@property(nonatomic,strong) UIView *bottomMaskView;
@property(nonatomic,assign) CGSize cropOverlaySize;
@property(nonatomic,strong) UIView *highlightView;
@property(nonatomic,strong) UIView *topMaskView;
@property (assign) SystemSoundID tickSound;
@property (nonatomic, strong) NSArray *libPhotos;

- (void) configureNoResultsView;
-(CAAnimationGroup*)photoponAnimationGroupRetake;
@end

@implementation PhotoponNewPhotoponOverlayViewController{
    UIImage* _photoponImage;
    UIImage* _photoponImageConfirmation;
}

@synthesize photoponToolBarView;
@synthesize photoponBtnCamera;
@synthesize photoponBtnCancel;
@synthesize photoponBtnLibrary;

@synthesize HUD;
@synthesize photoponNewPhotoponOffersViewController;
@synthesize photoponToolBarContainer;
@synthesize photoponCreationToolBar;
@synthesize photoponConfirmationToolBar;
@synthesize photoponBtnNext;
@synthesize photoponBtnPlace;
@synthesize photoponBtnRefresh;
@synthesize photoponBtnRetake;
@synthesize photoponImageConfirmation;
@synthesize photoponDirectionalPrompt;
@synthesize imageViewConfirmation;
@synthesize photoponFooterPanel;
@synthesize photoponHeaderPanel;
@synthesize picker;

// camera
@synthesize cameraFlashModeNumber;
@synthesize cameraDeviceNumber;

@synthesize photoponBtnInfo;
@synthesize photoponBtnShareApp;
@synthesize photoponBtnTutorialShare;

@synthesize photoponNewPhotoponCompositionViewModeNumber;

@synthesize photoponBtnEditCaptionCancel;
@synthesize photoponBtnEditCaptionDone;

@synthesize photoponEditCaptionView;

@synthesize smsMessageViewController;


@synthesize photoponImageConfirmationContainer;
@synthesize photoponOfferPagesContainer;

@synthesize tickSound = _tickSound;

@synthesize photoponNewPhotoponShutterViewController;

@synthesize photoponFlashLightingEffectOverlay;
@synthesize photoponEditCaptionToolBar;

@synthesize photoponInfoContainer;
@synthesize photoponCaption;
@synthesize photoponInfoImage;
@synthesize photoponInfoImageView;

@synthesize photoponSecondaryNavigationToolBar;

@synthesize photoponFlashImageView;
@synthesize photoponBtnFlashAuto;
@synthesize photoponBtnFlashOff;
@synthesize photoponBtnFlashOn;
@synthesize photoponBtnSettings;
@synthesize photoponBtnSwitch;

@synthesize shouldShowTooltipShareNumber;

@synthesize photoponTutorialShareContainer;
@synthesize photoponTutorialShareImage;
@synthesize photoponTutorialShareImageView;

@synthesize photoponTutorialShareTapGesture;

- (void) dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AudioServicesDisposeSystemSoundID(_tickSound);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        //CGRect c = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
        
        
        
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCropOverlaySize:(CGSize)cropOverlaySize
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        /**
         ADD VIEW MODE OBSERVERS HERE
         
         
         */
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadOffers:) name:PhotoponNotificationDidReceiveLocalOffers object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didOpenShutter:) name:PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidOpenShutter object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseShutter:) name:PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidCloseShutter object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCropImage:) name:PhotoponNotificationDidCropImage object:nil];
        
        [self initSounds];
        
        self.photoponNewPhotoponShutterViewController = [[PhotoponNewPhotoponShutterViewController alloc] initWithNibName:@"PhotoponNewPhotoponShutterViewController" bundle:nil];
        self.photoponNewPhotoponOffersViewController = [[PhotoponNewPhotoponOffersViewController alloc] initWithNibName:@"PhotoponNewPhotoponOffersViewController" bundle:nil];
        
        self.photoponNewPhotoponCompositionViewModeNumber = [[NSNumber alloc] initWithUnsignedInteger:PhotoponNewPhotoponCompositionViewModeCreate];
        
        self.cropOverlaySize = cropOverlaySize;
        
        
        
        // picker defaults
        [self setCameraDeviceNumber:[NSNumber numberWithUnsignedInteger:UIImagePickerControllerCameraDeviceFront]];
        [self setCameraFlashModeNumber: [NSNumber numberWithUnsignedInteger:UIImagePickerControllerCameraFlashModeAuto]];
        
    }
    return self;
}

- (void) initFirstTimeUserChecks{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.shouldShowTooltipShare         = NO;
    
    /**
     *  Show tooltip if new user
     * /
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pcom_show_tooltip_share_preference"] == nil) {
        //NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_username_preference"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_show_tooltip_share_preference"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.shouldShowTooltipShare = YES;
        
        //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(showTutorialShare) userInfo:nil repeats:NO];
        
    }*/
    
    
}

-(BOOL) shouldShowTooltipShare{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (BOOL)[self.shouldShowTooltipShareNumber boolValue];
}

-(void) setShouldShowTooltipShare:(BOOL)shouldShowTooltipShare{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.shouldShowTooltipShareNumber = [[NSNumber alloc] initWithBool:shouldShowTooltipShare];
}


- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self initFirstTimeUserChecks];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInfoViewTapped)];
    tgr.cancelsTouchesInView = NO;
    [self.photoponInfoContainer addGestureRecognizer:tgr];
    
    UITapGestureRecognizer *tgrEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToEdit)];
    tgrEdit.cancelsTouchesInView = NO;
    [self.photoponOfferPagesContainer addGestureRecognizer:tgrEdit];
    
    //[self initHUD];
    [self setUpTextField];
    
    //[self.photoponBtnLibrary setEnabled:NO];
    
    [self addChildViewController:self.photoponNewPhotoponOffersViewController];
    [self.photoponOfferPagesContainer addSubview:self.photoponNewPhotoponOffersViewController.view];
    [self.photoponNewPhotoponOffersViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.photoponNewPhotoponShutterViewController];
    [self.photoponOfferPagesContainer addSubview:self.photoponNewPhotoponShutterViewController.view];
    [self.photoponNewPhotoponShutterViewController didMoveToParentViewController:self];
    
    
    if ([MFMessageComposeViewController canSendText]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([MFMessageComposeViewController canSendText]) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        __weak __typeof(&*self)weakSelf = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            weakSelf.smsMessageViewController = [[MFMessageComposeViewController alloc] init];
            weakSelf.smsMessageViewController.messageComposeDelegate = weakSelf;
            weakSelf.smsMessageViewController.body = [PhotoponUtility appShareMessage];
            
        });
        
    }
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.view.userInteractionEnabled = YES;
    
    [self initPhotoponMasks];
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(configureViewForModeCloseInitially) withObject:nil waitUntilDone:NO];
	} else {
		[self configureViewForModeCloseInitially];
	}
}

- (void) showTutorialShare{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(showTutorialShareOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self showTutorialShareOnMainThread];
	}
    
}

- (void) showTutorialShareOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.view bringSubviewToFront:self.photoponTutorialShareContainer];
    
    [self fadeInView:self.photoponTutorialShareContainer];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTutorialShareViewTapped)];
    tgr.cancelsTouchesInView = NO;
    [self.photoponTutorialShareTapGesture addGestureRecognizer:tgr];
    
    self.shouldShowTooltipShare = NO;
    
}

- (void)setCameraFlashMode:(UIImagePickerControllerCameraFlashMode)cameraFlashMode{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setCameraFlashModeNumber:[NSNumber numberWithUnsignedInteger:cameraFlashMode]];
    
    if (self.picker.mediaUI)
        self.picker.mediaUI.cameraFlashMode = self.cameraFlashMode;
    
    
    
}

- (UIImagePickerControllerCameraFlashMode)cameraFlashMode{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (UIImagePickerControllerCameraFlashMode)[self.cameraFlashModeNumber unsignedIntegerValue];
}


- (void)setCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setCameraDeviceNumber:[NSNumber numberWithUnsignedInteger:cameraDevice]];
    
    if (self.picker.mediaUI)
        self.picker.mediaUI.cameraDevice = self.cameraDevice;
}

- (UIImagePickerControllerCameraDevice)cameraDevice{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (UIImagePickerControllerCameraDevice)[self.cameraDeviceNumber unsignedIntegerValue];
}

- (void) initPhotoponMasks {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.topMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.topMaskView.userInteractionEnabled = NO;
    self.bottomMaskView.userInteractionEnabled = NO;
    
    [self.view addSubview:self.topMaskView];
    [self.view addSubview:self.bottomMaskView];
    
    UIColor *backgroundColor            = BACKGROUND_COLOR_BLACK_OPAQUE;
    self.topMaskView.backgroundColor    = backgroundColor;
    self.bottomMaskView.backgroundColor = backgroundColor;
    
    
    /*
     self.highlightView = [[UIView alloc] initWithFrame:CGRectZero];
     self.highlightView.backgroundColor = [UIColor clearColor];
     self.highlightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.2].CGColor;
     self.highlightView.layer.borderWidth = 1.0f;
     [self.view addSubview:self.highlightView];
     */
    
    CGFloat scale = (CGRectGetWidth(self.view.frame) / self.cropOverlaySize.width);
    CGSize scaledCropOverlay = CGSizeMake((self.cropOverlaySize.width * scale), (self.cropOverlaySize.height * scale));
    CGFloat yOrigin = (CGRectGetHeight(self.view.frame) - scaledCropOverlay.height) / 2 - [PhotoponNewPhotoponUtility photoponCropFrameOffset];
    
    self.topMaskView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), yOrigin);
    self.bottomMaskView.frame = CGRectMake(0, yOrigin + scaledCropOverlay.height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - (yOrigin + scaledCropOverlay.height));
    
    //self.highlightView.frame = CGRectMake(0, CGRectGetMaxY(self.topMaskView.frame), CGRectGetWidth(self.view.frame), CGRectGetMinY(self.bottomMaskView.frame) - CGRectGetMaxY(self.topMaskView.frame));
}

#pragma mark Push-back animation group

/*
-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // The rotation angle is minor as the view is nearer
        t1 = CATransform3DRotate(t1, 7.5f*M_PI/180.0f, 1, 0, 0);
    } else {
        t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    }
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // Minor shift to mantai perspective
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.04, 0);
        t2 = CATransform3DScale(t2, 0.88, 0.88, 1);
    } else {
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
	CFTimeInterval duration = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.animationDuration] doubleValue];
    animation.duration = duration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}*/

#pragma mark Push-back animation group

- (CAAnimation*) photoponSlideAnimationForView:(UIView*)targetView fromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame{
    CABasicAnimation *photoponSlideAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
    return photoponSlideAnimation;
}

/*
- (CAAnimationGroup*)photoponAnimationGroupRetake {
    
    
    / *
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // The rotation angle is minor as the view is nearer
        t1 = CATransform3DRotate(t1, 7.5f*M_PI/180.0f, 1, 0, 0);
    } else {
        t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    }
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // Minor shift to mantai perspective
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.04, 0);
        t2 = CATransform3DScale(t2, 0.88, 0.88, 1);
    } else {
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
	CFTimeInterval duration = [[self ym_optionOrDefaultForKey:KNSemiModalOptionKeys.animationDuration] doubleValue];
    animation.duration = duration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    
    
    
    
    
    
    CABasicAnimation *photoponCloseShutterAnimation = [self photoponSlideAnimationForView:self.photoponNewPhotoponShutterViewController.photoponShutterPanelBottom fromFrame:self.photoponNewPhotoponShutterViewController.photoponShutterPanelBottom.frame toFrame:SHUTTER_BOTTOM_FRAME_DEFAULT];
    
    
    [CABasicAnimation animationWithKeyPath:@"frame"];
    [photoponCloseShutterAnimation setToValue:[NSValue valueWithCGRect:SHUTTER_BOTTOM_FRAME_DEFAULT]];
    [photoponCloseShutterAnimation setFromValue:[NSValue valueWithCGRect:[self.photoponNewPhotoponShutterViewController.photoponShutterPanelBottom.layer frame]]];
    [photoponCloseShutterAnimation setDuration:1.0];
    photoponCloseShutterAnimation.fillMode = kCAFillModeForwards;
    [photoponCloseShutterAnimation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
    
    [self.photoponNewPhotoponShutterViewController.photoponShutterPanelBottom.layer setFrame:SHUTTER_BOTTOM_FRAME_DEFAULT];
    [self.photoponNewPhotoponShutterViewController.photoponShutterPanelBottom.layer addAnimation:photoponCloseShutterAnimation forKey:@"someKeyForMyAnimation"];
    
    
    
    
    
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
     * /
}

- (void) transactionAnimationGroup {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
    
    // Layer animation
    CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
    [myAnimation setToValue:[NSValue valueWithCGRect:SHUTTER_BOTTOM_FRAME_DEFAULT]];
    [myAnimation setFromValue:[NSValue valueWithCGRect:[self.photoponNewPhotoponShutterViewController.photoponShutterPanelBottom frame]]];
    
    [myLayer setFrame:myNewFrame];
    [myLayer addAnimation:myAnimation forKey:@"someKeyForMyAnimation"];
    
    // Outer animation
    CABasicAnimation *outerAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
    [outerAnimation setToValue:[NSValue valueWithCGRect:myNewOuterFrame]];
    [outerAnimation setFromValue:[NSValue valueWithCGRect:[outerView frame]]];
    
    [[outerView layer] setFrame:myNewOuterFrame];
    [[outerView layer] addAnimation:outerAnimation forKey:@"someKeyForMyOuterAnimation"];
    
    [CATransaction commit];
}
*/
    
    



/**
 OBSOLETE
 **
 
    //[[NSNotificationCenter defaultCenter] removeObserver:self.picker.mediaUI];
    
    / *
    CATransition *shutterAnimation = [CATransition animation];
    [shutterAnimation setDelegate:self];
    [shutterAnimation setDuration:0.3];
    
    shutterAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    [shutterAnimation setType:@"reveal"];
    [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
    
    CALayer *cameraShutter = [[CALayer alloc] init];
    [cameraShutter setBounds:CGRectMake(0.0, 0.0, 320.0, 320.0)];
    [self.photoponNewPhotoponTagCouponViewController.photoponPagesContainerView.layer addSublayer:cameraShutter];
    [self.view.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
    * /
 
    / *
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //cameraIris Effect
    [transition setType:@"cameraIris"];
 
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:NextView animated:YES];
 * /
    
    / *
    CATransition *shutterAnimation = [CATransition animation];
    [shutterAnimation setDelegate:self];
    [shutterAnimation setDuration:0.6];
    
    shutterAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    [shutterAnimation setType:@"cameraIris"];
    [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
    CALayer *cameraShutter = [[CALayer alloc]init];
    [cameraShutter setBounds:CGRectMake(0.0, 0.0, 320.0, 425.0)];
    [self.layer addSublayer:cameraShutter];
    [self.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
    * /
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeViewMode:) name:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidChangeViewMode object:nil];
    / *
    [self.view bringSubviewToFront:self.photoponNewPhotoponTagCouponViewController.view];
    [self.view bringSubviewToFront:self.photoponHeaderPanel];
    [self.view bringSubviewToFront:self.photoponCreationToolBar];
    [self.view bringSubviewToFront:self.photoponToolBarContainer];
    [self.view bringSubviewToFront:self.photoponInfoConfirmationView];
    [self.view bringSubviewToFront:self.photoponInfoCreationView];
    [self.view bringSubviewToFront:self.photoponEditCaptionView];
    * /
}
*/

    
    
-(void) performViewResetWithTimedAnimation{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self configureViewForModeClose];
    
    
    
    /*
    NSDictionary *timerUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"photoponPresentationAnimationsName", @"beginPhotoponOverlayPresentationAnimations", nil];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(beginPhotoponOverlayPresentationAnimations) userInfo:timerUserInfo repeats:NO];
     */
}

- (void) fadeMaskColor:(CGFloat)targetAlpha{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    /*
    if (!targetAlpha<1.0f) {
        // we don't animate when setting opaque
        [self.bottomMaskView setBackgroundColor: BACKGROUND_COLOR_BLACK_OPAQUE];
        [self.topMaskView setBackgroundColor:BACKGROUND_COLOR_BLACK_OPAQUE];
        return;
    }*/
    
    
    
    [UIView animateWithDuration:FADE_TIMING_EXTENDED delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.bottomMaskView.alpha = targetAlpha;    // = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha: targetAlpha];
        self.topMaskView.alpha = targetAlpha;       // backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha: targetAlpha];
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            [self.bottomMaskView setAlpha: targetAlpha];    // = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha: targetAlpha];
            [self.topMaskView setAlpha: targetAlpha];       // backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha: targetAlpha];
            
            
            //[self.bottomMaskView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha: targetAlpha]];
            //[self.topMaskView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha: targetAlpha]];
            
        }
    }];
    
}

- (void) configureViewForModeOpen {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self restackOverlaySubviews];
    
    [self.photoponDirectionalPrompt setFont:[PhotoponUtility photoponFontRegularForBrand:12.0f]];
    
    
    
    
    
    [self.photoponNewPhotoponShutterViewController configureViewForModeOpen];
    
    [self.photoponDirectionalPrompt setAlpha:1.0f];
    
    [self.photoponDirectionalPrompt setAlpha:1.0f];
    [self.photoponDirectionalPrompt setHidden:NO];
    
    if (self.photoponNewPhotoponCompositionViewMode==PhotoponNewPhotoponCompositionViewModeCreate) {
        [self.photoponDirectionalPrompt setText:photoponDirectionalPromptCreationText];
        self.photoponCreationToolBar.frame      = [PhotoponNewPhotoponUtility photoponToolbarFrameActive];
        self.photoponConfirmationToolBar.frame  = [PhotoponNewPhotoponUtility photoponToolbarFrameDefault];
    }else{
        [self.photoponDirectionalPrompt setText:photoponDirectionalPromptConfirmationText];
        self.photoponCreationToolBar.frame      = [PhotoponNewPhotoponUtility photoponToolbarFrameDefault];
        self.photoponConfirmationToolBar.frame  = [PhotoponNewPhotoponUtility photoponToolbarFrameActive];
    }
}

- (void) configureViewForModeCloseInitially {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    [self configureViewForModeClose];
    [self presentToolbar];
    
}

- (void) configureViewForModeClose {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self restackOverlaySubviews];
    
    
    [self.photoponNewPhotoponShutterViewController configureViewForModeClose];
    
    [self.photoponDirectionalPrompt setAlpha:0.0f];
    [self.photoponDirectionalPrompt setHidden:YES];
    
    self.photoponCreationToolBar.frame      = [PhotoponNewPhotoponUtility photoponToolbarFrameDefault];
    self.photoponConfirmationToolBar.frame  = [PhotoponNewPhotoponUtility photoponToolbarFrameDefault];
    
    if (self.photoponNewPhotoponCompositionViewMode==PhotoponNewPhotoponCompositionViewModeCreate) {
        [self.photoponDirectionalPrompt setText:photoponDirectionalPromptCreationText];
    }else{
        [self.photoponDirectionalPrompt setText:photoponDirectionalPromptConfirmationText];
    }

}


/*
- (void) configureViewForModeDefault{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.photoponNewPhotoponCompositionViewMode==PhotoponNewPhotoponCompositionViewModeCreate){
        
        self.photoponDirectionalPrompt.text = photoponDirectionalPromptCreationText;
        
        //self.photoponCreationToolBar.frame = TOOLBAR_FRAME_DEFAULT;//CGRectMake(self.photoponCreationToolBar.frame.origin.x, self.photoponCreationToolBar.frame.size.height, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height);
    }
    else{
        
        self.photoponDirectionalPrompt.text = photoponDirectionalPromptConfirmationText;
        
    }
    
    
    [self.photoponDirectionalPrompt setAlpha:0.0f];
    [self.photoponDirectionalPrompt setHidden:YES];
    
    self.photoponCreationToolBar.frame      = TOOLBAR_FRAME_DEFAULT;
    self.photoponConfirmationToolBar.frame  = TOOLBAR_FRAME_DEFAULT;
    
    [self fadeView:self.photoponBackgroundFillContainer toAlpha:1.0f];
    
    
    
    //[self configureBlackBGColorForView:self.photoponFooterPanel withAlpha:1.0f];
    //[self configureBlackBGColorForView:self.photoponHeaderPanel withAlpha:1.0f];
    
}
*/
- (void) setUpTextField{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self.textField setKeyboardType:UIKeyboardTypeAlphabet];
    [self.textField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [self.textField setReturnKeyType:UIReturnKeyDone];
    
    
    
}

- (void) beginAppearanceTransitionFromViewModeCreation {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(beginAppearanceTransitionFromViewModeCreationOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self beginAppearanceTransitionFromViewModeCreationOnMainThread];
	}
    
}

- (void) beginAppearanceTransitionFromViewModeCreationOnMainThread {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self configureViewForModeOpen];
    
    [self swapToolBarViews];
    
}

- (void) beginAppearanceTransitionFromViewModeConfirmation {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(beginAppearanceTransitionFromViewModeConfirmationOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self beginAppearanceTransitionFromViewModeConfirmationOnMainThread];
	}
    
}

- (void) beginAppearanceTransitionFromViewModeConfirmationOnMainThread {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self configureViewForModeDefault];
    
    [self.view addSubview:self.photoponNewPhotoponShutterViewController.view];
    
    [self configureViewForModeOpen];
    
    [self.photoponNewPhotoponShutterViewController.view setHidden:NO];
    
    
    // exchange starting positions for slightly cooler effect
    [self.photoponNewPhotoponShutterViewController.photoponShutterSceneBackgroundView setFrame:[PhotoponNewPhotoponUtility photoponShutterSceneForegroundFrameOpen]];
    [self.photoponNewPhotoponShutterViewController.photoponShutterSceneForegroundView setFrame:[PhotoponNewPhotoponUtility photoponShutterSceneBackgroundFrameOpen]];
    
    
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.photoponNewPhotoponShutterViewController.photoponShutterPanelBottom.frame = [PhotoponNewPhotoponUtility photoponShutterBottomFrameDefault];
        self.photoponNewPhotoponShutterViewController.photoponShutterPanelTop.frame = [PhotoponNewPhotoponUtility photoponShutterBottomFrameDefault];
        
        self.photoponConfirmationToolBar.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameDefault];
        
        self.photoponDirectionalPrompt.alpha = 0.0f;
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.photoponNewPhotoponShutterViewController.photoponShutterSceneBackgroundView.frame = [PhotoponNewPhotoponUtility photoponShutterSceneFrameDefault];
                self.photoponNewPhotoponShutterViewController.photoponShutterSceneForegroundView.frame = [PhotoponNewPhotoponUtility photoponShutterSceneFrameDefault];
                
                self.photoponCreationToolBar.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameActive];
                
                
            }completion:^(BOOL finished) {
                
                if (finished) {
                    
                    //[self resetSession];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidCloseShutter object:nil];
                    
                }
                
            }];
            
        }
        
    }];
    
}


/*
- (void) beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated{
 
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super beginAppearanceTransition:isAppearing animated:animated];
    
    //[self.photoponNewPhotoponShutterViewController beginAppearanceTransition:<#(BOOL)#> animated:<#(BOOL)#>]
    
}
*/

- (void) configureBlackBGColorForView:(UIView*)targetView withAlpha:(CGFloat)targetAlpha{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [targetView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:targetAlpha]];
}

- (UIView *)currentToolbar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (self.photoponNewPhotoponCompositionViewMode == PhotoponNewPhotoponCompositionViewModeCreate)?self.photoponCreationToolBar:self.photoponConfirmationToolBar;
}


- (UIView *)nextToolbar {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (self.photoponNewPhotoponCompositionViewMode == PhotoponNewPhotoponCompositionViewModeCreate)?self.photoponConfirmationToolBar:self.photoponCreationToolBar;
}

- (void) presentToolbar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self fadeInView:self.photoponDirectionalPrompt];
    
    [self slideInView:[self currentToolbar]];
    
    
    
    /*
    switch (self.photoponNewPhotoponCompositionViewMode) {
        case PhotoponNewPhotoponCompositionViewModeCreate:
        {
            
            [self fadeInView:self.photoponDirectionalPrompt];
            [self slideInView:[self currentToolbar]];
            
        }
            break;
        case PhotoponNewPhotoponCompositionViewModeConfirm:
        {
            
            [self fadeInView:self.photoponDirectionalPrompt];
            [self slideInView:[self currentToolbar]];
        
        }
            break;
        default:
        {
            
            [self fadeInView:self.photoponDirectionalPrompt];
            [self slideInView:self.photoponCreationToolBar];
        
        }
            break;
    }
    */
}

- (void) dismissToolbar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self fadeInView:self.photoponDirectionalPrompt];
    [self slideInView:[self currentToolbar]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
    
    [self.photoponDirectionalPrompt setFont:[PhotoponUtility photoponFontRegularForBrand:12.0f]];
    
    //if (self.picker.mediaUI)
        //[self.picker.mediaUI viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    
    if ([PhotoponAppDelegate sharedPhotoponApplicationDelegate].shouldShowNewComp) {
        [PhotoponAppDelegate sharedPhotoponApplicationDelegate].shouldShowNewComp = NO;
    }
    
    
    //[self restackOverlaySubviews];
    
    /*
    if (self.picker.mediaUI) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self.picker.mediaUI) {      MADE IT HERE", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.picker.mediaUI viewDidAppear:animated];
        self.picker.mediaUI.cameraFlashMode = self.cameraFlashMode;
        self.picker.mediaUI.cameraDevice = self.cameraDevice;
    }
     */
}

- (void) beginPhotoponOverlayPresentationAnimations{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(beginPhotoponOverlayPresentationAnimationsOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self beginPhotoponOverlayPresentationAnimationsOnMainThread];
	}
}

- (void) beginPhotoponOverlayPresentationAnimationsOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    //[self presentToolbar];
    
    //[self fadeView:self.photoponBackgroundFillContainer toAlpha:PHOTOPON_OVERLAY_ALPHA];
    
    
    //[self fadeBlackBackgroundColorForView:self.photoponHeaderPanel withAlpha:PHOTOPON_OVERLAY_ALPHA];
    //[self fadeBlackBackgroundColorForView:self.photoponFooterPanel withAlpha:PHOTOPON_OVERLAY_ALPHA];
    
    //if( !self.photoponNewPhotoponOffersViewController.objects.count>0)
        //[self.photoponNewPhotoponOffersViewController loadOffers];
    
}

- (void) willOpenShutter {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(willOpenShutterOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self willOpenShutterOnMainThread];
    }
    
}


- (void) willOpenShutterOnMainThread {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.picker.mediaUI viewWillAppear:YES];
    [self.picker.mediaUI viewDidAppear:YES];
    
    [self.photoponNewPhotoponShutterViewController open];
    
    
}


- (void) openShutter {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(openShutterOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self openShutterOnMainThread];
    }
    
}


- (void) openShutterOnMainThread {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.picker.mediaUI viewWillAppear:YES];
    [self.picker.mediaUI viewDidAppear:YES];
    
    [self.photoponNewPhotoponShutterViewController open];
    
    
}

- (void)fadeBlackBackgroundColorForView:(UIView*)targetView withAlpha:(CGFloat)targetAlpha
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [targetView setHidden:NO];
    
    [UIView animateWithDuration:FADE_TIMING delay:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        targetView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:targetAlpha];
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            [targetView setBackgroundColor: [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:PHOTOPON_OVERLAY_ALPHA]];
        }
    }];
    
}

#pragma mark -
#pragma mark View Animations

- (void)fadeInView:(UIView*)targetView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:FADE_TIMING];
    targetView.alpha = 1.0;
    [UIView commitAnimations];
    
    //[targetView setAlpha:0.0f];
    */
    
    [targetView setHidden:NO];
    
    [UIView animateWithDuration:FADE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
        
        [UIView setAnimationDuration:FADE_TIMING];
        targetView.alpha = 1.0;
        
        
    }completion:^(BOOL finished) {
        if (finished) {
            [targetView setAlpha:1.0f];
        }
    }];
    
    
}

- (void)fadeOutView:(UIView*)targetView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[UIView beginAnimations:@"fade out" context:nil];
    //[UIView commitAnimations];
    
    [UIView animateWithDuration:FADE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
        
        [UIView setAnimationDuration:FADE_TIMING];
        targetView.alpha = 0.0;
        
        
    }completion:^(BOOL finished) {
        if (finished) {
            [targetView setAlpha:0.0f];
            [targetView setHidden:YES];
        }
    }];
    
}

-(void)swapToolBarViews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self slideOutView:[self currentToolbar]];
    
    //[self slideInView:[self nextToolbar]];
    
    [self slideInView:[self nextToolbar] withCurrentView:[self currentToolbar]];
    
    /*
    if (self.photoponCreationToolBar.frame.origin.x > 0.0f)
        [self slideInView:self.photoponCreationToolBar withCurrentView:self.photoponConfirmationToolBar];
    else
        [self slideInView:self.photoponConfirmationToolBar withCurrentView:self.photoponCreationToolBar];
     */
}

// TOOLBAR
-(void)slideInView:(UIView*)targetView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.view bringSubviewToFront: targetView];
    
    [targetView setAlpha:1.0f];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        targetView.frame = CGRectMake(targetView.frame.origin.x, 0.0f, targetView.frame.size.width, targetView.frame.size.height);
        
    }completion:^(BOOL finished) {
        if (finished) {
            
            targetView.frame = CGRectMake(targetView.frame.origin.x, 0.0f, targetView.frame.size.width, targetView.frame.size.height);
            
            
            //targetView.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameActive]; //TO CGRectMake(targetView.frame.origin.x, 54.0f, targetView.frame.size.width, targetView.frame.size.height);
            
            
            
            /*
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
                
            }completion:nil];
            */
        }
    }];
    
}

// TOOLBAR
-(void)slideOutView:(UIView*)targetView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.view bringSubviewToFront: targetView];
    
    [targetView setAlpha:1.0f];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
        
    }completion:^(BOOL finished) {
        if (finished) {
            
            [targetView setFrame: CGRectMake(targetView.frame.origin.x, targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height)];

            
            
            //targetView.frame = CGRectMake(0.0f, 0.0f, targetView.frame.size.width, targetView.frame.size.height);
            
            //targetView.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameActive]; //TO CGRectMake(targetView.frame.origin.x, 54.0f, targetView.frame.size.width, targetView.frame.size.height);
            
            
            
            /*
             [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
             
             targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
             
             }completion:nil];
             */
        }
    }];
    
}

// TOOLBAR
-(void)slideOutCreationToolbar{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    /*
    if (self.photoponSecondaryNavigationToolBar.frame.origin.y==0) {
        
    }*/
    
    [self.view bringSubviewToFront:self.photoponCreationToolBar];
    
    
    
    [self.photoponCreationToolBar setAlpha:1.0f];
    
    
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.photoponSecondaryNavigationToolBar.frame = [PhotoponNewPhotoponUtility photoponSecondaryToolbarFrameDefault];// SECONDARY_TOOLBAR_FRAME_DEFAULT;
        
        self.photoponCreationToolBar.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameDefault];
        
        //TOOLBAR_FRAME_DEFAULT;// CGRectMake(self.photoponCreationToolBar.frame.origin.x, targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
        
        self.photoponSecondaryNavigationToolBar.alpha = 0.0f;
        
    }completion:^(BOOL finished) {
        if (finished) {
            
            [self.photoponSecondaryNavigationToolBar setAlpha: 0.0f];
            
            [self.photoponCreationToolBar setFrame: [PhotoponNewPhotoponUtility photoponToolbarFrameDefault]];//TOOLBAR_FRAME_DEFAULT];
            
            [self.photoponSecondaryNavigationToolBar setFrame: [PhotoponNewPhotoponUtility photoponSecondaryToolbarFrameDefault]];
             
             //SECONDARY_TOOLBAR_FRAME_DEFAULT];
            
            
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.photoponConfirmationToolBar.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameActive];
                
                //TOOLBAR_FRAME_ACTIVE;
                
                
                // CGRectMake(self.photoponCreationToolBar.frame.origin.x, targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
                
                //self.photoponSecondaryNavigationToolBar.alpha = 0.0f;
                
                
                
                
                //targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
                
            }completion:^(BOOL finished){
               
                
                [self.photoponConfirmationToolBar setFrame :[PhotoponNewPhotoponUtility photoponToolbarFrameActive]];
                
                //TOOLBAR_FRAME_ACTIVE];
                
                
            }];
           
            
        }
        
            //[targetView setFrame: CGRectMake(targetView.frame.origin.x, targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height)];
            
            
            
            //targetView.frame = CGRectMake(0.0f, 0.0f, targetView.frame.size.width, targetView.frame.size.height);
            
            //targetView.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameActive]; //TO CGRectMake(targetView.frame.origin.x, 54.0f, targetView.frame.size.width, targetView.frame.size.height);
            
            
            
            /*
             [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
             
             targetView.frame = CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y - targetView.frame.size.height, targetView.frame.size.width, targetView.frame.size.height);
             
             }completion:nil];
             */
    
    }];

    
}


/**
 Toolbar swap only for now... will make it reusable later
 */
-(void)slideInView:(UIView*)targetView withCurrentView:(UIView*)currentView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *targetDirectionText;
    
    if (self.photoponNewPhotoponCompositionViewMode == PhotoponNewPhotoponCompositionViewModeCreate)
        targetDirectionText = photoponDirectionalPromptConfirmationText;
    else
        targetDirectionText = photoponDirectionalPromptCreationText;
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        currentView.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameActive];
        self.photoponDirectionalPrompt.alpha = 0.0f;
        
    }completion:^(BOOL finished) {
        if (finished) {
            
            [self.photoponDirectionalPrompt setAlpha:0.0f];
            self.photoponDirectionalPrompt.text = targetDirectionText;
            
            [UIView animateWithDuration:SLIDE_TIMING delay:0.1f options:UIViewAnimationOptionCurveLinear animations:^{
                
                targetView.frame = [PhotoponNewPhotoponUtility photoponToolbarFrameActive];
                self.photoponDirectionalPrompt.alpha = 1.0f;
                
            }completion:nil];
            
        }
    }];
    
}

/*
//-(void)revealShutter:(UIView*)targetView withCurrentView:(UIView*)currentView{
-(void)revealShutter{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //self.photoponShutterViewTop.frame = CGRectMake(self.photoponShutterViewTop.frame.origin.x, self.photoponShutterViewTop.frame.origin.y + self.photoponShutterViewTop.frame.size.height, self.photoponShutterViewTop.frame.size.width, self.photoponShutterViewTop.frame.size.height);
        
        self.photoponShutterViewTop.frame = CGRectMake(self.photoponShutterViewTop.frame.origin.x, self.photoponShutterViewTop.frame.origin.y - self.photoponShutterViewTop.frame.size.height, self.photoponShutterViewTop.frame.size.width, self.photoponShutterViewTop.frame.size.height);
        
        
        
        self.photoponShutterViewBottom.frame = CGRectMake(self.photoponShutterViewTop.frame.origin.x, self.photoponShutterViewTop.frame.origin.y + self.photoponShutterViewTop.frame.size.height, self.photoponShutterViewTop.frame.size.width, self.photoponShutterViewTop.frame.size.height);
        
        
        
    }completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:FADE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                
                self.photoponFooterPanel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
                
                self.photoponHeaderPanel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
                
                //self.photoponShutterViewBottom.frame = CGRectMake(self.photoponShutterViewBottom.frame.origin.x, self.photoponShutterViewBottom.frame.origin.y - self.photoponShutterViewBottom.frame.size.height, self.photoponShutterViewBottom.frame.size.width, self.photoponShutterViewBottom.frame.size.height);
                
            }completion:nil];
            
        }
    }];
    
}
*/

/*
-(void)slideOutView:(UIView*)targetView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    

}*/


/*
-(void)moveToolBarDown {
	
    UIView *childView = self.photoponNewPhotoponTagCouponViewController.photoponToolBarView;
    
    
    
	[self.view sendSubviewToBack:childView];
    
	[UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.photoponNewPhotoponTagCouponViewController.photoponToolBarView.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             
                             
                             //self.photoponNewPhotoponTagCouponViewController.tag = 0;
                         }
                     }];
}

-(void)moveToolBarUp:(UIView*)toolBarView {
    
	UIView *childView = [self getLeftView];
	[self.view sendSubviewToBack:childView];
    
	[UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _centerViewController.leftButton.tag = 0;
                         }
                     }];
}

-(void)moveToolBarToOriginalPosition {
	[UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}


- (void)shouldChangeViewMode:(NSNotification*)note{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self updateHUDWithStatusText:@"Finishing"];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCropImage:) name:PhotoponNotificationDidCropImage object:nil];
    //   [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidCropImage object:nil userInfo:nil];
}

/ *
- (void)didChangeViewMode:(NSNotification*)note{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self updateHUDWithStatusText:@"Finishing"];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCropImage:) name:PhotoponNotificationDidCropImage object:nil];
    //   [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidCropImage object:nil userInfo:nil];
}
 */

-(void)swapToolBars{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

-(void)viewModeForCreation{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

-(void)viewModeForConfirmation{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
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
#pragma mark - Lifecycle

+ (PhotoponNewPhotoponOverlayViewController*)photoponNewPhotoponOverlayViewWithCropOverlaySize:(CGSize)cropOverlaySize{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponNewPhotoponOverlayView" owner:nil options:nil];
    PhotoponNewPhotoponOverlayViewController *view = [arr objectAtIndex:0];
    
    [view initSounds];
    
    view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    view.cropOverlaySize = cropOverlaySize;
    view.userInteractionEnabled = YES;
    
    view.topMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    view.bottomMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    
    view.topMaskView.userInteractionEnabled = NO;
    view.bottomMaskView.userInteractionEnabled = NO;
    
    [view addSubview:view.topMaskView];
    [view addSubview:view.bottomMaskView];
    
    //UIColor *backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    //view.topMaskView.backgroundColor = backgroundColor;
    //view.bottomMaskView.backgroundColor = backgroundColor;
    
    view.highlightView = [[UIView alloc] initWithFrame:CGRectZero];
    view.highlightView.backgroundColor = [UIColor clearColor];
    view.highlightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.2].CGColor;
    view.highlightView.layer.borderWidth = 1.0f;
    [view addSubview:view.highlightView];
    
    view.photoponBtnLibrary.imageView.layer.cornerRadius = 2.0f;
    
    / *
     NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
     ALAssetsLibrary *al = [PhotoponNewPhotoponOverlayView defaultAssetsLibrary];
     [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
     usingBlock:^(ALAssetsGroup *group, BOOL *stop){
     
     [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
     if (asset) {
     [collector addObject:asset];
     }
     }];
     view.libPhotos = collector;
     
     ALAsset *asset = [view.libPhotos objectAtIndex:[view.libPhotos count]-1];
     [view.photoponBtnLibrary setImage:[UIImage imageWithCGImage:[asset thumbnail]] forState:UIControlStateNormal];
     }
     failureBlock:^(NSError *error) {
     NSLog(@"Library Btn SetImage Failed!!!");
     }];
     * /

    [view.photoponBtnLibrary setFrame:CGRectMake(276.0f, 5.0f, 34.0f, 34.0f)];
    [view bringSubviewToFront:view.photoponToolBarView];
    
    return view;
    
}
*/

- (void)initSounds{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:
                                                         [[NSBundle mainBundle] pathForResource:@"tick"
                                                                                         ofType:@"aiff"]],
                                     &_tickSound);
}

// gets called by our delayed camera shot timer to play a tick noise
- (void)tickFire:(NSTimer *)timer
{
	AudioServicesPlaySystemSound(self.tickSound);
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

/*
- (id)initWithFrame:(CGRect)frame cropOverlaySize:(CGSize)cropOverlaySize
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        self.cropOverlaySize = cropOverlaySize;
        self.userInteractionEnabled = YES;
        
        self.topMaskView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomMaskView = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.topMaskView.userInteractionEnabled = NO;
        self.bottomMaskView.userInteractionEnabled = NO;
        
        [self addSubview:self.topMaskView];
        [self addSubview:self.bottomMaskView];
        
        UIColor *backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        self.topMaskView.backgroundColor = backgroundColor;
        self.bottomMaskView.backgroundColor = backgroundColor;
        
        self.highlightView = [[UIView alloc] initWithFrame:CGRectZero];
        self.highlightView.backgroundColor = [UIColor clearColor];
        self.highlightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.6].CGColor;
        self.highlightView.layer.borderWidth = 1.0f;
        [self addSubview:self.highlightView];
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    
    CGFloat scale = (CGRectGetWidth(self.frame) / self.cropOverlaySize.width);
    CGSize scaledCropOverlay = CGSizeMake((self.cropOverlaySize.width * scale), (self.cropOverlaySize.height * scale));
    
    CGFloat yOrigin = (CGRectGetHeight(self.frame) - scaledCropOverlay.height) / 2 - [PhotoponNewPhotoponUtility photoponCropFrameOffset];
    
    self.topMaskView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), yOrigin);
    self.bottomMaskView.frame = CGRectMake(0, yOrigin + scaledCropOverlay.height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - (yOrigin + scaledCropOverlay.height));
    self.highlightView.frame = CGRectMake(0, CGRectGetMaxY(self.topMaskView.frame), CGRectGetWidth(self.frame), CGRectGetMinY(self.bottomMaskView.frame) - CGRectGetMaxY(self.topMaskView.frame));
    
}
*/


- (PhotoponNewPhotoponCompositionViewMode)photoponNewPhotoponCompositionViewMode{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (PhotoponNewPhotoponCompositionViewMode)[self.photoponNewPhotoponCompositionViewModeNumber unsignedIntegerValue];
}


- (void) setPhotoponNewPhotoponCompositionViewMode:(PhotoponNewPhotoponCompositionViewMode)photoponNewPhotoponCompositionViewMode{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponNewPhotoponCompositionViewModeNumber = [[NSNumber alloc] initWithUnsignedInteger:photoponNewPhotoponCompositionViewMode];
    
    self.photoponInfoImage = (self.photoponNewPhotoponCompositionViewMode==PhotoponNewPhotoponCompositionViewModeCreate)?[PhotoponNewPhotoponUtility photoponInfoCreationImage]:[PhotoponNewPhotoponUtility photoponInfoConfirmationImage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidChangeViewMode object:nil];
}

- (void)handleTutorialShareViewTapped{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponTutorialShareContainer setUserInteractionEnabled:NO];
    [self fadeOutView:self.photoponTutorialShareContainer];
    
    //[self.photoponTutorialShareContainer removeFromSuperview];
    
    self.shouldShowTooltipShare = NO;
    
    //[self.photoponInfoCreationView setAlpha:0.0f];
    //[self.photoponInfoCreationView setHidden:YES];
    
}

- (void)handleInfoViewTapped{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponInfoContainer setUserInteractionEnabled:NO];
    
    [self fadeOutView:self.photoponInfoContainer];
    
    
    
    //[self.photoponInfoCreationView setAlpha:0.0f];
    //[self.photoponInfoCreationView setHidden:YES];
    
}

- (void)handleTapToEdit{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self fadeInView:self.photoponEditCaptionView];
    [self.textField becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.photoponEditCaptionToolBar setAlpha:1.0f];
    //[self.photoponEditCaptionToolBar setHidden:NO];
    
    [UIView animateWithDuration:0.200f animations:^{
        
        self.photoponEditCaptionToolBar.frame = [PhotoponNewPhotoponUtility photoponEditCaptionToolbarFrameActive];
        
    }];
    
    
    /*
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height += keyboardFrameEnd.size.height;
    [self.scrollView setContentSize:scrollViewContentSize];
    
    CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
    // Align the bottom edge of the photo with the keyboard
    scrollViewContentOffset.y = scrollViewContentOffset.y + keyboardFrameEnd.size.height*3.0f - [UIScreen mainScreen].bounds.size.height;
    
    [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
     */
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView animateWithDuration:0.200f animations:^{
        
        self.photoponEditCaptionToolBar.frame = [PhotoponNewPhotoponUtility photoponEditCaptionToolbarFrameDefault];
        
    }];
    
    
    
    /*
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.scrollView setContentSize:scrollViewContentSize];
    }];
     */
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     if (textField == textViewPlaceHolderField) {
     return NO;
     }
     */
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //currentEditingTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    /*currentEditingTextField = nil;
     #ifdef DEBUG
     if ([textField.text isEqualToString:@"#%#"]) {
     [NSException raise:@"FakeCrash" format:@"Nothing to worry about, textField == #%#"];
     }
     #endif
     
     _hasChangesToAutosave = YES;
     [self autosaveContent];
     [self autosaveRemote];
     [self refreshButtons];
     */
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     if (textField == titleTextField) {
     self.apost.postTitle = [textField.text stringByReplacingCharactersInRange:range withString:string];
     self.navigationItem.title = [self editorTitle];
     
     } else if (textField == tagsTextField)
     self.post.tags = [tagsTextField.text stringByReplacingCharactersInRange:range withString:string];
     
     _hasChangesToAutosave = YES;
     [self refreshButtons];
     return YES;
     */
    
    
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *newCaption = self.textField.text;
    NSDictionary *captionEditUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         newCaption, @"captionText", nil];
    
    
    
    //[[[PhotoponMediaModel newPhotoponDraft] photoponMediaImageFile] setImage:newImage];
    //[[PhotoponMediaModel newPhotoponDraft].dictionary setObject:newCaption forKey:kPhotoponMediaAttributesCaptionKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidEditCaption object:nil userInfo:captionEditUserInfo];
    
    [textField resignFirstResponder];
    [self fadeOutView:self.photoponEditCaptionView];
    
    return YES;
    
}

- (void) resetSession{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.imageViewConfirmation.image = nil;
    self.photoponImageConfirmation = nil;
    
    
    
    self.photoponNewPhotoponCompositionViewMode = PhotoponNewPhotoponCompositionViewModeCreate;
    
}

- (void) photoponDidCancelLibrary{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self resetSession];
    [self configureViewForModeClose];
    
    
    
    //self.photoponNewPhotoponCompositionViewMode = PhotoponNewPhotoponCompositionViewModeCreate;
    //self.imageViewConfirmation.image = nil;
    
    //self.imageView.image = nil;
    
    /*
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(performViewResetWithTimedAnimation) withObject:nil waitUntilDone:NO];
    } else {
        [self performViewResetWithTimedAnimation];
    }*/

}

- (void) photoponDidChooseFromLibrary{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(dismissLibraryViewController) withObject:nil waitUntilDone:NO];
	} else {
		[self dismissLibraryViewController];
	}
}

- (void) dismissLibraryViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.view bringSubviewToFront:self.photoponCreationToolBar];
    //[self.photoponCreationToolBar setAlpha:1.0f];
    
    
    [self configureViewForModeClose];
    [self photoponDismissSemiModalViewWithController:self.picker.mediaUI];
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        
    //[self.photoponCreationToolBar setFrame:CGRectMake(0.0f, 54.0f, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height)];
        
    //[self presentToolbar];
        
    //});

    
    
    
    
    //[self.picker.mediaUI dismissSemiModalView];
    
    
    /*
    [[self.picker.mediaUI parentViewController] dismissSemiModalViewWithCompletion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [[self.picker.mediaUI parentViewController] dismissViewControllerAnimated", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.photoponCreationToolBar setFrame:CGRectMake(0.0f, 54.0f, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height)];
            
            [self presentToolbar];
            
        });
    }];*/

}

- (UIImage*) currentInfoImage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (self.photoponNewPhotoponCompositionViewMode==PhotoponNewPhotoponCompositionViewModeCreate)?[PhotoponNewPhotoponUtility photoponInfoCreationImage]:[PhotoponNewPhotoponUtility photoponInfoConfirmationImage];
}

- (void)resetInfoViews{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponInfoContainer removeFromSuperview];
    
    [self.photoponInfoContainer setHidden:NO];
    [self.photoponInfoContainer setAlpha:1.0f];
    
    self.photoponInfoImage = [self currentInfoImage];
    [self.photoponInfoImageView removeFromSuperview];
    [self.photoponInfoImageView setImage:self.photoponInfoImage];
    [self.photoponInfoContainer addSubview:self.photoponInfoImageView];
    [self.photoponInfoContainer setHidden:YES];
    [self.photoponInfoContainer setAlpha:0.0f];
    [self.view addSubview:self.photoponInfoContainer];
    
}

- (void) resetContainerFrames{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self resetInfoViews];
    
    /**
     ---------------------------------------------------------------
     FIRST - ensure proper container sizing & positioning
     ---------------------------------------------------------------
     **/
    [self.view setFrame:[PhotoponNewPhotoponUtility photoponOverlayFrame]];
    [self.photoponFlashLightingEffectOverlay setFrame:self.view.bounds];//[PhotoponNewPhotoponUtility photoponOverlayFrame]];
    [self.photoponInfoContainer setFrame:self.view.bounds];
    [self.photoponHeaderPanel setFrame:[PhotoponNewPhotoponUtility photoponHeaderFrame]];
    [self.photoponOfferPagesContainer setFrame:[PhotoponNewPhotoponUtility photoponOffersContainerFrame]];
    
    
    [self.photoponImageConfirmationContainer setFrame:self.view.bounds];//[PhotoponNewPhotoponUtility photoponOffersContainerFrame]];
    [self.imageViewConfirmation setFrame:[PhotoponNewPhotoponUtility photoponCropFrame]];
    
    
    //[self.photoponOfferPagesContainer setFrame:[PhotoponNewPhotoponUtility photoponOffersContainerFrame]];
    [self.photoponFooterPanel setFrame:[PhotoponNewPhotoponUtility photoponFooterFrame]];
    [self.photoponSecondaryNavigationToolBar setFrame:[PhotoponNewPhotoponUtility photoponSecondaryToolbarFrameDefault]];
    [self.photoponToolBarContainer setFrame:[PhotoponNewPhotoponUtility photoponToolbarContainerFrame]];
    [self.photoponEditCaptionView setFrame:self.view.bounds];//[PhotoponNewPhotoponUtility photoponEditCaptionFrame]];
    
    [self.topMaskView setFrame:[PhotoponNewPhotoponUtility photoponHeaderFrame]];
    
    
    [self.bottomMaskView setFrame:CGRectMake([PhotoponNewPhotoponUtility photoponFooterFrame].origin.x, [PhotoponNewPhotoponUtility photoponFooterFrame].origin.y - [PhotoponNewPhotoponUtility photoponOffersToolbarFrame].size.height, [PhotoponNewPhotoponUtility photoponFooterFrame].size.width, [PhotoponNewPhotoponUtility photoponFooterFrame].size.height + [PhotoponNewPhotoponUtility photoponOffersToolbarFrame].size.height)];
    
    [self.photoponNewPhotoponOffersViewController configurePhotoponOffersView];
    [self.photoponOfferPagesContainer setFrame:[PhotoponNewPhotoponUtility photoponOffersContainerFrame]];
    
}

- (void) restackOverlaySubviews{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self resetContainerFrames];
    
    // FLASH LIGHTING EFFECTS
    [self.view bringSubviewToFront:self.photoponFlashLightingEffectOverlay];
    
    // MASKS
    [self.view bringSubviewToFront:self.topMaskView];
    [self.view bringSubviewToFront:self.bottomMaskView];
    
    // CONFIRMATION IMAGE
    [self.view bringSubviewToFront:self.photoponImageConfirmationContainer];
    [self.photoponImageConfirmationContainer bringSubviewToFront:self.imageViewConfirmation];
    
    // OFFER PAGES
    [self.view bringSubviewToFront:self.photoponOfferPagesContainer];
    [self.photoponOfferPagesContainer bringSubviewToFront:self.photoponNewPhotoponOffersViewController.view];
    [self.photoponOfferPagesContainer bringSubviewToFront:self.photoponNewPhotoponShutterViewController.view];
    
    // HEADER
    [self.view bringSubviewToFront:self.photoponHeaderPanel];
    
    // FOOTER
    [self.view bringSubviewToFront:self.photoponFooterPanel];
    [self.photoponFooterPanel bringSubviewToFront:self.photoponDirectionalPrompt];
    [self.photoponFooterPanel bringSubviewToFront:self.photoponSecondaryNavigationToolBar];
    
    // TOOLBARS
    [self.view bringSubviewToFront:self.photoponToolBarContainer];
    [self.photoponToolBarContainer bringSubviewToFront:self.photoponConfirmationToolBar];
    [self.photoponToolBarContainer bringSubviewToFront:self.photoponCreationToolBar];
    
    // INFO
    [self.view bringSubviewToFront:self.photoponInfoContainer];
    [self.photoponInfoContainer bringSubviewToFront:self.photoponInfoImageView];
    
    // EDIT CAPTION
    [self.view bringSubviewToFront:self.photoponEditCaptionView];
    [self.photoponEditCaptionView bringSubviewToFront:self.photoponEditCaptionToolBar];
    
    if (self.shouldShowTooltipShare) {
        [self.view bringSubviewToFront:self.photoponTutorialShareContainer];
        [self.photoponTutorialShareContainer bringSubviewToFront:self.photoponTutorialShareImageView];
        [self.photoponTutorialShareContainer bringSubviewToFront:self.photoponBtnTutorialShare];
    }
    
}

#pragma - Action Handlers

- (IBAction)photoponBtnInfoHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self fadeInView:self.photoponInfoContainer];
    
    [self.photoponInfoContainer setUserInteractionEnabled:YES];
    
    
}

- (IBAction)photoponBtnShareAppHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(showShareApp) withObject:nil waitUntilDone:NO];
    } else {
        [self showShareApp];
    }
    
}

-(void)showShareApp{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidShowShareApp object:nil];
    
    
    
    //[self.picker removePhotoponObservers];
    
    
    
    
    
    // removeObserver:nil];// forKeyPath:<#(NSString *)#> removeObserver:@selector(cameraDidStartRunning:) name:AVCaptureSessionDidStartRunningNotification object:nil];
    
    
    
    //[self.picker.mediaUI pushViewController:self.smsMessageViewController animated:YES];
    
    
    
    
    
    //[[[PhotoponAppDelegate sharedPhotoponApplicat ionDelegate] navController] presentSemiViewController:self.smsMessageViewController withOptions:nil completion:nil dismissBlock:nil];
    //[self presentViewController:smsMessageViewController animated:YES completion:nil];
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MFMessageComposeViewController *smsMessageViewController = [[MFMessageComposeViewController alloc] init];
        
        smsMessageViewController.messageComposeDelegate = self;
        
        smsMessageViewController.body = [PhotoponUtility appShareMessage];
        
        [self presentViewController:smsMessageViewController animated:YES completion:nil];
        
    });
     */
}

- (IBAction)photoponBtnCancelHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Here's how to call dismiss button on the parent ViewController
    // be careful with view hierarchy
    
    
    //[self.picker.mediaUI.view removeFromSuperview];
    //[self.picker.mediaUI removeFromParentViewController];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO]; //withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    
    [self.picker dismissAnimated:YES];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidCancelNewPhotoponComposition object:nil];
    
    /*
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
     
    */
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate.navController dismissNewPhotoponPickerControllerAnimated:YES doUpload:NO];
}

- (IBAction)photoponBtnCameraHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self performTakePhoto];
}

- (void) fireCameraFlash {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponFlashLightingEffectOverlay setAlpha: 0.0f];
    [self.photoponFlashLightingEffectOverlay setHidden:NO];
    
    [UIView animateWithDuration:FADE_TIMING_SHORTENED delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.photoponFlashLightingEffectOverlay.alpha = 1.0f;
    
    }completion:^(BOOL finished) {
        if (finished) {
            
            [self.photoponFlashLightingEffectOverlay setAlpha: 1.0f];
            
            [UIView animateWithDuration:FADE_TIMING_SHORTENED delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.photoponFlashLightingEffectOverlay.alpha = 0.0f;
            }completion:^(BOOL finished) {
                
                if (finished) {
                    
                    [self.photoponFlashLightingEffectOverlay setAlpha: 0.0f];
                    [self.photoponFlashLightingEffectOverlay setHidden:YES];
                
                }
            }];
        }
    }];    
}

- (void)playTakePhotoEffects{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self tickFire:nil];
    [self fireCameraFlash];
    
}

- (void) performTakePhoto{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.libPhotos = nil;
    [self.photoponBtnCamera setUserInteractionEnabled:NO];
    
    if (!self.picker.mediaUI) {
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"media UI is nil" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        return;
    }
    
    [self.picker.mediaUI takePicture];
    
    
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(playTakePhotoEffects) withObject:nil waitUntilDone:NO];
    } else {
        [self playTakePhotoEffects];
    }
    
    
    
    
    /*
     
     PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
     [appDelegate.navController takePhotoponPhoto];
    
     
     // PUSH VC ANIMATIONS
     UIViewController *nextView = [[UIViewController alloc] init];
     [UIView animateWithDuration:0.75
     animations:^{
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [self.photoponNewPhotoponTagCouponViewController.navigationController pushViewController:nextView animated:NO];
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
     
     
     }];
     // POP VC ANIMATIONS
     [UIView animateWithDuration:0.75
     animations:^{
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
     }];
     [self.navigationController popViewControllerAnimated:NO];
     * /
     
     [CATransaction begin];
     CATransition *animation = [CATransition animation];
     animation.delegate = self;
     animation.duration = .3;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeForwards;
     
     animation.type = @"cameraIrisHollowClose";
     [self.view.window.layer addAnimation:animation forKey:@"shutterCloseAnimation"];
     [CATransaction commit];
     * /
     
     [CATransaction begin];
     CATransition *animation = [CATransition animation];
     animation.delegate = self;
     animation.duration = .3;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeForwards;
     
     animation.type = @"cameraIrisHollowClose";
     [self.photoponNewPhotoponTagCouponViewController.photoponPagesContainerView.layer addAnimation:animation forKey:@"shutterCloseAnimation"];
     [CATransaction commit];
     
     */
    
    
    
    //[self showHUDWithStatusText:@"Processsing"];
    
}
/*
- (void) didMoveToParentViewController:(id)parent{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didMoveToParentViewController:parent];
    
 
    
    
    / *
    if ([[parent className] isEqualToString:@"PhotoponImagePickerController"]) {
        [self.photoponNewPhotoponShutterViewController open];
        [self.photoponNewPhotoponOffersViewController loadOffers];
    }* /
    
}
*/
/*
- (void) beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super beginAppearanceTransition:isAppearing animated:animated];
    
    
    
}
*/

- (IBAction)photoponBtnLibraryHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(performPickerSourceSwap) withObject:nil waitUntilDone:NO];
    } else {
        [self performPickerSourceSwap];
    }
    
    //[self.picker showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

- (void)performPickerSourceSwap{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.picker.sourceType =]
    
    
    [self.picker.mediaUI setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponPickerControllerDidChangeSourceType object:nil];
    
    //self.photoponNewPhotoponCompositionViewMode = PhotoponNewPhotoponCompositionViewModeConfirm;
    
}

















#pragma - Ported From PhotoponNewPhotoponTagCouponViewController

- (IBAction)photoponBtnRefreshHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponNewPhotoponOffersViewController loadOffers];
    
}

- (IBAction)photoponBtnPlaceHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (IBAction)photoponBtnRetakeHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(photoponBtnRetakeHandlerOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self photoponBtnRetakeHandlerOnMainThread];
    }
    
    
    
    
    
    //[self performViewResetWithTimedAnimation];
    //[self.view setNeedsDisplay];
}

- (IBAction)photoponBtnRetakeHandlerOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    
    
    
    [self beginAppearanceTransitionFromViewModeConfirmation];
}

- (void)prepareNextStepInBackgroundWithBlock:(void (^)(NSError *error, PhotoponCouponModel *coupon))block{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"Page Control"
                                                         message:[NSString stringWithFormat:@"currentPage: %i", self.photoponNewPhotoponTagCouponViewController.photoponPagesScrollView.currentPage]
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                               otherButtonTitles:nil];
    
    [alertCheck show];
    */
    
    
    
    NSError *error;
    
    PhotoponCouponModel *coupon = [self.photoponNewPhotoponOffersViewController processedObjectAtIndexPath:[NSIndexPath indexPathForRow:self.photoponNewPhotoponOffersViewController.photoponPagesScrollView.currentPage inSection:0]];
    
    if (block)
        block(error, coupon);
}

- (void)didSnapPhoto{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self showHUDWithStatusText:@"Processing"];
    
    [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---------->         [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){          BEGIN BLOCK, BEGIN BLOCK, BEGIN BLOCK");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        /*
        if (error) {
            
            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor network connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
            
        }
        */
    }];
}

- (IBAction)photoponBtnNextHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"photoponBtnNextHandler 0");
    
    
    // screenshot for sharing
    
    
    [self.photoponNewPhotoponOffersViewController.photoponPagesContainerView insertSubview:self.imageViewConfirmation atIndex:0];
    
    [[PhotoponMediaModel newPhotoponDraft] takeScreenshot:self.photoponNewPhotoponOffersViewController.photoponPagesContainerView];
    
    
    
    [self.photoponNewPhotoponOffersViewController prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---------->         [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){          BEGIN BLOCK, BEGIN BLOCK, BEGIN BLOCK");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        /*
        if (error) {
            
            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor network connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
            
        }
        */
        
        NSLog(@"photoponBtnNextHandler 1");
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (photoponMediaModel==nil) {
            photoponMediaModel = appDelegate.tabBarController.photoponNewMediaDraft; //[PhotoponMediaModel newPhotoponDraft];
        }
        
        NSString *t = [[NSString alloc] initWithFormat:@"%@", self.textField.text];
        
        [photoponMediaModel.dictionary setObject:t forKey:kPhotoponMediaAttributesCaptionKey];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---->            self.textField.text = %@", self.textField.text);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        NSLog(@"photoponBtnNextHandler 2");
        
        [PhotoponMediaModel setNewPhotoponDraft:photoponMediaModel];
        
        NSLog(@"photoponBtnNextHandler 3");
        
        [self.picker dismissAndUploadAnimated:YES];
        
        //self.picker.completionBlock(nil, nil);
        
    }];
    
    NSLog(@"photoponBtnNextHandler 4");
    
}

- (void)updateCroppedImageViewWithImage:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self hideHud];
    
    // HIDE HUD
    /*
     [CATransaction begin];
     CATransition *animation = [CATransition animation];
     animation.delegate = self;
     animation.duration = .3;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeForwards;
     
     animation.type = @"cameraIrisHollowOpen";
     [self.photoponNewPhotoponTagCouponViewController.photoponPagesContainerView.layer addAnimation:animation forKey:@"shutterOpenAnimation"];
     [CATransaction commit];
     */
    
    
    
    
    self.photoponImageConfirmation = (UIImage*)sender;
    
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateCroppedImageViewWithImageOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self updateCroppedImageViewWithImageOnMainThread];
	}
    
    
    
}

- (void)updateCroppedImageViewWithImageOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self slideOutCreationToolbar];// slideOutView:self.photoponCreationToolBar];
    
    [self.imageViewConfirmation setImage:self.photoponImageConfirmation];
    
    
    
    [self fadeMaskColor:1.0f];
    
    [self.photoponBtnCamera setUserInteractionEnabled:YES];
    
    self.photoponNewPhotoponCompositionViewMode = PhotoponNewPhotoponCompositionViewModeConfirm;
    
}

- (void) configureSolidBlackBGColorForMaskViews{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self configureBlackBGColorForView:self.topMaskView withAlpha:1.0f];
    [self configureBlackBGColorForView:self.bottomMaskView withAlpha:1.0f];    
}

- (void)didLoadOffers:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self initFirstTimeUserChecks];
    
    /*
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(didOpenShutterOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self didOpenShutterOnMainThread];
	}*/
    
    
    
    
}

- (void)didOpenShutter:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(didOpenShutterOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self didOpenShutterOnMainThread];
	}
}

- (void)didOpenShutterOnMainThread
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponNewPhotoponShutterViewController.view removeFromSuperview];
    
    [self.picker.mediaUI viewWillAppear:YES];
    [self.picker.mediaUI viewDidAppear:YES];
    
    
    
    [self configureViewForModeOpen];
    
    [self fadeMaskColor:PHOTOPON_OVERLAY_ALPHA];
    
    
    
    
    
    /*
    UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"Overlay Frame"
                                                         message:[NSString stringWithFormat:@"x = %f, y = %f, width = %f, height = %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height]
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                               otherButtonTitles:nil];
    
    [alertCheck show];
    
    UIAlertView *alertCheckBounds = [[UIAlertView alloc] initWithTitle:@"Overlay Bounds"
                                                         message:[NSString stringWithFormat:@"x = %f, y = %f, width = %f, height = %f", self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height]
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                               otherButtonTitles:nil];
    
    [alertCheckBounds show];
    */
    
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        if( !weakSelf.photoponNewPhotoponOffersViewController.objects.count>0 )
            [weakSelf.photoponNewPhotoponOffersViewController loadOffers];
    });
}

- (void)didCloseShutter:(NSNotification *)notification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(didCloseShutterOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self didCloseShutterOnMainThread];
	}
}

- (void)didCloseShutterOnMainThread
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self performViewResetWithTimedAnimation];
    
    [self resetSession];
    
    
    
}


- (void)didCropImage:(NSNotification *)notification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateCroppedImageViewWithImage:) withObject:[[PhotoponMediaModel newPhotoponDraft] croppedImage] waitUntilDone:NO];
	} else {
		[self updateCroppedImageViewWithImage:[[PhotoponMediaModel newPhotoponDraft] croppedImage]];
	}
}

#pragma mark - HUD methods

- (void) initHUD {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    HUD = [[MBProgressHUD alloc] initWithView:appDelegate.navController.view];
	[appDelegate.navController.view addSubview:HUD];
	HUD.delegate = self;
    HUD.labelText = @"Processing";
	
    //HUD.minSize = CGSizeMake(140.f, 115.f);
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
        status = @"Loading";
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
        status = @"Loading";
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
#pragma mark Application state handlers

- (void) photoponDidEnterBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(processDidEnterBackground) withObject:nil waitUntilDone:NO];
	} else {
		[self processDidEnterBackground];
	}
}

- (void) processDidEnterBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponNewPhotoponShutterViewController configureViewForModeClose];
}

- (void) photoponDidEnterForeground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(processDidEnterForeroundOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self processDidEnterForeroundOnMainThread];
	}
}

- (void) processDidEnterForeroundOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (void) photoponWillEnterForeground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(processWillEnterForeground) withObject:nil waitUntilDone:NO];
	} else {
		[self processWillEnterForeground];
	}
}

- (void) processWillEnterForeground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self performViewResetWithTimedAnimation];
    
}

- (void) photoponDidBecomeActive{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.picker.mediaUI viewWillAppear:NO];
    //[self.picker.mediaUI viewDidAppear:NO];
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(processDidBecomeActive) withObject:nil waitUntilDone:NO];
	} else {
		[self processDidBecomeActive];
	}
}

- (void) processDidBecomeActive{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.picker.mediaUI viewWillAppear:NO];
    //[self.picker.mediaUI viewDidAppear:NO];
    
    
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

#pragma - MFMessageComposeViewController Delegate methods

// Then implement the delegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"Entered messageComposeController");
    switch (result) {
        case MessageComposeResultSent:
        {
            
            NSLog(@"SENT");
            //[self showHUDWithStatusText:@"SENT"];
            
            if (![NSThread isMainThread]) {
                [self performSelectorOnMainThread:@selector(dismissMessageViewController) withObject:nil waitUntilDone:NO];
            } else {
                [self dismissMessageViewController];
            }
            
        }
            break;
        case MessageComposeResultFailed:
        {
            
            NSLog(@"FAILED");
            //[self showHUDWithStatusText:@"Failed"];
            
            if (![NSThread isMainThread]) {
                [self performSelectorOnMainThread:@selector(dismissMessageViewController) withObject:nil waitUntilDone:NO];
            } else {
                [self dismissMessageViewController];
            }
        }
            break;
        case MessageComposeResultCancelled:
        {
            
            NSLog(@"CANCELLED");
            //[self showHUDWithStatusText:@"CANCELLED"];
            
            if (![NSThread isMainThread]) {
                [self performSelectorOnMainThread:@selector(dismissMessageViewController) withObject:nil waitUntilDone:NO];
            } else {
                [self dismissMessageViewController];
            }
            
        }
            break;
    }
    
    // fix the toolbar positioi=ning
    //[self presentToolbar];
    
    
    
}

- (void)photoponDismissSemiModalCustomSelf {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Here's how to call dismiss button on the parent ViewController
    // be careful with view hierarchy
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}

- (void)dismissMessageViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (!self.photoponTutorialShareContainer.isHidden)
        [self handleTutorialShareViewTapped];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidHideShareApp object:nil];
    
    
    
    /*
    
    
    //[self photoponDismissSemiModalCustomSelf];
    
    // Here's how to call dismiss button on the parent ViewController
    // be careful with view hierarchy
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalViewWithCompletion:)]) {
        [parent dismissSemiModalViewWithCompletion:^{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [[self.picker.mediaUI parentViewController] dismissViewControllerAnimated", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.photoponCreationToolBar setFrame:CGRectMake(0.0f, 54.0f, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height)];
                
                [self presentToolbar];
                
            });
        }];
        
    }

    */
    
    
    /*
    [self dismis dismisssem dismissSemiModalViewWithCompletion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [[self.picker.mediaUI parentViewController] dismissViewControllerAnimated", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.photoponCreationToolBar setFrame:CGRectMake(0.0f, 54.0f, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height)];
            
            [self presentToolbar];
            
        });
    }];*/
    
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [[self.picker.mediaUI parentViewController] dismissViewControllerAnimated", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.photoponCreationToolBar setFrame:CGRectMake(0.0f, 54.0f, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height)];
            
            [self presentToolbar];
            
        });
    }];
    */
    
    
    
    [self hideHudAfterDelay:1.0f];
    
    [self.view bringSubviewToFront:self.photoponCreationToolBar];
    
    [self.photoponCreationToolBar setAlpha:1.0f];
    
    
    
    /*
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.view bringSubviewToFront:self.photoponNewPhotoponTagCouponViewController.view];
            [self.view bringSubviewToFront:self.photoponHeaderPanel];
            [self.view bringSubviewToFront:self.photoponToolBarContainer];
            
            [self.photoponToolBarContainer bringSubviewToFront:self.photoponConfirmationToolBar];
            [self.photoponToolBarContainer bringSubviewToFront:self.photoponCreationToolBar];
            
            [self.view bringSubviewToFront:self.photoponInfoConfirmationView];
            [self.view bringSubviewToFront:self.photoponInfoCreationView];
            [self.view bringSubviewToFront:self.photoponEditCaptionView];
            
            [self.photoponCreationToolBar setAlpha:1.0f];
            
            //[self.photoponCreationToolBar setFrame:CGRectMake(0.0f, 54.0f, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height)];
                
            [self presentToolbar];
            
        });
    }];
     */
}

- (IBAction)photoponBtnEditCaptionCancelHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.textField resignFirstResponder];
    [self fadeOutView:self.photoponEditCaptionView];
    
}

- (IBAction)photoponBtnEditCaptionDoneHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self textFieldShouldReturn:self.textField];
    
}

- (IBAction)photoponBtnFlashAutoHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setCameraFlashModeNumber: [NSNumber numberWithUnsignedInteger:UIImagePickerControllerCameraFlashModeAuto]];
    
    self.picker.mediaUI.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    [self.photoponBtnFlashOff setSelected:NO];
    [self.photoponBtnFlashOn setSelected:NO];
    [self.photoponBtnFlashAuto setSelected:YES];
}

- (IBAction)photoponBtnFlashOnHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setCameraFlashModeNumber: [NSNumber numberWithUnsignedInteger:UIImagePickerControllerCameraFlashModeOn]];
    
    self.picker.mediaUI.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    
    [self.photoponBtnFlashOff setSelected:NO];
    [self.photoponBtnFlashOn setSelected:YES];
    [self.photoponBtnFlashAuto setSelected:NO];
}

- (IBAction)photoponBtnFlashOffHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self setCameraFlashModeNumber: [NSNumber numberWithUnsignedInteger:UIImagePickerControllerCameraFlashModeOff]];
    
    self.picker.mediaUI.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    
    [self.photoponBtnFlashOff setSelected:YES];
    [self.photoponBtnFlashOn setSelected:NO];
    [self.photoponBtnFlashAuto setSelected:NO];
    
}

- (IBAction)photoponBtnSwitchHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.cameraDevice = (self.cameraDevice == UIImagePickerControllerCameraDeviceFront)?UIImagePickerControllerCameraDeviceRear:UIImagePickerControllerCameraDeviceFront;
}

- (IBAction)photoponBtnSettingsHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(toggleSecondaryToolbarOnMainThread) withObject:nil waitUntilDone:NO];
	} else {
		[self toggleSecondaryToolbarOnMainThread];
	}
}

-(void) toggleSecondaryToolbarOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.photoponSecondaryNavigationToolBar.frame.origin.y>=self.photoponSecondaryNavigationToolBar.frame.size.height)
        [self slideInView:self.photoponSecondaryNavigationToolBar];
    else
        [self slideOutView:self.photoponSecondaryNavigationToolBar];
}

- (IBAction)photoponBtnTutorialShareHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(showShareApp) withObject:nil waitUntilDone:NO];
    } else {
        [self showShareApp];
    }
    
}

-(void) closeSecondaryToolbarOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.photoponSecondaryNavigationToolBar.frame.origin.y>0) {
        
        
        
        
    }
}

/*

-(void) updateFlashModeMenu{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self setCameraFlashModeNumber: [NSNumber numberWithUnsignedInteger:UIImagePickerControllerCameraFlashModeAuto]];
}*/



@end
