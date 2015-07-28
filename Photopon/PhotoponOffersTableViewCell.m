//
//  PhotoponOffersTableViewCell.m
//  Photopon
//
//  Created by Brad McEvilly on 7/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponOffersTableViewCell.h"
#import "PhotoponImageView.h"
#import "PhotoponUIButton.h"
#import "Photopon8CouponsModel.h"

@implementation PhotoponOffersTableViewCell

@synthesize photoponBtnCouponImage;
@synthesize photoponBtnCouponTitle;
@synthesize delegate;
@synthesize coupon;
@synthesize photoponBtnCouponSelect;
@synthesize couponTextView;
@synthesize photoponLabelCouponExpiration;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (PhotoponOffersTableViewCell *)photoponOffersTableViewCell{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponOffersTableViewCell" owner:nil options:nil];
    PhotoponOffersTableViewCell *cell = [arr objectAtIndex:0];
    
    return cell;
}

-(void)setUpWithObject:(Photopon8CouponsModel *)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.coupon = object;
    
    if (!self.coupon.place){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            NULL NULL NULL      if (!self.coupon.place){      ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    }else{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            self.coupon.place.name = %@", self, NSStringFromSelector(_cmd), self.coupon.place.name);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.photoponBtnCouponTitle setTitle:[[NSString alloc] initWithFormat:@"%@", self.coupon.place.name] forState:UIControlStateNormal];
        
        [self.photoponBtnCouponTitle setTitle:[[NSString alloc] initWithFormat:@"%@", self.coupon.place.name] forState:UIControlStateHighlighted];
        [self.photoponBtnCouponTitle setTitle:[[NSString alloc] initWithFormat:@"%@", self.coupon.place.name] forState:UIControlStateSelected];
        
        [self.photoponBtnCouponImage.imageView setImageWithURL:[NSURL URLWithString:self.coupon.couponURL] placeholderImage:nil];
        
        [self.couponTextView setText:self.coupon.details];
        
        //[self.photoponLabelCouponExpiration setText:self.coupon.expirationTextString];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
        
    }
    
    
    
    
    
    /*
    [self.photoponBtnCouponTitle setTitle:[[NSString alloc] initWithFormat:@"%@", self.coupon.place.name] forState:UIControlStateNormal];
    [self.photoponBtnCouponTitle setTitle:[[NSString alloc] initWithFormat:@"%@", self.coupon.place.name] forState:UIControlStateHighlighted];
    [self.photoponBtnCouponTitle setTitle:[[NSString alloc] initWithFormat:@"%@", self.coupon.place.name] forState:UIControlStateSelected];
    
    [self.photoponBtnCouponImage.imageView setImageWithURL:[NSURL URLWithString:self.coupon.couponURL] placeholderImage:nil];
    
    [self.couponTextView setText:self.coupon.details];
    
    [self.photoponLabelCouponExpiration setText:self.coupon.expirationTextString];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

/* Inform delegate that a user image or name was tapped */
- (IBAction)photoponBtnCouponHandler:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapCouponButton:)]) {
        [self.delegate cell:self didTapCouponButton:self.coupon];
    }
}

@end
