//
//  PhotoponActivityCell.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponBaseTextCell.h"

@protocol PAPActivityCellDelegate;


@interface PhotoponActivityCell : PhotoponBaseTextCell

/*!Setter for the activity associated with this cell */
@property (nonatomic, strong) PhotoponActivityModel *activity;

/*!Set the new state. This changes the background of the cell. */
- (void)setIsNew:(BOOL)isNew;

@end


/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol PhotoponActivityCellDelegate <PhotoponBaseTextCellDelegate>
@optional

/*!
 Sent to the delegate when the activity button is tapped
 @param activity the PFObject of the activity that was tapped
 */
- (void)cell:(PhotoponActivityCell *)cellView didTapActivityButton:(PhotoponActivityModel *)activity;

@end