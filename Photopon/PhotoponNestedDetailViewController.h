//
//  PhotoponNestedDetailViewController.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/30/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoponUserModel;
@class PhotoponMediaModel;
@class PhotoponCoordinateModel;
@class PhotoponCouponModel;
@class PhotoponTagModel;
@class PhotoponImageModel;
@class PhotoponPlaceModel;
@class PhotoponCommentModel;
@class PhotoponAlertModel;
@class PhotoponFeedbackModel;

@interface PhotoponNestedDetailViewController : PhotoponQueryTableViewController
{
    
    NSNumber *photoponDetailViewType;
    NSNumber *isTabBarController;
    
    PhotoponUserModel *photoponUserModel;
    PhotoponMediaModel *photoponMediaModel;
    PhotoponCoordinateModel *photoponCoordinateModel;
    PhotoponCouponModel *photoponCouponModel;
    PhotoponTagModel *photoponTagModel;
    PhotoponImageModel *photoponImageModel;
    PhotoponPlaceModel *photoponPlaceModel;
    PhotoponCommentModel *photoponCommentModel;
    PhotoponAlertModel *photoponAlertModel;
    PhotoponFeedbackModel *photoponFeedbackModel;
    
    IBOutlet UIButton *rightNavButton;
    IBOutlet UIButton *backNavButton;
    IBOutlet UIBarButtonItem *backBarButton;
    IBOutlet UIScrollView* scrollView;
    
}


@property (nonatomic, retain) NSNumber *photoponDetailViewType;

@property (nonatomic, retain) PhotoponUserModel *photoponUserModel;
@property (nonatomic, retain) PhotoponMediaModel *photoponMediaModel;
@property (nonatomic, retain) PhotoponCoordinateModel *photoponCoordinateModel;
@property (nonatomic, retain) PhotoponCouponModel *photoponCouponModel;
@property (nonatomic, retain) PhotoponTagModel *photoponTagModel;
@property (nonatomic, retain) PhotoponImageModel *photoponImageModel;
@property (nonatomic, retain) PhotoponPlaceModel *photoponPlaceModel;
@property (nonatomic, retain) PhotoponCommentModel *photoponCommentModel;
@property (nonatomic, retain) PhotoponAlertModel *photoponAlertModel;
@property (nonatomic, retain) PhotoponFeedbackModel *photoponFeedbackModel;
@property (nonatomic, retain) NSNumber *isTabBarController;

@property (nonatomic, retain) IBOutlet UIButton *rightNavButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backBarButton;
@property (nonatomic, retain) IBOutlet UIButton *backNavButton;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;


- (IBAction)rightNavButtonHandler:(id)sender;
- (IBAction)backNavButtonHandler:(id)sender;

/*
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, retain) IBOutlet UILabel* levelLabel;

- (IBAction)pressedGoDeeper:(id)sender;
*/





 
 @end
