//
//  PhotoponNewPhotoponUtility.h
//  Photopon
//
//  Created by Brad McEvilly on 9/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoponNewPhotoponUtility : NSObject




+ (CGSize) photoponCropSize;

#pragma mark - VIEW POSITIONING - FRAMES

+ (CGFloat) photoponCropFrameOffset;

+ (CGRect) photoponCropFrame;

+ (CGRect) photoponToolbarFrameDefault;

+ (CGRect) photoponToolbarFrameActive;

+ (CGRect) photoponShutterTopFrameDefault;

+ (CGRect) photoponShutterBottomFrameDefault;

+ (CGRect) photoponShutterSceneFrameDefault;

+ (CGRect) photoponShutterSceneForegroundFrameOpen;

+ (CGRect) photoponShutterSceneBackgroundFrameOpen;

// CONTAINERS

+ (CGRect) photoponShutterTopFrameOpen;

+ (CGRect) photoponShutterBottomFrameOpen;

+ (CGRect) photoponOverlayFrame;

+ (CGRect) photoponHeaderFrame;

+ (CGRect) photoponFooterFrame;

+ (CGRect) photoponToolbarContainerFrame;

+ (CGRect) photoponOffersContainerFrame;

+ (CGRect) photoponOffersToolbarFrame;

+ (CGRect) photoponSecondaryToolbarContainerFrame;

+ (CGRect) photoponSecondaryToolbarFrameDefault;

+ (CGRect) photoponSecondaryToolbarFrameActive;

+ (CGRect) photoponFlashLightingEffectFrame;

+ (CGRect) photoponInfoContainerFrame;

+ (CGRect) photoponEditCaptionFrame;

+ (CGRect) photoponEditCaptionToolbarFrameDefault;

+ (CGRect) photoponEditCaptionToolbarFrameActive;

+ (UIImage*) photoponInfoCreationImage;

+ (UIImage*) photoponInfoConfirmationImage;

@end
