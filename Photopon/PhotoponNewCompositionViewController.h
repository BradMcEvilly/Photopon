//
//  PhotoponNewCompositionViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/18/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PhotoponNewCompositionViewControllerCompletionBlock)(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict);

@interface PhotoponNewCompositionViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *photoponToolBarView;
@property (nonatomic, strong) IBOutlet UIView *photoponCropView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnLibrary;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCamera;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCancel;
@property (nonatomic, strong) UIImage *croppedImage;

/**
 Defaults to NO. Is passed to the UIImagePickerController
 */
@property(nonatomic,assign) BOOL allowsEditing;


@property(nonatomic,strong) UIImagePickerController *mediaUI;
/**
 Defaults to CGSizeZero. When set to a non-zero value, a crop
 overlay view will be displayed atop the selected image at the
 provided size.
 */
@property(nonatomic,assign) CGSize cropOverlaySize;

/**
 Allow overriding of the UIPopoverController class used to host the
 UIImagePickerController. Defaults to UIPopoverController.
 */
@property(nonatomic,copy) Class popoverControllerClass;
@property(nonatomic,strong) UIPopoverController *popoverController;

/**
 Defaults to YES.
 */
@property(nonatomic,assign) BOOL offerLastTaken;

/**
 Defaults to YES.
 */
@property(nonatomic,assign) BOOL saveToCameraRoll;

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,assign) UIImagePickerControllerSourceType sourceType;

@property(nonatomic,strong) NSMutableDictionary *mutableImageInfo;


/**
 @param completionBlock Called when a photo has been picked or cancelled (`imageInfoDict` will be nil if canceled). The `UIImagePickerController` has not been dismissed at the time of this being called.
 */
- (id)initWithPresentingViewController:(UIViewController *)aViewController withCompletionBlock:(PhotoponNewCompositionViewControllerCompletionBlock)completionBlock;

- (IBAction)takePicture:(id)sender;
- (IBAction)photoponBtnLibraryHandler:(id)sender;

- (IBAction)didSwitchToRear:(id)sender;
- (IBAction)didTakePicture:(id)sender;
- (IBAction)didCancel:(id)sender;

- (void)didCropImageHandler:(NSNotification *)notification;

@end