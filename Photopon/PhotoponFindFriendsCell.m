//
//  PhotoponFindFriendsCell.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponFindFriendsCell.h"
#import "PhotoponProfileImageView.h"

@interface PhotoponFindFriendsCell ()
/*! The cell's views. These shouldn't be modified but need to be exposed for the subclass */
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIButton *avatarImageButton;
@property (nonatomic, strong) PhotoponProfileImageView *avatarImageView;

@end

@implementation PhotoponFindFriendsCell

@synthesize delegate;
@synthesize user;
@synthesize avatarImageView;
@synthesize avatarImageButton;
@synthesize nameButton;
@synthesize photoLabel;
@synthesize followButton;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.avatarImageView = [[PhotoponProfileImageView alloc] init];
        [self.avatarImageView setFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
        [self.contentView addSubview:self.avatarImageView];
        
        self.avatarImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarImageButton setBackgroundColor:[UIColor clearColor]];
        [self.avatarImageButton setFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
        [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarImageButton];
        
        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameButton setBackgroundColor:[UIColor clearColor]];
        [self.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self.nameButton.titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [self.nameButton setTitleColor:[UIColor colorWithRed:87.0f/255.0f green:72.0f/255.0f blue:49.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.nameButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.nameButton];
        
        self.photoLabel = [[UILabel alloc] init];
        [self.photoLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.photoLabel setTextColor:[UIColor grayColor]];
        [self.photoLabel setBackgroundColor:[UIColor clearColor]];
        [self.photoLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.700f]];
        [self.photoLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.contentView addSubview:self.photoLabel];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.followButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [self.followButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 10.0f, 0.0f, 0.0f)];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"PhotoponButtonFollowOff.png"] forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"PhotoponButtonFollowOn.png"] forState:UIControlStateSelected];
        [self.followButton setImage:[UIImage imageNamed:@"IconTick.png"] forState:UIControlStateSelected];
        //[self.followButton setTitle:@"Follow  " forState:UIControlStateNormal]; // space added for centering
        //[self.followButton setTitle:@"Following" forState:UIControlStateSelected];
        [self.followButton setTitleColor:[UIColor colorWithRed:84.0f/255.0f green:57.0f/255.0f blue:45.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.followButton setTitleShadowColor:[UIColor colorWithRed:232.0f/255.0f green:203.0f/255.0f blue:168.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.followButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.followButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
        [self.followButton addTarget:self action:@selector(didTapFollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.followButton];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}


#pragma mark - PhotoponFindFriendsCell

- (void)setUser:(PhotoponUserModel *)aUser {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.user = aUser;
    
    // Configure the cell
    [avatarImageView setFile:[self.user objectForKey:kPhotoponUserAttributesProfilePictureUrlKey]];
    
    // Set name
    NSString *nameString = [self.user objectForKey:kPhotoponUserAttributesFullNameKey];
    CGSize nameSize = [nameString sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] forWidth:144.0f lineBreakMode:UILineBreakModeTailTruncation];
    [nameButton setTitle:[self.user objectForKey:kPhotoponUserAttributesFullNameKey] forState:UIControlStateNormal];
    [nameButton setTitle:[self.user objectForKey:kPhotoponUserAttributesFullNameKey] forState:UIControlStateHighlighted];
    
    [nameButton setFrame:CGRectMake( 60.0f, 17.0f, nameSize.width, nameSize.height)];
    
    // Set photo number label
    CGSize photoLabelSize = [@"photos" sizeWithFont:[UIFont systemFontOfSize:11.0f] forWidth:144.0f lineBreakMode:UILineBreakModeTailTruncation];
    [photoLabel setFrame:CGRectMake( 60.0f, 17.0f + nameSize.height, 140.0f, photoLabelSize.height)];
    
    // Set follow button
    [followButton setFrame:CGRectMake( 208.0f, 20.0f, 103.0f, 32.0f)];
}

#pragma mark - ()

+ (CGFloat)heightForCell {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 67.0f;
}

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        //[self.delegate cell:self didTapUserButton:self.user];
    }
}

/* Inform delegate that the follow button was tapped */
- (void)didTapFollowButtonAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
        //[self.delegate cell:self didTapFollowButton:self.user];
    }
}

@end
