//
//  PhotoponNewPhotoponPreviewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewPhotoponPreviewController.h"
#import "PhotoponNewPhotoponOverlayView.h"

@interface PhotoponNewPhotoponPreviewController ()

@property(nonatomic,copy) dispatch_block_t cancelBlock;
@property(nonatomic,copy) dispatch_block_t chooseBlock;
@property(nonatomic,assign) CGSize cropOverlaySize;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,weak) IBOutlet UILabel *previewLabel;
@property(nonatomic,weak) IBOutlet UIToolbar *toolbar;

@end

@implementation PhotoponNewPhotoponPreviewController

#pragma mark - Lifecycle

- (id)initWithImage:(UIImage *)anImage cropOverlaySize:(CGSize)cropOverlaySize chooseBlock:(dispatch_block_t)chooseBlock cancelBlock:(dispatch_block_t)cancelBlock
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSParameterAssert(chooseBlock);
    NSParameterAssert(cancelBlock);
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _cropOverlaySize = cropOverlaySize;
        self.cancelBlock = cancelBlock;
        self.chooseBlock = chooseBlock;
        self.image = anImage;
        self.title = NSLocalizedString(@"Choose Photo", nil);
    }
    
    return self;
}

#pragma mark - Methods

- (IBAction)didCancel:(id)sender
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.cancelBlock();
}

- (IBAction)didChoose:(id)sender
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.chooseBlock();
}

- (CGRect)previewFrame
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundToolBar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    if (self.toolbar.hidden == NO) {
        frame.size.height -= CGRectGetHeight(self.toolbar.frame);
    }
    
    return frame;
}

- (void)setupCropOverlay
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponNewPhotoponOverlayView *overlay = [[PhotoponNewPhotoponOverlayView alloc] initWithFrame:self.previewFrame cropOverlaySize:self.cropOverlaySize];
    [self.view insertSubview:overlay aboveSubview:self.imageView];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    self.imageView.image = self.image;
    self.imageView.frame = [self previewFrame];
    
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
        self.toolbar.hidden = YES;
        self.previewLabel.hidden = YES;
        
        // Intentionally not using the bar buttons from the xib as that causes
        // a weird re-layout.
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Use", nil) style:UIBarButtonItemStyleDone target:self action:@selector(didChoose:)];
    }
    else {
        self.toolbar.tintColor = [UIColor blackColor];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
        self.imageView.frame = [self previewFrame];
        
        // Configure the preview label for the cropping use case
        self.previewLabel.shadowColor = [UIColor blackColor];
        self.previewLabel.shadowOffset = CGSizeMake(0, -1);
        self.previewLabel.text = NSLocalizedString(@"Crop Preview", nil);
        [self.previewLabel sizeToFit];
        self.previewLabel.center = self.toolbar.center;
        
        self.title = self.previewLabel.text;
    }
    
    [self.view bringSubviewToFront:self.toolbar];
    [self.view bringSubviewToFront:self.previewLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 480);
    
    if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
        [self setupCropOverlay];
    }
    
    [super viewWillAppear:animated];
}

@end