//
//  PhotoponNewPhotoponPreviewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PhotoponNewPhotoponPreviewChooseBlock)(UIImage *chosenImage);

@interface PhotoponNewPhotoponPreviewController : UIViewController

/**
 `CZPhotoPreviewViewController` shows an image to the user for review. It should act
 like the preview in Mail.app and Messages.app. It does not support pinch to zoom.
 
 @param anImage The `UIImage` to show. Will be presented aspect fit.
 @param cropOverlaySize The size of the crop overlay view. Not displayed if equal to CGSizeZero.
 @param chooseBlock Block to be called if choose/use button is tapped.
 @param cancelBlock Block to be called if they cancel.
 */
- (id)initWithImage:(UIImage *)anImage cropOverlaySize:(CGSize)cropOverlaySize chooseBlock:(dispatch_block_t)chooseBlock cancelBlock:(dispatch_block_t)cancelBlock;

@end
