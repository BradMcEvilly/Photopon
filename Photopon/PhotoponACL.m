//
//  PhotoponACL.m
//  ParseKit
//
//  Created by Denis Berton on 22/09/12.
//  Copyright (c) 2012 Denis Berton. All rights reserved.
//

#import "PhotoponACL.h"
//#import "PhotoponUserModel.h"

@implementation PhotoponACL

+ (PhotoponACL *)ACL{return [[self alloc] init];}
+ (PhotoponACL *)ACLWithUser:(PhotoponUserModel *)user{return [[self alloc] init];}
- (void)setPublicReadAccess:(BOOL)allowed{}
+ (void)setDefaultACL:(PhotoponACL *)acl withAccessForCurrentUser:(BOOL)currentUserAccess{}
- (id)copyWithZone:(NSZone *)zone{return [PhotoponACL ACL];}
- (void)setWriteAccess:(BOOL)allowed forUser:(PhotoponUserModel *)user{}
- (void)setPublicWriteAccess:(BOOL)allowed{}

@end
