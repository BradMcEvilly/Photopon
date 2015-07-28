//
//  PhotoponWebViewController.h
//  Photopon
//
//  Created by Bradford McEvilly on 2/5/13.
//
//

#import "PhotoponNestedDetailViewController.h"

@class PhotoponNavigationBar;

@interface PhotoponWebViewController : PhotoponNestedDetailViewController <UIWebViewDelegate>
{
    
    IBOutlet UIWebView *photoponWebView;
    NSString *photoponWebURLString;
    IBOutlet UILabel *remoteStatusLabel;
    NSString *remoteStatusText;
    
    IBOutlet PhotoponNavigationBar *photoponNavigationBar;
    
    IBOutlet UIButton *buttonBack;
    
}

@property (nonatomic, strong) IBOutlet UIButton *buttonBack;

@property (nonatomic, strong) IBOutlet PhotoponNavigationBar *photoponNavigationBar;

@property (nonatomic, strong) IBOutlet UIWebView *photoponWebView;
@property (nonatomic, strong) NSString *photoponWebURLString;
@property (nonatomic, strong) IBOutlet UILabel *remoteStatusLabel;
@property (nonatomic, strong) NSString *remoteStatusText;


- (IBAction)backHandler:(id)sender;

-(void)loadPhotoponURL:(NSString*)photoponURLString;

@end
