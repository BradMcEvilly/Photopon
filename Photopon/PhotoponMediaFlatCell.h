//
//  PhotoponMediaFlatCell.h
//  Photopon
//
//  Created by Brad McEvilly on 8/20/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponMediaFooterInfoView.h"
#import "PhotoponMediaHeaderInfoView.h"
#import "PhotoponMediaCell.h"
#import "AMAttributedHighlightLabel.h"
#import "PhotoponMediaCaptionCell.h"
//@class PhotoponMediaFooterInfoView;
//@class PhotoponMediaHeaderInfoView;

@protocol PhotoponMediaFlatCellDelegate;

@class PhotoponMediaCaptionCell;
@class PhotoponTimelineViewController;

@class PhotoponMediaModel;
@class PhotoponUserModel;

//@class PhotoponMediaCell;

@class PhotoponOfferOverlayView;

@interface PhotoponMediaFlatCell : PhotoponMediaCell{
    PhotoponMediaModel *__weak photoponMediaModel;
}

@property (strong, nonatomic) IBOutlet UIView *backgroundPanelHeader;
@property (strong, nonatomic) IBOutlet UIView *backgroundPanelFooter;

@property (nonatomic, strong) IBOutlet UIView *photoponMainView;

@property (readwrite, weak) PhotoponMediaModel *photoponMediaModel;

@property (nonatomic, strong) IBOutlet UIView *photoponMediaFooterInfoView;
@property (nonatomic, strong) IBOutlet UIView *photoponMediaHeaderInfoView;
@property (nonatomic, strong) IBOutlet UIView *photoponMediaCaptionCell;
@property (nonatomic, strong) IBOutlet UIView *photoponMediaCell;
@property (nonatomic, strong) IBOutlet PhotoponOfferOverlayView *photoponOfferOverlayView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnMediaOverlay;

/*! @name Delegate */
@property (assign) id <PhotoponMediaFlatCellDelegate, PhotoponMediaCaptionCellDelegate> delegate;






@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsLikes;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsComments;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsSnips;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsLike;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsComment;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsSnip;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileImagePerson;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnProfileNamePerson;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelProfileSubtitlePerson;
@property (nonatomic, strong) IBOutlet UIImageView *photoponLabelProfileSubtitleImageViewPerson;
// photopon expiration objects
@property (nonatomic, strong) IBOutlet UIImageView *photoponExpirationImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoponExpirationDate;

@property (nonatomic, strong) NSDictionary *dataObject;

- (void)setName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;
- (void)showInView:(UIView *)view;

+ (PhotoponMediaFlatCell *)photoponMediaFlatCell:(id<PhotoponMediaFlatCellDelegate, PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate>)aDelegate;

//- (void)setStatsLikes:(NSString*)statsLikesText statsComments:(NSString*)statsCommentsText statsSnips:(NSString*)statsSnipsText;
//- (void)setActionsDoesLike: doesSnip;

- (void)fadeInView;
- (void)fadeOutView;

- (IBAction)handleUserButtonTapped:(id)sender;
- (IBAction)photoponBtnMediaOverlayHandler:(id)sender;

- (IBAction)handleCommentActionsButtonTapped:(id)sender;
- (IBAction)handleLikeActionsButtonTapped:(id)sender;
- (IBAction)handleSnipActionsButtonTapped:(id)sender;

- (IBAction)handleCommentStatsButtonTapped:(id)sender;
- (IBAction)handleLikeStatsButtonTapped:(id)sender;
- (IBAction)handleSnipStatsButtonTapped:(id)sender;

@end

/*!
 The protocol defines methods a delegate of a PhotoponMediaCaptionCell should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaFlatCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the cell is tapped
 @param indexPath - the hashtag associated with this action
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapMediaButton:(UIButton *)button;

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

/*!
 Sent to the delegate when the like photo button is tapped
 @param photo the PFObject for the photo that is being liked or disliked
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapLikePhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo;

/*!
 Sent to the delegate when the comment on photo button is tapped
 @param photo the PFObject for the photo that will be commented on
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapCommentOnPhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo;

/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapStatsLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapStatsSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFlatCell:(PhotoponMediaFlatCell *)photoponMediaFlatCell didTapStatsCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

@end
