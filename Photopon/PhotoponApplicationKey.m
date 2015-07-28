//
//  PhotoponApplicationKey.m
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponApplicationKey.h"
#import "PhotoponConstants.h"

#ifdef ANYWALL
#import "PhotoponAppDelegate.h"
#endif

@implementation PhotoponApplicationKey

+ (BOOL) isPhotoponFacebookUserKey:(NSString *)key{
    
    
    return [key isEqualToString: kPhotoponUserAttributesProfilePictureUrlKey]||
    [key isEqualToString: kPhotoponMediaAttributesThumbURLKey] ||
    [key isEqualToString: kPhotoponMediaAttributesImageMidURLKey] ||
    [key isEqualToString: kPhotoponMediaAttributesImageLargeURLKey] ||
    [key isEqualToString: kPhotoponMediaAttributesLinkURLKey] || [key isEqualToString:kPhotoponUserAttributesFacebookIDKey];
	return NO;
}

+ (BOOL) isPhotoponUserKey:(NSString *)key{
#ifdef ANYPIC
    return [key isEqualToString: kPhotoponMediaAttributesUserKey] ||
    [key isEqualToString: kPhotoponActivityFromUserKey] ||
    [key isEqualToString: kPhotoponActivityToUserKey];
#endif
#ifdef FACEBOOKWALL
	return [key isEqualToString: kPhotoponU];
#endif
	return NO;
}

+ (BOOL) isPhotoponGeoPointKey:(NSString *)key{
#ifdef ANYWALL
	return [key isEqualToString: kPhotoponParseLocationKey];
    
#endif
    return NO;
}

+ (BOOL) isPhotoponModelKey:(NSString *)key{
    return [key isEqualToString: kPhotoponActivityAttributesPhotoKey];
}

+ (NSString*) getPhotoponModelClassForKey:(NSString *)key{
    if([key isEqualToString: kPhotoponActivityAttributesPhotoKey]){
        return kPhotoponMediaClassKey;
    }
    return nil;
}

+(BOOL)isPhotoponMediaModelKey:(NSString *)key{
    return [key isEqualToString: kPhotoponMediaClassName];
}

+(BOOL)isPhotoponActivityModelKey:(NSString *)key{
    return [key isEqualToString: kPhotoponActivityClassName];
}

+(BOOL)isPhotoponCouponModelKey:(NSString *)key{
    return [key isEqualToString: kPhotoponCouponClassName];
}

+(BOOL)isPhotoponCommentModelKey:(NSString *)key{
    return [key isEqualToString: kPhotoponCommentClassName];
}

+(BOOL)isPhotoponTagModelKey:(NSString *)key{
    return [key isEqualToString: kPhotoponTagClassName];
}


@end