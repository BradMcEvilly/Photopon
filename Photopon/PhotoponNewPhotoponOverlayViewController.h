//
//  PhotoponNewPhotoponOverlayViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 8/26/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

typedef enum {
    PhotoponNewPhotoponCompositionViewModeCreate,
    PhotoponNewPhotoponCompositionViewModeConfirm
} PhotoponNewPhotoponCompositionViewMode;

typedef void (^PhotoponNewPhotoponCompletionBlock)(PhotoponMediaModel *photoponMediaModel);

@class PhotoponMediaModel;
@class PhotoponCouponModel;
@class Photopon8CouponsModel;
@class PhotoponNewPhotoponPickerController;
@class PhotoponNewPhotoponShutterViewController;
@class PhotoponNewPhotoponOffersViewController;
@class PhotoponNewPhotoponCompositionViewController;

@interface PhotoponNewPhotoponOverlayViewController : UIViewController <MBProgressHUDDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UIAlertViewDelegate, UITabBarControllerDelegate, UISplitViewControllerDelegate, UINavigationBarDelegate>{
    PhotoponMediaModel *photoponMediaModel;
}

@property (nonatomic, strong) IBOutlet UIView *photoponImageConfirmationContainer;
@property (nonatomic, strong) IBOutlet UIView *photoponFlashLightingEffectOverlay;
@property (nonatomic, strong) IBOutlet UIView *photoponOfferPagesContainer;

@property (nonatomic, strong) IBOutlet UIView *photoponToolBarContainer;
@property (nonatomic, strong) IBOutlet UIView *photoponCreationToolBar;
@property (nonatomic, strong) IBOutlet UIView *photoponConfirmationToolBar;
@property (nonatomic, strong) IBOutlet UIView *photoponSecondaryNavigationToolBar;

@property (nonatomic, strong) IBOutlet UIView *photoponEditCaptionView;
@property (nonatomic, strong) IBOutlet UIView *photoponEditCaptionToolBar;

@property (nonatomic, strong) IBOutlet UIView *photoponTutorialShareContainer;
@property (nonatomic, strong) IBOutlet UIView *photoponTutorialShareTapGesture;
@property (nonatomic, strong) UIImage *photoponTutorialShareImage;
@property (nonatomic, strong) IBOutlet UIImageView *photoponTutorialShareImageView;

@property (nonatomic, strong) IBOutlet UIView *photoponInfoContainer;
@property (nonatomic, strong) UIImage *photoponInfoImage;
@property (nonatomic, strong) IBOutlet UIImageView *photoponInfoImageView;

/*
 * SECONDARY NAVIGATION */
@property (nonatomic, strong) IBOutlet UIImageView *photoponFlashImageView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnFlashAuto;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnFlashOn;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnFlashOff;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnSwitch;

// secondary nav toggle
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnSettings;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnShareApp;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnInfo;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnTutorialShare;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCancel;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCamera;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnLibrary;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnEditCaptionCancel;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnEditCaptionDone;

@property(nonatomic, weak) IBOutlet PhotoponNewPhotoponCompositionViewController *photoponNewPhotoponCompositionViewController;

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIView *photoponCaption;

@property (nonatomic) PhotoponNewPhotoponCompositionViewMode photoponNewPhotoponCompositionViewMode;
@property (nonatomic, strong) NSNumber *photoponNewPhotoponCompositionViewModeNumber;

@property (nonatomic) UIImagePickerControllerCameraFlashMode cameraFlashMode;
@property (nonatomic) UIImagePickerControllerCameraDevice cameraDevice;

@property (nonatomic, strong) NSNumber *cameraFlashModeNumber;
@property (nonatomic, strong) NSNumber *cameraDeviceNumber;

@property (nonatomic, assign) PhotoponNewPhotoponPickerController *picker;

@property (nonatomic, strong) IBOutlet PhotoponNewPhotoponOffersViewController *photoponNewPhotoponOffersViewController;

@property (nonatomic, strong) PhotoponNewPhotoponShutterViewController *photoponNewPhotoponShutterViewController;

@property (nonatomic, strong) IBOutlet UIView *photoponHeaderPanel;
@property (nonatomic, strong) IBOutlet UIView *photoponFooterPanel;

@property (nonatomic, strong) MFMessageComposeViewController *smsMessageViewController;

//@property (nonatomic, strong) UIImage *photoponImageConfirmation;



@property (nonatomic, strong) UIImage *photoponImageConfirmation;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewConfirmation;
@property (nonatomic, strong) IBOutlet UILabel *photoponDirectionalPrompt;
@property (nonatomic, strong) IBOutlet UIView *photoponToolBarView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRetake;



//@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRetake;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRefresh;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnPlace;

//@property (nonatomic, strong) IBOutlet UIButton *photoponBtnTagCoupon;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnNext;

@property (nonatomic) BOOL shouldShowTooltipShare;
@property (nonatomic, retain) NSNumber *shouldShowTooltipShareNumber;

+ (PhotoponNewPhotoponOverlayViewController*)photoponNewPhotoponOverlayViewWithCropOverlaySize:(CGSize)cropOverlaySize;

/**
 @param completionBlock Called when a new photopon compositioin has been confirmed or cancelled (`imageInfoDict` will be nil if canceled). The `UIImagePickerController` has not been dismissed at the time of this being called. 
 **/
- (id)initWithCompletionBlock:(PhotoponNewPhotoponCompletionBlock)completionBlock;

- (Photopon8CouponsModel*)objectAtIndexPath:(NSIndexPath *)indexPath;

- (PhotoponCouponModel*)processedObjectAtIndexPath:(NSIndexPath *)indexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCropOverlaySize:(CGSize)cropOverlaySize;

- (id)initWithFrame:(CGRect)frame cropOverlaySize:(CGSize)cropOverlaySize;

- (void) beginPhotoponOverlayPresentationAnimations;

- (void) showHUDWithStatusText:(NSString*)status;

- (void) updateHUDWithStatusText:(NSString*)status;

- (void) updateHUDWithStatusText:(NSString*)status mode:(MBProgressHUDMode)mode;

- (void) hideHud;

- (void) hideHudAfterDelay:(float)delay;

- (void) openShutter;
- (void) closeShutter;
- (void) fireCameraFlash;
- (UIView*) currentToolbar;

- (void) updateCaptionWithText:(NSString*)captionText;
- (void) showCaptionActivityHUD;

- (void) configureViewForModeOpen;
- (void) configureViewForModeClose;
- (void) performViewResetWithTimedAnimation;

- (void) willOpenShutter;
- (void) willOpenShutterOnMainThread;

- (void) photoponDidBecomeActive;
- (void) photoponWillEnterForeground;
- (void) photoponDidEnterForeground;
- (void) photoponDidEnterBackground;

- (void) photoponDidCancelLibrary;
- (void) photoponDidChooseFromLibrary;

- (void) presentToolbar;

- (void) beginAppearanceTransitionFromViewModeCreation;
- (void) beginAppearanceTransitionFromViewModeConfirmation;


#pragma mark - IB Action Handlers

- (IBAction)photoponBtnEditCaptionCancelHandler:(id)sender;
- (IBAction)photoponBtnEditCaptionDoneHandler:(id)sender;

- (IBAction)photoponBtnCancelHandler:(id)sender;
- (IBAction)photoponBtnCameraHandler:(id)sender;
- (IBAction)photoponBtnLibraryHandler:(id)sender;

- (IBAction)photoponBtnInfoHandler:(id)sender;
- (IBAction)photoponBtnShareAppHandler:(id)sender;
- (IBAction)photoponBtnTutorialShareHandler:(id)sender;

- (IBAction)photoponBtnRetakeHandler:(id)sender;
- (IBAction)photoponBtnRefreshHandler:(id)sender;
- (IBAction)photoponBtnPlaceHandler:(id)sender;
- (IBAction)photoponBtnNextHandler:(id)sender;

// secondary nav handlers & toggle
- (IBAction)photoponBtnFlashAutoHandler:(id)sender;
- (IBAction)photoponBtnFlashOnHandler:(id)sender;
- (IBAction)photoponBtnFlashOffHandler:(id)sender;
- (IBAction)photoponBtnSwitchHandler:(id)sender;
- (IBAction)photoponBtnSettingsHandler:(id)sender;

@end
