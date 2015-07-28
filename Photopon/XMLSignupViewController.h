//
//  XMLSignupViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 7/17/12.
//  Copyright 2012 Photopon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponParser.h"
#import "PhotoponModel.h"
#import "UITableViewActivityCell.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponTableSectionFooterView.h"
#import "PhotoponConstants.h"
#import "PhotoponFile.h"
/////////////





#import <Foundation/Foundation.h>
#import "PhotoponUIButton+AFNetworking.h"
#import "PhotoponMediaModel.h"
#import "PhotoponComApi.h"
//#import "PhotoponMediaDataSource.h"
//#import "PhotoponTableViewDataSource.h"
#import "PhotoponUITableViewCell.h"

#import "PhotoponBaseUIViewController.h"

//#import "PhotoponFeedItemTableViewCellController.h"

/*@class PhotoponFeedItemsTableViewController;
@class PhotoponFeedItemTableViewCellController;
@class PhotoponUITableViewCell;
@class PhotoponUIButton;
@class PhotoponMediaModel;
@class PhotoponTabBarViewController;
@class PhotoponAppDelegate;
 */

@class PhotoponComApi;
@class PhotoponWebViewController;
@class PhotoponUIButton;
@class QuickPhotoUploadProgressController;
@class QuickPicturePreviewView;
@class PhotoponGalleryMedia;

@interface XMLSignupViewController : PhotoponBaseUIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIPickerViewDelegate, UIPopoverControllerDelegate> {
    
    PhotoponAppDelegate *appDelegate;
    
    //PhotoponTableSectionFooterView *footerView;
    
    
    //UIImagePickerController *picker;
    
    NSString *buttonText, *footerText, *email, *username, *firstname, *lastname, *facebookid, *birthday, *sex, *password, *passwordconfirm;
    
    UITableView *tableView;
    UITextField *lastTextField;
    
    IBOutlet UIButton *back;
    
    PhotoponComApi *pComApi;
    
    PhotoponWebViewController *photoponWebViewController;
    
    
    
    UIImage *currentImage;
    NSDictionary *currentImageMetadata;
    NSMutableDictionary *currentVideo;
    UIImagePickerController *picker;
    
    
    
    BOOL hasPhotos, hasVideos, isAddingMedia, isShowingMediaPickerActionSheet, isShowingChangeOrientationActionSheet, isShowingCustomSizeAlert;
	BOOL isLibraryMedia, didChangeOrientationDuringRecord, isShowingResizeActionSheet;
	
	NSMutableArray *photos, *videos;
	
    // upload related stuff
    NSNumber * mediaID;
    NSString * mediaType;
    NSString * mediaTypeName;
    NSString * remoteURL;
    NSString * localURL;
    NSString * shortcode;
    NSData * thumbnail;
    NSString * filename;
    NSString * filebase;
    NSNumber * filesize;
    NSString * orientation;
    NSDate * creationDate;
    NSString * html;
    NSNumber * remoteStatusNumber;
    NSNumber * width;
    NSNumber * height;
    UIImage *photo;
    NSData *binData;
    
    
    
    
    
    
    // upload related stuff
    
    IBOutlet PhotoponUIButton *photoponBtnProfilePhoto;
    
    
    /*
     UIActionSheet *sheet;
     
     UIImage *photoponBtnProfilePhotoImage;
     
     QuickPhotoUploadProgressController *uploadController;
     
     NSNumber * mediaID;
     NSString * mediaType;
     NSString * mediaTypeName;
     NSString * remoteURL;
     NSString * localURL;
     NSString * shortcode;
     NSData * thumbnail;
     NSString * filename;
     NSString * filebase;
     NSNumber * filesize;
     NSString * orientation;
     NSDate * creationDate;
     NSString * html;
     NSNumber * remoteStatusNumber;
     NSNumber * width;
     NSNumber * height;
     NSData *binData;
     UIImage *photo;
     UIImage *currentImage;
     
     */
    
    
    UIImagePickerController *mediaPicker;
    
    UIImagePickerController *photoPicker;
    QuickPhotoUploadProgressController *uploadController;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    UIViewController *pickerContainer;
    
    IBOutlet UITableView *table;
    
    IBOutlet UIBarButtonItem *addMediaButton;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UILabel *messageLabel;
    IBOutlet UIToolbar *bottomToolbar;
    
    UIPopoverController *addPopover;
    
    
    
    
    
    //PhotoponProgressHUD *progressAlert;
    
    
    
    IBOutlet PhotoponUIButton *profilePhoto;
    
    //IBOutlet PhotoponUIButton *save;
    
    
    IBOutlet UITextField *firstNameTextField;
    
    IBOutlet UITextField *lastNameTextField;
    
    IBOutlet UITextField *emailTextField;
    
    IBOutlet UITextField *passwordTextField;
    
    IBOutlet UIScrollView *scrollView;
    
    //IBOutlet UIView *formView;
    
    IBOutlet UILabel *titleLabel;
    
    
    NSString *firstName;
    NSString *lastName;
    UIImage *profilePhotoImage;
    
    
    CGRect startingFrame;
    
    NSMutableArray *assets;
    
    BOOL isTransitioning;
    NSFetchedResultsController *resultsController;
    
    UILabel *uploadLabel;
    
    
    
    PhotoponModelRemoteStatus remoteStatus;
    
    PhotoponTabBarController *photoponTabBarViewController_;
    

}
@property (nonatomic, unsafe_unretained) BOOL hasPhotos, hasVideos, isAddingMedia, isShowingMediaPickerActionSheet, isShowingChangeOrientationActionSheet, isShowingCustomSizeAlert;

@property (nonatomic,strong) UIImagePickerController *photoPicker;

@property (nonatomic, strong) PhotoponComApi *pComApi;

@property(nonatomic,strong) IBOutlet PhotoponUIButton *profilePhoto;

@property(nonatomic,strong) UIImagePickerController *mediaPicker;

@property(nonatomic,strong) PhotoponTableSectionFooterView *footerView;



@property (nonatomic,strong) PhotoponGalleryMedia *media;

@property (nonatomic,strong) PhotoponTabBarController *photoponTabBarViewController;

@property (nonatomic, strong) NSString *specialType;

@property (nonatomic, strong) UIViewController *pickerContainer;


@property (nonatomic, strong) NSString * content;

@property (nonatomic, strong) NSNumber * postID;

@property (nonatomic, strong) NSNumber * width;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSData *binData;

@property (nonatomic, strong) NSNumber * mediaID;
@property (nonatomic, strong) NSString * mediaType;
@property (nonatomic, strong) NSString * mediaTypeName;
@property (nonatomic, strong) NSString * remoteURL;
@property (nonatomic, strong) NSString * localURL;
@property (nonatomic, strong) NSString * shortcode;
@property (nonatomic, strong) NSData * thumbnail;
@property (nonatomic, strong) NSString * filename;
@property (nonatomic, strong) NSString * filebase;
@property (nonatomic, strong) NSNumber * filesize;
@property (nonatomic, strong) NSString * orientation;
@property (nonatomic, strong) NSDate * creationDate;
@property (nonatomic, strong) NSString * html;
@property (nonatomic, strong) NSNumber * remoteStatusNumber;
@property (nonatomic) PhotoponModelRemoteStatus remoteStatus;
@property (nonatomic) float progress;




@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
//////////////////////////////////////////
//////////////////////////////////////////
//////////////////////////////////////////
//////////////////////////////////////////
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) NSDictionary *currentImageMetadata;
@property (nonatomic, strong) NSMutableDictionary *currentVideo;
@property (nonatomic, strong) UIImagePickerController *picker;












/*
@property (nonatomic, retain) NSString * content;

@property (nonatomic, retain) NSNumber * postID;

@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSData *binData;

@property (nonatomic, retain) NSNumber * mediaID;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * mediaTypeName;
@property (nonatomic, retain) NSString * remoteURL;
@property (nonatomic, retain) NSString * localURL;
@property (nonatomic, retain) NSString * shortcode;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * filebase;
@property (nonatomic, retain) NSNumber * filesize;
@property (nonatomic, retain) NSString * orientation;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * html;
@property (nonatomic, retain) NSNumber * remoteStatusNumber;
@property (nonatomic) PhotoponGalleryMediaRemoteStatus remoteStatus;
 */
@property (nonatomic) float lastProgress;
//@property (nonatomic) float progress;

// >??????????????????????????
@property (nonatomic, retain) IBOutlet QuickPicturePreviewView *photoImageView;
//@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
@property (nonatomic, retain) UIImage *photo;










//@property (nonatomic, strong) UIImage *currentImage;

@property (nonatomic, retain) UIImage *photoponBtnProfilePhotoImage;

@property (nonatomic, retain) IBOutlet PhotoponUIButton *photoponBtnProfilePhoto;

@property (nonatomic, retain) PhotoponWebViewController *photoponWebViewController;

@property (nonatomic, retain) NSString *buttonText, *footerText, *email, *username, *firstname, *lastname, *facebookid, *birthday, *sex, *password, *passwordconfirm;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UITextField *lastTextField;

@property (nonatomic, retain) IBOutlet UIButton *back;

//@property (nonatomic, retain) PhotoponComApi *pComApi;

-(id)initWithFBProfileData;


- (IBAction)backHandler:(id)sender;

- (IBAction)photoponBtnProfilePhotoHandler:(id)sender;

- (void)fadeInView;

- (void)fadeOutView;

- (void)pickPhotoFromCamera:(id)sender;

- (void)pickPhotoFromPhotoLibrary:(id)sender;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

//- (UIImage *)resizeImage:(UIImage *)original toSize:(MediaResize)resize;

- (UIImage *)resizeImage:(UIImage *)original width:(CGFloat)width height:(CGFloat)height;

-(void)removeWebViewController;

- (void)uploadMediaWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;








-(void) showCam;
-(void) hideCam;

//-(void) showLiveCameraView;
//-(void) hideLiveCameraView;

-(void) showCameraLibraryView;
-(void) hideCameraLibraryView;

- (void)uploadMediaWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
//- (void)postPhotoponWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
//- (void)uploadMediaWithSuccess;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (UIImage *)fixImageOrientation:(UIImage *)img;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;





- (void)scaleAndRotateImage:(UIImage *)image;
- (IBAction)showPhotoPickerActionSheet:(id)sender;

- (void)post;
- (void)cancel;
- (void)saveImage;
//-(PhotoponTabBarViewController *)photoponTabBarViewController;
-(void)photoponSnapPhotoHandler;
-(void)photoponDidWriteToSavedPhotosAlbum:(id)sender;

-(void) showCam;
-(void) hideCam;

//-(void) showLiveCameraView;
//-(void) hideLiveCameraView;

-(void) showCameraLibraryView;
-(void) hideCameraLibraryView;

- (void)uploadMediaWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
//- (void)postPhotoponWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
//- (void)uploadMediaWithSuccess;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (UIImage *)fixImageOrientation:(UIImage *)img;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;





@end
