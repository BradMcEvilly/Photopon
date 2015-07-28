//
//  PhotoponNewCompositionPreviewViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewCompositionPreviewViewController.h"
#import "PhotoponNewCompositionViewController.h"

@interface PhotoponNewCompositionPreviewViewController ()

@property(nonatomic,copy) dispatch_block_t cancelBlock;
@property(nonatomic,copy) dispatch_block_t nextBlock;
@property(nonatomic,copy) dispatch_block_t tagBlock;
@property(nonatomic,assign) CGSize cropOverlaySize;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,weak) IBOutlet UILabel *previewLabel;

@end

@implementation PhotoponNewCompositionPreviewViewController

#pragma mark - Lifecycle

- (id)initWithImage:(UIImage *)anImage cropOverlaySize:(CGSize)cropOverlaySize tagBlock:(dispatch_block_t)tagBlock nextBlock:(dispatch_block_t)nextBlock cancelBlock:(dispatch_block_t)cancelBlock
{
    NSParameterAssert(chooseBlock);
    NSParameterAssert(cancelBlock);
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _cropOverlaySize = cropOverlaySize;
        self.cancelBlock = cancelBlock;
        self.nextBlock = nextBlock;
        self.nextBlock = tagBlock;
        self.image = anImage;
        self.title = NSLocalizedString(@"New Photopon", nil);
    }
    
    return self;
}

#pragma mark - Methods

- (void)didCancel:(id)sender
{
    self.cancelBlock();
}

- (void)didNext:(id)sender
{
    self.nextBlock();
}

- (void)didTagCoupon:(id)sender
{
    
    self.tagBlock();
    //self.chooseBlock();

}

- (CGRect)previewFrame
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    [self.photoponToolBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundToolBar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    if (self.photoponToolBar.hidden == NO) {
        frame.size.height -= CGRectGetHeight(self.photoponToolBar.frame);
    }
    
    return frame;
}
/*
- (void)setupCropOverlay
{
    CZCropPreviewOverlayView *overlay = [[CZCropPreviewOverlayView alloc] initWithFrame:self.previewFrame cropOverlaySize:self.cropOverlaySize];
    [self.view insertSubview:overlay aboveSubview:self.imageView];
}
*/
#pragma mark - UIViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.imageView.image = self.image;
    self.imageView.frame = [self previewFrame];
    
    [self.photoponToolBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundToolBar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    CGFloat widthRatio = self.imageView.frame.size.width / self.image.size.width;
    CGFloat heightRatio = self.imageView.frame.size.height / self.image.size.height;
    
    UIViewContentMode mode;
    
    if (widthRatio < heightRatio) {
        mode = UIViewContentModeScaleAspectFit;
    }
    else {
        mode = UIViewContentModeScaleAspectFill;
    }
    
    self.imageView.contentMode = mode;
    
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.y = (CGRectGetHeight([self previewFrame]) - CGRectGetHeight(self.imageView.frame)) / 2;
    self.imageView.frame = imageViewFrame;
    
    // No toolbar on iPad, use the nav bar. Mimic how Mail.app’s picker works
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.photoponToolBar.hidden = YES;
        self.previewLabel.hidden = YES;
        
        // Intentionally not using the bar buttons from the xib as that causes
        // a weird re-layout.
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Use", nil) style:UIBarButtonItemStyleDone target:self action:@selector(didChoose:)];
    }
    else {
        //self.photoponToolBar.tintColor = [UIColor blackColor];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
        self.imageView.frame = [self previewFrame];
        
        // Configure the preview label for the cropping use case
        self.previewLabel.shadowColor = [UIColor blackColor];
        self.previewLabel.shadowOffset = CGSizeMake(0, -1);
        self.previewLabel.text = NSLocalizedString(@"Crop Preview", nil);
        [self.previewLabel sizeToFit];
        self.previewLabel.center = self.photoponToolBar.center;
        
        self.title = self.previewLabel.text;
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake( 7.0f, 12.0f, 28.0f, 23.0f);
    [cancelButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCancel.png"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCancel.png"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(didCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoponToolBar addSubview:cancelButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake( 245.0f, 6.0f, 64.0f, 30.0f);
    [nextButton setImage:[UIImage imageNamed:@"PhotoponToolBarBtnNext.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"PhotoponToolBarBtnNext.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(didNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoponToolBar addSubview:nextButton];
    
    UIButton *tagCouponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tagCouponButton.frame = CGRectMake( 85.0f, 6.0f, 150.0f, 30.0f);
    [tagCouponButton setImage:[UIImage imageNamed:@"PhotoponToolBarBtnTagCoupon.png"] forState:UIControlStateNormal];
    [tagCouponButton setImage:[UIImage imageNamed:@"PhotoponToolBarBtnTagCoupon.png"] forState:UIControlStateHighlighted];
    [tagCouponButton addTarget:self action:@selector(didTagCoupon:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoponToolBar addSubview:tagCouponButton];
    
    
    [self.view bringSubviewToFront:self.photoponToolBar];
    [self.view bringSubviewToFront:self.previewLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 480);
    
    if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
        //[self setupCropOverlay];
    }
    
    [super viewWillAppear:animated];
}

@end