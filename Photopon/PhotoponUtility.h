//
//  PhotoponUtility.h
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponUserModel.h"

@interface PhotoponUtility : NSObject
+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)processFacebookProfilePictureData:(UIImage *)image;

+ (void)cacheTimelineImageData:(NSData *)data mediaModel:(PhotoponMediaModel*)media;

+ (UIImage*)timelineImageFromImageCacheKey:(NSString*)imageCacheKey;

+ (BOOL)doesHaveCachedTimelineImage:(NSString*)imageCacheKey;

+ (BOOL)userHasValidFacebookData:(PhotoponUserModel *)user;
+ (BOOL)userHasProfilePictures:(PhotoponUserModel *)user;

+ (NSString *)firstNameForDisplayName:(NSString *)displayName;

+ (void)followUserInBackground:(PhotoponUserModel *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUserEventually:(PhotoponUserModel *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PhotoponUserModel *)user;
+ (void)unfollowUsersEventually:(NSArray *)users;

+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController;

+ (NSMutableURLRequest *)imageRequestWithURL:(NSURL *)url;

+ (NSString*)facebookLocalImageName;

+ (NSString*)facebookGraphBasePath;

+ (NSString*)facebookProfilePicLinkStr;

+ (NSURL*)facebookProfilePicLinkURL;

+ (UIImage*)currentUserFacebookProfilePic;

+ (UIImage*)currentUserFacebookProfilePicSmall;

+ (UIImage*)currentUserFacebookProfilePicMed;

+ (PhotoponQuery *)queryForActivitiesOnPhoto:(PhotoponModel *)photo cachePolicy:(PhotoponCachePolicy)cachePolicy;

+(NSString*)photoponDateTextWithString:(NSString*)dateString;

+ (NSString*)photoponDateStringWith8CouponsExpirationDateString:(NSString*)dateString;

+ (NSDate*)photopon8CouponsExpirationDateWithString:(NSString*)dateString;

+ (NSString*)photoponDateStringWith8CouponsDateString:(NSString*)dateString;

+ (NSDate*)photopon8CouponsDateWithString:(NSString*)dateString;

+ (NSDate*)photoponDateWithString:(NSString*)dateString;

+ (NSDateFormatter*)photoponDateFormatter;

+ (NSString*)appShareUrl;

+ (NSString*)appShareMessage;

+ (NSString*)deviceNibName:(NSString*)nibName;

+ (BOOL)isTallScreen;

+ (NSString*)deviceSuffix;

+ (void)shareText:(NSString *)string andImage:(UIImage *)image;

+ (UIFont *)photoponFontLightForBrand:(CGFloat)fontSize;

+ (UIFont *)photoponFontBoldForBrand:(CGFloat)fontSize;

+ (UIFont *)photoponFontBoldForOfferValue;

+ (UIFont *)photoponFontBoldForOfferTitle;

+ (UIFont *)photoponFontBoldForOfferPersonalCaption;

+ (UIFont *)photoponFontRegularForBrand:(CGFloat)fontSize;

+ (UIFont *)photoponFontRegularForOfferValue:(CGFloat)fontSize;

+ (UIFont *)photoponFontRegularForOfferTitle:(CGFloat)fontSize;

+ (void) formatBrandLabel:(UILabel*)brandLabel;


@end

