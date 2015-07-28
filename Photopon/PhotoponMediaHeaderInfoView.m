//
//  PhotoponMediaHeaderInfoView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/10/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaHeaderInfoView.h"
#import "PhotoponImageView.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoponUIButton+AFNetworking.h"
#import "PhotoponUtility.h"


@interface PhotoponMediaHeaderInfoView ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation PhotoponMediaHeaderInfoView

@synthesize dataObject;
@synthesize photoponBtnProfileImagePerson;
@synthesize photoponBtnProfileNamePerson;
@synthesize photoponExpirationDate;
@synthesize photoponExpirationImageView;
@synthesize photoponLabelProfileSubtitleImageViewPerson;
@synthesize photoponLabelProfileSubtitlePerson;


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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

+ (PhotoponMediaHeaderInfoView *)photoponMediaHeaderInfoViewWithName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponMediaHeaderInfoView" owner:nil options:nil];
    PhotoponMediaHeaderInfoView *view = [arr objectAtIndex:0];
    
    [view setName:nameText imageURL:imageURLText createdDate:createdDateText expirationDate:expirationDateText];
    
    //view.clipsToBounds = NO;
    //view.containerView.clipsToBounds = NO;
    //view.superview.clipsToBounds = NO;
    //[view setBackgroundColor:[UIColor clearColor]];
    
    
    
    // translucent portion
    //view.containerView = [[UIView alloc] initWithFrame:CGRectMake( 6.0f, 0.0f, view.bounds.size.width - 6.0f * 2.0f, view.bounds.size.height)];
    //[view addSubview:view.containerView];
    //[view.containerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
    
    
    /*
    CALayer *layer = [view layer];
    layer.backgroundColor = [[UIColor whiteColor] CGColor];
    layer.masksToBounds = NO;
    layer.shadowRadius = 1.0f;
    layer.shadowOffset = CGSizeMake( 0.0f, 2.0f);
    layer.shadowOpacity = 0.5f;
    layer.shouldRasterize = YES;
    layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake( 0.0f, view.frame.size.height - 4.0f, view.frame.size.width, 4.0f)].CGPath;
    */
    return view;
}

#pragma mark -
#pragma mark Instance Methods


- (IBAction)handleUserButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoHeaderView:didTapUserButton:user:)]) {
        [self.delegate photoHeaderView:self didTapUserButton:sender user:nil];
    }
}

- (void)setName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");    
    
    //self.photoponExpirationDate.text = expirationDateText;
    self.photoponLabelProfileSubtitlePerson.text = createdDateText;
    [self.photoponBtnProfileNamePerson setTitle:nameText forState:UIControlStateNormal];
    [self.photoponBtnProfileNamePerson setTitle:nameText forState:UIControlStateHighlighted];
    [self.photoponBtnProfileNamePerson setTitle:nameText forState:UIControlStateSelected];
    
    
    if (imageURLText==nil || !imageURLText.length>0) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (imageURLText==nil || !imageURLText.length>0) { ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        return;
        
        //[self.photoponBtnProfileImagePerson.imageView setImageWithURL:[[NSURL alloc] initWithString:@"PhotoponPlaceholderProfileSmall.png"]];
    }else{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (imageURLText==nil || !imageURLText.length>0) {  else {  ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.photoponBtnProfileImagePerson.imageView setImageWithURL:[[NSURL alloc] initWithString:imageURLText] placeholderImage:[[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderProfileSmall.png"]];
    }
    
    
    /*
    CGSize sz = [nameText sizeWithFont:self.photoponBtnProfileImagePerson.titleLabel.font
                        constrainedToSize:CGSizeMake(self.frame.size.width, 999.0f)
                            lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect lfrm = self.photoponBtnProfileImagePerson.titleLabel.frame;
    lfrm.size.height = sz.height;
    self.photoponBtnProfileImagePerson.titleLabel.frame = lfrm;
    
    CGRect bfrm = self.photoponBtnProfileImagePerson.frame;
    bfrm.origin.y = lfrm.origin.y + lfrm.size.height + 10.0f;
    
    / *
    self.cancelButton.frame = bfrm;
    
    if ((cancelText == nil || [cancelText length] == 0) && !self.cancelButton.hidden) {
        self.cancelButton.hidden = YES;
        CGRect frame = self.frame;
        frame.size.height = lfrm.origin.y + lfrm.size.height + 10.0f;
        self.frame = frame;
        
    } else if(self.cancelButton.hidden) {
        self.cancelButton.hidden = NO;
        CGRect frame = self.frame;
        frame.size.height = bfrm.origin.y + bfrm.size.height + 10.0f;
        self.frame = frame;
    }
    */
    
    //if ([self superview]) {
    //    [self centerInSuperview];
    //}
}


- (void)showInView:(UIView *)view {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
}


- (void)centerInSuperview {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Center in parent.
    CGRect frame = [self superview].frame;
    CGFloat x = (frame.size.width / 2.0f) - (self.frame.size.width / 2.0f);
    CGFloat y = 75.0f;//(frame.size.height / 2.0f) - (self.frame.size.height / 2.0f);
    
    frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    self.frame = frame;
}


/*
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
}* /

- (void)drawRect:(CGRect)rect
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Drawing code
    
    [super drawRect:rect];
    [PhotoponUtility drawSideAndTopDropShadowForRect:self.frame inContext:UIGraphicsGetCurrentContext()];
    
}*/

@end
