//
//  PhotoponNewCompositionViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/18/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewCompositionViewController.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "PhotoponNewCompositionPreviewViewController.h"
#import "PhotoponTabBarController.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponConstants.h"

@interface PhotoponNewCompositionViewController ()
@property(nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@property(nonatomic,copy) PhotoponNewCompositionViewControllerCompletionBlock completionBlock;
@property(nonatomic,strong) UIImage *lastPhoto;
@property(nonatomic,weak) UIBarButtonItem *showFromBarButtonItem;
@property(nonatomic,assign) CGRect showFromRect;
@property(nonatomic,weak) UITabBar *showFromTabBar;
@property(nonatomic,weak) UIViewController *showFromViewController;
@property (assign) SystemSoundID tickSound;
@property (nonatomic, strong) NSArray *libPhotos;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@end

@implementation PhotoponNewCompositionViewController

@synthesize photoponToolBarView;
@synthesize photoponBtnLibrary;
@synthesize saveToCameraRoll;
@synthesize sourceType;
@synthesize cropOverlaySize;
@synthesize popoverController;
@synthesize mediaUI;
@synthesize photoponBtnCamera;
@synthesize photoponBtnCancel;
@synthesize photoponCropView;
@synthesize croppedImage;
@synthesize mutableImageInfo;

#pragma mark - Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
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

- (IBAction)takePicture:(id)sender
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    self.allowsEditing = NO;
    self.saveToCameraRoll = YES;
    [self observeApplicationDidEnterBackgroundNotification];
    
    self.cropOverlaySize = CGSizeMake(320, 320);
    
    [self.photoponBtnLibrary removeFromSuperview];
    //[self.photoponToolBar removeFromSuperview];
    
    self.imageView.clipsToBounds = YES;
    
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.cornerRadius = 5.0;
    
    self.mediaUI = [[UIImagePickerController alloc] init];
    
    /*
    [self.photoponToolBar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundToolBar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake( 160-44.5f, 5.0f, 89.0f, 34);
    [cameraButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCameraFull.png"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCameraFull.png"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(doTakePicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoponToolBar addSubview:cameraButton];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake( 7.0f, 12.0f, 28.0f, 23.0f);
    [cancelButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCancel.png"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCancel.png"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(didCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoponToolBar addSubview:cancelButton];
    */
    
    //[self.photoponBtnLibrary setFrame:CGRectMake( 276.0f, 3.0f, 37.0f, 37.0f)];
    //[self.photoponToolBar addSubview:self.photoponBtnLibrary];
    
    /*
    // library button
    UIButton *libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    libraryButton.frame = CGRectMake( 5.0f, 10.0f, 28.0f, 23.0f);
    [libraryButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCancel.png"] forState:UIControlStateNormal];
    [libraryButton setImage:[UIImage imageNamed:@"PhotoponButtonNewPhotoponCancel.png"] forState:UIControlStateHighlighted];
    [libraryButton addTarget:self action:@selector(photoponBtnLibraryHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoponToolBar addSubview:libraryButton];
    */
    
    self.photoponBtnLibrary.imageView.layer.cornerRadius = 2.0f;
    
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    ALAssetsLibrary *al = [PhotoponNewCompositionViewController defaultAssetsLibrary];
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
            usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                
                [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                    if (asset) {
                        [collector addObject:asset];
                    }
                }];
                self.libPhotos = collector;
                
                ALAsset *asset = [self.libPhotos objectAtIndex:[self.libPhotos count]-1];
                [self.photoponBtnLibrary setImage:[UIImage imageWithCGImage:[asset thumbnail]] forState:UIControlStateNormal];
         }
                    failureBlock:^(NSError *error) {
                        NSLog(@"Boom!!!");
                    }];
    [self.photoponBtnLibrary setFrame:CGRectMake(276.0f, 5.0f, 34.0f, 34.0f)];
    [self.photoponToolBarView addSubview:self.photoponBtnLibrary];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self show];
    
}

-(IBAction)photoponBtnLibraryHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

#pragma mark -
#pragma mark Toolbar Actions

- (IBAction)didTakePicture:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.mediaUI takePicture];
    
}

- (IBAction)didCancel:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self dismissAnimated:NO];
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    
    [appDelegate.tabBarController doDismissViewController];
    
    
}




//////////////////////////////////
// NEW ///////////////////////////
//////////////////////////////////

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

#pragma mark - Lifecycle

- (void)dealloc
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (id)initWithPresentingViewController:(UIViewController *)aViewController withCompletionBlock:(PhotoponNewCompositionViewControllerCompletionBlock)completionBlock;
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    
    if (self) {
        self.completionBlock = completionBlock;
        self.offerLastTaken = YES;
        self.saveToCameraRoll = YES;
        self.showFromViewController = aViewController;
        [self observeApplicationDidEnterBackgroundNotification];
    }
    
    return self;
}

#pragma mark - Methods

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    
    if (self.completionBlock) {
        self.completionBlock(nil, nil);
    }
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

- (void)cropImage:(UIImage *)image
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    CGFloat resizeScale = (image.size.width / self.photoponCropView.frame.size.width);
    
    NSLog(@"||||||||||||||>     1");
    
    CGSize size = image.size;
    CGSize cropSize = CGSizeMake(self.photoponCropView.frame.size.width * resizeScale, self.photoponCropView.frame.size.height * resizeScale);
    
    CGFloat scalex = cropSize.width / size.width;
    CGFloat scaley = cropSize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    NSLog(@"||||||||||||||>     2");
    
    UIGraphicsBeginImageContext(cropSize);
    
    NSLog(@"||||||||||||||>     3");
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    CGFloat originX = ((cropSize.width - width) / 2.0f);
    CGFloat originY = ((cropSize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(originX, originY, size.width * scale, size.height * scale);
    
    NSLog(@"||||||||||||||>     4");
    
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"||||||||||||||>     5");
        
        [image drawInRect:rect];
        
        NSLog(@"||||||||||||||>     5-1");
       
        self.croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSLog(@"||||||||||||||>     6");
        
        UIGraphicsEndImageContext();
        
        
        NSLog(@"||||||||||||||>     7");
        
        //self.mutableImageInfo[UIImagePickerControllerEditedImage] = self.croppedImage;
        
        UIImageWriteToSavedPhotosAlbum(self.croppedImage, nil, nil, nil);
        
        
        NSLog(@"||||||||||||||>     8");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationDidCropImage
                                                            object:self
                                                          userInfo:nil];
        
        
        NSLog(@"||||||||||||||>     9");
    
    //});
    
    
    
    NSLog(@"||||||||||||||>     10");
    
    
    //return newImage;
    
    
    
    
    
    
    
    
    
    
    
    
    //CGFloat resizeScale = (image.size.width / self.cropOverlaySize.width);
    
    /*
    CGSize size = image.size;
    CGSize cropSize = CGSizeMake(crop, self.cropOverlaySize.height);
    
    
    NSLog(@"||||||||||||||>     2");
    
    //CGFloat scalex = cropSize.width / size.width;
    //CGFloat scaley = cropSize.height / size.height;
    
    CGFloat scale = 0.0f; //MAX(scalex, scaley);
    
    
    NSLog(@"||||||||||||||>     3");
    
    UIGraphicsBeginImageContext(cropSize);
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    
    
    NSLog(@"||||||||||||||>     4");
    
    CGFloat originX = ((cropSize.width - width) / 2.0f);
    CGFloat originY = ((cropSize.height - height) / 2.0f);
    
    
    NSLog(@"||||||||||||||>     5");
    */
    //CGRect rect = CGRectMake(self.photoponCropView.frame.origin.x, self.photoponCropView.frame.origin.y, self.photoponCropView.frame.size.width, self.photoponCropView.frame.size.height);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    UIGraphicsBeginImageContext(self.photoponCropView.frame.size);
    
    NSLog(@"||||||||||||||>     1");
    
    [image drawInRect: self.photoponCropView.frame];
    
    NSLog(@"||||||||||||||>     2");
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSLog(@"||||||||||||||>     3");
    
    UIGraphicsEndImageContext();
    
    
    NSLog(@"||||||||||||||>     4");
    
    return newImage;
     */
}

- (void)dismissAnimated:(BOOL)animated
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.showFromViewController.presentedViewController) {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
    else if (self.popoverController) {
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
    
    if ([[self class] canTakePhoto] == NO) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
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
    
    mediaUI.allowsEditing = self.allowsEditing;
    mediaUI.delegate = self;
    mediaUI.mediaTypes = @[ (NSString *)kUTTypeImage ];
    mediaUI.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera && CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
        CGRect overlayFrame = mediaUI.view.frame;
        
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            if (CGRectGetHeight(UIScreen.mainScreen.bounds) > 480) {
                overlayFrame.size.height -= 96;
            }
            else {
                overlayFrame.size.height -= 54;
            }
        }
        
        //self.overlayView = [[CZCropPreviewOverlayView alloc] initWithFrame:overlayFrame cropOverlaySize:self.cropOverlaySize];
        //[self.overlayView removeFromSuperview];
        [self.overlayView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
        
        // `cameraOverlayView` docs say this is nil by default, but in practice it's non-nil.
        // Adding as a subview keeps pinch-to-zoom on the camera. Setting the property
        // loses pinch-to-zoom. Handling nil here just to be safe.
        
        [self.mediaUI setShowsCameraControls:NO];
        
        if (mediaUI.cameraOverlayView) {
            mediaUI.cameraOverlayView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
            [mediaUI.cameraOverlayView addSubview:self.overlayView];
            
            //[mediaUI.toolbar addSubview:self.photoponToolBar];
        }
        else {
            mediaUI.cameraOverlayView = self.overlayView;
            //[mediaUI.view addSubview:self.photoponToolBar];
            //mediaUI.toolbar ;
            
            //[mediaUI.view bringSubviewToFront:self.photoponToolBar];
            
        }
    }
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) && (sourceType == UIImagePickerControllerSourceTypePhotoLibrary)) {
        self.popoverController = [self makePopoverController:mediaUI];
        self.popoverController.delegate = self;
        
        if (self.showFromBarButtonItem) {
            [self.popoverController presentPopoverFromBarButtonItem:self.showFromBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else {
            [self.popoverController presentPopoverFromRect:self.showFromRect inView:self.showFromViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else {
        [self presentViewController:self.mediaUI animated:YES completion:^{
            //[self.mediaUI.toolbar setBackgroundImage:[UIImage imageNamed:@"PhotoponBackgroundToolBar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
        }];
    }

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCropImageHandler:) name:PhotoponNotificationDidCropImage object:self];
    
    UIImage *image = info[(self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage)];
    
    [self.photoponCropView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera && self.saveToCameraRoll) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    // if they chose the photo, and didn't edit, push in a preview
    
    if (self.allowsEditing == NO && self.sourceType != UIImagePickerControllerSourceTypeCamera) {
        PhotoponNewCompositionPreviewViewController *vc = [[PhotoponNewCompositionPreviewViewController alloc] initWithImage:image cropOverlaySize:self.cropOverlaySize tagBlock:nil nextBlock:^{
            
            /*
            UIImage *chosenImage = image;
            
            if (CGSizeEqualToSize(self.cropOverlaySize, CGSizeZero) == NO) {
                chosenImage = [self cropImage:chosenImage];
                
            }
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            NSMutableDictionary *mutableImageInfo = [info mutableCopy];
            mutableImageInfo[UIImagePickerControllerEditedImage] = chosenImage;
            
            self.completionBlock(picker, [mutableImageInfo copy]);
             */
            
        } cancelBlock:^{
            
            [picker popViewControllerAnimated:YES];
        
        }];
        
        [picker pushViewController:vc animated:YES];
    }
    else {
        
        self.mutableImageInfo = [info mutableCopy];
        
        // custom photopon storyboard sequence next step here
        
        NSLog(@"-------->       A");
        
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSLog(@"-------->       B");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        
            [self cropImage:image];
            
            NSLog(@"-------->       C");
            
        });
        
        //});
            
        NSLog(@"-------->       D");
        
            
            
            
           
            
        /*
        if (CGSizeEqualToSize(self.photoponCropView.frame.size, CGSizeZero) == NO) {
            mutableImageInfo[UIImagePickerControllerEditedImage] = [self cropImage:image];
        }
        
        
        [self.popoverController dismissPopoverAnimated:YES];
        
        
        
        // custom photopon storyboard sequence next step here
        UIImage *imageb = mutableImageInfo[UIImagePickerControllerEditedImage];
        if (!imageb) {
            
            imageb = mutableImageInfo[UIImagePickerControllerOriginalImage];
        
        }
        
        //[self.imageView setImage:image];
        
        NSLog(@"Do something...");
        
        UIImageWriteToSavedPhotosAlbum(imageb, nil, nil, nil);
        */
        
        
        /*
        PhotoponNewCompositionPreviewViewController *vc = [[PhotoponNewCompositionPreviewViewController alloc] initWithImage:image cropOverlaySize:self.photoponCropView.frame.size tagBlock:nil nextBlock:^{
            UIImage *chosenImage = image;
            
            if (CGSizeEqualToSize(self.photoponCropView.frame.size, CGSizeZero) == NO) {
                chosenImage = [self cropImage:chosenImage];
            }
            
            [self.popoverController dismissPopoverAnimated:YES];
            
            NSMutableDictionary *mutableImageInfo = [info mutableCopy];
            mutableImageInfo[UIImagePickerControllerEditedImage] = chosenImage;
            
            self.completionBlock(picker, [mutableImageInfo copy]);
        } cancelBlock:^{
            [picker popViewControllerAnimated:YES];
        }];
        
        [picker pushViewController:vc animated:YES];
        */
        
        
        //self.completionBlock(picker, mutableImageInfo);
    
    }
    
}

- (void)didCropImageHandler:(NSNotification *)notification {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"-------->       a");
    
    //[self.popoverController dismissPopoverAnimated:YES];
    
    NSLog(@"-------->       b");
    
    /*
    UIImage *imageb = mutableImageInfo[UIImagePickerControllerEditedImage];
    
    
    NSLog(@"-------->       c");
    
    
    if (!imageb) {
        
        
        NSLog(@"-------->       d");
        
        //imageb = mutableImageInfo[UIImagePickerControllerOriginalImage];
        
        
        NSLog(@"-------->       e");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSLog(@"-------->       B");
            
            UIImageWriteToSavedPhotosAlbum(self.croppedImage, nil, nil, nil);
            
            NSLog(@"-------->       C");
            
            
        });
        
        NSLog(@"-------->       f");
    }
    
    */
    
    NSLog(@"-------->       g");
}

- (IBAction)didSwitchToRear:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView transitionWithView:mediaUI.view duration:1.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        mediaUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    } completion:NULL];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    // Here is were I make the camera preview fit the entire screen.
    // This might violate the "don't change the view hierarchy"-rule.
    // So I am not sure if it is valid for App Store commitment.
    // However, the NSLogs are used to
    // figure out which subview is the actual Camera Preview which turns out
    // to be the PLPreviewView. (uncomment to se the printouts).
    // Change it's size to fit the entire screen (and scale it accordingly
    // to avoid distorted image
    
    NSLog(@"WillShowViewController called...");
    
    NSLog(@"VC:view:subviews\n %@\n\n", [[viewController view] subviews]);
    
    NSLog(@"VC:view:PLCameraView:subviews\n %@\n\n", [[[[viewController view] subviews] objectAtIndex: 0] subviews]);
    
    NSLog(@"VC:view:PLCameraView:PLPreviewView:subviews\n %@\n\n", [[[[[[viewController view] subviews] objectAtIndex: 0] subviews] objectAtIndex: 0] subviews]);
    //NSLog(@"VC:view:PLCameraView:PLCropOverLay:subviews\n %@\n\n", [[[[[[viewController view] subviews] objectAtIndex: 0] subviews] objectAtIndex: 1] subviews]);
    //NSLog(@"VC:view:PLCameraView:UIImageView:subviews\n %@\n\n", [[[[[[viewController view] subviews] objectAtIndex: 0] subviews] objectAtIndex: 2] subviews]);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.completionBlock(nil, nil);
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.popoverController = nil;
    self.completionBlock(nil, nil);
}

@end