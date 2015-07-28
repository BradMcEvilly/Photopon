//
//  PhotoponMediaModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "PhotoponModel.h"
#import "PhotoponModel+Subclass.h"
//#import "PhotoponCouponModel.h"
//#import "PhotoponUserModel.h"


//#import "PhotoponConstants.h"

typedef NS_ENUM(NSUInteger, MediaModelRemoteStatus) {
    MediaModelRemoteStatusPushing,    // Uploading post
    MediaModelRemoteStatusFailed,      // Upload failed
    MediaModelRemoteStatusLocal,       // Only local version
    MediaModelRemoteStatusSync,       // Post uploaded
    MediaModelRemoteStatusProcessing, // Intermediate status before uploading
};

/*

@class PhotoponCoordinateModel;
@class PhotoponUserModel;
@class PhotoponCouponModel;
@class PhotoponImageModel;
@class PhotoponAppDelegate;
@class AbstractPhotoponPost;
*/

//@class PhotoponModel;

@class PhotoponUserModel;
@class PhotoponCouponModel;
@class PhotoponGeoPointModel;
@class PhotoponAppDelegate;
@class PhotoponFile;
@class PhotoponUploadHeaderView;
@class PhotoponImageView;
@class PhotoponUIButton;

@interface PhotoponMediaModel : PhotoponModel

@property (nonatomic) BOOL didLikeBool;
@property (nonatomic) BOOL didSnipBool;

// Public properties
@property (readonly) NSString* identifier;
@property (readonly) PhotoponGeoPointModel * coordinate;
@property (readonly) NSString* value;
@property (readonly) NSString *cost;

@property (readonly) NSNumber* monetaryValue;
@property (readonly) NSNumber* socialValue;
@property (readonly) NSString* caption;
@property (readonly) NSString* linkURL;
@property (readonly) NSUInteger likeCount;
@property (readonly) NSUInteger commentCount;
@property (readonly) NSUInteger snipCount;
@property (readonly) PhotoponUserModel* user;
@property (readonly) PhotoponCouponModel* coupon;

//@property (readonly) PhotoponPlace* place;
//@property (readonly) PhotoponCouponModel* coupon;
//@property (readonly) PhotoponImageModel* image;

@property (readonly) NSString* couponId;
//@property (nonatomic,strong) PhotoponImageModel* image;

@property (readonly) NSString* thumbURL;
@property (readonly) NSString* imageMidURL;
@property (readonly) NSString* imageLargeURL;
@property (readonly) NSString* locationIdentifier;
@property (readonly) NSString* locationLatitude;
@property (readonly) NSString* locationLongitude;
@property (readonly) NSDate* createdTime;
@property (readonly) NSDictionary* users;
@property (readonly) NSDictionary* tags;

@property (nonatomic, strong) NSString * screenshotLocalURL;

@property (nonatomic) MediaModelRemoteStatus remoteStatus;
@property (nonatomic, strong) NSNumber * remoteStatusNumber;
@property (nonatomic, strong) PhotoponFile *photoponMediaImageFile;

@property (nonatomic, readonly) PhotoponAppDelegate *appDelegate;
@property (nonatomic, assign) PhotoponUploadHeaderView *photoponUploadHeaderView;
@property (nonatomic, assign) PhotoponImageView *photoponCroppedImageView;

@property (nonatomic, strong) NSNumber *didLike;
@property (nonatomic, strong) NSNumber *didSnip;

@property (nonatomic) float progress;

# pragma - Public methods

/**
 Creates a populated media model
 */
+ (PhotoponMediaModel*)modelWithDictionary:(NSDictionary*)dict;

/**
 Creates an empty local media model
 */
+ (PhotoponMediaModel *)newPhotoponDraft;

+ (PhotoponMediaModel *)modelFromCache;

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts;

+ (NSString *)titleForRemoteStatus:(NSNumber *)remoteStatus;

+ (NSString*)messageForNewPhotoponDraftCancel;

+ (void)setNewPhotoponDraft:(PhotoponMediaModel *)mediaModel;

+ (void)cancelNewPhotoponDraft;

+ (void)clearNewPhotoponDraft;

+ (void)getUserMediaWithId:(NSString*)userId withAccessToken:(NSString *)accessToken block:(void (^)(NSArray *records))block;

+ (void)getInstagramUserMediaWithId:(NSString*)userId withAccessToken:(NSString *)accessToken block:(void (^)(NSArray *records))block;

- (void)takeScreenshot:(UIView*)targetView;

# pragma - Instance methods

- (UIImage *)thumbNailImage;

- (void) convert8CouponsDictToCoupons:(NSMutableDictionary*)dict8Coupons;

- (UIImage *)rawImage;

- (void)cancelUpload;

- (void) cacheMediaAttributes;

- (void)uploadPhotoponMediaModel;

- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

- (void)cropMediaInBackgroundWithMediaSize:(CGSize)targetSize;

- (UIImage *)croppedImage;

- (void) userDidLike:(PhotoponUIButton *)button;

- (void) userDidUnlike:(PhotoponUIButton *)button;

- (void) userDidSnip:(PhotoponUIButton *)button;

- (void) userDidUnsnip:(PhotoponUIButton *)button;

@end
