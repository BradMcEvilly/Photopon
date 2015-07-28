//
//  PhotoponNewPhotoponOverlayView.h
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface PhotoponNewPhotoponOverlayView : UIView

@property (nonatomic, strong) IBOutlet UIView *photoponToolBarView;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCancel;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnCamera;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnLibrary;


+ (PhotoponNewPhotoponOverlayView*)photoponNewPhotoponOverlayViewWithCropOverlaySize:(CGSize)cropOverlaySize;

- (id)initWithFrame:(CGRect)frame cropOverlaySize:(CGSize)cropOverlaySize;

- (IBAction)photoponBtnCancelHandler:(id)sender;
- (IBAction)photoponBtnCameraHandler:(id)sender;
- (IBAction)photoponBtnLibraryHandler:(id)sender;

@end

