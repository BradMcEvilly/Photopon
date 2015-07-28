//
//  PhotoponUIViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 9/17/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PhotoponNewPhotoponTagCouponViewController;
@class PhotoponUIImagePickerController;
@class PhotoponOfferPageViewController;
@class PhotoponNewPhotoponOverlayViewController;

@interface PhotoponUIViewController : UINavigationController <UITableViewDelegate>

@property (nonatomic, strong) UIImageView   *currentScreenShot;
@property (nonatomic, strong) UIView        *overlayContainer;
@property (nonatomic, strong) UIView        *shutterContainer;
@property (nonatomic, strong) UIView        *offersContainer;
@property (nonatomic, strong) UIView        *pickerContainer;

// container views
@property (nonatomic, strong) PhotoponUIImagePickerController               *pickerContainerController;
@property (nonatomic, strong) PhotoponNewPhotoponTagCouponViewController    *offersContainerController;
@property (nonatomic, strong) PhotoponNewPhotoponOverlayViewController      *shutterContainerController;
@property (nonatomic, strong) UIViewController                              *currentScreenShotController;
@property (nonatomic, strong) PhotoponNewPhotoponOverlayViewController      *overlayContainerController;

@end
