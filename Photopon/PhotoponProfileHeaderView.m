//
//  PhotoponProfileHeaderView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/10/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponProfileHeaderView.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponUIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoponProfileHeaderView

@synthesize photoponProfileCoverImageView;

@synthesize photoponBtnProfileImage;
@synthesize photoponBtnProfileCover;
@synthesize photoponBtnProfileFollowing;
@synthesize photoponBtnProfileStatsFollowers;
@synthesize photoponBtnProfileStatsFollowing;
@synthesize photoponBtnProfileStatsPhotopons;
//@synthesize delegate;

@synthesize photoponLabelProfileName;
@synthesize photoponLabelProfileSubtitle;

@synthesize photoponUserModel;

@synthesize photoponProfileShadowImageView;

@synthesize photoponLabelFollowers;
@synthesize photoponLabelFollowersString;
@synthesize photoponLabelFollowing;
@synthesize photoponLabelFollowingString;
@synthesize photoponLabelPhotopons;
@synthesize photoponLabelPhotoponsString;
@synthesize photoponLabelProfileTitle;
@synthesize photoponProfileToolBar;
@synthesize photoponProfilePicImageView;
@synthesize photoponBtnProfileSnips;

/*
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

*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (PhotoponProfileHeaderView *)photoponProfileHeaderViewWithUserModel:(PhotoponUserModel *)userModel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponProfileHeaderView" owner:nil options:nil];
    PhotoponProfileHeaderView *view = [arr objectAtIndex:0];
    view.photoponUserModel = userModel;
    [view.photoponProfileShadowImageView setTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    
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
    
    if ([userModel.identifier isEqualToString:[PhotoponUserModel currentUser].identifier]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filename = [PhotoponUtility facebookLocalImageName];
        NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            filepath = %@", self, NSStringFromSelector(_cmd), filepath);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        if ([fileManager fileExistsAtPath:filepath]) {
            
            
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            if ([fileManager fileExistsAtPath:filepath]", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            //NSURL *linkURL = [[NSURL alloc] initWithString:filepath];
            
            //UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderProfileMedium.png"];
            
            //__weak __typeof(&*view)weakView = view;
            
            
            
            //[view.photoponBtnProfileImage.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURL] placeholderImage:placeHolderImg success:^
            
            //[PhotoponUtility currentUserFacebookProfilePicMed];
            
            
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filepath];
            
            [view.photoponProfilePicImageView setImage:image];
            
            /*
             [view.photoponBtnProfileImage.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURL] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
             
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"%@ :: %@            [view.photoponBtnProfileImage.imageView setImageWithURLRequest SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             
             [weakView.photoponBtnProfileImage.imageView setImage:image];
             
             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
             
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"%@ :: %@            [view.photoponBtnProfileImage.imageView setImageWithURLRequest FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             
             }];*/
            
        }
        
    }else{
        
        
        NSURL *linkURL = [[NSURL alloc] initWithString:userModel.profilePictureUrl];
        
        UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderProfileMedium.png"];
        
        __weak __typeof(&*view)weakView = view;
        
        [view.photoponProfilePicImageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURL] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [view.photoponProfilePicImageView setImageWithURLRequest SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [weakView.photoponProfilePicImageView setImage:image];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [view.photoponProfilePicImageView setImageWithURLRequest FAILURE FAILURE FAILURE", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
        }];
        
    }
    
    //if([userModel.didFollowString boolValue])
        //[view.photoponBtnProfileFollowing setSelected:YES];
    
    return view;
    
}

- (id)initWithUserModel:(PhotoponUserModel *)userModel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponProfileHeaderView" owner:nil options:nil];
    self = [arr objectAtIndex:0];
    
    if (self) {
        // Initialization code
        self.photoponUserModel = userModel;
    }
    return self;
    
}

- (id)initWithUserModel:(PhotoponUserModel *)userModel frame:(CGRect)frame{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        self.photoponUserModel = userModel;
    }
    return self;
    
}

-(IBAction)photoponBtnProfileImageHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}

-(IBAction)photoponBtnProfileCoverHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

-(IBAction)photoponBtnProfileFollowingHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponProfileHeaderView:didTapFollowUserButton:user:)]) {
        [self.delegate photoponProfileHeaderView:self didTapFollowUserButton:sender user:self.photoponUserModel];
    }
}

-(IBAction)photoponBtnProfileStatsPhotoponsHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponProfileHeaderView:didTapBtnProfileStatsPhotopons:user:)]) {
        [self.delegate photoponProfileHeaderView:self didTapBtnProfileStatsPhotopons:sender user:self.photoponUserModel];
    }
}

-(IBAction)photoponBtnProfileStatsFollowersHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponProfileHeaderView:didTapBtnProfileStatsFollowers:user:)]) {
        [self.delegate photoponProfileHeaderView:self didTapBtnProfileStatsFollowers:sender user:self.photoponUserModel];
    }
}

-(IBAction)photoponBtnProfileStatsFollowingHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponProfileHeaderView:didTapBtnProfileStatsFollowing:user:)]) {
        [self.delegate photoponProfileHeaderView:self didTapBtnProfileStatsFollowing:sender user:nil];
    }
}

-(IBAction)photoponBtnProfileSnipsHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponProfileHeaderView:didTapBtnProfileSnips:)]) {
        [self.delegate photoponProfileHeaderView:self didTapBtnProfileSnips:sender];
    }
    
}


/*
- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapBtnProfileStatsPhotopons:(PhotoponUIButton *)button user:(PhotoponUserModel *)user{
    
}

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapProfileStatsFollowers:(PhotoponUIButton *)button user:(PhotoponUserModel *)user{
    
}

- (void)photoponProfileHeaderView:(PhotoponProfileHeaderView *)photoponProfileHeaderView didTapProfileStatsFollowing:(PhotoponUIButton *)button user:(PhotoponUserModel *)user{
    
}
*/
@end
