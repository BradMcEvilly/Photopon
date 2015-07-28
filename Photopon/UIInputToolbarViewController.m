/*
 *  UIInputToolbarViewController.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "PhotoponAppDelegate.h"
#import "PhotoponTabBarController.h"
#import "UIInputToolbarViewController.h"
//#import "PhotoponPhotoPickerViewController.h"
//#import "MyViewController.h"

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

@implementation UIInputToolbarViewController

@synthesize inputToolbar;

- (void)dealloc
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

#pragma mark - View lifecycle

- (void)loadView
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super loadView];
    
    keyboardIsVisible = NO;
    
    /* Calculate screen size */
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:screenFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    /* Create toolbar */
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-kDefaultToolbarHeight, screenFrame.size.width, kDefaultToolbarHeight)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"Headline";
    
    //[inputToolbar.textView setSelectedRange:NSMakeRange(0, 0)];
    
}


/*
- (void)loadView
{
    [super loadView];

    
    
    
    CGFloat incrementVal = 16.0f;
    
    CGFloat product = incrementVal * 55.0f;
    
    CGRect inputToolbarFrame = CGRectMake(0.0f, 0.0f, 76.0f, product);
    
    //inputToolbar = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    //inputToolbar.bounds = CGRectMake(0.0f, 0.0f, 76.0f, 280.0f);
    
    //photoponTableFooterViewController_ = [[[PhotoponTableFooterViewController alloc] initWithNibName:@"PhotoponTableFooterViewController" bundle:nil] retain];
    
    //[tableView setTableFooterView:photoponTableFooterViewController_.view];
    
    //CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    //self.view.transform = rotateTable;
    //self.view.frame = CGRectMake(10.0f, 18.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    //tableViewCell.contentArray = [arrays objectAtIndex:indexPath.section];
    
    //tableViewCell.horizontalTableView.allowsSelection = YES;

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    keyboardIsVisible = NO;
    
    / * Calculate screen size * /
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:screenFrame];
    self.view.backgroundColor = [UIColor clearColor];
    / * Create toolbar * /
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-kDefaultToolbarHeight, screenFrame.size.width, kDefaultToolbarHeight)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"Headline";
    [inputToolbar.textView setFont:[UIFont boldSystemFontOfSize:18.0f]];
    inputToolbar.textView.textColor = [UIColor whiteColor];
    
    inputToolbar.backgroundColor = [UIColor clearColor];
}
 */

- (void)viewDidUnload
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[inputToolbar.textView becomeFirstResponder];
    //[inputToolbar.textView textViewDidChange:inputToolbar.textView.internalTextView];
}

- (void)viewWillAppear:(BOOL)animated 
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	[super viewWillAppear:animated];
	/* Listen for keyboard */    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //[self keyboardWillShow:nil];
    
    
    //[inputToolbar.textView setSelectedRange:NSMakeRange(0, inputToolbar.textView.text.length)];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect r = self.inputToolbar.frame;
	if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        r.origin.y = screenFrame.size.height - self.inputToolbar.frame.size.height - kStatusBarHeight;
        if (keyboardIsVisible) {
            r.origin.y -= kKeyboardHeightPortrait;
        }
        [self.inputToolbar.textView setMaximumNumberOfLines:13]; 
	}
	else
    {
        r.origin.y = screenFrame.size.width - self.inputToolbar.frame.size.height - kStatusBarHeight;
        if (keyboardIsVisible) {
            r.origin.y -= kKeyboardHeightLandscape;
        }
        [self.inputToolbar.textView setMaximumNumberOfLines:7];
        [self.inputToolbar.textView sizeToFit];
    }
    self.inputToolbar.frame = r;
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification 
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    /* Move the toolbar to above the keyboard */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height - kKeyboardHeightPortrait;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height - kKeyboardHeightLandscape - kStatusBarHeight;
    }
	self.inputToolbar.frame = frame;
	[UIView commitAnimations];
    keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification 
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    /* Move the toolbar back to bottom of the screen */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height;
    }
	self.inputToolbar.frame = frame;
	[UIView commitAnimations];
    keyboardIsVisible = NO;
}

-(void)inputButtonPressed:(NSString *)inputText
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    /* Called when toolbar button is pressed */
    NSLog(@"Pressed button with text: '%@'", inputText);
    /*
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.photoponPhotoPickerViewController.myViewController updateNewPhotoponHeadline:inputText];
    [appDelegate.photoponPhotoPickerViewController.myViewController hideEditMessageView];
    
     */
}
@end
