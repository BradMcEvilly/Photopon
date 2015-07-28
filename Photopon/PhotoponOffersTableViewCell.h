//
//  PhotoponOffersTableViewCell.h
//  Photopon
//
//  Created by Brad McEvilly on 7/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photopon8CouponsModel;
@class PhotoponUIButton;

@protocol PhotoponOffersTableViewCellDelegate;

@interface PhotoponOffersTableViewCell : UITableViewCell

/*!
 Unfortunately, objective-c does not allow you to redefine the type of a property,
 so we cannot set the type of the delegate here. Doing so would mean that the subclass
 of would not be able to define new delegate methods (which we do in PAPActivityCell).
 */
@property (nonatomic, strong) id delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) Photopon8CouponsModel *coupon;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCouponTitle;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCouponSelect;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnCouponImage;

@property (nonatomic, retain) IBOutlet UITextView *couponTextView;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelCouponExpiration;

+ (PhotoponOffersTableViewCell *)photoponOffersTableViewCell;

-(void)setUpWithObject:(Photopon8CouponsModel*)object;

/* Inform delegate that a coupon image or coupon place name was tapped */
- (IBAction)photoponBtnCouponHandler:(id)sender;

@end





/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol PhotoponOffersTableViewCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PhotoponUserModel of the user that was tapped
 */
- (void)cell:(PhotoponOffersTableViewCell *)cellView didTapCouponButton:(Photopon8CouponsModel *)aCoupon;

@end