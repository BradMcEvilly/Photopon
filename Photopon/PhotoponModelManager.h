//
//  PhotoponModelManager.h
//  Photopon
//  
//  Created by Brad McEvilly on 5/26/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreData/CoreData.h>
#import <WordPressApi/WordPressApi.h>
#import "PhotoponModel+Subclass.h"
#import "Reachability.h"
#import "PhotoponComApi.h"

#define ModelChangedNotification @"ModelChangedNotification"

//@class PhotoponModel;
@class PhotoponUserModel;

@interface PhotoponModelManager : PhotoponModel



@property (nonatomic, strong) NSDate *lastHomeSync;
@property (nonatomic, strong) NSDate *lastTimelineSync;
@property (nonatomic, strong) NSDate *lastExploreSync;
@property (nonatomic, strong) NSDate *lastNewsSync;
@property (nonatomic, strong) NSDate *lastProfileSync;
@property (nonatomic, strong) NSDate *lastUsersSync;
@property (nonatomic, strong) NSDate *lastCommentsSync;
@property (nonatomic, strong) NSDate *lastOffersSync;
@property (nonatomic, strong) NSDate *lastDetailsSync;


@property (nonatomic, strong) NSNumber *isAdmin, *hasOlderPosts, *hasOlderPages;
@property (nonatomic, strong) NSSet *mediaModels;
@property (nonatomic, strong) NSSet *mainMediaModels;
@property (nonatomic, strong) NSSet *timelineMediaModels;
@property (nonatomic, strong) NSSet *snippedMediaModels;
@property (nonatomic, strong) NSSet *userModels;
@property (nonatomic, strong) NSSet *offerModels;
@property (nonatomic, strong) NSSet *activityModels;
@property (nonatomic, strong) NSSet *tagModels;
@property (nonatomic, strong) NSSet *commentModels;
@property (nonatomic, strong) NSSet *categories;
@property (nonatomic, strong) NSSet *comments;
@property (nonatomic, assign) BOOL isSyncingHome;
@property (nonatomic, assign) BOOL isSyncingDetails;
@property (nonatomic, assign) BOOL isSyncingNews;
@property (nonatomic, assign) BOOL isSyncingComments;
@property (nonatomic, assign) BOOL isSyncingProfile;
@property (nonatomic, assign) BOOL isSyncingExplore;
@property (nonatomic, assign) BOOL isSyncingOffers;
@property (nonatomic, assign) BOOL isSyncingTags;
@property (nonatomic, assign) BOOL isSyncingUsers;
@property (nonatomic, assign) BOOL isSyncingSearchText;
@property (nonatomic, strong) NSDate *lastSyncDateHome;
@property (nonatomic, strong) NSDate *lastSyncDateNews;
@property (nonatomic, strong) NSDate *lastSyncDateComments;
@property (nonatomic, strong) NSDate *lastSyncDateProfile;
@property (nonatomic, strong) NSDate *lastSyncDateExplore;


@property (nonatomic, strong) NSDate *lastStatsSync;
@property (nonatomic, strong) NSString *lastUpdateWarning;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *username8Coupons;
@property (nonatomic, strong) NSString *password8Coupons;

@property (nonatomic, assign) BOOL geolocationEnabled;
@property (nonatomic, weak) NSNumber *isActivated;
@property (nonatomic, strong) NSDictionary *options; //we can store an NSArray or an NSDictionary as a transformable attribute...
@property (nonatomic, strong) NSDictionary *postFormats;
@property (weak, readonly) NSArray *sortedPostFormatNames;
@property (readonly, nonatomic, strong) WPXMLRPCClient *api;
@property (readonly, nonatomic, strong) WPXMLRPCClient *pCom8CouponsApi;
@property (readonly, nonatomic, strong) PhotoponComApi *pComApi;
@property (readonly, nonatomic, strong) PhotoponUserModel *currentUser;
@property (weak, readonly) NSString *version;
@property (weak, readonly) Reachability *reachability;
@property (readonly) BOOL reachable;

/**
 URL properties (example: http://wp.koke.me/sub/xmlrpc.php)
 */

// User to display the blog url to the user (IDN decoded, no http:)
// wp.koke.me/sub
@property (weak, readonly) NSString *displayURL;
// alias of displayURL
// kept for compatibilty, used as a key to store passwords
@property (weak, readonly) NSString *hostURL;
// http://wp.koke.me/sub
@property (nonatomic, strong) NSString *url;
// Used for reachability checks (IDN encoded)
// wp.koke.me
@property (weak, readonly) NSString *hostname;


#pragma mark - Service information

+ (id)sharedManager;


/** @name Serial Request Queue */

/**
 Dispatch queue for API requests
 @return The shared serial dispatch queue for API requests
 */
+ (dispatch_queue_t)queue;

- (BOOL)isWPcom;
- (BOOL)isPrivate;
- (NSArray *)sortedCategories;
- (id)getOptionValue:(NSString *) name;
- (NSString *)loginUrl;
- (NSString *)urlWithPath:(NSString *)path;
- (NSString *)adminUrlWithPath:(NSString *)path;

- (NSArray *)getXMLRPCArgsWithExtra:(id)extra;

- (NSArray *)get8CouponsXMLRPCArgsWithExtra:(id)extra;

- (NSString *)fetchPassword;
- (void)storePassword:(NSString *)password forUsername:(NSString*)username;
- (int)numberOfPendingComments;
- (NSDictionary *) getImageResizeDimensions;

- (void)findAllInBackgroundWithBlock:(void (^)(NSArray *results, NSError *error))block;
//- (void)findObjectsInBackgroundWithBlock

#pragma mark -

- (void)dataSave;
- (void)remove;


/*
- (void)syncPostsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;

- (void)syncPhotoponMainFeedItemsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncPhotoponNearbyFeedItemsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncPhotoponGlobalPopularFeedItemsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncPhotoponGlobalNewestFeedItemsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncPhotoponProfilePhotoponsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncPhotoponProfileSnipsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;

//- (void)syncPhotoponLikeWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure extraParameters:(NSArray *)paramsArrExtra;
//- (void)syncPhotoponUnlikeWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure extraParameters:(NSArray *)paramsArrExtra;
- (void)syncPhotoponLikeWithIndexPath:(NSIndexPath*)indexPath success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)syncPhotoponUnlikeWithIndexPath:(NSIndexPath*)indexPath success:(void (^)())success failure:(void (^)(NSError *error))failure;

- (void)syncPhotoponSnipWithIndexPath:(NSIndexPath*)indexPath success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)syncPhotoponUnsnipWithIndexPath:(NSIndexPath*)indexPath success:(void (^)())success failure:(void (^)(NSError *error))failure;

- (void)syncPhotoponSnippersWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncPhotoponLikersWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
*/


#pragma mark -
#pragma mark Synchronization
- (NSArray *)syncedTimeline;
- (NSArray *)syncedExplore;
- (NSArray *)syncedNews;
- (NSArray *)syncedProfile;

- (void)syncModelsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void)syncSearchTextWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void)syncDetailsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void)syncHomeWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void)syncExploreWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void)syncNewsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void)syncProfileWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void)syncOffersWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void)syncActivityWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;
- (void)syncCommentsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

/*
- (void)syncPostsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncPagesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (void)syncCategoriesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)syncOptionsWithWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)syncCommentsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)syncPostFormatsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)syncBlogWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
// Called when manually refreshing PostsViewController
// Syncs posts, categories, options, and post formats
- (void)syncBlogPostsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)checkActivationStatusWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)checkVideoPressEnabledWithSuccess:(void (^)(BOOL enabled))success failure:(void (^)(NSError *error))failure;
*/
#pragma mark -
#pragma mark Class methods
/*
+ (BOOL)blogExistsForURL:(NSString *)theURL withContext:(NSManagedObjectContext *)moc andUsername:(NSString *)username;
+ (Blog *)createFromDictionary:(NSDictionary *)blogInfo withContext:(NSManagedObjectContext *)moc;
+ (Blog *)findWithId:(int)blogId withContext:(NSManagedObjectContext *)moc;
+ (NSInteger)countWithContext:(NSManagedObjectContext *)moc;
*/

- (void)syncProfileInfoWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

@end



