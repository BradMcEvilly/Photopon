//
//  PhotoponOffersTableHeaderView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/17/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponCouponModel;
@protocol PhotoponOffersTableHeaderViewDelegate;

@interface PhotoponOffersTableHeaderView : UIView

/*! @name Delegate */
@property (nonatomic, weak) id <PhotoponOffersTableHeaderViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnSpoofpon;

@property (nonatomic, strong) PhotoponCouponModel *photoponCouponModel;

+ (PhotoponOffersTableHeaderView *)photoponOffersTableHeaderViewWithCouponModel:(PhotoponCouponModel *)spoofponModel;

-(IBAction)photoponBtnSpoofponHandler:(id)sender;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponOffersTableHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the coupon button is tapped
 @param user the PhotoponCouponModel associated with this button
 */
- (void)photoponOffersTableHeaderView:(PhotoponOffersTableHeaderView *)photoponOffersTableHeaderView didTapSpoofponButton:(UIButton *)button coupon:(PhotoponCouponModel *)coupon;

@end