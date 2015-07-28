//
//  PFUser.h
//  ParseKit
//
//  Created by Denis Berton on 22/09/12.
//  Copyright (c) 2012 Denis Berton. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoponUser : PhotoponObject

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *username;

    + (PhotoponUser *)currentUser;
    + (void)logOut;
    //+ (PFQuery *)query;
    + (void)setCurrentUser:(PhotoponUser *)user;
	+ (PhotoponUser *)user;
/*
	+ (void)logInWithUsernameInBackground:(NSString *)username
								 password:(NSString *)password
									block:(PhotoponUserResultBlock)block;
	- (void)signUpInBackgroundWithBlock:(PhotoponBooleanResultBlock)block;
*/
@end
