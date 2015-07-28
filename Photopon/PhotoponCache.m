//
//  PhotoponCache.m
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//

#import "PhotoponCache.h"

@interface PhotoponCache()

@property (nonatomic, strong) NSCache *cache;
- (void)setAttributes:(NSDictionary *)attributes forMedia:(PhotoponMediaModel *)media;
- (void)setAttributes:(NSDictionary *)attributes forCoupon:(PhotoponCouponModel *)coupon;
- (void)setAttributes:(NSDictionary *)attributes forPlace:(PhotoponPlaceModel *)place;
@end

@implementation PhotoponCache
@synthesize cache;

#pragma mark - Initialization

+ (id)sharedCache {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - PhotoponCache

- (void)clear {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.cache removeAllObjects];
}

- (NSDictionary *)attributesForMedia:(PhotoponMediaModel *)media{
    
    return nil;
    
}

- (void)setAttributesForMedia:(PhotoponMediaModel *)media couponID:(NSString*)coupon likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:likedByCurrentUser],kPhotoponMediaAttributesDidLikeBoolKey,
                                [NSNumber numberWithInt:[likers count]],kPhotoponMediaAttributesLikeCountKey,
                                likers,kPhotoponMediaAttributesLikersKey,
                                [NSNumber numberWithInt:[commenters count]],kPhotoponMediaAttributesCommentCountKey,
                                commenters,kPhotoponMediaAttributesCommentersKey,
                                nil];
    
    [self setAttributes:attributes forMedia:media];
    
}

- (NSDictionary *)attributesForPhoto:(PhotoponModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = [self keyForMedia:photo];
    return [self.cache objectForKey:key];
    
}

- (NSNumber *)likeCountForPhoto:(PhotoponModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kPhotoponMediaAttributesCommentersKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForPhoto:(PhotoponModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kPhotoponMediaAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSArray *)likersForPhoto:(PhotoponModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kPhotoponMediaAttributesLikersKey];
    }
    
    return [NSArray array];
}

- (NSArray *)commentersForPhoto:(PhotoponModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kPhotoponMediaAttributesCommentersKey];
    }
    
    return [NSArray array];
}

- (void)setPhotoIsLikedByCurrentUser:(PhotoponMediaModel *)photo liked:(BOOL)liked {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:kPhotoponMediaAttributesDidLikeBoolKey];
    [self setAttributes:attributes forMedia:photo];
}

- (BOOL)isPhotoLikedByCurrentUser:(PhotoponModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [[attributes objectForKey:kPhotoponMediaAttributesDidLikeBoolKey] boolValue];
    }
    
    return NO;
}

- (void)incrementLikerCountForPhoto:(PhotoponMediaModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:likerCount forKey:kPhotoponMediaAttributesLikeCountKey];
    [self setAttributes:attributes forMedia:photo];
}

- (void)decrementLikerCountForPhoto:(PhotoponMediaModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] - 1];
    if ([likerCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:likerCount forKey:kPhotoponMediaAttributesLikeCountKey];
    [self setAttributes:attributes forMedia:photo];
}

- (void)incrementCommentCountForPhoto:(PhotoponMediaModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:commentCount forKey:kPhotoponMediaAttributesCommentCountKey];
    [self setAttributes:attributes forMedia:photo];
}

- (void)decrementCommentCountForPhoto:(PhotoponMediaModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:commentCount forKey:kPhotoponMediaAttributesCommentCountKey];
    [self setAttributes:attributes forMedia:photo];
}

- (void)setAttributesForUser:(PhotoponUserModel *)user photoCount:(NSNumber *)count followedByCurrentUser:(BOOL)following {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count,kPhotoponUserAttributesMediaCountKey,
                                [NSNumber numberWithBool:following],kPhotoponUserAttributesDidFollowKey,
                                nil];
    [self setAttributes:attributes forUser:user];
}

- (NSDictionary *)attributesForUser:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSNumber *)photoCountForUser:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *photoCount = [attributes objectForKey:kPhotoponUserAttributesMediaCountKey];
        if (photoCount) {
            return photoCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)followStatusForUser:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kPhotoponUserAttributesDidFollowKey];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }
    
    return NO;
}

- (void)setPhotoCount:(NSNumber *)count user:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kPhotoponUserAttributesMediaCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowStatus:(BOOL)following user:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kPhotoponUserAttributesDidFollowKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFacebookFriends:(NSArray *)friends {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = kPhotoponUserDefaultsCacheFacebookFriendsKey;
    [self.cache setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)facebookFriends {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = kPhotoponUserDefaultsCacheFacebookFriendsKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (friends) {
        [self.cache setObject:friends forKey:key];
    }
    
    return friends;
}


#pragma mark - ()

- (void)setAttributes:(NSDictionary *)attributes forEntity:(PhotoponModel *)entity {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = [self keyForEntity:entity];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forMedia:(PhotoponMediaModel *)media {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = [self keyForMedia:media];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forCoupon:(PhotoponCouponModel *)coupon {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = [self keyForCoupon:coupon];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forPlace:(PhotoponPlaceModel *)place {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = [self keyForPlace:place];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForEntity:(PhotoponModel *)entity {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@_%@", [entity className], [entity objectId]];
}

- (NSString *)keyForMedia:(PhotoponModel *)photo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"media_%@", [photo objectId]];
}

- (NSString *)keyForCoupon:(PhotoponCouponModel *)coupon {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"coupon_%@", [coupon objectId]];
}

- (NSString *)keyForPlace:(PhotoponPlaceModel *)place {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"place_%@", [place objectId]];
}

- (NSString *)keyForUser:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

@end