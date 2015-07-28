//
//  PhotoponNewPhotoponShareHeaderView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class PhotoponMediaModel;
@protocol PhotoponNewPhotoponShareHeaderViewDelegate;

@interface PhotoponNewPhotoponShareHeaderView : UIView <UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate, UIPopoverControllerDelegate>



@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) IBOutlet UIView *photoponContent;
@property (nonatomic, strong) IBOutlet UIView *photoponContentHeader;
@property (nonatomic, strong) IBOutlet UIView *photoponToolBar;

@property (nonatomic, strong) IBOutlet UITextView *contentTextView;

@property (nonatomic, strong) IBOutlet UILabel *photoponOfferValue;

@property (nonatomic, strong) IBOutlet UIImageView *photoponMediaThumbnail;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileImage;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnFacebook;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnTwitter;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnStatus;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCaptions;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnHashtag;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnMention;

@property (nonatomic, strong) IBOutlet UITextField *photoponTextViewPlaceHolderField;


/*! @name Delegate */
//@property (nonatomic, weak) IBOutlet id <PhotoponNewPhotoponShareHeaderViewDelegate> delegate;
@property (assign) IBOutlet id <PhotoponNewPhotoponShareHeaderViewDelegate> delegate;


+ (PhotoponNewPhotoponShareHeaderView *)initPhotoponNewPhotoponShareHeaderView;

- (void)configureViewWithRefresh:(BOOL)refresh;

- (IBAction)photoponBtnProfileImageHandler:(id)sender;

- (IBAction)photoponBtnFacebookHandler:(id)sender;
- (IBAction)photoponBtnTwitterHandler:(id)sender;
- (IBAction)photoponBtnStatusHandler:(id)sender;

- (IBAction)photoponBtnCaptionsHandler:(id)sender;
- (IBAction)photoponBtnHashtagHandler:(id)sender;
- (IBAction)photoponBtnMentionHandler:(id)sender;

@end

/*!
 The protocol defines methods a delegate of a PhotoponNewPhotoponShareHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponNewPhotoponShareHeaderViewDelegate <NSObject, UITextViewDelegate>
@optional

/*!
 Sent to the delegate when the facebook button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapFacebookButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the twitter button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapTwitterButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapStatusButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapHashTagButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapMentionButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapBackButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didResignWithMedia:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the post status (public/private) button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapPublishButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the show example captions button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponNewPhotoponShareHeaderView:(PhotoponNewPhotoponShareHeaderView *)photoponNewPhotoponShareHeaderView didTapCaptionsButton:(UIButton *)button captions:(NSArray *)captions;

@end