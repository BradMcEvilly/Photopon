//
//  PhotoponComLoginViewController.m
//  Photopon
//
//  Created by Bradford McEvilly on 7/19/12.
//  Copyright (c) 2012 Photopon, Inc. All rights reserved.
//

#import "PhotoponComLoginViewController.h"
#import "UITableViewTextFieldCell.h"
#import "SFHFKeychainUtils.h"
#import "PhotoponApi.h"
#import "PhotoponComApi.h"
#import "PhotoponLogInViewController.h"
#import "PhotoponAppDelegate.h"
#import "PhotoponTabBarController.h"
#import "PhotoponUserModel.h"
#import "UIImage+Extensions.h"
#import "UIImage+Resize.h"
#import "UITableViewActivityCell.h"

@interface PhotoponComLoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSString *footerText, *buttonText;
@property (nonatomic, unsafe_unretained) BOOL isSigningIn;
@property (nonatomic, strong) PhotoponComApi *pComApi;

- (void)signIn:(id)sender;
@end

@implementation PhotoponComLoginViewController {
    UITableViewTextFieldCell *loginCell, *passwordCell;
}
@synthesize footerText, buttonText, isSigningIn, isStatsInitiated;
@synthesize delegate;
@synthesize pComApi = _pComApi;
//@synthesize tableView;
@synthesize back;
@synthesize photoponNavBar;

#pragma mark -
#pragma mark View lifecycle


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

- (void)viewDidLoad {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetMyPhotoponsSuccessfully:) name:GetMyPhotoponsSuccessful object:self];
    
    /*
    // override default image bg
    self.photoponBackgroundImageNameString = [[NSString alloc] initWithFormat:@"%@", @"Default.png"];
    self.photoponBackgroundImage = [UIImage photoponImageNamed:self.photoponBackgroundImageNameString];
    [self.photoponBackgroundImageView setImage:self.photoponBackgroundImage];
    */
    
    self.pComApi = [PhotoponComApi sharedApi];
	self.footerText = @" ";
	self.buttonText = NSLocalizedString(@"Sign In", @"");
	//self.navigationItem.title = NSLocalizedString(@"Sign In", @"");
    
	// Setup Pcom table header
	CGRect headerFrame = CGRectMake(0, 0, 320, 70);
	CGRect logoFrame = CGRectMake(60, 10, 197, 64);
	NSString *logoFile = @"PhotoponLogoStandard.png";
    
    /*
	if([[UIDevice currentDevice] platformString] == IPHONE_1G_NAMESTRING) {
		logoFile = @"PhotoponLogoStandard.png";
	}*/
	UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
	UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoFile]];
	logo.frame = logoFrame;
	[headerView addSubview:logo];
	//[logo release];
	self.tableView.tableHeaderView = headerView;
	
	if(IS_IPAD)
		self.tableView.backgroundView = nil;
    
    //	self.tableView.backgroundColor = [UIColor clearColor];
    
}

- (void)didGetMyPhotoponsSuccessfully:(NSNotification *)notification {

    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[appDelegate.photoponTabBarController loadMainFeedRemoteData];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	[super viewWillAppear:animated];
	isSigningIn = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	if(IS_IPAD == YES)
		return YES;
	else
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(section == 0)
		return 2;
	else
		return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if(section == 0)
		return footerText;
	else
		return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	UITableViewCell *cell = nil;
	
	if(indexPath.section == 1) {
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
        if(isSigningIn) {
			[activityCell.spinner startAnimating];
			self.buttonText = NSLocalizedString(@"Signing In...", @"");
		}
		else {
			[activityCell.spinner stopAnimating];
			self.buttonText = NSLocalizedString(@"Sign In", @"");
		}
		
		activityCell.textLabel.text = buttonText;
        if (isSigningIn) {
            activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            activityCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
		cell = activityCell;
	} else {		
        if ([indexPath row] == 0) {
            if (loginCell == nil) {
                loginCell = [[UITableViewTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                            reuseIdentifier:@"TextCell"];
                loginCell.textField.text = self.pComApi.username;
            }
            loginCell.textLabel.text = NSLocalizedString(@"Email", @"");
            loginCell.textField.placeholder = NSLocalizedString(@"Your email", @"");
            loginCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            loginCell.textField.returnKeyType = UIReturnKeyNext;
            loginCell.textField.tag = 0;
            loginCell.textField.delegate = self;
            if(isSigningIn)
                [loginCell.textField resignFirstResponder];
            cell = loginCell;
        }
        else {
            if (passwordCell == nil) {
                passwordCell = [[UITableViewTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                               reuseIdentifier:@"TextCell"];
                passwordCell.textField.text = self.pComApi.password;
            }

            
            
            passwordCell.textLabel.text = NSLocalizedString(@"Password", @"");
            passwordCell.textField.placeholder = NSLocalizedString(@"Photopon.com password", @"");
            passwordCell.textField.keyboardType = UIKeyboardTypeDefault;
            passwordCell.textField.secureTextEntry = YES;
            passwordCell.textField.tag = 1;
            passwordCell.textField.delegate = self;
            if(isSigningIn)
                [passwordCell.textField resignFirstResponder];
            cell = passwordCell;
        }
    }
    
	return cell;    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	[tv deselectRowAtIndexPath:indexPath animated:YES];
    
	switch (indexPath.section) {
		case 0:
        {
			UITableViewCell *cell = (UITableViewCell *)[tv cellForRowAtIndexPath:indexPath];
			for(UIView *subview in cell.subviews) {
				if([subview isKindOfClass:[UITextField class]] == YES) {
					UITextField *tempTextField = (UITextField *)subview;
					[tempTextField becomeFirstResponder];
					break;
				}
			}
			break;
        }
		case 1:
			for(int i = 0; i < 2; i++) {
				UITableViewCell *cell = (UITableViewCell *)[tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
				for(UIView *subview in cell.subviews) {
					if([subview isKindOfClass:[UITextField class]] == YES) {
						UITextField *tempTextField = (UITextField *)subview;
						[self textFieldDidEndEditing:tempTextField];
					}
				}
			}
			if([loginCell.textField.text isEqualToString:@""]) {
				self.footerText = NSLocalizedString(@"Email is required.", @"");
				self.buttonText = NSLocalizedString(@"Sign In", @"");
				[tv reloadData];
			}
			else if([passwordCell.textField.text isEqualToString:@""]) {
				self.footerText = NSLocalizedString(@"Password is required.", @"");
				self.buttonText = NSLocalizedString(@"Sign In", @"");
				[tv reloadData];
			}
			else {
				self.footerText = @" ";
				self.buttonText = NSLocalizedString(@"Signing in...", @"");
				
				[NSThread sleepForTimeInterval:0.15];
				[tv reloadData];
				if (!isSigningIn){
					isSigningIn = YES;
                    [self signIn:self];
				}
			}
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	[textField resignFirstResponder];
	
	UITableViewCell *cell = nil;
    UITextField *nextField = nil;
    switch (textField.tag) {
        case 0:
            [textField endEditing:YES];
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            if(cell != nil) {
                nextField = (UITextField*)[cell viewWithTag:1];
                if(nextField != nil)
                    [nextField becomeFirstResponder];
            }
            break;
        case 1:
            if((![loginCell.textField.text isEqualToString:@""]) && (![passwordCell.textField.text isEqualToString:@""])) {
                if (!isSigningIn){
                    isSigningIn = YES;
                    [self.tableView reloadData];
                    [self signIn:self];
                }
            }
            break;
	}
    
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    UITableViewCell *cell = (UITableViewCell *)[textField superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	switch (indexPath.row) {
		case 0:
			if((textField.text != nil) && ([textField.text isEqualToString:@""])) {
				self.footerText = NSLocalizedString(@"Email is required.", @"");
			}
			else {
				textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
			}
			break;
		case 1:
			if((textField.text != nil) && ([textField.text isEqualToString:@""])) {
				self.footerText = NSLocalizedString(@"Password is required.", @"");
			}
			break;
		default:
			break;
	}
	
    //	[self.tableView reloadData];
	[textField resignFirstResponder];
}

#pragma mark -
#pragma mark Custom methods

- (void)signIn:(id)sender {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    [self.pComApi setUsername:loginCell.textField.text
                      password:passwordCell.textField.text
                       success:^{
                           
                           [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                           [self.delegate loginController:self didAuthenticateWithUsername:self.pComApi.username];
                           //self.footerText = NSLocalizedString(@"Success!", @"");
                           
                    
                           
                           
                           /*
                           [[NSNotificationCenter defaultCenter] postNotificationName:GetMyPhotoponsSuccessful
                                                                               object:self
                                                                             userInfo:nil];
                           //[appDelegate.photoponTabBarViewController loadMainFeedRemoteData];
                           
                           [appDelegate.photoponSplashScreenViewController dismissViewControllerAnimated:YES completion:nil];
                           */
                           
                           //[appDelegate.navigationController popViewControllerAnimated:YES];
                           
                       }
                       failure:^(NSError *error) {
                           self.footerText = NSLocalizedString(@"Sign in failed. Please try again.", @"");
                           self.buttonText = NSLocalizedString(@"Sign In", @"");
                           isSigningIn = NO;
                           [self.tableView reloadData];
                       }];
    
}

- (IBAction)backHandler:(id)sender
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [appDelegate.loginViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super didReceiveMemoryWarning];    
}

- (void)viewDidUnload {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.view release], self.view = nil;
    photoponNavBar = nil;
    
    
}

- (void)dealloc {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.footerText = nil;
    self.buttonText = nil;
    self.pComApi = nil;
    photoponNavBar = nil;
    
}


@end

