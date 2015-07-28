//
//  PhotoponUITableViewCell.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/16/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PhotoponGlobalFeedTableViewCellController.h"

@class PhotoponUsersTableViewCellController;
@class PhotoponAlertsTableViewCellController;
@class PhotoponCouponsTableViewCellController;
@class PhotoponCommentsTableViewCellController;
@class PhotoponFeedItemTableViewCellController;
@class PhotoponMoreTableViewCellController;
@class PhotoponFeedItemActivityTableViewCellController;
//@class PhotoponGlobalFeedTableViewCellController;
@class PhotoponGlobalFeedPopularTableViewCellController;

@class PhotoponFeedItemsEmptyTableViewCellController;

@interface PhotoponUITableViewCell : UITableViewCell
{
    
    
    
    //NSNumber *isDetailView_;
    BOOL supressDeleteButton;
    PhotoponUsersTableViewCellController *photoponUsersTableViewCellController_;
    PhotoponAlertsTableViewCellController *photoponAlertsTableViewCellController_;
    PhotoponCouponsTableViewCellController *photoponCouponsTableViewCellController_;
    PhotoponCommentsTableViewCellController *photoponCommentsTableViewCellController_;
    PhotoponFeedItemTableViewCellController *photoponFeedItemTableViewCellController_;
    PhotoponGlobalFeedPopularTableViewCellController *photoponGlobalFeedPopularTableViewCellController_;
    PhotoponMoreTableViewCellController *photoponMoreTableViewCellController_;
    PhotoponFeedItemActivityTableViewCellController *photoponFeedItemActivityTableViewCellController_;
    //PhotoponGlobalFeedTableViewCellController *photoponGlobalFeedTableViewCellControllers_;
    PhotoponGlobalFeedPopularTableViewCellController *globalFeedPopularTableViewController_;
    
    PhotoponFeedItemsEmptyTableViewCellController *photoponFeedItemsEmptyTableViewCellController_;
}

@property (nonatomic,retain) PhotoponUsersTableViewCellController *photoponUsersTableViewCellController;
@property (nonatomic,retain) PhotoponAlertsTableViewCellController *photoponAlertsTableViewCellController;
@property (nonatomic) BOOL supressDeleteButton;
@property (nonatomic,retain) PhotoponCouponsTableViewCellController *photoponCouponsTableViewCellController;
@property (nonatomic,retain) PhotoponCommentsTableViewCellController *photoponCommentsTableViewCellController;
@property (nonatomic,retain) PhotoponMoreTableViewCellController *photoponMoreTableViewCellController;
@property (nonatomic,retain) PhotoponFeedItemTableViewCellController *photoponFeedItemTableViewCellController;
@property (nonatomic,retain) PhotoponGlobalFeedPopularTableViewCellController *photoponGlobalFeedPopularTableViewCellController;
@property (nonatomic,retain) PhotoponFeedItemActivityTableViewCellController *photoponFeedItemActivityTableViewCellController;
//@property (nonatomic,retain) PhotoponGlobalFeedTableViewCellController *photoponGlobalFeedTableViewCellControllers;

@property (nonatomic,retain) PhotoponGlobalFeedPopularTableViewCellController *globalFeedPopularTableViewController;

@property (nonatomic,retain) PhotoponFeedItemsEmptyTableViewCellController *photoponFeedItemsEmptyTableViewCellController;

@end
