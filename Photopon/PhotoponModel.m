//
//  PhotoponModel.m
//  Photopon
//
//  Created by Brad McEvilly on 5/9/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponModel.h"
#import "PhotoponFile.h"
#import "PhotoponApplicationKey.h"
#import "PhotoponUserModel.h"
#import "PhotoponAdapterUtils.h"
#import "PhotoponConstants.h"
#import "PhotoponComApi.h"
#import "PhotoponModelManager.h"

@interface PhotoponModel ()



@end

@implementation PhotoponModel{
    NSCache *_cache;
}

@synthesize dictionary;
@synthesize remoteStatusNumber;
//@synthesize cache = _cache;

#pragma mark - Initialisation

+ (id)modelWithDictionary:(NSMutableDictionary*)dict {

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponModel* pModel = [[[self class] alloc] init];
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [pModel.dictionary setObject:kPhotoponClassName forKey:kPhotoponEntityNameKey];
    [pModel.dictionary setObject:[NSDate date] forKey:kPhotoponCreatedTimeKey];
    [pModel.dictionary setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
    
    return pModel;
}

+ (PhotoponModel *)modelWithID:(NSString *)objID className:(NSString *)className{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponModel *m = [[self alloc] initWithName:className];
    [m.dictionary setObject:objID forKey:kPhotoponModelIdentifierKey];
    
    return m;
}

+ (PhotoponModel *)objectWithClassName:(NSString *)className{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[self alloc] initWithName:className];
}

+ (id)objectWithoutDataWithClassName:(NSString *)className
                                         objectId:(NSString *)objectId{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self modelWithID:objectId className:className];
}

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:[dicts count]];
    for (NSDictionary* modelDict in dicts) {
        [models addObject:[PhotoponModel modelWithDictionary:modelDict]];
    }
    return models;
}

- (id)initWithName:(NSString *)entityName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        self.dictionary = [NSMutableDictionary new];
        [self.dictionary setObject:entityName forKey:kPhotoponEntityNameKey];
        [self.dictionary setObject:[NSDate date] forKey:kPhotoponCreatedTimeKey];
        [self.dictionary setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
    }
    return self;
    
}

- (id)init{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

/*
+ (PhotoponModel *)modelFromCache{
    
    NSString *uid = [[EGOCache globalCache] stringForKey:kPhotoponUserAttributesIdentifierKey];
    if (!uid) {
        return nil;
    }
    PhotoponModel *pModel = [[PhotoponModel alloc] init];
    pModel.objectId = uid;
    return pModel;
}*/

-(NSCache *)cache {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];// sharedCache];
    }
    return _cache;
}

-(NSString*)entityKey{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.objectId || !self.entityName) {
        return nil;
    }
    return [[NSString alloc] initWithFormat:@"%@_%@", self.entityName, self.objectId];
}







/*
-(NSString*)entityName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.objectId || !self.entityName) {
        return nil;
    }
    return [[NSString alloc] initWithFormat:@"%@_%@", self.entityName, self.objectId];
}
*/
-(NSString*)objectId{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponModelIdentifierKey];
}

-(void)setObjectId:(NSString *)objectId{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSMutableDictionary *dictNew = [NSDictionary dictionaryWithDictionary:self.dictionary];
    [self.dictionary setValue:objectId forKey:kPhotoponModelIdentifierKey];
    //[self setDictionary:dictNew];
}

- (id)initWithAttributes:(NSDictionary*)attributes{
    // must be overridden in subclass
    
    self = [super init];
    if (!self) {
        return nil;
    }
    self.dictionary = [[NSMutableDictionary alloc] initWithDictionary: attributes];
    return self;
}


- (NSDate *)createdAt {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponCreatedTimeKey];
}

- (NSString *)className {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return nil;
}

- (id)initWithAttributes:(NSDictionary*)attributes forEntityName:(NSString *)entityName{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        
        self.dictionary = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        [self.dictionary setObject:entityName forKey:kPhotoponEntityNameKey];
    }
    return self;
    
}

-(NSNumber*)tag{
    return [self.dictionary objectForKey:@"tag"];
}

-(BOOL)hasBeenFetched{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[self.dictionary valueForKey:kPhotoponHasBeenFetchedKey] boolValue];
}

- (id)objectForKey:(NSString *)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // depricated
    //return [self.dictionary objectForKey:key];
    id obj = [self.dictionary objectForKey:key];
    if (obj != nil)
        return obj;
    
    if([PhotoponApplicationKey isPhotoponFacebookUserKey:key]){
        
        
        // clear NSUserDefaults
        
        //[[NSUserDefaults standardUserDefaults] setObject: forKey:kPhotoponUserAttributesCurrentUserKey];
        
        return [PhotoponUserModel currentUser];
        
        
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserAttributesFacebookIDKey];
        
        
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserAttributesFacebookAccessTokenKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserDefaultsCacheFacebookFriendsKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserDefaultsActivityFeedViewControllerLastRefreshKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    }else if([PhotoponApplicationKey isPhotoponFileKey:key]){
        NSString *fileName= [self.dictionary objectForKey:key];
        if(fileName){ //&& [DKFile fileExists:fileName]){
            
            
            //PhotoponFile *file = [PhotoponFile fileWithData:nil];
            //file.dictionary = [DKFile fileWithName:fileName];
            //[self.photoponCache setObject:file forKey:key];
            //return file;
        }
        return nil;
    }
    else if([PhotoponApplicationKey isPhotoponUserKey:key]){
        NSString* userId = [self.dictionary objectForKey:key];
        
        PhotoponUserModel* current = [PhotoponUserModel currentUser];
        if(current && [current.identifier isEqualToString: userId])
            return current;
        
        // otherwise, cache the current user
        
        
        /*
        PhotoponQuery *query = [PhotoponUserModel query];
        [query.dkQuery whereEntityIdMatches:userId];
        NSError *error = nil;
        NSArray *array = [query findObjects:&error];
        if([array count] > 0){
            PhotoponUserModel* user = (PhotoponUserModel*)[array objectAtIndex:0];
            [self.photoponCache setObject:user forKey:key];
            return user;
        }*/
    }
    else if([PhotoponApplicationKey isPhotoponGeoPointKey:key]){
        NSArray* arr = [self.dictionary objectForKey:key];
        PhotoponGeoPointModel* point = [PhotoponAdapterUtils convertObjToPhotopon:arr];
        [self.dictionary setObject:point forKey:key];
        return point;
    }
    else if([PhotoponApplicationKey isPhotoponModelKey:key]){
        NSString* objId = [self.dictionary objectForKey:key];
        if(!objId)
            return nil;
        /*
        PhotoponQuery *query = [PhotoponQuery queryWithClassName:[PhotoponApplicationKey getPhotoponModelClassForKey:key]];
        [query.dkQuery whereEntityIdMatches:objId];
        NSError *error = nil;
        NSArray *array = [query findObjects:&error];
        if([array count] > 0){
            PhotoponModel* obj = (PhotoponModel*)[array objectAtIndex:0];
            [self.photoponCache setObject:obj forKey:key];
            return obj;
        }*/
    }
    return [self.dictionary objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.dictionary setObject:[PhotoponAdapterUtils convertObjToNS:object] forKey:key];
    [self.dictionary setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
}

- (void)removeObjectForKey:(NSString *)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if([PhotoponApplicationKey isPhotoponFileKey:key]){
        
        /*
        NSString *fileName= [self.dictionary objectForKey:key];
        
        if(fileName && [self fileExists:fileName]){
            NSError *error = nil;
            [self deleteFile:fileName error:&error];
        }
         */
    }
    
    [self.cache removeObjectForKey:key];
    [self.dictionary removeObjectForKey:key];
	[self setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
    
}

- (void)addUniqueObject:(id)object forKey:(NSString *)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.dictionary addObjectToSet:[PhotoponAdapterUtils convertObjToNS:object] forKey:key];
    [self.dictionary setObject:object forKey:key];
	[self setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
    
}

- (void)removeObject:(id)object forKey:(NSString *)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.dictionary pullObject:[PhotoponAdapterUtils convertObjToNS:object] forKey: key];
    [self.cache removeObjectForKey:key];
    [self.dictionary removeObjectForKey:key];
	[self setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
}

- (void)saveInBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.dkEntity saveInBackground];
	
    
    [self setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
}

- (void)saveInBackgroundWithBlock:(PhotoponBooleanResultBlock)block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    block = [block copy];
    
    
    dispatch_queue_t q = dispatch_get_main_queue();
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
        BOOL ret = [weakSelf save:&error];
		[weakSelf setValue:[NSNumber numberWithBool:ret] forKey:kPhotoponHasBeenFetchedKey];
        if (block != NULL) {
            dispatch_async(q, ^{
                block(ret, error);
            });
        }
    });
}

- (void)saveEventually{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self saveInBackground];
	[self setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
}
- (void)saveEventually:(PhotoponBooleanResultBlock)callback{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self saveInBackgroundWithBlock:callback];
}

- (void)refreshInBackgroundWithTarget:(id)target selector:(SEL)selector{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    dispatch_queue_t q = dispatch_get_main_queue();
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
        [self refresh:&error];
		[self setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
        [self.cache removeAllObjects];
        if (selector != NULL) {
            dispatch_async(q, ^{
                if([target respondsToSelector:selector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [target performSelector:selector withObject:self withObject:error];
#pragma clang diagnostic pop
                }
            });
        }
    });
}

- (void)fetchIfNeededInBackgroundWithBlock:(PhotoponModelResultBlock)block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    block = [block copy];
    dispatch_queue_t q = dispatch_get_main_queue();
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
		if(!self.hasBeenFetched){
			[self refresh:&error];
			[self setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
            [self.cache removeAllObjects];
		}
        if (block != NULL) {
            dispatch_async(q, ^{
                block(self, error);
            });
        }
    });
}

- (BOOL)delete{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self delete];
}

- (void)deleteEventually{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self deleteInBackground];
}

- (void)setValue:(id)value forKey:(NSString *)key{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setObject:[PhotoponAdapterUtils convertObjToNS:value] forKey:key];
    [self setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
}

- (PhotoponModel *)fetchIfNeeded{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if(!self.hasBeenFetched){
        NSError *error = nil;
        [self refresh:&error];
        [self.cache removeAllObjects];
		[self setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
	}
    return self;
}

/**
 Batch save all entities.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 @return `YES` on success, `NO` on error.
 */
+ (BOOL)saveAll:(NSArray *)entities{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

/**
 Batch save all entities.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error.
 */
+ (BOOL)saveAll:(NSArray *)entities error:(NSError **)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

/**
 Batch save all entities in the background.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 */
+ (void)saveAllInBackground:(NSArray *)entities{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

/**
 Batch save all entities in the background.
 
 Useful if you want to make sure everything is transmitted to the server before saving.
 @param entities The entities to save
 @param block The save callback block
 */
+ (void)saveAllInBackground:(NSArray *)entities withBlock:(void (^)(NSArray *entities, NSError *error))block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

/**
 Saves the entity
 @return `YES` on success, `NO` on error
 @exception NSInvalidArgumentException Raised if any key contains an `$` or `.` character.
 */
- (BOOL)save{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

/**
 Saves the entity
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error
 @exception NSInvalidArgumentException Raised if any key contains an `$` or `.` character.
 */
- (BOOL)save:(NSError **)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

/**
 Refreshes the entity
 
 Refreshes the entity with data stored on the server.
 @return `YES` on success, `NO` on error
 */
- (BOOL)refresh{
    return YES;
}

/**
 Refreshes the entity
 
 Refreshes the entity with data stored on the server.
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error
 */
- (BOOL)refresh:(NSError **)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

/**
 Refreshes the entity in the background
 
 Refreshes the entity with data stored on the server.
 */
- (void)refreshInBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

/**
 Refreshes the entity in the background and invokes the callback on completion
 
 Refreshes the entity with data stored on the server.
 @param block The callback block
 */
- (void)refreshInBackgroundWithBlock:(void (^)(PhotoponModel *entity, NSError *error))block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

/** @name Deleting Entities */

/**
 Deletes the entity
 @param error The error object to be set on error
 @return `YES` on success, `NO` on error
 */
- (BOOL)delete:(NSError **)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

/**
 Deletes the entity in the background
 */
- (void)deleteInBackground{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

/**
 Deletes the entity in the background and invokes the callback block on completion
 @param block The callback block
 */
- (void)deleteInBackgroundWithBlock:(void (^)(PhotoponModel *entity, NSError *error))block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}
























/*
@synthesize isFeaturedImageChanged;

+ (NSString *)titleForStatus:(NSString *)status {
    if ([status isEqualToString:@"draft"]) {
        return NSLocalizedString(@"Draft", @"");
    } else if ([status isEqualToString:@"pending"]) {
        return NSLocalizedString(@"Pending review", @"");
    } else if ([status isEqualToString:@"private"]) {
        return NSLocalizedString(@"Privately published", @"");
    } else if ([status isEqualToString:@"publish"]) {
        return NSLocalizedString(@"Published", @"");
    } else {
        return status;
    }
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    
    if (self.remoteStatus == PhotoponModelRemoteStatusPushing) {
        // If we've just been fetched and our status is AbstractPostRemoteStatusPushing then something
        // when wrong saving -- the app crashed for instance. So change our remote status to failed.
        // Do this after a delay since property changes and saves are ignored during awakeFromFetch. See docs.
        [self performSelector:@selector(markRemoteStatusFailed) withObject:nil afterDelay:0.1];
    }
    
}

- (void)markRemoteStatusFailed {
    self.remoteStatus = PhotoponModelRemoteStatusFailed;
    [self save];
}

- (NSArray *)availableStatuses {
    return [NSArray arrayWithObjects:
            NSLocalizedString(@"Draft", @""),
            NSLocalizedString(@"Pending review", @""),
            NSLocalizedString(@"Private", @""),
            NSLocalizedString(@"Published", @""),
            nil];
}

- (BOOL)hasRemote {
    return ((self.postID != nil) && ([self.postID longLongValue] > 0));
}

- (void)remove {
    for (Media *media in self.media) {
        [media cancelUpload];
    }
    if (self.remoteStatus == PhotoponModelRemoteStatusPushing || self.remoteStatus == AbstractPostRemoteStatusLocal) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUploadCancelled" object:self];
    }
    
    [self.dictionary removeObjectForKey]
    
    [[self managedObjectContext] deleteObject:self];
    [self save];
}

- (void)save {
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        WPFLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        exit(-1);
    }
}

- (NSString *)statusTitle {
    return [AbstractPost titleForStatus:self.status];
}

- (void)setStatusTitle:(NSString *)aTitle {
    self.status = [AbstractPost statusForTitle:aTitle];
}

#pragma mark -
#pragma mark Revision management
- (void)cloneFrom:(AbstractPost *)source {
    for (NSString *key in [[[source entity] attributesByName] allKeys]) {
        if ([key isEqualToString:@"permalink"]) {
            NSLog(@"Skipping %@", key);
        } else {
            NSLog(@"Copying attribute %@", key);
            [self setValue:[source valueForKey:key] forKey:key];
        }
    }
    for (NSString *key in [[[source entity] relationshipsByName] allKeys]) {
        if ([key isEqualToString:@"original"] || [key isEqualToString:@"revision"]) {
            NSLog(@"Skipping relationship %@", key);
        } else if ([key isEqualToString:@"comments"]) {
            NSLog(@"Copying relationship %@", key);
            [self setComments:[source comments]];
        } else {
            NSLog(@"Copying relationship %@", key);
            [self setValue: [source valueForKey:key] forKey: key];
        }
    }
}

- (AbstractPost *)createRevision {
    if ([self isRevision]) {
        NSLog(@"!!! Attempted to create a revision of a revision");
        return self;
    }
    if (self.revision) {
        NSLog(@"!!! Already have revision");
        return self.revision;
    }
    
    AbstractPost *post = [NSEntityDescription insertNewObjectForEntityForName:[[self entity] name] inManagedObjectContext:[self managedObjectContext]];
    [post cloneFrom:self];
    [post setValue:self forKey:@"original"];
    [post setValue:nil forKey:@"revision"];
    post.isFeaturedImageChanged = self.isFeaturedImageChanged;
    return post;
}

- (void)deleteRevision {
    if (self.revision) {
        [[self managedObjectContext] deleteObject:self.revision];
        [self setPrimitiveValue:nil forKey:@"revision"];
    }
}

- (void)applyRevision {
    if ([self isOriginal]) {
        [self cloneFrom:self.revision];
        self.isFeaturedImageChanged = self.revision.isFeaturedImageChanged;
    }
}

- (void)updateRevision {
    if ([self isRevision]) {
        [self cloneFrom:self.original];
        self.isFeaturedImageChanged = self.original.isFeaturedImageChanged;
    }
}

- (BOOL)isRevision {
    return (![self isOriginal]);
}

- (BOOL)isOriginal {
    return ([self primitiveValueForKey:@"original"] == nil);
}

- (AbstractPost *)revision {
    return [self primitiveValueForKey:@"revision"];
}

- (AbstractPost *)original {
    return [self primitiveValueForKey:@"original"];
}

- (BOOL)hasChanges {
    if (![self isRevision])
        return NO;
    
    //Do not move the Featured Image check below in the code.
    if ((self.post_thumbnail != self.original.post_thumbnail)
        && (![self.post_thumbnail  isEqual:self.original.post_thumbnail])){
        self.isFeaturedImageChanged = YES;
        return YES;
    } else
        self.isFeaturedImageChanged = NO;
    
    
    //first let's check if there's no post title or content (in case a cheeky user deleted them both)
    if ((self.postTitle == nil || [self.postTitle isEqualToString:@""]) && (self.content == nil || [self.content isEqualToString:@""]))
        return NO;
    
    // We need the extra check since [nil isEqual:nil] returns NO
    if ((self.postTitle != self.original.postTitle)
        && (![self.postTitle isEqual:self.original.postTitle]))
        return YES;
    if ((self.content != self.original.content)
        && (![self.content isEqual:self.original.content]))
        return YES;
    
    if ((self.status != self.original.status)
        && (![self.status isEqual:self.original.status]))
        return YES;
    
    if ((self.password != self.original.password)
        && (![self.password isEqual:self.original.password]))
        return YES;
    
    if ((self.dateCreated != self.original.dateCreated)
        && (![self.dateCreated isEqual:self.original.dateCreated]))
        return YES;
    
	if ((self.permaLink != self.original.permaLink)
        && (![self.permaLink  isEqual:self.original.permaLink]))
        return YES;
	
    if (self.hasRemote == NO) {
        return YES;
    }
    
    // Relationships are not going to be nil, just empty sets,
    // so we can avoid the extra check
    if (![self.media isEqual:self.original.media])
        return YES;
    
    return NO;
}

- (PhotoponModelRemoteStatus)remoteStatus {
    return (PhotoponModelRemoteStatus)[[self remoteStatusNumber] intValue];
}

- (void)setRemoteStatus:(PhotoponModelRemoteStatus)aStatus {
    [self setRemoteStatusNumber:[NSNumber numberWithInt:aStatus]];
}

- (void)upload {
}

+ (NSString *)titleForRemoteStatus:(NSNumber *)remoteStatus {
    switch ([remoteStatus intValue]) {
        case AbstractPostRemoteStatusPushing:
            return NSLocalizedString(@"Uploading", @"");
            break;
        case AbstractPostRemoteStatusFailed:
            return NSLocalizedString(@"Failed", @"");
            break;
        case AbstractPostRemoteStatusSync:
            return NSLocalizedString(@"Posts", @"");
            break;
        default:
            return NSLocalizedString(@"Local", @"");
            break;
    }
}

- (NSString *)remoteStatusText {
    return [PhotoponModel titleForRemoteStatus:self.remoteStatusNumber];
}

 
 
 
 **********************
 
 [DateUtils GMTDateTolocalDate:[DateUtils localDateToGMTDate:[NSDate date]]];
 
 *********************
 
 
 
- (NSDate *)dateCreated {
	if(self.date_created_gmt != nil)
		return [DateUtils GMTDateTolocalDate:self.date_created_gmt];
	else
		return nil;
    
}

- (void)setDateCreated:(NSDate *)localDate {
	if(localDate == nil)
		self.date_created_gmt = nil;
	else
		self.date_created_gmt = [DateUtils localDateToGMTDate:localDate];
}


- (void)findComments {
    NSSet *comments = [self.blog.comments filteredSetUsingPredicate:
                       [NSPredicate predicateWithFormat:@"(postID == %@) AND (post == NULL)", self.postID]];
    if (comments && [comments count] > 0) {
        [self.comments unionSet:comments];
    }
}

- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
}

- (void)deletePostWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
}

- (NSDictionary *)XMLRPCDictionary {
    
    return self.dictionary;
    / *
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    
    [postParams setValueIfNotNil:self.postTitle forKey:@"title"];
    [postParams setValueIfNotNil:self.content forKey:@"description"];
    [postParams setValueIfNotNil:self.date_created_gmt forKey:@"date_created_gmt"];
    [postParams setValueIfNotNil:self.password forKey:@"wp_password"];
    [postParams setValueIfNotNil:self.permaLink forKey:@"permalink"];
    [postParams setValueIfNotNil:self.mt_excerpt forKey:@"mt_excerpt"];
    [postParams setValueIfNotNil:self.wp_slug forKey:@"wp_slug"];
    // To remove a featured image, you have to send an empty string to the API
    if (self.post_thumbnail == nil) {
        // Including an empty string for wp_post_thumbnail generates
        // an "Invalid attachment ID" error in the call to wp.newPage
        if ([self.postID longLongValue] > 0) {
            [postParams setValue:@"" forKey:@"wp_post_thumbnail"];
        }
        
    } else {
        [postParams setValue:self.post_thumbnail forKey:@"wp_post_thumbnail"];
	}
    
	if (self.mt_text_more != nil && [self.mt_text_more length] > 0)
        [postParams setObject:self.mt_text_more forKey:@"mt_text_more"];
	
    return postParams;
     * /
}

- (void)autosave {
    
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        // We better not crash on autosave
        //WPFLog(@"[Autosave] Unresolved Core Data Save error %@, %@", error, [error userInfo]);
    }
}
*/


@end

