//
//  PhotoponNewCompositionPreviewViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PhotoponNewCompositionPreviewViewControllerChooseBlock)(UIImage *chosenImage);

@interface PhotoponNewCompositionPreviewViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIToolbar *photoponToolBar;
@property (nonatomic, strong) IBOutlet UIButton *photoponBtnChoose;

/**
 `CZPhotoPreviewViewController` shows an image to the user for review. It should act
 like the preview in Mail.app and Messages.app. It does not support pinch to zoom.
 
 @param anImage The `UIImage` to show. Will be presented aspect fit.
 @param cropOverlaySize The size of the crop overlay view. Not displayed if equal to CGSizeZero.
 @param chooseBlock Block to be called if choose/use button is tapped.
 @param cancelBlock Block to be called if they cancel.
 */
- (id)initWithImage:(UIImage *)anImage cropOverlaySize:(CGSize)cropOverlaySize tagBlock:(dispatch_block_t)tagBlock nextBlock:(dispatch_block_t)nextBlock  cancelBlock:(dispatch_block_t)cancelBlock;


- (void)didCancel:(id)sender;

- (void)didNext:(id)sender;

- (void)didTagCoupon:(id)sender;

@end
