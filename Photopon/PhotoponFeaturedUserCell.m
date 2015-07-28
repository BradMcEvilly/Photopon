//
//  PhotoponFeaturedUserCell.m
//  Photopon
//
//  Created by Brad McEvilly on 8/20/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponFeaturedUserCell.h"
#import "PhotoponUserModel.h"

@implementation PhotoponFeaturedUserCell


@synthesize photoponBtnProfileImagePerson;
//@synthesize photoponUserModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)fadeInView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.4];
    self.photoponBtnProfileImagePerson.imageView.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:0.4];
    self.photoponBtnProfileImagePerson.imageView.alpha = 0.0;
    [UIView commitAnimations];
    
}

+ (PhotoponFeaturedUserCell *)photoponFeaturedUserCell:(id<PhotoponFeaturedUserCellDelegate>)aDelegate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponFeaturedUserCell" owner:nil options:nil];
    PhotoponFeaturedUserCell *cell = [arr objectAtIndex:0];
    
    return cell;
}

- (PhotoponUserModel *) photoponUserModel {
    return photoponUserModel;
}

- (void)setPhotoponUserModel:(PhotoponUserModel *)value {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    photoponUserModel = value;
        
    
    
    /*
    NSURL *linkURLProfilePic = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", kPhotoponContentBase, photoponUserModel.profilePictureUrl]];
    
    UIImage *placeHolderImgProfilePic = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
    
    //UIImageView *testImgView = [[UIImageView alloc] initWithFrame:cell.photoponMediaCell.imageView.frame];
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       photoponUserModel.profilePictureUrl = %@", photoponUserModel.profilePictureUrl);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       photoponUserModel.profilePictureUrl FULL = %@", [NSString stringWithFormat:@"%@%@", kPhotoponContentBase, photoponUserModel.profilePictureUrl]);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    __weak __typeof(&*self)weakSelf = self;
    //__weak __typeof(&*photoponUserModel)weakPhotoponUserModel = photoponUserModel;
    
    [self.photoponBtnProfileImagePerson.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLProfilePic] placeholderImage:placeHolderImgProfilePic success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            [self.photoponBtnProfileImagePerson.imageView setImageWithURLRequest SUCCESS SUCCESS SUCCESS ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.photoponBtnProfileImagePerson.imageView setImage:image];
            [weakSelf fadeInView];
        });
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            [self.photoponBtnProfileImagePerson.imageView setImageWithURLRequest FAILURE FAILURE FAILURE ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
    }];*/
    
}

- (IBAction)handleUserButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponFeaturedUserCell:didTapUserButton:user:)]) {
        [self.delegate photoponFeaturedUserCell:self didTapUserButton:sender user:self.photoponUserModel];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
