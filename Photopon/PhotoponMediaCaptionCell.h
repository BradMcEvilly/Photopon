//
//  PhotoponMediaCaptionCell.h
//  Photopon
//
//  Created by Brad McEvilly on 8/1/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMAttributedHighlightLabel.h"

@protocol PhotoponMediaCaptionCellDelegate;

@interface PhotoponMediaCaptionCell : UITableViewCell <AMAttributedHighlightLabelDelegate>

@property (strong, nonatomic) IBOutlet UIView *backgroundPanel;

@property (strong, nonatomic) NSString *contentText;

@property (nonatomic, strong) IBOutlet AMAttributedHighlightLabel *contentLabel;

/*! @name Delegate */
//@property (nonatomic, weak) id <PhotoponMediaCaptionCellDelegate> delegate;
@property (nonatomic, weak) id <PhotoponMediaCaptionCellDelegate> delegate;

+ (PhotoponMediaCaptionCell *)photoponMediaCaptionCell;

- (void)setUpWithText:(NSString*)aContentText;

@end

/*!
 The protocol defines methods a delegate of a PhotoponMediaCaptionCell should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaCaptionCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the hashtag is tapped
 @param text - the hashtag associated with this action
 */
- (void)photoponMediaCaptionCell:(PhotoponMediaCaptionCell *)photoponMediaCaptionCell didTapHashtagText:(NSString *)hashtagText;

/*!
 Sent to the delegate when the hashtag is tapped
 @param mentionText - the mentioned username text associated with this action
 */
- (void)photoponMediaCaptionCell:(PhotoponMediaCaptionCell *)photoponMediaCaptionCell didTapMentionText:(NSString *)mentionText;

/*!
 Sent to the delegate when the hashtag is tapped
 @param linkText - the http link (url string) associated with this action
 */
- (void)photoponMediaCaptionCell:(PhotoponMediaCaptionCell *)photoponMediaCaptionCell didTapLinkText:(NSString *)linkText;

@end