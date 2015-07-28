//
//  PhotoponUsersTableViewCell.h
//  Photopon
//
//  Created by Brad McEvilly on 7/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponTableViewCell.h"

@class PhotoponUIButton;
@class PhotoponUserModel;

@protocol PhotoponUsersTableViewCellDelegate;

@interface PhotoponUsersTableViewCell : PhotoponTableViewCell

/*! @name Delegate */
//@property (nonatomic, weak) id <PhotoponUsersTableViewCellDelegate> delegate;
@property (assign) id <PhotoponUsersTableViewCellDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnUserName;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnUserImage;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileFollowing;

//@property (nonatomic, strong) PhotoponUserModel *photoponUserModel;

+ (PhotoponUsersTableViewCell *)photoponUsersTableViewCellWithUserModel:(PhotoponUserModel *)userModel;

-(IBAction)photoponBtnUserNameHandler:(id)sender;
-(IBAction)photoponBtnProfileFollowingHandler:(id)sender;


@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponUsersTableViewCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponUsersTableViewCell:(PhotoponUsersTableViewCell *)photoponUsersTableViewCell didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

/*!
 Sent to the delegate when the like photo button is tapped
 @param photo the PFObject for the photo that is being liked or disliked
 */
- (void)photoponUsersTableViewCell:(PhotoponUsersTableViewCell *)photoponUsersTableViewCell didTapFollowUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

@end