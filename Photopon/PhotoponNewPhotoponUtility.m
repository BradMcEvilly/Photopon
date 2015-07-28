//
//  PhotoponNewPhotoponUtility.m
//  Photopon
//
//  Created by Brad McEvilly on 9/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//








/**
 Tags
 * /
#define CENTER_TAG          1
#define LEFT_PANEL_TAG      2
#define RIGHT_PANEL_TAG     3

/**
 Timing
 * /
#define SLIDE_TIMING            .3
#define FADE_TIMING             .5
#define FADE_TIMING_SHORTENED   .2
#define FADE_TIMING_EXTENDED    .8

/**
 Appearance - display
 * /
#define CORNER_RADIUS   4
#define PHOTOPON_OVERLAY_ALPHA  0.6f

/**
 Appearance - layout
 * /
#define CROP_SIZE                       CGSizeMake(320.0f, 320.0f)
#define PANEL_WIDTH                     60
#define TOOLBAR_FRAME_DEFAULT           CGRectMake(0.0f, 54.0f, 320.0f, 54.0f)
#define TOOLBAR_FRAME_ACTIVE            CGRectMake(0.0f, 0.0f, 320.0f, 54.0f)
// shutter closed
#define SHUTTER_TOP_FRAME_DEFAULT       CGRectMake    (0.0f, 0.0f, 320.0f, 160.0f)
#define SHUTTER_BOTTOM_FRAME_DEFAULT    CGRectMake (0.0f, 160.0f, 320.0f, 160.0f)
#define SHUTTER_SCENES_FRAME_DEFAULT    CGRectMake (0.0f, 0.0f, 320.0f, 320.0f)
// shutter open
#define SHUTTER_TOP_FRAME_OPEN                  CGRectMake (0.0f, -160.0f, 320.0f, 160.0f)
#define SHUTTER_BOTTOM_FRAME_OPEN               CGRectMake (0.0f, 320.0f, 320.0f, 160.0f)
#define SHUTTER_SCENES_FOREGROUND_FRAME_OPEN    CGRectMake (-320.0f, 0.0f, 320.0f, 320.0f)
#define SHUTTER_SCENES_BACKGROUND_FRAME_OPEN    CGRectMake (320.0f, 0.0f, 320.0f, 320.0f)

#define BACKGROUND_COLOR_BLACK_OPAQUE           [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]
#define BACKGROUND_COLOR_BLACK_OPAQUE           [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]
*/

#import "PhotoponNewPhotoponUtility.h"
#import "PhotoponNewPhotoponConstants.h"
#import "PhotoponUtility.h"

@implementation PhotoponNewPhotoponUtility

+ (CGSize) photoponCropSize{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return CROP_SIZE;
}

+ (CGFloat) photoponCropFrameOffset{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return CROP_FRAME_OFFSET_IPAD;
    if ([PhotoponUtility isTallScreen])
        return CROP_FRAME_OFFSET_TALL;
    return CROP_FRAME_OFFSET;
}

+ (CGRect) photoponCropFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return CROP_FRAME_IPAD;
    if ([PhotoponUtility isTallScreen])
        return CROP_FRAME_TALL;
    return CROP_FRAME;
}

+ (CGRect) photoponToolbarFrameDefault{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return TOOLBAR_FRAME_DEFAULT_IPAD;
    if ([PhotoponUtility isTallScreen])
        return TOOLBAR_FRAME_DEFAULT_TALL;
    return TOOLBAR_FRAME_DEFAULT;
}

+ (CGRect) photoponToolbarFrameActive{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return TOOLBAR_FRAME_ACTIVE_IPAD;
    if ([PhotoponUtility isTallScreen])
        return TOOLBAR_FRAME_ACTIVE_TALL;
    return TOOLBAR_FRAME_ACTIVE;
}

+ (CGRect) photoponShutterTopFrameDefault{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SHUTTER_TOP_FRAME_DEFAULT;
}

+ (CGRect) photoponShutterBottomFrameDefault{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SHUTTER_BOTTOM_FRAME_DEFAULT;
}

+ (CGRect) photoponShutterTopFrameOpen {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SHUTTER_TOP_FRAME_OPEN;
}

+ (CGRect) photoponShutterBottomFrameOpen{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SHUTTER_BOTTOM_FRAME_OPEN;
}

+ (CGRect) photoponShutterSceneFrameDefault{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SHUTTER_SCENES_FRAME_DEFAULT;
}

+ (CGRect) photoponShutterSceneForegroundFrameOpen{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SHUTTER_SCENES_FOREGROUND_FRAME_OPEN;
}

+ (CGRect) photoponShutterSceneBackgroundFrameOpen{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SHUTTER_SCENES_BACKGROUND_FRAME_OPEN;
}

+ (CGRect) photoponHeaderFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return HEADER_FRAME_IPAD;
    if ([PhotoponUtility isTallScreen])
        return HEADER_FRAME_TALL;
    return HEADER_FRAME;
}

+ (CGRect) photoponFooterFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return FOOTER_FRAME_IPAD;
    if ([PhotoponUtility isTallScreen])
        return FOOTER_FRAME_TALL;
    return FOOTER_FRAME;
}

+ (CGRect) photoponToolbarContainerFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (IS_IPAD)
        return TOOLBAR_CONTAINER_FRAME_IPAD;
    if ([PhotoponUtility isTallScreen])
        return TOOLBAR_CONTAINER_FRAME_TALL;
    return TOOLBAR_CONTAINER_FRAME;
}

+ (CGRect) photoponOffersContainerFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     if (IS_IPAD)
        return OFFERS_CONTAINER_FRAME_IPAD;
     if ([PhotoponUtility isTallScreen])
        return OFFERS_CONTAINER_FRAME_TALL;
     return OFFERS_CONTAINER_FRAME;
     */
    
    
    CGRect s = [PhotoponNewPhotoponUtility photoponCropFrame];
    
    
    
    
    
    //if (IS_IPAD)
        //s = [PhotoponNewPhotoponUtility photoponCropFrame];
    //if ([PhotoponUtility isTallScreen])
        //return OFFERS_CONTAINER_FRAME_TALL;
    //return OFFERS_CONTAINER_FRAME;
    
    
    
    
    
    CGFloat offersToolbarHeight = [PhotoponNewPhotoponUtility photoponOffersToolbarFrame].size.height;
    
    return CGRectMake(s.origin.x, s.origin.y, s.size.width, s.size.height + offersToolbarHeight);
}

+ (CGRect) photoponOffersToolbarFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return OFFERS_PAGE_CONTROL_TOOLBAR_FRAME_IPAD;
    if ([PhotoponUtility isTallScreen])
        return OFFERS_PAGE_CONTROL_TOOLBAR_FRAME_TALL;
    return OFFERS_PAGE_CONTROL_TOOLBAR_FRAME;
}

+ (CGRect) photoponSecondaryToolbarFrameDefault{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SECONDARY_TOOLBAR_FRAME_DEFAULT;
}

+ (CGRect) photoponSecondaryToolbarFrameActive{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return SECONDARY_TOOLBAR_FRAME_DEFAULT;
}

+ (CGRect) photoponOverlayFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /**
     if ([[UIApplication sharedApplication] isStatusBarHidden])
        return [[UIScreen mainScreen] bounds];
     */
    
    if (IS_IPAD)
        return OVERLAY_FRAME_IPAD;
    if ([PhotoponUtility isTallScreen])
        return OVERLAY_FRAME_TALL;
    return OVERLAY_FRAME;
    
}




+ (CGRect) photoponInfoContainerFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponNewPhotoponUtility photoponOverlayFrame];
}

+ (CGRect) photoponEditCaptionFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponNewPhotoponUtility photoponOverlayFrame];
}

+ (CGRect) photoponEditCaptionToolbarFrameDefault{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return EDIT_CAPTION_TOOLBAR_FRAME_DEFAULT_IPAD;
    if ([PhotoponUtility isTallScreen])
        return EDIT_CAPTION_TOOLBAR_FRAME_DEFAULT_TALL;
    return EDIT_CAPTION_TOOLBAR_FRAME_DEFAULT;
}

+ (CGRect) photoponEditCaptionToolbarFrameActive{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD)
        return EDIT_CAPTION_TOOLBAR_FRAME_ACTIVE_IPAD;
    if ([PhotoponUtility isTallScreen])
        return EDIT_CAPTION_TOOLBAR_FRAME_ACTIVE_TALL;
    return EDIT_CAPTION_TOOLBAR_FRAME_ACTIVE;
}

+ (CGRect) photoponFlashLightingEffectFrame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponNewPhotoponUtility photoponOverlayFrame];
}

+ (UIImage*) photoponInfoCreationImage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIImage photoponImageNamed:[NSString stringWithFormat:@"%@", INFO_CREATION_IMAGE_NAME]];
}

+ (UIImage*) photoponInfoConfirmationImage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIImage photoponImageNamed:[NSString stringWithFormat:@"%@", INFO_CONFIRMATION_IMAGE_NAME]];
}

//+ (NSString *)





/*
+ (UIBasicAnimation*)tr{
    
}*/

@end
