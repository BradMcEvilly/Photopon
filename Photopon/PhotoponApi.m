//
//  PhotoponApi.m
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponApi.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponUserModel.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
//#import "TouchXML.h"
#import "PhotoponConstants.h"
#import "WPXMLRPCClient.h"
#import "NSString+Helpers.h"
#import "NSString+Util.h"
#import "RegexKitLite.h"



#ifndef WPFLog
#define WPFLog(...) NSLog(__VA_ARGS__)
#endif

@interface PhotoponApi ()
@property (readwrite, nonatomic, strong) NSURL *xmlrpc;
@property (readwrite, nonatomic, strong) NSString *username;
@property (readwrite, nonatomic, strong) NSString *password;
@property (readwrite, nonatomic, strong) WPXMLRPCClient *client;
+ (void)validateXMLRPCUrl:(NSURL *)url success:(void (^)())success failure:(void (^)(NSError *error))failure;
+ (void)logExtraInfo:(NSString *)format, ...;
@end


@implementation PhotoponApi {
    NSURL *_xmlrpc;
    NSString *_username;
    NSString *_password;
    WPXMLRPCClient *_client;
}
@synthesize xmlrpc = _xmlrpc;
@synthesize username = _username;
@synthesize password = _password;
@synthesize client = _client;

+ (PhotoponApi *)apiWithXMLRPCEndpoint:(NSURL *)xmlrpc username:(NSString *)username password:(NSString *)password {
    return [[self alloc] initWithXMLRPCEndpoint:xmlrpc username:username password:password];
}


- (id)initWithXMLRPCEndpoint:(NSURL *)xmlrpc username:(NSString *)username password:(NSString *)password
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.xmlrpc = xmlrpc;
    self.username = username;
    self.password = password;
    
    self.client = [WPXMLRPCClient clientWithXMLRPCEndpoint:xmlrpc];
    
    return self;
}

- (void)dealloc {
}

#pragma mark - Authentication

- (void)authenticateWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self getProfileDataWithSuccess:^(NSArray *profileData) {
        if (success) {
            success();
        }
    } failure:failure];
}

- (void)getProfileDataWithSuccess:(void (^)(NSArray *profileData))success failure:(void (^)(NSError *error))failure {
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self.client callMethod:@"bp.verifyConnection"
                 parameters:[NSArray arrayWithObjects:self.username, self.password, nil]
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
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
                        
                            
                            
                            NSDictionary *returnData = (NSDictionary*)responseObject;
                            
                            PhotoponAppDelegate *appDelegate = [PhotoponAppDelegate sharedPhotoponApplicationDelegate];
                            
                            PhotoponUserModel *photoponUserModel = [[PhotoponUserModel alloc] initWithAttributes:returnData];
                            
                            [photoponUserModel cacheUserAttributes];
                        
                            [appDelegate setPhotoponUserModel:photoponUserModel];
                            
                            
                            
                            //[appDelegate presentTabBarController];
                            
                            
                            
                            
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
                            * /
                            
                            
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Verification Success!", @"")
                                                                                message:[NSString stringWithFormat:@"id= %@, ----- %@, ----- %@, -----  %@", appDelegate.photoponUserModel.identifier, appDelegate.photoponUserModel.fullname, appDelegate.photoponUserModel.firstName, appDelegate.photoponUserModel.lastName]
                                                                               delegate:self
                                                                      cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                            
                            alertView.tag = 20;
                            [alertView show];
                            [alertView release];
                            */
                            
                            
                            //[appDelegate initTabBarViewController];
                            
                            //[appDelegate carryOnThen];
                            
                            
                            //[photoponUserModel release];
                        
                        if (success) {
                            success(responseObject);
                        }
                            
                            
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                            
                            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Verify FAILED!" message:[error localizedDescription] cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK"];
                            /*
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Verify FAILED!", @"")
                                                                                message:[error localizedDescription]
                                                                               delegate:self
                                                                      cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                            
                            alertView.tag = 20;
                            [alertView show];
                             */
                        }
                    }];
}

- (void)callMethod:(NSString*)methodName withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure {
        
    [self.client callMethod:methodName
                 parameters:[NSArray arrayWithObjects:self.username, self.password, nil]
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            
                            success(responseObject);
                            
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
    
}

- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [self.client callMethod:methodName
                 parameters:paramsArray
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            
                            success(responseObject);
                            
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
    
    
}


#pragma mark - Helpers
/*
+ (void)guessXMLRPCURLForSite:(NSString *)url
                      success:(void (^)(NSURL *xmlrpcURL))success
                      failure:(void (^)(NSError *error))failure {
    __block NSURL *xmlrpcURL;
    __block NSString *xmlrpc;
    
    // ------------------------------------------------
    // 0. Is an empty url? Sorry, no psychic powers yet
    // ------------------------------------------------
    if (url == nil || [url isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"com.photopon.api" code:0 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Empty URL", @"") forKey:NSLocalizedDescriptionKey]];
        [self logExtraInfo: [error localizedDescription] ];
        return failure ? failure(error) : nil;
    }
    
    // ------------------------------------------------------------------------
    // 1. Assume the given url is the home page and XML-RPC sits at /xmlrpc.php
    // ------------------------------------------------------------------------
    [self logExtraInfo: @"1. Assume the given url is the home page and XML-RPC sits at /xmlrpc.php" ];
    if(![url hasPrefix:@"http"])
        url = [NSString stringWithFormat:@"http://%@", url];
    
    if ([url hasSuffix:@"bp-xmlrpc.php"])
        xmlrpc = url;
    else
        xmlrpc = [NSString stringWithFormat:@"%@/bp-xmlrpc.php", url];
    
    xmlrpcURL = [NSURL URLWithString:xmlrpc];
    if (xmlrpcURL == nil) {
        // Not a valid URL. Could be a bad protocol (htpp://), syntax error (http//), ...
        // See https://github.com/koke/NSURL-Guess for extra help cleaning user typed URLs
        NSError *error = [NSError errorWithDomain:@"com.photopon.api" code:1 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Invalid URL", @"") forKey:NSLocalizedDescriptionKey]];
        [self logExtraInfo: [error localizedDescription]];
        return failure ? failure(error) : nil;
    }
    [self logExtraInfo: @"Trying the following URL: %@", xmlrpcURL ];
    [self validateXMLRPCUrl:xmlrpcURL success:^{
        if (success) {
            success(xmlrpcURL);
        }
    } failure:^(NSError *error){
        if ([error.domain isEqual:NSURLErrorDomain] && error.code == NSURLErrorUserCancelledAuthentication) {
            [self logExtraInfo: [error localizedDescription]];
            if (failure) {
                failure(error);
            }
            return;
        }
        // -------------------------------------------
        // 2. Try the given url as an XML-RPC endpoint
        // -------------------------------------------
        [self logExtraInfo:@"2. Try the given url as an XML-RPC endpoint"];
        xmlrpcURL = [NSURL URLWithString:url];
        [self logExtraInfo: @"Trying the following URL: %@", url];
        [self validateXMLRPCUrl:xmlrpcURL success:^{
            if (success) {
                success(xmlrpcURL);
            }
        } failure:^(NSError *error){
            [self logExtraInfo:[error localizedDescription]];
            // ---------------------------------------------------
            // 3. Fetch the original url and look for the RSD link
            // ---------------------------------------------------
            [self logExtraInfo:@"3. Fetch the original url and look for the RSD link by using RegExp"];
            NSURLRequest *request = [NSURLRequest requestWithURL:xmlrpcURL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *rsdURL = [operation.responseString stringByMatching:@"<link rel=\"EditURI\" type=\"application/rsd\\+xml\" title=\"RSD\" href=\"([^\"]*)\"[^/]* />" capture:1];

                if (rsdURL == nil) {
                    //the RSD link not found using RegExp, try to find it again on a "cleaned" HTML document
                    [self logExtraInfo:@"The RSD link not found using RegExp, on the following doc: %@", operation.responseString];
                    [self logExtraInfo:@"Try to find it again on a cleaned HTML document"];
                    NSError *htmlError;
                    CXMLDocument *rsdHTML = [[CXMLDocument alloc] initWithXMLString:operation.responseString options:CXMLDocumentTidyXML error:&htmlError];
                    if(!htmlError) {
                        NSString *cleanedHTML = [rsdHTML XMLStringWithOptions:CXMLDocumentTidyXML];
                        [self logExtraInfo:@"The cleaned doc: %@", cleanedHTML];
                        rsdURL = [cleanedHTML stringByMatching:@"<link rel=\"EditURI\" type=\"application/rsd\\+xml\" title=\"RSD\" href=\"([^\"]*)\"[^/]* />" capture:1];
                    } else {
                        [self logExtraInfo:@"The cleaning function reported the following error: %@", [htmlError localizedDescription]];
                    }
                }
                
                if (rsdURL != nil) {
                    void (^parseBlock)(void) = ^() {
                        [self logExtraInfo:@"5. Parse the RSD document at the following URL: %@", rsdURL];
                        // -------------------------
                        // 5. Parse the RSD document
                        // -------------------------
                        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:rsdURL]];
                        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSError *rsdError;
                            CXMLDocument *rsdXML = [[CXMLDocument alloc] initWithXMLString:operation.responseString options:CXMLDocumentTidyXML error:&rsdError];
                            if (!rsdError) {
                                @try {
                                    CXMLElement *serviceXML = [[[rsdXML rootElement] children] objectAtIndex:1];
                                    for(CXMLElement *api in [[[serviceXML elementsForName:@"apis"] objectAtIndex:0] elementsForName:@"api"]) {
                                        if([[[api attributeForName:@"name"] stringValue] isEqualToString:@"Photopon"]) {
                                            // Bingo! We found the WordPress XML-RPC element
                                            xmlrpc = [[api attributeForName:@"apiLink"] stringValue];
                                            xmlrpcURL = [NSURL URLWithString:xmlrpc];
                                            [self logExtraInfo:@"Bingo! We found the Photopon XML-RPC element: %@", xmlrpcURL];
                                            [self validateXMLRPCUrl:xmlrpcURL success:^{
                                                if (success) success(xmlrpcURL);
                                            } failure:^(NSError *error){
                                                [self logExtraInfo: [error localizedDescription]];
                                                if (failure) failure(error);
                                            }];
                                        }
                                    }
                                }
                                @catch (NSException *exception) {
                                    if (failure) failure(error);
                                }
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self logExtraInfo: [error localizedDescription]];
                            if (failure) failure(error);
                        }];
                        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                        [queue addOperation:operation];
                    };
                    // ----------------------------------------------------------------------------
                    // 4. Try removing "?rsd" from the url, it should point to the XML-RPC endpoint         
                    // ----------------------------------------------------------------------------
                    xmlrpc = [rsdURL stringByReplacingOccurrencesOfString:@"?rsd" withString:@""];
                    if (![xmlrpc isEqualToString:rsdURL]) {
                        xmlrpcURL = [NSURL URLWithString:xmlrpc];
                        [self validateXMLRPCUrl:xmlrpcURL success:^{
                            if (success) {
                                success(xmlrpcURL);
                            }
                        } failure:^(NSError *error){
                            parseBlock();
                        }];
                    } else {
                        parseBlock();
                    }
                } else {
                    if (failure)
                        failure(error);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self logExtraInfo:@"Can't fetch the original url: %@", [error localizedDescription]];
                if (failure) failure(error);
            }];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:operation];
        }];
    }];
}
*/
#pragma mark - Private Methods

+ (void)validateXMLRPCUrl:(NSURL *)url success:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@                BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    WPXMLRPCClient *client = [WPXMLRPCClient clientWithXMLRPCEndpoint:url];
    [client callMethod:@"system.listMethods"
            parameters:[NSArray array]
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   if (success) {
                       success();
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (failure) {
                       failure(error);
                   }
               }];
}

+ (void)logExtraInfo:(NSString *)format, ... {
    BOOL extraDebugIsActive = NO;
    NSNumber *extra_debug = [[NSUserDefaults standardUserDefaults] objectForKey:@"extra_debug"];
    if ([extra_debug boolValue]) {
        extraDebugIsActive = YES;
    } 
#ifdef DEBUG
    extraDebugIsActive = YES; 
#endif 
    
    if( extraDebugIsActive == NO ) return;
    
    va_list ap;
	va_start(ap, format);
	NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
    WPFLog(@"[PhotoponApi] < %@", message);
}

@end