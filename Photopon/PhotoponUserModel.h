//
//  PhotoponUserModel.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoponConstants.h"
#import "PhotoponModel+Subclass.h"
//#import "PhotoponParser.h"
//#import "PhotoponQuery.h"
//#import "PhotoponModel+Subclass.h"


//#import "PhotoponModel.h"

@class PhotoponUserModel;

@interface PhotoponUserModel : PhotoponModel

// Public properties
@property (readonly) NSString* identifier;
@property (readonly) NSString* fullname;
@property (readonly) NSString* username;
@property (readonly) NSString* firstName;
@property (readonly) NSString* lastName;
@property (readonly) NSString* email;
@property (readonly) NSString* bio;
@property (readonly) NSString* website;
@property (readonly) NSString* profilePictureUrl;
@property (readonly) NSString* profileCoverPictureUrl;
@property (readonly) NSNumber* followedByCount;
@property (readonly) NSNumber* followersCount;
@property (readonly) NSNumber* redeemCount;
@property (readonly) NSNumber* mediaCount;
@property (readonly) NSNumber* score;

@property (readonly) NSString* followedByCountString;
@property (readonly) NSString* followersCountString;
@property (readonly) NSString* redeemCountString;
@property (readonly) NSString* mediaCountString;
@property (readonly) NSString* scoreString;
@property (readonly) NSString *didFollowString;

@property (readonly) NSString* twitterID;
@property (readonly) NSString* facebookID;
@property (readonly) NSString* instagramID;

@property (nonatomic) BOOL didFollowBool;
@property (readonly) NSNumber *didFollow;

@property (nonatomic, strong) PhotoponUserModel *leader;

+ (PhotoponUserModel *)currentUser;

+ (PhotoponUserModel *)modelFromCache;

+ (PhotoponUserModel*)modelWithDictionary:(NSDictionary*)dict;

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts;

+ (void)setCurrentUser:(PhotoponUserModel *)user;

- (void)changeUserName:(NSString*)username;
//+ (PhotoponQuery *)query;

//+ (void)getLikersForMediaId:(NSString*)mediaId withAccessToken:(NSString *)accessToken block:(void (^)(NSArray *records))block;
//+ (void)getUserMediaWithId:(NSString*)userId withAccessToken:(NSString *)accessToken block:(void (^)(NSArray *records))block;

+ (void)logOut;

- (id)initWithAttributes:(NSDictionary *)attributes;

- (void) refreshCurrentUserCallbackWithResult:(id)result error:(NSError*)error;

+ (BOOL) isLoggedIn;

- (void) cacheUserAttributes;

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PhotoponUserModelResultBlock)block;

-(void) userDidFollow:(UIButton *)button;

-(void) userDidUnfollow:(UIButton *)button;

@end
