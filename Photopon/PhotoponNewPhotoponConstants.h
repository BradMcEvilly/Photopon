//
//  PhotoponNewPhotoponConstants.h
//  Photopon
//
//  Created by Brad McEvilly on 9/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Tags
 */
#define CENTER_TAG          1
#define LEFT_PANEL_TAG      2
#define RIGHT_PANEL_TAG     3

/**
 Timing
 */
#define SLIDE_TIMING            .3
#define SLIDE_TIMING_EXTENDED   .400
#define FADE_TIMING             .5
#define FADE_TIMING_SHORTENED   .2
#define FADE_TIMING_EXTENDED    .8

#define INFO_CREATION_IMAGE_NAME            @"PhotoponInfoCreation"
#define INFO_CONFIRMATION_IMAGE_NAME        @"PhotoponInfoConfirmation"

/**
 Appearance - display
 */
#define CORNER_RADIUS   4
#define PHOTOPON_OVERLAY_ALPHA  0.8f

/**
 Appearance - layout
 */
#define CROP_SIZE                       CGSizeMake(320.0f, 320.0f)
#define PANEL_WIDTH                     60

// shutter
#define SHUTTER_FRAME                   CGRectMake (0.0f, 0.0f, 320.0f, 320.0f)
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



/**
 3.5 INCH SCREEN ORIGINS & MEASUREMENTS
 -----------------------------------
 HEADER             44
 FOOTER             48
 OFFERS FOOTER      14
 TOOLBAR CONTAINER  54
 PHOTO CROP         320
 -----------------------------------
 */

// DYNAMIC POSITIONS

#define CROP_FRAME_OFFSET                           33.0f

#define OVERLAY_FRAME                               CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)

#define CROP_FRAME                                  CGRectMake(0.0f, 44.0f, 320.0f, 320.0f)

#define TOOLBAR_FRAME_DEFAULT                       CGRectMake(0.0f, 54.0f, 320.0f, 54.0f)

#define TOOLBAR_FRAME_ACTIVE                        CGRectMake(0.0f, 0.0f, 320.0f, 54.0f)

#define OFFERS_CONTAINER_FRAME                      CGRectMake(0.0f, 44.0f, 320.0f, 334.0f)

#define OFFERS_PAGE_CONTROL_TOOLBAR_FRAME           CGRectMake(0.0f, 320.0f, 320.0f, 14.0f)

#define SECONDARY_TOOLBAR_FRAME_DEFAULT             CGRectMake(0.0f, 48.0f, 320.0f, 48.0f)

#define SECONDARY_TOOLBAR_FRAME_ACTIVE              CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)

#define TOOLBAR_CONTAINER_FRAME                     CGRectMake(0.0f, 426.0f, 320.0f, 54.0f)

#define HEADER_FRAME                                CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)

#define FOOTER_FRAME                                CGRectMake(0.0f, 378.0f, 320.0f, 48.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_DEFAULT          CGRectMake(0.0f, 426.0f, 320.0f, 54.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_ACTIVE           CGRectMake(0.0f, 210.0f, 320.0f, 54.0f)

/**
 --------------------------------------------
 IPHONE - 4 INCH
 --------------------------------------------
 */
/**
 4 INCH SCREEN ORIGINS & MEASUREMENTS
 -----------------------------------
 HEADER             76
 FOOTER             48
 OFFERS FOOTER      28
 TOOLBAR CONTAINER  96
 PHOTO CROP         320
 -----------------------------------
 */


#define CROP_FRAME_OFFSET_TALL                                  33.0f

#define OVERLAY_FRAME_TALL                                      CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)

#define CROP_FRAME_TALL                                         CGRectMake(0.0f, 76.0f, 320.0f, 320.0f)

#define TOOLBAR_FRAME_DEFAULT_TALL                              CGRectMake(0.0f, 96.0f, 320.0f, 96.0f)

#define TOOLBAR_FRAME_ACTIVE_TALL                               CGRectMake(0.0f, 0.0f, 320.0f, 96.0f)

#define OFFERS_CONTAINER_FRAME_TALL                             CGRectMake(0.0f, 76.0f, 320.0f, 348.0f)

#define OFFERS_PAGE_CONTROL_TOOLBAR_FRAME_TALL                  CGRectMake(0.0f, 320.0f, 320.0f, 28.0f)

#define SECONDARY_TOOLBAR_FRAME_DEFAULT_TALL                    CGRectMake(0.0f, 48.0f, 320.0f, 48.0f)

#define SECONDARY_TOOLBAR_FRAME_ACTIVE_TALL                     CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)

#define TOOLBAR_CONTAINER_FRAME_TALL                            CGRectMake(0.0f, 472.0f, 320.0f, 96.0f)

#define HEADER_FRAME_TALL                                       CGRectMake(0.0f, 0.0f, 320.0f, 76.0f)

#define FOOTER_FRAME_TALL                                       CGRectMake(0.0f, 424.0f, 320.0f, 48.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_DEFAULT_TALL                 CGRectMake(0.0f, 514.0f, 320.0f, 54.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_ACTIVE_TALL                  CGRectMake(0.0f, 298.0f, 320.0f, 54.0f)

/**
 --------------------------------------------
IPAD
 --------------------------------------------
* /

#define CROP_FRAME_OFFSET_IPAD                              33.0f

#define CROP_FRAME_IPAD                                     CGRectMake(0.0f, 76.0f, 320.0f, 320.0f)

#define OVERLAY_FRAME_IPAD                                  CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)

#define TOOLBAR_FRAME_DEFAULT_IPAD                          CGRectMake(0.0f, 96.0f, 320.0f, 96.0f)

#define TOOLBAR_FRAME_ACTIVE_IPAD                           CGRectMake(0.0f, 0.0f, 320.0f, 96.0f)

#define OFFERS_CONTAINER_FRAME_IPAD                         CGRectMake(0.0f, 76.0f, 320.0f, 337.0f)

#define OFFERS_PAGE_CONTROL_TOOLBAR_FRAME_IPAD              CGRectMake(0.0f, 320.0f, 320.0f, 32.0f)

#define SECONDARY_TOOLBAR_FRAME_DEFAULT_IPAD                CGRectMake(0.0f, 48.0f, 320.0f, 44.0f)

#define SECONDARY_TOOLBAR_FRAME_ACTIVE_IPAD                 CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)

#define TOOLBAR_CONTAINER_FRAME_IPAD                        CGRectMake(0.0f, 476.0f, 320.0f, 96.0f)

#define HEADER_FRAME_IPAD                                   CGRectMake(0.0f, 0.0f, 320.0f, 76.0f)

#define FOOTER_FRAME_IPAD                                   CGRectMake(0.0f, 428.0f, 320.0f, 96.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_DEFAULT_IPAD             CGRectMake(0.0f, 514.0f, 320.0f, 54.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_ACTIVE_IPAD              CGRectMake(0.0f, 298.0f, 320.0f, 54.0f)
*/

#define CROP_FRAME_OFFSET_IPAD                                  33.0f

#define OVERLAY_FRAME_IPAD                                      CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)

#define CROP_FRAME_IPAD                                         CGRectMake(0.0f, 76.0f, 320.0f, 320.0f)

#define TOOLBAR_FRAME_DEFAULT_IPAD                              CGRectMake(0.0f, 96.0f, 320.0f, 96.0f)

#define TOOLBAR_FRAME_ACTIVE_IPAD                               CGRectMake(0.0f, 0.0f, 320.0f, 96.0f)

#define OFFERS_CONTAINER_FRAME_IPAD                             CGRectMake(0.0f, 76.0f, 320.0f, 348.0f)

#define OFFERS_PAGE_CONTROL_TOOLBAR_FRAME_IPAD                  CGRectMake(0.0f, 320.0f, 320.0f, 28.0f)

#define SECONDARY_TOOLBAR_FRAME_DEFAULT_IPAD                    CGRectMake(0.0f, 48.0f, 320.0f, 48.0f)

#define SECONDARY_TOOLBAR_FRAME_ACTIVE_IPAD                     CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)

#define TOOLBAR_CONTAINER_FRAME_IPAD                            CGRectMake(0.0f, 472.0f, 320.0f, 96.0f)

#define HEADER_FRAME_IPAD                                       CGRectMake(0.0f, 0.0f, 320.0f, 76.0f)

#define FOOTER_FRAME_IPAD                                       CGRectMake(0.0f, 424.0f, 320.0f, 48.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_DEFAULT_IPAD                 CGRectMake(0.0f, 514.0f, 320.0f, 54.0f)

#define EDIT_CAPTION_TOOLBAR_FRAME_ACTIVE_IPAD                  CGRectMake(0.0f, 298.0f, 320.0f, 54.0f)




