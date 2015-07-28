//
//  PhotoponLoadMoreCell.m
//  Photopon
//
//  Created by Brad McEvilly on 5/23/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponLoadMoreCell.h"
#import "PhotoponUtility.h"

@implementation PhotoponLoadMoreCell

@synthesize cellInsetWidth;
@synthesize mainView;
@synthesize separatorImageTop;
@synthesize separatorImageBottom;
@synthesize loadMoreImageView;
@synthesize hideSeparatorTop;
@synthesize hideSeparatorBottom;


#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.cellInsetWidth = 0.0f;
        hideSeparatorTop = NO;
        hideSeparatorBottom = NO;
        
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        
        mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        [mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
        
        self.loadMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellLoadMore.png"]];
        [mainView addSubview:self.loadMoreImageView];
        
        self.separatorImageTop = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
        [mainView addSubview:separatorImageTop];
        
        self.separatorImageBottom = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
        [mainView addSubview:separatorImageBottom];
        
        [self.contentView addSubview:mainView];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [mainView setFrame:CGRectMake( self.cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*self.cellInsetWidth, self.contentView.frame.size.height)];
    
    // Layout load more text
    [self.loadMoreImageView setFrame:CGRectMake( -self.cellInsetWidth, -2.0f, 320.0f, 31.0f)];
    
    // Layout separator
    [self.separatorImageBottom setFrame:CGRectMake( 0.0f, self.frame.size.height - 2.0f, self.frame.size.width-self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageBottom setHidden:hideSeparatorBottom];
    
    [self.separatorImageTop setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageTop setHidden:hideSeparatorTop];
}

- (void)drawRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super drawRect:rect];
    if (self.cellInsetWidth != 0.0f) {
        [PhotoponUtility drawSideDropShadowForRect:mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}


#pragma mark - PAPLoadMoreCell

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    cellInsetWidth = insetWidth;
    [mainView setFrame:CGRectMake( insetWidth, mainView.frame.origin.y, mainView.frame.size.width - 2.0f * insetWidth, mainView.frame.size.height)];
    [self setNeedsDisplay];
}

@end
