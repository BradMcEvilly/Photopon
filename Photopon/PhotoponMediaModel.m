//
//  PhotoponMediaModel.m
//  Photopon
//
//  Created by Bradford McEvilly on 6/17/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponMediaModel.h"
//#import "PhotoponCoordinateModel.h"
#import "PhotoponUserModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponImageModel.h"
#import "PhotoponTagModel.h"
#import "PhotoponCouponModel.h"
#import "PhotoponAppDelegate.h"
//#import "NSMutableDictionary+Helpers.h"
//#import "AbstractPhotoponPost.h"
#import "PhotoponBaseModel.h"
#import "PhotoponModel.h"
#import "PhotoponFile.h"
#import "PhotoponUploadHeaderView.h"
#import "PhotoponHomeViewController.h"
#import "Photopon8CouponsModel.h"
#import "NSString+Helpers.h"
#import "PhotoponNewPhotoponUtility.h"

NSString * const kInstagramUserMediaRecentEndpoint = @"users/%@/media/recent";

@interface PhotoponMediaModel ()

//@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@interface PhotoponMediaModel(InternalProperties)
// We shouldn't need to store this, but if we don't send IDs on edits
// custom fields get duplicated and stop working
@property (nonatomic, strong) NSString *latitudeID;
@property (nonatomic, strong) NSString *longitudeID;
@property (nonatomic, strong) NSString *publicID;
@end

#pragma mark -
/*
@interface AbstractPhotoponPost (PhotoponApi)
- (NSDictionary *)XMLRPCDictionary;
@end
*/
@interface PhotoponMediaModel (PhotoponApi)
- (NSDictionary *)XMLRPCDictionary;
- (void)postPostWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)getPostWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)editPostWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)deletePostWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
@end

@interface PhotoponMediaModel(PrivateMethods)
- (void)xmlrpcUploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure ;
+ (PhotoponMediaModel *)newPost;
- (void)updateFromDictionary:(NSDictionary *)postInfo;
- (void)uploadInBackground;
- (void)didUploadInBackground;
- (void)failedUploadInBackground;
@end

@implementation PhotoponMediaModel{
    AFHTTPRequestOperation *_uploadOperation;
}

@synthesize appDelegate;
@synthesize photoponMediaImageFile;
@synthesize remoteStatusNumber;
@synthesize remoteStatus;
@synthesize screenshotLocalURL;

static PhotoponMediaModel* newDraft = nil;

+ (PhotoponMediaModel*)modelWithDictionary:(NSMutableDictionary*)dict {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (![dict objectForKey:kPhotoponModelIdentifierKey]) {
        return nil;
    }
    
    PhotoponMediaModel* pModel = [[PhotoponMediaModel alloc] init];
    
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [pModel.dictionary setObject:kPhotoponMediaClassName forKey:kPhotoponEntityNameKey];
    
    NSDate *createdDateObj = [NSDate dateFromString:[pModel objectForKey:kPhotoponCreatedTimeKey]];
    
    [pModel.dictionary setObject:createdDateObj forKey:kPhotoponCreatedTimeKey];
    [pModel.dictionary setValue:[NSNumber numberWithBool:YES] forKey:kPhotoponHasBeenFetchedKey];
    
    return pModel;
    /*
    
    PhotoponMediaModel* pModel = [[[self class] alloc] init];
    pModel.dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [pModel.dictionary setObject:kPhotoponClassName forKey:kPhotoponEntityNameKey];
    return pModel;
     */
}

+ (NSArray*)modelsFromDictionaries:(NSArray*)dicts {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:[dicts count]];
    for (NSDictionary* modelDict in dicts) {
        [models addObject:[PhotoponMediaModel modelWithDictionary:modelDict]];
    }
    return models;
}

/* ***************************************************************** */
// uploadPhotoponMediaModel
/* ***************************************************************** */
//
/* Uploads the new Photopon Draft
 *
 * NOTE:    THIS NEEDS TO BE BROKEN INTO 2 MAIN PARTS
 *      
 *          1). THE HTML DATA
 *          2). IMAGE FILE DATA
 *              - THE HTML DATA SUCCESS BLOCK WILL CALL ENCAPSULATED
 *                IMAGE UPLOAD WITH SUCCESS BLOCK
 *                                                                   */
/* ***************************************************************** */
- (void)uploadPhotoponMediaModel
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //  show HUD and retain it (showHUDAddedTo:animated: returns autoreleased object)
    //[self.appDelegate.hud show:YES];
    
    
    //  observe properties on the dataManager
    [self addObserver:self forKeyPath:@"pmm.progress" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"photoponModelManager.cleanedUp" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"dataManager.downHUD" options:NSKeyValueObservingOptionNew context:nil];
    
    //  begin your download here...
    
    //self.appDelegate.hud.labelText = NSLocalizedString(@"Connecting", "");
    //self.appDelegate.hud.detailsLabelText = @" ";
    
    //self.appDelegate.hud.progress = photoponFile.progress;
    
}

-(void) userDidLike:(PhotoponUIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *parameters = [self.appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:self.identifier, self.user.identifier, nil]];
    
    [self.appDelegate.pmm.api callMethod:kPhotoponAPIMethodPostLike parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Media Liked"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [alert show];
        */
        
        [self.dictionary setObject:@"1" forKey:kPhotoponMediaAttributesDidLikeBoolKey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor network connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        [self.dictionary setObject:@"0" forKey:kPhotoponMediaAttributesDidLikeBoolKey];
        
        [button setSelected:NO];
        
    }];
}

-(void) userDidUnlike:(PhotoponUIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *parameters = [self.appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:self.identifier, self.user.identifier, nil]];
    
    [self.appDelegate.pmm.api callMethod:kPhotoponAPIMethodPostUnlike parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Media Unliked"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [alert show];
        */
        [self.dictionary setObject:@"0" forKey:kPhotoponMediaAttributesDidLikeBoolKey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor network connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        [self.dictionary setObject:@"1" forKey:kPhotoponMediaAttributesDidLikeBoolKey];
        
        [button setSelected:YES];
        
    }];
}

- (void) userDidSnip:(PhotoponUIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *parameters = [self.appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:self.identifier, self.user.identifier, nil]];
    
    [self.appDelegate.pmm.api callMethod:kPhotoponAPIMethodPostSnip parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Media Snipped!"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [alert show];
        */
        
        [self.dictionary setObject:@"1" forKey:kPhotoponMediaAttributesDidSnipBoolKey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor network connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        [self.dictionary setObject:@"0" forKey:kPhotoponMediaAttributesDidSnipBoolKey];
        
        [button setSelected:NO];
        
    }];
}

-(void) userDidUnsnip:(PhotoponUIButton *)button{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *parameters = [self.appDelegate.pmm getXMLRPCArgsWithExtra:[NSArray arrayWithObjects:self.identifier, self.user.identifier, nil]];
    
    [self.appDelegate.pmm.api callMethod:kPhotoponAPIMethodPostUnsnip parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Media Unsnipped!"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [alert show];
        */
        [self.dictionary setObject:@"0" forKey:kPhotoponMediaAttributesDidSnipBoolKey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor network connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        [self.dictionary setObject:@"1" forKey:kPhotoponMediaAttributesDidSnipBoolKey];
        
        [button setSelected:YES];
        
    }];
    
}



-(NSString*)identifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesIdentifierKey];
}
-(NSString*)coordinate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesCoordinateKey];
}
-(NSString*)value{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesValueTitleKey];
}
-(NSString*)cost{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesCostKey];
}
-(NSString*)monetaryValue{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesMonetaryValueKey];
}
-(NSString*)socialValue{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesSocialValueKey];
}
-(NSString*)caption{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesCaptionKey];
}
-(NSString*)linkURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesLinkURLKey];
}
-(NSUInteger)likeCount{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[self.dictionary objectForKey:kPhotoponMediaAttributesLikeCountKey] integerValue];
}
-(NSUInteger)commentCount{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[self.dictionary objectForKey:kPhotoponMediaAttributesCommentCountKey] integerValue];
}
-(NSUInteger)snipCount{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[self.dictionary objectForKey:kPhotoponMediaAttributesSnipCountKey] integerValue];
}

-(PhotoponUserModel*)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponUserModel modelWithDictionary:(NSDictionary*)[self.dictionary objectForKey:kPhotoponMediaAttributesUserKey]];
}

-(PhotoponCouponModel*)coupon{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponCouponModel modelWithDictionary:(NSMutableDictionary*)[self.dictionary objectForKey:kPhotoponMediaAttributesCouponKey]];
}

-(NSString*)image{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return nil;//[self.dictionary objectForKey:kPhotoponMediaAttributesIdentifierKey];
}

-(NSString*)thumbURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesThumbURLKey];
}

-(NSString*)imageMidURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesImageMidURLKey];
}

-(NSString*)imageLargeURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesImageLargeURLKey];
}
-(NSString*)locationIdentifier{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesLocationIdentifierKey];
}
-(NSString*)locationLatitude{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesLocationLatitudeKey];
}

-(NSString*)locationLongitude{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesLocationLongitudeKey];
}

-(NSString*)createdTime{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (NSString*)[self.dictionary objectForKey:kPhotoponMediaAttributesCreatedTimeKey];
}

-(NSDictionary*)users{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesUsersKey];
}

-(NSDictionary*)tags{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.dictionary objectForKey:kPhotoponMediaAttributesTagsKey];
}

-(NSNumber*)didLike{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSNumber numberWithBool:[[NSString stringWithFormat:@"%@", [self.dictionary objectForKey:kPhotoponMediaAttributesDidLikeBoolKey]] boolValue]];
}

-(NSNumber*)didSnip{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [NSNumber numberWithBool:[[NSString stringWithFormat:@"%@", [self.dictionary objectForKey:kPhotoponMediaAttributesDidSnipBoolKey]] boolValue]];
    
}

- (BOOL)didLikeBool {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //return (BOOL)[[self didLike] boolValue];
    //return [[self.dictionary objectForKey:kPhotoponMediaAttributesDidLikeBoolKey] boolValue];
    return [(NSString*)[self.dictionary objectForKey:kPhotoponMediaAttributesDidLikeBoolKey] boolValue];
}

- (void)setDidLikeBool:(BOOL)didLikeBoolLocal {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self setDidLike:[NSNumber numberWithBool:didLikeBoolLocal]];
    NSMutableDictionary *dictNew = [NSDictionary dictionaryWithDictionary:self.dictionary];
    [dictNew setObject:[NSNumber numberWithBool:didLikeBoolLocal]  forKey:kPhotoponMediaAttributesDidLikeBoolKey];
    [self setDictionary:dictNew];
}

- (BOOL)didSnipBool {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    //return (BOOL)[[self didSnip] boolValue];
    //return [[self.dictionary objectForKey:kPhotoponMediaAttributesDidSnipBoolKey] boolValue];
    return [(NSString*)[self.dictionary objectForKey:kPhotoponMediaAttributesDidSnipBoolKey] boolValue];
}

- (void)setDidSnipBool:(BOOL)didSnipBoolLocal {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self setDidSnip:[NSNumber numberWithBool:didSnipBoolLocal]];
    NSMutableDictionary *dictNew = [NSDictionary dictionaryWithDictionary:self.dictionary];
    [dictNew setObject:[NSNumber numberWithBool:didSnipBoolLocal]  forKey:kPhotoponMediaAttributesDidSnipBoolKey];
    [self setDictionary:dictNew];
}

-(PhotoponAppDelegate *)appDelegate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
}


- (id)initWithAttributes:(NSDictionary *)attributes {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    
    /*
    self.identifier         = [attributes objectForKey:kPhotoponMediaAttributesIdentifierKey];
    self.coordinate         = [attributes objectForKey:kPhotoponMediaAttributesCoordinateKey];
    self.value              = [attributes objectForKey:kPhotoponMediaAttributesValueTiteKey];
    self.cost               = [attributes objectForKey:kPhotoponMediaAttributesCostKey];
    self.monetaryValue      = [attributes objectForKey:kPhotoponMediaAttributesMonetaryValueKey];
    self.socialValue        = [attributes objectForKey:kPhotoponMediaAttributesSocialValueKey];
    self.caption            = [attributes objectForKey:kPhotoponMediaAttributesCaptionKey];
    self.linkURL            = [attributes objectForKey:kPhotoponMediaAttributesLinkURLKey];
    self.likeCount          = [[attributes objectForKey:kPhotoponMediaAttributesLikeCountKey] integerValue];//[attributes objectForKey:kPhotoponMediaAttributesLikeCountKey];
    self.commentCount       = [[attributes objectForKey:kPhotoponMediaAttributesCommentCountKey] integerValue];
    self.snipCount          = [[attributes objectForKey:kPhotoponMediaAttributesSnipCountKey] integerValue];
    //self.user               = [[PhotoponUserModel alloc] initWithAttributes:(NSDictionary*)[attributes objectForKey:kPhotoponMediaAttributesUserKey]];
    //self.coupon             = [[PhotoponCouponModel alloc] initWithAttributes:(NSDictionary*)[attributes objectForKey:kPhotoponMediaAttributesCouponKey]];
    self.image              = nil;//[PhotoponImageModel alloc numberWithInt:(NSInteger)[attributes objectForKey:@"didFollow"]];
    
    self.thumbURL           = [attributes objectForKey:kPhotoponMediaAttributesThumbURLKey];
    self.imageMidURL        = [attributes objectForKey:kPhotoponMediaAttributesImageMidURLKey];
    self.imageLargeURL      = [attributes objectForKey:kPhotoponMediaAttributesImageLargeURLKey];
    self.locationIdentifier = [attributes objectForKey:kPhotoponMediaAttributesLocationIdentifierKey];
    self.locationLatitude   = [attributes objectForKey:kPhotoponMediaAttributesLocationLatitudeKey];
    self.locationLongitude  = [attributes objectForKey:kPhotoponMediaAttributesLocationLongitudeKey];
    
    self.createdTime        = [attributes objectForKey:kPhotoponMediaAttributesCreatedTimeKey];
    self.users              = [attributes objectForKey:kPhotoponMediaAttributesUsersKey];
    self.tags               = [attributes objectForKey:kPhotoponMediaAttributesTagsKey];
    
    self.didLike            = [attributes objectForKey:kPhotoponMediaAttributesDidLikeKey];
    self.didSnip            = [attributes objectForKey:kPhotoponMediaAttributesDidSnipKey];
    
     self.didLikeBool        = (BOOL)[attributes objectForKey:kPhotoponMediaAttributesDidLikeBoolKey];
     self.didSnipBool      = (BOOL)[attributes objectForKey:kPhotoponMediaAttributesDidSnipBoolKey];
     
     return self;
     */
    
    return self;
    
}

/**
 Creates an empty local post associated with blog
 */
+ (PhotoponMediaModel *)newPhotoponDraft{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(newDraft != nil)
        return newDraft;
    
    newDraft = nil;
    
    //NSString* userId = (NSString* )[[EGOCache globalCache] stringForKey:kPhotoponUserAttributesCurrentUserKey];
    //NSString *defaultsUserId = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesFacebookAccessTokenKey];
    
    NSLog(@"newPhotoponDraft 1");
    
    //NSMutableDictionary *newPhotoponDraftMedia = [(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponMediaKey] mutableCopy];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:kPhotoponMediaAttributesNewPhotoponMediaKey];
    NSMutableDictionary *newPhotoponDraftMedia = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    
    NSLog(@"newPhotoponDraft 2");
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cached User ID"
     message:userId
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     [alert show];
     */
    
    if(newPhotoponDraftMedia){
        
        // see if we have an image filepath
        
        NSLog(@"newPhotoponDraft 3");
        
        NSString *newPhotoponDraftFilePath = (NSString*)[newPhotoponDraftMedia objectForKey:kPhotoponMediaAttributesCouponKey];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            newPhotoponDraftFilePath = %@", self, NSStringFromSelector(_cmd), newPhotoponDraftFilePath);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        PhotoponCouponModel *cModel = [PhotoponCouponModel newPhotoponDraftCoupon];
        
        NSLog(@"newPhotoponDraft 4");
        
        if (cModel) {
            NSLog(@"newPhotoponDraft 5");
            [newPhotoponDraftMedia setObject:cModel forKey:kPhotoponMediaAttributesCouponKey];
        }
        
        NSLog(@"newPhotoponDraft 6");
        
        [PhotoponMediaModel setNewPhotoponDraft:[PhotoponMediaModel modelWithDictionary:newPhotoponDraftMedia]];
        
        NSLog(@"newPhotoponDraft 7");
        
        return [PhotoponMediaModel newPhotoponDraft];
    }
    
    NSLog(@"newPhotoponDraft 8");
    
    return newDraft;
}

+ (void)setNewPhotoponDraft:(PhotoponMediaModel *)mediaModel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    newDraft = mediaModel;
    
    NSLog(@"setNewPhotoponDraft 1");
    
    //[[NSNotificationCenter defaultCenter] addObserver:newDraft selector:@selector(didCropImage:) name:PhotoponNotificationDidCropImage object:nil];
    [newDraft cacheMediaAttributes];
    
    NSLog(@"setNewPhotoponDraft 2");
    
}

+ (NSString*)messageForNewPhotoponDraftCancel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [[NSString alloc] initWithFormat:@"%@", kNewPhotoponDraftCancelMessage];
}

+ (void)cancelNewPhotoponDraft{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponMediaModel newPhotoponDraft] cancelUpload];
    [PhotoponMediaModel clearNewPhotoponDraft];
}

- (void)cancelUpload {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.remoteStatus == MediaModelRemoteStatusPushing || self.remoteStatus == MediaModelRemoteStatusProcessing) {
        [_uploadOperation cancel];
        _uploadOperation = nil;
        self.remoteStatus = MediaModelRemoteStatusFailed;
    }
}

- (void)cropMediaInBackgroundWithMediaSize:(CGSize)targetSize{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        UIImage* image = [weakSelf rawImage];
        
        CGFloat resizeScale = (image.size.width / targetSize.width);
        
        NSLog(@"||||||||||||||>     1");
        
        CGSize size = image.size;
        
        NSLog(@"||||||||||||||>     2");
        
        CGSize cropSize = CGSizeMake(targetSize.width * resizeScale, targetSize.height * resizeScale);
        
        NSLog(@"||||||||||||||>     3");
        
        CGFloat scalex = cropSize.width / size.width;
        CGFloat scaley = cropSize.height / size.height;
        CGFloat scale = MAX(scalex, scaley);
        
        NSLog(@"||||||||||||||>     4");
        
        NSLog(@"||||||||||||||>     5");
        
        CGFloat width = size.width * scalex;
        CGFloat height = size.height * scaley;
        
        NSLog(@"||||||||||||||>     6");
        
        CGFloat originX = ((cropSize.width - width) / 2.0f);
        CGFloat originY = ((cropSize.height - height) / 2.0f) + ([PhotoponNewPhotoponUtility photoponCropFrameOffset] * resizeScale);
        
        NSLog(@"||||||||||||||>     7");
        
        CGRect rect = CGRectMake(originX, originY, size.width * scalex, size.height * scaley);
        
        [weakSelf.photoponMediaImageFile setImage:image withSize:rect.size];
        if (weakSelf.photoponCroppedImageView) {
            [weakSelf.photoponCroppedImageView setFile:weakSelf.photoponMediaImageFile];
        }
    });
}

/*
-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (buttonIndex == 1) {
        NSURLCredential *credential;
        if ([_challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            credential = [NSURLCredential credentialForTrust:_challenge.protectionSpace.serverTrust];
        } else {
            NSString *username, *password;
            if ([self respondsToSelector:@selector(setAlertViewStyle:)]) {
                username = [[self textFieldAtIndex:0] text];
                password = [[self textFieldAtIndex:1] text];
            } else {
                username = usernameField.text;
                password = passwordField.text;
            }
            credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistencePermanent];
        }
        
        [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:[_challenge protectionSpace]];
        [[_challenge sender] useCredential:credential forAuthenticationChallenge:_challenge];
    } else {
        [[_challenge sender] cancelAuthenticationChallenge:_challenge];
    }
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}
*/

+ (void)clearNewPhotoponDraft{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(newDraft){
        newDraft = nil;
        
        [[EGOCache globalCache] removeCacheForKey:kPhotoponMediaAttributesNewPhotoponMediaKey];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPhotoponMediaAttributesNewPhotoponMediaKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [PhotoponCouponModel clearNewPhotoponDraftCoupon];
    }
}

+ (PhotoponMediaModel *)modelFromCache{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // leave alone for now...
    return nil;
}

- (void) cacheMediaAttributes{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // make sure we have a dictionary and and image or something already went wrong
    if (!self.dictionary) {
        return;
    }
    
    NSLog(@"cacheMediaAttributes 1");
    
    PhotoponCouponModel *cModel = self.coupon;
    
    if (cModel) {
        
        NSLog(@"cacheMediaAttributes 2");
        
        [PhotoponCouponModel setNewPhotoponDraftCoupon:cModel];
        
        NSLog(@"cacheMediaAttributes 3");
        
        [self.dictionary removeObjectForKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        NSLog(@"cacheMediaAttributes 4");
        
        
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //NSMutableArray *arr = ; // set value
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dictionary];
        [defaults setObject:data forKey:kPhotoponMediaAttributesNewPhotoponMediaKey];
        
        [defaults synchronize];
        
        [self.dictionary setObject:cModel forKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        /*
        
        [[NSUserDefaults standardUserDefaults] setObject:self.dictionary forKey:kPhotoponMediaAttributesNewPhotoponMediaKey];
        
        NSLog(@"cacheMediaAttributes 5");
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"cacheMediaAttributes 6");
        
        [self.dictionary setObject:cModel forKey:kPhotoponMediaAttributesNewPhotoponCouponKey];
        
        NSLog(@"cacheMediaAttributes 7");
        */
    }else{
        
        NSLog(@"cacheMediaAttributes 8");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //NSMutableArray *arr = ; // set value
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dictionary];
        [defaults setObject:data forKey:kPhotoponMediaAttributesNewPhotoponMediaKey];
        
        [defaults synchronize];
        
    }
}

- (void) convert8CouponsDictToCoupons:(NSMutableDictionary*)dict8Coupons{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.dictionary setObject:[Photopon8CouponsModel couponModelWith8CouponsDictionary:dict8Coupons] forKey:kPhotoponMediaAttributesCouponKey];
}

- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"            self.dictionary = %@", self.dictionary);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //[self save];
    
    self.remoteStatus = MediaModelRemoteStatusLocal;
    
    self.photoponMediaImageFile.progress = 0.0f;
    
    [self xmlrpcUploadWithSuccess:success failure:failure];
}

- (void)takeScreenshot:(UIView*)targetView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UIImage *screenCaptureImage = [targetView screenshot];
    
    //return screenCaptureImage;
    
    NSData *imageData = UIImageJPEGRepresentation(screenCaptureImage, 0.90);
	//UIImage *imageThumbnail = [image thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"screenshot-%@.jpg", [formatter stringFromDate:[NSDate date]]];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
    
    self.screenshotLocalURL = [[NSString alloc] initWithFormat:@"%@", filepath];
}

- (void)xmlrpcUploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSString *mimeType = ([self.photoponMediaImageFile.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
    
    //NSString *tmpName   = [[[NSString alloc] initWithString:self.filename] retain];
    //NSString *tmpName   = [[[NSString alloc] initWithFormat:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/%@", self.filename] retain];
    
    NSString *localFileNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponLocalImageFileNameKey];
    NSString *localURLStr = [[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponMediaAttributesNewPhotoponLocalImageFilePathKey];
    
    
    
    //NSString *tmpName   = [[NSString alloc] initWithFormat:@"/tmp/%@", self.photoponMediaImageFile.filename];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"");
    NSLog(@"-------->                self.coupon.place.bio = %@", self.coupon.place.bio);
    NSLog(@"");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.dictionary setObject:self.coupon.value forKey:kPhotoponMediaAttributesValueTitleKey];
    
    NSDictionary *pComRequestArray = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      mimeType, @"type",
                                      localFileNameStr, @"filename",
                                      localURLStr, @"tmp_name",
                                      self.photoponMediaImageFile.filesize, @"size",
                                      [NSNumber numberWithInteger:0], @"error",
                                      [NSInputStream inputStreamWithFileAtPath:self.photoponMediaImageFile.localURL], @"bits",
                                      self.caption, @"title",
                                      self.value, @"mvalue",
                                      self.coupon.couponURL, @"coupon_url",
                                      self.coupon.details, @"details",
                                      self.coupon.terms, @"terms",
                                      self.coupon.instructions, @"instructions",
                                      [PhotoponUtility photoponDateStringWith8CouponsDateString:self.coupon.expirationString], @"expiration",
                                      self.coupon.couponType, @"coupon_type",
                                      self.coupon.startString, @"start",
                                      nil];
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->            self.coupon.expirationString = %@", self.coupon.expirationString);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->            self.coupon.expiration = %@", self.coupon.expiration);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->            self.coupon.details = %@", self.coupon.details);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSDictionary *pComRequestArray2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       self.coupon.place.name, @"name",
                                       self.coupon.place.street, @"street",
                                       self.coupon.place.city, @"city",
                                       self.coupon.place.zip, @"zip",
                                       self.coupon.place.bio, @"bio", //bio, @"bio", //self.coupon.place.bio, @"bio",
                                       self.coupon.place.phone, @"phone",
                                       self.coupon.place.publicID, @"public_id",
                                       self.coupon.place.category, @"category",
                                       self.coupon.place.imageUrl, @"imageUrl",
                                       self.coupon.place.locationIdentifier, @"locationIdentifier",
                                       self.coupon.place.locationLatitude, @"locationLatitude",
                                       self.coupon.place.locationLongitude, @"locationLongitude",
                                       self.coupon.place.rating, @"rating",
                                       self.coupon.place.url, @"url",
                                       nil];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->            self.coupon.place.bio = %@", self.coupon.place.bio);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    /*
    NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
                            mimeType, @"type",
                            localFileNameStr, @"name",
                            [NSInputStream inputStreamWithFileAtPath:localURLStr], @"bits",
                            nil];
    */
    
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithArray:[self.photoponMediaImageFile.pmm getXMLRPCArgsWithExtra:pComRequestArray]];
    [parameters addObject:pComRequestArray2];
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->           A parameters = %@", parameters );
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //NSArray *parameters = [self.photoponMediaImageFile.pmm getXMLRPCArgsWithExtra:object];
    
    self.remoteStatus = MediaModelRemoteStatusProcessing;
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
        // Create the request asynchronously
        // TODO: use streaming to avoid processing on memory
        NSMutableURLRequest *request = [weakSelf.photoponMediaImageFile.pmm.api requestWithMethod:kPhotoponAPIMethodUploadPhotopon parameters:parameters];
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---->           B parameters = %@", parameters );
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"---->           C parameters = %@", parameters );
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                
                //if ([self isDeleted])
                //return;
                
                if ([weakSelf.photoponMediaImageFile.mediaType isEqualToString:@"featured"]) {
                    
                    //[[NSNotificationCenter defaultCenter] postNotificationName:FeaturedImageUploadFailed object:self];
                    
                }
                
                weakSelf.remoteStatus = MediaModelRemoteStatusFailed;
                _uploadOperation = nil;
                if (failure) failure(error);
            };
            AFHTTPRequestOperation *operation = [weakSelf.photoponMediaImageFile.pmm.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //if ([self isDeleted])
                //return;
                
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"---->           D parameters = %@", parameters );
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                
                NSDictionary *response = (NSDictionary *)responseObject;
                
                if (![response isKindOfClass:[NSDictionary class]]) {
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"The server returned an empty response. This usually means you need to increase the memory limit in your blog", @"")}];
                    failureBlock(operation, error);
                    return;
                }
                if([response objectForKey:@"videopress_shortcode"] != nil)
                    weakSelf.photoponMediaImageFile.shortcode = [response objectForKey:@"videopress_shortcode"];
                
                if([response objectForKey:@"url"] != nil)
                    weakSelf.photoponMediaImageFile.remoteURL = [response objectForKey:@"url"];
                
                if ([response objectForKey:@"id"] != nil) {
                    weakSelf.photoponMediaImageFile.mediaID = [response objectForKey:kPhotoponModelIdentifierKey];
                }
                
                weakSelf.remoteStatus = MediaModelRemoteStatusSync;
                _uploadOperation = nil;
                
                
                if([weakSelf.photoponMediaImageFile.mediaType isEqualToString:@"video"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                                                                        object:weakSelf
                                                                      userInfo:response];
                } else if ([weakSelf.photoponMediaImageFile.mediaType isEqualToString:@"image"]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
                                                                        object:weakSelf
                                                                      userInfo:response];
                } else if ([weakSelf.photoponMediaImageFile.mediaType isEqualToString:@"featured"]){
                    //[[NSNotificationCenter defaultCenter] postNotificationName:FeaturedImageUploadSuccessful object:self userInfo:response];
                    
                }
                
                if (success) success();
                
            } failure:failureBlock];
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //if ([self isDeleted])
                    //return;
                    weakSelf.photoponMediaImageFile.photoponUploadHeaderView.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite *100;
                    
                    //self.photoponMediaImageFile.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                });
            }];
            
            _uploadOperation = operation;
            
            // Upload might have been canceled while processing
            if (weakSelf.remoteStatus == MediaModelRemoteStatusProcessing) {
                weakSelf.remoteStatus = MediaModelRemoteStatusPushing;
                [weakSelf.photoponMediaImageFile.pmm.api enqueueHTTPRequestOperation:operation];
            }
        });
    });
}

- (MediaModelRemoteStatus)remoteStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return (MediaModelRemoteStatus)[[self remoteStatusNumber] intValue];
}

- (void)setRemoteStatus:(MediaModelRemoteStatus)aStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setRemoteStatusNumber:[NSNumber numberWithInt:aStatus]];
    
    //if (!self.photoponUploadHeaderView)
        //self.photoponUploadHeaderView = [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] homeViewController].uploadHeaderView;
    
    __weak __typeof(&*self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        [weakSelf.photoponUploadHeaderView setRemoteStatus:aStatus];
        
        if ( aStatus == MediaModelRemoteStatusPushing )
            weakSelf.photoponUploadHeaderView.photoponMediaPhotoUploadStatusText = [NSString stringWithFormat:@"%@ %@", [PhotoponMediaModel titleForRemoteStatus:weakSelf.remoteStatusNumber], @"0%"];
        else
            weakSelf.photoponUploadHeaderView.photoponMediaPhotoUploadStatusText = [NSString stringWithFormat:@"%@", [PhotoponMediaModel titleForRemoteStatus:weakSelf.remoteStatusNumber]];
    });
    
    
}

+ (NSString *)titleForRemoteStatus:(NSNumber *)remoteStatus {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch ([remoteStatus intValue]) {
        case MediaModelRemoteStatusPushing:
            return NSLocalizedString(@"Uploading", @"");
            break;
        case MediaModelRemoteStatusFailed:
            return NSLocalizedString(@"Failed", @"");
            break;
        case MediaModelRemoteStatusSync:
            return NSLocalizedString(@"Finishing up", @"");
            break;
        default:
            return NSLocalizedString(@"Pending", @"");
            break;
    }
}

- (NSString *)remoteStatusText {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [PhotoponMediaModel titleForRemoteStatus:self.remoteStatusNumber];
}

- (UIImage *)thumbNailImage {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponMediaImageFile) {
        return nil;
    }
    return [UIImage imageWithData:self.photoponMediaImageFile.thumbnail];
}

- (UIImage *)croppedImage {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponMediaImageFile || !self.photoponMediaImageFile.localURL) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:self.photoponMediaImageFile.localURL];
}

- (UIImage *)rawImage {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponMediaImageFile || !self.photoponMediaImageFile.localURLRaw) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:self.photoponMediaImageFile.localURLRaw];
}

- (UIImage *)screenshotImage {
    
    if (!self.screenshotLocalURL) {
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:self.screenshotLocalURL];
    
}

/*
- (void)didCropImage:(NSNotification *)notification
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.photoponMediaImageFile) {
        self.photoponMediaImageFile = [[PhotoponFile alloc] init];
    }
    [self.photoponMediaImageFile setImage:(UIImage*)[notification.userInfo objectForKey:@"croppedImage"]];
    self.photoponCroppedImageView.file = self.photoponMediaImageFile;
}*/

@end


