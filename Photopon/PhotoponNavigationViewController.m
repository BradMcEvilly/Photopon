//
//  PhotoponNavigationViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNavigationViewController.h"
#import "PhotoponNewPhotoponPickerController.h"
#import "PhotoponActivityViewController.h"
#import "PhotoponHomeViewController.h"
#import "PhotoponExploreViewController.h"
#import "PhotoponTabBarController.h"
#import "PhotoponAccountProfileViewController.h"
#import "PhotoponProfileViewController.h"
#import "PhotoponNewPhotoponTagCouponViewController.h"
#import "PhotoponUploadHeaderView.h"
#import "PhotoponHomeViewController.h"
#import "PhotoponTabBarController.h"
#import "PhotoponAppDelegate.h"
#import <unistd.h>
#import "PhotoponNewPhotoponShareViewController.h"
#import "PhotoponUIImagePickerController.h"
#import "PhotoponNewPhotoponOverlayViewController.h"
#import "PhotoponWelcomeViewController.h"

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
#import "PhotoponUIViewController.h"

@interface PhotoponNavigationViewController ()
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) PhotoponNewPhotoponPickerController *pickPhotoController;
@end

@implementation PhotoponNavigationViewController

@synthesize photoponPickerPlaceholderScreenShot;
@synthesize photoponModalViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)displayPhotoponPicker:(UIView*)pickerView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[pickerView setAlpha:0.0f];
    
    [self.photoponModalViewController.view addSubview:pickerView];
    
    //[pickerView fadeIn];
    
}



/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController)
        return;
    
    UIView* controllerViewHolder = viewController.view;
    UIView* controllerCameraView = [[controllerViewHolder subviews] objectAtIndex:0];
    UIView* controllerPreview = [[controllerCameraView subviews] objectAtIndex:0];
    [controllerCameraView insertSubview:self.overlayView aboveSubview:controllerPreview];
}
*/



/*
- (void)dismissPhotoponPicker:(UIView*)pickerView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    // Here's how to call dismiss button on the parent ViewController
    // be careful with view hierarchy
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
    
    return;
    
    
    
    
    
    
    
    
    / * 
    
    
    
    
    [self.photoponPickerPlaceholderScreenShot setImage:[pickerView screenshot]];
    
    //[self.photoponModalViewController.view bringSubviewToFront:self.photoponPickerPlaceholderScreenShot];
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.photoponPickerPlaceholderScreenShot removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(removePhotoponPicker) withObject:nil waitUntilDone:NO];
    } else {
        [self removePhotoponPicker];
    }
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[self presentSemiViewController:appDelegate.tabBarController withOptions:nil completion:nil dismissBlock:nil];
    * /
    
    
}
*/
- (void)removePhotoponPicker{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //[self.view bringSubviewToFront:self.photoponModalViewController.view];
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //appDelegate.homeViewController par
    
    //[self.photoponModalViewController]
    
    
    
    [self.photoponModalViewController dismissSemiModalViewWithCompletion:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self dismissSemiModalViewWithCompletion:^{", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [self.photoponModalViewController.view removeFromSuperview];
        [self.photoponModalViewController removeFromParentViewController];
        
        [self.view bringSubviewToFront:appDelegate.tabBarController.view];
        [appDelegate.tabBarController.selectedViewController.view bringSubviewToFront:appDelegate.homeViewController.presentedViewController.view];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
    }];
    
    
}

/*
- (void) navigationController:(UINavigationController*) navigationController willShowViewController:(UIViewController*) viewController animated:(BOOL) animated {
    
    
    
    
    self.pickPhotoController.mediaUI.cameraOverlayView = nil;
    
    
    
    
    // your camera overlay view
}
/ *

-(void) presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self presentSemiViewController:viewControllerToPresent withOptions:nil completion:completion dismissBlock:^{
        
        [viewControllerToPresent dismissSemiModalViewWithCompletion:completion];
    
    }];
    
}* /

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
}
*/

-(void)applicationBecomeActive{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //if (self.pickPhotoController.photoponNewPhotoponOverlayViewController.view.window)
        //[self.pickPhotoController.photoponNewPhotoponOverlayViewController openShutter];
    
    
    /*
    if (self.pickPhotoController.photoponNewPhotoponOverlayViewController)
        [self.pickPhotoController.photoponNewPhotoponOverlayViewController openShutter];
    else
        [
     */
}

/*
- (PhotoponNewPhotoponPickerController *)photoController
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    __weak __typeof(&*self)weakSelf = self;
    
    return [[PhotoponNewPhotoponPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        
        [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] addUploadHeader];
        
        [weakSelf dismissNewPhotoponPickerControllerAnimated:YES doUpload:YES];
        
 
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidCancelNewPhotoponComposition object:nil];
 
        //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponTabBarControllerDidFinishEditingPhotoNotification object:nil];
        
        //[weakSelf dismissNewPhotoponPickerControllerAnimated:YES doUpload:YES];
        
        
        /*
        PhotoponNewPhotoponTagCouponViewController *photoponNewPhotoponTagCouponViewController = [[PhotoponNewPhotoponTagCouponViewController alloc] initWithCompletionBlock:^(PhotoponCouponModel *photoponCouponModel){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            photoponNewPhotoponTagCouponViewController = [[PhotoponNewPhotoponTagCouponViewController alloc] initWithCompletionBlock:", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] switchLocationManagerOff];
            
            // setup share vc
            //  1. create share vc
            //  2. set share vc delegate to self
            
            // share vc completion block:
            
            // setup upload progress header view
            //  1. create upload progress header view with completion block
            //  2. set upload progress view delegate to self
            
            PhotoponNewPhotoponShareViewController *photoponNewPhotoponShareViewController = [[PhotoponNewPhotoponShareViewController alloc] initWithCompletionBlock:^(PhotoponMediaModel *photoponMediaModel){
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            PhotoponNewPhotoponShareViewController alloc] initWithCompletionBlock:", self, NSStringFromSelector(_cmd));
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                // call photopon upload pregress view delegate
                
                [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] addUploadHeader];
                
                [imagePickerController popToRootViewControllerAnimated:YES];
                
                [weakSelf dismissNewPhotoponPickerControllerAnimated:YES doUpload:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponTabBarControllerDidFinishEditingPhotoNotification object:nil];
                
            }];
            
            [imagePickerController pushViewController:photoponNewPhotoponShareViewController animated:YES];
            
            
            
            // setup share vc
            //  1. create share vc
            //  2. set share vc delegate to self
            
                    // share vc completion block:
            
                    // setup upload progress header view
                    //  1. create upload progress header view with completion block
                    //  2. set upload progress view delegate to self
            
            
            / *
            [[PhotoponMediaModel newPhotoponDraft].dictionary setObject:photoponCouponModel forKey:kPhotoponMediaAttributesCouponKey];
            
            NSLog(@"|||||||||||||||||||----->           TAG COMPLETION CHECKPOINT: 1                ||||||||||||||||||||||||||||||||||||");
            
            [[PhotoponMediaModel newPhotoponDraft] cacheMediaAttributes];
            
            NSLog(@"|||||||||||||||||||----->           TAG COMPLETION CHECKPOINT: 1                ||||||||||||||||||||||||||||||||||||");
            * /
            
            / *
            // now init share view and upload to server calling encapsulated PhotoponModel public sync methods (just use single
            // upload method encapsulated in PhotoponMediaModel for now...
            PhotoponNewPhotoponTagCouponViewController *photoponNewPhotoponTagCouponViewController = [[PhotoponNewPhotoponTagCouponViewController alloc] initWithCompletionBlock:^(PhotoponCouponModel *photoponCouponModel){
                
                [[PhotoponMediaModel newPhotoponDraft] uploadPhotoponMediaModel];
                
            }];
            * /
            
            
        }];
        
        //[photoponNewPhotoponTagCouponViewController.imageView setImage: photoponNewPhotoponTagCouponViewController.photoponImage];
        
        
        [imagePickerController pushViewController:photoponNewPhotoponTagCouponViewController animated:YES];
        
        / *
        [weakSelf.pickPhotoController dismissAnimated:YES];
        weakSelf.pickPhotoController = nil;
        * /
    
    
    
    }];
    
    
    
    
}
*/
- (void)newPhotoponViewsOnMainThread{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![appDelegate validateDeviceConnection])
        return;
    
    self.photoponPickerPlaceholderScreenShot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoponPlaceholderNewPhotoponOverlay.png"]];
    
    [self.photoponModalViewController.view setFrame:self.view.window.bounds];
    
    [self.photoponModalViewController.view addSubview:self.photoponPickerPlaceholderScreenShot];
    
    [appDelegate.homeViewController presentSemiViewController:self.photoponModalViewController];
}

- (void)newPhotopon:(id)sender
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(newPhotoponViewsOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self newPhotoponViewsOnMainThread];
    }
    
    //[appDelegate.tabBarController presentSemiView:self.photoponPickerPlaceholderScreenShot withOptions:nil completion:^{
        
        
        
    
    
        
        
        
        
        / *
         dispatch_async(dispatch_get_main_queue(), ^{
         / *
         [appDelegate.tabBarController.view removeFromSuperview];
         
         [appDelegate.activityViewController.view removeFromSuperview];
         [appDelegate.exploreViewController.view removeFromSuperview];
         [appDelegate.homeViewController.view removeFromSuperview];
         [appDelegate.profileViewController.view removeFromSuperview];
         * /
         [appDelegate.tabBarController.view removeFromSuperview];
         
         appDelegate.tabBarController = nil;
         
         });
         * /
        
        
        NSLog(@"newPhotopon 3");
        
        //if (self.pickPhotoController) {
        
        NSLog(@"newPhotopon 4");
        
        //[self.pickPhotoController showFromBarButtonItem:sender];
        //return;
        //}
        
        NSLog(@"newPhotopon 5");
        
        self.pickPhotoController = [self photoController];
    
        
    
    
        self.pickPhotoController.saveToCameraRoll = NO;
        
        
        NSLog(@"newPhotopon 6");
        
        self.pickPhotoController.allowsEditing = NO;
    
        //self.pickPhotoController.cropOverlaySize = CGSizeMake(300, 300);
    
    
    
    //    [self.photoponModalViewController addChildViewController:self.pickPhotoController.mediaUI];
    
    
    
    
        NSLog(@"newPhotopon 7");
        
        /*
         if (self.cropPreviewSwitch.on) {
         self.pickPhotoController.allowsEditing = NO;
         self.pickPhotoController.cropOverlaySize = CGSizeMake(320, 100);
         }
         else {
         self.pickPhotoController.allowsEditing = YES;
         self.pickPhotoController.cropOverlaySize = CGSizeZero;
         }
         * /
        
        
        
        [self.pickPhotoController showFromBarButtonItem:sender];
        
        
        NSLog(@"newPhotopon 8");

        
        
    
    //} dismissBlock:^{
        
        //appDelegate.tabBarController parentViewController
        
    //}];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
     
    */
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)fadeOutViewWithRemove:(UIView*)targetView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponPickerPlaceholderScreenShot removeFromSuperview];
    
}

- (void)dismissNewPhotoponPickerControllerAnimated:(BOOL)animated doUpload:(BOOL)doUpload{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] tabBarController] resetToHomeViewController];
    
    if (doUpload)
        [self.pickPhotoController dismissAndUploadAnimated:animated];
    else
        [self.pickPhotoController dismissAnimated:animated];
}

- (void)takePhotoponPhoto{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[appDelegate.navController popToRootViewControllerAnimated:NO];
    
    [self.pickPhotoController takePhotoponPhoto];
    
    
}

- (void)viewDidLoad
{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[self presentSemiViewController:appDelegate.tabBarController withOptions:nil completion:nil dismissBlock:nil];
    
    
    
    //self.photoponModalViewController = [[PhotoponUIViewController alloc] init];
    
    //[self.photoponModalViewController loadView];
    
    //[appDelegate.homeViewController addChildViewController:self.photoponModalViewController];
    
    
    
    
    
    
    //[self.navigationController pushViewController:self.alternativeViewController animated:NO];
    
    
    
    
    
    
    
    self.imageView.clipsToBounds = YES;
    
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.cornerRadius = 5.0;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (void)willPresentAlertView:(FUIAlertView *)alertView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (void)didPresentAlertView:(FUIAlertView *)alertView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (void)alertView:(FUIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

- (void)alertView:(FUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}
@end
