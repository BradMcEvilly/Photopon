//
//  PhotoponComApi.h
//  Photopon
//
//  Created by Jorge Bernal on 6/4/12.
//  Copyright (c) 2012 Photopon. All rights reserved.
//

#import "PhotoponApi.h"
//#import "AFHTTPClient.h"

#define PhotoponComApiDidLoginNotification @"PhotoponComApiDidLogin"
#define PhotoponComApiDidLogoutNotification @"PhotoponComApiDidLogout"

@interface PhotoponComApi : PhotoponApi
@property (nonatomic,readonly,retain) NSString *username;
@property (nonatomic,readonly,retain) NSString *password;

+ (PhotoponComApi *)sharedApi;

- (void)setUsername:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;


// ------------------------------------------------------------------------------------------------ //
// Remote Data Getters                                                                              //
// ------------------------------------------------------------------------------------------------ //
- (NSArray*) photoponRegisterUserWithInfo:(NSArray*)userInfoParams withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponSyncFacebookUserWithInfo:(NSArray*)userInfoParams withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (NSArray*) photoponProfileGalleryWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (NSArray*) photoponProfileGalleryForUserID:(NSString*)userIdentifier andPage:(NSInteger)pageInt withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;


// REDUNDANT BUT STILL AVAILABLE FOR USE:
- (NSArray*) photoponProfileDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
// END REDUNDANT //

- (NSArray*) photoponProfileRedeemedWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (NSArray*) photoponProfileRedeemedDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponProfileFollowingWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponProfileFollowingDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponProfileFollowersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponProfileFollowersDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponNearbyPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponNearbyPhotoponsDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponLikesUsersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponLikesUsersDataForPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

// returns user lists to paint the picture given the numbers (counts)
- (void) photoponViewsUsersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponViewsUsersDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (NSArray*) photoponRedeemsUsersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (NSArray*) photoponRedeemsUsersDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

// REDUNDANT because this gets called via authentication automagically
//- (NSArray*) photoponProfileDataWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
//

// ------------------------------------------------------------------------------------------------ //
// Remote User/Social Action Data Setters                                                           //
// ------------------------------------------------------------------------------------------------ //
- (void) photoponUserDidViewPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void) photoponUserDidCommentPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void) photoponUserDidLikePhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void) photoponUserDidRedeemPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponUserDidFollowUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void) photoponUpdateProfileData:(NSArray*)paramsProfileData withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

// ------------------------------------------------------------------------------------------------ //
// ONLY 2 METHODS THAT WILL NOT (AT SOME POINT) AND DO NOT REQUIRE EXTRA PARAMETERS                 //
// ------------------------------------------------------------------------------------------------ //
- (void) photoponGlobalPopularPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void) photoponGlobalRecentPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
// ------------------------------------------------------------------------------------------------ //

- (void)syncPushNotificationInfo;

/*
 * Queries the REST Api for unread notes and determines if the user has
 * seen them using the response's last_seen_time timestamp.
 *
 * If we have unseen notes we post a WordPressComApiUnseenNotesNotification
 */
- (void)checkForNewUnseenNotifications;

- (void)signOut;

- (NSArray *)getXMLRPCArgsWithExtra:(id)extra;

/*
 
 old:

 
 - (NSArray*) photoponProfileGalleryWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (NSArray*) photoponProfileRedeemedWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (void) photoponProfileFollowersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (void) photoponProfileFollowingWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 
 
 - (void) photoponGlobalPopularPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (void) photoponGlobalRecentPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (void) photoponNearbyPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 
 
 - (void) photoponLikesWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (void) photoponViewsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (void) photoponCommentsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
 
 - (NSArray*) photoponRedeemsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
  
 
 // end old
 
 
 
 
 
 
 

//:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;
/ *
- (NSArray *)getRedeemed:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;

- (BOOL)setFollowing:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;

- (BOOL)setFollowers:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;
 
*/

@end

