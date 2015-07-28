//
//  PAPCache.h
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "PhotoponModel.h"
//#import "PhotoponUserModel.h"

@class PhotoponModel;
@class PhotoponUserModel;
@class PhotoponPlaceModel;
@class PhotoponCouponModel;


@interface PhotoponCache : NSObject
{
    
}
+ (id)sharedCache;
- (void)clear;


- (void)setAttributesForMedia:(PhotoponMediaModel *)media likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
- (NSDictionary *)attributesForMedia:(PhotoponMediaModel *)media;
- (NSNumber *)likeCountForPhoto:(PhotoponMediaModel *)photo;
- (NSNumber *)commentCountForPhoto:(PhotoponMediaModel *)photo;
- (NSArray *)likersForPhoto:(PhotoponMediaModel *)photo;
- (NSArray *)commentersForPhoto:(PhotoponMediaModel *)photo;
- (void)setPhotoIsLikedByCurrentUser:(PhotoponMediaModel *)photo liked:(BOOL)liked;
- (BOOL)isPhotoLikedByCurrentUser:(PhotoponMediaModel *)photo;
- (void)incrementLikerCountForPhoto:(PhotoponMediaModel *)photo;
- (void)decrementLikerCountForPhoto:(PhotoponMediaModel *)photo;
- (void)incrementCommentCountForPhoto:(PhotoponMediaModel *)photo;
- (void)decrementCommentCountForPhoto:(PhotoponMediaModel  *)photo;

- (NSDictionary *)attributesForUser:(PhotoponUserModel *)user;
- (void)setAttributes:(NSDictionary *)attributes forEntity:(PhotoponModel *)entity;

- (NSNumber *)photoCountForUser:(PhotoponUserModel *)user;
- (BOOL)followStatusForUser:(PhotoponUserModel *)user;
- (void)setPhotoCount:(NSNumber *)count user:(PhotoponUserModel *)user;
- (void)setFollowStatus:(BOOL)following user:(PhotoponUserModel *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;






// NEW
- (void)setAttributesForMedia:(PhotoponMediaModel *)media likers:(NSArray *)likers commenters:(NSArray *)commenters snippers:(NSArray *)snippers likedByCurrentUser:(BOOL)likedByCurrentUser snippedByCurrentUser:(BOOL)snippedByCurrentUser;

- (NSDictionary *)attributesForPhotoponMedia:(PhotoponMediaModel *)media;

- (NSNumber *)likeCountForPhotopon:(PhotoponMediaModel *)photo;
- (NSNumber *)commentCountForPhoto:(PhotoponMediaModel *)photo;
- (NSArray *)likersForPhoto:(PhotoponMediaModel *)photo;
- (NSArray *)commentersForPhoto:(PhotoponMediaModel *)photo;
- (void)setPhotoIsLikedByCurrentUser:(PhotoponMediaModel *)photo liked:(BOOL)liked;
- (BOOL)isPhotoLikedByCurrentUser:(PhotoponMediaModel *)photo;
- (void)incrementLikerCountForPhoto:(PhotoponMediaModel *)photo;
- (void)decrementLikerCountForPhoto:(PhotoponMediaModel *)photo;
- (void)incrementCommentCountForPhoto:(PhotoponMediaModel *)photo;
- (void)decrementCommentCountForPhoto:(PhotoponMediaModel  *)photo;

- (NSDictionary *)attributesForUser:(PhotoponUserModel *)user;
- (void)setAttributes:(NSDictionary *)attributes forEntity:(PhotoponModel *)entity;

- (NSNumber *)photoCountForUser:(PhotoponUserModel *)user;
- (BOOL)followStatusForUser:(PhotoponUserModel *)user;
- (void)setPhotoCount:(NSNumber *)count user:(PhotoponUserModel *)user;
- (void)setFollowStatus:(BOOL)following user:(PhotoponUserModel *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;





@end
