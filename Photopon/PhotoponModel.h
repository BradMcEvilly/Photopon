3//
//  PhotoponModel.h
//  Photopon
//
//  Created by Brad McEvilly on 5/9/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

//#import "IGConnect.h"
//#import "PhotoponACL.h"
//#import "PhotoponAppDelegate.h"
//#import "PhotoponConstants.h"

#import <Foundation/Foundation.h>
#import "PhotoponModelManager.h"
#import "DateUtils.h"
#import "PhotoponComApi.h"

//#import "PhotoponCache.h"

//@class PhotoponCache;

//@class PhotoponACL;

typedef enum {
    PhotoponModelRemoteStatusPushing,    // Uploading post
    PhotoponModelRemoteStatusFailed,      // Upload failed
    PhotoponModelRemoteStatusLocal,       // Only local version
    PhotoponModelRemoteStatusSync,       // Post uploaded
    PhotoponModelRemoteStatusProcessing, // Intermediate status before uploading
} PhotoponModelRemoteStatus;


@interface PhotoponModel : NSObject <IGRequestDelegate>
{
    
}
@property (readonly, nonatomic, strong) NSCache *cache;
@property (readonly) NSString* entityKey;
@property (readonly) NSString* identifier;
@property (readonly) NSString* entityName;
@property (nonatomic, strong) NSString *objectId;
@property (readonly) NSDate *createdAt;
@property (readonly) NSString *className;
@property (nonatomic, strong) NSNumber * remoteStatusNumber;
@property (nonatomic) PhotoponModelRemoteStatus remoteStatus;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (readonly) BOOL hasBeenFetched;
@property (readonly) NSNumber *tag;

+ (PhotoponModel*)modelWithDictionary:(NSDictionary*)dict;
+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts;

- (id)init;
- (id)initWithAttributes:(NSDictionary*)attributes forEntityName:(NSString *)entityName;
- (id) initWithAttributes:(NSDictionary*)attributes;
- (id) objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)addUniqueObject:(id)object forKey:(NSString *)key;
- (void)removeObject:(id)object forKey:(NSString *)key;
- (void)saveInBackground;

- (void)saveInBackgroundWithBlock:(PhotoponBooleanResultBlock)block;
- (void)saveEventually;
- (void)saveEventually:(PhotoponBooleanResultBlock)callback;
- (void)refreshInBackgroundWithTarget:(id)target selector:(SEL)selector;
- (void)fetchIfNeededInBackgroundWithBlock:(PhotoponModelResultBlock)block;
- (BOOL)delete;
- (void)deleteEventually;
- (void)setValue:(id)value forKey:(NSString *)key;
- (PhotoponModel *)fetchIfNeeded;
+ (PhotoponModel *)objectWithClassName:(NSString *)className;
+ (id)objectWithoutDataWithClassName:(NSString *)className objectId:(NSString*)objectId;

/**
 Batch save all entities.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 @return `YES` on success, `NO` on error.
 */
+ (BOOL)saveAll:(NSArray *)entities;

/**
 Batch save all entities.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error.
 */
+ (BOOL)saveAll:(NSArray *)entities error:(NSError **)error;

/**
 Batch save all entities in the background.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 */
+ (void)saveAllInBackground:(NSArray *)entities;

/**
 Batch save all entities in the background.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 @param block The save callback block
 */
+ (void)saveAllInBackground:(NSArray *)entities withBlock:(void (^)(NSArray *entities, NSError *error))block;

/**
 Saves the entity
 @return `YES` on success, `NO` on error
 @exception NSInvalidArgumentException Raised if any key contains an `$` or `.` character.
 */
- (BOOL)save;

/**
 Saves the entity
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error
 @exception NSInvalidArgumentException Raised if any key contains an `$` or `.` character.
 */
- (BOOL)save:(NSError **)error;

/** @name Refreshing Entities */

/**
 Refreshes the entity
 
 Refreshes the entity with data stored on the server.
 @return `YES` on success, `NO` on error
 */
- (BOOL)refresh;

/**
 Refreshes the entity
 
 Refreshes the entity with data stored on the server.
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error
 */
- (BOOL)refresh:(NSError **)error;

/**
 Refreshes the entity in the background
 
 Refreshes the entity with data stored on the server.
 */
- (void)refreshInBackground;

/**
 Refreshes the entity in the background and invokes the callback on completion
 
 Refreshes the entity with data stored on the server.
 @param block The callback block
 */
- (void)refreshInBackgroundWithBlock:(void (^)(PhotoponModel *entity, NSError *error))block;

/** @name Deleting Entities */

/**
 Deletes the entity
 @return `YES` on success, `NO` on error
 */
- (BOOL)delete;

/**
 Deletes the entity
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error
 */
- (BOOL)delete:(NSError **)error;

/**
 Deletes the entity in the background
 */
- (void)deleteInBackground;

/**
 Deletes the entity in the background and invokes the callback block on completion
 @param block The callback block
 */
- (void)deleteInBackgroundWithBlock:(void (^)(PhotoponModel *entity, NSError *error))block;

@end
