//
//  PhotoponModelManager.m
//  Photopon
//
//  Created by Brad McEvilly on 5/26/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponModelManager.h"
#import "PhotoponModel+Subclass.h"
#import "PhotoponMediaModel.h"
#import "PhotoponCommentModel.h"
#import "PhotoponUserModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponCouponModel.h"
#import "PhotoponComApi.h"

#import "SFHFKeychainUtils.h"
#import "UIImage+Resize.h"
#import "NSURL+IDN.h"
#import "NSString+XMLExtensions.h"
#import "WPXMLRPCClient.h"
#import "Photopon8CouponsModel.h"

#import "PhotoponCache.h"

@interface PhotoponModelManager (PrivateMethods)
- (WPXMLRPCRequestOperation *)operationForPostFormatsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (WPXMLRPCRequestOperation *)operationForCommentsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (WPXMLRPCRequestOperation *)operationForProfileInfoWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (WPXMLRPCRequestOperation *)operationForPhotoponsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (WPXMLRPCRequestOperation *)operationForFacebookUserLoginWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (WPXMLRPCRequestOperation *)operationForPhotoponUserLoginWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (WPXMLRPCRequestOperation *)operationForMainFeedWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more;
- (WPXMLRPCRequestOperation *)operationForTimelineWithConfig:(NSDictionary *)config success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
- (AFHTTPRequestOperation *)operationForOffersWithConfig:(NSDictionary *)config success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

- (WPXMLRPCRequestOperation *)operationForModelsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *))failure;

- (void)mergeCategories:(NSArray *)newCategories;
- (void)mergeComments:(NSArray *)newComments;
- (void)mergePages:(NSArray *)newPages;
- (void)mergePosts:(NSArray *)newPosts;

@property (readwrite, assign) BOOL reachable;
@property (readwrite, nonatomic, strong) PhotoponComApi *pComApi;

//@property (readwrite, nonatomic, strong) WPXMLRPCClient *pCom8CouponsApi;

@end


@implementation PhotoponModelManager {
    WPXMLRPCClient *_api;
    WPXMLRPCClient *_pCom8CouponsApi;
    PhotoponComApi *_pComApi;
    PhotoponUserModel *_currentUser;
    NSString *_blavatarUrl;
    Reachability *_reachability;
    BOOL _isReachable;
}
/*
@dynamic url, username, password, xmlrpc, apiKey;
@dynamic isAdmin, hasOlderPosts;
@dynamic posts, comments;
@dynamic lastPostsSync, lastStatsSync, lastPagesSync, lastCommentsSync, lastUpdateWarning;
@synthesize isSyncingPosts, isSyncingPages, isSyncingComments;
@dynamic geolocationEnabled, options, postFormats, isActivated;
*/

@synthesize lastCommentsSync;
@synthesize lastExploreSync;
@synthesize lastTimelineSync;
@synthesize lastHomeSync;
@synthesize lastNewsSync;
@synthesize lastOffersSync;
@synthesize lastProfileSync;
@synthesize lastStatsSync;
@synthesize lastDetailsSync;

@synthesize isSyncingComments;
@synthesize isSyncingExplore;
@synthesize isSyncingHome;
@synthesize isSyncingNews;
@synthesize isSyncingOffers;
@synthesize isSyncingProfile;
@synthesize isSyncingTags;
@synthesize isSyncingDetails;
@synthesize isSyncingUsers;
@synthesize isSyncingSearchText;
@synthesize username;
@synthesize password;

@synthesize username8Coupons;
@synthesize password8Coupons;

+ (id)sharedManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

+ (dispatch_queue_t)queue {
    static dispatch_queue_t q;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        q = dispatch_queue_create("photopon remote queue", DISPATCH_QUEUE_SERIAL);
    });
    return q;
}

- (void)loadMoreCommentsInBackgroundWithParams:(NSDictionary*)params withBlock:(void (^)(NSArray *results, NSError *error))block {
    
    NSString *mediaIDStr    = (NSString*)[params objectForKey:kPhotoponModelIdentifierKey];
    
    NSNumber *maxItems      = (NSNumber*)[params objectForKey:kPhotoponModelIdentifierKey];
    
    NSString *idStr         = [[PhotoponUserModel currentUser] identifier];
    
    NSArray *paramsArrExtra = [[NSArray alloc] initWithObjects:idStr, maxItems, mediaIDStr, nil];
    
    NSArray *parameters     = [self.pComApi getXMLRPCArgsWithExtra:paramsArrExtra];
    
    dispatch_queue_t q      = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
        
        [weakSelf.pComApi callMethodWithParams:@"bp.getComments" params:parameters withSuccess:^(NSArray *responseObject){
            
            NSLog(@"PhotoponModelManager :: loadMoreCommentsInBackgroundWithParams :: SUCCESS SUCCESS SUCCESS ");
            
            NSDictionary *returnData = (NSDictionary*)responseObject;
            
            NSArray * comments = (NSArray*)[returnData objectForKey:@"comment_models"];
            comments = [PhotoponCommentModel modelsFromDictionaries:comments];
            
            if (block != NULL) {
                dispatch_async(q, ^{
                    block(comments, error);
                });
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"PhotoponModelManager :: loadMoreCommentsInBackgroundWithParams FAILED FAILED FAILED     ");
            NSLog(@"||*****||");
            NSLog(@"||*****||");
            NSLog(@"||*****||               FAILURE DESCRIPTION:        ");
            NSLog(@"||*****||");
            NSLog(@"||*****||       %@", [error localizedDescription]);
            NSLog(@"||*****||");
            NSLog(@"||*****||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            if (block != NULL) {
                dispatch_async(q, ^{
                    block(nil, error);
                });
            }
            
        }];

    });
    
    
}

- (void)findAllInBackgroundWithBlock:(void (^)(NSArray *results, NSError *error))block {
    /*
    dispatch_queue_t q = dispatch_get_current_queue();
    dispatch_async([PhotoponModelManager queue], ^{
        NSError *error = nil;
        
        NSArray *entities = [self findAll:&error];
        if (block != NULL) {
            dispatch_async(q, ^{
                block(entities, error);
            });
        }
    });
     
    */
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    
    _api = nil;
    [_reachability stopNotifier];
    _reachability = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)geolocationEnabled
{
    BOOL tmpValue = YES;
    
    //[self willAccessValueForKey:@"geolocationEnabled"];
    //tmpValue = [[self primitiveValueForKey:@"geolocationEnabled"] boolValue];
    //[self didAccessValueForKey:@"geolocationEnabled"];
    
    return tmpValue;
}

- (void)setGeolocationEnabled:(BOOL)value
{
    //[self willChangeValueForKey:@"geolocationEnabled"];
    //[self setPrimitiveValue:[NSNumber numberWithBool:value] forKey:@"geolocationEnabled"];
    //[self didChangeValueForKey:@"geolocationEnabled"];
}

#pragma mark -
#pragma mark Custom methods

+ (BOOL)blogExistsForURL:(NSString *)theURL withContext:(NSManagedObjectContext *)moc andUsername:(NSString *)username{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Blog"
                                        inManagedObjectContext:moc]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"url like %@ AND username = %@", theURL, username]];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    fetchRequest = nil;
    
    return (results.count > 0);
}

+ (PhotoponModelManager *)createFromDictionary:(NSDictionary *)blogInfo withContext:(NSManagedObjectContext *)moc {
    /*
    PhotoponModelManager *blog = nil;
    NSString *blogUrl = [[blogInfo objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	if([blogUrl hasSuffix:@"/"])
		blogUrl = [blogUrl substringToIndex:blogUrl.length-1];
	blogUrl= [blogUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![self blogExistsForURL:blogUrl withContext:moc andUsername: [blogInfo objectForKey:@"username"]]) {
        blog = [[Blog alloc] initWithEntity:[NSEntityDescription entityForName:@"Blog"
                                                        inManagedObjectContext:moc]
             insertIntoManagedObjectContext:moc];
        
        blog.url = blogUrl;
        blog.blogID = [NSNumber numberWithInt:[[blogInfo objectForKey:@"blogid"] intValue]];
        blog.blogName = [[blogInfo objectForKey:@"blogName"] stringByDecodingXMLCharacters];
		blog.xmlrpc = [blogInfo objectForKey:@"xmlrpc"];
        blog.username = [blogInfo objectForKey:@"username"];
        blog.isAdmin = [NSNumber numberWithInt:[[blogInfo objectForKey:@"isAdmin"] intValue]];
        
        NSError *error = nil;
		if(blog.isWPcom) {
			[SFHFKeychainUtils storeUsername:[blogInfo objectForKey:@"username"]
								 andPassword:[blogInfo objectForKey:@"password"]
							  forServiceName:@"WordPress.com"
							  updateExisting:TRUE
									   error:&error ];
		} else {
			[SFHFKeychainUtils storeUsername:[blogInfo objectForKey:@"username"]
								 andPassword:[blogInfo objectForKey:@"password"]
							  forServiceName:blog.hostURL
							  updateExisting:TRUE
									   error:&error ];
		}
        // TODO: save blog settings
	}
    return blog;
     */
}

/*
+ (Blog *)findWithId:(int)blogId withContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Blog" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"blogID = %d", blogId]];
    
    NSError *err = nil;
    NSArray *result = [moc executeFetchRequest:request error:&err];
    Blog *blog = nil;
    if (err == nil && [result count] > 0 ) {
        blog = [result objectAtIndex:0];
    }
    return blog;
}

+ (NSInteger)countWithContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Blog" inManagedObjectContext:moc]];
    [request setIncludesSubentities:NO];
    
    NSError *err;
    NSUInteger count = [moc countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        count = 0;
    }
    return count;
}

- (NSString *)blavatarUrl {
	if (_blavatarUrl == nil) {
        NSString *hostUrl = [[NSURL URLWithString:self.xmlrpc] host];
        if (hostUrl == nil) {
            hostUrl = self.xmlrpc;
        }
		
        _blavatarUrl = hostUrl;
    }
    
    return _blavatarUrl;
}

// used as a key to store passwords, if you change the algorithm, logins will break
- (NSString *)displayURL {
    NSError *error = NULL;
    NSRegularExpression *protocol = [NSRegularExpression regularExpressionWithPattern:@"http(s?)://" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [NSString stringWithFormat:@"%@", [protocol stringByReplacingMatchesInString:[NSURL IDNDecodedHostname:self.url] options:0 range:NSMakeRange(0, [[NSURL IDNDecodedHostname:self.url] length]) withTemplate:@""]];
    
    if([result hasSuffix:@"/"])
        result = [result substringToIndex:[result length] - 1];
    
    return result;
}

- (NSString *)hostURL {
    return [self displayURL];
}

- (NSString *)hostname {
    NSString *hostname = [[NSURL URLWithString:self.xmlrpc] host];
    if (hostname == nil) {
        NSError *error = NULL;
        NSRegularExpression *protocol = [NSRegularExpression regularExpressionWithPattern:@"^.*://" options:NSRegularExpressionCaseInsensitive error:&error];
        hostname = [protocol stringByReplacingMatchesInString:self.url options:0 range:NSMakeRange(0, [self.url length]) withTemplate:@""];
    }
    
    // NSURL seems to not recongnize some TLDs like .me and .it, which results in hostname returning a full path.
    // This can break reachibility (among other things) for the blog.
    // As a saftey net, make sure we drop any path component before returning the hostname.
    NSArray *parts = [hostname componentsSeparatedByString:@"/"];
    if([parts count] > 0) {
        hostname = [parts objectAtIndex:0];
    }
    
    return hostname;
}

- (NSString *)loginUrl {
    return [self urlWithPath:@"wp-login.php"];
}

- (NSString *)urlWithPath:(NSString *)path {
    NSError *error = NULL;
    NSRegularExpression *xmlrpc = [NSRegularExpression regularExpressionWithPattern:@"xmlrpc.php$" options:NSRegularExpressionCaseInsensitive error:&error];
    return [xmlrpc stringByReplacingMatchesInString:self.xmlrpc options:0 range:NSMakeRange(0, [self.xmlrpc length]) withTemplate:path];
}

- (NSString *)adminUrlWithPath:(NSString *)path {
    return [self urlWithPath:[NSString stringWithFormat:@"wp-admin/%@", path]];
}

- (int)numberOfPendingComments{
    int pendingComments = 0;
    for (Comment *element in self.comments) {
        if ( [@"hold" isEqualToString: element.status] )
            pendingComments++;
    }
    
    return pendingComments;
}

-(NSArray *)sortedCategories {
	NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName"
                                                                       ascending:YES
                                                                        selector:@selector(caseInsensitiveCompare:)];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
	
	return [[self.categories allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray *)sortedPostFormatNames {
    NSMutableArray *sortedNames = [NSMutableArray arrayWithCapacity:[self.postFormats count]];
    
    if ([self.postFormats count] != 0) {
        id standardPostFormat = [self.postFormats objectForKey:@"standard"];
        if (standardPostFormat) {
            [sortedNames addObject:standardPostFormat];
        }
        [self.postFormats enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (![key isEqual:@"standard"]) {
                [sortedNames addObject:obj];
            }
        }];
    }
    
    return [NSArray arrayWithArray:sortedNames];
}
*/
 
- (BOOL)isPcom {
    /*
    if ([[self getOptionValue:@"wordpress.com"] boolValue]) {
        return YES;
    }
    
    
    NSRange range = [kPhotoponComXMLRPCUrl rangeOfString:@"photopon.com"];
	return (range.location != NSNotFound);
     */
}

//WP.COM private blog.
- (BOOL)isPrivate {
    if ( [self isWPcom] && [[self getOptionValue:@"blog_public"] isEqual:@"-1"] )
        return YES;
    return NO;
}

- (NSDictionary *) getImageResizeDimensions{
    CGSize smallSize, mediumSize, largeSize;
    int small_size_w =      [[self getOptionValue:@"thumbnail_size_w"] intValue]    > 0 ? [[self getOptionValue:@"thumbnail_size_w"] intValue] : image_small_size_w;
    int small_size_h =      [[self getOptionValue:@"thumbnail_size_h"] intValue]    > 0 ? [[self getOptionValue:@"thumbnail_size_h"] intValue] : image_small_size_h;
    int medium_size_w =     [[self getOptionValue:@"medium_size_w"] intValue]       > 0 ? [[self getOptionValue:@"medium_size_w"] intValue] : image_medium_size_w;
    int medium_size_h =     [[self getOptionValue:@"medium_size_h"] intValue]       > 0 ? [[self getOptionValue:@"medium_size_h"] intValue] : image_medium_size_h;
    int large_size_w =      [[self getOptionValue:@"large_size_w"] intValue]        > 0 ? [[self getOptionValue:@"large_size_w"] intValue] : image_large_size_w;
    int large_size_h =      [[self getOptionValue:@"large_size_h"] intValue]        > 0 ? [[self getOptionValue:@"large_size_h"] intValue] : image_large_size_h;
    
    smallSize = CGSizeMake(small_size_w, small_size_h);
    mediumSize = CGSizeMake(medium_size_w, medium_size_h);
    largeSize = CGSizeMake(large_size_w, large_size_h);
    
    return [NSDictionary dictionaryWithObjectsAndKeys: [NSValue valueWithCGSize:smallSize], @"smallSize",
            [NSValue valueWithCGSize:mediumSize], @"mediumSize",
            [NSValue valueWithCGSize:largeSize], @"largeSize",
            nil];
}

- (void)awakeFromFetch {
    [self reachability];
}

- (void)dataSave {
    /*
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        exit(-1);
    }
     */
    
	[[NSNotificationCenter defaultCenter] postNotificationName:ModelChangedNotification object:nil];
}

- (void)remove {
    NSLog(@"<PhotoponModelManager:%@> remove", self.hostURL);
    [self.api cancelAllHTTPOperations];
    _reachability.reachableBlock = nil;
    _reachability.unreachableBlock = nil;
    [_reachability stopNotifier];
    [self dataSave];
}

- (void)setXmlrpc:(NSString *)xmlrpc {
    //[self willChangeValueForKey:@"xmlrpc"];
    //[self setPrimitiveValue:xmlrpc forKey:@"xmlrpc"];
    //[self didChangeValueForKey:@"xmlrpc"];
    _blavatarUrl = nil;
    
    // Reset the api client so next time we use the new XML-RPC URL
    _api = nil;
}

- (NSArray *)get8CouponsXMLRPCArgsWithExtra:(id)extra {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    if (!self.username8Coupons || !self.username8Coupons.length>0) {
        self.username8Coupons = [[NSString alloc] initWithString:[Photopon8CouponsModel username]];  //:@"pcom_username_preference"];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        self.username = %@   ", self, NSStringFromSelector(_cmd), self.username);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        
        
    }
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@        self.password = %@   ", self, NSStringFromSelector(_cmd), self.password);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.password8Coupons || !self.password8Coupons>0) {
        
        self.password8Coupons = [[NSString alloc] initWithString:[Photopon8CouponsModel password]];
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        self.password = %@   ", self, NSStringFromSelector(_cmd), self.password);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    }
    
    NSMutableArray *result = [NSMutableArray array];
    //[result addObject:@"1"];
    [result addObject:self.username8Coupons];
    [result addObject:self.password8Coupons];
    
    if ([extra isKindOfClass:[NSArray class]]) {
        [result addObjectsFromArray:extra];
    } else if (extra != nil) {
        [result addObject:extra];
    }
    
    return [NSArray arrayWithArray:result];
    
    
    
    /*
     NSMutableArray *result = [NSMutableArray array];
     [result addObject:self.pComApi.username];
     [result addObject:[self fetchPassword]];
     
     if ([extra isKindOfClass:[NSArray class]]) {
     [result addObjectsFromArray:extra];
     } else if (extra != nil) {
     [result addObject:extra];
     }
     
     return [NSArray arrayWithArray:result];
     * /
     
     
     return [self.pComApi getXMLRPCArgsWithExtra:extra];
     */
}

- (NSArray *)getXMLRPCArgsWithExtra:(id)extra {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@        self.username = %@   ", self, NSStringFromSelector(_cmd), self.username);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.username || !self.username.length>0) {
        self.username = [[NSString alloc] initWithString:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesUsernameKey]];  //:@"pcom_username_preference"];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        self.username = %@   ", self, NSStringFromSelector(_cmd), self.username);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
    }
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@        self.password = %@   ", self, NSStringFromSelector(_cmd), self.password);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.password || !self.password>0) {
        
        self.password = [[NSString alloc] initWithString:[self fetchPassword]];
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        self.password = %@   ", self, NSStringFromSelector(_cmd), self.password);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    }
    
    NSMutableArray *result = [NSMutableArray array];
    //[result addObject:@"1"];
    [result addObject:self.username];
    [result addObject:self.password];
    
    if ([extra isKindOfClass:[NSArray class]]) {
        [result addObjectsFromArray:extra];
    } else if (extra != nil) {
        [result addObject:extra];
    }
    
    return [NSArray arrayWithArray:result];
    
    
    
    /*
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:self.pComApi.username];
    [result addObject:[self fetchPassword]];
    
    if ([extra isKindOfClass:[NSArray class]]) {
        [result addObjectsFromArray:extra];
    } else if (extra != nil) {
        [result addObject:extra];
    }
    
    return [NSArray arrayWithArray:result];
     * /
    
    
    return [self.pComApi getXMLRPCArgsWithExtra:extra];
    */
}
     
- (NSString *)fetchPassword {
    NSError *err;
	NSString *password;
    
    //[SFHFKeychainUtils storeUsername:kPhotoponGuestUsername andPassword:@"F3CrRi64IaOS4KdE84tCB594Fr3CrErG875TaOS8Kd093v84XirZ1YxD" forServiceName:@"Photopon.com" updateExisting:YES error:&error];
    
    password = [SFHFKeychainUtils getPasswordForUsername:kPhotoponGuestUsername andServiceName:@"Photopon.com" error:&err];
                
    /*password = [SFHFKeychainUtils getPasswordForUsername:self.pComApi.username
                                          andServiceName:@"Photopon.com"
                                                   error:&err];
    */
    
    
    /*
	if (self.isWPcom) {
        password = [SFHFKeychainUtils getPasswordForUsername:self.pComApi.username
                                              andServiceName:@"Photopon.com"
                                                       error:&err];
    } else {
		password = [SFHFKeychainUtils getPasswordForUsername:self.pComApi.username
                                              andServiceName:self.hostURL
                                                       error:&err];
	}
     */
    
    // The result of fetchPassword is stored in NSArrays in several places.
    // Make sure we return an empty string instead of nil to prevent a crash.
	if (password == nil)
		password = @"";
    
	return password;
}

- (void)storePassword:(NSString *)password forUsername:(NSString*)username{
    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:username andPassword:@"F3CrRi64IaOS4KdE84tCB594Fr3CrErG875TaOS8Kd093v84XirZ1YxD" forServiceName:@"Photopon.com" updateExisting:YES error:&error];
}



/*
+ (NSString *)APISecret {
    if (kDKManagerAPISecret.length == 0) {
        [NSException raise:NSInternalInconsistencyException format:@"No API secret specified"];
        return nil;
    }
    return kPhotoponComXMLRPCUrl;
}
*/

- (NSString *)version {
    return [self getOptionValue:@"software_version"];
}

- (Reachability *)reachability {
    if (_reachability == nil) {
        _reachability = [Reachability reachabilityWithHostname:self.hostname];
        __weak PhotoponModelManager *pmm = self;
        pmm.reachable = YES;
        _reachability.reachableBlock = ^(Reachability *reach) {
            pmm.reachable = YES;
        };
        _reachability.unreachableBlock = ^(Reachability *reach) {
            pmm.reachable = NO;
        };
        [_reachability startNotifier];
    }
    
    return _reachability;
}

- (BOOL)reachable {
    // Creates reachability object if it's nil
    [self reachability];
    return _isReachable;
}

- (void)setReachable:(BOOL)reachable {
    _isReachable = reachable;
}

#pragma mark -
#pragma mark Synchronization

- (NSArray *)syncedPostsWithEntityName:(NSString *)entityName {
    
    /*
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(remoteStatusNumber = %@) AND (postID != NULL) AND (original == NULL) AND (blog = %@)",
							  [NSNumber numberWithInt:AbstractPostRemoteStatusSync], self];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date_created_gmt" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (array == nil) {
        array = [NSArray array];
    }
    return array;
     */
    return nil;
}

- (NSArray *)syncedPosts {
    return [self syncedPostsWithEntityName:@"Post"];
}
/*
- (void)syncPostsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more {
    if (self.isSyncingPosts) {
        WPLog(@"Already syncing posts. Skip");
        return;
    }
    self.isSyncingPosts = YES;
    
    WPXMLRPCRequestOperation *operation = [self operationForPostsWithSuccess:success failure:failure loadMore:more];
    [self.api enqueueXMLRPCRequestOperation:operation];
}

- (NSArray *)syncedPages {
    return [self syncedPostsWithEntityName:@"Page"];
}

- (void)syncPagesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more {
	if (self.isSyncingPages) {
        WPLog(@"Already syncing pages. Skip");
        return;
    }
    self.isSyncingPages = YES;
    WPXMLRPCRequestOperation *operation = [self operationForPagesWithSuccess:success failure:failure loadMore:more];
    [self.api enqueueXMLRPCRequestOperation:operation];
}

- (void)syncCategoriesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    WPXMLRPCRequestOperation *operation = [self operationForCategoriesWithSuccess:success failure:failure];
    [self.api enqueueXMLRPCRequestOperation:operation];
}

- (void)syncOptionsWithWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    WPXMLRPCRequestOperation *operation = [self operationForOptionsWithSuccess:success failure:failure];
    [self.api enqueueXMLRPCRequestOperation:operation];
}

- (id)getOptionValue:(NSString *) name {
	if ( self.options == nil || (self.options.count == 0) ) {
        return nil;
    }
    NSDictionary *currentOption = [self.options objectForKey:name];
    return [currentOption objectForKey:@"value"];
}
*/
- (NSArray *)syncedTimeline{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}
- (NSArray *)syncedExplore{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}
- (NSArray *)syncedNews{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}
- (NSArray *)syncedProfile{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (AFHTTPRequestOperation *)operationForOffersWithConfig:(NSDictionary *)config success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                path8CouponsAPI = %@", self, NSStringFromSelector(_cmd), [Photopon8CouponsModel fullUrl]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[Photopon8CouponsModel baseUrl]]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:[Photopon8CouponsModel methodEndpointUrl]
                                                      parameters:[Photopon8CouponsModel params]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        // Print the response body in text
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"--------->          Response BEFORE: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSString *feed = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSError *error;
        
        NSData *jsonData = [feed dataUsingEncoding:NSUTF32BigEndianStringEncoding];
        
        NSArray *rows  = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: &error];
        
        
        
        
        
        
        
        
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
        
        NSArray *parameters;
        
        parameters = [appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:[[NSString alloc] initWithFormat:@"%@", @"some user api param here"], nil]];
        
        [appDelegate.pmm.api callMethod:kPhotoponMerchantsAPIMethodGetCoupons parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSMutableArray *finalRows = [[NSMutableArray alloc] initWithArray:(NSArray*)responseObject];
            
            [finalRows addObjectsFromArray:rows];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSLog(@"--------->          Response AFTER WITH SUCCESS MERCHANTS: %@", finalRows);
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            if (success) {
                success(finalRows);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
            
            [self.dictionary setObject:@"0" forKey:kPhotoponUserAttributesDidFollowStringKey];
            
            NSMutableArray *finalRows = [[NSMutableArray alloc] initWithArray:(NSArray*)rows];
            
            
            
            //[NSArray alloc] initWithObjects:<#(id), ...#>, nil
            //NSString *feed = [[NSString alloc] initWithFormat:@"%@", (NSString *)responseObject];
            
            //feed = [PhotoponAdapterUtils sanitizeRawJSONString:feed];
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            NSLog(@"--------->          Response AFTER WITH FAILED MERCHANTS: %@", finalRows);
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            if (success) {
                success(finalRows);
            }
            
        }];
        
        
        
        
        
        
        
        
        
        
        
        
        
        //[NSArray alloc] initWithObjects:<#(id), ...#>, nil
        //NSString *feed = [[NSString alloc] initWithFormat:@"%@", (NSString *)responseObject];
        
        //feed = [PhotoponAdapterUtils sanitizeRawJSONString:feed];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"--------->          Response AFTER: %@", rows);
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        //NSArray *offers = (NSArray*)feed;
        
        
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"--------->          Error: %@", error);
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    //[operation start];
    
    //NSArray *parameters = [[NSArray alloc] initWithArray:[self get8CouponsXMLRPCArgsWithExtra:(NSArray*)[config objectForKey:kPhotoponMethodParamsKey]]];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                CHECKPOINT 1 - ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return operation;
    
}

- (WPXMLRPCRequestOperation *)operationForModelsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    NSArray *parameters = [[NSArray alloc] initWithArray:[self getXMLRPCArgsWithExtra:(NSArray*)[config objectForKey:kPhotoponMethodParamsKey]]];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                CHECKPOINT 1 - ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *methodNameStr = [[NSString alloc] initWithFormat:@"%@", (NSString*)[config objectForKey:kPhotoponMethodNameKey]];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                methodNameStr = %@", self, NSStringFromSelector(_cmd), methodNameStr);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:methodNameStr parameters:parameters];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                CHECKPOINT 2 - ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success syncing models: %@", @"SUCCESS SUCCESS SUCCESS");
        
        if (success) {
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@                CHECKPOINT 3 - ", weakSelf, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing models: %@", [error localizedDescription]);
        
        
        if (failure) {
            failure(error);
        }
    }];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                CHECKPOINT 4 - ", weakSelf, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return operation;
    
}

- (void)syncModelsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    WPXMLRPCRequestOperation *operation = [self operationForModelsWithConfig:config success:^(NSArray *responseInfo){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@       WPXMLRPCRequestOperation *operation = [self operationForModelsWithConfig:config success:^(NSArray *responseInfo){    SUCCESS SUCCESS SUCCESS - ", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@       WPXMLRPCRequestOperation *operation = [self operationForModelsWithConfig:config success:^(NSArray *responseInfo){    FAILURE FAILURE FAILURE - ", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if (failure) {
            failure(error);
        }
    }];
    
    [self.api enqueueXMLRPCRequestOperation:operation];

}

- (void)syncSearchTextWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingSearchText) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingSearchText = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingSearchText = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingSearchText = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncDetailsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingDetails) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingDetails = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingDetails = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingDetails = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncHomeWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingHome) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingHome = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingHome = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingHome = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncExploreWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingExplore) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingExplore = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingExplore = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingExplore = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncNewsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingNews) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingNews = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingNews = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingNews = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncProfileWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingProfile) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingProfile = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingProfile = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingProfile = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncOffersWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (self.isSyncingOffers) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingOffers = YES;
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    AFHTTPRequestOperation *operation = [self operationForOffersWithConfig:config success:^(NSArray *responseInfo){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@       AFHTTPRequestOperation *operation = [self operationForOffersWithConfig:config success:^(NSArray *responseInfo){    SUCCESS SUCCESS SUCCESS - ", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        weakSelf.isSyncingOffers = NO;
        
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@       AFHTTPRequestOperation *operation = [self operationForOffersWithConfig:config success:^(NSArray *responseInfo){    FAILURE FAILURE FAILURE - ", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        weakSelf.isSyncingOffers = NO;
        
        if (failure) {
            failure(error);
        }
    }];
    
    [self.api enqueueHTTPRequestOperation:operation];
    
    
    
    
    
    
    
    /*
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        self.isSyncingOffers = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        self.isSyncingOffers = NO;
        if (failure) {
            failure(error);
        }
    }];*/
}

- (void)syncActivityWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingNews) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingNews = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingNews = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingNews = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncCommentsWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingComments) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingComments = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        weakSelf.isSyncingComments = NO;
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        weakSelf.isSyncingComments = NO;
        if (failure) {
            failure(error);
        }
    }];
}

/*
- (void)syncSearchTextWithConfig:(NSDictionary *)config success:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.isSyncingSearchText) {
        NSLog(@"Already syncing search text. Skip");
        return;
    }
    self.isSyncingSearchText = YES;
    
    [self syncModelsWithConfig:config success:^(NSArray *responseInfo){
        if (success) {
            success(responseInfo);
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}*/

// facebook login operation
// photopon user login operation
// init & present tabbarcontroller operatio



- (WPXMLRPCRequestOperation *)operationForFacebookUserLoginWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:nil];
    
    __weak __typeof(&*self)weakSelf = self;
    
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"bp.syncFBUser" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted] || self.managedObjectContext == nil)
        //return;
        
        
        NSError *error = nil;
        
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authentication Success!", @"")
         message:@"You are logged in!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        //dispatch_queue_t q = dispatch_get_main_queue();
        dispatch_async([PhotoponModelManager queue], ^{
            //NSError *error = nil;
            
            
            //dispatch_async(q, ^{
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            // check for errors
            if (error) {
                // display hud error message
                //appDelegate.hud.labelText = NSLocalizedString(@"Building Lists", nil);
                //[appDelegate.hud show:YES];
                //[appDelegate.hud hide:YES afterDelay:3.0];
                
            }else{
                
                NSDictionary *returnData = (NSDictionary*)responseObject;
                
                [PhotoponUserModel setCurrentUser:[PhotoponUserModel modelWithDictionary:returnData]];
                
                [[PhotoponUserModel currentUser] cacheUserAttributes];
                
                [appDelegate setPhotoponUserModel:[PhotoponUserModel currentUser]];
            }
#pragma clang diagnostic pop
            
            //});
        });
        
        
        
        
        
        
        
        
        
        
        
        weakSelf.options = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        NSString *minimumVersion = @"3.1";
        float version = [[weakSelf version] floatValue];
        if (version < [minimumVersion floatValue]) {
            if (weakSelf.lastUpdateWarning == nil || [weakSelf.lastUpdateWarning floatValue] < [minimumVersion floatValue]) {
                /*[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] showAlertWithTitle:NSLocalizedString(@"WordPress version too old", @"")
                 message:[NSString stringWithFormat:NSLocalizedString(@"The site at %@ uses WordPress %@. We recommend to update to the latest version, or at least %@", @""), [self hostname], [self version], minimumVersion]];
                 */
                weakSelf.lastUpdateWarning = minimumVersion;
            }
        }
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing options: %@", [error localizedDescription]);
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
    
}

- (WPXMLRPCRequestOperation *)operationForProfileInfoWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    __weak __typeof(&*self)weakSelf = self;
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:nil];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"bp.verifyConnection" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted] || self.managedObjectContext == nil)
        //return;
        
        
        NSError *error = nil;
        
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authentication Success!", @"")
         message:@"You are logged in!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        //dispatch_queue_t q = dispatch_get_main_queue();
        dispatch_async([PhotoponModelManager queue], ^{
            //NSError *error = nil;
            
            
                //dispatch_async(q, ^{
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            // check for errors
            if (error) {
                // display hud error message
                //appDelegate.hud.labelText = NSLocalizedString(@"Building Lists", nil);
                //[appDelegate.hud show:YES];
                //[appDelegate.hud hide:YES afterDelay:3.0];
                
            }else{
                        
                        NSDictionary *returnData = (NSDictionary*)responseObject;
                        
                        [PhotoponUserModel setCurrentUser:[PhotoponUserModel modelWithDictionary:returnData]];
                        
                        [[PhotoponUserModel currentUser] cacheUserAttributes];
                        
                        [appDelegate setPhotoponUserModel:[PhotoponUserModel currentUser]];
            }
#pragma clang diagnostic pop
                   
                //});
            });
            
            
        
        
        
        
        
        
        
        
        
        weakSelf.options = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        NSString *minimumVersion = @"3.1";
        float version = [[weakSelf version] floatValue];
        if (version < [minimumVersion floatValue]) {
            if (weakSelf.lastUpdateWarning == nil || [self.lastUpdateWarning floatValue] < [minimumVersion floatValue]) {
                /*[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] showAlertWithTitle:NSLocalizedString(@"WordPress version too old", @"")
                 message:[NSString stringWithFormat:NSLocalizedString(@"The site at %@ uses WordPress %@. We recommend to update to the latest version, or at least %@", @""), [self hostname], [self version], minimumVersion]];
                 */
                weakSelf.lastUpdateWarning = minimumVersion;
            }
        }
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing options: %@", [error localizedDescription]);
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
    
}

- (WPXMLRPCRequestOperation *)operationForPhotoponsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (WPXMLRPCRequestOperation *)operationForFacebookUserLoginWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (WPXMLRPCRequestOperation *)operationForPhotoponUserLoginWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (WPXMLRPCRequestOperation *)operationForTimelineWithConfig:(NSDictionary *)config success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:(NSArray*)[config objectForKey:kPhotoponMethodParamsKey]];
    
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:(NSString*)[config objectForKey:kPhotoponMethodNameKey] parameters:parameters];
    
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing posts: %@", [error localizedDescription]);
        self.isSyncingHome = NO;
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
    
}

- (WPXMLRPCRequestOperation *)operationForTimelineWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int num;
    
    // Don't load more than 20 posts if we aren't at the end of the table,
    // even if they were previously donwloaded
    //
    // Blogs with long history can get really slow really fast,
    // with no chance to go back
    
    int postBatchSize = 10;
    if (more) {
        num = MAX([self.mediaModels count], postBatchSize);
        if ([self.hasOlderPosts boolValue]) {
            num += postBatchSize;
        }
    } else {
        num = postBatchSize;
    }
    
    NSArray *paramsArrExtra = [NSArray arrayWithObjects:self.currentUser.identifier, [NSNumber numberWithInt:num], nil];
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:paramsArrExtra];
    
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"bp.getMyGallery" parameters:parameters];
    
    __weak __typeof(&*self)weakSelf = self;
    
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted])
        //return;
        
        
        /*
        NSArray *posts = (NSArray *)responseObject;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Response Array", nil)
                                                        message:[NSString stringWithFormat:@"Length: %i", [posts count]]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
        
        
         
        // If we asked for more and we got what we had, there are no more posts to load
        if (more && ([posts count] <= [self.mediaModels count])) {
            self.hasOlderPosts = [NSNumber numberWithBool:NO];
        } else if (!more) {
            //we should reset the flag otherwise when you refresh this blog you can't get more than 20 posts
            self.hasOlderPosts = [NSNumber numberWithBool:YES];
        }
        
        [self mergePosts:posts];
        
        //self.lastHomeSync = [NSDate date];
        self.isSyncingHome = NO;
        */
        
        weakSelf.isSyncingHome = NO;
            
        
        
        if (success) {
            
            success(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing posts: %@", [error localizedDescription]);
        weakSelf.isSyncingHome = NO;
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
    
}

- (WPXMLRPCRequestOperation *)operationForMainFeedWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int num;
    
    // Don't load more than 20 posts if we aren't at the end of the table,
    // even if they were previously donwloaded
    //
    // Blogs with long history can get really slow really fast,
    // with no chance to go back
    int postBatchSize = 10;
    if (more) {
        num = MAX([self.mediaModels count], postBatchSize);
        if ([self.hasOlderPosts boolValue]) {
            num += postBatchSize;
        }
    } else {
        num = postBatchSize;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:[NSNumber numberWithInt:num]];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"bp.getRecentPosts" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted])
        //return;
        
        NSArray *posts = (NSArray *)responseObject;
        
        // If we asked for more and we got what we had, there are no more posts to load
        if (more && ([posts count] <= [self.mediaModels count])) {
            weakSelf.hasOlderPosts = [NSNumber numberWithBool:NO];
        } else if (!more) {
            //we should reset the flag otherwise when you refresh this blog you can't get more than 20 posts
            weakSelf.hasOlderPosts = [NSNumber numberWithBool:YES];
        }
        
        [weakSelf mergePosts:posts];
        
        //self.lastHomeSync = [NSDate date];
        weakSelf.isSyncingHome = NO;
        
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing posts: %@", [error localizedDescription]);
        weakSelf.isSyncingHome = NO;
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
    
}

- (void)syncProfileInfoWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    WPXMLRPCRequestOperation *operation = [self operationForProfileInfoWithSuccess:success failure:failure];
    [self.api enqueueXMLRPCRequestOperation:operation];
}



/*
- (void)syncCommentsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
	if (self.isSyncingComments) {
        WPLog(@"Already syncing comments. Skip");
        return;
    }
    self.isSyncingComments = YES;
    WPXMLRPCRequestOperation *operation = [self operationForCommentsWithSuccess:success failure:failure];
    [self.api enqueueXMLRPCRequestOperation:operation];
}

- (void)syncPostFormatsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    WPXMLRPCRequestOperation *operation = [self operationForPostFormatsWithSuccess:success failure:failure];
    [self.api enqueueXMLRPCRequestOperation:operation];
}

- (void)syncBlogWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    WPXMLRPCRequestOperation *operation;
    NSMutableArray *operations = [NSMutableArray arrayWithCapacity:6];
    operation = [self operationForOptionsWithSuccess:nil failure:nil];
    [operations addObject:operation];
    operation = [self operationForPostFormatsWithSuccess:nil failure:nil];
    [operations addObject:operation];
    operation = [self operationForCategoriesWithSuccess:nil failure:nil];
    [operations addObject:operation];
    if (!self.isSyncingComments) {
        operation = [self operationForCommentsWithSuccess:nil failure:nil];
        [operations addObject:operation];
        self.isSyncingComments = YES;
    }
    if (!self.isSyncingPosts) {
        operation = [self operationForPostsWithSuccess:nil failure:nil loadMore:NO];
        [operations addObject:operation];
        self.isSyncingPosts = YES;
    }
    if (!self.isSyncingPages) {
        operation = [self operationForPagesWithSuccess:nil failure:nil loadMore:NO];
        [operations addObject:operation];
        self.isSyncingPages = YES;
    }
    
    AFHTTPRequestOperation *combinedOperation = [self.api combinedHTTPRequestOperationWithOperations:operations success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [self.api enqueueHTTPRequestOperation:combinedOperation];
}

- (void)syncBlogPostsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    WPXMLRPCRequestOperation *operation;
    NSMutableArray *operations = [NSMutableArray arrayWithCapacity:4];
    operation = [self operationForOptionsWithSuccess:nil failure:nil];
    [operations addObject:operation];
    operation = [self operationForPostFormatsWithSuccess:nil failure:nil];
    [operations addObject:operation];
    operation = [self operationForCategoriesWithSuccess:nil failure:nil];
    [operations addObject:operation];
    if (!self.isSyncingPosts) {
        operation = [self operationForPostsWithSuccess:success failure:failure loadMore:NO];
        [operations addObject:operation];
        self.isSyncingPosts = YES;
    }
    
    AFHTTPRequestOperation *combinedOperation = [self.api combinedHTTPRequestOperationWithOperations:operations success:nil failure:nil];
    [self.api enqueueHTTPRequestOperation:combinedOperation];
}


- (void)checkActivationStatusWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    WPFLogMethod();
    WPXMLRPCClient *api = [WPXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
    [api callMethod:@"wpcom.getActivationStatus"
         parameters:[NSArray arrayWithObjects:[self hostURL], nil]
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *returnData = responseObject;
                if ([returnData isKindOfClass:[NSString class]]) {
                    //[self setBlogID:[returnData numericValue]];
                    [self setIsActivated:[NSNumber numberWithBool:YES]];
                    [self dataSave];
                }
                if (success) success();
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSString *errorMessage = [error localizedDescription];
                
                if ([errorMessage isEqualToString:@"Parse Error. Please check your XML-RPC endpoint."])
                {
                    [self setIsActivated:[NSNumber numberWithBool:YES]];
                    [self dataSave];
                    if (success) success();
                } else if ([errorMessage isEqualToString:@"Site not activated."]) {
                    if (failure) failure(error);
                } else if ([errorMessage isEqualToString:@"Blog not found."]) {
                    if (failure) failure(error);
                } else {
                    if (failure) failure(error);
                }
                
            }];
}

- (void)checkVideoPressEnabledWithSuccess:(void (^)(BOOL enabled))success failure:(void (^)(NSError *error))failure {
    if (!self.isWPcom) {
        if (success) success(YES);
        return;
    }
    NSArray *parameters = [self getXMLRPCArgsWithExtra:nil];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"wpcom.getFeatures" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL videoEnabled = YES;
        if(([responseObject isKindOfClass:[NSDictionary class]]) && ([responseObject objectForKey:@"videopress_enabled"] != nil))
            videoEnabled = [[responseObject objectForKey:@"videopress_enabled"] boolValue];
        else
            videoEnabled = YES;
        
        if (success) success(videoEnabled);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
    [self.api enqueueXMLRPCRequestOperation:operation];
}*/

#pragma mark - api accessor

- (WPXMLRPCClient *)api {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (_api == nil) {
        _api = [[WPXMLRPCClient alloc] initWithXMLRPCEndpoint:[NSURL URLWithString:kPhotoponComXMLRPCUrl]];
    }
    return _api;
}

- (WPXMLRPCClient *)pCom8CouponsApi {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (_pCom8CouponsApi == nil) {
        
        _pCom8CouponsApi = [[WPXMLRPCClient alloc] initWithXMLRPCEndpoint:[NSURL URLWithString:kPhotoponComXMLRPCUrl]];
    }
    return _api;
}

- (PhotoponComApi *)pComApi {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (_pComApi == nil) {
        _pComApi = [PhotoponComApi sharedApi];
    }
    return _pComApi;
}

- (PhotoponUserModel *)currentUser {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (_currentUser == nil) {
        _currentUser = [PhotoponUserModel currentUser];
    }
    // temporary fix
    if (!_currentUser) {
        return [[PhotoponUserModel alloc] init];
    }
    return _currentUser;
}


#pragma mark -

/*
-(void)hudTestUpload{
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.hud.mode = MBProgressHUDModeAnnularDeterminate;
    appDelegate.hud.labelText = @"Loading";
    
    
    
    / *
    [self operationForPostFormatsWithSuccess:<#^(void)success#> failure:<#^(NSError *error)failure#>:^(float progress) {
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.hud.progress = progress;
    
    } completionCallback:^{
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.hud hide:YES];
    }];
    * /
    
}
*/
- (WPXMLRPCRequestOperation *)operationForOptionsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:nil];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"wp.getOptions" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted] || self.managedObjectContext == nil)
            //return;
        
        weakSelf.options = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        NSString *minimumVersion = @"3.1";
        float version = [[weakSelf version] floatValue];
        if (version < [minimumVersion floatValue]) {
            if (weakSelf.lastUpdateWarning == nil || [self.lastUpdateWarning floatValue] < [minimumVersion floatValue]) {
                /*[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] showAlertWithTitle:NSLocalizedString(@"WordPress version too old", @"")
                                                                                      message:[NSString stringWithFormat:NSLocalizedString(@"The site at %@ uses WordPress %@. We recommend to update to the latest version, or at least %@", @""), [self hostname], [self version], minimumVersion]];
                */
                 weakSelf.lastUpdateWarning = minimumVersion;
            }
        }
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing options: %@", [error localizedDescription]);
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
}

- (WPXMLRPCRequestOperation *)operationForPostFormatsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"show-supported"];
    NSArray *parameters = [self getXMLRPCArgsWithExtra:dict];
    
    __weak __typeof(&*self)weakSelf = self;
    
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"wp.getPostFormats" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted])
            //return;
        
        NSDictionary *respDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        if ([respDict objectForKey:@"supported"] && [[respDict objectForKey:@"supported"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *supportedKeys = [NSMutableArray arrayWithArray:[respDict objectForKey:@"supported"]];
            // Standard isn't included in the list of supported formats? Maybe it will be one day?
            if (![supportedKeys containsObject:@"standard"]) {
                [supportedKeys addObject:@"standard"];
            }
            
            NSDictionary *allFormats = [respDict objectForKey:@"all"];
            NSMutableArray *supportedValues = [NSMutableArray array];
            for (NSString *key in supportedKeys) {
                [supportedValues addObject:[allFormats objectForKey:key]];
            }
            respDict = [NSDictionary dictionaryWithObjects:supportedValues forKeys:supportedKeys];
        }
        weakSelf.postFormats = respDict;
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing post formats: %@", [error localizedDescription]);
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
}

- (WPXMLRPCRequestOperation *)operationForCommentsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    NSDictionary *requestOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:100] forKey:@"number"];
    NSArray *parameters = [self getXMLRPCArgsWithExtra:requestOptions];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"wp.getComments" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted])
            //return;
        
        [weakSelf mergeComments:responseObject];
        weakSelf.isSyncingComments = NO;
        weakSelf.lastCommentsSync = [NSDate date];
        
        if (success) {
            success();
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:kCommentsChangedNotificationName object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing comments: %@", [error localizedDescription]);
        weakSelf.isSyncingComments = NO;
        
        if (failure) {
            failure(error);
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:kCommentsChangedNotificationName object:self];
    }];
    
    return operation;
}

- (WPXMLRPCRequestOperation *)operationForCategoriesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:nil];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"wp.getCategories" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted])
            //return;
        
        [self mergeCategories:responseObject];
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing categories: %@", [error localizedDescription]);
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
}

- (WPXMLRPCRequestOperation *)operationForPostsWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int num;
    
    // Don't load more than 20 posts if we aren't at the end of the table,
    // even if they were previously donwloaded
    //
    // Blogs with long history can get really slow really fast,
    // with no chance to go back
    int postBatchSize = 10;
    if (more) {
        num = MAX([self.mediaModels count], postBatchSize);
        if ([self.hasOlderPosts boolValue]) {
            num += postBatchSize;
        }
    } else {
        num = postBatchSize;
    }
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:[NSNumber numberWithInt:num]];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"metaWeblog.getRecentPosts" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted])
            //return;
        
        NSArray *posts = (NSArray *)responseObject;
        
        // If we asked for more and we got what we had, there are no more posts to load
        if (more && ([posts count] <= [self.mediaModels count])) {
            self.hasOlderPosts = [NSNumber numberWithBool:NO];
        } else if (!more) {
            //we should reset the flag otherwise when you refresh this blog you can't get more than 20 posts
            self.hasOlderPosts = [NSNumber numberWithBool:YES];
        }
        
        [self mergePosts:posts];
        
        //self.lastHomeSync = [NSDate date];
        self.isSyncingHome = NO;
        
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error syncing posts: %@", [error localizedDescription]);
        self.isSyncingHome = NO;
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
}

- (WPXMLRPCRequestOperation *)operationForPagesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure loadMore:(BOOL)more {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int num;
	
    int syncCount = [[self syncedTimeline] count];
    // Don't load more than 20 pages if we aren't at the end of the table,
    // even if they were previously donwloaded
    //
    // Blogs with long history can get really slow really fast,
    // with no chance to go back
    int pageBatchSize = 40;
    if (more) {
        num = MAX(syncCount, pageBatchSize);
        if ([self.hasOlderPages boolValue]) {
            num += pageBatchSize;
        }
    } else {
        num = pageBatchSize;
    }
    
    NSArray *parameters = [self getXMLRPCArgsWithExtra:[NSNumber numberWithInt:num]];
    WPXMLRPCRequest *request = [self.api XMLRPCRequestWithMethod:@"wp.getPages" parameters:parameters];
    WPXMLRPCRequestOperation *operation = [self.api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if ([self isDeleted])
            //return;
        
        NSArray *pages = (NSArray *)responseObject;
        
        // If we asked for more and we got what we had, there are no more pages to load
        if (more && ([pages count] <= syncCount)) {
            self.hasOlderPages = [NSNumber numberWithBool:NO];
        } else if (!more) {
            //we should reset the flag otherwise when you refresh this blog you can't get more than 20 pages
            self.hasOlderPages = [NSNumber numberWithBool:YES];
        }
        
        [self mergePages:pages];
        //self.lastPagesSync = [NSDate date];
        //self.isSyncingPages = NO;
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //WPFLog(@"Error syncing pages: %@", [error localizedDescription]);
        //self.isSyncingPages = NO;
        
        if (failure) {
            failure(error);
        }
    }];
    
    return operation;
}

#pragma mark -

- (void)mergeCategories:(NSArray *)newCategories {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Don't even bother if blog has been deleted while fetching categories
    //if ([self isDeleted] || self.managedObjectContext == nil)
        return;
    /*
	NSMutableArray *categoriesToKeep = [NSMutableArray array];
    for (NSDictionary *categoryInfo in newCategories) {
        Category *newCat = [Category createOrReplaceFromDictionary:categoryInfo forBlog:self];
        if (newCat != nil) {
            [categoriesToKeep addObject:newCat];
        } else {
            WPFLog(@"-[Category createOrReplaceFromDictionary:forBlog:] returned a nil category: %@", categoryInfo);
        }
    }
    
	NSSet *syncedCategories = self.categories;
	if (syncedCategories && (syncedCategories.count > 0)) {
		for (Category *cat in syncedCategories) {
			if(![categoriesToKeep containsObject:cat]) {
				WPLog(@"Deleting Category: %@", cat);
				[[self managedObjectContext] deleteObject:cat];
			}
		}
    }
    
    [self dataSave];
     */
}

- (void)mergePosts:(NSArray *)newPosts {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    /*
    // Don't even bother if blog has been deleted while fetching posts
    if ([self isDeleted] || self.managedObjectContext == nil)
        return;
    
    NSMutableArray *postsToKeep = [NSMutableArray array];
    for (NSDictionary *postInfo in newPosts) {
        NSNumber *postID = [[postInfo objectForKey:@"postid"] numericValue];
        Post *newPost = [Post findOrCreateWithBlog:self andPostID:postID];
        if (newPost.remoteStatus == AbstractPostRemoteStatusSync) {
            [newPost updateFromDictionary:postInfo];
        }
        [postsToKeep addObject:newPost];
    }
    
    NSArray *syncedPosts = [self syncedPosts];
    for (Post *post in syncedPosts) {
        
        if (![postsToKeep containsObject:post]) {  /*&& post.blog.blogID == self.blogID* /
			//the current stored post is not contained "as-is" on the server response
            
            if (post.revision) { //edited post before the refresh is finished
				//We should check if this post is already available on the blog
				BOOL presence = NO;
                
				for (Post *currentPostToKeep in postsToKeep) {
					if([currentPostToKeep.postID isEqualToNumber:post.postID]) {
						presence = YES;
						break;
					}
				}
				if( presence == YES ) {
					//post is on the server (most cases), kept it unchanged
				} else {
					//post is deleted on the server, make it local, otherwise you can't upload it anymore
					post.remoteStatus = AbstractPostRemoteStatusLocal;
					post.postID = nil;
					post.permaLink = nil;
				}
			} else {
				//post is not on the server anymore. delete it.
                WPLog(@"Deleting post: %@", post.postTitle);
                WPLog(@"%d posts left", [self.posts count]);
                [[self managedObjectContext] deleteObject:post];
            }
        }
    }
    
    [self dataSave];
     */
}

- (void)mergePages:(NSArray *)newPages {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    if ([self isDeleted] || self.managedObjectContext == nil)
        return;
    
    NSMutableArray *pagesToKeep = [NSMutableArray array];
    for (NSDictionary *pageInfo in newPages) {
        NSNumber *pageID = [[pageInfo objectForKey:@"page_id"] numericValue];
        Page *newPage = [Page findOrCreateWithBlog:self andPageID:pageID];
        if (newPage.remoteStatus == AbstractPostRemoteStatusSync) {
            [newPage updateFromDictionary:pageInfo];
        }
        [pagesToKeep addObject:newPage];
    }
    
    NSArray *syncedPages = [self syncedPages];
    for (Page *page in syncedPages) {
		if (![pagesToKeep containsObject:page]) { /*&& page.blog.blogID == self.blogID* /
            
			if (page.revision) { //edited page before the refresh is finished
				//We should check if this page is already available on the blog
				BOOL presence = NO;
                
				for (Page *currentPageToKeep in pagesToKeep) {
					if([currentPageToKeep.postID isEqualToNumber:page.postID]) {
						presence = YES;
						break;
					}
				}
				if( presence == YES ) {
					//page is on the server (most cases), kept it unchanged
				} else {
					//page is deleted on the server, make it local, otherwise you can't upload it anymore
					page.remoteStatus = AbstractPostRemoteStatusLocal;
					page.postID = nil;
					page.permaLink = nil;
				}
			} else {
				//page is not on the server anymore. delete it.
                WPLog(@"Deleting page: %@", page);
                [[self managedObjectContext] deleteObject:page];
            }
        }
    }
    
    [self dataSave];
     */
}

- (void)mergeComments:(NSArray *)newComments {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    // Don't even bother if blog has been deleted while fetching comments
    if ([self isDeleted] || self.managedObjectContext == nil)
        return;
    
	NSMutableArray *commentsToKeep = [NSMutableArray array];
    for (NSDictionary *commentInfo in newComments) {
        Comment *newComment = [Comment createOrReplaceFromDictionary:commentInfo forBlog:self];
        if (newComment != nil) {
            [commentsToKeep addObject:newComment];
        } else {
            WPFLog(@"-[Comment createOrReplaceFromDictionary:forBlog:] returned a nil comment: %@", commentInfo);
        }
    }
    
	NSSet *syncedComments = self.comments;
    if (syncedComments && (syncedComments.count > 0)) {
		for (Comment *comment in syncedComments) {
			// Don't delete unpublished comments
			if(![commentsToKeep containsObject:comment] && comment.commentID != nil) {
				WPLog(@"Deleting Comment: %@", comment);
				[[self managedObjectContext] deleteObject:comment];
			}
		}
    }
    
    [self dataSave];
     */
}

@end

