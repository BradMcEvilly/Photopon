//
//  PhotoponApi.h
//  Photopon
//
//  Created by Bradford McEvilly on 4/10/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPClient.h"

@class AFHTTPRequestOperation;
/**
 PhotoponApi API for iOS 
 */
@interface PhotoponApi : AFHTTPClient

///-----------------------------------------
/// @name Accessing PhotoponApi API properties
///-----------------------------------------

@property (readonly, nonatomic, strong) NSURL *xmlrpc;

///-------------------------------------------------------
/// @name Creating and Initializing a PhotoponApi API Client
///-------------------------------------------------------

/**
 Creates and initializes a `PhotoponApi` client trying to guess the proper XML-RPC endpoint from the site URL.
 
 @param xmlrpc The XML-RPC endpoint URL, e.g.: https://en.blog.wordpress.com/xmlrpc.php
 @param username The user name
 @param password The password
 */
+ (PhotoponApi *)apiWithXMLRPCEndpoint:(NSURL *)xmlrpc username:(NSString *)username password:(NSString *)password;


/**
 Initializes a `PhotoponApi` client trying to guess the proper XML-RPC endpoint from the site URL.
 
 @param xmlrpc The XML-RPC endpoint URL, e.g.: https://en.blog.wordpress.com/xmlrpc.php
 @param username The user name
 @param password The password
 */
- (id)initWithXMLRPCEndpoint:(NSURL *)xmlrpc username:(NSString *)username password:(NSString *)password;

///---------------------
/// @name Authentication
///---------------------

/**
 Verifies if the given credentials are valid
 
 @param success A block object to execute when the login is successful. This block has no return value and no arguments.
 @param failure A block object to execute when the login failed. This block has no return value and takes one argument: a NSError object with details on the error.
 */
- (void)authenticateWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

- (void)callMethod:(NSString*)methodName withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

- (void)callMethodWithParams:(NSString*)methodName params:(NSArray *)paramsArray withSuccess:(void (^)(NSArray *responseInfo))success failure:(void (^)(NSError *error))failure;

/**
 Authenticates and returns a list of the profile data for the current logged in user
 
 @param success A block object to execute when the login is successful. This block has no return value and takes one argument: an array with the blogs list.
 @param failure A block object to execute when the login failed. This block has no return value and takes one argument: a NSError object with details on the error.
 */
- (void)getProfileDataWithSuccess:(void (^)(NSArray *profileData))success failure:(void (^)(NSError *error))failure;





///--------------
/// @name Helpers
///--------------

/**
 Given a site URL, tries to guess the URL for the XML-RPC endpoint
 
 When asked for a site URL, sometimes users type the XML-RPC url, or the xmlrpc.php has been moved/renamed. This method would try a few methods to find the proper XML-RPC endpoint:
 
 * Try to load the given URL adding `/xmlrpc.php` at the end. This is the most common use case for proper site URLs
 * If that fails, try a test XML-RPC request given URL, maybe it was the XML-RPC URL already
 * If that fails, fetch the given URL and search for an `EditURI` link pointing to the XML-RPC endpoint
 
 For additional URL typo fixing, see [NSURL-Guess](https://github.com/koke/NSURL-Guess)
 
 @param siteURL The site's main url, e.g.: http://en.blog.wordpress.com/
 @param success A block object to execute when the method finds a suitable XML-RPC endpoint on the site provided. This block has no return value and takes one argument: the found XML-RPC endpoint URL.
 @param failure A block object to execute when the method doesn't find a suitable XML-RPC endpoint on the site. This block has no return value and takes one argument: a NSError object with details on the error.
 */
+ (void)guessXMLRPCURLForSite:(NSString *)siteURL
                      success:(void (^)(NSURL *xmlrpcURL))success
                      failure:(void (^)(NSError *error))failure;


@end
