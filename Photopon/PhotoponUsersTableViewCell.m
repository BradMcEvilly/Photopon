//
//  PhotoponUsersTableViewCell.m
//  Photopon
//
//  Created by Brad McEvilly on 7/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponUsersTableViewCell.h"
#import "PhotoponUIButton+AFNetworking.h"
#import "PhotoponUserModel.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoponUsersTableViewCell

@synthesize photoponBtnProfileFollowing;
@synthesize photoponBtnUserName;
@synthesize photoponBtnUserImage;
//@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (PhotoponUsersTableViewCell *)photoponUsersTableViewCellWithUserModel:(PhotoponUserModel *)userModel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponUsersTableViewCell" owner:nil options:nil];
    PhotoponUsersTableViewCell *cell = [arr objectAtIndex:0];
    
    return cell;
}

-(IBAction)photoponBtnUserNameHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponUsersTableViewCell:didTapUserButton:user:)]) {
        [self.delegate photoponUsersTableViewCell:self didTapUserButton:sender user:nil];
    }
    
    
}


-(IBAction)photoponBtnProfileFollowingHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponUsersTableViewCell:didTapFollowUserButton:user:)]) {
        [self.delegate photoponUsersTableViewCell:self didTapFollowUserButton:sender user:nil];
    }
    
}

@end
