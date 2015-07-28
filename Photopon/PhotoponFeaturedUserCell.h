//
//  PhotoponFeaturedUserCell.h
//  Photopon
//
//  Created by Brad McEvilly on 8/20/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponUserModel;
@protocol PhotoponFeaturedUserCellDelegate;

@interface PhotoponFeaturedUserCell : UITableViewCell{
    PhotoponUserModel *__weak photoponUserModel;
}

@property (readwrite, weak) PhotoponUserModel *photoponUserModel;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnProfileImagePerson;

@property (nonatomic, weak) id <PhotoponFeaturedUserCellDelegate> delegate;

+ (PhotoponFeaturedUserCell *)photoponFeaturedUserCell:(id<PhotoponFeaturedUserCellDelegate>)aDelegate;

- (IBAction)handleUserButtonTapped:(id)sender;

- (void)fadeInView;


- (void)fadeOutView;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponFeaturedUserCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponFeaturedUserCell:(PhotoponFeaturedUserCell *)photoponFeaturedUserCell didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user;

@end