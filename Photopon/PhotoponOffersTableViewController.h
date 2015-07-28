//
//  PhotoponOffersTableViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponQueryTableViewController.h"
#import "PhotoponOffersTableViewCell.h"

@class Photopon8CouponsModel;
@protocol PhotoponOffersTableViewDelegate;

@interface PhotoponOffersTableViewController : PhotoponQueryTableViewController <PhotoponOffersTableViewCellDelegate>

@property (nonatomic, weak) id <PhotoponOffersTableViewDelegate> delegate;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponOffersTableViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param offer the PhotoponCouponModel associated with this button
 */
- (void)photoponOffersTableViewController:(PhotoponOffersTableViewController *)photoponOffersTableViewController didTapCouponButton:(UIButton *)button offer:(Photopon8CouponsModel *)offer;

/*!
 Sent to the delegate when the close is tapped
 @param offer the PhotoponCouponModel associated with this button
 */
- (void)photoponOffersTableViewController:(PhotoponOffersTableViewController *)photoponOffersTableViewController didCloseAnimated:(BOOL)animated;

@end