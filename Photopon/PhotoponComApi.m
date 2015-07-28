//
//  PhotoponComApi.m
//  Photopon
//
//  Created by Jorge Bernal on 6/4/12.
//  Copyright (c) 2012 Photopon. All rights reserved.
//

#import "PhotoponApi.h"
#import "PhotoponComApi.h"
#import "SFHFKeychainUtils.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponConstants.h"
#import "PhotoponUserModel.h"

@interface PhotoponComApi ()
@property (readwrite, nonatomic, retain) NSString *username;
@property (readwrite, nonatomic, retain) NSString *password;
@end

@implementation PhotoponComApi
@dynamic username;
@dynamic password;

+ (PhotoponComApi *)sharedApi {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    static PhotoponComApi *_sharedApi = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"pcom_username_preference"];
        NSString *password = nil;
        if (username) {
            NSError *error = nil;
            password = [SFHFKeychainUtils getPasswordForUsername:username
                                                  andServiceName:@"Photopon.com"
                                                           error:&error];
        }
        _sharedApi = [[self alloc] initWithXMLRPCEndpoint:[NSURL URLWithString:kPhotoponComXMLRPCUrl] username:username password:password];
    });
    
    return _sharedApi;

}

- (NSArray*) photoponProfileGalleryWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getMyGallery" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
                                                            message:@"You have gallery items!"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                  otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
        alertView.tag = 20;
        [alertView show];
        [alertView release];
        */
        
        
    } failure:^(NSError *error) {
        //
        /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
                                                            message:[error localizedDescription] 
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                  otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        alertView.tag = 20;
        [alertView show];
        [alertView release];
        */
        
        
    }];
    
}

- (NSArray*) photoponProfileGalleryForUserID:(NSString*)userIdentifier andPage:(NSInteger)pageInt withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // cannot send integer because it's not an object - must be obj c object - and strings are proper for our usage
    NSString *pageIntString = [[NSString alloc] initWithFormat:@"%i", pageInt];
    
    //NSNumber *pageNumber = [[[NSNumber alloc] initWithInt:pageInt] retain];
    NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, pageIntString, nil]; 
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getMyGallery" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        //[pageNumber release];
        //[pageIntString release];
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
            /*
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
             message:@"You have gallery items!"
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
             
             alertView.tag = 20;
             [alertView show];
             [alertView release];
             */
            
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        //[pageNumber release];
        
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];
    
    
}

- (NSArray*) photoponRegisterUserWithInfo:(NSArray*)userInfoParams withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    
    [self callMethodWithParams:@"bp.registerNewUser" params:userInfoParams withSuccess:^(NSArray *responseInfo){
    
    
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
        
        
        
        
        
        
    //[self callMethod:@"bp.getMyGallery" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
            /*
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Verification Success!", @"")
             message:@"User Model Populated!"
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
             
             alertView.tag = 20;
             [alertView show];
             [alertView release];
             */
            
            
            
        NSDictionary *returnData = [[NSDictionary alloc] init];
        returnData = (NSDictionary*)responseInfo;
        
        //[[NSDictionary alloc] init];
        
        //(NSDictionary*)responseInfo;
        
            
        
            PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
            PhotoponUserModel *photoponUserModel = [PhotoponUserModel alloc];
        
            photoponUserModel = [PhotoponUserModel modelWithDictionary:returnData];
        
        
        
        
            //NSDictionary *imgs = (NSDictionary *)[responseObject objectForKey:@"images"];
        
        
        /*
            photoponUserModel.identifier = [[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"identifier"]];
        
            
        
            photoponUserModel.facebookID = [[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"facebookID"]];
            
            / *
             photoponUserModel.fullname = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"fullname"]] retain];
             photoponUserModel.username = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"username"]] retain];
             photoponUserModel.firstName = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"firstName"]] retain];
             photoponUserModel.lastName = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"lastName"]] retain];
             * /
            
            
            photoponUserModel.fullname = (NSString*)[returnData objectForKey:@"fullname"];
            photoponUserModel.username = (NSString*)[returnData objectForKey:@"username"];
            photoponUserModel.firstName = (NSString*)[returnData objectForKey:@"firstName"];
            photoponUserModel.lastName = (NSString*)[returnData objectForKey:@"lastName"];
            photoponUserModel.email = (NSString*)[returnData objectForKey:@"email"];
            photoponUserModel.bio = (NSString*)[returnData objectForKey:@"bio"];
            photoponUserModel.website = (NSString*)[returnData objectForKey:@"website"];
            
            
            photoponUserModel.profilePictureUrl = [[NSString alloc] initWithFormat:@"%@%@", kPhotoponContentBase, (NSString*)[returnData objectForKey:@"profilePictureUrl"]];
            //photoponUserModel.profilePictureUrl = (NSString*)[returnData objectForKey:@"profilePictureUrl"];
            photoponUserModel.profileCoverPictureUrl = (NSString*)[returnData objectForKey:@"profileCoverPictureUrl"];
            photoponUserModel.followedByCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followedByCount"]];
            photoponUserModel.followersCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followersCount"]];
            photoponUserModel.redeemCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"redeemCount"]];
            photoponUserModel.mediaCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"mediaCount"]];
            photoponUserModel.score = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"score"]];
            photoponUserModel.didFollow = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"didFollow"]];
            
            photoponUserModel.mediaCountString = (NSString*)[returnData objectForKey:@"mediaCountString"];
            photoponUserModel.followersCountString = (NSString*)[returnData objectForKey:@"followersCountString"];
            photoponUserModel.followedByCountString = (NSString*)[returnData objectForKey:@"followedByCountString"];
            photoponUserModel.redeemCountString = (NSString*)[returnData objectForKey:@"redeemCountString"];
            photoponUserModel.scoreString = (NSString*)[returnData objectForKey:@"scoreString"];
            photoponUserModel.didFollowString = (NSString*)[returnData objectForKey:@"didFollowString"];
            */
        
        
            [appDelegate setPhotoponUserModel:photoponUserModel];
        
            self.username = appDelegate.photoponUserModel.username;
            self.password = [userInfoParams objectAtIndex:1];
            
         
            
            
            
            
            // ACCOUNT CREATED
            /*
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Signup Success!", @"")
                                                                message:[NSString stringWithFormat:@"id= %@, ----- %@, ----- %@, -----  %@", appDelegate.photoponUserModel.identifier, appDelegate.photoponUserModel.fullname, appDelegate.photoponUserModel.firstName, appDelegate.photoponUserModel.lastName]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
            
            alertView.tag = 20;
            [alertView show];
            [alertView release];
            */
            
            
            
            
            
            [SFHFKeychainUtils storeUsername:self.username andPassword:self.password forServiceName:@"Photopon.com" updateExisting:YES error:&error];
            if (error) {
                
                /*[self setUsername:self.username password:self.password success:^{
                    [appDelegate presentTabBarController];
                } failure:^(NSError *error) {
                
                    
                    
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Half Successful!", @"")
                     message:@"Account created successfully but error logging in! Try closing Photopon and logging in with your credentials."
                     delegate:self
                     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                     alertView.tag = 20;
                     [alertView show];
                     
                }];
                */
                
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"pcom_username_preference"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_authenticated_flag"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [PhotoponAppDelegate sharedPhotoponApplicationDelegate].isPcomAuthenticated = YES;
                [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] registerForPushNotifications];
                [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponComApiDidLoginNotification object:self.username];
                
                
                
                // AND LOGGED IN!
                // 100% ALL AROUND SUCCESS!
                /*
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logged In!", @"")
                                                                    message:[NSString stringWithFormat:@"You are now logged into Photopon for iPhone!"]
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                
                alertView.tag = 20;
                [alertView show];
                [alertView release];
                */
                // Carry on
                //[appDelegate presentTabBarController];
                
            }
            
            /*
             'mediaCountString' => $mediaCountString,
             'followersCountString' => $followersCountString,
             'followedByCountString' => $followedByCountString,
             'redeemCountString' => $redeemCountString,
             'scoreString' => $scoreString,
             'didFollowString' => $didFollowString,
             
             @synthesize followedByCountString;
             @synthesize followersCountString;
             @synthesize redeemCountString;
             @synthesize mediaCountString;
             @synthesize scoreString;
             @synthesize didFollowString;
             */
            
            
            
            
            
            
            
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        //}
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        if (success) {
            
            success(responseInfo);
            
        }
        
        
    } failure:^(NSError *error) {
        
        self.username = nil;
        self.password = nil;

        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
    return nil;
}

- (void) photoponSyncFacebookUserWithInfo:(NSArray*)userInfoParams withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self callMethodWithParams:@"bp.syncFBUser" params:userInfoParams withSuccess:^(NSArray *responseInfo){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        [self callMethodWithParams      SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
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
        
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableDictionary *returnData = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)responseInfo];
        
        [PhotoponUserModel setCurrentUser:[PhotoponUserModel modelWithDictionary:returnData]];// [[PhotoponUserModel alloc] initWithAttributes:returnData];
        
        [[PhotoponUserModel currentUser] cacheUserAttributes];
        
        //4appDelegate.pmm.currentUser = photoponUserModel;
        
        
        //[PhotoponUserModel setCurrentUser:photoponUserModel];
        
        [appDelegate setPhotoponUserModel:[PhotoponUserModel currentUser]];
        
                 
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //NSMutableArray *arr = ; // set value
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[PhotoponUserModel currentUser] identifier]];
        [defaults setObject:data forKey:kPhotoponUserAttributesIdentifierKey];
        [defaults synchronize];
        
        
        
        
        /*
        
        NSDictionary *returnData = (NSDictionary*)responseInfo;
        
        PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        PhotoponUserModel *photoponUserModel = [[PhotoponUserModel alloc] init];
        
        photoponUserModel.identifier = [[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"identifier"]];
        photoponUserModel.facebookID = [[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"facebookID"]];
        photoponUserModel.fullname = (NSString*)[returnData objectForKey:@"fullname"];
        photoponUserModel.username = (NSString*)[returnData objectForKey:@"username"];
        photoponUserModel.firstName = (NSString*)[returnData objectForKey:@"firstName"];
        photoponUserModel.lastName = (NSString*)[returnData objectForKey:@"lastName"];
        photoponUserModel.email = (NSString*)[returnData objectForKey:@"email"];
        photoponUserModel.bio = (NSString*)[returnData objectForKey:@"bio"];
        photoponUserModel.website = (NSString*)[returnData objectForKey:@"website"];
        
        photoponUserModel.profilePictureUrl = [[NSString alloc] initWithFormat:@"%@%@", kPhotoponContentBase, (NSString*)[returnData objectForKey:@"profilePictureUrl"]];
        //photoponUserModel.profilePictureUrl = (NSString*)[returnData objectForKey:@"profilePictureUrl"];
        photoponUserModel.profileCoverPictureUrl = (NSString*)[returnData objectForKey:@"profileCoverPictureUrl"];
        photoponUserModel.followedByCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followedByCount"]];
        photoponUserModel.followersCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followersCount"]];
        photoponUserModel.redeemCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"redeemCount"]];
        photoponUserModel.mediaCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"mediaCount"]];
        photoponUserModel.score = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"score"]];
        photoponUserModel.didFollow = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"didFollow"]];
        
        photoponUserModel.mediaCountString = (NSString*)[returnData objectForKey:@"mediaCountString"];
        photoponUserModel.followersCountString = (NSString*)[returnData objectForKey:@"followersCountString"];
        photoponUserModel.followedByCountString = (NSString*)[returnData objectForKey:@"followedByCountString"];
        photoponUserModel.redeemCountString = (NSString*)[returnData objectForKey:@"redeemCountString"];
        photoponUserModel.scoreString = (NSString*)[returnData objectForKey:@"scoreString"];
        photoponUserModel.didFollowString = (NSString*)[returnData objectForKey:@"didFollowString"];
        
        [appDelegate setPhotoponUserModel:photoponUserModel];
        */
        
        
        weakSelf.username = appDelegate.photoponUserModel.username;
        
        
        //self.password = (NSString*)[(NSArray*)[userInfoParams objectAtIndex:0] objectAtIndex:1];
        
        
        
        
        
        
        // ACCOUNT CREATED
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Signup Success!", @"")
         message:[NSString stringWithFormat:@"id= %@, ----- %@, ----- %@, -----  %@", appDelegate.photoponUserModel.identifier, appDelegate.photoponUserModel.fullname, appDelegate.photoponUserModel.firstName, appDelegate.photoponUserModel.lastName]
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
        
        
        //[SFHFKeychainUtils storeUsername:self.username andPassword:self.password forServiceName:@"Photopon.com" updateExisting:YES error:&error];
        
        if (error) {
        
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@        if (error) {        ", self, NSStringFromSelector(_cmd));
            NSLog(@"                 DESCRIPTION:    %@", error.description);
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            //[self setUsername:self.username password:self.password success:^{
                //[appDelegate presentTabBarController];
            //} failure:^(NSError *error) {
                
                
                /*
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Half Successful!", @"")
                                                                    message:@"Your account was created successfully BUT there was a strange error logging in! Try closing Photopon and logging in with the credentials you used to create your account."
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                alertView.tag = 20;
                [alertView show];
                 */
            //}];
        
            
        } else {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@        if(error)   else{   ", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"pcom_username_preference"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_authenticated_flag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [PhotoponAppDelegate sharedPhotoponApplicationDelegate].isPcomAuthenticated = YES;
            //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] registerForPushNotifications];
            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponComApiDidLoginNotification object:self.username];
            
            
            
            // AND LOGGED IN!
            // 100% ALL AROUND SUCCESS!
            /*
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logged In!", @"")
             message:[NSString stringWithFormat:@"You are now logged into Photopon for iPhone!"]
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
             
             alertView.tag = 20;
             [alertView show];
             [alertView release];
             */
            // Carry on
            //[appDelegate presentTabBarController];
            
        }
        
        /*
         'mediaCountString' => $mediaCountString,
         'followersCountString' => $followersCountString,
         'followedByCountString' => $followedByCountString,
         'redeemCountString' => $redeemCountString,
         'scoreString' => $scoreString,
         'didFollowString' => $didFollowString,
         
         @synthesize followedByCountString;
         @synthesize followersCountString;
         @synthesize redeemCountString;
         @synthesize mediaCountString;
         @synthesize scoreString;
         @synthesize didFollowString;
         */
        
        
        
        
        
        
        
        
        
        
        //someArray = [NSArray arrayWithArray:responseInfo];
        
        
        //}
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        if (success) {
            
            success(responseInfo);
            
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@        [self callMethodWithParams      FAILURE FAILURE", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"            DESCRIPTION:      %@", error.description);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        weakSelf.username = nil;
        weakSelf.password = nil;
        
        if (failure) {
            failure(error);
        }
        
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription]
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
}

- (NSArray*) photoponProfileDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, nil];
    
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getProfileData" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
        
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
            /*
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
             message:@"You have gallery items!"
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
             
             alertView.tag = 20;
             [alertView show];
             [alertView release];
             */
            
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];
    
    
}

- (NSArray*) photoponProfileRedeemedWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getRedeemedPhotopons" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
}

- (NSArray*) photoponProfileRedeemedDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getRedeemedPhotopons" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }]; 
    
    
}

- (void) photoponProfileFollowingWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getFollowing" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
}

- (void) photoponProfileFollowingDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getFollowing" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];    
    
    
}

- (void) photoponProfileFollowersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getFollowers" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        
        
        
        
        // responseInfo;
        
        
        //success(success);
        
        //return 
        
        //return success(success);
        //success(success);
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Followers Success!", @"")
         message:@"You have followers!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Followers FAILED!", @"")
         message:@"You have NO followers!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
    
}

- (void) photoponProfileFollowersDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getFollowers" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        // failure
        
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
    }];   
    
}

- (void) photoponNearbyPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getNearbyPhotopons" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
}



- (void) photoponLikesUsersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getLikes" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
}

- (void) photoponLikesUsersDataForPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:mediaIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getLikes" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];   
    
    
}


// returns user lists to paint the picture given the numbers (counts)
- (void) photoponViewsUsersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getViews" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
}

- (void) photoponViewsUsersDataForPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    //
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:mediaIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getViews" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];
    
    
}

- (NSArray*) photoponRedeemsUsersWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
        //NSArray *someArray;
        [self callMethod:@"bp.getRedeems" withSuccess:^(NSArray *responseInfo){
            //
            //return success
            if (success) {
                
                success(responseInfo);
                
                
                
                //someArray = [NSArray arrayWithArray:responseInfo];
                
                
            }
            /*
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
             message:@"You have gallery items!"
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
             
             alertView.tag = 20;
             [alertView show];
             [alertView release];
             */
            
            
        } failure:^(NSError *error) {
            //
            /*
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
             message:[error localizedDescription] 
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
             alertView.tag = 20;
             [alertView show];
             [alertView release];
             */
            
            
        }];
        
    
    
}

- (NSArray*) photoponRedeemsUsersDataForUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getRedeems" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];   

    
    
}

/*
- (NSArray*) photoponProfileDataWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    //NSArray *someArray;
    [self callMethod:@"bp.getProfileData" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        / *
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         * /
        
        
    } failure:^(NSError *error) {
        //
        / *
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         * /
        
        
    }];
    
    
    
}
*/


// ------------------------------------------------------------------------------------------------ //
// Remote User/Social Action Data Setters                                                           //
// ------------------------------------------------------------------------------------------------ //
- (void) photoponUserDidViewPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    // SEND REMOTE ACTION HERE 
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //
    NSArray *paramsArrObj = [NSArray arrayWithObjects:mediaIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getViews" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];
    
}

- (void) photoponUserDidCommentPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
// SEND REMOTE ACTION HERE 

    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *paramsArrObj = [NSArray arrayWithObjects:mediaIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getViews" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];

}

- (void) photoponUserDidLikePhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    // SEND REMOTE ACTION HERE 
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *paramsArrObj = [NSArray arrayWithObjects:mediaIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getViews" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];
    
}

- (void) photoponUserDidRedeemPhotoponMediaID:(NSString*)mediaIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
// SEND REMOTE ACTION HERE 

    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *paramsArrObj = [NSArray arrayWithObjects:mediaIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getViews" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];

}

- (void) photoponUserDidFollowUserID:(NSString*)userIdentifier withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    // SEND REMOTE ACTION HERE 
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.getProfileData" params:paramsArrObj withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
    }];
    
}

- (void) photoponUpdateProfileData:(NSArray*)paramsProfileData withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    // SEND REMOTE ACTION HERE 

    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *paramsArrObj = [NSArray arrayWithObjects:userIdentifier, nil]; 
    
    
    //NSArray *resp = nil;
    //- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
    [self callMethodWithParams:@"bp.updateProfileInfo" params:paramsProfileData withSuccess:^(NSArray *responseInfo){
        //
        //return success
        
        if (success) {
            
            //resp = [responseInfo retain];
            
            success(responseInfo);
            
            NSDictionary *returnData = (NSDictionary*)responseInfo;
            
            PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            NSString *rMessage = [returnData objectForKey:@"message"];
            
            
            
            
            
            
            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Profile Updated Successfully!" message:rMessage cancelButtonTitle:@"OK"];
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        
    } failure:^(NSError *error) {
        //
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Something went wrong!" message:[error description] cancelButtonTitle:@"OK"];
        
        
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
    }];


}

    


    
    
















- (void) photoponGlobalPopularPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getGlobalPopularPhotopons" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    }];
    
}

- (void) photoponGlobalRecentPhotoponsWithSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure
{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //NSArray *someArray;
    [self callMethod:@"bp.getGlobalRecentPhotopons" withSuccess:^(NSArray *responseInfo){
        //
        //return success
        if (success) {
            
            success(responseInfo);
            
            
            
            //someArray = [NSArray arrayWithArray:responseInfo];
            
            
        }
        /*
         
         
         'bp.getNearbyPhotopons'				=> 'this:bp_xmlrpc_fetch_photopon_feed_nearby',
         'bp.getGlobalPopularPhotopons'		=> 'this:bp_xmlrpc_fetch_photopon_feed_global_popular',
         'bp.getGlobalRecentPhotopons'		=> 'this:bp_xmlrpc_fetch_photopon_feed_global_recent',
         
         // feed item activity services
         'bp.newPostActivity'				=> 'this:bp_xmlrpc_call_newPostActivity', // Like increment, Redeem increment, view increment, etc
         'bp.getComments'	           		=> 'this:bp_xmlrpc_call_get_comments',
         
         
         
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery Success!", @"")
         message:@"You have gallery items!"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
    } failure:^(NSError *error) {
        //
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get Gallery FAILED!", @"")
         message:[error localizedDescription] 
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         alertView.tag = 20;
         [alertView show];
         [alertView release];
         */
        
        
        
        
    }];
    
}





    
- (void)setUsername:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self signOut]; // Only one account supported for now
    self.username = username;
    self.password = password;
    [self authenticateWithSuccess:^{
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
        
        
        
        [SFHFKeychainUtils storeUsername:self.username andPassword:self.password forServiceName:@"Photopon.com" updateExisting:YES error:&error];
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"pcom_username_preference"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_authenticated_flag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [PhotoponAppDelegate sharedPhotoponApplicationDelegate].isPcomAuthenticated = YES;
            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] registerForPushNotifications];
            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponComApiDidLoginNotification object:self.username];
            if (success) success();
        }
    } failure:^(NSError *error) {
        self.username = nil;
        self.password = nil;
        if (failure) failure(error);
    }];
}

- (void)signOut {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
#if FALSE
    // Until we have accounts, don't delete the password or any blog with that username will stop working
    NSError *error = nil;
    [SFHFKeychainUtils deleteItemForUsername:self.username andServiceName:@"Photopon.com" error:&error];
#endif
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pcom_username_preference"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pcom_authenticated_flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [PhotoponAppDelegate sharedPhotoponApplicationDelegate].isPcomAuthenticated = NO;
    //[[PhotoponAppDelegate sharedPhotoponApplicationDelegate] unregisterApnsToken];
    self.username = nil;
    self.password = nil;
    
    // Clear reader caches and cookies
    // FIXME: this doesn't seem to log out the reader properly
    NSArray *readerCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kMobileReaderURL]];
    for (NSHTTPCookie *cookie in readerCookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    // Notify the world
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponComApiDidLogoutNotification object:nil];
}




- (void)syncPushNotificationInfo {
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kApnsDeviceTokenPrefKey];
    if( nil == token ) return; //no apns token available
    
    if(![[PhotoponComApi sharedApi] hasCredentials])
        return;
    
    NSString *authURL = kNotificationAuthURL;
    NSError *error;
    NSManagedObjectContext *context = [[WordPressAppDelegate sharedWordPressApplicationDelegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Blog" inManagedObjectContext:context]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"blogName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *blogs = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *blogsID = [NSMutableArray array];
    
    //get a references to media files linked in a post
    for (Blog *blog in blogs) {
        if( [blog isWPcom] ) {
            [blogsID addObject:[blog blogID] ];
        } else {
            if ( [blog getOptionValue:@"jetpack_client_id"] )
                [blogsID addObject:[blog getOptionValue:@"jetpack_client_id"] ];
        }
    }
    
    // Send a multicall for the blogs list and retrieval of push notification settings
    NSMutableArray *operations = [NSMutableArray arrayWithCapacity:2];
    WPXMLRPCClient *api = [[WPXMLRPCClient alloc] initWithXMLRPCEndpoint:[NSURL URLWithString:authURL]];
    
    [api setAuthorizationHeaderWithToken:self.authToken];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	NSString *appversion = [[info objectForKey:@"CFBundleVersion"] stringByUrlEncoding];
    
    NSArray *blogsListParameters = [NSArray arrayWithObjects:[self usernameForXmlrpc], [self passwordForXmlrpc], token, blogsID, @"apple", appversion, nil];
    WPXMLRPCRequest *blogsListRequest = [api XMLRPCRequestWithMethod:@"wpcom.mobile_push_set_blogs_list" parameters:blogsListParameters];
    WPXMLRPCRequestOperation *blogsListOperation = [api XMLRPCRequestOperationWithRequest:blogsListRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPFLog(@"Sent blogs list (%d blogs)", [blogsID count]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WPFLog(@"Failed registering blogs list: %@", [error localizedDescription]);
    }];
    
    [operations addObject:blogsListOperation];
    
    NSArray *settingsParameters = [NSArray arrayWithObjects:[self usernameForXmlrpc], [self passwordForXmlrpc], token, @"apple", nil];
    WPXMLRPCRequest *settingsRequest = [api XMLRPCRequestWithMethod:@"wpcom.get_mobile_push_notification_settings" parameters:settingsParameters];
    WPXMLRPCRequestOperation *settingsOperation = [api XMLRPCRequestOperationWithRequest:settingsRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *supportedNotifications = (NSDictionary *)responseObject;
        [[NSUserDefaults standardUserDefaults] setObject:supportedNotifications forKey:@"notification_preferences"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WPFLog(@"Failed to receive supported notification list: %@", [error localizedDescription]);
    }];
    
    [operations addObject:settingsOperation];
    
    AFHTTPRequestOperation *combinedOperation = [api combinedHTTPRequestOperationWithOperations:operations success:^(AFHTTPRequestOperation *operation, id responseObject) {} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [api enqueueHTTPRequestOperation:combinedOperation];
     */
}

- (void)checkForNewUnseenNotifications {
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    NSDictionary *params = @{ @"unread":@"true", @"number":@"20", @"num_note_items":@"20", @"fields" : WordPressComApiNotificationFields };
    [self getPath:@"notifications" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *last_seen_time = [responseObject objectForKey:@"last_seen_time"];
        NSArray *notes = [responseObject objectForKey:@"notes"];
        if ([notes count] > 0) {
            NSMutableArray *unseenNotes = [[NSMutableArray alloc] initWithCapacity:[notes count]];
            [notes enumerateObjectsUsingBlock:^(id noteData, NSUInteger idx, BOOL *stop) {
                NSNumber *timestamp = [noteData objectForKey:@"timestamp"];
                if ([timestamp compare:last_seen_time] == NSOrderedDescending) {
                    [unseenNotes addObject:noteData];
                }
            }];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:WordPressComApiUnseenNotesNotification
                              object:self
                            userInfo:@{
    WordPressComApiNotesUserInfoKey : unseenNotes,
WordPressComApiUnseenNoteCountInfoKey : [NSNumber numberWithInteger:[unseenNotes count]]
             }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
     */
}

- (NSArray *)getXMLRPCArgsWithExtra:(id)extra {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray *result = [NSMutableArray array];
    //[result addObject:@"1"];
    [result addObject:[PhotoponComApi sharedApi].username];
    [result addObject:[PhotoponComApi sharedApi].password];
    
    if ([extra isKindOfClass:[NSArray class]]) {
        [result addObjectsFromArray:extra];
    } else if (extra != nil) {
        [result addObject:extra];
    }
    
    return [NSArray arrayWithArray:result];
}




@end
