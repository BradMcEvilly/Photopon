//
//  PhotoponFile.h
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponModelManager.h"
#import "PhotoponMediaModel.h"

@class PhotoponUploadHeaderView;

typedef NS_ENUM(NSUInteger, FileRemoteStatus) {
    FileRemoteStatusPushing,    // Uploading post
    FileRemoteStatusFailed,      // Upload failed
    FileRemoteStatusLocal,       // Only local version
    FileRemoteStatusSync,       // Post uploaded
    FileRemoteStatusProcessing, // Intermediate status before uploading
};

@interface PhotoponFile : NSObject
{
}

@property (nonatomic, strong) NSNumber * mediaID;
@property (nonatomic, strong) NSString * mediaType;
@property (weak, nonatomic, readonly) NSString * mediaTypeName;
@property (nonatomic, strong) NSString * remoteURL;
@property (nonatomic, strong) NSString * localURL;
@property (nonatomic, strong) NSString * localURLRaw;
@property (nonatomic, strong) NSString * shortcode;
@property (nonatomic, strong) NSNumber * length;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSData * thumbnail;
@property (nonatomic, strong) NSString * filename;
@property (nonatomic, strong) NSString * filenameRaw;
@property (nonatomic, strong) NSNumber * filesize;
@property (nonatomic, strong) NSNumber * width;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSString * orientation;
@property (nonatomic, strong) NSDate * creationDate;
@property (weak, nonatomic, readonly) NSString * html;
@property (nonatomic, strong) NSNumber * remoteStatusNumber;
@property (nonatomic) FileRemoteStatus remoteStatus;
@property (nonatomic) float progress;
@property (nonatomic, assign) PhotoponUploadHeaderView *photoponUploadHeaderView;

@property (readonly) PhotoponModelManager * pmm;
@property (nonatomic, strong) NSMutableSet * posts;

+ (PhotoponFile *)initNewPhotoponFile;
- (void)cancelUpload;
- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)remove;
- (void)save;
//- (void)setImage:(UIImage *)image withSize:(MediaResize)size;

- (void)setImage:(UIImage *)image withSize:(CGSize)imageSize;

- (void)setImage:(UIImage *)image withRect:(CGRect)rect;

- (void)setRawImage:(UIImage *)image ;

@end



