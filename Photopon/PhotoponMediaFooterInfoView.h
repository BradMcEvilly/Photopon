//
//  PhotoponMediaFooterInfoView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/13/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoponMediaFooterInfoViewDelegate;

@interface PhotoponMediaFooterInfoView : UIView

/*! @name Delegate */
@property (nonatomic, weak) id <PhotoponMediaFooterInfoViewDelegate> delegate;

@property (nonatomic,strong) PhotoponMediaModel *photoponMediaModel;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsLikes;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsComments;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsSnips;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsLike;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsComment;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsSnip;

+ (PhotoponMediaFooterInfoView *)photoponMediaFooterInfoViewWithMediaModel:(PhotoponMediaModel *)mediaModel;

- (IBAction)handleCommentActionsButtonTapped:(id)sender;
- (IBAction)handleLikeActionsButtonTapped:(id)sender;
- (IBAction)handleSnipActionsButtonTapped:(id)sender;

- (IBAction)handleCommentStatsButtonTapped:(id)sender;
- (IBAction)handleLikeStatsButtonTapped:(id)sender;
- (IBAction)handleSnipStatsButtonTapped:(id)sender;

- (void)setStatsLikes:(NSString*)statsLikesText statsComments:(NSString*)statsCommentsText statsSnips:(NSString*)statsSnipsText;

- (void)setActionsDoesLike: doesSnip;

- (void)setName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;


@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaFooterInfoViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;


/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapStatsLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapStatsSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapStatsCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;


@end