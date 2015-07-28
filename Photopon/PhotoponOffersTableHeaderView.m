//
//  PhotoponOffersTableHeaderView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/17/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponOffersTableHeaderView.h"
#import "PhotoponCouponModel.h"

@implementation PhotoponOffersTableHeaderView

@synthesize delegate;
@synthesize photoponBtnSpoofpon;
@synthesize photoponCouponModel;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (PhotoponOffersTableHeaderView *)photoponOffersTableHeaderViewWithCouponModel:(PhotoponCouponModel *)spoofponModel{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponOffersTableHeaderView" owner:nil options:nil];
    PhotoponOffersTableHeaderView *view = [arr objectAtIndex:0];
    view.photoponCouponModel = spoofponModel;
    
    /*
    //[view.photoponBtnProfileImage setImageWithURL: [NSURL URLWithString:view.photoponUserModel.profilePictureUrl]];
    view.photoponLabelProfileName.text = [[NSString alloc] initWithFormat:@"%@ %@", view.photoponUserModel.firstName, view.photoponUserModel.lastName];
    
    
    
    view.photoponLabelPhotoponsString = [[NSString alloc] initWithFormat:@"%@", @"PHOTOPONS"];
    view.photoponLabelFollowingString = [[NSString alloc] initWithFormat:@"%@", @"FOLLOWING"];
    view.photoponLabelFollowersString = [[NSString alloc] initWithFormat:@"%@", @"FOLLOWERS"];
    
    view.photoponLabelPhotopons.text = view.photoponLabelPhotoponsString;
    view.photoponLabelFollowing.text = view.photoponLabelFollowingString;
    view.photoponLabelFollowers.text = view.photoponLabelFollowersString;
    
    [view.photoponBtnProfileStatsFollowers setTitle:view.photoponUserModel.followersCountString forState:UIControlStateNormal];
    [view.photoponBtnProfileStatsFollowing setTitle:view.photoponUserModel.followedByCountString forState:UIControlStateNormal];
    [view.photoponBtnProfileStatsPhotopons setTitle:view.photoponUserModel.mediaCountString forState:UIControlStateNormal];
    
    [view.photoponBtnProfileFollowing setSelected:NO];
    
    if([userModel.didFollowString boolValue])
        [view.photoponBtnProfileFollowing setSelected:YES];
    */
    
    return view;
    
}

-(IBAction)photoponBtnSpoofponHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate) {
        [self.delegate photoponOffersTableHeaderView:self didTapSpoofponButton:sender coupon:self.photoponCouponModel];
    }
    
}

@end
