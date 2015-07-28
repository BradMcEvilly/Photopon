//
//  PhotoponMediaCaptionCell.m
//  Photopon
//
//  Created by Brad McEvilly on 8/1/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "PhotoponMediaCaptionCell.h"
#import "PhotoponUtility.h"
#import "PhotoponTimelineViewController.h"
#import "PhotoponAccountProfileViewController.h"


@interface PhotoponMediaCaptionCell ()

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@end

@implementation PhotoponMediaCaptionCell

@synthesize backgroundPanel;
@synthesize contentText;
@synthesize contentLabel;
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

+ (PhotoponMediaCaptionCell *)photoponMediaCaptionCell{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponMediaCaptionCell" owner:nil options:nil];
    PhotoponMediaCaptionCell *cell = [arr objectAtIndex:0];
    
    cell.contentText = [[NSString alloc] initWithFormat:@"%@", @""];
    [cell.contentLabel setString: cell.contentText];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setUpWithText:(NSString*)aContentText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.contentText = aContentText;
    [self.contentLabel setString: self.contentText];
    
    [self.contentLabel setDelegate:self];
    
    //[self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIView
/*
- (void)drawRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super drawRect:rect];
    
    //if (!hideDropShadow) {
    
    [PhotoponUtility drawSideDropShadowForRect:self.backgroundPanel.frame inContext:UIGraphicsGetCurrentContext()];
    
    
    //}
}

/ *
#pragma mark - PhotoponMediaCaptionCell backgroundPanel

+ (CGRect)rectForView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 69.0f);
}
*/

#pragma - AMAttributedHighlightLabel Delegate methods

- (void)selectedMention:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponMediaCaptionCell:didTapMentionText:)]) {
        [self.delegate photoponMediaCaptionCell:self didTapMentionText:string];
    }
}

- (void)selectedHashtag:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
     */
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponMediaCaptionCell:didTapHashtagText:)]) {
        [self.delegate photoponMediaCaptionCell:self didTapHashtagText:string];
    }
}

- (void)selectedLink:(NSString *)string {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponMediaCaptionCell:didTapLinkText::)]) {
        [self.delegate photoponMediaCaptionCell:self didTapLinkText:string];
    }
}

@end
