//
//  PAPTabBarController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/15/12.
//

#import <QuartzCore/QuartzCore.h>

#import "PhotoponTabBarController.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+AlphaAdditions.h"
#import "UIImage+Alpha.h"
#import "UIImage+RoundedCornerAdditions.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponTabBarController.h"
#import "PhotoponHomeViewController.h"
#import "PhotoponToolTipViewController.h"
#import "PhotoponOffersTableViewController.h"
#import "PhotoponNavigationViewController.h"
#import "PhotoponMediaModel.h"
#import "UITabBarController+hidable.h"
#import "PhotoponNewPhotoponCompositionViewController.h"

@interface PhotoponTabBarController ()
@property (nonatomic,strong) UINavigationController *navController;
@property (weak, nonatomic) IBOutlet UISwitch *cropPreviewSwitch;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@end

@implementation PhotoponTabBarController



@synthesize navController;
@synthesize photoponBackgroundImageNameString;
@synthesize photoponBackgroundImageView;
@synthesize photoponBackgroundImage;
@synthesize photoponNewMediaDraft;
@synthesize photoponCameraButton;
@synthesize photoponNewPhotoponCompositionNavigationViewController;
@synthesize photoponNewPhotoponCompositionViewController;

//NSString *const kUTTypeImage         = @"image";

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] switchLocationManagerOn];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (IS_IPAD) {
        self.photoponNewPhotoponCompositionViewController = [[PhotoponNewPhotoponCompositionViewController alloc] initWithNibName:@"PhotoponNewPhotoponCompositionViewController" bundle:nil];
        
    }else{
        self.photoponNewPhotoponCompositionViewController = [[PhotoponNewPhotoponCompositionViewController alloc] initWithNibName:@"PhotoponNewPhotoponCompositionViewController" bundle:nil];
    }
    
    self.photoponNewPhotoponCompositionNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.photoponNewPhotoponCompositionViewController];
    
    
    
    // You can optionally listen to notifications
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
    
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    
        [[self tabBar] setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundTabBar-768.png"]];
    
    
    [[self tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"PhotoponBackgroundTabBarItemSelected.png"]];
    
    CGRect imageViewFrame;
    
    if([[PhotoponAppDelegate sharedPhotoponApplicationDelegate] isTall])
        imageViewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 411.0f + 88.0f ); // add 88 to accomodate iPhone 5 height
    else
        imageViewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 411.0f);
    
    self.photoponBackgroundImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];//CGRectMake(0.0f, 44.0f, 320.0f, 480.0f-93.0f)];
    self.photoponBackgroundImageNameString = [[NSString alloc] initWithFormat:@"%@", @"PhotoponBackgroundShort@2x.png"];
    self.photoponBackgroundImage = [UIImage photoponImageNamed:self.photoponBackgroundImageNameString];
    [self.photoponBackgroundImageView setImage:self.photoponBackgroundImage];
    
    
    
    self.navController = [[UINavigationController alloc] init];
    
    //[self.photoponNewPhotoponCompositionNavigationViewController setNavigationBarHidden:NO animated:NO];
    
    
    //[self.photoponNewPhotoponCompositionNavigationViewController.navigationBar setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
    
    
    
    
    //[self.navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundNavBarWhite.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    //self.navController
    
    //[self.navController.view addSubview:self.photoponBackgroundImageView];
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Frame Dimensions:"
     message:[NSString stringWithFormat:@"x=%i, y=%i, width=%i, height=%i", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
     [alert show];
     */
    
    [PhotoponUtility addBottomDropShadowToNavigationBarForNavigationController:self.navController];
    
}

#pragma mark - UITabBarController

- (void)newPhotopon:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(newPhotoponOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self newPhotoponOnMainThread];
    }
}

- (void)newPhotoponOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return;
    
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self setUpNewCompositionDraft];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController] presentViewController:self.photoponNewPhotoponCompositionNavigationViewController animated:YES completion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@             [self presentSemiViewController:    completion:{    ", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //if (!self.photoponNewPhotoponCompositionViewController.photoponNewPhotoponOverlayViewController) {
        
        
        
            [weakSelf.photoponNewPhotoponCompositionViewController setUpView];
            
        //}else{
            
          //  [self.photoponNewPhotoponCompositionViewController addPhotoPickerController];
        //}
        
        
        //[self.photoponNewPhotoponCompositionViewController setUpView];
        
        //[self.photoponNewPhotoponCompositionViewController addPhotoPickerController];
        
    }];
    
}

- (void) setUpNewCompositionDraft{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [[NSString alloc] initWithFormat:@"%@", @""], kPhotoponMediaAttributesNewPhotoponLocalImageFilePathKey,
                                       nil];
    
    self.photoponNewMediaDraft = [[PhotoponMediaModel alloc]  initWithAttributes:attributes];
    self.photoponNewMediaDraft.photoponMediaImageFile = [PhotoponFile initNewPhotoponFile];
    [PhotoponMediaModel setNewPhotoponDraft:self.photoponNewMediaDraft];
    
    
    
}

- (void) resetToHomeViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *homeNavigationController = weakSelf.viewControllers[PhotoponHomeTabBarItemIndex];
        //[homeNavigationController popToRootViewControllerAnimated:NO];
        weakSelf.selectedViewController = homeNavigationController;
    });
    
}

- (void) dismissPhotoponCompositionView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO]; //withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        weakSelf.photoponNewPhotoponCompositionViewController = nil;
        
        weakSelf.photoponNewPhotoponCompositionNavigationViewController = nil;
        
        weakSelf.photoponNewPhotoponCompositionViewController = [[PhotoponNewPhotoponCompositionViewController alloc] initWithNibName:@"PhotoponNewPhotoponCompositionViewController" bundle:nil];
        
        weakSelf.photoponNewPhotoponCompositionNavigationViewController = [[UINavigationController alloc] initWithRootViewController:weakSelf.photoponNewPhotoponCompositionViewController];
        
    });
    
    [self.navigationController.view setNeedsDisplay];
    
    
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            
            /*
            UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"Local Coupons"
                                                                 message:[NSString stringWithFormat:@"I can't find local coupons. Check your internet connection and be sure to enable Location Services for Photopon in Settings App."]
                                                                delegate:[PhotoponAppDelegate sharedPhotoponApplicationDelegate]
                                                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                       otherButtonTitles:nil];
            [alertCheck show];
            */
            
            
            
            
            
            
            
            UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                                 message:[NSString stringWithFormat:@"To re-enable, please go to Settings and turn on Location Service for this app."]
                                                                delegate:[PhotoponAppDelegate sharedPhotoponApplicationDelegate]
                                                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                       otherButtonTitles:nil];
            [alertCheck show];
            
            
            // [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] presentExplanationLocationServicesWithAlert];
            
            
            
            
            
            
            
            
            /*
            UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                                 message:[NSString stringWithFormat:@"To re-enable, please go to Settings and turn on Location Service for this app."]
                                                                delegate:[PhotoponAppDelegate sharedPhotoponApplicationDelegate]
                                                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                       otherButtonTitles:nil];
            [alertCheck show];
             */
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //[self.navigationController setWantsFullScreenLayout:NO];
    
    //[self.navigationController.view setFrame:CGRectMake(0.0f, 20.0f, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    
    
    
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super setViewControllers:viewControllers animated:animated];
    
    self.photoponCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (IS_IPAD) {
        self.photoponCameraButton.frame = CGRectMake( 128.0f+(448.0f/2), 0.0f, 64.0f, 49);
    }else{
        self.photoponCameraButton.frame = CGRectMake( 128.0f, 0.0f, 64.0f, 49);
    }
    
    [self.photoponCameraButton setImage:[UIImage imageNamed:@"PhotoponTabBarIconShareBlue.png"] forState:UIControlStateNormal];
    [self.photoponCameraButton setImage:[UIImage imageNamed:@"PhotoponTabBarIconShareBlue-hl.png"] forState:UIControlStateHighlighted];
    [self.photoponCameraButton setImage:[UIImage imageNamed:@"PhotoponTabBarIconShareBlue-hl.png"] forState:UIControlStateSelected];
    [self.photoponCameraButton setShowsTouchWhenHighlighted:NO];
    [self.photoponCameraButton addTarget:self action:@selector(newPhotopon:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.photoponCameraButton];
    
    //
    
    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeUpGestureRecognizer setNumberOfTouchesRequired:1];
    [self.photoponCameraButton addGestureRecognizer:swipeUpGestureRecognizer];
    
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self dismissModalViewControllerAnimated:NO];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    /*
    PAPEditPhotoViewController *viewController = [[PAPEditPhotoViewController alloc] initWithImage:image];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navController pushViewController:viewController animated:NO];
    
     */
    
    [self presentModalViewController:self.navController animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (buttonIndex == 0) {
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
}


#pragma mark - PAPTabBarController

- (BOOL)shouldPresentPhotoCaptureController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    PhotoponOffersTableViewController *photoponOffersTableViewController = [[PhotoponOffersTableViewController alloc] init];
    
    [self.navController pushViewController:photoponOffersTableViewController animated:YES];
    
    
    /*
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
     */
}

-(void) doDismissViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - ()

/*
- (void)photoCaptureButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //PhotoponNewPhotoponPickerController *photoponNewCompositionViewController = [[PhotoponNewCompositionViewController alloc] initWithNibName:@"PhotoponNewCompositionViewController" bundle:nil];
    
    //[self presentViewController:photoponNewCompositionViewController animated:YES completion:nil];
    
    
 
    / *
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
        [actionSheet showFromTabBar:self.tabBar];
    } else {
        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }
     * /
    
}*/

- (BOOL)shouldStartCameraController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate validateDeviceConnection])
        return NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentModalViewController:cameraUI animated:YES];
    
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO 
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentModalViewController:cameraUI animated:YES];
    
    return YES;
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self shouldPresentPhotoCaptureController];
}






#pragma mark - Demo

- (IBAction)buttonDidTouch:(id)sender {
    
    [self.photoponNewPhotoponCompositionNavigationViewController pushViewController:self.photoponNewPhotoponCompositionViewController animated:NO];
    
    // You can also present a UIViewController with complex views in it
    // and optionally containing an explicit dismiss button for semi modal
    [self presentSemiViewController:self.photoponNewPhotoponCompositionNavigationViewController withOptions:@{
     KNSemiModalOptionKeys.pushParentBack    : @(YES),
     KNSemiModalOptionKeys.animationDuration : @(0.4),
     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
	 }];
    
}

#pragma mark - Optional notifications

- (void) semiModalResized:(NSNotification *) notification {
    if(notification.object == self){
        NSLog(@"The view controller presented was been resized");
    }
}

- (void)semiModalPresented:(NSNotification *) notification {
    if (notification.object == self) {
        NSLog(@"This view controller just shown a view with semi modal annimation");
    }
}
- (void)semiModalDismissed:(NSNotification *) notification {
    if (notification.object == self) {
        NSLog(@"A view controller was dismissed with semi modal annimation");
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
