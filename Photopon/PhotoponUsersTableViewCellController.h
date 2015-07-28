//
//  PhotoponUsersTableViewCellController.h
//  Photopon
//
//  Created by Bradford McEvilly on 5/12/12.
//  Copyright 2012 Photopon, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponTableViewCell.h"

@class PhotoponUIButton;
@class PhotoponUITableViewCell;
@class PhotoponFeedItemActivityTableViewController;
//@class PhotoponUsersTableViewCellController;

@interface PhotoponUsersTableViewCellController : PhotoponTableViewCell
{
    
    //IBOutlet PhotoponUsersTableViewCellController *photoponUsersTableViewCellController_;
    IBOutlet PhotoponUITableViewCell *photoponUserCell_;
    
    // profile info objects - person
    IBOutlet PhotoponUIButton *photoponBtnProfileImagePerson;
    IBOutlet PhotoponUIButton *photoponBtnProfileNamePerson;
    IBOutlet PhotoponUIButton *photoponBtnFollow;
    IBOutlet UILabel *photoponUserTitle;
    
    
    NSNumber *isFollowing;
    //NSString *photoponID_; // obsolete - using super's photoponMediaModel to load referenced photopon cell
//@private
    PhotoponFeedItemActivityTableViewController *controller_;
}

@property (nonatomic, assign) PhotoponFeedItemActivityTableViewController *controller;

@property (nonatomic, retain) IBOutlet PhotoponUITableViewCell *photoponUserCell;
// profile info objects - person
@property (nonatomic,retain) IBOutlet PhotoponUIButton *photoponBtnProfileImagePerson;
@property (nonatomic,retain) IBOutlet PhotoponUIButton *photoponBtnProfileNamePerson;
@property (nonatomic,retain) IBOutlet PhotoponUIButton *photoponBtnFollow;
@property (nonatomic,retain) IBOutlet UILabel *photoponUserTitle;

@property (nonatomic, retain) NSNumber *isFollowing;


#pragma mark
#pragma mark Feed Item Action Handlers

// Profile Info Button Handlers
-(IBAction)photoponBtnProfileImagePersonHandler:(id)sender;

-(IBAction)photoponBtnProfileNamePersonHandler:(id)sender;

-(IBAction)photoponBtnFollowHandler:(id)sender;

@end


