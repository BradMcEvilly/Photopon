//
//  PhotoponMediaFooterStatsView.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaFooterStatsView.h"

@implementation PhotoponMediaFooterStatsView

@synthesize photoponBtnStatsComments;
@synthesize photoponBtnStatsLikes;
@synthesize photoponBtnStatsSnips;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)handleCommentStatsButtonTapped:(id)sender{

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self photoponMediaFooterStatsView:self didTapCommentMediaButton:sender media:[delegate ];
}

- (IBAction)handleLikeStatsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (IBAction)handleSnipStatsButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

/*!
 Sent to the delegate when the like media button is tapped
 @param media the PhotoponMediaModel for the photopon that is being liked, disliked, snipped, unsnipped, etc
 * /
- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapLikeMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapSnipMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (void)photoponMediaFooterStatsView:(PhotoponMediaFooterStatsView *)photoponMediaFooterStatsView didTapCommentMediaButton:(PhotoponUIButton *)button media:(PhotoponMediaModel *)media{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
