//
//  PhotoponACL.h
//  ParseKit
//
//  Created by Denis Berton on 22/09/12.
//  Copyright (c) 2012 Denis Berton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoponConstants.h"
//#import "PhotoponUserModel.h"
//#import "PhotoponACL.h"

@class PhotoponUserModel;

@interface PhotoponACL : NSObject <NSCopying>

    + (PhotoponACL *)ACL;
    + (PhotoponACL *)ACLWithUser:(PhotoponUserModel *)user;
    - (void)setPublicReadAccess:(BOOL)allowed;
    + (void)setDefaultACL:(PhotoponACL *)acl withAccessForCurrentUser:(BOOL)currentUserAccess;
    - (void)setWriteAccess:(BOOL)allowed forUser:(PhotoponUserModel *)user;
	- (void)setPublicWriteAccess:(BOOL)allowed;
@end
