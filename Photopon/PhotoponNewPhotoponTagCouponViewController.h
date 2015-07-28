//
//  PhotoponNewPhotoponTagCouponViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "PhotoponOffersTableViewController.h"
#import "PhotoponQueryPageViewController.h"

@class PhotoponCouponModel;
@class Photopon8CouponsModel;
@class PhotoponMediaModel;
@class PhotoponOfferOverlayView;
//@class PhotoponOffersTableViewController;

typedef void (^PhotoponTagCouponCompletionBlock)(PhotoponCouponModel *photoponCouponModel);

@interface PhotoponNewPhotoponTagCouponViewController : PhotoponQueryPageViewController

@property (nonatomic, strong) UIImage *photoponImage;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *photoponToolBarLabel;
@property (nonatomic, strong) IBOutlet UIView *photoponToolBarView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRetake;

//@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRetake;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRefresh;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnPlace;

//@property (nonatomic, strong) IBOutlet UIButton *photoponBtnTagCoupon;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnNext;

//@property (nonatomic, strong) PhotoponOffersTableViewController *photoponOffersTableViewController;

//@property (nonatomic, strong) IBOutlet PhotoponOfferOverlayView *offerOverlay;

/**
 @param completionBlock Called when a coupon has been tagged or cancelled (`imageInfoDict` will be nil if canceled). The `UIImagePickerController` has not been dismissed at the time of this being called.
 */
- (id)initWithCompletionBlock:(PhotoponTagCouponCompletionBlock)completionBlock;

- (Photopon8CouponsModel*)objectAtIndexPath:(NSIndexPath *)indexPath;
- (PhotoponCouponModel*)processedObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void)prepareNextStepInBackgroundWithBlock:(void (^)(NSError *error, PhotoponCouponModel *coupon))block;

- (void) setUpPhotoponConfig;

- (IBAction)photoponBtnRetakeHandler:(id)sender;
//- (IBAction)photoponBtnTagCouponHandler:(id)sender;
- (IBAction)photoponBtnRefreshHandler:(id)sender;
- (IBAction)photoponBtnPlaceHandler:(id)sender;
- (IBAction)photoponBtnNextHandler:(id)sender;

@end