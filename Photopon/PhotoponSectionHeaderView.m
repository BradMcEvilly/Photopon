//
//  PhotoponSectionHeaderView.m
//  Photopon
//
//  Created by Brad McEvilly on 8/4/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponSectionHeaderView.h"

@implementation PhotoponSectionHeaderView

@synthesize photoponSectionTitle;
@synthesize photoponSectionTitleText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (PhotoponSectionHeaderView *)photoponSectionHeaderViewWithSectionTitle:(NSString *)sectionTitle{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // just build existing views & delegates & pass mediaModel along to this view and media cell, footer, and header views
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponSectionHeaderView" owner:nil options:nil];
    PhotoponSectionHeaderView *view = [arr objectAtIndex:0];
    
    view.photoponSectionTitleText = sectionTitle;
    
    [view.photoponSectionTitle setText:view.photoponSectionTitleText];
    
    return view;
}

-(void)updateSectionTitleWithText:(NSString*)text{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    self.photoponSectionTitleText = text;
    
    [self.photoponSectionTitle setText:self.photoponSectionTitleText];
    
    [self setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
