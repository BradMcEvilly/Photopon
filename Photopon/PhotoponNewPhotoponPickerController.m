//
//  PhotoponNewPhotoponPickerController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoponNewPhotoponPickerController.h"
#import "PhotoponNewPhotoponOverlayViewController.h"
#import "PhotoponNewPhotoponPreviewController.h"
#import "UIImage+Scaling.h"
#import "PhotoponFile.h"
#import "PhotoponMediaModel.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponHomeViewController.h"
#import "CZPhotoPreviewViewController.h"
#import "PhotoponNavigationViewController.h"
#import "UIViewController+Photopon.h"
#import "PhotoponNewPhotoponUtility.h"
#import "PhotoponNewPhotoponConstants.h"


typedef enum {
    PhotoPickerButtonUseLastPhoto,
    PhotoPickerButtonTakePhoto,
    PhotoPickerButtonChooseFromLibrary,
} PhotoPickerButtonKind;

@interface PhotoponNewPhotoponPickerController ()
<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UITableViewDelegate>



@end


@implementation PhotoponNewPhotoponPickerController

@synthesize croppedImage;
//@synthesize photoponNewPhotoponOverlayViewController;

@synthesize libScreenShotViewController;
@synthesize camScreenShotViewController;
@synthesize camScreenShot;
@synthesize libScreenShot;
@synthesize libScreenShotImg;
@synthesize camScreenShotImg;

#pragma mark - Class Methods

+ (BOOL)canTakePhoto
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage] == NO) {
        return NO;
        
    }
    
    return YES;
}

- (void) takePhotoponPhoto{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.mediaUI) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"media UI is nil" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        return;
    }
    
    [self.mediaUI takePicture];
    
}

#pragma mark - Lifecycle

- (void)dealloc
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)removePhotoponApplicationDidEnterBGObserver{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (id)initWithPresentingViewController:(UIViewController *)aViewController withCompletionBlock:(PhotoponPickerCompletionBlock)completionBlock
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    
    if (self) {
        
        [self addPhotoponObservers];
        
        self.mediaUI = [[UIImagePickerController alloc] init];
        
        self.completionBlock = completionBlock;
        self.offerLastTaken = NO;
        self.saveToCameraRoll = NO;
        self.showFromViewController = aViewController;
        
        // default
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cropOverlaySize = CGSizeMake(320, 320);
        
    }
    
    return self;
}

- (void) removePhotoponObservers{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) addPhotoponObservers{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraDidStartRunning:) name:AVCaptureSessionDidStartRunningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraDidStopRunning:) name:AVCaptureSessionDidStopRunningNotification object:nil];
    
}

- (id)initWithPresentingViewController:(UIViewController *)aViewController withOverlayViewController:(PhotoponNewPhotoponOverlayViewController *)overlayViewController withCompletionBlock:(PhotoponPickerCompletionBlock)completionBlock
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraDidStartRunning:) name:AVCaptureSessionDidStartRunningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraDidStopRunning:) name:AVCaptureSessionDidStopRunningNotification object:nil];
        
        self.mediaUI = [[UIImagePickerController alloc] init];
        
        
        self.mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        self.mediaUI.allowsEditing = self.allowsEditing;
        self.mediaUI.delegate = self;
        self.mediaUI.mediaTypes = @[ (NSString *)kUTTypeImage ];
        
        [self.mediaUI loadView];
        
        
        
        self.completionBlock = completionBlock;
        self.offerLastTaken = NO;
        self.saveToCameraRoll = NO;
        self.showFromViewController = aViewController;
        
        // default
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cropOverlaySize = CGSizeMake(320, 320);
        self.photoponNewPhotoponOverlayViewController = overlayViewController;
        
        
        
    }
    
    return self;
}

- (void)cameraDidStartRunning:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // `cameraOverlayView` docs say this is nil by default, but in practice it's non-nil.
    // Adding as a subview keeps pinch-to-zoom on the camera. Setting the property
    // loses pinch-to-zoom. Handling nil here just to be safe.
    
    //self.mediaUI.cameraOverlayView = self.photoponNewPhotoponOverlayViewController.view;
    
    
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(cameraDidStartRunningOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self cameraDidStartRunningOnMainThread];
    }
    
}

- (void)cameraDidStartRunningOnMainThread
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    @try {
        
        NSLog(@"CHECK 1");
        
        if (!self.photoponNewPhotoponOverlayViewController.view.window)
            return;
        NSLog(@"CHECK 2");
        if (self.mediaUI.cameraOverlayView == self.photoponNewPhotoponOverlayViewController.view) {
            return;
        }
        
        NSLog(@"CHECK 3");
        
        self.photoponNewPhotoponOverlayViewController.picker = self;
        
        
        NSLog(@"CHECK 4");
        
        
        
        
        [self.mediaUI addChildViewController:self.photoponNewPhotoponOverlayViewController];
        
        NSLog(@"CHECK 5");
        
        
        //self.mediaUI.cameraOverlayView = nil;
        
        self.mediaUI.cameraOverlayView = self.photoponNewPhotoponOverlayViewController.view;
        
        NSLog(@"CHECK 6");
        
        self.photoponNewPhotoponOverlayViewController.view.bounds = [PhotoponNewPhotoponUtility photoponOverlayFrame];
        
        NSLog(@"CHECK 7");
        
        [self.mediaUI viewWillAppear:NO];
        
        NSLog(@"CHECK 8");
        
        [self.mediaUI viewDidAppear:NO];
        
        NSLog(@"CHECK 9");
        
        
        if (self.photoponNewPhotoponOverlayViewController) {
            [self.photoponNewPhotoponOverlayViewController openShutter];
        }
        NSLog(@"CHECK 10");
        
        
    }
    @catch (NSException *exception) {
        //
        NSLog(@"CHECK 11");
    }
    @finally {
        //
        
        NSLog(@"CHECK 12");
        
    }
    
    NSLog(@"CHECK 13");
    
}

- (void)cameraDidStopRunning:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // `cameraOverlayView` docs say this is nil by default, but in practice it's non-nil.
    // Adding as a subview keeps pinch-to-zoom on the camera. Setting the property
    // loses pinch-to-zoom. Handling nil here just to be safe.
    
    //self.mediaUI.cameraOverlayView = self.photoponNewPhotoponOverlayViewController.view;
    
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(cameraDidStopRunningOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        [self cameraDidStopRunningOnMainThread];
    }
}

- (void)cameraDidStopRunningOnMainThread
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.view removeFromSuperview];
    
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.parentViewController.view bringSubviewToFront:self.photoponNewPhotoponOverlayViewController.view];
    
    
    
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.parentViewController.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.parentViewController.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
    
    
    
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.parentViewController.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
    
    
    
    //[self.photoponNewPhotoponOverlayViewController.view removeFromSuperview];
    
    //self.mediaUI.cameraOverlayView = nil;
    
    //[self.photoponNewPhotoponOverlayViewController configureViewForModeClose];
    
    [self.mediaUI.view removeFromSuperview];
    
    
}

-(void)setUpCameraOverlay{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController] addChildViewController:self.photoponNewPhotoponOverlayViewController];
    //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController].photoponModalViewController addChildViewController:self.mediaUI];
}

#pragma mark - Application state change

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.popoverController dismissPopoverAnimated:YES];
    //self.popoverController = nil;
    
    //
    
    //[self.photoponNewPhotoponOverlayViewController photoponDidBecomeActive];
    
    
    
    
    
    
    
    
    /*
    if (self.completionBlock) {
        self.completionBlock(nil, nil);
    }*/
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.popoverController dismissPopoverAnimated:YES];
    //self.popoverController = nil;
    
    //[self.photoponNewPhotoponOverlayViewController photoponDidEnterBackground];
    
    
    
    /*
     if (self.completionBlock) {
     self.completionBlock(nil, nil);
     }*/
}



- (ALAssetsLibrary *)assetsLibrary
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetsLibrary;
}

- (NSString *)buttonTitleForButtonIndex:(NSUInteger)buttonIndex
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (buttonIndex) {
        case PhotoPickerButtonUseLastPhoto:
            return NSLocalizedString(@"Use Last Photo Taken", nil);
            
        case PhotoPickerButtonTakePhoto:
            return NSLocalizedString(@"Take Photo", nil);
            
        case PhotoPickerButtonChooseFromLibrary:
            return NSLocalizedString(@"Choose from Library", nil);
            
        default:
            return nil;
    }
}

- (UIImage *)cropImage:(UIImage *)image
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*self.croppedImage = [UIImage alloc];
    
    self.croppedImage = image;
    
    CGFloat resizeScale = (image.size.width / self.cropOverlaySize.width);
    
    
    NSLog(@"||||||||||||||>     1");
    
    CGSize size = image.size;
    
    NSLog(@"||||||||||||||>     2");
    
    //CGSize reSize = CGSizeMake(self.cropOverlaySize.width * resizeScale, self.cropOverlaySize.height * resizeScale);
    
    
    CGSize cropSize = CGSizeMake(self.cropOverlaySize.width * resizeScale, self.cropOverlaySize.height * resizeScale);
    
    NSLog(@"||||||||||||||>     3");
    
    CGFloat scalex = cropSize.width / size.width;
    CGFloat scaley = cropSize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    NSLog(@"||||||||||||||>     4");
    
    
    //UIGraphicsBeginImageContext(cropSize);
    
    NSLog(@"||||||||||||||>     5");
    
    CGFloat width = size.width * scalex;
    CGFloat height = size.height * scaley;
    
    NSLog(@"||||||||||||||>     6");
    
    CGFloat originX = ((cropSize.width - width) / 2.0f);
    CGFloat originY = ((cropSize.height - height) / 2.0f) + ([PhotoponNewPhotoponUtility photoponCropFrameOffset] * resizeScale);
    
    NSLog(@"||||||||||||||>     7");
    
    CGRect rect = CGRectMake(originX, originY, size.width * scalex, size.height * scaley);
    
    
    NSLog(@"||||||||||||||>     8");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSLog(@"||||||||||||||>     8-1");
        
        //newImage = [image imageByScalingProportionallyToSize:CGSizeMake(320.0f, 320.0f)];
        
        UIImage*newImage = [image croppedImageWithRect:rect];
        
        NSLog(@"||||||||||||||>     8-1-1");
        
        newImage = [newImage imageByScalingProportionallyToSize:CGSizeMake(320.0f, 320.0f)];
        
        NSLog(@"||||||||||||||>     8-2");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSLog(@"||||||||||||||>     8-3");
            
            //UIImageWriteToSavedPhotosAlbum(self.croppedImage, nil, nil, nil);
            
            NSDictionary *croppedImageUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  newImage, @"croppedImage", nil];
            
            //[[[PhotoponMediaModel newPhotoponDraft] photoponMediaImageFile] setImage:newImage];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidCropImage object:nil userInfo:croppedImageUserInfo];
            
            NSLog(@"||||||||||||||>     8-4");
           
            //image =
            
        });
        
        NSLog(@"||||||||||||||>     8-5");
        
        
    });
    
    //[image drawInRect:rect];
    
    NSLog(@"||||||||||||||>     9");
    
    //UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSLog(@"||||||||||||||>     10");
    
    //UIGraphicsEndImageContext();
    
    NSLog(@"||||||||||||||>     11");
    
    
    
    return image;
    
    
    
    / *
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    CGFloat resizeScale = (image.size.width / self.cropOverlaySize.width);
    
    NSLog(@"||||||||||||||>     1");
    
    CGSize size = image.size;
    
    NSLog(@"||||||||||||||>     2");
    
    CGSize cropSize = CGSizeMake(self.cropOverlaySize.width * resizeScale, self.cropOverlaySize.height * resizeScale);
    
    NSLog(@"||||||||||||||>     3");
    
    
    
    
    CGFloat scalex = cropSize.width / size.width;
    CGFloat scaley = cropSize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    NSLog(@"||||||||||||||>     4");
    
    
    

    //CGBitmapContextCreate(nil, cropSize.width, cropSize.height, <#size_t bitsPerComponent#>, <#size_t bytesPerRow#>, <#CGColorSpaceRef space#>, <#CGBitmapInfo bitmapInfo#>)
    
    //UIGraphicsEndImageContext();
    
    //UIGraphicsBeginImageContext(cropSize);
    
    //UIGraphicsBeginImageContext()
    
    /*
    UIGraphicsBeginImageContext(drawImage.bounds.size);
    [drawImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage
    * /
    NSLog(@"||||||||||||||>     5");
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    NSLog(@"||||||||||||||>     6");
    
    CGFloat originX = ((cropSize.width - width) / 2.0f);
    CGFloat originY = ((cropSize.height - height) / 2.0f - [PhotoponNewPhotoponUtility photoponCropFrameOffset]);
    
    NSLog(@"||||||||||||||>     7");
    
    CGRect rect = CGRectMake(originX, originY, size.width * scale, size.height * scale);
    
    NSLog(@"||||||||||||||>     8");
    
    //UIImage *newImg = [UIImage alloc];
    
    NSLog(@"||||||||||||||>     9");
    
    //newImg = [image copy];
    
    NSLog(@"||||||||||||||>     10");
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSLog(@"||||||||||||||>     10-1");
        
        [image croppedImageWithRect:rect];
        
        NSLog(@"||||||||||||||>     11");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSLog(@"||||||||||||||>     11-1");
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
            NSLog(@"||||||||||||||>     11-2");
            
        });
        
        NSLog(@"||||||||||||||>     12");
        
        
    });
    
    NSLog(@"||||||||||||||>     13");
    
    return image;
    
    /*
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    
    
    NSLog(@"||||||||||||||>     8");
    
    [imgView setImage:image];
    
    size_t width2 = cropSize.width;
    size_t height2 = cropSize.height;
    
    NSLog(@"||||||||||||||>     9");
    
    unsigned char *imageBuffer = (unsigned char *)malloc(width2*height2*4);
    
    NSLog(@"||||||||||||||>     10");
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    NSLog(@"||||||||||||||>     11");
    
    CGContextRef imageContext =
    CGBitmapContextCreate(imageBuffer, width2, height2, 8, width2*4, colourSpace,
                          kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    NSLog(@"||||||||||||||>     12");
    
    CGColorSpaceRelease(colourSpace);
    
    NSLog(@"||||||||||||||>     13");
    
    [imgView.layer renderInContext:imageContext];
    
    NSLog(@"||||||||||||||>     14");
    
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
    
    NSLog(@"||||||||||||||>     15");
    
    UIImage *imge = [[UIImage alloc] initWithCGImage:outputImage];
    
    NSLog(@"||||||||||||||>     16");
    
    CGImageRelease(outputImage);
    
    NSLog(@"||||||||||||||>     17");
    
    CGContextRelease(imageContext);
    
    NSLog(@"||||||||||||||>     18");
    
    free(imageBuffer);
    
    NSLog(@"||||||||||||||>     19");
    
    return imge;
    
    
    
    / *
    
    
    NSLog(@"||||||||||||||>     8-1");
    
    UIGraphicsBeginImageContext(imgView.frame.size);
    
    NSLog(@"||||||||||||||>     8-2");
    
    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //[image drawInRect:rect];
    

    NSLog(@"||||||||||||||>     9");
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
     
    
    NSLog(@"||||||||||||||>     10");
    
    UIGraphicsEndImageContext();
    
    NSLog(@"||||||||||||||>     11");
    * /
    //return newImage;
    */
    
    
    
}

- (void)callResizeImage:(UIImage*)rImage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)dismissAnimated:(BOOL)animated
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSDictionary *dismissDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"animated", animated, nil];
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(dismissAccordinglyAnimated) withObject:nil waitUntilDone:NO];
    } else {
        [self dismissAccordinglyAnimated];
    }
}

- (void)dismissAccordinglyAnimated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidCancelNewPhotoponComposition object:nil];
    
    /*
    BOOL animated = YES; //(BOOL)[sender objectForKey:@"animated"];
    
    if (self.popoverController) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self.popoverController) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.popoverController dismissPopoverAnimated:NO];
        
    }else if (self.showFromViewController){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            }else if (self.showFromViewController.presentedViewController){", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        //[appDelegate.navController dismissPhotoponPicker:self.mediaUI.view];
        
        
        
        / *
        [appDelegate.tabBarController presentSemiView:appDelegate.navController.photoponPickerPlaceholderScreenShot];
        
        [self.showFromViewController dismissViewControllerAnimated:NO completion:^{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.showFromViewController dismissViewControllerAnimated:NO completion:^{", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.tabBarController dismissSemiModalView];
            
            
            
            
        }];
        * /
        
    }
    */
}

- (void)dismissAndUploadAnimated:(BOOL)animated
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSDictionary *dismissDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"animated", animated, nil];
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(dismissAndUploadAccordinglyAnimated) withObject:nil waitUntilDone:NO];
    } else {
        [self dismissAndUploadAccordinglyAnimated];
    }
}

- (void)dismissAndUploadAccordinglyAnimated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BOOL animated = NO;//(BOOL)[sender objectForKey:@"animated"];
    
    
    if (self.showFromViewController) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (self.showFromViewController) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        
        
        
        //[appDelegate.navController dismissPhotoponPicker:self.mediaUI.view];
        
        [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] addUploadHeader];
        
        //[weakSelf dismissNewPhotoponPickerControllerAnimated:YES doUpload:YES];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerDidCancelNewPhotoponComposition object:nil];
        
        
        
        
        [[PhotoponMediaModel newPhotoponDraft] uploadWithSuccess:^{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            PhotoponMediaModel newPhotoponDraft] uploadWithSuccess:^{   SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] removeUploadHeaderReload:YES];
            
            [appDelegate.homeViewController showShareSheet];
            
            [PhotoponMediaModel clearNewPhotoponDraft];
            
            
        }failure:^(NSError*failure){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            PhotoponMediaModel newPhotoponDraft] uploadWithSuccess:^{      FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] uploadHeaderView] configureFailedView];
            [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] uploadHeaderView].photoponMediaPhotoUploadStatus.text = @"Failed";
            
            NSLog(@"=---------->        ERROR DESCRIPTION: %@", failure.description);
            
        }];
        
        
        /*
        
        
        
        [self.showFromViewController dismissSemiModalViewWithCompletion:^{
         
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self.showFromViewController dismissSemiModalViewWithCompletion:^{", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            
            [[PhotoponMediaModel newPhotoponDraft] uploadWithSuccess:^{
                
                
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            PhotoponMediaModel newPhotoponDraft] uploadWithSuccess:^{   SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] removeUploadHeaderReload:YES];
                
                [PhotoponMediaModel clearNewPhotoponDraft];
                
            }failure:^(NSError*failure){
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            PhotoponMediaModel newPhotoponDraft] uploadWithSuccess:^{      FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                [[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] uploadHeaderView] configureFailedView];
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                
                [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] uploadHeaderView].photoponMediaPhotoUploadStatus.text = @"Failed";
                
                //[[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] uploadHeaderView] setNeedsDisplay];
                
                //});
                
                NSLog(@"=---------->        ERROR DESCRIPTION: %@", failure.description);
                
                
                //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController] removeUploadHeaderReload:YES];
                
            }];
            
        }];
         */
        
    }
    else if (self.popoverController) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            else if (self.popoverController) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.popoverController dismissPopoverAnimated:animated];
    }
    
    
    
    
}

- (void)getLastPhotoTakenWithCompletionBlock:(void (^)(UIImage *))completionBlock
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (*stop == YES) {
            return;
        }
        
        group.assetsFilter = [ALAssetsFilter allPhotos];
        
        if ([group numberOfAssets] == 0) {
            completionBlock(nil);
        }
        else {
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *innerStop) {
                
                // `index` will be `NSNotFound` on last call
                
                if (index == NSNotFound || result == nil) {
                    return;
                }
                
                ALAssetRepresentation *representation = [result defaultRepresentation];
                completionBlock([UIImage imageWithCGImage:[representation fullScreenImage]]);
                
                *innerStop = YES;
            }];
        }
        
        *stop = YES;
        
    } failureBlock:^(NSError *error) {
        completionBlock(nil);
    }];
}

- (UIPopoverController *)makePopoverController:(UIImagePickerController *)mediaUI
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.popoverControllerClass) {
        return [[self.popoverControllerClass alloc] initWithContentViewController:mediaUI];
    }
    else {
        return [[UIPopoverController alloc] initWithContentViewController:mediaUI];
    }
}

- (void)observeApplicationDidBecomeActiveNotification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)observeApplicationDidEnterBackgroundNotification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)show
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    if ([[self class] canTakePhoto] == NO) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    */
    
    if ([[self class] canTakePhoto] == NO) {
        
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else {
        [self showImagePickerWithSourceType:self.sourceType];
    }

    /*
    else {
        void (^showActionSheetBlock)(UIImage *) = ^(UIImage *lastPhoto) {
            
            self.lastPhoto = lastPhoto;
            
            UIActionSheet *sheet;
            
            if (lastPhoto) {
                sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:[self buttonTitleForButtonIndex:PhotoPickerButtonUseLastPhoto], [self buttonTitleForButtonIndex:PhotoPickerButtonTakePhoto], [self buttonTitleForButtonIndex:PhotoPickerButtonChooseFromLibrary], nil];
            }
            else {
                sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:[self buttonTitleForButtonIndex:PhotoPickerButtonTakePhoto], [self buttonTitleForButtonIndex:PhotoPickerButtonChooseFromLibrary], nil];
            }
            
            if (self.showFromBarButtonItem) {
                [sheet showFromBarButtonItem:self.showFromBarButtonItem animated:YES];
            }
            else if (self.showFromTabBar) {
                [sheet showFromTabBar:self.showFromTabBar];
            }
            else {
                [sheet showFromRect:self.showFromRect inView:self.showFromViewController.view animated:YES];
            }
        };
        
        if (self.offerLastTaken) {
            [self getLastPhotoTakenWithCompletionBlock:showActionSheetBlock];
        }
        else {
            showActionSheetBlock(nil);
        }
    }*/
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.showFromBarButtonItem = barButtonItem;
    [self show];
}

- (void)showFromTabBar:(UITabBar *)tabBar
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.showFromTabBar = tabBar;
    [self show];
}

- (void)showFromRect:(CGRect)rect
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.showFromRect = rect;
    [self show];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.sourceType = sourceType;
    
    self.mediaUI.allowsEditing = self.allowsEditing;
    self.mediaUI.delegate = self;
    self.mediaUI.mediaTypes = @[ (NSString *)kUTTypeImage ];
    self.mediaUI.sourceType = sourceType;
    
    
    self.mediaUI.cameraOverlayView = nil;
    
    
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera && CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
        
        CGRect overlayFrame = self.mediaUI.view.frame;
        
        // have to move this here or causes crash when showing album
        [self.mediaUI setShowsCameraControls:NO];
        
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            if ([PhotoponUtility isTallScreen]) {
                overlayFrame.size.height -= 96;
            }
            else {
                overlayFrame.size.height -= 54;
            }
        }
    
    }
    
    if (IS_IPAD && (sourceType == UIImagePickerControllerSourceTypePhotoLibrary)) {
        
        if (![NSThread isMainThread]) {
            [self performSelectorOnMainThread:@selector(showPhotoponLibrary) withObject:nil waitUntilDone:NO];
        } else {
            [self showPhotoponLibrary];
        }
        
    }
    else {
        
        if (![NSThread isMainThread]) {
            [self performSelectorOnMainThread:@selector(showPhotoponCamera) withObject:nil waitUntilDone:NO];
        } else {
            [self showPhotoponCamera];
        }
        
    }
}


- (void)showPhotoponCamera{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //[self.showFromViewController addChildViewController:self.mediaUI];
    
    
    
    [self.showFromViewController.view addSubview:self.mediaUI.view];
    
    //[self.mediaUI didMoveToParentViewController:self.showFromViewController];
    
    
    
    //[self.showFromViewController presentViewController:self.mediaUI animated:NO completion:nil];
    
    
    
    //[self.showFromViewController.navigationController pushPhotoponPickerViewController:self.mediaUI];
    
    /*
    if (self.camScreenShotViewController){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@           if (self.camScreenShotViewController)", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
        //[self updatePhotoLibraryScreenShot];
        
    }else{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@           if (self.camScreenShotViewController) else{", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.showFromViewController presentViewController:self.mediaUI animated:YES completion:nil];
        
        
        
        
        
     
        / *
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.navController displayPhotoponPicker:self.mediaUI.view];
        
        [appDelegate.navController.photoponModalViewController addChildViewController:self.mediaUI];
        
        [appDelegate.navController addChildViewController:self.photoponNewPhotoponOverlayViewController];
        [appDelegate.navController.photoponModalViewController.view addSubview:self.photoponNewPhotoponOverlayViewController.view];
        
        / *
        [self.showFromViewController presentViewController:self.mediaUI animated:NO completion:^{
            
            
            //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
            //[appDelegate.navController fadeOutViewWithRemove:appDelegate.navController.photoponPickerPlaceholderScreenShot];
            
            
            
            //[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController] fadeOutViewWithRemove:[[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController].photoponPickerPlaceholderScreenShot]];
            
            
            
            
        }];
         * /
    }
        //[self.showFromViewController presentSemiViewController:self.mediaUI withOptions:nil completion:nil dismissBlock:nil];
    */
}

- (void)showPhotoponLibrary{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    self.photoponPlaceholderNewPhotoponOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoponPlaceholderNewPhotoponOverlay.png"]];
    [self.presentedViewController presentSemiView:self.photoponPlaceholderNewPhotoponOverlayImageView withOptions:nil completion:^{
    */
    
    
    if (IS_IPAD) {
        
        self.popoverController = [self makePopoverController:self.mediaUI];
        self.popoverController.delegate = self;
        
        if (self.showFromBarButtonItem) {
            [self.popoverController presentPopoverFromBarButtonItem:self.showFromBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else {
            [self.popoverController presentPopoverFromRect:self.showFromRect inView:self.showFromViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }else{
        
        //[self.showFromViewController.navigationController pushViewController:self.mediaUI animated:YES];
        
        //[self.showFromViewController.parentViewController presentViewController:self.mediaUI animated:<#(BOOL)#> completion:<#^(void)completion#>:self.mediaUI];
        
        [self.showFromViewController presentViewController:self.mediaUI animated:YES completion:nil];
        
        
        
        //[self.showFromViewController.navigationController presentViewController:self.mediaUI animated:YES completion:^{
            
            
        //}];
        
    }
    
    
    
    
    //[self updateCameraScreenShot];
    
    
    
    /*
    [self.showFromViewController presentViewController:self animated:NO completion:^{
        
        [self.mediaUI removeFromParentViewController];
        
        self.mediaUI.sourceType =
        
    }];
    
    
    
    
    
    //[self.showFromViewController.navigationController.presentedViewController.view addSubview:self.camScreenShot];
    
    //[self.showFromViewController dismissSemiModalView];
    
    */
        
        
}

- (void) updateCameraScreenShot{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    /*
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navController displayPhotoponPicker:self.mediaUI.view];
    */
    
    
    
    self.camScreenShotImg = [self.mediaUI.view screenshot];
    [self.camScreenShot setImage:self.camScreenShotImg];
    
    if (!self.camScreenShotViewController)
        self.camScreenShotViewController = [[UIViewController alloc] init];
    
    self.camScreenShotViewController.view = self.camScreenShot;
    
    [self.showFromViewController presentViewController:self.libScreenShotViewController animated:NO completion:^{
        
        
        [self.mediaUI.view removeFromSuperview];
        //[self.mediaUI removeFromParentViewController];
        [self.mediaUI setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if (self.libScreenShotViewController && self.libScreenShotViewController.view.window){
            [self.libScreenShotViewController.view removeFromSuperview];
            [self.libScreenShotViewController removeFromParentViewController];
            self.libScreenShotViewController = nil;
        }
        
        
        self.popoverController = [self makePopoverController:self.mediaUI];
        self.popoverController.delegate = self;
        
        if (self.showFromBarButtonItem) {
            [self.popoverController presentPopoverFromBarButtonItem:self.showFromBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else {
            [self.popoverController presentPopoverFromRect:self.showFromRect inView:self.showFromViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
        //[self.showFromViewController presentSemiViewController:self.mediaUI withOptions:nil completion:nil dismissBlock:nil];
        
    }];
    
}

- (void) updatePhotoLibraryScreenShot{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.libScreenShotImg = [self.mediaUI.view screenshot];
    [self.libScreenShot setImage:self.libScreenShotImg];
    
    if (!self.libScreenShotViewController)
        self.libScreenShotViewController = [[UIViewController alloc] init];
    
    self.libScreenShotViewController.view = self.libScreenShot;
    
    [self.showFromViewController presentViewController:self.libScreenShotViewController animated:NO completion:^{
        
        [self.mediaUI.view removeFromSuperview];
        [self.mediaUI removeFromParentViewController];
        [self.mediaUI setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if (self.camScreenShotViewController && self.camScreenShotViewController.view.window){
            [self.camScreenShotViewController.view removeFromSuperview];
            [self.camScreenShotViewController removeFromParentViewController];
            self.camScreenShotViewController = nil;
        }
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        self.completionBlock(nil, nil);
        return;
    }
    
    if (self.lastPhoto == nil) {
        buttonIndex++;
    }
    
    switch (buttonIndex) {
        case 0:
            self.completionBlock(nil, @{ UIImagePickerControllerOriginalImage : self.lastPhoto, UIImagePickerControllerEditedImage : self.lastPhoto });
            break;
            
        case 1:
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            return;
            
        case 2:
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIImage *image = info[(self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage)];
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera && self.saveToCameraRoll) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"--> 1");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"-------->       writing image... ");
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //});
    }
    
    // if they chose the photo, and didn't edit, push in a preview
    
    if (![picker isViewLoaded]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"--> 2");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        // If we get a memory warning on the way here our view could have unloaded.
        // In order to prevet a crash we'll make sure its loaded before
        // dismissing the modal.
        
        [picker view];
        
        //[self.blogSelector loadBlogsForType:BlogSelectorButtonTypeQuickPhoto];
        //self.blogSelector.delegate = self;
        
        /*
        // if the keyboard is showing we need to reset the height of the view as well.
        if (!CGRectEqualToRect(keyboardFrame, CGRectZero)) {
            CGRect frame = self.view.frame;
            frame.size.height = keyboardFrame.size.height;
            self.view.frame = frame;
        }
         */
    }
    
    
    if (self.mediaUI.sourceType != UIImagePickerControllerSourceTypeCamera) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"--> 3");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [[[PhotoponMediaModel newPhotoponDraft] photoponMediaImageFile] setRawImage:image];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  3-1");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [[PhotoponMediaModel newPhotoponDraft] cropMediaInBackgroundWithMediaSize:self.cropOverlaySize];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  3-2");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        //[self.popoverController dismissPopoverAnimated:animated];
        
        
        
        
        [self.photoponNewPhotoponOverlayViewController photoponDidChooseFromLibrary];
        
        if (![NSThread isMainThread]) {
            [self performSelectorOnMainThread:@selector(showPhotoponCamera) withObject:nil waitUntilDone:NO];
        } else {
            [self showPhotoponCamera];
        }
        
        
        
        //[self updatePhotoLibraryScreenShot];
        //[self.popoverController dismissPopoverAnimated:YES];
        //[self.mediaUI setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        
        
        
        
        
        
        
        
        
        /*
        
        //PhotoponNewPhotoponPreviewController *vc = [[PhotoponNewPhotoponPreviewController alloc] initWithImage:image cropOverlaySize:self.cropOverlaySize chooseBlock:^{
        
        CZPhotoPreviewViewController *vc = [[CZPhotoPreviewViewController alloc] initWithImage:image cropOverlaySize:self.cropOverlaySize chooseBlock:^{
            
            UIImage *chosenImage = image;
            
            if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
                chosenImage = [self cropImage:chosenImage];
            }
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            NSMutableDictionary *mutableImageInfo = [info mutableCopy];
            mutableImageInfo[UIImagePickerControllerEditedImage] = chosenImage;
            
            //self.completionBlock(picker, [mutableImageInfo copy]);
        
        } cancelBlock:^{
            [picker popViewControllerAnimated:YES];
        }];
        
        [picker pushViewController:vc animated:YES];
         */
    }
    else {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"--> 4");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
        //dispatch_async(dispatch_get_main_queue(), ^{
            /*
            NSMutableDictionary *mutableImageInfo = [info mutableCopy];
            
            if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
                mutableImageInfo[UIImagePickerControllerEditedImage] = [self cropImage:image];
            }
             */
        
        
        /*
        CZPhotoPreviewViewController *vc = [[CZPhotoPreviewViewController alloc] initWithImage:image cropOverlaySize:self.cropOverlaySize chooseBlock:^{
            
            UIImage *chosenImage = image;
            
            if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
                chosenImage = [self cropImage:chosenImage];
            }
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            NSMutableDictionary *mutableImageInfo = [info mutableCopy];
            mutableImageInfo[UIImagePickerControllerEditedImage] = chosenImage;
            
            //self.completionBlock(picker, [mutableImageInfo copy]);
            
        } cancelBlock:^{
            [picker popViewControllerAnimated:YES];
        }];
        
        [picker pushViewController:vc animated:YES];
        */
        
        
        
        
        
        [[[PhotoponMediaModel newPhotoponDraft] photoponMediaImageFile] setRawImage:image];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  4-1");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [[PhotoponMediaModel newPhotoponDraft] cropMediaInBackgroundWithMediaSize:self.cropOverlaySize];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  4-2");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.popoverController dismissPopoverAnimated:NO];
        
        
        
        
        
        
        
        
        
        /*
        
        //[self.photoponNewPhotoponOverlayViewController configureViewForModeDefault];
        
        [self.photoponNewPhotoponOverlayViewController performViewResetWithTimedAnimation];
        
        [self.mediaUI setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [[[PhotoponMediaModel newPhotoponDraft] photoponMediaImageFile] setRawImage:image];
        * /
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  4-1");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [[PhotoponMediaModel newPhotoponDraft] cropMediaInBackgroundWithMediaSize:self.cropOverlaySize];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  4-2");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.popoverController dismissPopoverAnimated:YES];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  4-3");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //self.completionBlock(picker, nil);
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-->  4-4");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //});
         */
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(showPhotoponCamera) withObject:nil waitUntilDone:NO];
    } else {
        [self showPhotoponCamera];
    }
    
    
    
    
    //self.completionBlock(nil, nil);
    
    /*
    
    [self updatePhotoLibraryScreenShot];
    
    [self.mediaUI setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self.photoponNewPhotoponOverlayViewController photoponDidCancelLibrary];
    
    [self.showFromViewController presentSemiViewController:self.mediaUI withOptions:nil completion:nil dismissBlock:nil];
    */
    
}


#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.popoverController = nil;
    
    //self.completionBlock(nil, nil);

}

/*
- (void)applicationBecomeActive {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (self.photoponNewPhotoponOverlayViewController)
        [self.photoponNewPhotoponOverlayViewController openShutter];

}
*/

@end
