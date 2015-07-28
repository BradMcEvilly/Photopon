//
//  PhotoponFindFriendsCell.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAPProfileImageView;
@class PhotoponUserModel;

@protocol PhotoponFindFriendsCellDelegate;

@interface PhotoponFindFriendsCell : UITableViewCell {
    id _delegate;
}

@property (nonatomic, strong) id<PhotoponFindFriendsCellDelegate> delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PhotoponUserModel *user;
@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UIButton *followButton;

/*! Setters for the cell's content */
- (void)setUser:(PhotoponUserModel *)user;

- (void)didTapUserButtonAction:(id)sender;
- (void)didTapFollowButtonAction:(id)sender;

/*! Static Helper methods */
+ (CGFloat)heightForCell;

@end

/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol PhotoponFindFriendsCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(PhotoponFindFriendsCell *)cellView didTapUserButton:(PhotoponUserModel *)aUser;
- (void)cell:(PhotoponFindFriendsCell *)cellView didTapFollowButton:(PhotoponUserModel *)aUser;

@end
