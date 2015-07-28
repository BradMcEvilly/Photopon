//
//  PhotoponRedeemViewController.h
//  Photopon
//
//  Created by Bradford McEvilly on 1/27/13.
//
//

#import <UIKit/UIKit.h>
#import "PhotoponNestedDetailViewController.h"

@class PhotoponUIButton;

@interface PhotoponRedeemViewController : UIViewController <UIWebViewDelegate, UINavigationControllerDelegate>
{
    
    IBOutlet UIView *redeemInfoView;
    IBOutlet UITextView *redeemInfoTextView;
    NSString *redeemInfoText;
    
    IBOutlet UIView *redeemOtherInfoView;
    IBOutlet UITextView *redeemOtherInfoTextView;
    NSString *redeemOtherInfoText;
    
    IBOutlet UIWebView *redeemWebView;
    NSString *redeemWebURLString;
    IBOutlet UILabel *remoteStatusLabel;
    NSString *remoteStatusText;
    
    IBOutlet PhotoponUIButton *photoponBtnRedeemWebsite;
    IBOutlet PhotoponUIButton *photoponBtnRedeemDirections;
    
    PhotoponCouponModel *photoponCouponModel;
    
}

@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnRedeemWebsite;
@property (nonatomic, strong) IBOutlet PhotoponUIButton *photoponBtnRedeemDirections;

@property (nonatomic, strong) PhotoponCouponModel *photoponCouponModel;

@property (nonatomic, strong) IBOutlet UIView *redeemInfoView;
@property (nonatomic, strong) IBOutlet UITextView *redeemInfoTextView;
@property (nonatomic, strong) NSString *redeemInfoText;

@property (nonatomic, strong) IBOutlet UIView *redeemOtherInfoView;
@property (nonatomic, strong) IBOutlet UITextView *redeemOtherInfoTextView;
@property (nonatomic, strong) NSString *redeemOtherInfoText;

@property (nonatomic, strong) IBOutlet UIWebView *redeemWebView;
@property (nonatomic, strong) NSString *redeemWebURLString;
@property (nonatomic, strong) IBOutlet UILabel *remoteStatusLabel;
@property (nonatomic, strong) NSString *remoteStatusText;

-(id)initWithCouponModel:(PhotoponCouponModel*)couponModel;

-(void)loadRedeemURL:(NSString*)redeemURLString;

-(IBAction)photoponBtnRedeemWebsiteHandler:(id)sender;
-(IBAction)photoponBtnRedeemDirectionsHandler:(id)sender;


@end
