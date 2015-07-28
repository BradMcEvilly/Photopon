//
//  PhotoponSearchTableViewCell.m
//  Photopon
//
//  Created by Brad McEvilly on 7/29/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponSearchTableViewCell.h"
#import "PhotoponUIButton.h"

@implementation PhotoponSearchTableViewCell

//@synthesize delegate;
@synthesize photoponBtnResultCellImage;
@synthesize photoponBtnResultCellTitle;
@synthesize photoponResultCellIcon;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        /*
         // Initialization code
         self.opaque = NO;
         self.selectionStyle = UITableViewCellSelectionStyleNone;
         self.accessoryType = UITableViewCellAccessoryNone;
         self.clipsToBounds = NO;
         
         UIView *dropshadowView = [[UIView alloc] init];
         dropshadowView.backgroundColor = [UIColor clearColor];
         dropshadowView.frame = CGRectMake( 0.0f, -44.0f, 309.0f, 322.0f);
         [self.contentView addSubview:dropshadowView];
         
         CALayer *layer = dropshadowView.layer;
         layer.masksToBounds = NO;
         layer.shadowRadius = 2.0f;
         layer.shadowOpacity = 0.5f;
         layer.shadowOffset = CGSizeMake( 0.0f, -1.0f);
         layer.shouldRasterize = NO;
         
         self.imageView.frame = CGRectMake( 0.0f, 0.0f, 309.0f, 309.0f);
         self.imageView.backgroundColor = [UIColor colorWithRed:230.0f green:230.0f blue:230.0f alpha:1.0f];
         self.imageView.contentMode = UIViewContentModeScaleAspectFit;
         
         self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
         self.photoButton.frame = CGRectMake( 0.0f, 0.0f, 309.0f, 309.0f);
         self.photoButton.backgroundColor = [UIColor clearColor];
         [self.contentView addSubview:self.photoButton];
         
         [self.contentView bringSubviewToFront:self.imageView];
         
         [self.contentView addSubview:offerOverlay];
         
         [self setBackgroundColor:[UIColor clearColor]];
         [self.contentView setBackgroundColor:[UIColor clearColor]];
         */
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}

+ (PhotoponSearchTableViewCell *)photoponSearchResultsTableViewCellWithContentText:(NSString*)contentText imageName:(NSString*)imageName{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponSearchTableViewCell" owner:nil options:nil];
    PhotoponSearchTableViewCell *cell = [arr objectAtIndex:0];
    
    return cell;
}

-(IBAction)photoponBtnResultCellHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoponSearchTableViewCell:didTapResultCellButton:)]) {
        [self.delegate photoponSearchTableViewCell:self didTapResultCellButton:sender];
    }
    
}


@end
