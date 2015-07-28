//
//  PhotoponNavigationViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FUIAlertView.h"

@class PhotoponUIViewController;

@interface PhotoponNavigationViewController : UINavigationController <UIActionSheetDelegate, FUIAlertViewDelegate>

@property (nonatomic, strong) PhotoponUIViewController* photoponModalViewController;

@property (nonatomic, strong) UIImageView *photoponPickerPlaceholderScreenShot;

- (void)displayPhotoponPicker:(UIView*)pickerView;
//- (void)dismissPhotoponPicker:(UIView*)pickerView;


- (void)dismissNewPhotoponPickerControllerAnimated:(BOOL)animated doUpload:(BOOL)doUpload;

- (void)takePhotoponPhoto;

- (void)newPhotopon:(id)sender;

- (void)fadeOutViewWithRemove:(UIView*)targetView;


@end
