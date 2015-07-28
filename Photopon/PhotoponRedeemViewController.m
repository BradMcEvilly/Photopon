//
//  PhotoponRedeemViewController.m
//  Photopon
//
//  Created by Bradford McEvilly on 1/27/13.
//
//

#import "PhotoponRedeemViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "PhotoponAppDelegate.h"
#import "PhotoponCouponModel.h"
#import "PhotoponMediaModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponUIWebViewController.h"

@interface PhotoponRedeemViewController ()

@end

@implementation PhotoponRedeemViewController

@synthesize redeemInfoView;
@synthesize redeemInfoText;
@synthesize redeemInfoTextView;

@synthesize redeemWebView;
@synthesize redeemWebURLString;
@synthesize remoteStatusLabel;
@synthesize remoteStatusText;

@synthesize redeemOtherInfoView;
@synthesize redeemOtherInfoTextView;
@synthesize redeemOtherInfoText;

@synthesize photoponBtnRedeemWebsite;
@synthesize photoponBtnRedeemDirections;

@synthesize photoponCouponModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}

-(id)initWithCouponModel:(PhotoponCouponModel *)couponModel{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithNibName:@"PhotoponRedeemViewController" bundle:nil];
    if (self) {
        
        self.photoponCouponModel = couponModel;
        
    }
    return self;
    
}

- (void)viewDidLoad
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationItem setTitle:@"Redeem"];
    
    redeemWebView.delegate = self;
    
    UIBarButtonItem *backBarButton;
    
    UIImage *imageBack=[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"];
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.bounds = CGRectMake( 0, 0, imageBack.size.width, imageBack.size.height );
    [buttonBack setBackgroundImage:imageBack forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backNavButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    backBarButton = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    //self.redeemInfoTextView.text = self.photoponCouponModel.terms;
    
    /*
    typedef enum {
        PhotoponCouponSourceTypeSocial,
        PhotoponCouponSourceTypePayPerSnip,
        PhotoponCouponSourceType8Coupons,
        PhotoponCouponSourceTypeCityGrid,
    } PhotoponCouponSourceType;
*/
    
    
    
    NSString *nullFieldString = [[NSString alloc] initWithFormat:@"%@", @"<null>"];
    if ( ([self.photoponCouponModel.couponURL isEqualToString:nullFieldString]) || ([self.photoponCouponModel.couponURL isEqualToString:@""]) || (self.photoponCouponModel.couponURL==nil)) {
        //
        
        [self.photoponBtnRedeemWebsite setEnabled:NO];
        
        
    }
    
    if ( ([self.photoponCouponModel.couponType isEqualToString:@"3"])){
        
        self.redeemInfoTextView.text = [NSString stringWithFormat:@"Must Mention CityGrid/CitySearch.  %@ - Phone: %@. Address: %@, %@, %@.", self.photoponCouponModel.place.name, self.photoponCouponModel.place.phone, self.photoponCouponModel.place.street, self.photoponCouponModel.place.city, self.photoponCouponModel.place.zip];
    }else{
        
        self.redeemInfoTextView.text = [NSString stringWithFormat:@"%@ - Phone: %@. Address: %@, %@ %@.", self.photoponCouponModel.place.name, self.photoponCouponModel.place.phone, self.photoponCouponModel.place.street, self.photoponCouponModel.place.city, self.photoponCouponModel.place.zip];
        
    }
    
    
    
    /*
    if ( ([self.photoponCouponModel.couponType isEqualToString:@""]) || (self.photoponCouponModel.couponType==nil)) {
        //
        
        self.redeemInfoTextView.text = @"Mention CitySearch";
    }
    
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    NSString *nullFieldString = [[[NSString alloc] initWithFormat:@"%@", @"0000-00-00 00:00:00"] autorelease];
    if ([self.photoponCouponModel.expirationString isEqualToString:nullFieldString]) {
        
        self.photoponCouponModel.expirationTextString = [[NSString alloc] initWithFormat:@"Expires: %@", @"Never"];
        
    }else{
        
        self.photoponCouponModel.expiration = [NSDate dateFromString:self.photoponCouponModel.expirationString withFormat:[NSDate dbFormatString]];
        
        self.photoponCouponModel.expirationTextString = [[NSString alloc] initWithFormat:@"Expires: %@", [NSDate stringFromDate:self.photoponCouponModel.expiration withFormat:@"MM/dd/yyyy"]];
        
    }*/

    
    
    
    
    
    self.redeemOtherInfoTextView.text = [NSString stringWithFormat:@"Terms:%@ %@ %@", self.photoponCouponModel.terms, self.photoponCouponModel.details, self.photoponCouponModel.expirationTextString];
    
    
    
}

- (void)backNavButtonHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)loadRedeemURL:(NSString*)redeemURLString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.redeemInfoView setAlpha:0.0f];
    [self.redeemInfoView setHidden:YES];
    [redeemWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:redeemURLString]]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.view addSubview:self.loadingImageView];
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.loadingImageView removeFromSuperview];
    [self.remoteStatusLabel setAlpha:0.0f];
    [self.remoteStatusLabel setHidden:YES];
    
}

-(IBAction)photoponBtnRedeemWebsiteHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.redeemInfoView setAlpha:0.0f];
    [self.redeemInfoView setHidden:YES];
    
    [redeemWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.photoponCouponModel.couponURL]]];
    
    [self.view addSubview:redeemWebView];
    
    
    
    
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //self.pComApi = [PhotoponComApi sharedApi];
    
    
    //PhotoponUIWebViewController *photoponUIWebViewController = [[PhotoponUIWebViewController alloc] initWithNibName:@"PhotoponUIWebViewController" bundle:nil];
    
    
    
    //[self.navigationController presentViewController:photoponUIWebViewController animated:YES completion:nil];
    
    
    //[appDelegate.photoponTabBarViewController showNestedDetailViewController:photoponUIWebViewController];
    
    
    
    
    
    
    /*
    PhotoponRedeemViewController *photoponRedeemViewController = [[[PhotoponRedeemViewController alloc] initWithCouponModel:self.photoponMediaModel.coupon] autorelease];
    
    //[self.navigationController presentViewController:photoponRedeemViewController animated:YES completion:nil];
    
    
    [appDelegate.photoponTabBarViewController showNestedDetailViewController:photoponRedeemViewController];
    */
    
    
    //[photoponUIWebViewController loadRedeemURL:self.photoponMediaModel.coupon.couponURL];
    
    
    
}

-(IBAction)photoponBtnRedeemDirectionsHandler:(id)sender{
    
    //
    
}








/*
(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"FeedCell";
    FeedDetailCell *cell = (FeedDetailCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = (FeedDetailCell*)[[[NSBundle mainBundle] loadNibNamed:@"FeedDetail" owner:nil options:nil] objectAtIndex:0];
    }
    [tableView setSeparatorColor:[UIColor grayColor]];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.nameLabel.text = @"Telephone";
                [cell.detailLabel setText:[_feedDictionary valueForKey:@"mobile"]];
            }
            else {
                cell.nameLabel.text = @"Mobile";
                [cell.detailLabel setText:[_feedDictionary valueForKey:@"iPhone"]];
            }
            break;
        case 1:
            cell.nameLabel.text = @"E-mail";
            [cell.detailLabel setText:[_feedDictionary valueForKey:@"Email"]];
            break;
        case 2:
            cell.nameLabel.text = @"address";
            [cell.detailLabel setText:[_feedDictionary valueForKey:@"address"]];
            CGSize size = [[_feedDictionary valueForKey:@"address"] sizeWithFont:[UIFont systemFontOfSize:14.0]
                                                               constrainedToSize:CGSizeMake(200.0, 400.0) lineBreakMode:UILineBreakModeWordWrap];
            CGRect frm = cell.detailLabel.frame;
            frm.size.height = size.height;
            [cell.detailLabel setFrame:frm];
        default:
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSString *address = [_feedDictionary valueForKey:@"address"];
        CGSize recommendedSize = [address sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, INT_MAX)];
        return 44 + recommendedSize.height;
    }
    else {
        return 44;
    }
}

*/



























/*
- (void)webView:(UIWebView *)sender didFinishLoadForFrame:(WebFrame*)frame{
    
    [self.remoteStatusLabel setAlpha:0.0f];
    [self.remoteStatusLabel setHidden:YES];
    
}


–(void) webView:didFinishLoadForFrame:
–(void) webView:didCommitLoadForFrame:
–(void) webView:willCloseFrame:
–(void) webView:didChangeLocationWithinPageForFrame:
//Data Received Messages
–(void) webView:didReceiveTitle:forFrame:
–(void) webView:didReceiveIcon:forFrame:
//Error Messages
–(void) webView:didFailProvisionalLoadWithError:forFrame:
–(void) webView:didFailLoadWithError:forFrame:
//Client and Server Redirect Messages
–(void) webView:didCancelClientRedirectForFrame:
–(void) webView:willPerformClientRedirectToURL:delay:fireDate:forFrame:
–(void) webView:didReceiveServerRedirectForProvisionalLoadForFrame:
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
