//
//  PhotoponMediaFooterActionsView.m
//  Photopon
//
//  Created by Brad McEvilly on 5/25/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaFooterActionsView.h"

@implementation PhotoponMediaFooterActionsView

@synthesize photoponBtnActionsComment;
@synthesize photoponBtnActionsLike;
@synthesize photoponBtnActionsSnip;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
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

- (IBAction)handleCommentActionsButtonTapped:(id)sender{
    
}

- (IBAction)handleLikeActionsButtonTapped:(id)sender{
    
}

- (IBAction)handleSnipActionsButtonTapped:(id)sender{
    
}


@end
