//
//  PhotoponNewCompositionMainView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/10/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CZPhotoPickerController.h"
#import "PhotoponNewCompositionMainView.h"

@interface PhotoponNewCompositionMainView ()
@property (weak, nonatomic) IBOutlet UISwitch *cropPreviewSwitch;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) CZPhotoPickerController *pickPhotoController;
@end

@implementation PhotoponNewCompositionMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - CZPhotoPickerController Methods

- (CZPhotoPickerController *)photoController
{
    __weak __typeof(&*self)weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        
        UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage];
        if (!image) {
            image = imageInfoDict[UIImagePickerControllerOriginalImage];
        }
        
        weakSelf.imageView.image = image;
        
        [weakSelf.pickPhotoController dismissAnimated:YES];
        weakSelf.pickPhotoController = nil;
        
    }];
}

- (IBAction)takePicture:(id)sender
{
    if (self.pickPhotoController) {
        return;
    }
    
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.saveToCameraRoll = NO;
    
    if (self.cropPreviewSwitch.on) {
        self.pickPhotoController.allowsEditing = NO;
        self.pickPhotoController.cropOverlaySize = CGSizeMake(320, 100);
    }
    else {
        self.pickPhotoController.allowsEditing = YES;
        self.pickPhotoController.cropOverlaySize = CGSizeZero;
    }
    
    [self.pickPhotoController showFromBarButtonItem:sender];
}

@end
