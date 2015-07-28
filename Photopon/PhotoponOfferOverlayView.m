//
//  PhotoponOfferOverlayView.m
//  Photopon
//
//  Created by Brad McEvilly on 7/10/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponOfferOverlayView.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoponOfferOverlayView{
    NSString *_sourceImage;
}

//@synthesize photoponPersonalMessage;
@synthesize photoponOfferDetails;
@synthesize photoponOfferValue;
@synthesize photoponPlaceDetails;
@synthesize photoponPersonalMessage;
@synthesize sourceImage;
@synthesize sourceImageView;
@synthesize sourceURL;
@synthesize distanceText;
@synthesize distanceLabelView;
@synthesize offerSourceImageContainer;

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (id) initWithCoder:(NSCoder *)aDecoder{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self.photoponOfferValue setFont:[PhotoponUtility photoponFontBoldForOfferValue]];
        [self.photoponOfferDetails setFont:[PhotoponUtility photoponFontBoldForOfferTitle]];
        [self.photoponPersonalMessage setFont:[PhotoponUtility photoponFontBoldForOfferPersonalCaption]];
    
    }
    return self;
}

+ (PhotoponOfferOverlayView *)photoponOfferOverlayViewWithOfferDetails:(NSString *)detailsText offerValue:(NSString *)valueText  personalMessage:(NSString *)personalMessageText {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PhotoponOfferOverlayView" owner:nil options:nil];
    PhotoponOfferOverlayView *view = [arr objectAtIndex:0];
    [view setDetail:detailsText offerValue:valueText personalMessage:personalMessageText];
    
    view.clipsToBounds = NO;
    //view.containerView.clipsToBounds = NO;
    view.superview.clipsToBounds = NO;
    //[self setBackgroundColor:[UIColor clearColor]];
    
    
    [view.photoponOfferValue setFont:[PhotoponUtility photoponFontBoldForOfferValue]];
    [view.photoponOfferDetails setFont:[PhotoponUtility photoponFontBoldForOfferTitle]];
    [view.photoponPersonalMessage setFont:[PhotoponUtility photoponFontBoldForOfferPersonalCaption]];
    
    
    
    
    //[view centerInSuperview];
    
    
    
    // translucent portion
    //view.containerView = [[UIView alloc] initWithFrame:CGRectMake( 6.0f, 0.0f, view.bounds.size.width - 6.0f * 2.0f, view.bounds.size.height)];
    //[view addSubview:view.containerView];
    //[view.containerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoponBackgroundComments.png"]]];
    
    
    /*
     CALayer *layer = [view layer];
     layer.backgroundColor = [[UIColor whiteColor] CGColor];
     layer.masksToBounds = NO;
     layer.shadowRadius = 1.0f;
     layer.shadowOffset = CGSizeMake( 0.0f, 2.0f);
     layer.shadowOpacity = 0.5f;
     layer.shouldRasterize = YES;
     layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake( 0.0f, view.frame.size.height - 4.0f, view.frame.size.width, 4.0f)].CGPath;
     */
    
    
    
    return view;
}

#pragma mark -
#pragma mark Instance Methods


- (IBAction)handleUserButtonTapped:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    /*
     // Prevent multiple taps.
     [photoponBtnProfileNamePerson removeTarget:self action:@selector(handleUserButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
     
     [UIView animateWithDuration:0.3 animations:^{
     self.alpha = 0.0;
     } completion:^(BOOL finished) {
     [self removeFromSuperview];
     }];
     */
    
    
    
}

- (void)setPlaceDetails:(NSString *)detailText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponPlaceDetails.text = detailText;
    
    [self setNeedsDisplay];
}

- (void)setPlaceName:(NSString *)placeNameText placeDistance:(NSString *)placeDistanceText offerSourceImageURL:(NSString *)sourceImageURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponPlaceDetails.text = placeNameText;
    
    @try {
        self.sourceURL = [[NSString alloc] initWithFormat:@"%@", sourceImageURL];
    }
    @catch (NSException *exception) {
        self.sourceURL = [[NSString alloc] initWithFormat:@"%@", @"http://images.photopon.com/images/coupon-stack.png"];
    }
    @finally {
        
    }
    self.distanceText = placeDistanceText;
    self.distanceLabelView.text = self.distanceText;
    
    
    
    [self setNeedsDisplay];
    
}

- (void)setSourceURL:(NSString *)aSourceURL{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    _sourceImage = aSourceURL;
    
    NSURL *linkURLOfferSourceImage = [[NSURL alloc] initWithString:_sourceImage];
    
    UIImage *placeHolderOfferSourceImage = [[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderOfferSource-110-26.png"];
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"---->       self.sourceURL = %@", self.sourceURL);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.sourceImageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLOfferSourceImage] placeholderImage:placeHolderOfferSourceImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[weakSelf.offerSourceImageContainer setBackgroundColor:[UIColor whiteColor]];
            //[weakSelf.offerSourceImageContainer setAlpha:0.6f];
            [weakSelf.sourceImageView setImage:image];
            [weakSelf setNeedsDisplay];
            
        });
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        [weakSelf.offerSourceImageContainer setBackgroundColor:[UIColor clearColor]];
        UIImage *photoponLogoImage = [UIImage imageNamed:@"PhotoponLogoStandardWhite-110-26.png"];
        [weakSelf.sourceImageView setImage:photoponLogoImage];
        
    }];
    
    
    /*
    self.sourceURL = aSourceURL;
    
    NSURL *linkURLOfferSourceLogo = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", self.sourceURL]];
    
    UIImage *placeHolderImgOfferSourceLogo = [UIImage imageNamed:@"PhotoponPlaceholderOfferSource-76-14.png"];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.sourceImageView setImageWithURLRequest:[PhotoponUtility imageRequestWithURL:linkURLOfferSourceLogo] placeholderImage:placeHolderImgOfferSourceLogo success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage* image){
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            [self.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImageWithURLRequest SUCCESS SUCCESS SUCCESS ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [weakSelf.sourceImageView setImage:image];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"-------->            [self.photoponMediaHeaderInfoView.photoponBtnProfileImagePerson.imageView setImageWithURLRequest FAILURE FAILURE FAILURE ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
    }];
    */
    
}

- (void)setDetail:(NSString *)detailText offerValue:(NSString *)valueText personalMessage:(NSString *)personalMessageText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.photoponOfferValue.text = valueText;
    self.photoponOfferDetails.text = detailText;
    self.photoponPersonalMessage.text = personalMessageText;
    
    
    /*
    self.photoponExpirationDate.text = expirationDateText;
    self.photoponLabelProfileSubtitlePerson.text = createdDateText;
    [self.photoponBtnProfileNamePerson setTitle:nameText forState:UIControlStateNormal];
    [self.photoponBtnProfileNamePerson setTitle:nameText forState:UIControlStateHighlighted];
    [self.photoponBtnProfileNamePerson setTitle:nameText forState:UIControlStateSelected];
    
    
    if (imageURLText==nil || !imageURLText.length>0) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (imageURLText==nil || !imageURLText.length>0) { ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        return;
        
        //[self.photoponBtnProfileImagePerson.imageView setImageWithURL:[[NSURL alloc] initWithString:@"PhotoponPlaceholderProfileSmall.png"]];
    }else{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (imageURLText==nil || !imageURLText.length>0) {  else {  ", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.photoponBtnProfileImagePerson.imageView setImageWithURL:[[NSURL alloc] initWithString:imageURLText] placeholderImage:[[UIImage alloc] initWithContentsOfFile:@"PhotoponPlaceholderProfileSmall.png"]];
    }
    */
    
    
    
    /*
     CGSize sz = [nameText sizeWithFont:self.photoponBtnProfileImagePerson.titleLabel.font
     constrainedToSize:CGSizeMake(self.frame.size.width, 999.0f)
     lineBreakMode:NSLineBreakByWordWrapping];
     
     CGRect lfrm = self.photoponBtnProfileImagePerson.titleLabel.frame;
     lfrm.size.height = sz.height;
     self.photoponBtnProfileImagePerson.titleLabel.frame = lfrm;
     
     CGRect bfrm = self.photoponBtnProfileImagePerson.frame;
     bfrm.origin.y = lfrm.origin.y + lfrm.size.height + 10.0f;
     
     / *
     self.cancelButton.frame = bfrm;
     
     if ((cancelText == nil || [cancelText length] == 0) && !self.cancelButton.hidden) {
     self.cancelButton.hidden = YES;
     CGRect frame = self.frame;
     frame.size.height = lfrm.origin.y + lfrm.size.height + 10.0f;
     self.frame = frame;
     
     } else if(self.cancelButton.hidden) {
     self.cancelButton.hidden = NO;
     CGRect frame = self.frame;
     frame.size.height = bfrm.origin.y + bfrm.size.height + 10.0f;
     self.frame = frame;
     }
     */
    
    if ([self superview]) {
        [self centerInSuperview];
    }
}


- (void)showInView:(UIView *)view {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
}


- (void)centerInSuperview {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN ", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Center in parent.
    CGRect frame = [self superview].frame;
    CGFloat x = (frame.size.width / 2.0f) - (self.frame.size.width / 2.0f);
    CGFloat y = [self superview].frame.size.height - self.frame.size.height;// 75.0f;//(frame.size.height / 2.0f) - (self.frame.size.height / 2.0f);
    
    frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    self.frame = frame;
}


@end
