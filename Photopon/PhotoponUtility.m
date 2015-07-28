//
//  PhotoponUtility.m
//  Photopon
//
//  Created by Brad McEvilly on 5/22/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponUtility.h"
#import "UIImage+ResizeAdditions.h"
#import "PhotoponACL.h"
#import "PhotoponUserModel.h"
#import "PhotoponConstants.h"
#import "PhotoponModelManager.h"
#import "PhotoponMediaModel.h"
#import "Photopon8CouponsModel.h"
#import "PhotoponActivityModel.h"
#import "PhotoponAppDelegate.h"
#import "WPXMLRPCClient.h"

#import "PhotoponAdapterUtils.h"
#import "NSDate+Helper.h"
#import "NSDate-Utilities.h"
#import "DateUtils.h"


@implementation PhotoponUtility
#pragma mark - PhotoponUtility
#pragma mark Like Photos

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    /*
    
    PhotoponQuery *queryExistingLikes = [PhotoponQuery queryWithClassName:kPhotoponActivityClassKey];
    [queryExistingLikes whereKey:kPhotoponActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kPhotoponActivityTypeKey equalTo:kPhotoponActivityTypeLike];
    [queryExistingLikes whereKey:kPhotoponActivityFromUserKey equalTo:[PhotoponUser currentUser]];
    [queryExistingLikes setCachePolicy:kPhotoponCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PhotoponModel *activity in activities) {
                [activity delete];
            }
        }
        
        // proceed to creating new like
        PhotoponModel *likeActivity = [PhotoponModel objectWithClassName:kPhotoponActivityClassKey];
        [likeActivity setObject:kPhotoponActivityTypeLike forKey:kPhotoponActivityTypeKey];
        [likeActivity setObject:[PhotoponUserModel currentUser] forKey:kPhotoponActivityFromUserKey];
        [likeActivity setObject:[photo objectForKey:kPhotoponMediaAttributesUserKey] forKey:kPhotoponActivityToUserKey];
        [likeActivity setObject:photo forKey:kPhotoponActivityPhotoKey];
        
        PhotoponACL *likeACL = [PhotoponACL ACLWithUser:[PhotoponUserModel currentUser]];
        [likeACL setPublicReadAccess:YES];
        [likeACL setWriteAccess:YES forUser:[photo objectForKey:kPhotoponPhotoUserKey]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
            // refresh cache
            PhotoponQuery *query = [PhotoponUtility queryForActivitiesOnPhoto:photo cachePolicy:kPhotoponCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PhotoponModel *activity in objects) {
                        if ([[activity objectForKey:kPhotoponActivityTypeKey] isEqualToString:kPhotoponActivityTypeLike] && [activity objectForKey:kPhotoponActivityFromUserKey]) {
                            [likers addObject:[activity objectForKey:kPhotoponActivityFromUserKey]];
                        } else if ([[activity objectForKey:kPhotoponActivityTypeKey] isEqualToString:kPhotoponActivityTypeComment] && [activity objectForKey:kPhotoponActivityFromUserKey]) {
                            [commenters addObject:[activity objectForKey:kPhotoponActivityFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kPhotoponActivityFromUserKey] objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
                            if ([[activity objectForKey:kPhotoponActivityTypeKey] isEqualToString:kPhotoponActivityTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[PhotoponCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];
            
        }];
    }];
     */
    
}

+(NSString*)photoponDateStringWith8CouponsDateString:(NSString*)dateString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            dateString = %@", dateString);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [[PhotoponUtility photopon8CouponsDateWithString:dateString] stringWithFormat:[NSDate dbFormatString]] = %@", [[PhotoponUtility photopon8CouponsDateWithString:dateString] stringWithFormat:[NSDate dbFormatString]]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[NSDate date] stringWithFormat:
    return [[PhotoponUtility photopon8CouponsDateWithString:dateString] stringWithFormat:[NSDate dbFormatString]];
}

+(NSString*)photoponDateStringWith8CouponsExpirationDateString:(NSString*)dateString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            dateString = %@", dateString);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [[PhotoponUtility photopon8CouponsExpirationDateWithString:dateString] stringWithFormat:[NSDate dbFormatString]] = %@", [[PhotoponUtility photopon8CouponsExpirationDateWithString:dateString] stringWithFormat:[NSDate dbFormatString]]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    return [[PhotoponUtility photopon8CouponsExpirationDateWithString:dateString] stringWithFormat:[NSDate dbFormatString]];
}

+(NSDate*)photopon8CouponsExpirationDateWithString:(NSString*)dateString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            dateString = %@", dateString);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataExpirationDateFormat] = %@", [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataExpirationDateFormat]);
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataExpirationDateFormat];
}

+(NSDate*)photopon8CouponsDateWithString:(NSString*)dateString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            dateString = %@", dateString);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataDateFormat] = %@", [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataDateFormat]);
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataDateFormat];
}

+(NSString*)photoponDateTextWithString:(NSString*)dateString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    NSDateFormatter *photoponDF = [PhotoponUtility photoponDateFormatter];
    
    //[PhotoponUtility ]
    [photoponDF setDateFormat:@"MM/DD/yyyy"];
    [PhotoponUtility photoponDateWithString:dateString];
    */
    
    
    
    return [[PhotoponUtility photoponDateWithString:dateString] stringWithFormat:kPhotoponDateTextFormat];
    
}

+(NSDate*)photoponDateWithString:(NSString*)dateString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            dateString = %@", dateString);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDateFormatter *df = [PhotoponUtility photoponDateFormatter];
    if (df) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"                    if (df) {       ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if ([df dateFromString:dateString]) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"                   if ([df dateFromString:dateString] {       ");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"            [df dateFromString:dateString] = %@", [df dateFromString:dateString]);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"            RETURNING RETURNING RETURNING       [df dateFromString:dateString]");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            return [df dateFromString:dateString];
        }
    }
    
    
    /*
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    
    [df2 setDateFormat:k8CouponsAPIReturnDataDateFormat];
    */
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataDateFormat = %@", [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataDateFormat]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSDate dateFromString:dateString withFormat:k8CouponsAPIReturnDataDateFormat];
    
}



+(NSDateFormatter*)photoponDateFormatter{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    @try {
        
        NSDateFormatter *postDateFormatter = [[NSDateFormatter alloc] init];
        [postDateFormatter setDateFormat:kPhotoponDateFormat];
        return postDateFormatter;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
    return nil;
    
}



+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    PhotoponQuery *queryExistingLikes = [PhotoponQuery queryWithClassName:kPhotoponActivityClassKey];
    [queryExistingLikes whereKey:kPhotoponActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kPhotoponActivityTypeKey equalTo:kPhotoponActivityTypeLike];
    [queryExistingLikes whereKey:kPhotoponActivityFromUserKey equalTo:[PhotoponUserModel currentUser]];
    [queryExistingLikes setCachePolicy:kPhotoponCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PhotoponModel *activity in activities) {
                [activity delete];
            }
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
            // refresh cache
            PhotoponQuery *query = [PhotoponUtility queryForActivitiesOnPhoto:photo cachePolicy:kPhotoponCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PhotoponModel *activity in objects) {
                        if ([[activity objectForKey:kPhotoponActivityTypeKey] isEqualToString:kPhotoponActivityTypeLike]) {
                            [likers addObject:[activity objectForKey:kPhotoponActivityFromUserKey]];
                        } else if ([[activity objectForKey:kPhotoponActivityTypeKey] isEqualToString:kPhotoponActivityTypeComment]) {
                            [commenters addObject:[activity objectForKey:kPhotoponActivityFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kPhotoponActivityFromUserKey] objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
                            if ([[activity objectForKey:kPhotoponActivityTypeKey] isEqualToString:kPhotoponActivityTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[PhotoponCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];
            
        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
     */
}

+ (BOOL)doesHaveCachedTimelineImage:(NSString*)imageCacheKey{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    
    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageCacheKey]];
    
    return ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]);
}

+ (UIImage*)timelineImageFromImageCacheKey:(NSString*)imageCacheKey{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@.jpg", imageCacheKey];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    //NSURL *timelineImageCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageCacheKey]];
    
    return [UIImage imageWithContentsOfFile:filepath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        // We have a cached Facebook profile picture
        
        UIImage *timelineImage = [[UIImage alloc] initWithContentsOfFile:filepath];
        
        return timelineImage;
    }
    return nil;
}

+ (void)cacheTimelineImageData:(NSData *)data mediaModel:(PhotoponMediaModel*)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (data.length == 0) {
        return;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Photopon.
    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@.jpg", media.entityKey];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSURL *timelinePhotoCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", media.entityKey]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[timelinePhotoCacheURL path]]) {
        // We have a cached Facebook profile picture
        
        NSData *oldTimelinePhotoData = [NSData dataWithContentsOfFile:[timelinePhotoCacheURL path]];
        
        if ([oldTimelinePhotoData isEqualToData:data]) {
            return;
        }
    }
    
    if (data.length > 0) {
        // save on low priority block
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:filepath contents:data attributes:nil];
            
        });
    }
    
    
    /*
     if (mediumImageData.length > 0) {
     PhotoponFile *fileMediumImage = [PhotoponFile fileWithData:mediumImageData];
     [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (!error) {
     [[PhotoponUserModel currentUser] setObject:fileMediumImage forKey:kPhotoponUserAttributesProfilePictureUrlKey];
     [[PhotoponUserModel currentUser] saveEventually];
     }
     }];
     }
     
     if (smallRoundedImageData.length > 0) {
     PhotoponFile *fileSmallRoundedImage = [PhotoponFile fileWithData:smallRoundedImageData];
     [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (!error) {
     [[PhotoponUserModel currentUser] setObject:fileSmallRoundedImage forKey:kPhotoponUserAttributesProfilePictureUrlKey];
     [[PhotoponUserModel currentUser] saveEventually];
     }
     }];
     }    
     */
    
}

+ (UIImage*)currentUserFacebookProfilePic{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [PhotoponUtility facebookLocalImageName];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            filepath = %@", self, NSStringFromSelector(_cmd), filepath);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([fileManager fileExistsAtPath:filepath]) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"File exists" message:[NSString stringWithFormat:@"Path: %@", filepath] cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
    }
    
    return [[UIImage alloc] initWithContentsOfFile:filepath];
}

+ (UIImage*)currentUserFacebookProfilePicSmall{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[PhotoponUtility currentUserFacebookProfilePic] thumbnailImage:64 transparentBorder:0 cornerRadius:6 interpolationQuality:kCGInterpolationLow];
}

+ (UIImage*)currentUserFacebookProfilePicMed{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[PhotoponUtility currentUserFacebookProfilePic] thumbnailImage:309 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
}

#pragma mark Facebook

+ (void)processFacebookProfilePictureData:(UIImage *)image{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate* appDelegate = (PhotoponAppDelegate*)[UIApplication sharedApplication].delegate;
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.90);//[[NSData alloc] initWithData: UIImageJPEGRepresentation(image, 0.90)];
        
        //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filename = [PhotoponUtility facebookLocalImageName];
        NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            filepath = %@", weakSelf, NSStringFromSelector(_cmd), filepath);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        /*
        if ([fileManager fileExistsAtPath:filepath]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Exists (processFPPD)"
                                                                message:[NSString stringWithFormat:@"Path: %@", filepath]
                                                               delegate:appDelegate
                                                      cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
            alertView.tag = 20;
            [alertView show];
        }
        */
        // save on low priority block
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //NSFileManager *fileManager = [NSFileManager defaultManager];
            //[fileManager createFileAtPath:filepath contents:image attributes:nil];
            
            
            // upload to photopon server
            
            NSString *mimeType  = @"image/jpeg";
            
            NSLog(@"-");
            NSLog(@"-");
            NSLog(@"----------->    here 2");
            NSLog(@"-");
            NSLog(@"-");
            
            
            //NSString *tmpName   = [[[NSString alloc] initWithString:self.filename] retain];
            //NSString *tmpName   = [[[NSString alloc] initWithFormat:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/%@", self.filename] retain];
            
            //NSString *tmpName   = filepath;
            
            NSLog(@"-");
            NSLog(@"-");
            NSLog(@"----------->    here 3");
            NSLog(@"-");
            NSLog(@"-");
            
            //NSString *tmpName   = [[[NSString alloc] initWithString:@"/tmp"] retain];
            //NSString *tmpName   = [[[NSString alloc] initWithString:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/"] retain];
            
            NSNumber *fileSize = [[NSNumber alloc] initWithFloat:imageData.length/1024];
            
            NSDictionary *pComRequestArray = [NSDictionary dictionaryWithObjectsAndKeys:
                                              mimeType, @"type",
                                              kFacebookProfileImageName, @"name",
                                              filepath, @"tmp_name",
                                              fileSize, @"size",
                                              [NSNumber numberWithInteger:0], @"error",
                                              [NSInputStream inputStreamWithFileAtPath:filepath], @"bits",
                                              nil];
            
            
            NSLog(@"-");
            NSLog(@"-");
            NSLog(@"----------->    here 4");
            NSLog(@"-");
            NSLog(@"-");
            
            
            /*
            NSArray *paramSignupCredentialsArray = [[[NSArray alloc] initWithObjects:self.username, self.password, nil] autorelease];//, [NSArray arrayWithObjects: email, firstname, lastname, facebookid, sex, birthday];
            NSArray *paramSignupAdditionalArray = [[[NSArray alloc] initWithObjects:self.email, self.firstname, self.lastname, self.facebookid, self.sex, self.birthday, nil] autorelease];
            
            NSMutableArray *parameters = [[[NSMutableArray alloc] initWithArray:paramSignupCredentialsArray] autorelease];
            
            [parameters addObject:paramSignupAdditionalArray];
            
            NSArray *parametersFinal = [[[NSArray alloc] initWithArray:parameters] retain];
            
            
            //[self.pComApi photoponRegisterUserWithInfo: parametersFinal withSuccess:^(NSArray *responseInfo)
            
            [self.pComApi photoponRegisterUserWithInfo: parametersFinal withSuccess:^(NSArray *responseInfo) {
                */
                
                //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                
                
                NSArray *parameters = [[NSArray alloc] initWithArray:[appDelegate.pmm getXMLRPCArgsWithExtra:pComRequestArray]];
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                NSLog(@"-|");
                NSLog(@"-|");
                NSLog(@"dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {");
                NSLog(@"-|");
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
            
            //getMyGallery
            //WPXMLRPCClient *api = [WPXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
            //appDelegate.pmm.api
            
            NSMutableURLRequest *request = [appDelegate.pmm.api  requestWithMethod:kPhotoponAPIMethodUploadProfilePhoto parameters:parameters];
            
            //[appDelegate.photoponTabBarViewController showPhotoponUploadProgressBar];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                NSLog(@"-|");
                NSLog(@"-|");
                NSLog(@"dispatch_async(dispatch_get_main_queue(), ^(void) {");
                NSLog(@"-|");
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                
                //X [self.photoponNewPhotoponHUDViewController showUploadProgress:uploadController.photoponProgressBar];
                
                AFHTTPRequestOperation *operation = [appDelegate.pmm.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                    NSLog(@"-|");
                    NSLog(@"-|");
                    NSLog(@"AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:....");
                    NSLog(@"        SUCCESS SUCCESS SUCCESS ");
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
                    
                    NSDictionary *response = (NSDictionary *)responseObject;
                    //if([response objectForKey:@"videopress_shortcode"] != nil)
                    //self.shortcode = [response objectForKey:@"videopress_shortcode"];
                    
                    if(([response objectForKey:@"confirmation"] != nil) && ([response objectForKey:@"confirmation"]) ){
                        
                        // [self close];
                        
                        /*
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"Confirmed! Upload Successful!", @"")
                         message:[response objectForKey:@"message"]
                         delegate:self
                         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                         alertView.tag = 20;
                         [alertView show];
                         [alertView release];
                         */
                        
                        
                    }else {
                        
                        /*
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"NOT CONFIRMED! Upload Successful!", @"")
                         message:[response objectForKey:@"message"]
                         delegate:self
                         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                         alertView.tag = 20;
                         [alertView show];
                         [alertView release];
                         */
                        
                        
                    }
                    /*
                     //self.remoteURL = [response objectForKey:@"url"];
                     
                     if ([response objectForKey:@"id"] != nil) {
                     //self.mediaID = [[response objectForKey:@"id"] numericValue];
                     }
                     
                     self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
                     [_uploadOperation release]; _uploadOperation = nil;
                     if (success) success();
                     
                     / *
                     if([self.mediaType isEqualToString:@"video"]) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                     object:self
                     userInfo:response];
                     } else {
                     */
                    
                    
                    //[[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful object:self userInfo:response];
                    
                    //}
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                    NSLog(@"-|");
                    NSLog(@"-|");
                    NSLog(@"AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:....");
                    NSLog(@"        FAILURE FAILURE FAILURE ");
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    
                    
                    
                    //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
                    
                    //self.remoteStatus = PhotoponModelRemoteStatusFailed;
                    //X [_uploadOperation release]; _uploadOperation = nil;
                    //if (failure) failure(error);
                }];
                [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                    NSLog(@"-|");
                    NSLog(@"-|");
                    NSLog(@"[operation setUploadProgressBlock:^(NSInteger bytesWritten ...");
                    NSLog(@"        ");
                    NSLog(@"        ");
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                        NSLog(@"-|");
                        NSLog(@"-|");
                        NSLog(@"[operation setUploadProgressBlock:^(NSInteger bytesWritten ...");
                        NSLog(@"        ");
                        NSLog(@"        ");
                        NSLog(@"dispatch_async(dispatch_get_main_queue(), ^(void) {");
                        NSLog(@"        ");
                        NSLog(@"        ");
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        
                        
                    });
                }];
                //X _uploadOperation = [operation retain];
                [appDelegate.pmm.api enqueueHTTPRequestOperation:operation];
            });
        });
        
        
        
        
        
        
    });
    
}







    //self.filenameRaw = filename;
    //self.localURLRaw = filepath;

    //[[NSUserDefaults standardUserDefaults] synchronize];



    /*
    if (image) {
        return;
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 50.0f);
    
    __weak __typeof(&*self)weakSelf = self;
    
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Photopon.
    
    //NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    
    PhotoponAppDelegate* appDelegate = (PhotoponAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [PhotoponUtility facebookLocalImageName];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            filepath = %@", self, NSStringFromSelector(_cmd), filepath);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:kFacebookProfileImageName];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        // We have a cached Facebook profile picture
        
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:filepath];
        
        if ([oldProfilePictureData isEqualToData:data]) {
            return;
        }
    }
    
    if (data.length > 0) {
        
        //UIImage * medImg = [UIImage imageWithData:mediumImageData];
        
        // save on low priority block
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
     
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:filepath contents:image attributes:nil];
            
            
            // upload to photopon server
            
            NSString *mimeType  = @"image/jpeg";
            
            NSLog(@"-");
            NSLog(@"-");
            NSLog(@"----------->    here 2");
            NSLog(@"-");
            NSLog(@"-");
            
            
            //NSString *tmpName   = [[[NSString alloc] initWithString:self.filename] retain];
            //NSString *tmpName   = [[[NSString alloc] initWithFormat:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/%@", self.filename] retain];
            
            //NSString *tmpName   = filepath;
            
            NSLog(@"-");
            NSLog(@"-");
            NSLog(@"----------->    here 3");
            NSLog(@"-");
            NSLog(@"-");
            
            //NSString *tmpName   = [[[NSString alloc] initWithString:@"/tmp"] retain];
            //NSString *tmpName   = [[[NSString alloc] initWithString:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/"] retain];
            
            NSNumber *fileSize = [[NSNumber alloc] initWithFloat:newProfilePictureData.length/1024];
            
            NSDictionary *pComRequestArray = [NSDictionary dictionaryWithObjectsAndKeys:
                                              mimeType, @"type",
                                              kFacebookProfileImageName, @"name",
                                              filepath, @"tmp_name",
                                              fileSize, @"size",
                                              [NSNumber numberWithInteger:0], @"error",
                                              [NSInputStream inputStreamWithFileAtPath:filepath], @"bits",
                                              nil];
            
            
            NSLog(@"-");
            NSLog(@"-");
            NSLog(@"----------->    here 4");
            NSLog(@"-");
            NSLog(@"-");
            
            
            / *
             NSArray *paramSignupCredentialsArray = [[[NSArray alloc] initWithObjects:self.username, self.password, nil] autorelease];//, [NSArray arrayWithObjects: email, firstname, lastname, facebookid, sex, birthday];
             NSArray *paramSignupAdditionalArray = [[[NSArray alloc] initWithObjects:self.email, self.firstname, self.lastname, self.facebookid, self.sex, self.birthday, nil] autorelease];
             
             NSMutableArray *parameters = [[[NSMutableArray alloc] initWithArray:paramSignupCredentialsArray] autorelease];
             
             [parameters addObject:paramSignupAdditionalArray];
             
             NSArray *parametersFinal = [[[NSArray alloc] initWithArray:parameters] retain];
             
             
             //[self.pComApi photoponRegisterUserWithInfo: parametersFinal withSuccess:^(NSArray *responseInfo)
             
             [self.pComApi photoponRegisterUserWithInfo: parametersFinal withSuccess:^(NSArray *responseInfo) {
             * /
            
            //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            
            NSArray *parameters = [[NSArray alloc] initWithArray:[appDelegate.pmm getXMLRPCArgsWithExtra:pComRequestArray]];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
            NSLog(@"-|");
            NSLog(@"-|");
            NSLog(@"dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {");
            NSLog(@"-|");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
                
                //getMyGallery
                //WPXMLRPCClient *api = [WPXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
                //appDelegate.pmm.api
                
                NSMutableURLRequest *request = [appDelegate.pmm.api  requestWithMethod:kPhotoponAPIMethodUploadProfilePhoto parameters:parameters];
                
                //[appDelegate.photoponTabBarViewController showPhotoponUploadProgressBar];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                    NSLog(@"-|");
                    NSLog(@"-|");
                    NSLog(@"dispatch_async(dispatch_get_main_queue(), ^(void) {");
                    NSLog(@"-|");
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    
                    
                    //X [self.photoponNewPhotoponHUDViewController showUploadProgress:uploadController.photoponProgressBar];
                    
                    AFHTTPRequestOperation *operation = [appDelegate.pmm.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                        NSLog(@"-|");
                        NSLog(@"-|");
                        NSLog(@"AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:....");
                        NSLog(@"        SUCCESS SUCCESS SUCCESS ");
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
                        
                        NSDictionary *response = (NSDictionary *)responseObject;
                        //if([response objectForKey:@"videopress_shortcode"] != nil)
                        //self.shortcode = [response objectForKey:@"videopress_shortcode"];
                        
                        if(([response objectForKey:@"confirmation"] != nil) && ([response objectForKey:@"confirmation"]) ){
                            
                            // [self close];
                            
                            /*
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"Confirmed! Upload Successful!", @"")
                             message:[response objectForKey:@"message"]
                             delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                             alertView.tag = 20;
                             [alertView show];
                             [alertView release];
                             * /
                            
                            
                        }else {
                            
                            /*
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"NOT CONFIRMED! Upload Successful!", @"")
                             message:[response objectForKey:@"message"]
                             delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                             alertView.tag = 20;
                             [alertView show];
                             [alertView release];
                             * /
                            
                            
                        }
                        /*
                         //self.remoteURL = [response objectForKey:@"url"];
                         
                         if ([response objectForKey:@"id"] != nil) {
                         //self.mediaID = [[response objectForKey:@"id"] numericValue];
                         }
                         
                         self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
                         [_uploadOperation release]; _uploadOperation = nil;
                         if (success) success();
                         
                         / *
                         if([self.mediaType isEqualToString:@"video"]) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                         object:self
                         userInfo:response];
                         } else {
                         * /
                        
                        
                        //[[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful object:self userInfo:response];
                        
                        //}
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                        NSLog(@"-|");
                        NSLog(@"-|");
                        NSLog(@"AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:....");
                        NSLog(@"        FAILURE FAILURE FAILURE ");
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        
                        
                        
                        //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
                        
                        //self.remoteStatus = PhotoponModelRemoteStatusFailed;
                        //X [_uploadOperation release]; _uploadOperation = nil;
                        //if (failure) failure(error);
                    }];
                    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                        
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                        NSLog(@"-|");
                        NSLog(@"-|");
                        NSLog(@"[operation setUploadProgressBlock:^(NSInteger bytesWritten ...");
                        NSLog(@"        ");
                        NSLog(@"        ");
                        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            
                            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                            NSLog(@"%@ :: %@            ", weakSelf, NSStringFromSelector(_cmd));
                            NSLog(@"-|");
                            NSLog(@"-|");
                            NSLog(@"[operation setUploadProgressBlock:^(NSInteger bytesWritten ...");
                            NSLog(@"        ");
                            NSLog(@"        ");
                            NSLog(@"dispatch_async(dispatch_get_main_queue(), ^(void) {");
                            NSLog(@"        ");
                            NSLog(@"        ");
                            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                            
                            
                        });
                    }];
                    //X _uploadOperation = [operation retain];
                    [appDelegate.pmm.api enqueueHTTPRequestOperation:operation];
                });
            });
            
            
            
            
            
            
        });
        
    }
    
    
    / *
    
    UIImage *image = [UIImage imageWithData:newProfilePictureData];
    
    UIImage *mediumImage = [image thumbnailImage:309 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:6 interpolationQuality:kCGInterpolationLow];
    
    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
    
    if (mediumImageData.length > 0) {
        
        //UIImage * medImg = [UIImage imageWithData:mediumImageData];
        
        // save on low priority block
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:[profilePictureCacheURLMed path] contents:mediumImageData attributes:nil];
            
        });
        
    }
    
        / *
        PhotoponFile *fileMediumImage = [PhotoponFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PhotoponUserModel currentUser] setObject:fileMediumImage forKey:kPhotoponUserAttributesProfilePictureUrlKey];
                [[PhotoponUserModel currentUser] saveEventually];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        PhotoponFile *fileSmallRoundedImage = [PhotoponFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PhotoponUserModel currentUser] setObject:fileSmallRoundedImage forKey:kPhotoponUserAttributesProfilePictureUrlKey];
                [[PhotoponUserModel currentUser] saveEventually];
            }
        }];
    }*/
//}

+ (BOOL)userHasValidFacebookData:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *facebookId = [user objectForKey:kPhotoponUserAttributesFacebookIDKey];
    return (facebookId && facebookId.length > 0);
}

+ (BOOL)userHasProfilePictures:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponFile *profileCoverPicture = [user objectForKey:kPhotoponUserAttributesProfileCoverPictureUrlKey];
    PhotoponFile *profilePicture = [user objectForKey:kPhotoponUserAttributesProfilePictureUrlKey];
    
    return (profileCoverPicture && profilePicture);
}


#pragma mark Display Name

+ (NSString *)firstNameForDisplayName:(NSString *)displayName {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!displayName || displayName.length == 0) {
        return @"Someone";
    }
    
    NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [displayNameComponents objectAtIndex:0];
    if (firstName.length > 100) {
        // truncate to 100 so that it fits in a Push payload
        firstName = [firstName substringToIndex:100];
    }
    return firstName;
}


#pragma mark User Following

+ (void)followUserInBackground:(PhotoponUserModel *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([[user objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
        return;
    }
    
    NSMutableDictionary *followActivityDict = [[NSMutableDictionary alloc] init];
    
    //PhotoponActivityModel *followActivity = [PhotoponActivityModel  objectWithClassName:kPhotoponActivityClassKey];
    [followActivityDict setObject:[PhotoponUserModel currentUser] forKey:kPhotoponActivityAttributesFromUserKey];
    [followActivityDict setObject:user forKey:kPhotoponActivityAttributesToUserKey];
    [followActivityDict setObject:kPhotoponActivityAttributesTypeFollow forKey:kPhotoponActivityAttributesTypeKey];
    
    PhotoponActivityModel *followActivity = [PhotoponActivityModel modelWithDictionary:followActivityDict];
    
    
    
    PhotoponACL *followACL = [PhotoponACL ACLWithUser:[PhotoponUserModel currentUser]];
    [followACL setPublicReadAccess:YES];
    //followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
    }];
    [[PhotoponCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PhotoponUserModel *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if ([[user objectId] isEqualToString:[[PhotoponUserModel currentUser] objectId]]) {
        return;
    }
    
    PhotoponModel *followActivity = [PhotoponModel objectWithClassName:kPhotoponActivityClassKey];
    [followActivity setObject:[PhotoponUserModel currentUser] forKey:kPhotoponActivityAttributesFromUserKey];
    [followActivity setObject:user forKey:kPhotoponActivityAttributesToUserKey];
    [followActivity setObject:kPhotoponActivityAttributesTypeFollow forKey:kPhotoponActivityAttributesTypeKey];
    
    PhotoponACL *followACL = [PhotoponACL ACLWithUser:[PhotoponUserModel currentUser]];
    [followACL setPublicReadAccess:YES];
    //followActivity.ACL = followACL;
    
    [followActivity saveEventually:completionBlock];
    [[PhotoponCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    for (PhotoponUserModel *user in users) {
        [PhotoponUtility followUserEventually:user block:completionBlock];
        [[PhotoponCache sharedCache] setFollowStatus:YES user:user];
    }
}

+ (void)unfollowUserEventually:(PhotoponUserModel *)user {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    /*
    PhotoponQuery *query = [PhotoponQuery queryWithClassName:kPhotoponActivityClassKey];
    [query whereKey:kPhotoponActivityFromUserKey equalTo:[PhotoponUserModel currentUser]];
    [query whereKey:kPhotoponActivityToUserKey equalTo:user];
    [query whereKey:kPhotoponActivityTypeKey equalTo:kPhotoponActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        
        if (!error) {
            for (PhotoponModel *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    }];
    [[PhotoponCache sharedCache] setFollowStatus:NO user:user];
     */
}

+ (void)unfollowUsersEventually:(NSArray *)users {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    PhotoponQuery *query = [PhotoponQuery queryWithClassName:kPhotoponActivityClassKey];
    [query whereKey:kPhotoponActivityFromUserKey equalTo:[PhotoponUserModel currentUser]];
    [query whereKey:kPhotoponActivityToUserKey containedIn:users];
    [query whereKey:kPhotoponActivityTypeKey equalTo:kPhotoponActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        for (PhotoponModel *activity in activities) {
            [activity deleteEventually];
        }
    }];
    for (PhotoponUserModel *user in users) {
        [[PhotoponCache sharedCache] setFollowStatus:NO user:user];
    }
     */
}

#pragma mark Activities

+ (PhotoponQuery *)queryForActivitiesOnPhoto:(PhotoponModel *)photo cachePolicy:(PhotoponCachePolicy)cachePolicy {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    PhotoponQuery *queryLikes = [PhotoponQuery queryWithClassName:kPhotoponActivityClassKey];
    [queryLikes whereKey:kPhotoponActivityPhotoKey equalTo:photo];
    [queryLikes whereKey:kPhotoponActivityTypeKey equalTo:kPhotoponActivityTypeLike];
    
    PhotoponQuery *queryComments = [PhotoponQuery queryWithClassName:kPhotoponActivityClassKey];
    [queryComments whereKey:kPhotoponActivityPhotoKey equalTo:photo];
    [queryComments whereKey:kPhotoponActivityTypeKey equalTo:kPhotoponActivityTypeComment];
    
    PhotoponQuery *query = [PhotoponQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kPhotoponActivityFromUserKey];
    [query includeKey:kPhotoponActivityPhotoKey];
    
    return query;
     */
    return nil;
}


#pragma mark Shadow Rendering

+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 3.0f, rect.origin.y, rect.size.width + 6.0f, rect.size.height + 3.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 3.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y - 3.0f,
                                          rect.size.width,
                                          rect.size.height + 3.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 3.0f, rect.origin.y - 3.0f, rect.size.width + 6.0f, rect.size.height + 3.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 3.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y,
                                          rect.size.width,
                                          rect.size.height + 3.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 3.0f, rect.origin.y, rect.size.width + 6.0f, rect.size.height));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 3.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y - 3.0f,
                                          rect.size.width,
                                          rect.size.height + 3.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, navigationController.navigationBar.frame.size.height, navigationController.navigationBar.frame.size.width, 3.0f)];
    [gradientView setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    navigationController.navigationBar.clipsToBounds = NO;
    [navigationController.navigationBar addSubview:gradientView];	    
}

+ (NSString*)facebookLocalImageName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSString alloc] initWithFormat:@"%@", kFacebookProfileImageName];
}

+ (NSString*)facebookGraphBasePath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponUserModel *user = [PhotoponUserModel currentUser];
    return [NSString stringWithFormat:kFacebookGraphBasePath, user.facebookID];
}

+ (NSString*)facebookProfilePicLinkStr{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@%@", [PhotoponUtility facebookGraphBasePath], @"picture?width=400&height=400"];
}

+ (NSURL*)facebookProfilePicLinkURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSURL URLWithString:[PhotoponUtility facebookProfilePicLinkStr]];
}

+ (NSMutableURLRequest *)imageRequestWithURL:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad; // this will make sure the request always returns the cached image
    request.HTTPShouldHandleCookies = NO;
    request.HTTPShouldUsePipelining = YES;
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    return request;
}

+(NSString*)appShareUrl{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSString stringWithFormat:@"%@", kAppShareURL];
}

+(NSString*)appShareMessage{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // method, key, lat, lon, radius, limit
    return [[NSString alloc] initWithFormat:kAppShareMessage,
            [PhotoponUtility appShareUrl]];
}

/**
 @params prefiltered nib name
 returns nib name filtered for device
 */
+(NSString*)deviceNibName:(NSString*)nibName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSString alloc] initWithFormat:@"%@%@", nibName, [PhotoponUtility deviceSuffix]];
}

+(BOOL)isTallScreen{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (IS_IPAD) {
        return YES;
    }
    
    return ([[UIScreen mainScreen] bounds].size.height >480)?YES:NO;
}

+(NSString*)deviceSuffix{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (IS_IPAD)
        return [NSString stringWithFormat:@"%@", kPhotoponDeviceSuffixIPad];
    if ([PhotoponUtility isTallScreen])
        return [NSString stringWithFormat:@"%@", kPhotoponDeviceSuffixIPhoneTall];
    return @"";
}

- (void)shareText:(NSString *)string andImage:(UIImage *)image
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (string) {
        [sharingItems addObject:string];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] navController] presentViewController:activityController animated:YES completion:nil];
    
}

#pragma mark 
#pragma mark - PHOTOPON FONTS


/**
 
 
 [self.offerOverlay.photoponOfferValue setFont:[PhotoponUtility photoponFontBoldForOfferValue]];
 [self.offerOverlay.photoponOfferDetails setFont:[PhotoponUtility photoponFontBoldForOfferTitle]];
 [self.offerOverlay.photoponPersonalMessage setFont:[PhotoponUtility photoponFontBoldForOfferPersonalCaption]];
 
 */



+ (UIFont *)photoponFontLightForBrand:(CGFloat)fontSize {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontLightBrand] size:fontSize];
}




+ (UIFont *)photoponFontBoldForBrand:(CGFloat)fontSize {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontBoldBrand] size:fontSize];
}

+ (UIFont *)photoponFontBoldForOfferValue{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontBoldOffer] size:32.0f];
}


+ (UIFont *)photoponFontBoldForOfferTitle{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontRegularOffer] size:32.0f];
}


+ (UIFont *)photoponFontBoldForOfferPersonalCaption{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontFamilyOfferCaption] size:22.0f];
}

+ (UIFont *)photoponFontRegularForOfferValue:(CGFloat)fontSize{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontRegularOffer] size:fontSize];
}

+ (UIFont *)photoponFontRegularForBrand:(CGFloat)fontSize {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontRegularBrand] size:fontSize];
}

+ (UIFont *)photoponFontRegularForOfferTitle:(CGFloat)fontSize{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@", kPhotoponFontRegularOffer] size:fontSize];
}

+ (void) formatBrandLabel:(UILabel*)brandLabel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    brandLabel.font = [PhotoponUtility photoponFontRegularForBrand:15.0f];
}



@end