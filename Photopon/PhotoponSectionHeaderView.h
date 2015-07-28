//
//  PhotoponSectionHeaderView.h
//  Photopon
//
//  Created by Brad McEvilly on 8/4/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoponSectionHeaderView : UIView

@property (nonatomic,retain) IBOutlet NSString *photoponSectionTitleText;

@property (nonatomic,retain) IBOutlet UILabel *photoponSectionTitle;

+ (PhotoponSectionHeaderView *)photoponSectionHeaderViewWithSectionTitle:(NSString *)sectionTitle;

@end
