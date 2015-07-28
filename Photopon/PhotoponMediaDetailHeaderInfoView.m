//
//  PhotoponMediaDetailHeaderInfoView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/14/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaDetailHeaderInfoView.h"
#import "PhotoponMediaFooterInfoView.h"
#import "PhotoponMediaHeaderInfoView.h"
#import "PhotoponMediaCell.h"
#import "PhotoponUIButton+AFNetworking.h"
#import "PhotoponTimelineViewController.h"
#import "PhotoponMediaCaptionCell.h"
#import "PhotoponRedeemViewController.h"

@implementation PhotoponMediaDetailHeaderInfoView

@synthesize photoponBtnActionsComment;
@synthesize photoponBtnActionsLike;
@synthesize photoponBtnActionsSnip;
@synthesize photoponBtnProfileImagePerson;
@synthesize photoponBtnProfileNamePerson;
@synthesize photoponBtnStatsComments;
@synthesize photoponBtnStatsLikes;
@synthesize photoponBtnStatsSnips;
@synthesize photoponExpirationDate;
@synthesize photoponExpirationImageView;
@synthesize photoponLabelProfileSubtitleImageViewPerson;
@synthesize photoponLabelProfileSubtitlePerson;
@synthesize photoponMediaModel;

@synthesize photoponMediaFooterInfoView;
@synthesize photoponMediaHeaderInfoView;
@synthesize photoponMediaCell;
//@synthesize photoponMediaCaptionCell;
@synthesize photoponPersonalMessage;

@synthesize photoponBtnRedeem;

//@synthesize delegate;

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

+ (PhotoponMediaDetailHeaderInfoView *)photoponMediaDetailHeaderInfoView:(PhotoponMediaModel *)mediaModel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // just build existing views & delegates & pass mediaModel along to this view and media cell, footer, and header views
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponMediaDetailHeaderInfoView" owner:nil options:nil];
    PhotoponMediaDetailHeaderInfoView *view = [arr objectAtIndex:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
    
    view.photoponMediaModel = mediaModel;
    
    view.photoponMediaHeaderInfoView.delegate = view;
    view.photoponMediaFooterInfoView.delegate = view;
    
    view.photoponPersonalMessage.delegate = view;
    view.photoponPersonalMessage.userInteractionEnabled = YES;
    view.photoponPersonalMessage.numberOfLines = 0;
    view.photoponPersonalMessage.lineBreakMode = NSLineBreakByCharWrapping;
    [view.photoponPersonalMessage setString:@"This #is a @test for my #@new http://AMAttributedHighlightLabel.class"];
    
        
    [view.photoponMediaCell setDetail:view.photoponMediaModel.value offerValue:view.photoponMediaModel.coupon.details personalMessage:view.photoponMediaModel.caption];
    
    //view.photoponMediaCaptionCell.delegate = view;
        
    //[view.photoponMediaCell setAlpha:0.0f];
    
        /*
        if (mediaModel.caption)
            [view.photoponMediaCaptionCell setUpWithText:mediaModel.caption];
        else
            [view.photoponMediaCaptionCell setUpWithText:@""];
        
         */
    if (mediaModel.linkURL) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---->       object.linkURL = %@", mediaModel.linkURL);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSURL *linkURL = [[NSURL alloc] initWithString:mediaModel.linkURL];
        
        UIImage *placeHolderImg = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderMediaPhoto.png"];
        
        __weak __typeof(&*view)weakView = view;
        
        [view.photoponMediaCell.imageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURL] placeholderImage:placeHolderImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakView.photoponMediaCell.imageView setImage:image];
                [weakView fadeInView];
            });
        
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            
        }];
    }
    
    });
    
    return view;
    
}

- (void)fadeInView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.4];
    self.photoponMediaCell.imageView.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:0.4];
    self.photoponMediaCell.imageView.alpha = 0.0;
    [UIView commitAnimations];
    
}

#pragma mark PhotoponMediaFooterInfoViewDelegate methods

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}


/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 */
- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapStatsLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapStatsSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)photoponMediaFooterInfoView:(PhotoponMediaFooterInfoView *)photoponMediaFooterInfoView didTapStatsCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

#pragma mark PhotoponMediaHeaderInfoViewDelegate methods

- (void)photoHeaderView:(PhotoponMediaHeaderInfoView *)photoHeaderView didTapUserButton:(UIButton *)button user:(PhotoponUserModel *)user{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)photoHeaderView:(PhotoponMediaHeaderInfoView *)photoHeaderView didTapLikePhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (void)photoHeaderView:(PhotoponMediaHeaderInfoView *)photoHeaderView didTapCommentOnPhotoButton:(UIButton *)button photo:(PhotoponMediaModel *)photo{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}


#pragma - AMAttributedHighlightLabel Delegate methods

- (void)selectedMention:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Selected" message:string cancelButtonTitle:@"OK"];
    
}
- (void)selectedHashtag:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Selected" message:string cancelButtonTitle:@"OK"];
    
}
- (void)selectedLink:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Selected" message:string cancelButtonTitle:@"OK"];
    
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}

- (IBAction)photoponBtnRedeemHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    [self.delegate photoponMediaDetailHeaderInfoView:self didTapRedeemButton:sender user:self.photoponMediaModel];
    
    
    //[appDelegate.photoponTabBarViewController showNestedDetailViewController:photoponRedeemViewController];
    
    
    /*
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"");
     NSLog(@"            self.photoponMediaModel.coupon.couponURL     ");
     NSLog(@"------>    %@", self.photoponMediaModel.coupon.couponURL);
     NSLog(@"");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
     */
    //[photoponRedeemViewController loadRedeemURL:@"http://www.yelp.com/deals/plaza-restaurant-newton?aff_sub=portal"];
    //[photoponRedeemViewController loadRedeemURL:self.photoponMediaModel.coupon.couponURL];

    
    
    
}

@end
