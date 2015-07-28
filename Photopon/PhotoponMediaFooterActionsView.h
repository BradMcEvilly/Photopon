//
//  PhotoponMediaFooterActionsView.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoponMediaFooterActionsViewDelegate;

@interface PhotoponMediaFooterActionsView : UIView

/*! @name Delegate */
@property (nonatomic, weak) id <PhotoponMediaFooterActionsViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsLike;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsComment;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnActionsSnip;

+ (PhotoponMediaFooterActionsView *)photoponMediaFooterActionsViewWithName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;

- (IBAction)handleCommentActionsButtonTapped:(id)sender;
- (IBAction)handleLikeActionsButtonTapped:(id)sender;
- (IBAction)handleSnipActionsButtonTapped:(id)sender;

- (void)setName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;
- (void)showInView:(UIView *)view;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaFooterActionsViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponMediaFooterActionsView:(PhotoponMediaFooterActionsView *)photoponMediaFooterActionsView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFooterActionsView:(PhotoponMediaFooterActionsView *)photoponMediaFooterActionsView didTapLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterActionsView:(PhotoponMediaFooterActionsView *)photoponMediaFooterActionsView didTapSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;

- (void)photoponMediaFooterActionsView:(PhotoponMediaFooterActionsView *)photoponMediaFooterActionsView didTapCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media;


@end