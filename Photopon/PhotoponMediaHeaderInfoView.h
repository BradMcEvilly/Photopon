//
//  PhotoponMediaHeaderInfoView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/10/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponUIButton.h"
//@class PhotoponUIButton;

@protocol PhotoponMediaHeaderInfoViewDelegate;

@interface PhotoponMediaHeaderInfoView : UIView

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileImagePerson;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnProfileNamePerson;
@property (nonatomic, strong) IBOutlet UILabel *photoponLabelProfileSubtitlePerson;
@property (nonatomic, strong) IBOutlet UIImageView *photoponLabelProfileSubtitleImageViewPerson;
// photopon expiration objects
@property (nonatomic, strong) IBOutlet UIImageView *photoponExpirationImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoponExpirationDate;

@property (nonatomic, strong) NSDictionary *dataObject;

/*! @name Delegate */
@property (nonatomic, weak) id <PhotoponMediaHeaderInfoViewDelegate> delegate;

+ (PhotoponMediaHeaderInfoView *)photoponMediaHeaderInfoViewWithName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;

- (IBAction)handleUserButtonTapped:(id)sender;
- (void)setName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText;
- (void)showInView:(UIView *)view;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaHeaderInfoViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoHeaderView:(PhotoponMediaHeaderInfoView *)photoHeaderView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

/*!
 Sent to the delegate when the like photo button is tapped
 @param photo the PFObject for the photo that is being liked or disliked
 */
- (void)photoHeaderView:(PhotoponMediaHeaderInfoView *)photoHeaderView didTapLikePhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo;

/*!
 Sent to the delegate when the comment on photo button is tapped
 @param photo the PFObject for the photo that will be commented on
 */
- (void)photoHeaderView:(PhotoponMediaHeaderInfoView *)photoHeaderView didTapCommentOnPhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo;

@end