//
//  PhotoponImageModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoponModel;
@class PhotoponAppDelegate;


@interface PhotoponImageModel : PhotoponModel
{
    UIImage *image;
    NSData *binData;
    NSNumber *width;
    NSNumber *height;
    NSString* fullUrl;
    NSString* largeUrl;
    NSString* large2xUrl;
        
    PhotoponAppDelegate *appDelegate;
    
}

@property (nonatomic, strong) PhotoponAppDelegate *appDelegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *binData;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSString* fullUrl;
@property (nonatomic, strong) NSString* largeUrl;
@property (nonatomic, strong) NSString* large2xUrl;


//@property (nonatomic, retain) NSDictionary *options; //we can store an NSArray or an NSDictionary as a transformable attribute... 

- (id) init;
//- (void)setPhotoponImage:(UIImage *)aImage withSize:(MediaResize)size;
- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

@end
