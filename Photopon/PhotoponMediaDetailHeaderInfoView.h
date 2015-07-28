//
//  PhotoponMediaDetailHeaderInfoView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponMediaFooterInfoView.h"
#import "PhotoponMediaHeaderInfoView.h"
//#import "PhotoponMediaCell.h"
#import "AMAttributedHighlightLabel.h"
#import "PhotoponMediaCaptionCell.h"

@class PhotoponMediaCell;

@protocol PhotoponMediaDetailHeaderInfoViewDelegate;

@interface PhotoponMediaDetailHeaderInfoView : UIView <PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate, AMAttributedHighlightLabelDelegate>

@property (strong, nonatomic) IBOutlet AMAttributedHighlightLabel *photoponPersonalMessage;

/*! @name Delegate */
//@property (nonatomic, weak) id <PhotoponMediaDetailHeaderInfoViewDelegate> delegate;
@property (assign) id <PhotoponMediaDetailHeaderInfoViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet PhotoponMediaHeaderInfoView *photoponMediaHeaderInfoView;
@property (nonatomic, strong) IBOutlet PhotoponMediaFooterInfoView *photoponMediaFooterInfoView;
@property (nonatomic, strong) IBOutlet PhotoponMediaCell *photoponMediaCell;
//@property (nonatomic, strong) IBOutlet PhotoponMediaCaptionCell *photoponMediaCaptionCell;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnProfileImagePerson;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnProfileNamePerson;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelProfileSubtitlePerson;
@property (nonatomic, strong) IBOutlet UIImageView *photoponLabelProfileSubtitleImageViewPerson;
// photopon expiration objects
@property (nonatomic, strong) IBOutlet UIImageView *photoponExpirationImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoponExpirationDate;

@property (nonatomic,strong) PhotoponMediaModel *photoponMediaModel;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRedeem;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsLikes;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsComments;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsSnips;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsLike;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsComment;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsSnip;

- (IBAction)photoponBtnRedeemHandler:(id)sender;

- (IBAction)handleCommentActionsButtonTapped:(id)sender;
- (IBAction)handleLikeActionsButtonTapped:(id)sender;
- (IBAction)handleSnipActionsButtonTapped:(id)sender;

- (IBAction)handleCommentStatsButtonTapped:(id)sender;
- (IBAction)handleLikeStatsButtonTapped:(id)sender;
- (IBAction)handleSnipStatsButtonTapped:(id)sender;

- (IBAction)handleUserButtonTapped:(id)sender;

+ (PhotoponMediaDetailHeaderInfoView *)photoponMediaDetailHeaderInfoView:(PhotoponMediaModel *)mediaModel;

- (void)fadeInView;
- (void)fadeOutView;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaDetailHeaderInfoViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponMediaDetailHeaderInfoView:(PhotoponMediaDetailHeaderInfoView *)photoponMediaDetailHeaderInfoView didTapRedeemButton:(UIButton *)button user:(PhotoponMediaModel *)media;


@end