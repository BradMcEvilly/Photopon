//
//  PhotoponActivityModel.h
//  Photopon
//
//  Created by Brad McEvilly on 5/26/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponModel+Subclass.h"

@interface PhotoponActivityModel : PhotoponModel

@property (readonly) NSString *content;
@property (readonly) NSString *fromUser;
@property (readonly) NSString *identifier;
@property (readonly) NSString *mediaIdentifier;
@property (readonly) NSString *photo;
@property (readonly) NSString *thumbnailURL;
@property (readonly) NSString *title;
@property (readonly) NSString *toUser;
@property (readonly) NSString *typeComment;
@property (readonly) NSString *typeFollow;
@property (readonly) NSString *typeJoined;
@property (readonly) NSString *type;
@property (readonly) NSString *typeLike;
@property (readonly) NSString *userIdentifier;

+ (PhotoponActivityModel*)modelWithDictionary:(NSMutableDictionary*)dict;
+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts;

@end
