//
//  PhotoponNewPhotoponOffersViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 9/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewPhotoponOffersViewController.h"
#import "PhotoponMediaModel.h"
//#import "PhotoponOffersTableViewController.h"
#import "PhotoponCouponModel.h"
#import "Photopon8CouponsModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponNewPhotoponShareViewController.h"
//#import "PhotoponOffersTableViewController.h"
#import "PhotoponOfferOverlayView.h"
#import "PhotoponOfferPageViewController.h"
#import "PhotoponCouponModel.h"
#import "StyledPageControl.h"
#import "PhotoponNewPhotoponUtility.h"

@interface PhotoponNewPhotoponOffersViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate>

@property(nonatomic,copy) PhotoponNewPhotoponOffersCompletionBlock completionBlock;

@end

@implementation PhotoponNewPhotoponOffersViewController

@synthesize photoponPagesContainerView;
@synthesize photoponPagesScrollView;
@synthesize photoponShutterContainer; 
@synthesize photoponToolBarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil entityName:kPhotoponCouponClassName];
    if (self) {
        
        
    
    }
    return self;
}

-(void)loadOffers{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self loadObjects];
    
}


















































- (id)initWithCoder:(NSCoder *)aDecoder{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityName:(NSString*)entityName
{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil entityName:entityName];
    if (self) {
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
        //self.methodParams = [[NSMutableDictionary alloc] init];
        
        
        
        self.objectsPerPage = k8CouponsAPIParamsLimit;
        
        
        //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        [self.methodParams setObject:[[NSString alloc] initWithString: entityName] forKey:kPhotoponEntityNameKey];
        [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        
        // redundant - now handled by updateCurrentOffset method
        //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
        
        
        
        // set defaults
        [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedCouponModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
        
        self.paginationEnabled = YES;
        
        @synchronized(self) {
            
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [defaults objectForKey:kPhotoponMediaAttributesNewPhotoponPlaceKey];
            NSMutableDictionary *newPhotoponDraftPlace = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
            
            
            //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
            NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
            if (!currentUserID || !currentUserID.length>0) {
                currentUserID = [[NSString alloc] initWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]]];
            }
            [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
            [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //self.objects = [NSMutableArray new];
        
        NSLog(@"PhotoponQueryTableViewController initWithStyle       2");
    }
    return self;
}

- (id)initWithCompletionBlock:(PhotoponNewPhotoponOffersCompletionBlock)completionBlock
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //self = [super init];
    
    self = [self initWithNibName:@"PhotoponNewPhotoponOffersViewController" bundle:nil entityName:kPhotoponCouponClassName];
    
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidLoad];
    
    [self.photoponBtnNext setEnabled:NO];
    
    [self configurePhotoponOffersView];
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super viewDidAppear:animated];
    
}

-(void)configurePhotoponOffersView{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self configurePhotoponPageControlStyle];
    
    [self.photoponPagesContainerView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    [self.photoponToolBarView setFrame:[PhotoponNewPhotoponUtility photoponOffersToolbarFrame]];
    
    CGRect pageControlFrame = self.photoponToolBarView.bounds;
    [self.photoponPageControl setFrame:pageControlFrame];
    [self.photoponActivityPageControl setFrame:pageControlFrame];
    
    [self restackSubviews];
    
}

-(void)configurePhotoponPageControlStyle{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.photoponPageControl setPageControlStyle:PageControlStyleDefault];
    
    [self.photoponPageControl setNumberOfPages:20];
    [self.photoponPageControl setCurrentPage:1];
    [self.photoponPageControl setCoreNormalColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3f]];
    [self.photoponPageControl setCoreSelectedColor:[UIColor whiteColor]];
    [self.photoponPageControl setGapWidth:28];
    [self.photoponPageControl setDiameter:8];
    [self.photoponPageControl setAlpha:1.0f];
    
    [self.photoponActivityPageControl setPageControlStyle:PageControlStyleDefault];
    
    [self.photoponActivityPageControl setNumberOfPages:20];
    [self.photoponActivityPageControl setCurrentPage:1];
    [self.photoponActivityPageControl setCoreNormalColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3f]];
    [self.photoponActivityPageControl setCoreSelectedColor:[UIColor whiteColor]];
    [self.photoponActivityPageControl setGapWidth:28];
    [self.photoponActivityPageControl setDiameter:8];
    [self.photoponActivityPageControl setAlpha:1.0f];
    
    
    
    
    /* custom page control thumbnails
    [pageControl setPageControlStyle:PageControlStyleThumb];
    [pageControl setThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-normal.png"]];
    [pageControl setSelectedThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-selected.png"]];
     */
}

-(void)restackSubviews{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self.view bringSubviewToFront: self.photoponToolBarView];
    [self.photoponToolBarView bringSubviewToFront: self.photoponActivityPageControl];
    [self.photoponToolBarView bringSubviewToFront: self.photoponPageControl];
    
    [self.view bringSubviewToFront: self.photoponPagesContainerView];
    [self.photoponPagesContainerView bringSubviewToFront: self.photoponActivityPagesScrollView];
    [self.photoponPagesContainerView bringSubviewToFront: self.photoponPagesScrollView];
    
}

- (IBAction)photoponBtnRefreshHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self reloadInBackground];
    
}

- (IBAction)photoponBtnPlaceHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
}

- (IBAction)photoponBtnRetakeHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponOverlayViewControllerShouldChangeViewMode object:nil userInfo:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)photoponBtnNextHandler:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){", weakSelf, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"---------->         [self prepareNextStepInBackgroundWithBlock:^(NSError *error, PhotoponCouponModel *coupon){          BEGIN BLOCK, BEGIN BLOCK, BEGIN BLOCK");
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        /*
        if (error) {
            [[PhotoponAppDelegate sharedPhotoponApplicationDelegate] photoponAlertViewWithTitle:@"Poor internet connection" message:@"Try again later" cancelButtonTitle:nil otherButtonTitle:@"OK"];
        }
        */
        
        
        //self.completionBlock(coupon);
        
    }];
}

- (void)setUpPageViewControllers{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    int i;
    int iMax = (self.objects.count >= self.objectsPerPage)?self.objectsPerPage:self.objects.count;

    for (i=0; i< iMax; i++){
        
        [self.photoponPagesScrollView addPagedViewController:[[PhotoponOfferPageViewController alloc] initWithCouponModel:[self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]]];
    }

}

- (void)objectsDidLoad:(NSError *)error{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [super objectsDidLoad:error];
    [self.photoponBtnNext setEnabled:YES];
    
}

- (NSMutableArray *)paramsForTable{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // Params:
    //  1). UserID      - so we know whos gallery to load
    //  2). MaxObjects  - so we don't receive more than
    /*NSArray *params =  [NSArray arrayWithObjects:
     self.identifier,
     (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
     nil];
     */
    
    
    NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
                               self.identifier,
                               (NSNumber*)[self.methodParams objectForKey:kPhotoponCurrentOffsetKey],
                               nil];
    return params;
}

- (Photopon8CouponsModel*)objectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [Photopon8CouponsModel modelWithDictionary:(NSDictionary*)[self dictionaryAtIndexPath:indexPath]];
}

- (PhotoponCouponModel*)processedObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    Photopon8CouponsModel *offer = [self objectAtIndexPath:indexPath];
    
    [offer sanitize];
    
    PhotoponMediaModel *pMediaModel = [PhotoponMediaModel newPhotoponDraft];
    
    [pMediaModel convert8CouponsDictToCoupons:offer.dictionary];
    
    
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"------->            pMediaModel.coupon.details = %@", pMediaModel.coupon.details);
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [PhotoponMediaModel setNewPhotoponDraft:pMediaModel];
    
    return [[PhotoponMediaModel newPhotoponDraft] coupon];
}

- (void)prepareNextStepInBackgroundWithBlock:(void (^)(NSError *error, PhotoponCouponModel *coupon))block{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    /*
     UIAlertView *alertCheck = [[UIAlertView alloc] initWithTitle:@"Page Control"
     message:[NSString stringWithFormat:@"currentPage: %i", self.photoponPagesScrollView.currentPage]
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil];
     [alertCheck show];
     */
    
    
    NSError *error;
    PhotoponCouponModel *coupon = [self processedObjectAtIndexPath:[NSIndexPath indexPathForRow:self.photoponPagesScrollView.currentPage inSection:0]];
    
    if (block)
        block(error, coupon);
}

- (void) setUpPhotoponConfig{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"PhotoponQueryTableViewController initWithStyle       1");
    //self.methodParams = [[NSMutableDictionary alloc] init];
    
    self.objectsPerPage = k8CouponsAPIParamsLimit;
    
    
    //PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //NSString *uidString = [[NSString alloc] initWithFormat:@"%@", appDelegate.pmm.currentUser.identifier];
    
    [self.methodParams setObject:[[NSString alloc] initWithString: kPhotoponCouponClassName] forKey:kPhotoponEntityNameKey];
    [self.methodParams setObject:[[NSNumber alloc] initWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
    
    
    
    // redundant - now handled by updateCurrentOffset method
    //[self.methodParams setObject:[[NSNumber alloc] initWithInt:self.currentOffset] forKey:kPhotoponCurrentOffsetKey];
    
    // set defaults
    [self.methodParams setObject:[[NSString alloc] initWithFormat:@"%@", kPhotoponAPIReturnedCouponModelsKey] forKey:kPhotoponMethodReturnedModelsKey];
    
    self.paginationEnabled = NO;
    
    @synchronized(self) {
        //[self.methodParams setObject:[[PhotoponUserModel currentUser] identifier] forKey:kPhotoponModelIdentifierKey];
        NSString *currentUserID = [[PhotoponUserModel currentUser] identifier];
        if (!currentUserID || !currentUserID.length>0) {
            currentUserID = [[NSString alloc] initWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:kPhotoponUserAttributesIdentifierKey]]];
        }
        [self.methodParams setObject:currentUserID forKey:kPhotoponModelIdentifierKey];
        [self.methodParams setObject:[NSNumber numberWithInt:self.objectsPerPage] forKey:kPhotoponObjectsPerPageKey];
    }
    
    
    
    
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