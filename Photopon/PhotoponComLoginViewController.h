//
//  PhotoponComLoginViewController.h
//  Photopon
//
//  Created by Bradford McEvilly on 7/19/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AddUsersBlogsViewController.h"
//#import "UITableViewActivityCell.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponBaseUIViewController.h"

@protocol PhotoponComLoginViewControllerDelegate;

@interface PhotoponComLoginViewController : PhotoponBaseUIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *back;
    IBOutlet UIView *photoponNavBar;

}

@property (unsafe_unretained) id<PhotoponComLoginViewControllerDelegate> delegate;
@property (nonatomic, unsafe_unretained) BOOL isStatsInitiated;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *back;
@property (nonatomic, strong) IBOutlet UIView *photoponNavBar;

- (IBAction)backHandler:(id)sender;

- (void)fadeInView;
- (void)fadeOutView;

@end

@protocol PhotoponComLoginViewControllerDelegate <NSObject>
- (void)loginController:(PhotoponComLoginViewController *)loginController didAuthenticateWithUsername:(NSString *)username;
- (void)loginControllerDidDismiss:(PhotoponComLoginViewController *)loginController;
@end