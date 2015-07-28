//
//  PhotoponMediaFooterInfoView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/13/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaFooterInfoView.h"

@implementation PhotoponMediaFooterInfoView

@synthesize photoponBtnStatsComments;
@synthesize photoponBtnStatsLikes;
@synthesize photoponBtnStatsSnips;
@synthesize photoponBtnActionsComment;
@synthesize photoponBtnActionsLike;
@synthesize photoponBtnActionsSnip;
@synthesize photoponMediaModel;
@synthesize delegate;

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

+ (PhotoponMediaFooterInfoView *)photoponMediaFooterInfoViewWithMediaModel:(PhotoponMediaModel *)mediaModel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponMediaFooterInfoView" owner:nil options:nil];
    PhotoponMediaFooterInfoView *view = [arr objectAtIndex:0];
    
    view.photoponMediaModel = mediaModel;
    
    [view setStatsLikes:[view.photoponMediaModel objectForKey:kPhotoponMediaAttributesLikeCountKey] statsComments:[view.photoponMediaModel objectForKey:kPhotoponMediaAttributesCommentCountKey] statsSnips:[view.photoponMediaModel objectForKey:kPhotoponMediaAttributesSnipCountKey]];
    
    [view setContentMode:UIViewContentModeScaleAspectFit];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    return view;
}

- (void)setStatsLikes:(NSString*)statsLikesText statsComments:(NSString*)statsCommentsText statsSnips:(NSString*)statsSnipsText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}

- (IBAction)handleCommentStatsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (delegate && [delegate respondsToSelector:@selector(photoponMediaFooterInfoView:didTapStatsCommentMediaButton:media:)]) {
        [delegate photoponMediaFooterInfoView:self didTapStatsCommentMediaButton:sender media:self.photoponMediaModel];
    }
    
}

- (IBAction)handleLikeStatsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (delegate && [delegate respondsToSelector:@selector(photoponMediaFooterInfoView:didTapStatsLikeMediaButton:media:)]) {
        [delegate photoponMediaFooterInfoView:self didTapStatsLikeMediaButton:sender media:self.photoponMediaModel];
    }
    
}

- (IBAction)handleSnipStatsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (delegate && [delegate respondsToSelector:@selector(photoponMediaFooterInfoView:didTapStatsSnipMediaButton:media:)]) {
        [delegate photoponMediaFooterInfoView:self didTapStatsSnipMediaButton:sender media:self.photoponMediaModel];
    }
    
}

- (IBAction)handleCommentActionsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:nil userInfo:nil];
    
    if (delegate && [delegate respondsToSelector:@selector(photoponMediaFooterInfoView:didTapCommentMediaButton:media:)]) {
        [delegate photoponMediaFooterInfoView:self didTapCommentMediaButton:sender media:self.photoponMediaModel];
    }
    
}

- (IBAction)handleLikeActionsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:nil userInfo:nil];
    
    if (delegate && [delegate respondsToSelector:@selector(photoponMediaFooterInfoView:didTapLikeMediaButton:media:)]) {
        [delegate photoponMediaFooterInfoView:self didTapLikeMediaButton:sender media:self.photoponMediaModel];
    }
}

- (IBAction)handleSnipActionsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponPhotoDetailsViewControllerUserSnippedUnsnippedPhotoNotification object:nil userInfo:nil];
    
    if (delegate && [delegate respondsToSelector:@selector(photoponMediaFooterInfoView:didTapSnipMediaButton:media:)]) {
        [delegate photoponMediaFooterInfoView:self didTapSnipMediaButton:sender media:self.photoponMediaModel];
    }
    
}


- (void)setName:(NSString *)nameText imageURL:(NSString *)imageURLText createdDate:(NSString *)createdDateText expirationDate:(NSString *)expirationDateText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
}



@end
