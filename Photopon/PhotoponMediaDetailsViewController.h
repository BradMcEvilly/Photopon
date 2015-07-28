//
//  PhotoponMediaDetailsViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoponMediaDetailHeaderView.h"
#import "PhotoponBaseTextCell.h"
#import "PhotoponMediaDetailHeaderInfoView.h"

@interface PhotoponMediaDetailsViewController : PhotoponQueryTableViewController <UITextFieldDelegate, UIActionSheetDelegate, PhotoponMediaDetailsHeaderViewDelegate, PhotoponBaseTextCellDelegate, PhotoponMediaDetailHeaderInfoViewDelegate>

@property (nonatomic, strong) PhotoponMediaModel *media;

@property (nonatomic, strong) PhotoponMediaDetailHeaderInfoView *headerView;

@property (nonatomic, strong) NSNumber *heightNumber;

@property (nonatomic, strong) NSNumber *tagNumber;

- (id)initWithMedia:(PhotoponMediaModel*)aMedia;

@end
