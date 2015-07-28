//
//  PhotoponOfferPageViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 8/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponMediaModel;
@class Photopon8CouponsModel;
@class PhotoponOfferOverlayView;

@interface PhotoponOfferPageViewController : UIViewController{
    Photopon8CouponsModel *__weak photoponCouponModel;
    PhotoponMediaModel *__weak photoponMediaModel;
}

@property (nonatomic, strong) NSNumber *pageIndexNumber;

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) IBOutlet PhotoponOfferOverlayView *offerOverlay;

@property (nonatomic, strong) NSString *captionText;

@property (nonatomic, strong) IBOutlet UILabel *captionLabelView;

@property (readwrite, weak) Photopon8CouponsModel *photoponCouponModel;

@property (readwrite, weak) PhotoponMediaModel *photoponMediaModel;

- (id)initWithCouponModel:(Photopon8CouponsModel*)coupon;

@end
