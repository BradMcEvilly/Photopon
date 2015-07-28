//
//  PhotoponOfferPageViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 8/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponOfferPageViewController.h"
//#import "PhotoponUtility.h"
#import "Photopon8CouponsModel.h"
#import "PhotoponOfferOverlayView.h"

@interface PhotoponOfferPageViewController ()

@end

@implementation PhotoponOfferPageViewController{
    //NSString *_captionText;
}

@synthesize pageIndexNumber;
@synthesize captionLabelView;
@synthesize captionText;

//@synthesize offerOverlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCropImage:) name:PhotoponNotificationDidCropImage object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeCaptionText:) name:PhotoponNotificationDidEditCaption object:nil];
        
    }
    return self;
}

- (id)initWithCouponModel:(Photopon8CouponsModel*)coupon{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithNibName:@"PhotoponOfferPageViewController" bundle:nil];
    if (self) {
        // Custom initialization
        photoponCouponModel = coupon;
        self.captionText = [[NSString alloc] initWithFormat:@"%@", @"Add a caption"];
        self.pageIndexNumber = [[NSNumber alloc] initWithInteger:-1];
        
    }
    return self;
}


- (void)didChangeCaptionText:(NSNotification*)note{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self updateCaptionText:(NSString*)[note.userInfo objectForKey:@"captionText"]];
    
    //[self setCaptionText:(NSString*)[note.userInfo objectForKey:@"captionText"]];
    
    
    
}

- (void)updateCaptionText:(NSString *)aCaptionText{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.captionText = aCaptionText;
    
    __weak __typeof(&*self)weakSelf = self;
    
    if (self.view.window) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.captionLabelView.text = weakSelf.captionText;
            
            [weakSelf.view setNeedsLayout];
            [weakSelf.view setNeedsDisplay];
        
        });
        
    }
}

- (NSInteger)pageIndex{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [self.pageIndexNumber integerValue];
}

- (void)setPageIndex:(NSInteger)pageIndex{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.pageIndexNumber = [[NSNumber alloc] initWithInteger:pageIndex];
}

- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    
    [self.offerOverlay.photoponOfferValue setFont:[PhotoponUtility photoponFontBoldForOfferValue]];
    [self.offerOverlay.photoponOfferDetails setFont:[PhotoponUtility photoponFontBoldForOfferTitle]];
    [self.offerOverlay.photoponPersonalMessage setFont:[PhotoponUtility photoponFontBoldForOfferPersonalCaption]];
    
    if ((photoponCouponModel.title && photoponCouponModel.title.length>0) || (photoponCouponModel.value && photoponCouponModel.value.length>0) )
        [self.offerOverlay setDetail:photoponCouponModel.title offerValue:photoponCouponModel.value personalMessage:self.captionText];
    
    if (photoponCouponModel.place.name && photoponCouponModel.place.name.length>0) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (photoponCouponModel.place.name && photoponCouponModel.place.name.length>0) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.offerOverlay setPlaceName:photoponCouponModel.place.name placeDistance: photoponCouponModel.distance offerSourceImageURL:photoponCouponModel.showLogo];
        
        
        
        //[self.offerOverlay setPlaceDetails:[photoponCouponModel.dictionary objectForKey:k8CouponsAPIReturnDataNameKey]];
        
    }
    
    [self.captionLabelView setFont:[PhotoponUtility photoponFontBoldForOfferPersonalCaption]];
    
    [self.offerOverlay.photoponOfferValue setFont:[PhotoponUtility photoponFontBoldForOfferValue]];
    
    
    self.captionLabelView.text = self.captionText;
    
    
    
    /*
     if (photoponCouponModel.title && photoponCouponModel.title.length>0) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            if (photoponCouponModel.title && photoponCouponModel.title.length>0) {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [self.offerOverlay setPlaceDetails:photoponCouponModel.place.name];
    }*/
}

- (Photopon8CouponsModel *)photoponCouponModel {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return photoponCouponModel;
}

- (void)setPhotoponCouponModel:(Photopon8CouponsModel *)value {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    photoponCouponModel = value;
}


- (void)didReceiveMemoryWarning
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
