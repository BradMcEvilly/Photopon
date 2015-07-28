//
//  PhotoponProfileHeaderView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/10/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponImageView;
@class PhotoponUserModel;
@protocol PhotoponProfileHeaderViewDelegate;

@interface PhotoponProfileHeaderView : UIView

@property (nonatomic, strong) IBOutlet UILabel *photoponLabelProfileName;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelProfileTitle;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelProfileSubtitle;

@property (nonatomic, strong) IBOutlet UILabel *photoponLabelPhotopons;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelFollowers;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelFollowing;

@property (nonatomic, strong) NSString *photoponLabelPhotoponsString;
@property (nonatomic, strong) NSString *photoponLabelFollowersString;
@property (nonatomic, strong) NSString *photoponLabelFollowingString;

@property (nonatomic, strong) IBOutlet PhotoponImageView *photoponProfileCoverImageView;

@property (nonatomic, strong) IBOutlet UIImageView *photoponProfileShadowImageView;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileImage;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileCover;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileFollowing;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileSnips;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileStatsPhotopons;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileStatsFollowers;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileStatsFollowing;
@property (nonatomic, strong) IBOutlet UIImageView *photoponProfilePicImageView;

@property (nonatomic, strong) IBOutlet UIView *photoponProfileToolBar;

@property (nonatomic, strong) PhotoponUserModel *photoponUserModel;



/*! @name Delegate */
//@property (nonatomic, weak) id <PhotoponProfileHeaderViewDelegate> delegate;
@property (assign) id <PhotoponProfileHeaderViewDelegate> delegate;

+ (PhotoponProfileHeaderView *)photoponProfileHeaderViewWithUserModel:(PhotoponUserModel *)userModel;

- (id)initWithUserModel:(PhotoponUserModel *)userModel;

- (id)initWithUserModel:(PhotoponUserModel *)userModel frame:(CGRect)frame;

//- (void) photoponProfileFollowers;

-(IBAction)photoponBtnProfileImageHandler:(id)sender;
-(IBAction)photoponBtnProfileCoverHandler:(id)sender;
-(IBAction)photoponBtnProfileFollowingHandler:(id)sender;
-(IBAction)photoponBtnProfileSnipsHandler:(id)sender;

-(IBAction)photoponBtnProfileStatsPhotoponsHandler:(id)sender;
-(IBAction)photoponBtnProfileStatsFollowersHandler:(id)sender;
-(IBAction)photoponBtnProfileStatsFollowingHandler:(id)sender;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponProfileHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponMediaFooterActionsView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */



- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileStatsPhotopons:(PhotoponUIButton *)button user:(PhotoponUserModel *)user;

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileStatsFollowers:(PhotoponUIButton *)button user:(PhotoponUserModel *)user;

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileStatsFollowing:(PhotoponUIButton *)button user:(PhotoponUserModel *)user;

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapFollowUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileSnips:(UIButton *)button;

@end