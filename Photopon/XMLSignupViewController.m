//
//  XMLSignupViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/17/12.
//  Copyright 2012 Photopon. All rights reserved.
//

#import "XMLSignupViewController.h"
#import "UITableViewTextFieldCell.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponLogInViewController.h"
#import "SFHFKeychainUtils.h"
#import "PhotoponUserModel.h"
#import "WordPressXMLRPCApi.h"
#import "SFHFKeychainUtils.h"
#import "PhotoponApi.h"
#import "PhotoponComApi.h"
#import "UIImage+Resize.h"

#import "PhotoponWebViewController.h"
#import "PhotoponTabBarController.h"

#import "PhotoponUIButton+AFNetworking.h"

#import "UIDevice-Hardware.h"



#import "WPXMLRPCClient.h"
#import "UIView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <Foundation/Foundation.h>
#import "NSString+Helpers.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoponAppDelegate.h"
#import "UIInputToolbarViewController.h"
//#import "PhotoponShareViewController.h"
#import "AFHTTPClient.h"
#import "PhotoponConstants.h"
#import "PhotoponMediaModel.h"
#import "PhotoponImageModel.h"
#import "PhotoponCouponModel.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponTabBarController.h"
//#import "PhotoponNewPhotoponViewController.h"
//#import "PhotoponCouponsTableViewController.h"
//#import "PhotoponNewPhotoponHUDViewController.h"
//#import "PhotoponCouponsTableViewCellController.h"
//#import "PhotoponCouponsTableViewDataSource.h"
//#import "PhotoponNewPhotoponContainerViewController.h"
//#import "PhotoponCouponListTableVfffiewController.h"
#import "QuickPhotoUploadProgressController.h"
//#import "PhotoponPost.h"
//#import "QuickPicturePreviewView.h"
#import "UIInputToolbarViewController.h"
#import "NSMutableDictionary+Helpers.h"
//#import "PhotoponViewDeckViewController.h"
//#import "PhotoponProgressViewController.h"
#import "UIImage-Extensions.h"
//#import "PhotoponPopoverBackgroundView.h"
//#import "CPopoverManager.h"
//#import "PhotoponProgressViewController.h"
//#import "PhotoponPrePostOptionsViewController.h"
//#import "PhotoponNewCompositionSnapshotViewController.h"

#import "UIImageView+AFNetworking.h"

#import "PhotoponTableSectionFooterView.h"



@interface XMLSignupViewController(PrivateMethods)
- (void)backgroundTap:(id)sender;
- (void)scrollViewToCenter;
- (void)tosButtonPressed;
- (void)saveLoginData;
- (void)xmlrpcCreateAccount;
- (void)refreshTable;
@end


@implementation XMLSignupViewController{
    AFHTTPRequestOperation *_uploadOperation;
}




/*
 @synthesize profilePhoto;
 @synthesize back;
 @synthesize save;
 @synthesize firstNameTextField;
 @synthesize lastNameTextField;
 @synthesize emailTextField;
 @synthesize passwordTextField;
 //@synthesize scrollView;
 @synthesize formView;
 @synthesize titleLabel;
 
 @synthesize firstName;
 @synthesize lastName;
 @synthesize profilePhotoImage;
 @synthesize mediaPicker;
 @synthesize photoponMediaModel = photoponMediaModel_;
 @synthesize photoponImageModel = photoponImageModel_;
 @synthesize photoponCouponModel = photoponCouponModel_;
 @synthesize photoponNewImage;
 //@synthesize photoponPhotoView;
 @synthesize photoPicker;
 @synthesize geolocation, tags, postFormat, postFormatText;
 @synthesize categories;
 @synthesize hasPhotos;
 @synthesize hasVideos;
 @synthesize isShowingMediaPickerActionSheet;
 @synthesize isShowingCustomSizeAlert;
 @synthesize isShowingChangeOrientationActionSheet;
 @synthesize isAddingMedia;
 
 
 
 
 // duplicate synths
 @synthesize email;
 @synthesize password;
 @synthesize mediaID;
 @synthesize sourceType;
 @synthesize photo;
 @synthesize photoImageView;
 
 @synthesize mediaType;
 @synthesize mediaTypeName;
 @synthesize remoteURL;
 @synthesize localURL;
 @synthesize shortcode;
 @synthesize thumbnail;
 @synthesize filename;
 @synthesize filebase;
 @synthesize filesize;
 @synthesize orientation;
 @synthesize creationDate;
 @synthesize html;
 @synthesize remoteStatusNumber;
 @synthesize width;
 @synthesize height;
 @synthesize binData;
 @synthesize progress;
 @synthesize remoteStatus;
 @synthesize content;
 @synthesize postID;
 @synthesize currentImage;
 
 */

@synthesize hasPhotos;
@synthesize hasVideos;
@synthesize isShowingMediaPickerActionSheet;
@synthesize isShowingCustomSizeAlert;
@synthesize isShowingChangeOrientationActionSheet;
@synthesize isAddingMedia;


@synthesize currentImageMetadata;
@synthesize currentVideo;
@synthesize picker;

// upload related stuff



@synthesize mediaPicker;
@synthesize photoPicker;

@synthesize photoponTabBarViewController = photoponTabBarViewController_;

@synthesize media;



@synthesize specialType;

@synthesize footerView;



//@synthesize photoponNewPhotoponContainerViewController;
//@synthesize tableView;


@synthesize pickerContainer;







@synthesize buttonText, footerText, email, username, firstname, lastname, facebookid, birthday, sex, password, passwordconfirm;
@synthesize tableView;
@synthesize lastTextField;
@synthesize back;

@synthesize pComApi = _pComApi;

@synthesize photoponWebViewController;

@synthesize mediaID;
@synthesize photo;
@synthesize photoImageView;
@synthesize sourceType;
@synthesize binData;
@synthesize content;
@synthesize creationDate;
@synthesize filebase;
@synthesize filename;
@synthesize filesize;
@synthesize height;
@synthesize width;
@synthesize html;
@synthesize localURL;
@synthesize mediaType;
@synthesize mediaTypeName;
@synthesize orientation;
@synthesize postID;
@synthesize lastProgress;
@synthesize progress;
@synthesize remoteURL;
@synthesize remoteStatus;
@synthesize remoteStatusNumber;
@synthesize shortcode;
@synthesize title;
@synthesize thumbnail;



@synthesize photoponBtnProfilePhoto;
@synthesize photoponBtnProfilePhotoImage;

@synthesize currentImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)fadeInView
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:0.4];
    self.view.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)fadeOutView
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [UIView beginAnimations:@"fade out" context:nil];
    [UIView setAnimationDuration:0.4];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //username = [[NSString alloc] initWithFormat:@"TTTTHHHHHHHTHTHTHTTTTTT" ];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
        
    appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    
    [self setFooterText:@" "];
    
    
    
    // set up table header
    
    //self.photoponBtnProfilePhotoImage = appDelegate.profilePhotoImage;
    
    CGRect photoFrame = CGRectMake(10, 10, 70, 70);
    [photoponBtnProfilePhoto removeFromSuperview];
    photoponBtnProfilePhoto.frame = photoFrame;
    
    
    // Setup Pcom table header
	CGRect headerFrame = CGRectMake(0, 0, 320, 70);
	//CGRect logoFrame = CGRectMake(60, 10, 190, 64);
	//NSString *logoFile = @"PhotoponLogoStandard.png";
	if([[UIDevice currentDevice] platformString] == IPHONE_1G_NAMESTRING) {
        //	logoFile = @"PhotoponLogoStandard.png";
	}
    
	UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
	//UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoFile]];
	//logo.frame = logoFrame;
	[headerView addSubview:photoponBtnProfilePhoto];
	//[logo release];
	self.tableView.tableHeaderView = headerView;
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerButton setFrame:CGRectMake(0, 0, 320, 20)];
    [footerButton setTitle:NSLocalizedString(@"You agree to Photopon's terms of use \nby submitting this form.", @"") forState:UIControlStateNormal];
    [footerButton.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [footerButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [footerButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    /*
    CGFloat red = (CGFloat)(255.0 / 255.0);
    CGFloat green = (CGFloat)(255.0 / 255.0);
    CGFloat blue = (CGFloat)(255.0 / 255.0);
    
    [footerButton setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1] forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1] forState:UIControlStateHighlighted];
    [footerButton setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1] forState:UIControlStateSelected];
    */
    
    [footerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //[footerButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //[footerButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [footerButton addTarget:self action:@selector(tosButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
    
    
    
	if(IS_IPAD)
		self.tableView.backgroundView = nil;
	
	self.tableView.backgroundColor = [UIColor clearColor];
    
    
    
    
    
    // add gesture recognizer for background tap to remove keyboard to tableView
    // -- breaks submit button
    //    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    //    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidUnload
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setButtonText:nil];
    [self setFooterText:nil];
    [self setTableView:nil];
    [self setLastTextField:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (section) {
        case 0:
            // blog name, username, password, confirm and email entry
            return 5;
            break;
        case 1:
            // submit button
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

/*
 -(id)initWithFBProfileData{
 
 //    photoponXMLSignupViewController = [[[XMLSignupViewController alloc] initWithNibName:@"XMLSignupViewController" bundle:nil] retain];
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
 
 self = [self initWithNibName:@"XMLSignupViewController" bundle:nil];
 if (self) {
 
 // Custom initialization
 
 self.username = appDelegate.username;
 
 self.firstname = appDelegate.profileFirstName;
 
 self.lastname = appDelegate.profileLastName;
 
 self.email = appDelegate.profileEmail;
 
 self.facebookid = appDelegate.profileFacebookID;
 self.birthday = appDelegate.profileBirthdayDate;
 self.sex = appDelegate.profileSex;
 
 [self setPhoto:appDelegate.profilePhotoImage];
 
 if (photo != nil) {
 self.photoponBtnProfilePhotoImage = self.photo;
 }
 
 
 
 [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateNormal];
 [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateHighlighted];
 [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateSelected];
 
 
 
 /*
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppDel First Name:"
 message:appDelegate.profileFirstName
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 [alert show];
 [alert release];
 * /
 
 
 }
 return self;
 
 
 }*/

-(id)initWithFBProfileData{
    
    //    photoponXMLSignupViewController = [[[XMLSignupViewController alloc] initWithNibName:@"XMLSignupViewController" bundle:nil] retain];
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self = [self initWithNibName:@"XMLSignupViewController" bundle:nil];
    if (self) {
        
        // Custom initialization
        
        self.username = appDelegate.loginViewController.profileUsername;
        
        self.firstname = appDelegate.loginViewController.profileFirstName;
        
        self.lastname = appDelegate.loginViewController.profileLastName;
        
        self.email = appDelegate.loginViewController.profileEmail;
        
        self.facebookid = appDelegate.loginViewController.profileFacebookID;
        self.birthday = appDelegate.loginViewController.profileBirthdayDate;
        self.sex = appDelegate.loginViewController.profileSex;
        
        
        [self setPhoto:appDelegate.loginViewController.profilePhotoImage];
        
        if (photo != nil) {
            self.photoponBtnProfilePhotoImage = self.photo;
            [self saveImage];
        }
        
        
        /*
         [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateNormal];
         [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateHighlighted];
         [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateSelected];
         */
        
        
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppDel First Name:"
         message:appDelegate.profileFirstName
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
         otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
         [alert show];
         [alert release];
         */
        
        
    }
    return self;
    
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	UITableViewCell *cell = nil;
	
    
    
    if (indexPath.section == 0) {
        
        if ( self.photoponBtnProfilePhotoImage != nil)  {
            [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateNormal];
        }
        
        UITableViewTextFieldCell *creationCell = [[UITableViewTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                  reuseIdentifier:@"TextCell"];
        
        if ([indexPath row] == 0) {
            
            if ( (self.firstname != nil) || !([self.firstname isEqualToString:@""]) ) {
                [creationCell.textField setText:self.firstname];
            }else {
                // if no data, use placeholder
                creationCell.textField.placeholder = NSLocalizedString(@"Your first name", @"");
            }
            
            creationCell.textLabel.text = NSLocalizedString(@"First Name", @"");
            creationCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            creationCell.textField.returnKeyType = UIReturnKeyNext;
            creationCell.textField.tag = 0;
            creationCell.textField.delegate = self;
            
            if(firstname != nil)
                creationCell.textField.text = firstname;
        } else if ([indexPath row] == 1) {
            
            if ( !(self.lastname == nil) || !([self.lastname isEqualToString:@""]) ) {
                [creationCell.textField setText:self.lastname];
            }else {
                // if no data, use placeholder
                creationCell.textField.placeholder = NSLocalizedString(@"Your last name", @"");
            }
            creationCell.textLabel.text = NSLocalizedString(@"Last Name", @"");
            creationCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            creationCell.textField.returnKeyType = UIReturnKeyNext;
            creationCell.textField.tag = 1;
            creationCell.textField.delegate = self;
            
            if(lastname != nil)
                creationCell.textField.text = lastname;
        } else if ([indexPath row] == 2) {
            creationCell.textLabel.text = NSLocalizedString(@"Password", @"");
            creationCell.textField.placeholder = NSLocalizedString(@"Photopon.com password", @"");
            creationCell.textField.keyboardType = UIKeyboardTypeDefault;
            creationCell.textField.returnKeyType = UIReturnKeyNext;
            creationCell.textField.secureTextEntry = YES;
            creationCell.textField.tag = 2;
            creationCell.textField.delegate = self;
            
            if(password != nil)
                creationCell.textField.text = password;
        } else if ([indexPath row] == 3) {
            creationCell.textLabel.text = NSLocalizedString(@"Confirm", @"");
            creationCell.textField.placeholder = NSLocalizedString(@"Confirm", @"");
            creationCell.textField.keyboardType = UIKeyboardTypeDefault;
            creationCell.textField.returnKeyType = UIReturnKeyNext;
            creationCell.textField.secureTextEntry = YES;
            creationCell.textField.tag = 3;
            creationCell.textField.delegate = self;
            
            if(passwordconfirm != nil)
                creationCell.textField.text = passwordconfirm;
        } else if ([indexPath row] == 4) {
            if (self.email) {
                [creationCell.textField setText:self.email];
            }else {
                // if no data, use placeholder
                creationCell.textField.placeholder = NSLocalizedString(@"E-mail address", @"");
                
            }
            creationCell.textLabel.text = NSLocalizedString(@"E-mail", @"");
            creationCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            creationCell.textField.returnKeyType = UIReturnKeyDone;
            creationCell.textField.tag = 4;
            creationCell.textField.delegate = self;
            
            if(email != nil)
                creationCell.textField.text = email;
        }
        
        creationCell.textField.delegate = self;
        cell = creationCell;
    } else if (indexPath.section == 1) {
        UITableViewActivityCell *activityCell = nil;
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UITableViewActivityCell" owner:nil options:nil];
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[UITableViewActivityCell class]])
			{
				activityCell = (UITableViewActivityCell *)currentObject;
				break;
			}
		}
        
        self.buttonText = NSLocalizedString(@"Create Photopon.com Account", @"");
        
		activityCell.textLabel.text = buttonText;
		cell = activityCell;
	}
    
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if(section == 0) {
        
		return footerText;
        
    } else {
		return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (section == 1) {
        return 0.0f;
    }
    
    return 20.0f;
}
/*
 - (UIView *) footerView {
 
 if(footerView)
 return footerView;
 
 float w = [[self view] bounds].size.width;
 
 // height irrelevant as long as non zero custom view will resize
 CGRect footerFrame = CGRectMake(0, 0, w, 32);
 
 footerView = [[PhotoponTableSectionFooterView alloc] initWithFrame:footerFrame];
 
 [footerView setFooterTitle:footerText];
 
 return footerView;
 
 }
 
 
 - (UIView *) tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)sec {
 return [self footerView];
 }
 */


- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0){
        
        CGRect footerFrame = [tv rectForFooterInSection:1];
        CGRect labelFrame = CGRectMake(20, 25, footerFrame.size.width - 40, footerFrame.size.height - 40);
        
        UIView *footer = [[UIView alloc] initWithFrame:footerFrame];
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [footer setBackgroundColor:[UIColor clearColor]];
        [footerLabel setBackgroundColor:[UIColor clearColor]];
        
        [footerLabel setTextColor:[UIColor redColor]];
        
        [footerLabel setText:footerText];
        
        [footer addSubview:footerLabel];
        
        return footer;
    }
    
    return nil;
}


#pragma mark -
#pragma mark Table view delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [textField resignFirstResponder];
    
    UITableViewCell *cell = nil;
    UITextField *nextField = nil;
    
    if (textField.tag == 4) {
        // do something here
        
    } else {
        switch (textField.tag) {
            case 0:
                cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                break;
            case 1:
                cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                break;
            case 2:
                cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                break;
            case 3:
                cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                break;
        }
        
        [textField endEditing:YES];
        
        if(cell != nil) {
            nextField = (UITextField*)[cell viewWithTag:textField.tag+1];
            
            if(nextField != nil) {
                [nextField becomeFirstResponder];
            }
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setLastTextField:textField];
    
    [self scrollViewToCenter];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UITableViewCell *cell = (UITableViewCell *)[textField superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
    //[textField setTextColor:[UIColor whiteColor]];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if((textField.text != nil) && ([textField.text isEqualToString:@""])) {
                    [self setFooterText:NSLocalizedString(@"First name is required.", @"")];
                } else {
                    [self setFirstname:textField.text];
                }
                break;
            case 1:
                if((textField.text != nil) && ([textField.text isEqualToString:@""])) {
                    [self setFooterText:NSLocalizedString(@"Last is required.", @"")];
                } else {
                    [self setLastname:textField.text];
                }
                break;
            case 2:
                if((textField.text != nil) && ([textField.text isEqualToString:@""])) {
                    [self setFooterText:NSLocalizedString(@"Password is required.", @"")];
                } else {
                    [self setPassword:textField.text];
                }
                break;
            case 3:
                if((textField.text != nil) && ([textField.text isEqualToString:@""]) && !([textField.text isEqualToString:self.password])) {
                    [self setFooterText:NSLocalizedString(@"Passwords must match.", @"")];
                } else {
                    [self setPasswordconfirm:textField.text];
                }
                break;
            case 4:
                if((textField.text != nil) && ([textField.text isEqualToString:@""])) {
                    [self setFooterText:NSLocalizedString(@"E-mail is required.", @"")];
                } else {
                    [self setEmail:textField.text];
                }
                break;
            default:
                break;
        }
    }
	
	[textField resignFirstResponder];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        if (self.photo == nil) {
            [self setFooterText:NSLocalizedString(@"Profile photo is required.", @"")];
            [self setButtonText:NSLocalizedString(@"Create Photopon.com Account", @"")];
            [tv reloadData];
            return;
        } else if (firstname == nil) {
            [self setFooterText:NSLocalizedString(@"First name is required.", @"")];
            [self setButtonText:NSLocalizedString(@"Create Photopon.com Account", @"")];
            [tv reloadData];
            return;
        } else if (lastname == nil) {
            [self setFooterText:NSLocalizedString(@"Last name is required.", @"")];
            [self setButtonText:NSLocalizedString(@"Create Photopon.com Account", @"")];
            [tv reloadData];
            return;
        } else if (password == nil) {
            [self setFooterText:NSLocalizedString(@"Password is required.", @"")];
            [self setButtonText:NSLocalizedString(@"Create Photopon.com Account", @"")];
            [tv reloadData];
            return;
        } else if (!([password isEqualToString:passwordconfirm])) {
            [self setFooterText:NSLocalizedString(@"Passwords must match.", @"")];
            [self setButtonText:NSLocalizedString(@"Create Photopon.com Account", @"")];
            [tv reloadData];
            return;
        } else if (email == nil) {
            [self setFooterText:NSLocalizedString(@"E-mail is required.", @"")];
            [self setButtonText:NSLocalizedString(@"Create Photopon.com Account", @"")];
            [tv reloadData];
            return;
        } else {
            [self setButtonText:NSLocalizedString(@"Creating Account...", @"")];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
                
                self.username = [[NSString alloc] initWithFormat:@"%@", email ];
                
                [self xmlrpcCreateAccount];
                
            });
            
            //[self performSelectorInBackground:@selector(xmlrpcCreateAccount) withObject:self];
            
            //[NSThread sleepForTimeInterval:0.15];
            
            //[tv reloadData];
        }
    }
}

#pragma mark -
#pragma mark Custom Methods

- (void)backgroundTap:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Handle for background tap to remove keyboard from screen
    [self.lastTextField resignFirstResponder];
}

- (void)scrollViewToCenter
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Scroll fields behind keyboard so the user can see them
    if(IS_IPAD == NO) {
        CGPoint textFieldOrigin = [self.lastTextField convertPoint:self.lastTextField.frame.origin toView:self.view];
        CGFloat scrollPoint = self.view.frame.size.height / 2 - self.lastTextField.frame.size.height;
        
        if (textFieldOrigin.y > scrollPoint) {
            CGFloat scrollDistance = textFieldOrigin.y - scrollPoint/2;
            [self.tableView setContentOffset:CGPointMake(0.0f, scrollDistance) animated:YES];
        }
    }
}

- (void) tosButtonPressed {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     // Push ToS to new webview
     WPWebViewController *tosView;
     if (IS_IPAD) {
     tosView = [[WPWebViewController alloc] initWithNibName:@"WPWebViewController-iPad" bundle:nil];
     }
     else {
     
     tosView = [[WPWebViewController alloc] initWithNibName:@"WPWebViewController" bundle:nil];
     }
     
     [tosView setUrl:[NSURL URLWithString:@"http://www.placepon.com/tos.html"]];
     [tosView view];
     [self.navigationController pushViewController:tosView animated:YES];
     [tosView release];
     */
    
    
    
    self.photoponWebViewController = [[PhotoponWebViewController alloc] initWithNibName:@"PhotoponWebViewController" bundle:nil];
    
    
    
    //[self.navigationController presentViewController:photoponRedeemViewController animated:YES completion:nil];
    
    //[photoponWebViewController.backBarButton removeTarget:nil action:@selector(backNavButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    //[photoponWebViewController.backBarButton addTarget:self action:@selector(removeWebViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationController pushViewController:self.photoponWebViewController animated:YES];
    
    NSString *tosString = [[NSString alloc] initWithFormat:@"%@", kPhotoponLegalURLTerms];
    
    [self.photoponWebViewController loadPhotoponURL:tosString];
    
    
    
    
}

- (void)saveLoginData {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSError *error = nil;
    //FIXME
    /*    [SFHFKeychainUtils storeUsername:username
     andPassword:password
     forServiceName:@"Photopon.com"
     updateExisting:YES
     error:&error];
     */
    
    
    
    
    /*
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authentication Success!", @"")
     message:@"You are logged in!"
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     alertView.tag = 20;
     [alertView show];
     [alertView release];
     */
    
    
    
    [SFHFKeychainUtils storeUsername:self.username andPassword:self.password forServiceName:@"Photopon.com" updateExisting:YES error:&error];
    if (error) {
        NSLog(@"Error storing pcom credentials: %@", [error localizedDescription]);
    }
    
    if(![self.username isEqualToString:@""])
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"pcom_username_preference"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pcom_authenticated_flag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [PhotoponAppDelegate sharedPhotoponApplicationDelegate].isPcomAuthenticated = YES;
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] registerForPushNotifications];
        //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponComApiDidLoginNotification object:self.username];
        //if (success) success();
    }
    
}

-(void)prePopulateFieldsWithDictionary:(NSDictionary *)prePopulateDict{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
}
/*
 - (void)xmlrpcCreateAccount {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 // then to display during output, we'll copy and paste the following line:
 // NSArray *numbers = [[firstSplit objectAtIndex:0] componentsSepratedByString:@","];
 
 self.pComApi = [PhotoponComApi sharedApi];
 
 
 
 [self.pComApi photoponRegisterUserWithInfo:[NSArray arrayWithObjects:username, password, [NSArray arrayWithObjects: email, firstname, lastname, facebookid, sex, birthday,  nil], nil] withSuccess:^(NSArray *responseInfo) {
 
 
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"if (self.photo!=nil) {       ");
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDidUploadSuccessfully:) name:ImageUploadSuccessful object:self];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaUploadFailed:) name:ImageUploadFailed object:self];
 appDelegate.isUploadingPost = YES;
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusProcessing;
 
 [self uploadMediaWithSuccess:^(NSArray *responseInfo){
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"[self uploadMediaWithSuccess:^(NSArray *responseInfo){       ");
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
 message:NSLocalizedString(@"Success!", @"")
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"OK", @"")
 otherButtonTitles:nil];
 [alert show];
 [alert release];
 
 self.photo = nil;
 
 // clear cache each time
 SDImageCache *imageCache = [SDImageCache sharedImageCache];
 [imageCache clearMemory];
 [imageCache clearDisk];
 [imageCache cleanDisk];
 
 }failure:^(NSError *error){
 
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"[self uploadMediaWithSuccess:        FAIL FAIL FAIL ){");
 NSLog(@"DESCRIPTION:   %@", [error description]);
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
 message:[error description]
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"OK", @"")
 otherButtonTitles:nil];
 [alert show];
 [alert release];
 
 self.photo = nil;
 
 }];
 
 
 
 
 
 
 
 /*
 
 NSDictionary *returnData = (NSDictionary*)[responseObject retain];
 
 PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
 
 PhotoponUserModel *photoponUserModel = [[[PhotoponUserModel alloc] init]retain];
 
 //NSDictionary *imgs = (NSDictionary *)[responseObject objectForKey:@"images"];
 
 photoponUserModel.identifier = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"identifier"]] retain];
 / *
 photoponUserModel.fullname = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"fullname"]] retain];
 photoponUserModel.username = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"username"]] retain];
 photoponUserModel.firstName = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"firstName"]] retain];
 photoponUserModel.lastName = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"lastName"]] retain];
 * /
 
 
 photoponUserModel.fullname = (NSString*)[returnData objectForKey:@"fullname"];
 photoponUserModel.username = (NSString*)[returnData objectForKey:@"username"];
 photoponUserModel.firstName = (NSString*)[returnData objectForKey:@"firstName"];
 photoponUserModel.lastName = (NSString*)[returnData objectForKey:@"lastName"];
 photoponUserModel.bio = (NSString*)[returnData objectForKey:@"bio"];
 photoponUserModel.website = (NSString*)[returnData objectForKey:@"website"];
 photoponUserModel.profilePictureUrl = (NSString*)[returnData objectForKey:@"profilePictureUrl"];
 photoponUserModel.profileCoverPictureUrl = (NSString*)[returnData objectForKey:@"profileCoverPictureUrl"];
 photoponUserModel.followedByCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followedByCount"]];
 photoponUserModel.followersCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followersCount"]];
 photoponUserModel.redeemCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"redeemCount"]];
 photoponUserModel.mediaCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"mediaCount"]];
 photoponUserModel.score = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"score"]];
 photoponUserModel.didFollow = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"didFollow"]];
 
 photoponUserModel.mediaCountString = (NSString*)[returnData objectForKey:@"mediaCountString"];
 photoponUserModel.followersCountString = (NSString*)[returnData objectForKey:@"followersCountString"];
 photoponUserModel.followedByCountString = (NSString*)[returnData objectForKey:@"followedByCountString"];
 photoponUserModel.redeemCountString = (NSString*)[returnData objectForKey:@"redeemCountString"];
 photoponUserModel.scoreString = (NSString*)[returnData objectForKey:@"scoreString"];
 photoponUserModel.didFollowString = (NSString*)[returnData objectForKey:@"didFollowString"];
 
 [appDelegate setPhotoponUserModel:photoponUserModel];
 
 
 
 
 [self saveLoginData];
 
 // You're now ready to pull money out of thin air and make your first photopon. Have fun!
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome to Photopon!", @"")
 message:NSLocalizedString(@"You're officially among the first to discover the next-generation coupon!", @"")
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 
 alert.tag = 10;
 [alert autorelease];
 [alert show];
 
 
 
 [appDelegate carryOnThen];
 
 
 
 
 / *
 'mediaCountString' => $mediaCountString,
 'followersCountString' => $followersCountString,
 'followedByCountString' => $followedByCountString,
 'redeemCountString' => $redeemCountString,
 'scoreString' => $scoreString,
 'didFollowString' => $didFollowString,
 
 @synthesize followedByCountString;
 @synthesize followersCountString;
 @synthesize redeemCountString;
 @synthesize mediaCountString;
 @synthesize scoreString;
 @synthesize didFollowString;
 */


















//NSString *status = [[NSString alloc] init];
//status = @"";

/*
 NSDictionary *returnData = [responseObject retain];
 
 PhotoponAppDelegate *delegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
 
 PhotoponUserModel *photoponUserModel = [[PhotoponUserModel alloc] init ];
 
 
 //NSDictionary *imgs = (NSDictionary *)[responseObject objectForKey:@"images"];
 
 photoponUserModel.identifier = [returnData objectForKey:@"identifier"];
 photoponUserModel.fullname = [returnData objectForKey:@"fullname"];
 photoponUserModel.username = [returnData objectForKey:@"username"];
 photoponUserModel.firstName = [returnData objectForKey:@"firstName"];
 photoponUserModel.lastName = [returnData objectForKey:@"lastName"];
 photoponUserModel.bio = [returnData objectForKey:@"bio"];
 photoponUserModel.website = [returnData objectForKey:@"website"];
 photoponUserModel.profilePictureUrl = [returnData objectForKey:@"profilePictureUrl"];
 photoponUserModel.profileCoverPictureUrl = [returnData objectForKey:@"profileCoverPictureUrl"];
 photoponUserModel.followedByCount = [returnData objectForKey:@"followedByCount"];
 photoponUserModel.followersCount = [returnData objectForKey:@"followersCount"];
 photoponUserModel.redeemCount = [returnData objectForKey:@"redeemCount"];
 photoponUserModel.mediaCount = [returnData objectForKey:@"mediaCount"];
 
 [delegate setPhotoponUserModel:photoponUserModel];
 
 [photoponUserModel release];
 
 
 / *
 NSArray *errors = [NSArray arrayWithObjects:@"field_1", @"password", @"field_5", @"field_6", @"field_7", nil];
 for (id e in errors) {
 if ([returnData valueForKey:e])
 status = [returnData valueForKey:e];
 }
 
 if ([status isEqualToString:@""])
 status = @"Success";
 
 if (status != @"Success") {
 [self setFooterText:@"Error"];
 [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
 } else {* /
 
 
 
 
 
 
 
 
 
 
 
 
 
 //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
 //}
 
 NSLog(@"--------->");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
 NSLog(@"CREATE ACCOUNT SUCCESS!!!");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"--------->");
 
 
 //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
 
 //[appDelegate.photoponSplashScreenViewController dismissViewControllerAnimated:YES completion:nil];
 
 //[appDelegate.navigationController popViewControllerAnimated:YES];
 
 
 //[appDelegate carryOnThen];
 
 //[appDelegate showLoggedIn];
 
 
 
 } failure:^(NSError *error) {
 
 WPFLog(@"Failed registering account: %@", [error localizedDescription]);
 [self setFooterText:[error localizedDescription]];
 [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
 
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Registration failed!", @"")
 message:[error localizedDescription]
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
 
 
 NSLog(@"--------->");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
 NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"--------->");
 
 [self setFooterText:@"FAILED AGAIN!"];
 
 
 }];
 
 //[pool release];
 }
 
 */









- (void)xmlrpcCreateAccount {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     
     NSDictionary *pComRequestArray = [NSDictionary dictionaryWithObjectsAndKeys:
     mimeType, @"type",
     self.filename, @"filename",
     tmpName, @"tmp_name",
     self.filesize, @"size",
     [NSNumber numberWithInteger:0], @"error",
     [NSInputStream inputStreamWithFileAtPath:self.localURL], @"bits",
     self.photoponMediaModel.caption, @"title",
     self.photoponCouponModel.details, @"details",
     self.photoponCouponModel.terms, @"terms",
     self.photoponCouponModel.instructions, @"instructions",
     self.photoponCouponModel.startString, @"start",
     self.photoponCouponModel.expirationString, @"expiration",
     self.photoponCouponModel.couponType, @"coupon_type",
     self.photoponCouponModel.couponURL, @"coupon_url",
     self.photoponMediaModel.value, @"mvalue",
     nil];
     
     NSDictionary *pComRequestArray2 = [NSDictionary dictionaryWithObjectsAndKeys:
     self.photoponCouponModel.place.publicID, @"public_id",
     self.photoponCouponModel.place.name, @"name",
     self.photoponCouponModel.place.street, @"street",
     self.photoponCouponModel.place.city, @"city",
     self.photoponCouponModel.place.zip, @"zip",
     self.photoponCouponModel.place.phone, @"phone",
     self.photoponCouponModel.place.publicID, @"public_id",
     self.photoponCouponModel.place.category, @"category",
     self.photoponCouponModel.place.imageUrl, @"imageUrl",
     self.photoponCouponModel.place.bio, @"bio",
     self.photoponCouponModel.place.locationIdentifier, @"locationIdentifier",
     self.photoponCouponModel.place.locationLatitude, @"locationLatitude",
     self.photoponCouponModel.place.locationLongitude, @"locationLongitude",
     self.photoponCouponModel.place.rating, @"rating",
     self.photoponCouponModel.place.url, @"url",
     nil];
     
     //photoponMediaModel_, @"place",
     //nil];
     
     //[self setRemoteStatus:PhotoponGalleryMediaRemoteStatusProcessing];
     NSMutableArray *parameters = [[[NSMutableArray alloc] initWithArray:[appDelegate getXMLRPCArgsWithExtra:pComRequestArray]] retain];
     [parameters addObject:pComRequestArray2];
     
     AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
     
     //_photoponUploadProgressQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
     //
     NSMutableURLRequest *request = [api requestWithMethod:@"bp.uploadPhotopon" parameters:parameters];
     
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     //
     
     AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     //[self hideUploadProgress];
     NSDictionary *response = (NSDictionary *)responseObject;
     [_uploadOperation release]; _uploadOperation = nil;
     
     */
    
    
    
    
    
    
    
    // then to display during output, we'll copy and paste the following line:
    // NSArray *numbers = [[firstSplit objectAtIndex:0] componentsSepratedByString:@","];
    
    self.pComApi = [PhotoponComApi sharedApi];
    
    //NSString *buttonText, *footerText, *email, *username, *firstname, *lastname, *facebookid, *birthday, *sex, *password, *passwordconfirm;
    
    // ------------------------------------------------- //
    // validate objects
    // ------------------------------------------------- //
    if (!facebookid) {
        facebookid = [[NSString alloc] initWithFormat:@"%@", @""];
    }
    if (!sex) {
        sex = [[NSString alloc] initWithFormat:@"%@", @""];
    }
    if (!birthday) {
        birthday = [[NSString alloc] initWithFormat:@"%@", @""];
    }
    
    
    
    
    NSArray *paramSignupCredentialsArray = [[NSArray alloc] initWithObjects:self.username, self.password, nil];//, [NSArray arrayWithObjects: email, firstname, lastname, facebookid, sex, birthday];
    NSArray *paramSignupAdditionalArray = [[NSArray alloc] initWithObjects:self.email, self.firstname, self.lastname, self.facebookid, self.sex, self.birthday, nil];
    
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithArray:paramSignupCredentialsArray];
    
    [parameters addObject:paramSignupAdditionalArray];
    
    NSArray *parametersFinal = [[NSArray alloc] initWithArray:parameters];
    
    
    
    [self.pComApi photoponRegisterUserWithInfo: parametersFinal withSuccess:^(NSArray *responseInfo) {
        
        //[SFHFKeychainUtils storeUsername:self.username andPassword:self.password forServiceName:@"Photopon.com" updateExisting:YES error:&error];
        //[self saveLoginData];
        
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"if (self.photo!=nil) {       ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDidUploadSuccessfully:) name:ImageUploadSuccessful object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaUploadFailed:) name:ImageUploadFailed object:self];
        appDelegate.isUploadingPost = YES;
        self.remoteStatus = PhotoponModelRemoteStatusProcessing;
        
        
        
        
        
        
        
        [self uploadMediaWithSuccess:^{
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"[self uploadMediaWithSuccess:^{");
            NSLog(@"");
            NSLog(@"------------>   SUCCESS SUCCESS SUCCESS ");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            /*
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
             message:NSLocalizedString(@"Success!", @"")
             delegate:self
             cancelButtonTitle:NSLocalizedString(@"OK", @"")
             otherButtonTitles:nil];
             [alert show];
             [alert release];
             */
        }
        failure:^(NSError *error) {
                                 
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"[self uploadMediaWithSuccess:^{");
             NSLog(@"");
             NSLog(@"------------>   FAILURE FAILURE FAILURE ");
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
             
             /*
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
              message:[error description]
              delegate:self
              cancelButtonTitle:NSLocalizedString(@"OK", @"")
              otherButtonTitles:nil];
              [alert show];
              [alert release];
              */
         }];
        
        
        
        
        
        
        
        
        /*
         [self uploadMediaWithSuccess:^(NSArray *responseInfo){
         
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         NSLog(@"[self uploadMediaWithSuccess:^(NSArray *responseInfo){       ");
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
         message:NSLocalizedString(@"Success!", @"")
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"OK", @"")
         otherButtonTitles:nil];
         [alert show];
         [alert release];
         
         self.photo = nil;
         
         // clear cache each time
         SDImageCache *imageCache = [SDImageCache sharedImageCache];
         [imageCache clearMemory];
         [imageCache clearDisk];
         [imageCache cleanDisk];
         
         }failure:^(NSError *error){
         
         [parametersFinal release];
         
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         NSLog(@"[self uploadMediaWithSuccess:        FAIL FAIL FAIL ){");
         NSLog(@"DESCRIPTION:   %@", [error description]);
         NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
         message:[error description]
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"OK", @"")
         otherButtonTitles:nil];
         [alert show];
         [alert release];
         
         self.photo = nil;
         
         }];
         
         */
        
        
        
        
        
        /*
         
         NSDictionary *returnData = (NSDictionary*)[responseObject retain];
         
         PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
         
         PhotoponUserModel *photoponUserModel = [[[PhotoponUserModel alloc] init]retain];
         
         //NSDictionary *imgs = (NSDictionary *)[responseObject objectForKey:@"images"];
         
         photoponUserModel.identifier = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"identifier"]] retain];
         / *
         photoponUserModel.fullname = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"fullname"]] retain];
         photoponUserModel.username = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"username"]] retain];
         photoponUserModel.firstName = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"firstName"]] retain];
         photoponUserModel.lastName = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[returnData objectForKey:@"lastName"]] retain];
         * /
         
         
         photoponUserModel.fullname = (NSString*)[returnData objectForKey:@"fullname"];
         photoponUserModel.username = (NSString*)[returnData objectForKey:@"username"];
         photoponUserModel.firstName = (NSString*)[returnData objectForKey:@"firstName"];
         photoponUserModel.lastName = (NSString*)[returnData objectForKey:@"lastName"];
         photoponUserModel.bio = (NSString*)[returnData objectForKey:@"bio"];
         photoponUserModel.website = (NSString*)[returnData objectForKey:@"website"];
         photoponUserModel.profilePictureUrl = (NSString*)[returnData objectForKey:@"profilePictureUrl"];
         photoponUserModel.profileCoverPictureUrl = (NSString*)[returnData objectForKey:@"profileCoverPictureUrl"];
         photoponUserModel.followedByCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followedByCount"]];
         photoponUserModel.followersCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"followersCount"]];
         photoponUserModel.redeemCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"redeemCount"]];
         photoponUserModel.mediaCount = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"mediaCount"]];
         photoponUserModel.score = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"score"]];
         photoponUserModel.didFollow = [NSNumber numberWithInt:(NSInteger)[returnData objectForKey:@"didFollow"]];
         
         photoponUserModel.mediaCountString = (NSString*)[returnData objectForKey:@"mediaCountString"];
         photoponUserModel.followersCountString = (NSString*)[returnData objectForKey:@"followersCountString"];
         photoponUserModel.followedByCountString = (NSString*)[returnData objectForKey:@"followedByCountString"];
         photoponUserModel.redeemCountString = (NSString*)[returnData objectForKey:@"redeemCountString"];
         photoponUserModel.scoreString = (NSString*)[returnData objectForKey:@"scoreString"];
         photoponUserModel.didFollowString = (NSString*)[returnData objectForKey:@"didFollowString"];
         
         [appDelegate setPhotoponUserModel:photoponUserModel];
         
         
         
         
         [self saveLoginData];
         
         // You're now ready to pull money out of thin air and make your first photopon. Have fun!
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome to Photopon!", @"")
         message:NSLocalizedString(@"You're officially among the first to discover the next-generation coupon!", @"")
         delegate:self
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         
         alert.tag = 10;
         [alert autorelease];
         [alert show];
         
         
         
         [appDelegate carryOnThen];
         
         
         
         
         / *
         'mediaCountString' => $mediaCountString,
         'followersCountString' => $followersCountString,
         'followedByCountString' => $followedByCountString,
         'redeemCountString' => $redeemCountString,
         'scoreString' => $scoreString,
         'didFollowString' => $didFollowString,
         
         @synthesize followedByCountString;
         @synthesize followersCountString;
         @synthesize redeemCountString;
         @synthesize mediaCountString;
         @synthesize scoreString;
         @synthesize didFollowString;
         */
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //NSString *status = [[NSString alloc] init];
        //status = @"";
        
        /*
         NSDictionary *returnData = [responseObject retain];
         
         PhotoponAppDelegate *delegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
         
         PhotoponUserModel *photoponUserModel = [[PhotoponUserModel alloc] init ];
         
         
         //NSDictionary *imgs = (NSDictionary *)[responseObject objectForKey:@"images"];
         
         photoponUserModel.identifier = [returnData objectForKey:@"identifier"];
         photoponUserModel.fullname = [returnData objectForKey:@"fullname"];
         photoponUserModel.username = [returnData objectForKey:@"username"];
         photoponUserModel.firstName = [returnData objectForKey:@"firstName"];
         photoponUserModel.lastName = [returnData objectForKey:@"lastName"];
         photoponUserModel.bio = [returnData objectForKey:@"bio"];
         photoponUserModel.website = [returnData objectForKey:@"website"];
         photoponUserModel.profilePictureUrl = [returnData objectForKey:@"profilePictureUrl"];
         photoponUserModel.profileCoverPictureUrl = [returnData objectForKey:@"profileCoverPictureUrl"];
         photoponUserModel.followedByCount = [returnData objectForKey:@"followedByCount"];
         photoponUserModel.followersCount = [returnData objectForKey:@"followersCount"];
         photoponUserModel.redeemCount = [returnData objectForKey:@"redeemCount"];
         photoponUserModel.mediaCount = [returnData objectForKey:@"mediaCount"];
         
         [delegate setPhotoponUserModel:photoponUserModel];
         
         [photoponUserModel release];
         
         
         / *
         NSArray *errors = [NSArray arrayWithObjects:@"field_1", @"password", @"field_5", @"field_6", @"field_7", nil];
         for (id e in errors) {
         if ([returnData valueForKey:e])
         status = [returnData valueForKey:e];
         }
         
         if ([status isEqualToString:@""])
         status = @"Success";
         
         if (status != @"Success") {
         [self setFooterText:@"Error"];
         [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
         } else {*/
        
        
        
        
        
        
        
        
        
        
        
        
        
        //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
        //}
        
        NSLog(@"--------->");
        NSLog(@"-------------------------------------------------------------");
        NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
        NSLog(@"CREATE ACCOUNT SUCCESS!!!");
        NSLog(@"-------------------------------------------------------------");
        NSLog(@"--------->");
        
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //[appDelegate.photoponSplashScreenViewController dismissViewControllerAnimated:YES completion:nil];
        
        //[appDelegate.navigationController popViewControllerAnimated:YES];
        
        
        //[appDelegate carryOnThen];
        
        //[appDelegate showLoggedIn];
        
        
        
    } failure:^(NSError *error) {
        
        [self setFooterText:[error localizedDescription]];
        [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
        
        [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Registration failed" message:[error description] cancelButtonTitle:nil otherButtonTitle:@"OK"];
        
        
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
        
        
        NSLog(@"--------->");
        NSLog(@"-------------------------------------------------------------");
        NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
        NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
        NSLog(@"-------------------------------------------------------------");
        NSLog(@"--------->");
        
        [self setFooterText:@"FAILED AGAIN!"];
        
        
    }];
    
    //[pool release];
}





























/*
 - (void)uploadMediaWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
 
 [FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
 
 //[self save];
 self.progress = 0.0f;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 / *
 
 
 NSAutoreleasePool *pool = [NSAutoreleasePool new];
 [self setFooterText:@"Creating Account..."];
 AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
 //[api callMethod:@"bp.updateProfileStatus"
 [api callMethod:@"bp.registerNewUser"
 parameters:[NSArray arrayWithObjects:username, password, [NSArray arrayWithObjects: email, firstname, lastname, nil], nil]
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 
 //NSString *status = [[NSString alloc] init];
 //status = @"";
 NSDictionary *returnData = [responseObject retain];
 
 
 / *
 NSArray *errors = [NSArray arrayWithObjects:@"field_1", @"password", @"field_5", @"field_6", @"field_7", nil];
 for (id e in errors) {
 if ([returnData valueForKey:e])
 status = [returnData valueForKey:e];
 }
 
 if ([status isEqualToString:@""])
 status = @"Success";
 
 if (status != @"Success") {
 [self setFooterText:@"Error"];
 [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
 } else {* /
 [self saveLoginData];
 
 // You're now ready to pull money out of thin air and make your first photopon. Have fun!
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Awesome!", @"")
 message:NSLocalizedString(@"You're officially among the first to discover the next-generation coupon!", @"")
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 
 alert.tag = 10;
 [alert autorelease];
 [alert show];
 [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
 //}
 
 NSLog(@"--------->");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
 NSLog(@"CREATE ACCOUNT SUCCESS!!!");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"--------->");
 
 [self setFooterText:@"Success! Welcome to Photopon!"];
 
 //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
 
 [appDelegate.photoponSplashScreenViewController dismissViewControllerAnimated:YES completion:nil];
 
 [appDelegate.navigationController popViewControllerAnimated:YES];
 
 //[appDelegate showLoggedIn];
 
 
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 WPFLog(@"Failed registering account: %@", [error localizedDescription]);
 [self setFooterText:[error localizedDescription]];
 [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Well, that failed miserably", @"")
 message:[error localizedDescription]
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
 
 
 NSLog(@"--------->");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
 NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"--------->");
 
 [self setFooterText:@"FAILED AGAIN! SORRY SUCKER!!"];
 
 
 }];
 
 [pool release];
 
 
 
 */























/*
 
 
 $photopon_username 			= $this->escape( $args[0] );
 $photopon_password 			= $this->escape( $args[1] );
 $photopon_meta	 				= $args[2];
 
 $link_thumb					= $photopon_meta['thumb'];
 $link_med 						= $photopon_meta['mid'];
 $link_large			 		= $photopon_meta['larger'];
 
 $photopon_headline				= $photopon_meta['headline'];
 $photopon_offer_info			= $photopon_meta['offer_info'];
 $photopon_media_type			= $photopon_meta['media_type'];
 
 $file['file']					= $photopon_meta['file'];
 
 $file['name'] 					= $file['file']['name'];
 $file['type'] 					= $file['file']['type'];
 $file['tmp_name'] 				= $file['file']['tmp_name'];
 $file['error'] 				= $file['file']['error'];
 $file['size'] 					= $file['file']['size'];
 * /
 
 
 
 
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
 
 NSString *mimeType = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
 
 
 NSDictionary *filePostData = [NSDictionary dictionaryWithObjectsAndKeys:
 
 self.filename,                                                        @"name",
 mimeType,                                                             @"type",
 [NSString stringWithString:@"p_tmp"],                                 @"tmp_name",// dir only - filename gets added on server-side
 [NSNumber numberWithInteger:0],                                       @"error",
 self.filesize,                                                        @"size",
 [NSInputStream inputStreamWithFileAtPath:self.localURL],              @"bits",
 
 nil];
 
 
 
 NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
 
 
 [NSString stringWithFormat:@"%@", self.filebase],               @"file_base",
 [NSString stringWithFormat:@"%@-thumb.jpg", self.filebase],     @"thumb",
 [NSString stringWithFormat:@"%@-mid.jpg", self.filebase],       @"mid",
 [NSString stringWithFormat:@"%@-large.jpg", self.filebase],     @"larger",
 
 self.photoponMediaModel.caption,                                @"headline",
 self.photoponMediaModel.coupon.details,                         @"offer_info",
 [NSString stringWithString:@"photo"],                           @"media_type",
 
 filePostData,                                                   @"file",
 
 nil];
 
 
 NSArray *parameters = [appDelegate getXMLRPCArgsWithExtra:object];
 
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusProcessing;
 
 / *
 
 
 // Create the request asynchronously
 // TODO: use streaming to avoid processing on memory
 NSMutableURLRequest *request = [appDelegate.api requestWithMethod:@"bp.uploadPhotopon" parameters:parameters];
 
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 
 
 AFHTTPRequestOperation *operation = [appDelegate.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSDictionary *response = (NSDictionary *)responseObject;
 if([response objectForKey:@"videopress_shortcode"] != nil)
 self.shortcode = [response objectForKey:@"videopress_shortcode"];
 
 if([response objectForKey:@"url"] != nil)
 self.remoteURL = [response objectForKey:@"url"];
 
 if ([response objectForKey:@"id"] != nil) {
 self.mediaID = [[response objectForKey:@"id"] numericValue];
 }
 
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
 [_uploadOperation release]; _uploadOperation = nil;
 //if (success) success();
 
 if([self.mediaType isEqualToString:@"video"]) {
 [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
 object:self
 userInfo:response];
 } else {
 [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
 object:self
 userInfo:response];
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
 [_uploadOperation release]; _uploadOperation = nil;
 //if (failure) failure(error);
 }];
 [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
 });
 }];
 _uploadOperation = [operation retain];
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
 [appDelegate.api enqueueHTTPRequestOperation:operation];
 
 
 
 */



/*
 NSMutableArray *pComRequestArray = [NSMutableArray arrayWithObjects:
 self.filebase,
 [NSString stringWithFormat:@"%@_thumb.jpg", self.filebase],
 [NSString stringWithFormat:@"%@_mid.jpg", self.filebase],
 [NSString stringWithFormat:@"%@_large.jpg", self.filebase],
 self.photoponMediaModel.caption,
 self.photoponMediaModel.coupon.details,
 [NSString stringWithString:@"photo"],
 self.filename,
 self.mediaType,
 [NSString stringWithString:@""],    // dir only - filename gets added on server-side
 (NSString *)[NSNumber numberWithInteger:0],
 [NSString stringWithFormat:@"%i", self.filesize],
 [NSInputStream inputStreamWithFileAtPath: self.localURL],
 self.localURL,
 nil];
 * /
 
 
 
 NSString *mimeType  = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
 
 //NSString *tmpName   = [[[NSString alloc] initWithString:self.filename] retain];
 //NSString *tmpName   = [[[NSString alloc] initWithFormat:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/%@", self.filename] retain];
 
 NSString *tmpName   = [[[NSString alloc] initWithFormat:@"/tmp/%@", self.filename] retain];
 //NSString *tmpName   = [[[NSString alloc] initWithString:@"/tmp"] retain];
 //NSString *tmpName   = [[[NSString alloc] initWithString:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/"] retain];
 NSDictionary *pComRequestArray = [NSDictionary dictionaryWithObjectsAndKeys:
 mimeType, @"type",
 self.filename, @"name",
 tmpName, @"tmp_name",
 self.filesize, @"size",
 [NSNumber numberWithInteger:0], @"error",
 [NSInputStream inputStreamWithFileAtPath:self.localURL], @"bits",
 nil];
 
 
 
 [FileLogger log:@"<uploadMediaWithSuccess> ::   NSArray *pComRequestArray = [[NSArray alloc] initWithObjects:"];
 
 NSArray *parameters = [[[NSArray alloc] initWithArray:[appDelegate getXMLRPCArgsWithExtra:pComRequestArray]] retain];
 
 [self setRemoteStatus:PhotoponGalleryMediaRemoteStatusProcessing];
 
 
 
 
 
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
 
 [FileLogger log:@"<uploadMediaWithSuccess> :: dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void)"];
 
 
 
 
 
 //getMyGallery
 AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
 
 NSMutableURLRequest *request = [api requestWithMethod:@"bp.uploadProfilePhoto" parameters:parameters];
 
 //[appDelegate.photoponTabBarViewController showPhotoponUploadProgressBar];
 
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 
 //X [self.photoponNewPhotoponHUDViewController showUploadProgress:uploadController.photoponProgressBar];
 
 AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 
 //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
 
 NSDictionary *response = (NSDictionary *)responseObject;
 //if([response objectForKey:@"videopress_shortcode"] != nil)
 //self.shortcode = [response objectForKey:@"videopress_shortcode"];
 
 if(([response objectForKey:@"confirmation"] != nil) && ([response objectForKey:@"confirmation"]) ){
 
 // [self close];
 
 /*
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"Confirmed! Upload Successful!", @"")
 message:[response objectForKey:@"message"]
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 * /
 
 
 }else {
 
 /*
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"NOT CONFIRMED! Upload Successful!", @"")
 message:[response objectForKey:@"message"]
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 * /
 
 
 }
 /*
 //self.remoteURL = [response objectForKey:@"url"];
 
 if ([response objectForKey:@"id"] != nil) {
 //self.mediaID = [[response objectForKey:@"id"] numericValue];
 }
 
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
 [_uploadOperation release]; _uploadOperation = nil;
 if (success) success();
 
 / *
 if([self.mediaType isEqualToString:@"video"]) {
 [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
 object:self
 userInfo:response];
 } else {
 * /
 [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
 object:self
 userInfo:response];
 //}
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
 
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
 //X [_uploadOperation release]; _uploadOperation = nil;
 if (failure) failure(error);
 }];
 [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 
 
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 
 self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
 //X [self.photoponNewPhotoponHUDViewController updateUploadProgress:self.progress];
 
 });
 }];
 //X _uploadOperation = [operation retain];
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
 [api enqueueHTTPRequestOperation:operation];
 });
 });
 
 
 
 
 
 
 
 //AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
 /*
 [api callMethod:@"bp.uploadPhotopon" //@"wp.uploadFile"
 parameters:parameters
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 
 [FileLogger log:@"<uploadMediaWithSuccess> ::      dispatch_async(dispatch_get_main_queue()    ::      SUCCESS BLOCK!!!"];
 
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"Upload Successful!", @"")
 message:@"Uploaded"
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 
 
 
 
 
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 
 [FileLogger log:@"<uploadMediaWithSuccess> ::      dispatch_async(dispatch_get_main_queue()    ::      FAIL BLOCK!!!"];
 
 UIAlertView *alertView = [[UIAlertView alloc]     initWithTitle:NSLocalizedString(@"Upload failed", @"")
 message:[error localizedDescription]
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
 
 
 NSLog(@"--------->");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
 NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"--------->");
 
 
 
 
 }];
 
 [FileLogger log:@"<uploadMediaWithSuccess> ::      dispatch_async(dispatch_get_main_queue(), ^(void)  <------  END STATEMENT  ----->"];
 
 / *
 [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
 });
 }];
 _uploadOperation = [operation retain];
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
 [appDelegate.api enqueueHTTPRequestOperation:operation];
 */

//[pool release];

//});
//  });


/*
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
 
 NSString *mimeType = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
 
 
 
 
 
 
 NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
 
 self.filename, @"name",
 mimeType, @"type",
 [NSString stringWithFormat:@"tmp/%@", self.filename], @"tmp_name",
 [NSNumber numberWithInteger:0], @"error",
 self.filesize, @"size",
 
 [NSInputStream inputStreamWithFileAtPath:self.localURL], @"bits",
 
 //filePostData, @"file",
 
 
 
 nil];
 //
 
 
 NSArray *parameters = [appDelegate getXMLRPCArgsWithExtra:object];
 
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusProcessing;
 
 
 
 
 // Create the request asynchronously
 // TODO: use streaming to avoid processing on memory
 NSMutableURLRequest *request = [appDelegate.api requestWithMethod:@"bp.uploadPhotopon" parameters:parameters];
 
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 
 
 AFHTTPRequestOperation *operation = [appDelegate.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSDictionary *response = (NSDictionary *)responseObject;
 if([response objectForKey:@"videopress_shortcode"] != nil)
 self.shortcode = [response objectForKey:@"videopress_shortcode"];
 
 if([response objectForKey:@"url"] != nil)
 self.remoteURL = [response objectForKey:@"url"];
 
 if ([response objectForKey:@"id"] != nil) {
 self.mediaID = [[response objectForKey:@"id"] numericValue];
 }
 
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
 [_uploadOperation release]; _uploadOperation = nil;
 //if (success) success();
 
 if([self.mediaType isEqualToString:@"video"]) {
 [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
 object:self
 userInfo:response];
 } else {
 [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
 object:self
 userInfo:response];
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
 [_uploadOperation release]; _uploadOperation = nil;
 //if (failure) failure(error);
 }];
 [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
 });
 }];
 _uploadOperation = [operation retain];
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
 [appDelegate.api enqueueHTTPRequestOperation:operation];
 
 
 
 
 / *
 
 AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
 //[api callMethod:@"bp.updateProfileStatus"
 [api callMethod:@"wp.uploadFile"
 parameters:parameters
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload Successful!", @"")
 message:@"Uploaded"
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 
 
 
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload failed", @"")
 message:[error localizedDescription]
 delegate:self
 cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
 otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
 alertView.tag = 20;
 [alertView show];
 [alertView release];
 //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
 
 
 NSLog(@"--------->");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
 NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
 NSLog(@"-------------------------------------------------------------");
 NSLog(@"--------->");
 
 
 
 }];
 
 [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 dispatch_async(dispatch_get_main_queue(), ^(void) {
 self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
 });
 }];
 _uploadOperation = [operation retain];
 self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
 [appDelegate.api enqueueHTTPRequestOperation:operation];
 * /
 
 
 });
 });
 * /
 
 
 
 //[self xmlrpcUploadWithSuccess:nil failure:nil];
 [FileLogger log:@"<uploadMediaWithSuccess> ::  <-------     END     ------->"];
 }
 */

- (void)saveImage:(UIImage*)img {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self setPhoto:img];
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"saveImage"
     message:@"made it here"
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        // Execute asynchronous background process
        
        
        //[self setPhoto:img];
        
        
        if (self.sourceType == UIImagePickerControllerSourceTypeCamera){
            
            
            //UIImageWriteToSavedPhotosAlbum(self.photo, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL); // context
            
            UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
            
            //MediaResize newSize = kResizeLarge;
            
            //[self.photoponMediaModel setImage:self.photoponImageModel];
            
        }
        
        
        
        // send to main queue again to complete custom save portion
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////
            // CUSTOM PHOTOPON SAVE OF SAVE PROCESS:        //////////////////
            //////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////
            
            MediaResize size = kResizeLarge;
            
            UIImage *aImage = self.photo;
            /*
             
             if (aImage.size.height>aImage.size.width) {
             // rotate and resave this thing
             newImagePortrait  = [self resizeImage:aImage width:600.0f height:900.0f];
             
             
             
             }else if(aImage.size.width>aImage.size.height){
             // PERFECT! This is the way we want it!
             //- (UIImage *)resizeImage:(UIImage *)original width:(CGFloat)width height:(CGFloat)height
             newImageLandscape  = [self resizeImage:aImage width:900.0f height:600.0f];
             
             }else{
             
             // UH-OH! This is odd ... perfect square? Fishy business ...
             return;
             
             }
             */
            
            
            // UIImage *bImage;
            
            
            CGSize smallSize = CGSizeMake(100.0f, 150.0f);// [[predefDim objectForKey: @"smallSize"] CGSizeValue];
            CGSize mediumSize = CGSizeMake(200.0f, 300.0f);//[[predefDim objectForKey: @"mediumSize"] CGSizeValue];
            CGSize largeSize =  CGSizeMake(400.0f, 600.0f);//[[predefDim objectForKey: @"largeSize"] CGSizeValue];
            
            switch (aImage.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    smallSize = CGSizeMake(smallSize.height, smallSize.width);
                    mediumSize = CGSizeMake(mediumSize.height, mediumSize.width);
                    largeSize = CGSizeMake(largeSize.height, largeSize.width);
                    break;
                default:
                    break;
            }
            
            CGSize newSize;
            switch (size) {
                case kResizeSmall:
                    newSize = smallSize;
                    break;
                case kResizeMedium:
                    newSize = mediumSize;
                    break;
                case kResizeLarge:
                    newSize = largeSize;
                    break;
                default:
                    newSize = aImage.size;
                    break;
            }
            
            switch (self.photo.imageOrientation) {
                case UIImageOrientationUp:
                case UIImageOrientationUpMirrored:
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                    self.orientation = @"landscape";
                    break;
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    self.orientation = @"portrait"; // portrait
                    break;
                default:
                    self.orientation = @"portrait";
            }
            
            
            
            // Let's fix this portrait junk - LANDSCAPE ONLY!
            if (self.orientation==@"portrait") {
                
                
                UIImage *newImagePortrait = self.photo;
                UIImage *newImageLandscape = [[UIImage alloc] initWithCGImage: newImagePortrait.CGImage scale:1.0 orientation:UIImageOrientationUp];
                
                aImage = newImageLandscape;
                
                self.orientation = @"landscape";
                /*
                 //CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
                 //CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
                 * /
                 
                 CGFloat degrees = -90.0f;
                 // calculate the size of the rotated view's containing box for our drawing space
                 UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,aImage.size.width, aImage.size.height)];
                 CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
                 rotatedViewBox.transform = t;
                 CGSize rotatedSize = rotatedViewBox.frame.size;
                 [rotatedViewBox release];
                 
                 // Create the bitmap context
                 UIGraphicsBeginImageContext(rotatedSize);
                 CGContextRef bitmap = UIGraphicsGetCurrentContext();
                 
                 // Move the origin to the middle of the image so we will rotate and scale around the center.
                 CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
                 
                 //   // Rotate the image context
                 CGContextRotateCTM(bitmap, degrees * M_PI / 180);
                 
                 // Now, draw the rotated/scaled image into the context
                 CGContextScaleCTM(bitmap, 1.0, -1.0);
                 CGContextDrawImage(bitmap, CGRectMake(-aImage.size.width / 2, -aImage.size.height / 2, aImage.size.width, aImage.size.height), [aImage CGImage]);
                 
                 UIImage *cImage = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
                 
                 bImage = cImage;
                 */
                
                
                
                
                
                
                
                
            }
            
            
            
            //The dimensions of the image, taking orientation into account.
            CGSize originalSize = CGSizeMake(aImage.size.width, aImage.size.height);
            
            UIImage *resizedImage = aImage;
            if(aImage.size.width > newSize.width || aImage.size.height > newSize.height){
                resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:newSize interpolationQuality:kCGInterpolationHigh];
            }else{
                resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:originalSize interpolationQuality:kCGInterpolationHigh];
            }
            
            
            NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.90);
            UIImage *imageThumbnail = [aImage thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
            
            //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            //NSData *imageData = UIImagePNGRepresentation(pickedImage);
            
            [self setFilebase:(NSString*)[formatter stringFromDate:[NSDate date]]];
            NSString *photoponPhotoFilename = [[NSString alloc] initWithFormat:@"%@.jpg", self.filebase];
            [self setFilename:photoponPhotoFilename]; // default filename - suffix "-large" since we'll always use the largest copy as our template
            
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
            [self setLocalURL:path];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:path contents:imageData attributes:nil];
            
            
            /*
             NSError * errors = nil;
             [imageData writeToFile:path options:NSDataWritingAtomic error:&errors];
             
             if (errors != nil) {
             NSLog(@"Error: %@", errors);
             return;
             }
             */
            
            self.creationDate   = [NSDate date];
            self.filesize       = [NSNumber numberWithInt:(imageData.length/1024)];
            [self setMediaType:[NSString stringWithFormat:@"%@", @"image/jpeg"]];
            self.thumbnail      = UIImageJPEGRepresentation(imageThumbnail, 0.90);
            self.width          = [NSNumber numberWithInt:resizedImage.size.width];
            self.height         = [NSNumber numberWithInt:resizedImage.size.height];
            
            
            
            //[self hideBackdropView];
            
            
            //MediaResize size = kResizeLarge;
            
            //UIImage *aImage = self.photo;
            
            /*
             
             CGSize smallSize = CGSizeMake(290.0f, 194.0f);// [[predefDim objectForKey: @"smallSize"] CGSizeValue];
             CGSize mediumSize = CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"mediumSize"] CGSizeValue];
             CGSize largeSize =  CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"largeSize"] CGSizeValue];
             switch (aImage.imageOrientation) {
             case UIImageOrientationLeft:
             case UIImageOrientationLeftMirrored:
             case UIImageOrientationRight:
             case UIImageOrientationRightMirrored:
             smallSize = CGSizeMake(smallSize.height, smallSize.width);
             mediumSize = CGSizeMake(mediumSize.height, mediumSize.width);
             largeSize = CGSizeMake(largeSize.height, largeSize.width);
             break;
             default:
             break;
             }
             
             CGSize newSize;
             switch (size) {
             case kResizeSmall:
             newSize = smallSize;
             break;
             case kResizeMedium:
             newSize = mediumSize;
             break;
             case kResizeLarge:
             newSize = largeSize;
             break;
             default:
             newSize = aImage.size;
             break;
             }
             / *
             switch (aImage.imageOrientation) {
             case UIImageOrientationUp:
             case UIImageOrientationUpMirrored:
             case UIImageOrientationDown:
             case UIImageOrientationDownMirrored:
             //    self.orientation = @"landscape";
             break;
             case UIImageOrientationLeft:
             case UIImageOrientationLeftMirrored:
             case UIImageOrientationRight:
             case UIImageOrientationRightMirrored:
             //   self.orientation = @"portrait";
             break;
             default:
             //    self.orientation = @"portrait";
             }
             */
            //The dimensions of the image, taking orientation into account.
            
            
            //CGSize originalSize = CGSizeMake(aImage.size.width, aImage.size.height);
            
            /*
             //UIImage *resizedImage = aImage;
             if(aImage.size.width > newSize.width || aImage.size.height > newSize.height)
             resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
             bounds:newSize
             interpolationQuality:kCGInterpolationHigh];
             else
             resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
             bounds:originalSize
             interpolationQuality:kCGInterpolationHigh];
             
             
             NSData *imageData = UIImageJPEGRepresentation(self.photo, 0.90);
             
             
             //self.binData = [NSData dataWithData:imageData];
             
             UIImage *imageThumbnail = [self.photo thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
             
             
             
             //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
             //NSData *imageData = UIImagePNGRepresentation(pickedImage);
             
             //NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
             //NSString *path = [documentsDirectory stringByAppendingPathComponent:@"imageName.png"];
             
             //if (error != nil) {
             //  NSLog(@"Error: %@", error);
             //  return;
             //}
             
             
             
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString *documentsDirectory = [paths objectAtIndex:0];
             
             NSString *photoponPhotoFilename = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
             [formatter release]; formatter = nil;
             NSString *filepath = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
             
             NSFileManager *fileManager = [NSFileManager defaultManager];
             [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
             
             
             NSError * error = nil;
             //[imageData writeToFile:filepath options:NSDataWritingAtomic error:&error];
             
             if(error){
             UIAlertView *alert;
             
             alert = [[UIAlertView alloc] initWithTitle:@"Success"
             message:[error description]
             delegate:self cancelButtonTitle:@"Ok"
             otherButtonTitles:nil];
             
             
             
             [alert show];
             [alert release];
             
             }
             
             
             
             self.creationDate = [NSDate date];
             self.filename = photoponPhotoFilename;
             self.localURL = filepath;
             self.filesize = [NSNumber numberWithInt:(imageData.length/1024)];
             self.mediaType = @"image";
             self.thumbnail = UIImageJPEGRepresentation(imageThumbnail, 0.90);
             self.width = [NSNumber numberWithInt:self.photo.size.width];
             self.height = [NSNumber numberWithInt:self.photo.size.height];
             
             
             
             
             
             
             
             
             
             
             
             
             / *
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
             
             //UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
             
             if (self.photoPicker.sourceType == UIImagePickerControllerSourceTypeCamera){
             
             UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
             
             MediaResize newSize = kResizeLarge;
             
             [photoponImageModel_ setPhotoponImage:self.photo withSize:newSize];
             [self.photoponMediaModel setImage:self.photoponImageModel];
             
             }
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
             
             
             / *
             Blog *blog = [[Blog alloc] init];
             if (post == nil) {
             post = [PhotoponPost newDraftForBlog:blog];
             }
             
             if (post.media && [post.media count] > 0) {
             media = [post.media anyObject];
             } else {
             //media = [PhotoponGalleryMedia newMediaForPost:post];
             int resizePreference = 0;
             if([[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"] != nil)
             resizePreference = [[[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"] intValue];
             
             MediaResize newSize = kResizeLarge;
             switch (resizePreference) {
             case 1:
             newSize = kResizeSmall;
             break;
             case 2:
             newSize = kResizeMedium;
             break;
             case 4:
             newSize = kResizeOriginal;
             break;
             
             }
             }
             */
            
            //int resizePreference = 0;
            
            //MediaResize newSize = kResizeLarge;
            
            /*
             switch (resizePreference) {
             case 1:
             newSize = kResizeSmall;
             break;
             case 2:
             newSize = kResizeMedium;
             break;
             case 4:
             newSize = kResizeOriginal;
             break;
             */
            
            //self.photo = [[UIImage alloc] init];
            
            //[photoponImageModel_ setPhotoponImage:self.photo withSize:newSize];
            //[self.photoponMediaModel setImage:self.photoponImageModel];
            
            //}
            
            
            //[media save];
            //[media release];
            //[postButtonItem setEnabled:YES];
        });
        
        
        
        
        
        
        
        
        
        
        
        
    });
    
    
    
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if(buttonIndex == 0) {
        
        [self pickPhotoFromCamera:actionSheet];
        
    }
    else if(buttonIndex == 1) {
        
        //if (actionSheet.tag == TAG_ACTIONSHEET_VIDEO) {
        //  [self pickVideoFromCamera:actionSheet];
        //} else {
        
        [self pickPhotoFromPhotoLibrary:actionSheet];
        
        //}
        
    }
    else {
        
        self.isAddingMedia = NO;
    }
    
    
    
}

- (void)pickPhotoFromCamera:(id)sender {
    
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        /*
         if (IS_IPAD && addPopover != nil) {
         [addPopover dismissPopoverAnimated:YES];
         }*/
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    
    //[self presentModalViewController:self.mediaPicker animated:YES];
    
    /*
     self.currentOrientation = [self interpretOrientation:[UIDevice currentDevice].orientation];
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
     
     if(IS_IPAD == YES) {
     UIBarButtonItem *barButton = postDetailViewController.photoButton;
     if (addPopover == nil) {
     addPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
     if ([addPopover respondsToSelector:@selector(popoverBackgroundViewClass)]) {
     addPopover.popoverBackgroundViewClass = [WPPopoverBackgroundView class];
     }
     addPopover.delegate = self;
     }
     
     if (!CGRectIsEmpty(actionSheetRect)) {
     [addPopover presentPopoverFromRect:actionSheetRect inView:self.postDetailViewController.postSettingsViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     } else {
     [addPopover presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     }
     [[CPopoverManager instance] setCurrentPopoverController:addPopover];
     }
     else {
     [postDetailViewController.navigationController presentModalViewController:picker animated:YES];
     }
     }
     */
}
/*
 - (void)pickPhotoFromPhotoLibrary:(id)sender {
 
 [self presentModalViewController:picker animated:YES];
 
 }*/


- (void)pickPhotoFromPhotoLibrary:(id)sender {
	UIBarButtonItem *barButton = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        if (IS_IPAD && addPopover != nil) {
            [addPopover dismissPopoverAnimated:YES];
        }
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([(UIView *)sender tag] == 0) {
			//barButton = postDetailViewController.movieButton;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
			picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
			
			if([[NSUserDefaults standardUserDefaults] objectForKey:@"video_quality_preference"] != nil) {
				NSString *quality = [[NSUserDefaults standardUserDefaults] objectForKey:@"video_quality_preference"];
				switch ([quality intValue]) {
					case 0:
						picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
						break;
					case 1:
						picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
						break;
					case 2:
						picker.videoQuality = UIImagePickerControllerQualityTypeLow;
						break;
					case 3:
						picker.videoQuality = UIImagePickerControllerQualityType640x480;
						break;
					default:
						picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
						break;
				}
			}
        } else {
			//barButton = postDetailViewController.photoButton;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        }
		isLibraryMedia = YES;
		
		if(IS_IPAD == YES) {
            if (addPopover == nil) {
                addPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
                addPopover.delegate = self;
            }
            
            [addPopover presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            //[[CPopoverManager instance] setCurrentPopoverController:addPopover];
		}
		else {
			if(pickerContainer == nil)
				pickerContainer = [[UIViewController alloc] init];
			
			pickerContainer.view.frame = CGRectMake(0, 0, 320, 480);
            appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
			//[appDelegate.navigationController.view addSubview:pickerContainer.view];
			//[appDelegate.navigationController.view bringSubviewToFront:pickerContainer.view];
			//[pickerContainer presentModalViewController:picker animated:YES];
		}
    }
}


/*
 
 - (void)imagePickerController:(UIImagePickerController *)thePicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 / *
 if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
 UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
 if (thePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
 UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
 currentImage = image;
 
 //UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=1000000050&ext=JPG").
 NSURL *assetURL = nil;
 if (&UIImagePickerControllerReferenceURL != NULL) {
 assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
 }
 if (assetURL) {
 [self getMetadataFromAssetForURL:assetURL];
 } else {
 NSDictionary *metadata = nil;
 if (&UIImagePickerControllerMediaMetadata != NULL) {
 metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
 }
 / *
 if (metadata) {
 NSMutableDictionary *mutableMetadata = [metadata mutableCopy];
 NSDictionary *gpsData = [mutableMetadata objectForKey:@"{GPS}"];
 / *
 if (!gpsData && self.post.geolocation) {
 / *
 Sample GPS data dictionary
 "{GPS}" =     {
 Altitude = 188;
 AltitudeRef = 0;
 ImgDirection = "84.19556";
 ImgDirectionRef = T;
 Latitude = "41.01333333333333";
 LatitudeRef = N;
 Longitude = "0.01666666666666";
 LongitudeRef = W;
 TimeStamp = "10:34:04.00";
 };
 * /
 CLLocationDegrees latitude = self.post.geolocation.latitude;
 CLLocationDegrees longitude = self.post.geolocation.longitude;
 NSDictionary *gps = [NSDictionary dictionaryWithObjectsAndKeys:
 [NSNumber numberWithDouble:fabs(latitude)], @"Latitude",
 (latitude < 0.0) ? @"S" : @"N", @"LatitudeRef",
 [NSNumber numberWithDouble:fabs(longitude)], @"Longitude",
 (longitude < 0.0) ? @"W" : @"E", @"LongitudeRef",
 nil];
 [mutableMetadata setObject:gps forKey:@"{GPS}"];
 }* /
 [mutableMetadata removeObjectForKey:@"Orientation"];
 [mutableMetadata removeObjectForKey:@"{TIFF}"];
 self.currentImageMetadata = mutableMetadata;
 }
 * /
 }
 
 NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
 [nf setNumberStyle:NSNumberFormatterDecimalStyle];
 NSNumber *resizePreference = [NSNumber numberWithInt:-1];
 if([[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"] != nil)
 resizePreference = [nf numberFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"]];
 
 
 switch ([resizePreference intValue]) {
 case 0:
 {
 // Dispatch async to detal with a rare bug presenting the actionsheet after a memory warning when the
 // view has been recreated.
 dispatch_async(dispatch_get_main_queue(), ^{
 [self showResizeActionSheet];
 });
 break;
 }
 case 1:
 {
 [self useImage:[self resizeImage:currentImage toSize:kResizeSmall]];
 break;
 }
 case 2:
 {
 [self useImage:[self resizeImage:currentImage toSize:kResizeMedium]];
 break;
 }
 case 3:
 {
 [self useImage:[self resizeImage:currentImage toSize:kResizeLarge]];
 break;
 }
 case 4:
 {
 //[self useImage:currentImage];
 [self useImage:[self resizeImage:currentImage toSize:kResizeOriginal]];
 break;
 }
 default:
 {
 // Dispatch async to detal with a rare bug presenting the actionsheet after a memory warning when the
 // view has been recreated.
 dispatch_async(dispatch_get_main_queue(), ^{
 [self showResizeActionSheet];
 });
 break;
 }
 }
 
 }
 * /
 }
 */
- (void)useImage:(UIImage *)theImage {
	//Media *imageMedia = [Media newMediaForPost:self.apost];
	NSData *imageData = UIImageJPEGRepresentation(theImage, 0.90);
	UIImage *imageThumbnail = [self generateThumbnailFromImage:theImage andSize:CGSizeMake(75, 75)];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    
	/*if (self.currentImageMetadata != nil) {
     // Write the EXIF data with the image data to disk
     CGImageSourceRef  source = NULL;
     CGImageDestinationRef destination = NULL;
     BOOL success = NO;
     //this will be the data CGImageDestinationRef will write into
     NSMutableData *dest_data = [NSMutableData data];
     
     source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
     if (source) {
     CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)
     destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
     
     if(destination) {
     //add the image contained in the image source to the destination, copying the old metadata
     CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) self.currentImageMetadata);
     
     //tell the destination to write the image data and metadata into our data object.
     //It will return false if something goes wrong
     success = CGImageDestinationFinalize(destination);
     } else {
     WPFLog(@"***Could not create image destination ***");
     }
     } else {
     WPFLog(@"***Could not create image source ***");
     }
     
     if(!success) {
     WPLog(@"***Could not create data from image destination ***");
     //write the data without EXIF to disk
     NSFileManager *fileManager = [NSFileManager defaultManager];
     [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
     } else {
     //write it to disk
     [dest_data writeToFile:filepath atomically:YES];
     }
     //cleanup
     if (destination)
     CFRelease(destination);
     if (source)
     CFRelease(source);
     } else {
     
     NSFileManager *fileManager = [NSFileManager defaultManager];
     [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
     
     }
     
     * /
     
     if(currentOrientation == kLandscape)
     imageMedia.orientation = @"landscape";
     else
     imageMedia.orientation = @"portrait";
     imageMedia.creationDate = [NSDate date];
     imageMedia.filename = filename;
     imageMedia.localURL = filepath;
     imageMedia.filesize = [NSNumber numberWithInt:(imageData.length/1024)];
     if (isPickingFeaturedImage)
     imageMedia.mediaType = @"featured";
     else
     imageMedia.mediaType = @"image";
     imageMedia.thumbnail = UIImageJPEGRepresentation(imageThumbnail, 0.90);
     imageMedia.width = [NSNumber numberWithInt:theImage.size.width];
     imageMedia.height = [NSNumber numberWithInt:theImage.size.height];
     if (isPickingFeaturedImage)
     [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadingFeaturedImage" object:nil];
     
     [imageMedia uploadWithSuccess:^{
     if ([imageMedia isDeleted]) {
     NSLog(@"Media deleted while uploading (%@)", imageMedia);
     return;
     }
     if (!isPickingFeaturedImage) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldInsertMediaBelow" object:imageMedia];
     }
     else {
     
     }
     [imageMedia save];
     } failure:^(NSError *error) {
     if( isPickingFeaturedImage ) {
     [WPError showAlertWithError:error title:NSLocalizedString(@"Sorry, 'Featured Image' upload failed.", @"")];
     }
     }];
     
     isAddingMedia = NO;
     
     if (isPickingFeaturedImage)
     [postDetailViewController switchToSettings];
     else
     [postDetailViewController switchToMedia];
     */
}

- (void)cancelUpload {
    //NSLog(@"||*****||");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [_uploadOperation cancel];
    _uploadOperation = nil;
    self.remoteStatus = PhotoponModelRemoteStatusFailed;
}

















































- (void)refreshTable {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView reloadData];
}

/*
 - (void)createBlog {
 NSMutableDictionary *newBlog = [[NSMutableDictionary alloc] init];
 
 [newBlog setValue:self.blogName forKey:@"blogName"];
 [newBlog setValue:@"1" forKey:@"isAdmin"];
 [newBlog setValue:@"0" forKey:@"isActivated"];
 //[newBlog setValue:[NSString stringWithFormat:@"http://%@.placepon.com/", self.blogName] forKey:@"url"];
 [newBlog setValue:[NSString stringWithFormat:@"http://placepon.com/core/wp-content/plugins/buddypress-xmlrpc-receiver/bp-xmlrpc.php", self.blogName] forKey:@"xmlrpc"];
 [newBlog setValue:self.username forKey:@"username"];
 [newBlog setValue:self.password forKey:@"password"];
 
 Blog *blog = [Blog createFromDictionary:newBlog withContext:appDelegate.managedObjectContext];
 [blog dataSave];
 
 [newBlog release];
 
 //FIXME: should we send a notification? addUsersBlogsViewController does this.
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"BlogsRefreshNotification" object:nil];
 }
 */

-(void)removeWebViewController{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.photoponWebViewController.view removeFromSuperview];
    
    self.photoponWebViewController = nil;
    
    /*
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     
     // Update UI with result
     
     NSLog(@"}=<><><><><><><><><><><><><><><><><>-->");
     NSLog(@"calling .... ");
     NSLog(@"[self photoponXMLSignupViewController fadeInView]");
     NSLog(@"}=<><><><><><><><><><><><><><><><><>-->");
     
     //[self dismissModalViewControllerAnimated:YES];
     
     [self dismissViewControllerAnimated:YES completion:nil];
     
     [self.photoponWebViewController.view removeFromSuperview];
     
     self.photoponWebViewController = nil;
     
     
     NSLog(@"}=<><><><><><><><><><><><><><><><><>-->");
     NSLog(@"}=<><><><><><><><><><><><><><><><><>-->");
     NSLog(@"END");
     
     });
     */
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    switch (alertView.tag) {
        case 10:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 20:
            break;
    }
}

- (IBAction)backHandler:(id)sender
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //[appDelegate.photoponSplashScreenViewController dismissViewControllerAnimated:YES completion:nil];
    
    [appDelegate.loginViewController dismissViewControllerAnimated:YES completion:nil];
    
    //[appDelegate.photoponSplashScreenViewController fadeOutSignupView];
    
    //[appDelegate.photoponSplashScreenViewController fadeInView];
    
    
    
}
/*
 -(IBAction)photoponBtnProfilePhotoHandler:(id)sender{
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 sheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to set your picture?"
 delegate:self
 cancelButtonTitle:@"Cancel"
 destructiveButtonTitle:nil
 otherButtonTitles:@"Take Picture", @"Choose Picture", nil];
 
 // Show the sheet
 [sheet showInView:self.view];
 [sheet release];
 
 
 }
 */

/*
 - (IBAction)photoponBtnProfilePhotoHandler:(id)sender {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 / *
 NSLog(@"----> ");
 NSLog(@"PhotoponProfileSettingsViewController :: profilePhotoHandler");
 NSLog(@"----> ");
 * /
 
 
 
 self.picker = [[UIImagePickerController alloc] init];
 [picker setDelegate:self];
 picker.allowsEditing = YES;
 
 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
 UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to set your picture?"
 delegate:self
 cancelButtonTitle:@"Cancel"
 destructiveButtonTitle:nil
 otherButtonTitles:@"Take photo", @"Choose Existing", nil];
 [actionSheet showInView:self.view];
 } else {
 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 [self presentModalViewController:picker animated:YES];
 }
 }
 */


- (IBAction)photoponBtnProfilePhotoHandler:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     NSLog(@"----> ");
     NSLog(@"PhotoponProfileSettingsViewController :: profilePhotoHandler");
     NSLog(@"----> ");
     */
    
    
    self.mediaPicker = [[UIImagePickerController alloc] init];
    [mediaPicker setDelegate:self];
    mediaPicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to set your picture?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } else {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.mediaPicker animated:YES];
    }
    
    
    
    
    
    
    
    
    
    /*
     
     if (!mediaPicker) {
     self.mediaPicker = [[[UIImagePickerController alloc] init] retain];
     [mediaPicker setDelegate:self];
     mediaPicker.allowsEditing = YES;
     }
     
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to set your picture?"
     delegate:self
     cancelButtonTitle:@"Cancel"
     destructiveButtonTitle:nil
     otherButtonTitles:@"Take photo", @"Choose Existing", nil];
     [actionSheet showInView:self.view];
     } else {
     mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     [self presentModalViewController:mediaPicker animated:YES];
     }
     */
}




- (void)showQuickPhotoButton:(BOOL)delay {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (uploadController) {
        [UIView animateWithDuration:0.6f
                              delay:delay ? 1.2f : 0.0f
                            options:0
                         animations:^{
                             CGRect frame = self.view.frame;
                             self.view.frame = CGRectMake(frame.origin.x, self.view.bounds.size.height - 83, frame.size.width, frame.size.height);
                             frame = uploadController.view.frame;
                             uploadController.view.frame = CGRectMake(frame.origin.x, self.view.bounds.size.height + 83, frame.size.width, frame.size.height);
                         } completion:^(BOOL finished) {
                             [uploadController.view removeFromSuperview];
                             uploadController = nil;
                         }];
    }
}

- (void)postDidUploadSuccessfully:(NSNotification *)notification {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    appDelegate.isUploadingPost = NO;
    if (uploadController) {
        [UIView animateWithDuration:0.6f animations:^{
            [uploadController.spinner setAlpha:0.0f];
            uploadController.label.text = NSLocalizedString(@"Published!", @"");
            uploadController.label.textColor = [[UIColor alloc] initWithRed:1.0f green:1.0f/255.0f blue:1.0f alpha:1.0f];
            uploadController.label.frame = CGRectMake(uploadController.label.frame.origin.x, uploadController.label.frame.origin.y - 12, uploadController.label.frame.size.width, uploadController.label.frame.size.height);
        } completion:^(BOOL finished) {
            [self showQuickPhotoButton:YES];
        }];
    }
}

- (void)postUploadFailed:(NSNotification *)notification {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    appDelegate.isUploadingPost = NO;
    [self showQuickPhotoButton:NO];
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Photopon Publish Failed", @"")
     message:NSLocalizedString(@"Sorry, the photopon publish failed. The photopon has been saved as a Local File.", @"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */
}

-(void)photoponSnapPhotoHandler{
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    //[photoponNewPhotoponViewController_.picker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
    //[photoponNewPhotoponViewController_.picker takePicture];
    
    //self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    
    [self.photoPicker takePicture];
    
    
    //[photoPicker presentModalViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
    [photoPicker setShowsCameraControls:NO];
    
}

-(void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    [aPicker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //image = [image croppedImage:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    image = [image croppedImage:[[info valueForKey:UIImagePickerControllerCropRect] CGRectValue]];
    [self setPhoto:image];
    
    self.photoponBtnProfilePhotoImage = self.photo;
    [self.profilePhoto.imageView setImage:self.photo];
    
    [self saveImage];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    NSLog(@"|");
    NSLog(@"|");
    NSLog(@"----------->");
    NSLog(@"PhotoponNewPhotoponViewController :: imagePickerControllerDidCancel");
    NSLog(@"----------->");
    NSLog(@"|");
    NSLog(@"|");
    
    //picker.delegate = nil;
    
    [picker dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    
    
    [self hideCam];
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    /*
     UIAlertView *alert;
     
     // Unable to save the image
     if (error){
     alert = [[UIAlertView alloc] initWithTitle:@"Error"
     message:@"Unable to save image to Photo Album."
     delegate:self cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     
     
     
     }else{ // All is well
     
     alert = [[UIAlertView alloc] initWithTitle:@"Success"
     message:@"Image saved to Photo Album."
     delegate:self cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     
     //[self saveImage];
     
     }
     
     [alert show];
     [alert release];
     //MediaResize newSize = kResizeLarge;
     
     
     
     
     
     
     NSData *imageData = UIImageJPEGRepresentation(self.photo, 0.90);
     UIImage *imageThumbnail = [self.photo thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
     
     
     
     
     //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
     //NSData *imageData = UIImagePNGRepresentation(pickedImage);
     
     NSString *photoponPhotoFilename = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
     
     self.filename = photoponPhotoFilename;
     
     NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
     NSString *path = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
     
     self.localURL = path;
     
     NSError * errors = nil;
     [imageData writeToFile:path options:NSDataWritingAtomic error:&errors];
     
     if (errors != nil) {
     NSLog(@"Error: %@", errors);
     return;
     }
     
     
     self.creationDate   = [NSDate date];
     self.filename       = photoponPhotoFilename;
     self.filesize       = [NSNumber numberWithInt:(imageData.length/1024)];
     self.mediaType      = @"image";
     self.thumbnail      = UIImageJPEGRepresentation(imageThumbnail, 0.90);
     self.width          = [NSNumber numberWithInt:self.photo.size.width];
     self.height         = [NSNumber numberWithInt:self.photo.size.height];
     
     
     
     
     //[self.photoponImageModel setPhotoponImage:self.photoponImageModel.image withSize:nil];
     
     //[self.photoponMediaModel setImage:self.photoponImageModel];
     
     
     
     
     
     
     
     
     
     
     //  }
     
     
     
     if (error){
     [FileLogger log:@"-----------------------------------------------"];
     [FileLogger log:@"-----------------------------------------------"];
     [FileLogger log:@"---------|         ERROR         |-------------"];//%@ %@", self, NSStringFromSelector(_cmd)];
     [FileLogger log:@"-----------------------------------------------"];
     [FileLogger log:@"---------|  error.description =  |-------------"];
     [FileLogger log:@"-----------------------------------------------"];
     [FileLogger log:@"---------|  %@ ", error.description];
     [FileLogger log:@"-----------------------------------------------"];
     [FileLogger log:@"-----------------------------------------------"];
     
     }
     */
}


- (IBAction)postAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //- (IBAction)saveAction:(id)sender {
    
    
    
}

- (void)post {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     UIAlertView *videoAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Share->post", @"")
     message:NSLocalizedString(@"ShareController is ok. Hmmmm.", @"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil];
     [videoAlert show];
     [videoAlert release];
     */
    
    //Blog *blog = [[Blog alloc] init];//self.blogSelector.activeBlog;
    //blog.blogID = [NSNumber numberWithInt:1];
    
    
    
    /*
     //media = nil;
     if (post == nil) {
     post = [PhotoponPost newDraftForBlog:blog];
     } else {
     post.blog = blog;
     //media = [post.media anyObject];
     [media setBlog:blog];
     }
     post.postTitle = @"Something";
     
     //    post.media =
     
     //.text;
     //post.content = contentTextView.text;
     //if (self.isCameraPlus) {
     //  post.specialType = @"QuickPhotoCameraPlus";
     //} else {
     //  post.specialType = @"QuickPhoto";
     // }
     
     post.postFormat = @"image";
     */
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDidUploadSuccessfully:) name:ImageUploadSuccessful object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaUploadFailed:) name:ImageUploadFailed object:self];
    
    appDelegate.isUploadingPost = YES;
    
    
    
    
    
    
    
    
    //photoponImageModel_.remoteStatus = PhotoponGalleryMediaRemoteStatusProcessing;
    
    
    
    self.remoteStatus = PhotoponModelRemoteStatusProcessing;
    
    
    
    [self uploadMediaWithSuccess:^{
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"[self uploadMediaWithSuccess:^{");
        NSLog(@"");
        NSLog(@"------------>   SUCCESS SUCCESS SUCCESS ");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
         message:NSLocalizedString(@"Success!", @"")
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"OK", @"")
         otherButtonTitles:nil];
         [alert show];
         [alert release];
         */
    }
                         failure:^(NSError *error) {
                             
                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                             NSLog(@"[self uploadMediaWithSuccess:^{");
                             NSLog(@"");
                             NSLog(@"------------>   FAILURE FAILURE FAILURE ");
                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                             
                             /*
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"uploadMediaWithSuccess", @"")
                              message:[error description]
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                              otherButtonTitles:nil];
                              [alert show];
                              [alert release];
                              */
                         }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //[self.photoponImageModel uploadWithSuccess:nil failure:nil];
    
    
    /*
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     [photoponImageModel_ uploadWithSuccess:^{
     
     UIAlertView *photoponIsCurrentlyBusy = [[UIAlertView alloc] initWithTitle:@"Upload Success!"
     message:@"Photopon posted successfully!"
     delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
     [photoponIsCurrentlyBusy show];
     [photoponIsCurrentlyBusy release];
     
     }failure:^(NSError *error){
     
     UIAlertView *photoponIsCurrentlyBusy = [[UIAlertView alloc] initWithTitle:@"Upload Failed!"
     message:@"Photopon post FAILED!"
     delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
     [photoponIsCurrentlyBusy show];
     [photoponIsCurrentlyBusy release];
     
     }];
     
     //[post save];
     });
     */
    //[self.navigationController popViewControllerAnimated:YES];
    //[self uploadQuickPhoto: post];
    
    //uploadController = nil;
    
    
    
    
    [self uploadQuickPhoto];
    
    /*
     UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"post :: end", @"")
     message:@"end of post {..."
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     alertView2.tag = 22;
     [alertView2 show];
     [alertView2 release];
     */
}

- (void)uploadQuickPhoto {
    
    
    //if (self.photoponImageModel != nil) {
    
    //X self.currentPhotoponMediaModel = self.photoponMediaModel;
    
    //remove the quick photo button w/ sexy animation
    CGRect frame = self.view.frame;
    
    if (uploadController == nil) {
        uploadController = [[QuickPhotoUploadProgressController alloc] initWithNibName:@"QuickPhotoUploadProgressController" bundle:nil];
        uploadController.view.frame = CGRectMake(frame.origin.x, self.view.bounds.size.height + 83, frame.size.width, frame.size.height);
        //X [self.photoponContainerView.view addSubview:uploadController.view];
    }
    
    if (uploadController.spinner.alpha == 0.0) {
        //reset the uploading view
        [uploadController.spinner setAlpha: 1.0f];
        uploadController.label.frame = CGRectMake(uploadController.label.frame.origin.x, uploadController.label.frame.origin.y + 12, uploadController.label.frame.size.width, uploadController.label.frame.size.height);
    }
    [uploadController.spinner startAnimating];
    
    uploadController.label.textColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    uploadController.label.text = NSLocalizedString(@"Photoponing...", @"");
    
    //show the upload dialog animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6f];
    self.view.frame = CGRectMake(frame.origin.x, self.view.bounds.size.height + 83, frame.size.width, frame.size.height);
    frame = uploadController.view.frame;
    uploadController.view.frame = CGRectMake(frame.origin.x, self.view.bounds.size.height - 83, frame.size.width, frame.size.height);
    
    [UIView commitAnimations];
    
    //X [self.photoponNewPhotoponHUDViewController.controlSetThirdView setHidden:YES];
    //X [self.photoponNewPhotoponHUDViewController.controlSetFirstView setHidden:YES];
    //X [self.photoponNewPhotoponHUDViewController.controlSetSecondView setHidden:YES];
    
    // }
}

/*
 IBOutlet UIProgressView * threadProgressView;
 threadProgressView.progress = 0.0;
 [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
 
 - (void)makeMyProgressBarMoving {
 
 float actual = [threadProgressView progress];
 if (actual < 1) {
 threadProgressView.progress = actual + ((float)recievedData/(float)xpectedTotalSize);
 [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
 }
 else{
 
 
 
 }
 
 }
 */



- (void)saveImage {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        //UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
        
        if (self.sourceType == UIImagePickerControllerSourceTypeCamera){
            
            UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
            
            //MediaResize newSize = kResizeLarge;
            
            //[self.photoponMediaModel setImage:self.photoponImageModel];
            
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateNormal];
            [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateHighlighted];
            [self.photoponBtnProfilePhoto setImage:self.photoponBtnProfilePhotoImage forState:UIControlStateSelected];
            
            
            
            MediaResize size = kResizeLarge;
            
            UIImage *aImage = self.photo;
            /*
             
             
             if (aImage.size.height>aImage.size.width) {
             // rotate and resave this thing
             newImagePortrait  = [self resizeImage:aImage width:600.0f height:900.0f];
             
             
             
             }else if(aImage.size.width>aImage.size.height){
             // PERFECT! This is the way we want it!
             //- (UIImage *)resizeImage:(UIImage *)original width:(CGFloat)width height:(CGFloat)height
             newImageLandscape  = [self resizeImage:aImage width:900.0f height:600.0f];
             
             }else{
             
             // UH-OH! This is odd ... perfect square? Fishy business ...
             return;
             
             }
             */
            
            
            UIImage *bImage;
            
            
            
            CGSize smallSize = CGSizeMake(100.0f, 150.0f);// [[predefDim objectForKey: @"smallSize"] CGSizeValue];
            CGSize mediumSize = CGSizeMake(200.0f, 300.0f);//[[predefDim objectForKey: @"mediumSize"] CGSizeValue];
            CGSize largeSize =  CGSizeMake(400.0f, 600.0f);//[[predefDim objectForKey: @"largeSize"] CGSizeValue];
            
            switch (aImage.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    smallSize = CGSizeMake(smallSize.height, smallSize.width);
                    mediumSize = CGSizeMake(mediumSize.height, mediumSize.width);
                    largeSize = CGSizeMake(largeSize.height, largeSize.width);
                    break;
                default:
                    break;
            }
            
            CGSize newSize;
            switch (size) {
                case kResizeSmall:
                    newSize = smallSize;
                    break;
                case kResizeMedium:
                    newSize = mediumSize;
                    break;
                case kResizeLarge:
                    newSize = largeSize;
                    break;
                default:
                    newSize = aImage.size;
                    break;
            }
            
            switch (self.photo.imageOrientation) {
                case UIImageOrientationUp:
                case UIImageOrientationUpMirrored:
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                    self.orientation = @"landscape";
                    break;
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    self.orientation = @"portrait"; // portrait
                    break;
                default:
                    self.orientation = @"portrait";
            }
            
            
            
            // Let's fix this portrait junk - LANDSCAPE ONLY!
            if ([self.orientation isEqualToString:@"portrait"]) {
                
                
                UIImage *newImagePortrait = self.photo;
                UIImage *newImageLandscape = [[UIImage alloc] initWithCGImage: newImagePortrait.CGImage scale:1.0 orientation:UIImageOrientationUp];
                
                aImage = newImageLandscape;
                
                self.orientation = @"landscape";
                /*
                 //CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
                 //CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
                 * /
                 
                 CGFloat degrees = -90.0f;
                 // calculate the size of the rotated view's containing box for our drawing space
                 UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,aImage.size.width, aImage.size.height)];
                 CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
                 rotatedViewBox.transform = t;
                 CGSize rotatedSize = rotatedViewBox.frame.size;
                 [rotatedViewBox release];
                 
                 // Create the bitmap context
                 UIGraphicsBeginImageContext(rotatedSize);
                 CGContextRef bitmap = UIGraphicsGetCurrentContext();
                 
                 // Move the origin to the middle of the image so we will rotate and scale around the center.
                 CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
                 
                 //   // Rotate the image context
                 CGContextRotateCTM(bitmap, degrees * M_PI / 180);
                 
                 // Now, draw the rotated/scaled image into the context
                 CGContextScaleCTM(bitmap, 1.0, -1.0);
                 CGContextDrawImage(bitmap, CGRectMake(-aImage.size.width / 2, -aImage.size.height / 2, aImage.size.width, aImage.size.height), [aImage CGImage]);
                 
                 UIImage *cImage = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
                 
                 bImage = cImage;
                 */
                
                
                
                
                
                
                
                
            }
            
            
            
            //The dimensions of the image, taking orientation into account.
            CGSize originalSize = CGSizeMake(aImage.size.width, aImage.size.height);
            
            UIImage *resizedImage = aImage;
            if(aImage.size.width > newSize.width || aImage.size.height > newSize.height){
                resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:newSize interpolationQuality:kCGInterpolationHigh];
            }else{
                resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:originalSize interpolationQuality:kCGInterpolationHigh];
            }
            
            
            
            NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.90);
            UIImage *imageThumbnail = [aImage thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
            
            //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            //NSData *imageData = UIImagePNGRepresentation(pickedImage);
            
            [self setFilebase:(NSString*)[formatter stringFromDate:[NSDate date]]];
            NSString *photoponPhotoFilename = [[NSString alloc] initWithFormat:@"%@.jpg", self.filebase];
            [self setFilename:photoponPhotoFilename]; // default filename - suffix "-large" since we'll always use the largest copy as our template
            
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
            [self setLocalURL:path];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:path contents:imageData attributes:nil];
            
            
            /*
             NSError * errors = nil;
             [imageData writeToFile:path options:NSDataWritingAtomic error:&errors];
             
             if (errors != nil) {
             NSLog(@"Error: %@", errors);
             return;
             }
             */
            
            
            self.creationDate   = [NSDate date];
            self.filesize       = [NSNumber numberWithInt:(imageData.length/1024)];
            [self setMediaType:[NSString stringWithFormat:@"%@", @"image/jpeg"]];
            self.thumbnail      = UIImageJPEGRepresentation(imageThumbnail, 0.90);
            self.width          = [NSNumber numberWithInt:resizedImage.size.width];
            self.height         = [NSNumber numberWithInt:resizedImage.size.height];
            
            
            
            //X [self.photoponNewPhotoponHUDViewController hideBackdropView];
            
            
            //MediaResize size = kResizeLarge;
            
            //UIImage *aImage = self.photo;
            
            /*
             
             CGSize smallSize = CGSizeMake(290.0f, 194.0f);// [[predefDim objectForKey: @"smallSize"] CGSizeValue];
             CGSize mediumSize = CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"mediumSize"] CGSizeValue];
             CGSize largeSize =  CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"largeSize"] CGSizeValue];
             switch (aImage.imageOrientation) {
             case UIImageOrientationLeft:
             case UIImageOrientationLeftMirrored:
             case UIImageOrientationRight:
             case UIImageOrientationRightMirrored:
             smallSize = CGSizeMake(smallSize.height, smallSize.width);
             mediumSize = CGSizeMake(mediumSize.height, mediumSize.width);
             largeSize = CGSizeMake(largeSize.height, largeSize.width);
             break;
             default:
             break;
             }
             
             CGSize newSize;
             switch (size) {
             case kResizeSmall:
             newSize = smallSize;
             break;
             case kResizeMedium:
             newSize = mediumSize;
             break;
             case kResizeLarge:
             newSize = largeSize;
             break;
             default:
             newSize = aImage.size;
             break;
             }
             / *
             switch (aImage.imageOrientation) {
             case UIImageOrientationUp:
             case UIImageOrientationUpMirrored:
             case UIImageOrientationDown:
             case UIImageOrientationDownMirrored:
             //    self.orientation = @"landscape";
             break;
             case UIImageOrientationLeft:
             case UIImageOrientationLeftMirrored:
             case UIImageOrientationRight:
             case UIImageOrientationRightMirrored:
             //   self.orientation = @"portrait";
             break;
             default:
             //    self.orientation = @"portrait";
             }
             */
            //The dimensions of the image, taking orientation into account.
            
            
            //CGSize originalSize = CGSizeMake(aImage.size.width, aImage.size.height);
            
            /*
             //UIImage *resizedImage = aImage;
             if(aImage.size.width > newSize.width || aImage.size.height > newSize.height)
             resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
             bounds:newSize
             interpolationQuality:kCGInterpolationHigh];
             else
             resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
             bounds:originalSize
             interpolationQuality:kCGInterpolationHigh];
             
             
             NSData *imageData = UIImageJPEGRepresentation(self.photo, 0.90);
             
             
             //self.binData = [NSData dataWithData:imageData];
             
             UIImage *imageThumbnail = [self.photo thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
             
             
             
             //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
             //NSData *imageData = UIImagePNGRepresentation(pickedImage);
             
             //NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
             //NSString *path = [documentsDirectory stringByAppendingPathComponent:@"imageName.png"];
             
             //if (error != nil) {
             //  NSLog(@"Error: %@", error);
             //  return;
             //}
             
             
             
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString *documentsDirectory = [paths objectAtIndex:0];
             
             NSString *photoponPhotoFilename = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
             [formatter release]; formatter = nil;
             NSString *filepath = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
             
             NSFileManager *fileManager = [NSFileManager defaultManager];
             [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
             
             
             NSError * error = nil;
             //[imageData writeToFile:filepath options:NSDataWritingAtomic error:&error];
             
             if(error){
             UIAlertView *alert;
             
             alert = [[UIAlertView alloc] initWithTitle:@"Success"
             message:[error description]
             delegate:self cancelButtonTitle:@"Ok"
             otherButtonTitles:nil];
             
             
             
             [alert show];
             [alert release];
             
             }
             
             
             
             self.creationDate = [NSDate date];
             self.filename = photoponPhotoFilename;
             self.localURL = filepath;
             self.filesize = [NSNumber numberWithInt:(imageData.length/1024)];
             self.mediaType = @"image";
             self.thumbnail = UIImageJPEGRepresentation(imageThumbnail, 0.90);
             self.width = [NSNumber numberWithInt:self.photo.size.width];
             self.height = [NSNumber numberWithInt:self.photo.size.height];
             
             
             
             
             
             
             
             
             
             
             
             
             / *
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
             
             //UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
             
             if (self.photoPicker.sourceType == UIImagePickerControllerSourceTypeCamera){
             
             UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
             
             MediaResize newSize = kResizeLarge;
             
             [photoponImageModel_ setPhotoponImage:self.photo withSize:newSize];
             [self.photoponMediaModel setImage:self.photoponImageModel];
             
             }
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
             
             
             / *
             Blog *blog = [[Blog alloc] init];
             if (post == nil) {
             post = [PhotoponPost newDraftForBlog:blog];
             }
             
             if (post.media && [post.media count] > 0) {
             media = [post.media anyObject];
             } else {
             //media = [PhotoponGalleryMedia newMediaForPost:post];
             int resizePreference = 0;
             if([[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"] != nil)
             resizePreference = [[[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"] intValue];
             
             MediaResize newSize = kResizeLarge;
             switch (resizePreference) {
             case 1:
             newSize = kResizeSmall;
             break;
             case 2:
             newSize = kResizeMedium;
             break;
             case 4:
             newSize = kResizeOriginal;
             break;
             
             }
             }
             */
            
            //int resizePreference = 0;
            
            //MediaResize newSize = kResizeLarge;
            
            /*
             switch (resizePreference) {
             case 1:
             newSize = kResizeSmall;
             break;
             case 2:
             newSize = kResizeMedium;
             break;
             case 4:
             newSize = kResizeOriginal;
             break;
             */
            
            //self.photo = [[UIImage alloc] init];
            
            //[photoponImageModel_ setPhotoponImage:self.photo withSize:newSize];
            //[self.photoponMediaModel setImage:self.photoponImageModel];
            
            //}
            
            
            //[media save];
            //[media release];
            //[postButtonItem setEnabled:YES];
        });
    });
}

- (void)saveImageTest {
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        //UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            
            
            MediaResize size = kResizeLarge;
            
            UIImage *aImage = self.photo;
            /*
             
             
             if (aImage.size.height>aImage.size.width) {
             // rotate and resave this thing
             newImagePortrait  = [self resizeImage:aImage width:600.0f height:900.0f];
             
             
             
             }else if(aImage.size.width>aImage.size.height){
             // PERFECT! This is the way we want it!
             //- (UIImage *)resizeImage:(UIImage *)original width:(CGFloat)width height:(CGFloat)height
             newImageLandscape  = [self resizeImage:aImage width:900.0f height:600.0f];
             
             }else{
             
             // UH-OH! This is odd ... perfect square? Fishy business ...
             return;
             
             }
             */
            
            
            UIImage *bImage;
            
            
            
            CGSize smallSize = CGSizeMake(100.0f, 150.0f);// [[predefDim objectForKey: @"smallSize"] CGSizeValue];
            CGSize mediumSize = CGSizeMake(200.0f, 300.0f);//[[predefDim objectForKey: @"mediumSize"] CGSizeValue];
            CGSize largeSize =  CGSizeMake(400.0f, 600.0f);//[[predefDim objectForKey: @"largeSize"] CGSizeValue];
            
            switch (aImage.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    smallSize = CGSizeMake(smallSize.height, smallSize.width);
                    mediumSize = CGSizeMake(mediumSize.height, mediumSize.width);
                    largeSize = CGSizeMake(largeSize.height, largeSize.width);
                    break;
                default:
                    break;
            }
            
            CGSize newSize;
            switch (size) {
                case kResizeSmall:
                    newSize = smallSize;
                    break;
                case kResizeMedium:
                    newSize = mediumSize;
                    break;
                case kResizeLarge:
                    newSize = largeSize;
                    break;
                default:
                    newSize = aImage.size;
                    break;
            }
            
            switch (self.photo.imageOrientation) {
                case UIImageOrientationUp:
                case UIImageOrientationUpMirrored:
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                    self.orientation = @"landscape";
                    break;
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    self.orientation = @"portrait"; // portrait
                    break;
                default:
                    self.orientation = @"portrait";
            }
            
            
            
            // Let's fix this portrait junk - LANDSCAPE ONLY!
            if (self.orientation==@"portrait") {
                
                
                UIImage *newImagePortrait = self.photo;
                UIImage *newImageLandscape = [[UIImage alloc] initWithCGImage: newImagePortrait.CGImage scale:1.0 orientation:UIImageOrientationUp];
                
                aImage = newImageLandscape;
                
                self.orientation = @"landscape";
                /*
                 //CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
                 //CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
                 * /
                 
                 CGFloat degrees = -90.0f;
                 // calculate the size of the rotated view's containing box for our drawing space
                 UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,aImage.size.width, aImage.size.height)];
                 CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
                 rotatedViewBox.transform = t;
                 CGSize rotatedSize = rotatedViewBox.frame.size;
                 [rotatedViewBox release];
                 
                 // Create the bitmap context
                 UIGraphicsBeginImageContext(rotatedSize);
                 CGContextRef bitmap = UIGraphicsGetCurrentContext();
                 
                 // Move the origin to the middle of the image so we will rotate and scale around the center.
                 CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
                 
                 //   // Rotate the image context
                 CGContextRotateCTM(bitmap, degrees * M_PI / 180);
                 
                 // Now, draw the rotated/scaled image into the context
                 CGContextScaleCTM(bitmap, 1.0, -1.0);
                 CGContextDrawImage(bitmap, CGRectMake(-aImage.size.width / 2, -aImage.size.height / 2, aImage.size.width, aImage.size.height), [aImage CGImage]);
                 
                 UIImage *cImage = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
                 
                 bImage = cImage;
                 */
                
                
                
                
                
                
                
                
            }
            
            
            
            //The dimensions of the image, taking orientation into account.
            CGSize originalSize = CGSizeMake(aImage.size.width, aImage.size.height);
            
            UIImage *resizedImage = aImage;
            if(aImage.size.width > newSize.width || aImage.size.height > newSize.height){
                resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:newSize interpolationQuality:kCGInterpolationHigh];
            }else{
                resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:originalSize interpolationQuality:kCGInterpolationHigh];
            }
            
            
            
            NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.90);
            UIImage *imageThumbnail = [aImage thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
            
            //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            //NSData *imageData = UIImagePNGRepresentation(pickedImage);
            
            [self setFilebase:(NSString*)[formatter stringFromDate:[NSDate date]]];
            NSString *photoponPhotoFilename = [[NSString alloc] initWithFormat:@"%@.jpg", self.filebase];
            [self setFilename:photoponPhotoFilename]; // default filename - suffix "-large" since we'll always use the largest copy as our template
            
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
            [self setLocalURL:path];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:path contents:imageData attributes:nil];
            
            
            /*
             NSError * errors = nil;
             [imageData writeToFile:path options:NSDataWritingAtomic error:&errors];
             
             if (errors != nil) {
             NSLog(@"Error: %@", errors);
             return;
             }
             */
            
            
            self.creationDate   = [NSDate date];
            self.filesize       = [NSNumber numberWithInt:(imageData.length/1024)];
            [self setMediaType:[NSString stringWithFormat:@"%@", @"image/jpeg"]];
            self.thumbnail      = UIImageJPEGRepresentation(imageThumbnail, 0.90);
            self.width          = [NSNumber numberWithInt:resizedImage.size.width];
            self.height         = [NSNumber numberWithInt:resizedImage.size.height];
            
            
            
            //X [self.photoponNewPhotoponHUDViewController hideBackdropView];
            
            
            //MediaResize size = kResizeLarge;
            
            //UIImage *aImage = self.photo;
            
            /*
             
             CGSize smallSize = CGSizeMake(290.0f, 194.0f);// [[predefDim objectForKey: @"smallSize"] CGSizeValue];
             CGSize mediumSize = CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"mediumSize"] CGSizeValue];
             CGSize largeSize =  CGSizeMake(290.0f, 194.0f);//[[predefDim objectForKey: @"largeSize"] CGSizeValue];
             switch (aImage.imageOrientation) {
             case UIImageOrientationLeft:
             case UIImageOrientationLeftMirrored:
             case UIImageOrientationRight:
             case UIImageOrientationRightMirrored:
             smallSize = CGSizeMake(smallSize.height, smallSize.width);
             mediumSize = CGSizeMake(mediumSize.height, mediumSize.width);
             largeSize = CGSizeMake(largeSize.height, largeSize.width);
             break;
             default:
             break;
             }
             
             CGSize newSize;
             switch (size) {
             case kResizeSmall:
             newSize = smallSize;
             break;
             case kResizeMedium:
             newSize = mediumSize;
             break;
             case kResizeLarge:
             newSize = largeSize;
             break;
             default:
             newSize = aImage.size;
             break;
             }
             / *
             switch (aImage.imageOrientation) {
             case UIImageOrientationUp:
             case UIImageOrientationUpMirrored:
             case UIImageOrientationDown:
             case UIImageOrientationDownMirrored:
             //    self.orientation = @"landscape";
             break;
             case UIImageOrientationLeft:
             case UIImageOrientationLeftMirrored:
             case UIImageOrientationRight:
             case UIImageOrientationRightMirrored:
             //   self.orientation = @"portrait";
             break;
             default:
             //    self.orientation = @"portrait";
             }
             */
            //The dimensions of the image, taking orientation into account.
            
            
            //CGSize originalSize = CGSizeMake(aImage.size.width, aImage.size.height);
            
            /*
             //UIImage *resizedImage = aImage;
             if(aImage.size.width > newSize.width || aImage.size.height > newSize.height)
             resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
             bounds:newSize
             interpolationQuality:kCGInterpolationHigh];
             else
             resizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
             bounds:originalSize
             interpolationQuality:kCGInterpolationHigh];
             
             
             NSData *imageData = UIImageJPEGRepresentation(self.photo, 0.90);
             
             
             //self.binData = [NSData dataWithData:imageData];
             
             UIImage *imageThumbnail = [self.photo thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
             
             
             
             //UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
             //NSData *imageData = UIImagePNGRepresentation(pickedImage);
             
             //NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
             //NSString *path = [documentsDirectory stringByAppendingPathComponent:@"imageName.png"];
             
             //if (error != nil) {
             //  NSLog(@"Error: %@", error);
             //  return;
             //}
             
             
             
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString *documentsDirectory = [paths objectAtIndex:0];
             
             NSString *photoponPhotoFilename = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
             [formatter release]; formatter = nil;
             NSString *filepath = [documentsDirectory stringByAppendingPathComponent:photoponPhotoFilename];
             
             NSFileManager *fileManager = [NSFileManager defaultManager];
             [fileManager createFileAtPath:filepath contents:imageData attributes:nil];
             
             
             NSError * error = nil;
             //[imageData writeToFile:filepath options:NSDataWritingAtomic error:&error];
             
             if(error){
             UIAlertView *alert;
             
             alert = [[UIAlertView alloc] initWithTitle:@"Success"
             message:[error description]
             delegate:self cancelButtonTitle:@"Ok"
             otherButtonTitles:nil];
             
             
             
             [alert show];
             [alert release];
             
             }
             
             
             
             self.creationDate = [NSDate date];
             self.filename = photoponPhotoFilename;
             self.localURL = filepath;
             self.filesize = [NSNumber numberWithInt:(imageData.length/1024)];
             self.mediaType = @"image";
             self.thumbnail = UIImageJPEGRepresentation(imageThumbnail, 0.90);
             self.width = [NSNumber numberWithInt:self.photo.size.width];
             self.height = [NSNumber numberWithInt:self.photo.size.height];
             
             
             
             
             
             
             
             
             
             
             
             
             / *
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
             
             //UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
             
             if (self.photoPicker.sourceType == UIImagePickerControllerSourceTypeCamera){
             
             UIImageWriteToSavedPhotosAlbum(self.photo, nil, nil, nil);
             
             MediaResize newSize = kResizeLarge;
             
             [photoponImageModel_ setPhotoponImage:self.photo withSize:newSize];
             [self.photoponMediaModel setImage:self.photoponImageModel];
             
             }
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
             
             
             / *
             Blog *blog = [[Blog alloc] init];
             if (post == nil) {
             post = [PhotoponPost newDraftForBlog:blog];
             }
             
             if (post.media && [post.media count] > 0) {
             media = [post.media anyObject];
             } else {
             //media = [PhotoponGalleryMedia newMediaForPost:post];
             int resizePreference = 0;
             if([[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"] != nil)
             resizePreference = [[[NSUserDefaults standardUserDefaults] objectForKey:@"media_resize_preference"] intValue];
             
             MediaResize newSize = kResizeLarge;
             switch (resizePreference) {
             case 1:
             newSize = kResizeSmall;
             break;
             case 2:
             newSize = kResizeMedium;
             break;
             case 4:
             newSize = kResizeOriginal;
             break;
             
             }
             }
             */
            
            //int resizePreference = 0;
            
            //MediaResize newSize = kResizeLarge;
            
            /*
             switch (resizePreference) {
             case 1:
             newSize = kResizeSmall;
             break;
             case 2:
             newSize = kResizeMedium;
             break;
             case 4:
             newSize = kResizeOriginal;
             break;
             */
            
            //self.photo = [[UIImage alloc] init];
            
            //[photoponImageModel_ setPhotoponImage:self.photo withSize:newSize];
            //[self.photoponMediaModel setImage:self.photoponImageModel];
            
            //}
            
            
            //[media save];
            //[media release];
            //[postButtonItem setEnabled:YES];
        });
    });
}


- (void)uploadPhotopon: (BOOL)upload{
    
    
    
    
    
    //- (void)savePost: (BOOL)upload{
    
    //[self post];
    
    
    
    
    /*
     if( [self isMediaInUploading] ) {
     [self showMediaInUploadingalert];
     return;
     }
     //[self savePost:YES];
     */
    
    
    
    
    /*
     self.apost.postTitle = titleTextField.text;
     self.apost.content = textView.text;
     if ([self.apost.content rangeOfString:@"<!--more-->"].location != NSNotFound)
     self.apost.mt_text_more = @"";
     
     [self.view endEditing:YES];
     
     if ( self.apost.original.password != nil ) { //original post was password protected
     if ( self.apost.password == nil || [self.apost.password isEqualToString:@""] ) { //removed the password
     self.apost.password = @"";
     }
     }
     
     [self.apost.original applyRevision];
     if (upload){
     NSString *postTitle = self.apost.postTitle;
     [self.apost.original uploadWithSuccess:^{
     NSLog(@"post uploaded: %@", postTitle);
     } failure:^(NSError *error) {
     NSLog(@"post failed: %@", [error localizedDescription]);
     }];
     } else {
     [self.apost.original save];
     }
     
     [self dismissEditView];
     
     */
    
    
}

//check if there are media in uploading status
-(BOOL) isMediaPendingUpload {
    
    //-(BOOL) isMediaInUploading {
	
    
    
    
    
	BOOL isMediaPendingUpload = NO;
	/*
     NSSet *mediaFiles = self.apost.media;
     for (Media *media in mediaFiles) {
     if(media.remoteStatus == MediaRemoteStatusPushing) {
     isMediaInUploading = YES;
     break;
     }
     }
     mediaFiles = nil;
     */
	return isMediaPendingUpload;
}

-(void) showMediaPendingUploadAlert {
    
    
    
    
    
    
    
    /*
     // (just like showProgress and hideProgress but for uploading photopons
     // just make a window like the model view controller or simply the plain "showProgress" and "hideProgress" table controller methods will suffice
     //-(void) showMediaInUploadingalert {
     
     
     //the post is using the network connection and cannot be stoped, show a message to the user
     UIAlertView *photoponIsCurrentlyBusy = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"Info alert title")
     message:NSLocalizedString(@"A Media file is currently in uploading. Please try later.", @"")
     delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
     [photoponIsCurrentlyBusy show];
     [photoponIsCurrentlyBusy release];
     */
    
}

-(void)photoponDidWriteToSavedPhotosAlbum:(id)sender{
    
    
    NSLog(@"|");
    NSLog(@"|");
    NSLog(@"----------->");
    NSLog(@"PhotoponShareViewController :: photoponDidWriteToSavedPhotosAlbum");
    NSLog(@"----------->");
    NSLog(@"|");
    NSLog(@"|");
    
}



-(void) showCam{
    
}

-(void) hideCam{
    
}


//-(void) showLiveCameraView;
//-(void) hideLiveCameraView;

-(void) showCameraLibraryView{
    
}

-(void) hideCameraLibraryView{
    
}

//- (void)postPhotoponWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
//- (void)uploadMediaWithSuccess;

- (UIImage *)fixImageOrientation:(UIImage *)img{
    
}












































































































/*
 -(void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
 
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
 NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
 
 [FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
 
 [aPicker dismissModalViewControllerAnimated:YES];
 
 UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
 
 //image = [image croppedImage:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
 image = [image croppedImage:[[info valueForKey:UIImagePickerControllerCropRect] CGRectValue]];
 [self setPhoto:image];
 
 self.photoponBtnProfilePhotoImage = self.photo;
 [self.profilePhoto.imageView setImage:self.photo];
 
 [self saveImage];
 
 }
 
 
 
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
 // TODO: make this all threaded?
 // crop the image to the bounds provided
 self.photo = [info objectForKey:UIImagePickerControllerOriginalImage];
 
 self.photoponBtnProfilePhotoImage = self.photo;
 
 NSLog(@"orig image size: %@", [[NSValue valueWithCGSize:img.size] description]);
 
 // save the image, only if it's a newly taken image:
 if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
 UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
 }
 
 // self.image_View.image = img;
 // self.image_View.contentMode = UIViewContentModeScaleAspectFit;
 
 NSLog(@"Picker has returned");
 [self dismissViewControllerAnimated:YES
 completion:^{
 ModalViewController *sampleView = [[ModalViewController alloc] init];
 [self presentModalViewController:sampleView animated:YES];
 }];
 }
 
 */


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     if (!mediaPicker) {
     self.mediaPicker = [[[UIImagePickerController alloc] init] retain];
     [mediaPicker setDelegate:self];
     mediaPicker.allowsEditing = YES;
     }*/
    
    
    
    
    
    if (buttonIndex == 0) {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        //[actionSheet release];
        return;
    }
    
    [self presentModalViewController:self.mediaPicker animated:YES];
    
    //[actionSheet release];
    
}


- (IBAction)saveAction:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Saving photo to library\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *profilePic = [UIImage imageNamed:@"PhotoponProfilePhoto.png"];
        UIImageWriteToSavedPhotosAlbum(profilePic,self,@selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
        
        //[alert dismissWithClickedButtonIndex:0 animated:YES];
        
    });
}
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (error) {
        // Message user, unable to save image
    } else {
        // Image saved to album
    }
}

//

- (IBAction)profilePhotoHandler:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /*
     NSLog(@"----> ");
     NSLog(@"PhotoponProfileSettingsViewController :: profilePhotoHandler");
     NSLog(@"----> ");
     */
    
    
    
    
    
    self.mediaPicker = [[UIImagePickerController alloc] init];
    [mediaPicker setDelegate:self];
    mediaPicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to set your picture?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } else {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.mediaPicker animated:YES];
    }
}




















////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////


- (void)photoponNewImage:(UIImage *)photoponNewImage hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    
    
    NSLog(@"|");
    NSLog(@"|");
    NSLog(@"----------->");
    NSLog(@"PhotoponShareViewController :: photoponNewImage :: hasBeenSavedInPhotoAlbumWithError");
    NSLog(@"----------->");
    NSLog(@"|");
    NSLog(@"|");
    
    if (error) {
        
        
        // Do anything needed to handle the error or display it to the user
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
    }
}

- (void)showProgress:(NSString*)theProgress
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //progressAlert = [[PhotoponProgressHUD alloc] initWithLabel:[NSString stringWithString:theProgress]];
	//[progressAlert show];
    
    
    
}

- (void)hideProgress
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //[progressAlert dismissWithClickedButtonIndex:0 animated:YES];
    //[progressAlert release], progressAlert = nil;
    
}






























#pragma mark - QuickPhoto
- (void)mediaDidUploadSuccessfully:(NSNotification *)notification {
    
    //[FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
    
    
    
    
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"mediaDidUploadSuccessfully", @"")
     message:NSLocalizedString(@"Yes.", @"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */
    
    
    
    
    
    //self.content = [NSString stringWithFormat:@"%@\n\n%@", [self html], self.content];
    //[uploadController.view removeFromSuperview];
    //[uploadController release], uploadController = nil;
    //[self uploadWithSuccess:nil failure:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)mediaUploadFailed:(NSNotification *)notification {
    
    
    appDelegate.isUploadingPost = NO;
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Photopon Photo Failed", @"")
     message:NSLocalizedString(@"Sorry, the photopon upload failed.", @"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)uploadWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    //[self postPhotoponWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure];
    
}





/*
 #pragma mark - Table view delegate
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (!indexPath.section) {
 self.viewDeckController.leftLedge = MAX(indexPath.row*44,10);
 }
 else {
 self.viewDeckController.rightLedge = MAX(indexPath.row*44,10);
 }
 }
 */





-(void)postFileToPHP{
    
    
    /*
     
     
     NSData *imageData = UIImagePNGRepresentation(delegate.dataBean.image);
     NSString *urlString = [NSString stringWithFormat:@"%@test.php", delegate.dataBean.hosterURL];
     
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:urlString]];
     [request setHTTPMethod:@"POST"];
     
     NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
     [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
     
     NSMutableData *body = [NSMutableData data];
     [body appendData:[[NSString stringWithFormat:@"rn--%@rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"test.png\"rn"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-streamrnrn"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[NSData dataWithData:imageData]];
     [body appendData:[[NSString stringWithFormat:@"rn--%@--rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [request setHTTPBody:body];
     
     NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     
     NSLog([NSString stringWithFormat:@"Image Return String: %@", returnString]);
     
     
     */
}

- (void)uploadMediaWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    
    //[self save];
    self.progress = 0.0f;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     
     
     NSAutoreleasePool *pool = [NSAutoreleasePool new];
     [self setFooterText:@"Creating Account..."];
     AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
     //[api callMethod:@"bp.updateProfileStatus"
     [api callMethod:@"bp.registerNewUser"
     parameters:[NSArray arrayWithObjects:username, password, [NSArray arrayWithObjects: email, firstname, lastname, nil], nil]
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     
     //NSString *status = [[NSString alloc] init];
     //status = @"";
     NSDictionary *returnData = [responseObject retain];
     
     
     / *
     NSArray *errors = [NSArray arrayWithObjects:@"field_1", @"password", @"field_5", @"field_6", @"field_7", nil];
     for (id e in errors) {
     if ([returnData valueForKey:e])
     status = [returnData valueForKey:e];
     }
     
     if ([status isEqualToString:@""])
     status = @"Success";
     
     if (status != @"Success") {
     [self setFooterText:@"Error"];
     [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
     } else {* /
     [self saveLoginData];
     
     // You're now ready to pull money out of thin air and make your first photopon. Have fun!
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Awesome!", @"")
     message:NSLocalizedString(@"You're officially among the first to discover the next-generation coupon!", @"")
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     
     alert.tag = 10;
     [alert autorelease];
     [alert show];
     [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
     //}
     
     NSLog(@"--------->");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
     NSLog(@"CREATE ACCOUNT SUCCESS!!!");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"--------->");
     
     [self setFooterText:@"Success! Welcome to Photopon!"];
     
     //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
     
     [appDelegate.photoponSplashScreenViewController dismissViewControllerAnimated:YES completion:nil];
     
     [appDelegate.navigationController popViewControllerAnimated:YES];
     
     //[appDelegate showLoggedIn];
     
     
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     WPFLog(@"Failed registering account: %@", [error localizedDescription]);
     [self setFooterText:[error localizedDescription]];
     [self setButtonText:NSLocalizedString(@"Create Photopon Account", @"")];
     
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Well, that failed miserably", @"")
     message:[error localizedDescription]
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     alertView.tag = 20;
     [alertView show];
     [alertView release];
     [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
     
     
     NSLog(@"--------->");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
     NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"--------->");
     
     [self setFooterText:@"FAILED AGAIN! SORRY SUCKER!!"];
     
     
     
     }];
     
     [pool release];
     
     
     
     */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     
     
     $photopon_username 			= $this->escape( $args[0] );
     $photopon_password 			= $this->escape( $args[1] );
     $photopon_meta	 				= $args[2];
     
     $link_thumb					= $photopon_meta['thumb'];
     $link_med 						= $photopon_meta['mid'];
     $link_large			 		= $photopon_meta['larger'];
     
     $photopon_headline				= $photopon_meta['headline'];
     $photopon_offer_info			= $photopon_meta['offer_info'];
     $photopon_media_type			= $photopon_meta['media_type'];
     
     $file['file']					= $photopon_meta['file'];
     
     $file['name'] 					= $file['file']['name'];
     $file['type'] 					= $file['file']['type'];
     $file['tmp_name'] 				= $file['file']['tmp_name'];
     $file['error'] 				= $file['file']['error'];
     $file['size'] 					= $file['file']['size'];
     * /
     
     
     
     
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
     
     NSString *mimeType = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
     
     
     NSDictionary *filePostData = [NSDictionary dictionaryWithObjectsAndKeys:
     
     self.filename,                                                        @"name",
     mimeType,                                                             @"type",
     [NSString stringWithString:@"p_tmp"],                                 @"tmp_name",// dir only - filename gets added on server-side
     [NSNumber numberWithInteger:0],                                       @"error",
     self.filesize,                                                        @"size",
     [NSInputStream inputStreamWithFileAtPath:self.localURL],              @"bits",
     
     nil];
     
     
     
     NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
     
     
     [NSString stringWithFormat:@"%@", self.filebase],               @"file_base",
     [NSString stringWithFormat:@"%@-thumb.jpg", self.filebase],     @"thumb",
     [NSString stringWithFormat:@"%@-mid.jpg", self.filebase],       @"mid",
     [NSString stringWithFormat:@"%@-large.jpg", self.filebase],     @"larger",
     
     self.photoponMediaModel.caption,                                @"headline",
     self.photoponMediaModel.coupon.details,                         @"offer_info",
     [NSString stringWithString:@"photo"],                           @"media_type",
     
     filePostData,                                                   @"file",
     
     nil];
     
     
     NSArray *parameters = [appDelegate getXMLRPCArgsWithExtra:object];
     
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusProcessing;
     
     / *
     
     
     // Create the request asynchronously
     // TODO: use streaming to avoid processing on memory
     NSMutableURLRequest *request = [appDelegate.api requestWithMethod:@"bp.uploadPhotopon" parameters:parameters];
     
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     
     
     AFHTTPRequestOperation *operation = [appDelegate.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *response = (NSDictionary *)responseObject;
     if([response objectForKey:@"videopress_shortcode"] != nil)
     self.shortcode = [response objectForKey:@"videopress_shortcode"];
     
     if([response objectForKey:@"url"] != nil)
     self.remoteURL = [response objectForKey:@"url"];
     
     if ([response objectForKey:@"id"] != nil) {
     self.mediaID = [[response objectForKey:@"id"] numericValue];
     }
     
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
     [_uploadOperation release]; _uploadOperation = nil;
     //if (success) success();
     
     if([self.mediaType isEqualToString:@"video"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
     object:self
     userInfo:response];
     } else {
     [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
     object:self
     userInfo:response];
     }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
     [_uploadOperation release]; _uploadOperation = nil;
     //if (failure) failure(error);
     }];
     [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
     });
     }];
     _uploadOperation = [operation retain];
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
     [appDelegate.api enqueueHTTPRequestOperation:operation];
     
     
     
     */
    
    
    
    /*
     NSMutableArray *pComRequestArray = [NSMutableArray arrayWithObjects:
     self.filebase,
     [NSString stringWithFormat:@"%@_thumb.jpg", self.filebase],
     [NSString stringWithFormat:@"%@_mid.jpg", self.filebase],
     [NSString stringWithFormat:@"%@_large.jpg", self.filebase],
     self.photoponMediaModel.caption,
     self.photoponMediaModel.coupon.details,
     [NSString stringWithString:@"photo"],
     self.filename,
     self.mediaType,
     [NSString stringWithString:@""],    // dir only - filename gets added on server-side
     (NSString *)[NSNumber numberWithInteger:0],
     [NSString stringWithFormat:@"%i", self.filesize],
     [NSInputStream inputStreamWithFileAtPath: self.localURL],
     self.localURL,
     nil];
     */
    
    NSLog(@"-");
    NSLog(@"-");
    NSLog(@"----------->    here 1");
    NSLog(@"-");
    NSLog(@"-");
    
    NSString *mimeType  = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
    
    NSLog(@"-");
    NSLog(@"-");
    NSLog(@"----------->    here 2");
    NSLog(@"-");
    NSLog(@"-");
    
    
    //NSString *tmpName   = [[[NSString alloc] initWithString:self.filename] retain];
    //NSString *tmpName   = [[[NSString alloc] initWithFormat:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/%@", self.filename] retain];
    
    NSString *tmpName   = [[NSString alloc] initWithFormat:@"/tmp/%@", self.filename];
    
    NSLog(@"-");
    NSLog(@"-");
    NSLog(@"----------->    here 3");
    NSLog(@"-");
    NSLog(@"-");
    
    //NSString *tmpName   = [[[NSString alloc] initWithString:@"/tmp"] retain];
    //NSString *tmpName   = [[[NSString alloc] initWithString:@"/var/www/vhosts/www.placepon.com/httpdocs/core/wp-content/uploads/"] retain];
    
    
    NSDictionary *pComRequestArray = [NSDictionary dictionaryWithObjectsAndKeys:
                                      mimeType, @"type",
                                      self.filename, @"name",
                                      tmpName, @"tmp_name",
                                      self.filesize, @"size",
                                      [NSNumber numberWithInteger:0], @"error",
                                      [NSInputStream inputStreamWithFileAtPath:self.localURL], @"bits",
                                      nil];
    
    NSLog(@"-");
    NSLog(@"-");
    NSLog(@"----------->    here 4");
    NSLog(@"-");
    NSLog(@"-");
    
    
    /*
     NSArray *paramSignupCredentialsArray = [[[NSArray alloc] initWithObjects:self.username, self.password, nil] autorelease];//, [NSArray arrayWithObjects: email, firstname, lastname, facebookid, sex, birthday];
     NSArray *paramSignupAdditionalArray = [[[NSArray alloc] initWithObjects:self.email, self.firstname, self.lastname, self.facebookid, self.sex, self.birthday, nil] autorelease];
     
     NSMutableArray *parameters = [[[NSMutableArray alloc] initWithArray:paramSignupCredentialsArray] autorelease];
     
     [parameters addObject:paramSignupAdditionalArray];
     
     NSArray *parametersFinal = [[[NSArray alloc] initWithArray:parameters] retain];
     
     
     //[self.pComApi photoponRegisterUserWithInfo: parametersFinal withSuccess:^(NSArray *responseInfo)
     
     [self.pComApi photoponRegisterUserWithInfo: parametersFinal withSuccess:^(NSArray *responseInfo) {
     */
    
    
    
    
    
    appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    NSArray *parameters = [[NSArray alloc] initWithArray:[appDelegate.pComApi getXMLRPCArgsWithExtra:pComRequestArray]];
    
    NSLog(@"-");
    NSLog(@"-");
    NSLog(@"----------->    here 5");
    NSLog(@"-");
    NSLog(@"-");
    
    
    [self setRemoteStatus:PhotoponModelRemoteStatusProcessing];
    
    NSLog(@"-");
    NSLog(@"-");
    NSLog(@"----------->    here 6");
    NSLog(@"-");
    NSLog(@"-");
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            ", self, NSStringFromSelector(_cmd));
    NSLog(@"-|");
    NSLog(@"-|");
    NSLog(@"dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {");
    NSLog(@"-|");
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
        
        
        //getMyGallery
        WPXMLRPCClient *api = [WPXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
        
        NSMutableURLRequest *request = [api requestWithMethod:@"bp.uploadProfilePhoto" parameters:parameters];
        
        //[appDelegate.photoponTabBarViewController showPhotoponUploadProgressBar];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            ", self, NSStringFromSelector(_cmd));
            NSLog(@"-|");
            NSLog(@"-|");
            NSLog(@"dispatch_async(dispatch_get_main_queue(), ^(void) {");
            NSLog(@"-|");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            //X [self.photoponNewPhotoponHUDViewController showUploadProgress:uploadController.photoponProgressBar];
            
            AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            ", self, NSStringFromSelector(_cmd));
                NSLog(@"-|");
                NSLog(@"-|");
                NSLog(@"AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:....");
                NSLog(@"        SUCCESS SUCCESS SUCCESS ");
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
                
                NSDictionary *response = (NSDictionary *)responseObject;
                //if([response objectForKey:@"videopress_shortcode"] != nil)
                //self.shortcode = [response objectForKey:@"videopress_shortcode"];
                
                if(([response objectForKey:@"confirmation"] != nil) && ([response objectForKey:@"confirmation"]) ){
                    
                    // [self close];
                    
                    /*
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"Confirmed! Upload Successful!", @"")
                     message:[response objectForKey:@"message"]
                     delegate:self
                     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                     alertView.tag = 20;
                     [alertView show];
                     [alertView release];
                     */
                    
                    
                }else {
                    
                    /*
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"NOT CONFIRMED! Upload Successful!", @"")
                     message:[response objectForKey:@"message"]
                     delegate:self
                     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                     alertView.tag = 20;
                     [alertView show];
                     [alertView release];
                     */
                    
                    
                }
                /*
                 //self.remoteURL = [response objectForKey:@"url"];
                 
                 if ([response objectForKey:@"id"] != nil) {
                 //self.mediaID = [[response objectForKey:@"id"] numericValue];
                 }
                 
                 self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
                 [_uploadOperation release]; _uploadOperation = nil;
                 if (success) success();
                 
                 / *
                 if([self.mediaType isEqualToString:@"video"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
                 object:self
                 userInfo:response];
                 } else {
                 */
                [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
                                                                    object:self
                                                                  userInfo:response];
                //}
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            ", self, NSStringFromSelector(_cmd));
                NSLog(@"-|");
                NSLog(@"-|");
                NSLog(@"AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:....");
                NSLog(@"        FAILURE FAILURE FAILURE ");
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                //X [self.photoponNewPhotoponHUDViewController hideUploadProgress];
                
                self.remoteStatus = PhotoponModelRemoteStatusFailed;
                //X [_uploadOperation release]; _uploadOperation = nil;
                if (failure) failure(error);
            }];
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                NSLog(@"%@ :: %@            ", self, NSStringFromSelector(_cmd));
                NSLog(@"-|");
                NSLog(@"-|");
                NSLog(@"[operation setUploadProgressBlock:^(NSInteger bytesWritten ...");
                NSLog(@"        ");
                NSLog(@"        ");
                NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    NSLog(@"%@ :: %@            ", self, NSStringFromSelector(_cmd));
                    NSLog(@"-|");
                    NSLog(@"-|");
                    NSLog(@"[operation setUploadProgressBlock:^(NSInteger bytesWritten ...");
                    NSLog(@"        ");
                    NSLog(@"        ");
                    NSLog(@"dispatch_async(dispatch_get_main_queue(), ^(void) {");
                    NSLog(@"        ");
                    NSLog(@"        ");
                    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                    
                    self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                    //X [self.photoponNewPhotoponHUDViewController updateUploadProgress:self.progress];
                    
                });
            }];
            //X _uploadOperation = [operation retain];
            self.remoteStatus = PhotoponModelRemoteStatusPushing;
            [api enqueueHTTPRequestOperation:operation];
        });
    });
    
    
    
    
    
    
    
    //AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
    /*
     [api callMethod:@"bp.uploadPhotopon" //@"wp.uploadFile"
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     
     [FileLogger log:@"<uploadMediaWithSuccess> ::      dispatch_async(dispatch_get_main_queue()    ::      SUCCESS BLOCK!!!"];
     
     
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:    NSLocalizedString(@"Upload Successful!", @"")
     message:@"Uploaded"
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     alertView.tag = 20;
     [alertView show];
     [alertView release];
     
     
     
     
     
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     
     [FileLogger log:@"<uploadMediaWithSuccess> ::      dispatch_async(dispatch_get_main_queue()    ::      FAIL BLOCK!!!"];
     
     UIAlertView *alertView = [[UIAlertView alloc]     initWithTitle:NSLocalizedString(@"Upload failed", @"")
     message:[error localizedDescription]
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     alertView.tag = 20;
     [alertView show];
     [alertView release];
     //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
     
     
     NSLog(@"--------->");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
     NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"--------->");
     
     
     
     
     }];
     
     [FileLogger log:@"<uploadMediaWithSuccess> ::      dispatch_async(dispatch_get_main_queue(), ^(void)  <------  END STATEMENT  ----->"];
     
     / *
     [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
     });
     }];
     _uploadOperation = [operation retain];
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
     [appDelegate.api enqueueHTTPRequestOperation:operation];
     */
    
    //[pool release];
    
    //});
    //  });
    
    
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
     
     NSString *mimeType = ([self.mediaType isEqualToString:@"video"]) ? @"video/mp4" : @"image/jpeg";
     
     
     
     
     
     
     NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
     
     self.filename, @"name",
     mimeType, @"type",
     [NSString stringWithFormat:@"tmp/%@", self.filename], @"tmp_name",
     [NSNumber numberWithInteger:0], @"error",
     self.filesize, @"size",
     
     [NSInputStream inputStreamWithFileAtPath:self.localURL], @"bits",
     
     //filePostData, @"file",
     
     
     
     nil];
     //
     
     
     NSArray *parameters = [appDelegate getXMLRPCArgsWithExtra:object];
     
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusProcessing;
     
     
     
     
     // Create the request asynchronously
     // TODO: use streaming to avoid processing on memory
     NSMutableURLRequest *request = [appDelegate.api requestWithMethod:@"bp.uploadPhotopon" parameters:parameters];
     
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     
     
     AFHTTPRequestOperation *operation = [appDelegate.api HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *response = (NSDictionary *)responseObject;
     if([response objectForKey:@"videopress_shortcode"] != nil)
     self.shortcode = [response objectForKey:@"videopress_shortcode"];
     
     if([response objectForKey:@"url"] != nil)
     self.remoteURL = [response objectForKey:@"url"];
     
     if ([response objectForKey:@"id"] != nil) {
     self.mediaID = [[response objectForKey:@"id"] numericValue];
     }
     
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusSync;
     [_uploadOperation release]; _uploadOperation = nil;
     //if (success) success();
     
     if([self.mediaType isEqualToString:@"video"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:VideoUploadSuccessful
     object:self
     userInfo:response];
     } else {
     [[NSNotificationCenter defaultCenter] postNotificationName:ImageUploadSuccessful
     object:self
     userInfo:response];
     }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusFailed;
     [_uploadOperation release]; _uploadOperation = nil;
     //if (failure) failure(error);
     }];
     [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
     });
     }];
     _uploadOperation = [operation retain];
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
     [appDelegate.api enqueueHTTPRequestOperation:operation];
     
     
     
     
     / *
     
     AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:[NSString stringWithFormat: @"%@", kWPcomXMLRPCUrl]]];
     //[api callMethod:@"bp.updateProfileStatus"
     [api callMethod:@"wp.uploadFile"
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload Successful!", @"")
     message:@"Uploaded"
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     alertView.tag = 20;
     [alertView show];
     [alertView release];
     
     
     
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload failed", @"")
     message:[error localizedDescription]
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
     otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
     alertView.tag = 20;
     [alertView show];
     [alertView release];
     //[self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
     
     
     NSLog(@"--------->");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"XMLSignupViewController :: xmlrpcCreateAccount");
     NSLog(@"CREATE ACCOUNT FAILURE!!! NOOOOOO!!! DAMN IT!!! FAILED!!!");
     NSLog(@"-------------------------------------------------------------");
     NSLog(@"--------->");
     
     
     
     }];
     
     [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     self.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
     });
     }];
     _uploadOperation = [operation retain];
     self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
     [appDelegate.api enqueueHTTPRequestOperation:operation];
     * /
     
     
     });
     });
     */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //[self xmlrpcUploadWithSuccess:nil failure:nil];
}




/*
- (void)postPhotoponWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    
    NSArray *parameters = [appDelegate.pComApi getXMLRPCArgsWithExtra:[self XMLRPCDictionary]];
    self.remoteStatus = PhotoponGalleryMediaRemoteStatusPushing;
    
    NSMutableURLRequest *request = [appDelegate.api requestWithMethod:@"wp.newPost"
                                                           parameters:parameters];
    if (self.specialType != nil) {
        [request addValue:self.specialType forHTTPHeaderField:@"WP-Quick-Post"];
    }
    
    AFHTTPRequestOperation *operation = [appDelegate.pComApi HTTPRequestOperationWithRequest:request
                                                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                     if ([responseObject respondsToSelector:@selector(numericValue)]) {
                                                                                         self.postID = [responseObject numericValue];
                                                                                         self.remoteStatus = AbstractPostRemoteStatusSync;
                                                                                         // Set the temporary date until we get it from the server so it sorts properly on the list
                                                                                         //self.date_created_gmt = [DateUtils localDateToGMTDate:[NSDate date]];
                                                                                         //[self getPostWithSuccess:nil failure:nil];
                                                                                         if (success) success();
                                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUploaded" object:self];
                                                                                     } else if (failure) {
                                                                                         self.remoteStatus = AbstractPostRemoteStatusFailed;
                                                                                         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Invalid value returned for new post: %@", responseObject] forKey:NSLocalizedDescriptionKey];
                                                                                         NSError *error = [NSError errorWithDomain:@"org.wordpress.iphone" code:0 userInfo:userInfo];
                                                                                         failure(error);
                                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUploadFailed" object:self];
                                                                                     }
                                                                                     
                                                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                     self.remoteStatus = AbstractPostRemoteStatusFailed;
                                                                                     if (failure) failure(error);
                                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUploadFailed" object:self];
                                                                                 }];
    [appDelegate.api enqueueHTTPRequestOperation:operation];
    
    
}

*/


/* Used in Custom Dimensions Resize */
- (UIImage *)resizeImage:(UIImage *)original width:(CGFloat)width height:(CGFloat)height {
	UIImage *resizedImage = original;
	if(currentImage.size.width > width || currentImage.size.height > height) {
		// Resize the image using the selected dimensions
		resizedImage = [original resizedImageWithContentMode:UIViewContentModeScaleAspectFit
													  bounds:CGSizeMake(width, height)
										interpolationQuality:kCGInterpolationHigh];
	} else {
		//use the original dimension
		resizedImage = [original resizedImageWithContentMode:UIViewContentModeScaleAspectFit
													  bounds:CGSizeMake(currentImage.size.width, currentImage.size.height)
										interpolationQuality:kCGInterpolationHigh];
	}
	
	return resizedImage;
}



- (UIImage *)generateThumbnailFromImage:(UIImage *)theImage andSize:(CGSize)targetSize {
    return [theImage thumbnailImage:75 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
}







- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    [self setPhoto:image];
    
    self.currentImage = photo;
    
    self.photoponBtnProfilePhotoImage = image;
    
    self.profilePhoto.imageView.image = image;
    
    
    
    
    
    
    /*
     if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
     
     [self.popoverController dismissPopoverAnimated:YES];
     
     } else {
     
     [picker dismissViewControllerAnimated:YES completion:nil];
     
     }
     */
    
}
/*
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
 UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
 
 
 
 //[self saveImage:image];
 self.currentImage = image;
 
 self.profilePhotoImage = image;
 
 self.profilePhoto.imageView.image = self.currentImage;
 
 [picker dismissViewControllerAnimated:YES completion:nil];
 }
 */








/*
 -(void)dealloc{
 
 [media release];
 [photoponTabBarViewController_ release];
 [specialType release];
 [pickerContainer release];
 [content release];
 [postID release];
 [width release];
 [height release];
 [binData release];
 [mediaID release];
 [mediaType release];
 [mediaTypeName release];
 [remoteURL release];
 [localURL release];
 [shortcode release];
 [thumbnail release];
 [filename release];
 [filebase release];
 [filesize release];
 [orientation release];
 [creationDate release];
 [html release];
 [remoteStatusNumber release];
 [photoImageView release];
 [tableView release];
 [photo release];
 [photoponNewImage release];
 [photoPicker release];
 [pComApi release];
 [profilePhoto release];
 [mediaPicker release];
 
 [save release];
 
 [back release];
 
 [firstNameTextField release];
 
 [lastNameTextField release];
 
 [emailTextField release];
 
 [passwordTextField release];
 
 [formView release];
 
 [titleLabel release];
 
 
 [firstName release];
 [lastName release];
 [email release];
 [password release];
 [profilePhotoImage release];
 
 [tags release];
 [postFormat release];
 [postFormatText release];
 [categories release];
 [geolocation release];
 
 [currentImage release];
 [currentImageMetadata release];
 [currentVideo release];
 [picker release];
 
 [super dealloc];
 }
 
 */








@end
