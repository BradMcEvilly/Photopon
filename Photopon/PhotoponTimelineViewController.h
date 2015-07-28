//
//  PhotoponTimelineViewController.h
//  Photopon
//
//  Created by Brad McEvilly on 5/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponQueryTableViewController.h"
#import "PhotoponMediaHeaderInfoView.h"
#import "PhotoponMediaFooterInfoView.h"
#import "PhotoponMediaFullCell.h"
#import "PhotoponMediaFlatCell.h"

@interface PhotoponTimelineViewController : PhotoponQueryTableViewController <PhotoponMediaFlatCellDelegate, PhotoponMediaFullCellDelegate, PhotoponMediaFooterInfoViewDelegate, PhotoponMediaHeaderInfoViewDelegate>

- (PhotoponMediaFooterInfoView *)dequeueReusableSectionFooterView;

- (PhotoponMediaHeaderInfoView *)dequeueReusableSectionHeaderView;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (PhotoponMediaFooterInfoView *)tableView:(UITableView *)tableView viewForMediaFooterInfoInSection:(NSInteger)section;

@end
