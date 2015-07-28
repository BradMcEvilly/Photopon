//
//  Photopon8CouponsModel.h
//  Photopon
//
//  Created by Brad McEvilly on 8/2/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponCouponModel.h"

@interface Photopon8CouponsModel : PhotoponCouponModel

@property (readonly) NSString *dealOriginalPrice;
@property (readonly) NSString *dealPrice;
@property (readonly) NSString *dealSavings;
@property (readonly) NSString *dealDiscountPercent;
@property (readonly) NSString *dealSource;

@property (readonly) NSString *distance;

@property (readonly) NSString *user;
@property (readonly) NSString *userID;

@property (readonly) NSString *showLogo;

@property (readonly) NSString *showImage;
@property (readonly) NSString *showImageStandardBig;
@property (readonly) NSString *showImageStandardSmall;

@property (readonly) NSString *nullFieldStr;

@property (readonly) NSString *value;


+(Photopon8CouponsModel *)modelWithDictionary:(NSDictionary*)dict;

+ (NSMutableDictionary*)couponModelWith8CouponsDictionary:(NSMutableDictionary*)dict;

+(NSArray*)modelsFromDictionaries:(NSArray*)dicts;

+(NSString*)username;

+(NSString*)password;

+(NSString*)method;

+(NSString*)key;

+(NSString*)lat;

+(NSString*)lon;

+(NSString*)radius;

+(NSString*)limit;

+(NSString*)baseUrl;

+(NSString*)endpointUrl;

+(NSString*)methodEndpointUrl;

+(NSString*)fullUrl;

+(NSDictionary*)params;

-(void)sanitize;

-(void)sanitizeRawJSON;

@end
