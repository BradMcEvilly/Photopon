//
//  PhotoponWebViewController.m
//  Photopon
//
//  Created by Bradford McEvilly on 2/5/13.
//
//

#import "PhotoponWebViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "PhotoponAppDelegate.h"
#import "XMLSignupViewController.h"
#import "PhotoponLogInViewController.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponNavigationBar.h"

@interface PhotoponWebViewController ()

@end

@implementation PhotoponWebViewController

@synthesize photoponWebView;
@synthesize photoponWebURLString;
@synthesize remoteStatusLabel;
@synthesize remoteStatusText;
@synthesize photoponNavigationBar;
@synthesize buttonBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    photoponWebView.delegate = self;
    
    self.photoponWebView.scalesPageToFit = YES;
    
    
    UIImage *imageBack=[UIImage imageNamed:@"PhotoponNavBarBtnBack.png"];
    self.buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.bounds = CGRectMake( 0, 0, imageBack.size.width, imageBack.size.height );
    [buttonBack setBackgroundImage:imageBack forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backHandler:) forControlEvents:UIControlEventTouchUpInside];
    backBarButton = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    
    
    
}

-(void)loadPhotoponURL:(NSString*)photoponURLString{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    [photoponWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:photoponURLString]]];
    
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
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backHandler:(id)sender
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[appDelegate.photoponSplashScreenViewController.photoponXMLSignupViewController removeWebViewController];
    
    //[self.view removeFromSuperview];
    
    
}

@end
