//
//  PhotoponApplicationKey.h
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoponApplicationKey : NSObject
+(BOOL)isPhotoponFacebookUserKey:(NSString *)key;
+(BOOL)isPhotoponFileKey:(NSString *)key;
+(BOOL)isPhotoponUserKey:(NSString *)key;
+(BOOL)isPhotoponGeoPointKey:(NSString *)key;
+(BOOL)isPhotoponModelKey:(NSString *)key;
+(BOOL)isPhotoponMediaModelKey:(NSString *)key;
+(BOOL)isPhotoponActivityModelKey:(NSString *)key;
+(BOOL)isPhotoponCouponModelKey:(NSString *)key;
+(BOOL)isPhotoponCommentModelKey:(NSString *)key;
+(BOOL)isPhotoponTagModelKey:(NSString *)key;
+(NSString*)getPhotoponModelClassForKey:(NSString *)key;
@end
