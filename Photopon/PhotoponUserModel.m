//
//  PhotoponUserModel.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

//#import "PhotoponModel+Subclass.h"
#import "PhotoponUserModel.h"
//#import "PhotoponQuery.h"
#import "PhotoponAppDelegate.h"
#import "IGConnect.h"
#import <SSKeychain/SSKeychain.h>


@interface PhotoponUserModel ()

//@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation PhotoponUserModel

@synthesize hasBeenFetched;
@synthesize dictionary;
@synthesize leader;

static PhotoponUserModel* current = nil;
/*
@synthesize identifier;
@synthesize fullname;
@synthesize username;
@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize bio;
@synthesize website;
@synthesize profilePictureUrl;
@synthesize profileCoverPictureUrl;
@synthesize followedByCount;
@synthesize followersCount;
@synthesize redeemCount;
@synthesize mediaCount;
@synthesize score;

@synthesize followedByCountString;
@synthesize followersCountString;
@synthesize redeemCountString;
@synthesize mediaCountString;
@synthesize scoreString;
@synthesize didFollowString;

@synthesize twitterID;
@synthesize facebookID;
@synthesize instagramID;

@synthesize didFollowBool;
@synthesize didFollow;
*/

+ (PhotoponUserModel*)modelWithDictionary:(NSDictionary*)dict {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if (![dict isKindOfClass:[NSDictionary class]]) {
        //
        return nil;
    }
    */
    
    
    //PhotoponUserModel* pModel = [[[self class] alloc] init];
    
    
    
    // should not be using this method if no object identifier present
    if (![dict objectForKey:kPhotoponModelIdentifierKey]) {
        return nil;
    }
    
    PhotoponUserModel* pModel = [[PhotoponUserModel alloc] init];
    
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [pModel.dictionary setObject:kPhotoponUserClassName forKey:kPhotoponEntityNameKey];
    [pModel.dictionary setObject:[NSDate date] forKey:kPhotoponCreatedTimeKey];
    [pModel.dictionary setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
    
    return pModel;
    
}

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:[dicts count]];
    for (NSMutableDictionary* modelDict in dicts) {
        [models addObject:[PhotoponUserModel modelWithDictionary:modelDict]];
    }
    return models;
}

+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                                block:(PhotoponUserModelResultBlock)block{
	
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    block = [block copy];
    dispatch_queue_t q = dispatch_get_current_queue();
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
        
        PhotoponUserModel* c = [PhotoponUserModel currentUser];
        if(!c){
            
            /*
            PFQuery *query = [PFUser query];
            [query whereKey:kUserNameKey equalTo:username];
            DKQuery *andQuery = [query.dkQuery and];
            [andQuery whereKey:kUserPasswordKey equalTo:password];
            NSArray *array = [query findObjects:&error];
             
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
            if([array count] > 0)
                [PhotoponUserModel setCurrentUser:(PFUser*)[array objectAtIndex:0]];
            else
                [PhotoponUserModel setCurrentUser: nil];
             
             */
        
        
        
        
            PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
            [appDelegate.pmm syncProfileInfoWithSuccess:nil failure:nil];
        
        
        

            
            
            
        }
        
        if (block != NULL) {
            dispatch_async(q, ^{
                block(current, error);
            });
        }
    });
}

- (void) refreshInBackgroundWithTarget:(id)target selector:(SEL)selector{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponComApi *pComApi = [PhotoponComApi sharedApi];
    
    dispatch_queue_t q = dispatch_get_main_queue();
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
        
        [pComApi getProfileDataWithSuccess:^(NSArray *profileData) {
            
            if (selector != NULL) {
                dispatch_async(q, ^{
                    if([target respondsToSelector:selector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [target performSelector:selector withObject:(NSDictionary*)profileData withObject:error];
#pragma clang diagnostic pop
                    }
                });
            }
            
            
            
        } failure:^(NSError *failure) {
            
            
            
        }];
        
        
        //[self refresh:&error];
		//[self setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
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

- (void) refreshCurrentUserCallbackWithResult:(id)result error:(NSError*)error{
    
    if (!error) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)result];
        current = [[PhotoponUserModel alloc] initWithAttributes:dict];
        [[PhotoponUserModel currentUser] cacheUserAttributes];
    }
}

+ (BOOL) isLoggedIn{
    
    NSString *uid = [[EGOCache globalCache] stringForKey:kPhotoponUserAttributesCurrentUserKey];
    if (uid && (uid.length>0)) {
        // if we made it here then we know we have high probability that credentials are stored and accessible
        return YES;
    }
    return NO;
}

-(NSString*)identifier{
    return (NSString*)[self.dictionary objectForKey:kPhotoponUserAttributesIdentifierKey];
}
-(NSString*)fullname{
    return [self.dictionary objectForKey:kPhotoponUserAttributesFullNameKey];
}

-(NSString*)username{
    return [self.dictionary objectForKey:kPhotoponUserAttributesUsernameKey];
}
-(NSString*)firstName{
    return [self.dictionary objectForKey:kPhotoponUserAttributesFirstNameKey];
}
-(NSString*)lastName{
    return [self.dictionary objectForKey:kPhotoponUserAttributesLastNameKey];
}
-(NSString*)email{
    return [self.dictionary objectForKey:kPhotoponUserAttributesEmailKey];
}
-(NSString*)bio{
    return [self.dictionary objectForKey:kPhotoponUserAttributesBioKey];
}
-(NSString*)website{
    return [self.dictionary objectForKey:kPhotoponUserAttributesWebsiteKey];
}
-(NSString*)profilePictureUrl{
    return [self.dictionary objectForKey:kPhotoponUserAttributesProfilePictureUrlKey];
}
-(NSString*)profileCoverPictureUrl{
    return [self.dictionary objectForKey:kPhotoponUserAttributesProfileCoverPictureUrlKey];
}
-(NSNumber*)followedByCount{
    return [self.dictionary objectForKey:kPhotoponUserAttributesFollowedByCountKey];
}
-(NSNumber*)followersCount{
    return [self.dictionary objectForKey:kPhotoponUserAttributesFollowersCountKey];
}
-(NSNumber*)redeemCount{
    return [self.dictionary objectForKey:kPhotoponUserAttributesRedeemCountKey];
}
-(NSNumber*)mediaCount{
    return [self.dictionary objectForKey:kPhotoponUserAttributesMediaCountKey];
}
-(NSNumber*)score{
    return [self.dictionary objectForKey:kPhotoponUserAttributesScoreKey];
}

-(NSString*)followedByCountString{
    return [self.dictionary objectForKey:kPhotoponUserAttributesFollowedByCountStringKey];
}
-(NSString*)followersCountString{
    return [self.dictionary objectForKey:kPhotoponUserAttributesFollowersCountStringKey];
}
-(NSString*)redeemCountString{
    return [self.dictionary objectForKey:kPhotoponUserAttributesRedeemCountStringKey];
}
-(NSString*)mediaCountString{
    return [self.dictionary objectForKey:kPhotoponUserAttributesMediaCountStringKey];
}
-(NSString*)scoreString{
    return [self.dictionary objectForKey:kPhotoponUserAttributesScoreStringKey];
}
-(NSString*)didFollowString{
    return [self.dictionary objectForKey:kPhotoponUserAttributesDidFollowStringKey];
}

-(NSString*)twitterID{
    return [self.dictionary objectForKey:kPhotoponUserAttributesTwitterIDKey];
}
-(NSString*)facebookID{
    return [self.dictionary objectForKey:kPhotoponUserAttributesFacebookIDKey];
}
-(NSString*)instagramID{
    return [self.dictionary objectForKey:kPhotoponUserAttributesInstagramIDKey];
}

-(BOOL)didFollowBool{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [(NSString*)[self.dictionary objectForKey:kPhotoponUserAttributesDidFollowStringKey] boolValue];
    //return [[self.dictionary objectForKey:kPhotoponUserAttributesDidFollowKey] boolValue];
}
-(NSNumber*)didFollow{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSNumber numberWithBool:[[NSString stringWithFormat:@"%@", [self.dictionary objectForKey:kPhotoponUserAttributesDidFollowStringKey]] boolValue]];
    //return [self.dictionary objectForKey:kPhotoponUserAttributesDidFollowKey];
}

-(void) userDidFollow:(UIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    NSArray *parameters = [appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:self.leader.identifier, nil]];
    
    [appDelegate.pmm.api callMethod:kPhotoponAPIMethodPostFollow parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
         message:@"Media Liked"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         [alert show];
         */
        
        [self.dictionary setObject:@"1" forKey:kPhotoponUserAttributesDidFollowStringKey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        [self.dictionary setObject:@"0" forKey:kPhotoponUserAttributesDidFollowStringKey];
        
        [button setSelected:NO];
        
    }];
}

-(void) userDidUnfollow:(UIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    NSArray *parameters = [appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:self.leader.identifier, nil]];
    
    [appDelegate.pmm.api callMethod:kPhotoponAPIMethodPostUnfollow parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
         message:@"Media Unliked"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         [alert show];
         */
        [self.dictionary setObject:@"0" forKey:kPhotoponUserAttributesDidFollowStringKey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        [self.dictionary setObject:@"1" forKey:kPhotoponUserAttributesDidFollowStringKey];
        
        [button setSelected:YES];
        
    }];
}


/*
+ (void)getLikersForMediaId:(NSString*)mediaId withAccessToken:(NSString *)accessToken block:(void (^)(NSArray *records))block{
 
}
*/
+ (void)getInstagramUserMediaWithId:(NSString*)userId withAccessToken:(NSString *)accessToken block:(void (^)(NSArray *records))block
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    NSMutableDictionary* paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/followed-by", @"method", nil];
    
    [appDelegate.instagram requestWithParams:paramsDict delegate:current];
    
    /*
     [[appDelegate.instagram sharedClient] getPath:path
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSMutableArray *mutableRecords = [NSMutableArray array];
     NSArray* data = [responseObject objectForKey:@"data"];
     for (NSDictionary* obj in data) {
     PhotoponMediaModel* media = [[PhotoponMediaModel alloc] initWithAttributes:obj];
     [mutableRecords addObject:media];
     }
     if (block) {
     block([NSArray arrayWithArray:mutableRecords]);
     }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"error: %@", error.localizedDescription);
     if (block) {
     block([NSArray array]);
     }
     }];
     */
}

- (BOOL)didLikeBool {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (BOOL)[[self didFollow] boolValue];
}


- (id)initWithAttributes:(NSDictionary *)attributes {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self = [PhotoponUserModel modelWithDictionary:attributes];
    if (!self) {
        return nil;
    }
    
    //current = (PhotoponUserModel*)(id)[PhotoponUserModel modelWithDictionary:self.dictionary];
    
    /*
    
    self.identifier = [attributes objectForKey:@"identifier"];
    self.username = [attributes objectForKey:@"username"];
    self.firstName = [attributes objectForKey:@"firstName"];
    self.lastName = [attributes objectForKey:@"lastName"];
    self.email = [attributes objectForKey:@"email"];
    self.bio = [attributes objectForKey:@"bio"];
    self.website = [attributes objectForKey:@"website"];
    self.profilePictureUrl = [attributes objectForKey:@"profilePictureUrl"];
    self.profileCoverPictureUrl = [attributes objectForKey:@"profileCoverPictureUrl"];
    self.followedByCount = [NSNumber numberWithInt:(NSInteger)[attributes objectForKey:@"followedByCount"]];
    self.followersCount = [NSNumber numberWithInt:(NSInteger)[attributes objectForKey:@"followersCount"]];
    self.redeemCount = [NSNumber numberWithInt:(NSInteger)[attributes objectForKey:@"redeemCount"]];
    self.mediaCount = [NSNumber numberWithInt:(NSInteger)[attributes objectForKey:@"mediaCount"]];
    self.score = [NSNumber numberWithInt:(NSInteger)[attributes objectForKey:@"score"]];
    self.didFollow = [NSNumber numberWithInt:(NSInteger)[attributes objectForKey:@"didFollow"]];
    
    self.mediaCountString = [attributes objectForKey:@"mediaCountString"];
    self.followersCountString = [attributes objectForKey:@"followersCountString"];
    self.followedByCountString = [attributes objectForKey:@"followedByCountString"];
    self.redeemCountString = [attributes objectForKey:@"redeemCountString"];
    self.scoreString = [attributes objectForKey:@"scoreString"];
    self.didFollowString = [attributes objectForKey:@"didFollowString"];
    
    self.twitterID   = [attributes objectForKey:@"twitterID"];
    self.facebookID = [attributes objectForKey:@"facebookID"];
    self.instagramID = [attributes objectForKey:@"instagramID"];
    
    //self.thumbnailUrl = [[[attributes valueForKeyPath:@"images"] valueForKeyPath:@"thumbnail"] valueForKeyPath:@"url"];
    //self.standardUrl = [[[attributes valueForKeyPath:@"images"] valueForKeyPath:@"standard_resolution"] valueForKeyPath:@"url"];
    //self.likes = [[[attributes objectForKey:@"likes"] valueForKey:@"count"] integerValue];
     */
    
    return self;
    
}

+ (PhotoponUserModel *)currentUser{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(current != nil)
        return current;
    
    current = nil;
    
    //NSString* userId = (NSString* )[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesCurrentUserKey];
    
    //NSString *defaultsUserId = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesFacebookAccessTokenKey];
    
    
    
    NSString *userId = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]];
    
    /*
    if (defaultsUserId && defaultsUserId.length>0) {
        
        //[self openSessionWithAllowLoginUI:YES];
        
    }
    
    / *
    if (userId && userId.length >0) {
        return 
        
        
    }
    */
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cached User ID"
                                                    message:userId
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [alert show];
    */
    
    if(userId && userId.length>0){
        //current = [PhotoponUserModel modelFromCache];
        // this is better:
        /*
        PhotoponQuery *query = [PhotoponUserModel query];
        
        [query.dkQuery whereEntityIdMatches: userId];
        NSError* error = nil;
        NSArray *array = [query findObjects:&error];
        if(!error && [array count] > 0)
            current = (PhotoponUserModel*)[array objectAtIndex:0];
        
        */
        
        
        current = [PhotoponUserModel modelFromCache];
        
        
        //if (current) {
          //  return current;
        //}else{
        //}
        
        

    }
    

    return current;

}

-(void)changeUserName:(NSString *)username{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.dictionary setObject:username forKey:kPhotoponUserAttributesUsernameKey];
    
}


+(PhotoponUserModel*)modelFromCache{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    current = nil;
    
    PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
    
    
    //appDelegate.hud.labelText = NSLocalizedString(@"Searching Cache", nil);
    
    //[appDelegate.hud show:YES];
    //[appDelegate.hud hide:YES afterDelay:2.0];
    
    NSString *userId = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]];
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    
    // we know we at least have this data or it would never have made it this far
    // this won't work when app was closed entirely
    //[userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesCurrentUserKey] forKey:kPhotoponUserAttributesIdentifierKey];
    [userDict setObject:(NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]] forKey:kPhotoponUserAttributesIdentifierKey];
    
    
    
    @try {
        
        // as for the rest, we're not so sure...
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesFacebookIDKey] forKey:kPhotoponUserAttributesFacebookIDKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesFullNameKey] forKey:kPhotoponUserAttributesFullNameKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesUsernameKey] forKey:kPhotoponUserAttributesUsernameKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesFirstNameKey] forKey:kPhotoponUserAttributesFirstNameKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesLastNameKey] forKey:kPhotoponUserAttributesLastNameKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesEmailKey] forKey:kPhotoponUserAttributesEmailKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesBioKey] forKey:kPhotoponUserAttributesBioKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesWebsiteKey] forKey:kPhotoponUserAttributesWebsiteKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesProfilePictureUrlKey] forKey:kPhotoponUserAttributesProfilePictureUrlKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesProfileCoverPictureUrlKey] forKey:kPhotoponUserAttributesProfileCoverPictureUrlKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesMediaCountStringKey] forKey:kPhotoponUserAttributesMediaCountStringKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesFollowersCountStringKey] forKey:kPhotoponUserAttributesFollowersCountStringKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesFollowedByCountStringKey] forKey:kPhotoponUserAttributesFollowedByCountStringKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesRedeemCountStringKey] forKey:kPhotoponUserAttributesRedeemCountStringKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesScoreStringKey] forKey:kPhotoponUserAttributesScoreStringKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesDidFollowStringKey] forKey:kPhotoponUserAttributesDidFollowStringKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesTwitterIDKey] forKey:kPhotoponUserAttributesTwitterIDKey];
        [userDict setObject:(NSString*)[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesInstagramIDKey] forKey:kPhotoponUserAttributesInstagramIDKey];
        
        //current = [[PhotoponUserModel alloc] initWithAttributes:userDict];
        
        return [[PhotoponUserModel alloc] initWithAttributes:userDict];
        
        
    }
    @catch (NSException *exception) {
        
        
        
        //appDelegate.hud.labelText = NSLocalizedString(@"Connecting to Photopon.com", nil);
        //[appDelegate.hud show:YES];
        //[appDelegate.hud hide:YES afterDelay:3.0];
        
        // oops, info doesn't exist so let's grab it remotely
        // REMOTE QUERY HERE
        PhotoponComApi *pComApi = [PhotoponComApi sharedApi];
        
        [userDict setObject:(NSString*)pComApi.username forKey:kPhotoponUserAttributesUsernameKey];
        
        PhotoponUserModel *u = [[PhotoponUserModel alloc] initWithAttributes:userDict];
        [u.dictionary setValue:[NSNumber numberWithBool:NO] forKey:kPhotoponHasBeenFetchedKey];
        
        
        //[PhotoponUserModel logInWithUsernameInBackground:pComApi.username password:pComApi.password block:nil];
        return u;
        
    }
    @finally {
        
        
        
    }
    
    /*
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followedByCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"redeemCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"mediaCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"score"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"didFollow"];
     */
    
    return current;

}

- (void) cacheUserAttributes{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.identifier) {
        return;
    }
    
    [[EGOCache globalCache] setString:self.identifier forKey:kPhotoponUserAttributesCurrentUserKey];
    
    [[EGOCache globalCache] setString:self.identifier forKey:kPhotoponUserAttributesIdentifierKey];
    [[EGOCache globalCache] setString:self.facebookID forKey:kPhotoponUserAttributesFacebookIDKey];
    [[EGOCache globalCache] setString:self.fullname forKey:kPhotoponUserAttributesFullNameKey];
    [[EGOCache globalCache] setString:self.username forKey:kPhotoponUserAttributesUsernameKey];
    [[EGOCache globalCache] setString:self.firstName forKey:kPhotoponUserAttributesFirstNameKey];
    [[EGOCache globalCache] setString:self.lastName forKey:kPhotoponUserAttributesLastNameKey];
    [[EGOCache globalCache] setString:self.email forKey:kPhotoponUserAttributesEmailKey];
    [[EGOCache globalCache] setString:self.bio forKey:kPhotoponUserAttributesBioKey];
    [[EGOCache globalCache] setString:self.website forKey:kPhotoponUserAttributesWebsiteKey];
    [[EGOCache globalCache] setString:self.profilePictureUrl forKey:kPhotoponUserAttributesProfilePictureUrlKey];
    [[EGOCache globalCache] setString:self.profileCoverPictureUrl forKey:kPhotoponUserAttributesProfileCoverPictureUrlKey];
    
    /*
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"followedByCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"redeemCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"mediaCount"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"score"];
     [[EGOCache globalCache] setString:photoponUserModel.identifier forKey:@"didFollow"];
     */
    
    [[EGOCache globalCache] setString:self.mediaCountString forKey:kPhotoponUserAttributesMediaCountStringKey];
    [[EGOCache globalCache] setString:self.followersCountString forKey:kPhotoponUserAttributesFollowersCountStringKey];
    [[EGOCache globalCache] setString:self.followedByCountString forKey:kPhotoponUserAttributesFollowedByCountStringKey];
    [[EGOCache globalCache] setString:self.redeemCountString forKey:kPhotoponUserAttributesRedeemCountStringKey];
    [[EGOCache globalCache] setString:self.scoreString forKey:kPhotoponUserAttributesScoreStringKey];
    [[EGOCache globalCache] setString:self.didFollowString forKey:kPhotoponUserAttributesDidFollowStringKey];
    
    [[EGOCache globalCache] setString:self.twitterID forKey:kPhotoponUserAttributesTwitterIDKey];
    [[EGOCache globalCache] setString:self.instagramID forKey:kPhotoponUserAttributesInstagramIDKey];
    
    //current = self;
    
}

+ (void)logOut{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(current){
        current = nil;
        [[EGOCache globalCache] removeCacheForKey:kPhotoponUserAttributesCurrentUserKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponUserAttributesIdentifierKey];
    }
    
    /*
    [[EGOCache globalCache] removeCacheForKey:kPhotoponUserAttributesCurrentUserKey];
    [[EGOCache globalCache] removeCacheForKey:kPhotoponModelIdentifierKey];
    [[[PhotoponUserModel currentUser] cache] removeAllObjects];
     */
    
}

+ (void)setCurrentUser:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    current = user;
    [[EGOCache globalCache] setString:user.identifier forKey:kPhotoponUserAttributesCurrentUserKey];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user.identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kPhotoponUserAttributesIdentifierKey];
    [[NSUserDefaults standardUserDefaults] setObject:user.identifier forKey:kPhotoponUserAttributesCurrentUserKey];
    [[NSUserDefaults standardUserDefaults] setObject:user.facebookID forKey:kPhotoponUserAttributesFacebookIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/*
-(NSString*)username{
	return [self objectForKey:kPhotoponUserAttributesIdentifierKey];
}*/
/*
+ (PhotoponQuery *)query{
    return  [PhotoponQuery queryWithClassName:kPhotoponUserClassName];
}*/

/*
- (void)setUsername:(NSString *)username{
	[self setObject:self.username forKey:kPhotoponUserAttributesUsernameKey];
}
 */

-(NSString*)password{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[PhotoponComApi sharedApi] password];
	//return [self objectForKey:kPhotoponu];
}

- (void)setPassword:(NSString *)password{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self setObject:self.password forKey:kUserPasswordKey];
    [[PhotoponComApi sharedApi] setUsername:[[PhotoponComApi sharedApi] username] password:password success:nil failure:nil];
}

+ (PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	return (PhotoponUserModel*)[PhotoponUserModel objectWithClassName:kPhotoponUserClassName];
}


/*
- (void)setUsername:(NSString *)username{
	[self.dictionary setObject:self.username forKey:@"user"];
}

-(NSString*)password{
	return [self objectForKey:kUserPasswordKey];
}

- (void)setPassword:(NSString *)password{
	[self setObject:self.password forKey:kUserPasswordKey];
}

- (void)setDidFollowBool:(BOOL)didFollowBoolLocal {
    [self setDidFollow:[NSNumber numberWithBool:didFollowBoolLocal]];
}*/

@end