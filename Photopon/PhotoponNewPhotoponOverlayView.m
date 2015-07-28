//
//  PhotoponNewPhotoponOverlayView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoponNewPhotoponOverlayView.h"
#import "PhotoponTabBarController.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponNavigationViewController.h"
#import "PhotoponNewPhotoponUtility.h"

@interface PhotoponNewPhotoponOverlayView()

@property(nonatomic,strong) UIView *bottomMaskView;
@property(nonatomic,assign) CGSize cropOverlaySize;
@property(nonatomic,strong) UIView *highlightView;
@property(nonatomic,strong) UIView *topMaskView;
@property (assign) SystemSoundID tickSound;
@property (nonatomic, strong) NSArray *libPhotos;

@end

@implementation PhotoponNewPhotoponOverlayView

@synthesize photoponToolBarView;
@synthesize photoponBtnCamera;
@synthesize photoponBtnCancel;
@synthesize photoponBtnLibrary;

#pragma mark - Lifecycle

+ (PhotoponNewPhotoponOverlayView*)photoponNewPhotoponOverlayViewWithCropOverlaySize:(CGSize)cropOverlaySize{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponNewPhotoponOverlayView" owner:nil options:nil];
    PhotoponNewPhotoponOverlayView *view = [arr objectAtIndex:0];
    
    [view initSounds];
    
    view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    view.cropOverlaySize = cropOverlaySize;
    view.userInteractionEnabled = YES;
    
    view.topMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    view.bottomMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    
    view.topMaskView.userInteractionEnabled = NO;
    view.bottomMaskView.userInteractionEnabled = NO;
    
    [view addSubview:view.topMaskView];
    [view addSubview:view.bottomMaskView];
    
    //UIColor *backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    //view.topMaskView.backgroundColor = backgroundColor;
    //view.bottomMaskView.backgroundColor = backgroundColor;
    
    view.highlightView = [[UIView alloc] initWithFrame:CGRectZero];
    view.highlightView.backgroundColor = [UIColor clearColor];
    view.highlightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.2].CGColor;
    view.highlightView.layer.borderWidth = 1.0f;
    [view addSubview:view.highlightView];
    
    view.photoponBtnLibrary.imageView.layer.cornerRadius = 2.0f;
    
    /*
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    ALAssetsLibrary *al = [PhotoponNewPhotoponOverlayView defaultAssetsLibrary];
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                          
                          [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                              if (asset) {
                                  [collector addObject:asset];
                              }
                          }];
                          view.libPhotos = collector;
                          
                          ALAsset *asset = [view.libPhotos objectAtIndex:[view.libPhotos count]-1];
                          [view.photoponBtnLibrary setImage:[UIImage imageWithCGImage:[asset thumbnail]] forState:UIControlStateNormal];
                      }
                    failureBlock:^(NSError *error) {
                        NSLog(@"Library Btn SetImage Failed!!!");
                    }];
    */
    
    [view.photoponBtnLibrary setFrame:CGRectMake(276.0f, 5.0f, 34.0f, 34.0f)];
    [view bringSubviewToFront:view.photoponToolBarView];
    
    return view;
    
}

- (void)initSounds{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:
                                                [[NSBundle mainBundle] pathForResource:@"tick"
                                                                                ofType:@"aiff"]],
                                     &_tickSound);
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

- (id)initWithFrame:(CGRect)frame cropOverlaySize:(CGSize)cropOverlaySize
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        self.cropOverlaySize = cropOverlaySize;
        self.userInteractionEnabled = YES;
        
        self.topMaskView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomMaskView = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.topMaskView.userInteractionEnabled = NO;
        self.bottomMaskView.userInteractionEnabled = NO;
        
        [self addSubview:self.topMaskView];
        [self addSubview:self.bottomMaskView];
        
        UIColor *backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        self.topMaskView.backgroundColor = backgroundColor;
        self.bottomMaskView.backgroundColor = backgroundColor;
        
        self.highlightView = [[UIView alloc] initWithFrame:CGRectZero];
        self.highlightView.backgroundColor = [UIColor clearColor];
        self.highlightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.6].CGColor;
        self.highlightView.layer.borderWidth = 1.0f;
        [self addSubview:self.highlightView];
    }
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    
    CGFloat scale = (CGRectGetWidth(self.frame) / self.cropOverlaySize.width);
    CGSize scaledCropOverlay = CGSizeMake((self.cropOverlaySize.width * scale), (self.cropOverlaySize.height * scale));
    
    CGFloat yOrigin = (CGRectGetHeight(self.frame) - scaledCropOverlay.height) / 2 - [PhotoponNewPhotoponUtility photoponCropFrameOffset];
    
    self.topMaskView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), yOrigin);
    self.bottomMaskView.frame = CGRectMake(0, yOrigin + scaledCropOverlay.height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - (yOrigin + scaledCropOverlay.height));
    self.highlightView.frame = CGRectMake(0, CGRectGetMaxY(self.topMaskView.frame), CGRectGetWidth(self.frame), CGRectGetMinY(self.bottomMaskView.frame) - CGRectGetMaxY(self.topMaskView.frame));
    
}

- (IBAction)photoponBtnCancelHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navController dismissNewPhotoponPickerControllerAnimated:YES doUpload:NO];
    
}

- (IBAction)photoponBtnCameraHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.libPhotos = nil;
    
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navController takePhotoponPhoto];
    
}

- (IBAction)photoponBtnLibraryHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

@end