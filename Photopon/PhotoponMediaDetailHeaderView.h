//
//  PhotoponMediaDetailHeaderView.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponMediaDetailHeaderView.h"

@protocol PhotoponMediaDetailsHeaderViewDelegate;

@interface PhotoponMediaDetailHeaderView : UIView

/*! @name Managing View Properties */

/// The photo displayed in the view
@property (nonatomic, strong, readonly) PhotoponMediaModel *photo;

/// The user that took the photo
@property (nonatomic, strong, readonly) PhotoponUserModel *photographer;

/// Array of the users that liked the photo
@property (nonatomic, strong) NSArray *likeUsers;

/// Heart-shaped like button
@property (nonatomic, strong, readonly) UIButton *likeButton;

/*! @name Delegate */
@property (nonatomic, strong) id<PhotoponMediaDetailsHeaderViewDelegate> delegate;

+ (CGRect)rectForView;

- (id)initWithFrame:(CGRect)frame photo:(PhotoponMediaModel*)aPhoto;
- (id)initWithFrame:(CGRect)frame photo:(PhotoponMediaModel*)aPhoto photographer:(PhotoponUserModel*)aPhotographer likeUsers:(NSArray*)theLikeUsers;

- (void)setLikeButtonState:(BOOL)selected;
- (void)reloadLikeBar;
@end

/*!
 The protocol defines methods a delegate of a PAPPhotoDetailsHeaderView should implement.
 */
@protocol PhotoponMediaDetailsHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */
- (void)photoDetailsHeaderView:(PhotoponMediaDetailHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

@end