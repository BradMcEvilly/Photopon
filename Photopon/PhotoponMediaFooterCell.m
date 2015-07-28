//
//  PhotoponMediaFooterCell.m
//  Photopon
//
//  Created by Brad McEvilly on 8/2/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponMediaFooterCell.h"
#import "PhotoponMediaFooterInfoView.h"
#import "PhotoponUtility.h"

@implementation PhotoponMediaFooterCell

@synthesize photoponMediaFooterInfoView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (PhotoponMediaFooterCell *)photoponMediaFooterCell{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponMediaFooterCell" owner:nil options:nil];
    PhotoponMediaFooterCell *cell = [arr objectAtIndex:0];
    
    // Initialization code
    cell.opaque = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.clipsToBounds = NO;
    
    /*
    UIView *dropshadowView = [[UIView alloc] init];
    dropshadowView.backgroundColor = [UIColor clearColor];
    dropshadowView.frame = CGRectMake( 6.0f, -44.0f, 309.0f, 322.0f);
    [cell.contentView addSubview:dropshadowView];
    */
    
    cell.photoponMediaFooterInfoView.backgroundColor = [UIColor clearColor];
    
    
    //dropshadowView.frame = CGRectMake( 6.0f, -44.0f, 309.0f, 322.0f);
    //[cell.contentView addSubview:dropshadowView];
    
    CALayer *layer = cell.photoponMediaFooterInfoView.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.9f;
    layer.shadowOffset = CGSizeMake( 0.0f, -1.0f);
    layer.shouldRasterize = NO;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UIView
/*
- (void)drawRect:(CGRect)rect {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super drawRect:rect];
    
    //if (!hideDropShadow) {
    
    [PhotoponUtility drawSideDropShadowForRect:self.photoponMediaFooterInfoView.frame inContext:UIGraphicsGetCurrentContext()];
    
    //}
}
*/

#pragma mark - PhotoponMediaFooterInfoView
/*
+ (CGRect)rectForView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, viewTotalHeight);
}
*/
@end
