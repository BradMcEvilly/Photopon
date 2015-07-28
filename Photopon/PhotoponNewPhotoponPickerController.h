//
//  PhotoponNewPhotoponPickerController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@class PhotoponNewPhotoponOverlayViewController;

typedef void (^PhotoponPickerCompletionBlock)(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict);

@interface PhotoponNewPhotoponPickerController : NSObject

/**
 Defaults to NO. Is passed to the UIImagePickerController
 */
@property(nonatomic,assign) BOOL allowsEditing;

/**
 Defaults to CGSizeZero. When set to a non-zero value, a crop
 overlay view will be displayed atop the selected image at the
 provided size.
 */
@property(nonatomic,assign) CGSize cropOverlaySize;

@property(nonatomic,strong) UIImage* croppedImage;

@property(nonatomic, assign) PhotoponNewPhotoponOverlayViewController *photoponNewPhotoponOverlayViewController;

/**
 Allow overriding of the UIPopoverController class used to host the
 UIImagePickerController. Defaults to UIPopoverController.
 */
@property(nonatomic,copy) Class popoverControllerClass;

/**
 Defaults to YES.
 */
@property(nonatomic,assign) BOOL offerLastTaken;

/**
 Defaults to YES.
 */
@property(nonatomic,assign) BOOL saveToCameraRoll;

@property(nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@property(nonatomic,copy) PhotoponPickerCompletionBlock completionBlock;
@property(nonatomic,strong) UIImage *lastPhoto;
@property(nonatomic,strong) UIPopoverController *popoverController;
@property(nonatomic,weak) UIBarButtonItem *showFromBarButtonItem;
@property(nonatomic,assign) CGRect showFromRect;
@property(nonatomic,weak) UITabBar *showFromTabBar;
@property(nonatomic,weak) UIViewController *showFromViewController;
@property(nonatomic,assign) UIImagePickerControllerSourceType sourceType;
@property(nonatomic,strong) UIImagePickerController *mediaUI;

@property(nonatomic,strong) UIViewController *libScreenShotViewController;
@property(nonatomic,strong) UIViewController *camScreenShotViewController;

@property(nonatomic,strong) UIImageView *camScreenShot;
@property(nonatomic,strong) UIImageView *libScreenShot;
@property(nonatomic,strong) UIImage *camScreenShotImg;
@property(nonatomic,strong) UIImage *libScreenShotImg;



/**
 @param completionBlock Called when a photo has been picked or cancelled (`imageInfoDict` will be nil if canceled). The `UIImagePickerController` has not been dismissed at the time of this being called.
 */
- (id)initWithPresentingViewController:(UIViewController *)aViewController withCompletionBlock:(PhotoponPickerCompletionBlock)completionBlock;

/**
 @param completionBlock Called when a photo has been picked or cancelled (`imageInfoDict` will be nil if canceled). The `UIImagePickerController` has not been dismissed at the time of this being called.
 */
- (id)initWithPresentingViewController:(UIViewController *)aViewController withOverlayViewController:(PhotoponNewPhotoponOverlayViewController*)overlayViewController withCompletionBlock:(PhotoponPickerCompletionBlock)completionBlock;

- (void)dismissAnimated:(BOOL)animated;
- (void)dismissAndUploadAnimated:(BOOL)animated;

- (void)showFromTabBar:(UITabBar *)tabBar;
- (void)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)showFromRect:(CGRect)rect;

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType;

- (void)removePhotoponApplicationDidEnterBGObserver;

- (void) takePhotoponPhoto;

- (void) removePhotoponObservers;

- (void) addPhotoponObservers;

- (void) updateCameraScreenShot;

- (void) updatePhotoLibraryScreenShot;

//- (void) addCameraOverlay;

@end
