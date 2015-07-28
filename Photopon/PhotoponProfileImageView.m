//
//  PhotoponProfileImageView.m
//  Photopon
//
//  Created by Brad McEvilly on 5/24/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponProfileImageView.h"
#import "PhotoponImageView.h"

@interface PhotoponProfileImageView ()
@property (nonatomic, strong) UIImageView *borderImageview;
@end

@implementation PhotoponProfileImageView

@synthesize borderImageview;
@synthesize profileImageView;
@synthesize profileButton;



#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithFrame:frame];
    if (self) {
        
        /*
        self.backgroundColor = [UIColor clearColor];
        
        self.profileImageView = [[PhotoponImageView alloc] initWithFrame:frame];
        [self addSubview:self.profileImageView];
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];
        
        
        / *
        if (frame.size.width < 35.0f) {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-29.png"]];
        } else if (frame.size.width < 43.0f) {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-35.png"]];
        } else {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-43.png"]];
        }
        
        // 
        
        [self addSubview:self.borderImageview];
         */
    }
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super layoutSubviews];
    //[self bringSubviewToFront:self.borderImageview];
    
    //self.profileImageView.frame = CGRectMake( 1.0f, 0.0f, self.frame.size.width - 2.0f, self.frame.size.height - 2.0f);
    //self.borderImageview.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    //self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
}

#pragma mark - PAPProfileImageView

- (void)setFile:(PhotoponFile *)file {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!file) {
        return;
    }
    /*
    self.profileImageView.image = [UIImage imageNamed:@"PhotoponPlaceholderProfileSmall.png"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
     */
}

@end


