//
//  PhotoponMediaFullCell.h
//  Photopon
//
//  Created by Brad McEvilly on 8/4/13.
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

@protocol PhotoponMediaFullCellDelegate;

@class PhotoponMediaCaptionCell;
@class PhotoponTimelineViewController;

@class PhotoponMediaModel;
//@class PhotoponMediaCell;

@class PhotoponOfferOverlayView;

@interface PhotoponMediaFullCell : UITableViewCell{
    PhotoponMediaModel *__weak photoponMediaModel;
}

@property (strong, nonatomic) IBOutlet UIView *backgroundPanelHeader;
@property (strong, nonatomic) IBOutlet UIView *backgroundPanelFooter;

@property (nonatomic, strong) IBOutlet UIView *photoponMainView;

@property (readwrite, weak) PhotoponMediaModel *photoponMediaModel;

@property (nonatomic, strong) IBOutlet PhotoponMediaFooterInfoView *photoponMediaFooterInfoView;
@property (nonatomic, strong) IBOutlet PhotoponMediaHeaderInfoView *photoponMediaHeaderInfoView;
@property (nonatomic, strong) IBOutlet PhotoponMediaCaptionCell *photoponMediaCaptionCell;
@property (nonatomic, strong) IBOutlet PhotoponMediaCell *photoponMediaCell;
@property (nonatomic, strong) IBOutlet PhotoponOfferOverlayView *photoponOfferOverlayView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnMediaOverlay;

/*! @name Delegate */
@property (assign) id <PhotoponMediaFullCellDelegate, PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate, PhotoponMediaCaptionCellDelegate> delegate;


- (IBAction)photoponBtnMediaOverlayHandler:(id)sender;

+ (PhotoponMediaFullCell *)photoponMediaFullCell:(id<PhotoponMediaFullCellDelegate, PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate>)aDelegate;

- (void)setUpWithDelegate:(id <PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate, PhotoponMediaCaptionCellDelegate>)delegate;

- (void)fadeInView;
- (void)fadeOutView;

@end

/*!
 The protocol defines methods a delegate of a PhotoponMediaCaptionCell should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponMediaFullCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the cell is tapped
 @param indexPath - the hashtag associated with this action
 */
- (void)photoponMediaFullCell:(PhotoponMediaFullCell *)photoponMediaFullCell didTapMediaButton:(UIButton *)button;

@end
