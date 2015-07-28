//
//  PhotoponNewPhotoponCompositionViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 9/18/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewPhotoponCompositionViewController.h"
#import "PhotoponNewPhotoponShutterViewController.h"
#import "PhotoponNewPhotoponOverlayViewController.h"
#import "PhotoponNewPhotoponPickerController.h"
//#import "PhotoponUIImagePickerController.h"
#import "PhotoponImagePickerController.h"
#import "PhotoponNewPhotoponPickerController.h"
#import "PhotoponNewPhotoponConstants.h"
#import "PhotoponUtility.h"
#import "PhotoponNewPhotoponUtility.h"
#import "PhotoponNewPhotoponOffersViewController.h"

@interface PhotoponNewPhotoponCompositionViewController ()
//@property(nonatomic,weak) IBOutlet UIImageView *imageView;
//@property(nonatomic,strong) PhotoponNewPhotoponPickerController *pickPhotoController;
@end

@implementation PhotoponNewPhotoponCompositionViewController

@synthesize photoponImagePickerController;
@synthesize photoponNewPhotoponOverlayViewController;

@synthesize photoponPlaceholderPresentationImageView;

/*
// container views
@synthesize overlayContainer;
@synthesize shutterContainer;
@synthesize offersContainer;
@synthesize pickerContainer;

@synthesize pickerContainerController;
@synthesize offersContainerController;
@synthesize shutterContainerController;
@synthesize overlayContainerController;
@synthesize modalContainerController;
*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //self.tabBarItem.image = [UIImage imageNamed:@"second"];
        
        // Take note that you need to take ownership of the ViewController that is being presented
        //modalVC  = [[KNThirdViewController alloc] initWithNibName:@"KNThirdViewController" bundle:nil];
        
        // self.shutterContainerController = [[PhotoponNewPhotoponShutterViewController alloc] initWithNibName:@"PhotoponNewPhotoponShutterViewController" bundle:nil];
        
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    [self.view setFrame:[PhotoponNewPhotoponUtility photoponOverlayFrame]];
    
    if ([PhotoponUtility isTallScreen]) {
        [self.photoponPlaceholderPresentationImageView setImage:[UIImage imageNamed:@"PhotoponPlaceholderNewPhotoponOverlay-568h@2x.png"]];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    //[self.pickPhotoController.mediaUI
    
    //if (self.pickPhotoController.mediaUI) {
      //  [self.photoponNewPhotoponOverlayViewController openShutter];
        
    //}
    
    
}

-(void)setUpView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFindNoCoupons:)
                                                 name:PhotoponNotificationPhotoponNewPhotoponOffersViewControllerDidFindNoCoupons
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didShowShareApp:)
                                                 name:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidShowShareApp
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didHideShareApp:)
                                                 name:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidHideShareApp
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didCancelNewPhotoponComposition:)
                                                 name:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidCancelNewPhotoponComposition
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePickerSourceType:)
                                                 name:PhotoponNotificationPhotoponNewPhotoponPickerControllerDidChangeSourceType
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeViewMode:)
                                                 name:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidChangeViewMode
                                               object:nil];
    
    // semi-modal stuff
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalPresented:)
                                                 name:kSemiModalDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalResized:)
                                                 name:kSemiModalWasResizedNotification
                                               object:nil];
    
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.photoponNewPhotoponOverlayViewController = [[PhotoponNewPhotoponOverlayViewController alloc] initWithNibName:@"PhotoponNewPhotoponOverlayViewController" bundle:nil withCropOverlaySize:CROP_SIZE];
    self.photoponImagePickerController = [[PhotoponImagePickerController alloc] init]; // initWithDelegate:self];
    
    // add as child view controller
    [self addChildViewController:self.photoponImagePickerController];
    [self.view addSubview:self.photoponImagePickerController.view];
    [self.photoponImagePickerController didMoveToParentViewController:self];
    
    
    [self addChildViewController:self.photoponNewPhotoponOverlayViewController];
    [self.view insertSubview:self.photoponNewPhotoponOverlayViewController.view aboveSubview:self.photoponImagePickerController.view];
    [self.photoponNewPhotoponOverlayViewController didMoveToParentViewController:self];
    
    
    
    
    
    
    
    
    
    
    [self addPhotoPickerController];
    
    //[self.view setNeedsLayout];
    //[self.view setNeedsDisplay];
    
    [self.photoponPlaceholderPresentationImageView removeFromSuperview];
    
    
}




/**
 OBSOLETE
    / *
    // POP VC ANIMATIONS
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
    * /
    
    / *
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

    / *
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
    * /
    / *
    self.overlayContainerController = [CameraOverlayView new];
    self.overlayView.alpha = 0;
    self.cameraController.cameraOverlayView = self.overlayView;
    * /
}
*/

- (PhotoponNewPhotoponPickerController *)photoController
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    //__weak __typeof(&*self)weakSelf = self;
    
    
    
    return [[PhotoponNewPhotoponPickerController alloc] initWithPresentingViewController:self.photoponImagePickerController withOverlayViewController:self.photoponNewPhotoponOverlayViewController withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponTabBarControllerDidFinishEditingPhotoNotification object:nil];
        
    }];
}

- (void)didFindNoCoupons:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self removePhotoPickerControllerAndEndComposition];
    
    
    /*
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isUpdatingLocation)
        [appDelegate presentExplanationLocationServices];
    */
    
    UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"Local Coupons"
                                                         message:[NSString stringWithFormat:@"I can't find local offer templates. Check network connection and location services in Settings App."]
                                                        delegate:[PhotoponAppDelegate sharedPhotoponApplicationDelegate]
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                               otherButtonTitles:nil];
    [alertCheck show];
    
    
    
    //[self presentViewController:self.photoponNewPhotoponOverlayViewController.smsMessageViewController animated:YES completion:nil];
    
}

- (void)didShowShareApp:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self removePhotoPickerController];
    
    if ([MFMessageComposeViewController canSendText]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if ([MFMessageComposeViewController canSendText]) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if (self.photoponNewPhotoponOverlayViewController.smsMessageViewController) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            if (self.photoponNewPhotoponOverlayViewController.smsMessageViewController) { ", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [self presentViewController:self.photoponNewPhotoponOverlayViewController.smsMessageViewController animated:YES completion:nil];
        }
    }
    
}

- (void)didHideShareApp:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self addPhotoPickerController];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [[self.picker.mediaUI parentViewController] dismissViewControllerAnimated", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.photoponNewPhotoponOverlayViewController.photoponCreationToolBar setFrame:CGRectMake(0.0f, 54.0f, weakSelf.photoponNewPhotoponOverlayViewController.photoponCreationToolBar.frame.size.width, weakSelf.photoponNewPhotoponOverlayViewController.photoponCreationToolBar.frame.size.height)];
            
            [weakSelf.photoponNewPhotoponOverlayViewController presentToolbar];
            
            //[self.pickPhotoController addPhotoponObservers];
            
        });
    }];

    
    //[self dismissViewControllerAnimated:YES completion:nil];// dismissViewController:self.photoponNewPhotoponOverlayViewController.smsMessageViewController animated:YES completion:nil];
    
}

- (void)didCancelNewPhotoponComposition:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self removePhotoPickerControllerAndEndComposition];
    
    
    
    /*
    if(self.photoponNewPhotoponOverlayViewController.photoponNewPhotoponCompositionViewMode == PhotoponNewPhotoponCompositionViewModeConfirm)
        [self removePhotoPickerController];
    else
        [self addPhotoPickerController];
    
    //self.pickPhotoController.mediaUI.sourceType = self.pickPhotoController.sourceType;
    */
}


#pragma mark - Application state change

- (void)didChangeViewMode:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self removePhotoPickerController];
    
    if(self.photoponNewPhotoponOverlayViewController.photoponNewPhotoponCompositionViewMode == PhotoponNewPhotoponCompositionViewModeConfirm)
        [self removePhotoPickerController];
    else
        [self addPhotoPickerController];
    
    //self.pickPhotoController.mediaUI.sourceType = self.pickPhotoController.sourceType;
    
}

- (void)didChangePickerSourceType:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //[self.photoponImagePickerController.view removeFromSuperview];
    
    //[self.pickPhotoController.mediaUI.view removeFromSuperview];
    
    //self.pickPhotoController.sourceType = (self.pickPhotoController.sourceType==UIImagePickerControllerSourceTypeCamera)?UIImagePickerControllerSourceTypePhotoLibrary:UIImagePickerControllerSourceTypeCamera;
    //self.pickPhotoController.mediaUI.sourceType = self.pickPhotoController.sourceType;
    
    
   // [self.photoponImagePickerController.view addSubview:self.pickPhotoController.mediaUI.view];
    
    //[self.view addSubview:self.photoponImagePickerController.view];
    
    //[self.pickPhotoController showFromBarButtonItem:(id)[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] tabBarController] photoponCameraButton]];
    
    
    //[self.photoponImagePickerController.view];
    
    
    //self.pickPhotoController.showFromViewController = self;
    
    /*
    self.pickPhotoController = [[PhotoponNewPhotoponPickerController alloc] initWithPresentingViewController:self withOverlayViewController:self.photoponNewPhotoponOverlayViewController withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict){
                                
    }];
     */
    
    
    
    
    //if (!self.pickPhotoController){
        //self.pickPhotoController = [self photoController];
        //self.pickPhotoController.saveToCameraRoll = NO;
        //self.pickPhotoController.allowsEditing = NO;
        
        //[self.pickPhotoController showFromBarButtonItem:(id)[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] tabBarController] photoponCameraButton]];
    //}
    //else{
    
    
    //[self.view addSubview:self.pickPhotoController.mediaUI.view];
    
    //}
    
    //[self removePhotoPickerController];
    
    //[self addPhotoPickerController];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.popoverController dismissPopoverAnimated:YES];
    //self.popoverController = nil;
    
    //
    
    //[self.photoponNewPhotoponOverlayViewController photoponDidBecomeActive];
    
    
    [self addPhotoPickerController];
    
    //[self.photoponNewPhotoponOverlayViewController openShutter];
    
    
    
    /*
     if (self.completionBlock) {
     self.completionBlock(nil, nil);
     }*/
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self removePhotoPickerController];
    
    
    /*
    if (self.pickPhotoController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self removeCameraOverlay];
    }
    */
    
    
    /*
     
     [self.photoponNewPhotoponOverlayViewController photoponDidEnterBackground];
     
     
     
     [self.photoponNewPhotoponOverlayViewController removeFromParentViewController];
     
     //[self.photoponNewPhotoponOverlayViewController removeFromSuperview];
     
     [self addChildViewController:self.photoponNewPhotoponOverlayViewController];
     [self.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
     self.photoponImagePickerController.photoPickerController.mediaUI.cameraOverlayView = nil;
     */
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.photoponNewPhotoponOverlayViewController.photoponNewPhotoponCompositionViewMode==PhotoponNewPhotoponCompositionViewModeCreate){
        [self addPhotoPickerController];
    }
    
    
    
}

- (void) addCameraOverlay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(addCameraOverlayOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self addCameraOverlayOnMainThread];
    }
}

- (void) addCameraOverlayOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.pickPhotoController.mediaUI.cameraOverlayView = self.photoponNewPhotoponOverlayViewController.view;
    
}

- (void) removeCameraOverlay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(removeCameraOverlayOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self removeCameraOverlayOnMainThread];
    }
}

- (void) removeCameraOverlayOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.view removeFromSuperview];
    //[self.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
    //self.pickPhotoController.mediaUI.cameraOverlayView = nil;
    
}

- (void) addPhotoPickerController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.pickPhotoController){
        
        
        self.pickPhotoController = [self photoController];
        self.pickPhotoController.saveToCameraRoll = NO;
        self.pickPhotoController.allowsEditing = NO;
        
        self.pickPhotoController.photoponNewPhotoponOverlayViewController = self.photoponNewPhotoponOverlayViewController;
        
        
        
        [self.pickPhotoController showFromBarButtonItem:(id)[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] tabBarController] photoponCameraButton]];
    }
    else{
        [self.pickPhotoController.showFromViewController.view addSubview:self.pickPhotoController.mediaUI.view];
    }
}

- (void) removePhotoPickerControllerAndEndComposition {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self removeCameraOverlay];
    //[self.pickPhotoController.mediaUI removeFromParentViewController];
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self removePhotoPickerController];
    
    //[self.photoponNewPhotoponOverlayViewController removeFromParentViewController];
    
    
    //[self.photoponNewPhotoponOverlayViewController.photoponNewPhotoponOffersViewController.view removeFromSuperview];
    
    //[self.pickPhotoController.mediaUI dismissViewControllerAnimated:NO completion:nil];
    
    //self.pickPhotoController.mediaUI.cameraOverlayView = nil;
    
    //[self.photoponImagePickerController removeFromParentViewController];
    
    //[self.photoponImagePickerController.view removeFromSuperview];
    
    //[self.pickPhotoController.mediaUI.view removeFromSuperview];
    //self.pickPhotoController.mediaUI = nil;
    //self.pickPhotoController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
    //self.pickPhotoController = nil;
    
    //[self.photoponImagePickerController.view removeFromSuperview];
    //[self.photoponImagePickerController removeFromParentViewController];
    //self.photoponImagePickerController = nil;
    
    //[self.view insertSubview:self.photoponPlaceholderPresentationImageView belowSubview:self.photoponNewPhotoponOverlayViewController.view];
    //[self.photoponNewPhotoponOverlayViewController removeFromParentViewController];
    //[self.photoponNewPhotoponOverlayViewController.view removeFromSuperview];
    
    ///self.photoponNewPhotoponOverlayViewController = nil;
    //self.photoponImagePickerController = nil;
    
    
    
    
    [appDelegate.navController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [appDelegate.tabBarController dismissPhotoponCompositionView];
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.view removeFromSuperview];
    /*
    UIViewController *parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView:)]) {
        [parent dismissSemiModalView];
    }*/
}

- (void) removePhotoPickerController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self removeCameraOverlay];
    //[self.pickPhotoController.mediaUI removeFromParentViewController];
    
    
    
    [self.photoponNewPhotoponOverlayViewController.view removeFromSuperview]; // addSubview:self.photoponNewPhotoponOverlayViewController.view];
    [self.photoponNewPhotoponOverlayViewController removeFromParentViewController];
    
    [self addChildViewController:self.photoponNewPhotoponOverlayViewController];
    [self.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
    [self.photoponNewPhotoponOverlayViewController didMoveToParentViewController:self];
    
    [self.pickPhotoController.mediaUI.view removeFromSuperview];
    
}

/*
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.pickPhotoController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self removeCameraOverlay];
    }
    
    
    
    
    
    
    
    
    / *
     
     [self.photoponNewPhotoponOverlayViewController photoponDidEnterBackground];
     
     
     
     [self.photoponNewPhotoponOverlayViewController removeFromParentViewController];
     
     //[self.photoponNewPhotoponOverlayViewController removeFromSuperview];
     
     [self addChildViewController:self.photoponNewPhotoponOverlayViewController];
     [self.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
     self.photoponImagePickerController.photoPickerController.mediaUI.cameraOverlayView = nil;
     * /
    
}
*/



- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //if (status) {
        //
    //}
    
}

- (void)viewDidUnload{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidUnload];
    
    
    /*
    self.pickPhotoController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
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
- (IBAction)dismissButtonDidTouch:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(photoponDismissSemiModalSelf) withObject:nil waitUntilDone:NO];
    } else {
        [self photoponDismissSemiModalSelf];
    }
}

- (IBAction)resizeSemiModalView:(id)sender {
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
        [parent resizeSemiView:CGSizeMake(320, arc4random() % 280 + 180)];
    }
}
*/

#pragma mark - Optional notifications

- (void) semiModalResized:(NSNotification *) notification {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(notification.object == self){
        NSLog(@"The view controller presented was been resized");
    }
}

- (void)semiModalPresented:(NSNotification *) notification {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (notification.object == self) {
        NSLog(@"This view controller just shown a view with semi modal annimation");
    }
}
- (void)semiModalDismissed:(NSNotification *) notification {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (notification.object == self) {
        NSLog(@"A view controller was dismissed with semi modal annimation");
    }
}

-(void)dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






@end
