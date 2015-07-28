//
//  PhotoponNewPhotoponCompositionViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 9/18/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponNewPhotoponOverlayViewController;
@class PhotoponNewPhotoponPickerController;
@class PhotoponImagePickerController;
@class PhotoponUIViewController;

@interface PhotoponNewPhotoponCompositionViewController : UIViewController <MBProgressHUDDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UIAlertViewDelegate, UITabBarControllerDelegate, UISplitViewControllerDelegate, UINavigationBarDelegate, CLLocationManagerDelegate>

/*@property (nonatomic, strong) UIImageView   *currentScreenShot;
@property (nonatomic, strong) UIView        *overlayContainer;
@property (nonatomic, strong) UIView        *shutterContainer;
@property (nonatomic, strong) UIView        *offersContainer;
@property (nonatomic, strong) UIView        *pickerContainer;
@property (nonatomic, strong) UIView        *modalContainer;
*/

// container views

/**
 @ contains the mediaUI for a smooth transition between presenting semi-modal view controllers
 */
@property (nonatomic, strong) PhotoponUIViewController                      *modalContainerController;

@property (nonatomic, strong) PhotoponNewPhotoponPickerController           *pickPhotoController;

@property (nonatomic, strong) PhotoponImagePickerController                 *photoponImagePickerController;

@property (nonatomic, strong) PhotoponNewPhotoponOverlayViewController      *photoponNewPhotoponOverlayViewController;


@property (nonatomic, strong) IBOutlet UIImageView                          *photoponPlaceholderPresentationImageView;


- (void) addPhotoPickerController;

- (void) setUpView;



/*
@property (nonatomic, strong) PhotoponNewPhotoponTagCouponViewController    *offersContainerController;
@property (nonatomic, strong) PhotoponNewPhotoponShutterViewController      *shutterContainerController;
@property (nonatomic, strong) PhotoponUIViewController                      *currentScreenShotController;
*/

//- (IBAction)dismissButtonDidTouch:(id)sender;

/*- (IBAction)resizeSemiModalView:(id)sender;

- (void) addCameraOverlay;

- (void) removeCameraOverlay;

- (void) openShutter;

- (void) closeShutter;
*/

@end