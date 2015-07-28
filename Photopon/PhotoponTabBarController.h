//
//  PAPTabBarController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/15/12.
//

#import <UIKit/UIKit.h>
//#import "PAPEditPhotoViewController.h"

@protocol PhotoponTabBarControllerDelegate;

@class PhotoponMediaModel;
@class PhotoponNewPhotoponCompositionViewController;

@interface PhotoponTabBarController : UITabBarController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) UIImageView *photoponBackgroundImageView;
@property(nonatomic, strong) UIImage *photoponBackgroundImage;
@property(nonatomic, strong) NSString *photoponBackgroundImageNameString;

@property(nonatomic, strong) UIButton *photoponCameraButton;

@property (nonatomic, strong) PhotoponMediaModel *photoponNewMediaDraft;

@property (nonatomic, strong) UINavigationController *photoponNewPhotoponCompositionNavigationViewController;

@property (nonatomic, strong) PhotoponNewPhotoponCompositionViewController *photoponNewPhotoponCompositionViewController;

-(void) showToolTipImageName:(NSString*)imageName;

-(void) doDismissViewController;

- (BOOL) shouldPresentPhotoCaptureController;

- (void) resetToHomeViewController;

- (void) dismissPhotoponCompositionView;

- (void)newPhotopon:(id)sender;

@end

@protocol PhotoponTabBarControllerDelegate <NSObject>

- (void)tabBarController:(UITabBarController *)tabBarController cameraButtonTouchUpInsideAction:(UIButton *)button;

@end