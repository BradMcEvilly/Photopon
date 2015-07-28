//
//  PhotoponMediaFooterStatsView.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoponMediaFooterStatsViewDelegate;

@interface PhotoponMediaFooterStatsView : UIView

/*! @name Delegate */
@property (nonatomic, weak) id <PhotoponMediaFooterStatsViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsLikes;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsComments;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnStatsSnips;

+ (PhotoponMediaFooterStatsView *)photoponMediaFooterStatsViewWithName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;

- (IBAction)handleCommentStatsButtonTapped:(id)sender;
- (IBAction)handleLikeStatsButtonTapped:(id)sender;
- (IBAction)handleSnipStatsButtonTapped:(id)sender;

- (void)setName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;
- (void)showInView:(UIView *)view;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaFooterStatsViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the comment on photo button is tapped
 @param photo the PFObject for the photo that will be commented on
 */
- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapCommentOnPhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo;


@end
