//
//  PhotoponSearchTableViewCell.h
//  Photopon
//
//  Created by Brad McEvilly on 7/29/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponTableViewCell.h"

@class PhotoponUIButton;

@protocol PhotoponSearchTableViewCellDelegate;

@interface PhotoponSearchTableViewCell : PhotoponTableViewCell

/*! @name Delegate */
//@property (nonatomic, weak) id <PhotoponSearchTableViewCellDelegate> delegate;
@property (assign) id <PhotoponSearchTableViewCellDelegate> delegate;

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnResultCellTitle;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnResultCellImage;
@property (nonatomic, strong) IBOutlet UIImageView *photoponResultCellIcon;

+ (PhotoponSearchTableViewCell *)photoponSearchResultsTableViewCellWithContentText:(NSString*)contentText imageName:(NSString*)imageName;

-(IBAction)photoponBtnResultCellHandler:(id)sender;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponSearchTableViewCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoponSearchTableViewCell:(PhotoponSearchTableViewCell *)photoponSearchTableViewCell didTapResultCellButton:(UIButton *)button;

@end