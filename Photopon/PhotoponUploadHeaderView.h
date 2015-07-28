//
//  PhotoponUploadHeaderView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/24/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PhotoponMediaModel;
@protocol PhotoponUploadHeaderViewDelegate;

@interface PhotoponUploadHeaderView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *photoponMediaPhoto;
@property (nonatomic, strong) IBOutlet UILabel *photoponMediaPhotoUploadStatus;
@property (nonatomic, strong) IBOutlet UILabel *photoponMediaPhotoUploadProgress;

@property (nonatomic, strong) IBOutlet UIButton *photoponBtnRetryUpload;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCancelUpload;

@property (nonatomic, assign) PhotoponFile *photoponFile;

/*! @name Delegate */
//@property (nonatomic, weak) id <PhotoponUploadHeaderViewDelegate> delegate;
@property (assign) id <PhotoponUploadHeaderViewDelegate> delegate;


@property (nonatomic, strong) PhotoponMediaModel *photoponMediaModel;

@property (copy) NSString *photoponMediaPhotoUploadStatusText;
@property (nonatomic, strong) NSNumber * remoteStatusNumber;
@property (nonatomic) MediaModelRemoteStatus remoteStatus;


/**
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
 */
@property (assign) float progress;

+ (PhotoponUploadHeaderView *)initPhotoponUploadHeaderView;

- (void)configureFailedView;

- (void)setupDefaultNeedsDisplay:(BOOL)needsDisplay;

-(IBAction)photoponBtnRetryUploadHandler:(id)sender;
-(IBAction)photoponBtnCancelUploadHandler:(id)sender;

@end




/*!
 The protocol defines methods a delegate of a PhotoponUploadHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol PhotoponUploadHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the retry button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponUploadHeaderView:(PhotoponUploadHeaderView *)photoponUploadHeaderView didTapRetryUploadButton:(UIButton *)button media:(PhotoponMediaModel *)media;

/*!
 Sent to the delegate when the cancel upload button is tapped
 @param user the PhotoponMediaModel associated with this button
 */
- (void)photoponUploadHeaderView:(PhotoponUploadHeaderView *)photoponUploadHeaderView didTapCancelUploadButton:(UIButton *)button media:(PhotoponMediaModel *)media;


@end