//
//  PhotoponCommentModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponModel.h"

@class PhotoponUserModel;

@interface PhotoponCommentModel : PhotoponModel

@property (readonly) NSString* identifier;
@property (readonly) NSString* content;
@property (readonly) NSString* activityID;
@property (readonly) NSString* mediaID;

@property (readonly) PhotoponUserModel* user;

@property (readonly) NSString* locationIdentifier;
@property (readonly) NSString* locationLatitude;
@property (readonly) NSString* locationLongitude;
@property (readonly) NSDate* createdTime;

/**
 Creates a populated media model
 */
+ (PhotoponCommentModel*)modelWithDictionary:(NSDictionary*)dict;

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts;

@end
