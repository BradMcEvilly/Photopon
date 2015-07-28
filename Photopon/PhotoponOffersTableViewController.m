//
//  PhotoponOffersTableViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 7/15/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponOffersTableViewController.h"
#import "AFJSONRequestOperation.h"
#import "PhotoponCoordinateModel.h"
#import "PhotoponPlaceModel.h"
#import "PhotoponCouponModel.h"
#import "Photopon8CouponsModel.h"
#import "PhotoponOffersTableViewCell.h"

@interface PhotoponOffersTableViewController ()

@end

@implementation PhotoponOffersTableViewController

@synthesize delegate;

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
    
    [self.view setFrame:CGRectMake(0.0f, 0.0f, 125.0f, 200.0f)];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    
    [closeBtn setImage:[UIImage imageNamed:@"PhotoponButtonClose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(didClose:) forControlEvents:UIControlEventTouchUpInside];
    
	// Do any additional setup after loading the view.
}


-(void)didClose:(id)sender{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [delegate respondsToSelector:@selector(photoponOffersTableViewController:didCloseAnimated:)]) {
        [delegate photoponOffersTableViewController:self didCloseAnimated:YES];
    }
}
/*
- (NSArray*)call8CouponsAPI{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSMutableArray *couponCollection = [[NSMutableArray alloc] init];
    
    
    // 8coupons
    //http://api.8coupons.com/v1/getdeals?key=XYZ&zip=10022&mileradius=20&limit=500&userid=18381
    / *
     Response:
     
     "affiliate":"yes",
     "name":"Morning Star Farm",
     "address":"489 State Rt 94 S",
     "address2":"",
     "storeID":"3073650",
     "chainID":null,
     "totalDealsInThisStore":"1",
     "homepage":"",
     "phone":"973.579.1226",
     "state":"NJ",
     "city":"Newton",
     "ZIP":"07860",
     "URL":"http:\/\/www.8coupons.com\/apiout\/showdeal\/deal\/9701994\/1857578\/aff",
     "storeURL":"http:\/\/www.8coupons.com\/discounts\/morning-star-farm-newton-07860",
     "dealSource":"yelp.com",
     "user":"yelp",
     "userID":"733207",
     "ID":"9701994",
     "dealTitle":"$75 for $100 Certificate",
     "disclaimer":"",
     "dealinfo":"You get a voucher redeemable for $100 at Morning Star Farm. Print out your voucher, or redeem on your phone with the  Yelp app .",
     "expirationDate":"2013-03-02",
     "postDate":"2013-02-27 01:14:04",
     "showImage":"http:\/\/s3-media1.ak.yelpcdn.com\/bphoto\/wtcDCE1kgoROeehzNLxc5Q\/l.jpg",
     "showLogo":"http:\/\/www.8coupons.com\/partners\/logo\/small\/yelp.png",
     "up":null,
     "down":null,
     "DealTypeID":"1",
     "categoryID":"4",
     "subcategoryID":"69",
     "lat":"41.0279",
     "lon":"-74.8222",
     "distance":"3.03354048160047",
     "dealOriginalPrice":"100",
     "dealPrice":"75",
     "dealSavings":"25",
     "dealDiscountPercent":"25"
     
     NSString* theURLOffers8cpns = [NSString stringWithFormat:@"http://api.8coupons.com/v1/getdeals?key=02fbfdcae460b422ba93ca0de753e2ac566a290f92e6a03bd8eb3b5c5beb6fbcec933468b156b3b6050939c1cb7ea653&lat=%@&lon=%@&mileradius=4&limit=100", [NSString stringWithFormat:@"%3.6f", [appDelegate photoponLatitude]], [NSString stringWithFormat:@"%3.6f", [appDelegate photoponLongitude]] ];
     
 
     * /
    
    PhotoponAppDelegate *appDelegate = (PhotoponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSString* theURLOffers8cpns = [NSString stringWithFormat:@"%@", k8CouponsAPIBaseUrl];
    
    
    
    
    //NSString* theURLOffers = [NSString stringWithFormat:@"http://api.citygridmedia.com/content/offers/v2/search/latlon?what=&lat=41.05&lon=74.75&radius=20&publisher=test&format=json"];
    
    
    
    
    //NSString* theURLOffers = [NSString stringWithFormat:@"http://api.citygridmedia.com/content/offers/v2/search/latlon?what=&lat=34.03&lon=-118.28&radius=5&publisher=test&format=json"];
    
    / *NSString* theURL = [NSString stringWithFormat:@"http://api2.citysearch.com/search/locations?type=barclub&where=91101&publisher=acme&api_key=%@&rpp=50&format=json", API_KEY];
     * /
    NSString *response = [NSString alloc];
    
    NSURL* myURL = [NSURL URLWithString:theURLOffers8cpns];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURLOffers8cpns]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             
                                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                                             NSLog(@"%@ :: %@   [AFJSONRequestOperation JSONRequestOperationWithRequest:request      SUCCESS SUCCESS SUCCESS", self, NSStringFromSelector(_cmd));
                                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                                             
                                             
                                             
                                             
                                             NSDictionary *jsonDict = (NSDictionary *) JSON;
                                             NSArray *products = [jsonDict objectForKey:@"products"];
                                             [products enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
                                                 NSString*response2 = [obj objectForKey:@"icon_url"];
                                             }];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             
                                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                                             NSLog(@"FAILURE FAILURE FAILURE     Request Failure Because %@",[error userInfo]);
                                             NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
                                             
                                         }];
    
    [operation start];
    
    
    / *
     URLLib* theurllib = [URLLib new];
     
     id response = [theurllib objectWithUrl:myURL];
     */
    /*
     NSDictionary *feed = (NSDictionary *)response;
     NSDictionary *jsonResponse = (NSDictionary *)[feed valueForKey:@"jsonResponse"];
     NSDictionary *results = (NSDictionary *)[feed valueForKey:@"results"];
     //NSString* resultsString = [NSString stringWithFormat:@"http://api.citygridmedia.com/content/offers/v2/search/latlon?what=&lat=34.03&lon=-118.28&radius=5&publisher=test&format=json"];
     //NSLog(@"|||||||||||||||||   RESULTS = ||||||||||||||| %@", results);
     
     
     //NSArray *items =(NSArray*)[feed valueForKey:@"results"];
     
     
     NSArray *offers =(NSArray*)[results valueForKey:@"offers"];
     * /
    
    NSString *feed = (NSString *)response;
    
    // sanitize our 8coupons data
    //feed = [feed stringByReplacingOccurrencesOfString:@"[" withString:@""];
    //feed = [feed stringByReplacingOccurrencesOfString:@"]" withString:@""];
    //feed = [feed stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //feed = [feed stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSArray *offers = (NSArray*)feed;
    / *
     UIAlertView *offersAlert = [[UIAlertView alloc] initWithTitle:@"offers.count = "
     message:[NSString stringWithFormat:@"%i", offers.count]
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil];
     [offersAlert show];
     [offersAlert release];
     * /
    
    @try
    {
        
        
        
        
        
        
        
        
        
        / * by Emma McEvilly 10/26/2012
         bv ghrbhodv
         * /
        
        
        
        /////////////////////////////////////////////////////
        /////////////////////////////////////////////////////
        
        
        
        NSLog(@"HERE 1");
        int i;
        for( i=0; i< offers.count; i++) {
            
            NSLog(@"offers.count = %i", offers.count);
            NSDictionary* offer = (NSDictionary *)[offers objectAtIndex:i];
            NSLog(@"[offer valueForKey:@title] = %@#", [offer objectForKey:@"dealTitle"]);
            
            NSString *public_id8Coupons = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer objectForKey:@"ID"]];
            
            public_id8Coupons = [public_id8Coupons stringByReplacingOccurrencesOfString:@" " withString:@""];
            public_id8Coupons = [public_id8Coupons stringByReplacingOccurrencesOfString:@"(" withString:@""];
            public_id8Coupons = [public_id8Coupons stringByReplacingOccurrencesOfString:@")" withString:@""];
            public_id8Coupons = [public_id8Coupons stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            public_id8Coupons = [public_id8Coupons stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *name = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer objectForKey:@"name"]];
            
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@"(" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@")" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *image_url = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer objectForKey:@"showImage"]];
            
            image_url = [image_url stringByReplacingOccurrencesOfString:@" " withString:@""];
            image_url = [image_url stringByReplacingOccurrencesOfString:@"(" withString:@""];
            image_url = [image_url stringByReplacingOccurrencesOfString:@")" withString:@""];
            image_url = [image_url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            image_url = [image_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            
            NSString *place_url = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer objectForKey:@"homepage"]];
            
            place_url = [place_url stringByReplacingOccurrencesOfString:@" " withString:@""];
            place_url = [place_url stringByReplacingOccurrencesOfString:@"(" withString:@""];
            place_url = [place_url stringByReplacingOccurrencesOfString:@")" withString:@""];
            place_url = [place_url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            place_url = [place_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *coupon_url = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer objectForKey:@"URL"]];
            
            coupon_url = [coupon_url stringByReplacingOccurrencesOfString:@" " withString:@""];
            coupon_url = [coupon_url stringByReplacingOccurrencesOfString:@"(" withString:@""];
            coupon_url = [coupon_url stringByReplacingOccurrencesOfString:@")" withString:@""];
            coupon_url = [coupon_url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            coupon_url = [coupon_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            
            / *
             NSNumber *latNumber = [[[NSNumber alloc] initWithFloat:4.3f]autorelease];
             //NSNumber *latNumber = [[NSNumber alloc] initWithFloat:[(NSNumber*)[offer valueForKey:@"lat"] floatValue]];
             NSString *lat = [[[NSString alloc] initWithFormat:@"%3.6f", [latNumber floatValue]] retain];
             
             NSNumber *lonNumber = [[[NSNumber alloc] initWithFloat:4.3f] autorelease];
             //NSNumber *lonNumber = [[NSNumber alloc] initWithFloat:[(NSNumber*)[offer valueForKey:@"lon"] floatValue]];
             NSString *lon = [[[NSString alloc] initWithFormat:@"%3.6f", [lonNumber floatValue]] retain];
             * /
            
            
            
            //NSNumber *latNumber = [[[NSNumber alloc] initWithFloat:4.3f]autorelease];
            //NSNumber *latNumber = [[NSNumber alloc] initWithFloat:[(NSNumber*)[offer valueForKey:@"lat"] floatValue]];
            NSString *lat = [[NSString alloc] initWithFormat:@"%@", @""];
            
            //NSNumber *lonNumber = [[[NSNumber alloc] initWithFloat:4.3f] autorelease];
            //NSNumber *lonNumber = [[NSNumber alloc] initWithFloat:[(NSNumber*)[offer valueForKey:@"lon"] floatValue]];
            NSString *lon = [[NSString alloc] initWithFormat:@"%@", @""];
            
            
            
            
            
            
            / *NSString *lat = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"lat"]] retain];
             
             //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
             lat = [lat stringByReplacingOccurrencesOfString:@"(" withString:@""];
             lat = [lat stringByReplacingOccurrencesOfString:@")" withString:@""];
             lat = [lat stringByReplacingOccurrencesOfString:@"\"" withString:@""];
             lat = [lat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
             NSString *lon = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"lon"]] retain];
             
             //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
             lon = [lon stringByReplacingOccurrencesOfString:@"(" withString:@""];
             lon = [lon stringByReplacingOccurrencesOfString:@")" withString:@""];
             lon = [lon stringByReplacingOccurrencesOfString:@"\"" withString:@""];
             lon = [lon stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             * /
            
            / *
             address":"440 E 79th St.",
             "address2":"",
             "storeID":"2103229",
             "chainID":null,
             "totalDealsInThisStore":"1",
             "homepage":"http://gkayskincare.com/gkay/index.htm",
             "phone":"212.639.9305",
             "state":"NY",
             "city":"New York",
             "ZIP":"10021",
             
             * /
            NSString *street = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"address"]];
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            street = [street stringByReplacingOccurrencesOfString:@"(" withString:@""];
            street = [street stringByReplacingOccurrencesOfString:@")" withString:@""];
            street = [street stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            street = [street stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *city = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"city"]];
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            city = [city stringByReplacingOccurrencesOfString:@"(" withString:@""];
            city = [city stringByReplacingOccurrencesOfString:@")" withString:@""];
            city = [city stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            city = [city stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            / *
             NSString *stateCG = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[address valueForKey:@"state"]] retain];
             //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
             stateCG = [stateCG stringByReplacingOccurrencesOfString:@"(" withString:@""];
             stateCG = [stateCG stringByReplacingOccurrencesOfString:@")" withString:@""];
             stateCG = [stateCG stringByReplacingOccurrencesOfString:@"\"" withString:@""];
             stateCG = [stateCG stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             * /
            NSString *postal_code = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"ZIP"]];
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            postal_code = [postal_code stringByReplacingOccurrencesOfString:@"(" withString:@""];
            postal_code = [postal_code stringByReplacingOccurrencesOfString:@")" withString:@""];
            postal_code = [postal_code stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            postal_code = [postal_code stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *phone = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"phone"]];
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *categoryID = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"categoryID"]];
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            categoryID = [categoryID stringByReplacingOccurrencesOfString:@"(" withString:@""];
            categoryID = [categoryID stringByReplacingOccurrencesOfString:@")" withString:@""];
            categoryID = [categoryID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            categoryID = [categoryID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *expirationDateRaw = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"expirationDate"]];
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            expirationDateRaw = [expirationDateRaw stringByReplacingOccurrencesOfString:@"(" withString:@""];
            expirationDateRaw = [expirationDateRaw stringByReplacingOccurrencesOfString:@")" withString:@""];
            expirationDateRaw = [expirationDateRaw stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            expirationDateRaw = [expirationDateRaw stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *postDateRaw = [[NSString alloc] initWithFormat:@"%@", (NSString*)[offer valueForKey:@"postDate"]];
            //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            postDateRaw = [postDateRaw stringByReplacingOccurrencesOfString:@"(" withString:@""];
            postDateRaw = [postDateRaw stringByReplacingOccurrencesOfString:@")" withString:@""];
            postDateRaw = [postDateRaw stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            postDateRaw = [postDateRaw stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            
            / *
             
             // RESPONSE DATE SANITIZATION
             NSString *expirationDate = [NSString alloc];
             
             if ([expirationDateRaw isEqualToString:nullFieldString]) {
             expirationDate = [[[NSString alloc] initWithFormat:@"%@", expirationDateRaw] retain];
             }else{
             // sanitize - change start date format for mysql
             NSDate *expirationDateDateObj = [NSDate dateFromString:expirationDateRaw withFormat:[NSDate dateFormatString]];
             expirationDate = [[[NSString alloc] initWithFormat:@"%@", [expirationDateDateObj stringWithFormat:[NSDate dbFormatString]]] retain];
             }
             
             NSString *postDate = [NSString alloc];
             
             if ([postDateRaw isEqualToString:nullFieldString]) {
             postDate = [[[NSString alloc] initWithFormat:@"%@", postDateRaw] retain];
             }
             * /
            //polkvhhhhjkkkjj  ncxzcvbnm,..//
            //h jjxhhhhhh                                  n                                                                                                                                                                                                              //ggd b
            
            
            
            //NSString *image_url = @"";//[offer valueForKey:@"image_url"];
            //NSString *name = (NSString*)[locations valueForKey:@"name"];
            
            
            / *
             NSDictionary *locations = (NSDictionary*)[offer valueForKey:@"locations"];
             
             
             //NSArray *locations = (NSArray *)[offer valueForKey:@"locations"];
             //NSLog(@"locations image_url %@", [locations valueForKey:@"image_url"]);
             
             NSString *image_url = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[locations valueForKey:@"image_url"]] retain];
             
             image_url = [image_url stringByReplacingOccurrencesOfString:@" " withString:@""];
             image_url = [image_url stringByReplacingOccurrencesOfString:@"(" withString:@""];
             image_url = [image_url stringByReplacingOccurrencesOfString:@")" withString:@""];
             image_url = [image_url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
             image_url = [image_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
             
             
             //int ia;
             
             //for (ia=0; ia < [locations count]; ia++) {
             
             //NSDictionary* location = (NSDictionary *)[locations objectAtIndex:ia];
             
             //if ([locations valueForKey:@"image_url"]) {
             //image_url = [locations valueForKey:@"image_url"];
             //}
             //if ([locations valueForKey:@"name"]) {
             //NSString *name = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[locations valueForKey:@"name"]] retain];
             //}
             
             NSString *name = [[[NSString alloc] initWithFormat:@"%@", (NSString*)[locations valueForKey:@"name"]] retain];
             
             //name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
             name = [name stringByReplacingOccurrencesOfString:@"(" withString:@""];
             name = [name stringByReplacingOccurrencesOfString:@")" withString:@""];
             name = [name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
             name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
             //NSString *image_url = (NSString*)[locations valueForKey:@"image_url"];
             //NSString *name      = (NSString*)[locations valueForKey:@"name"];
             * /
            
            //}
            
            
            
            // PLACE //
            
            NSNumber *couponSrcType = [[NSNumber alloc] initWithInt:PhotoponCouponSourceType8Coupons];
            
            PhotoponCoordinateModel *photoponCoordinateModel = [[PhotoponCoordinateModel alloc] init];
            photoponCoordinateModel.location = [[CLLocation alloc] init];
            photoponCoordinateModel.latitudeString = [NSString stringWithFormat:@"%@", photoponCoordinateModel.location.coordinate.latitude];
            photoponCoordinateModel.longitudeString = [NSString stringWithFormat:@"%@", photoponCoordinateModel.location.coordinate.longitude];
            
            // COUPON //
            / *
            PhotoponCouponModel *photoponCouponModel = [[PhotoponCouponModel alloc] init];
            photoponCouponModel.identifier = [NSString stringWithFormat:@"%@", @"-"];
            photoponCouponModel.details = [NSString stringWithString:(NSString*)[offer objectForKey:@"dealTitle"]];
            photoponCouponModel.terms = [NSString stringWithFormat:@"%@", (NSString*)[offer valueForKey:@"disclaimer"]];
            photoponCouponModel.instructions = [NSString stringWithFormat:@"%@", (NSString*)[offer valueForKey:@"disclaimer"]];
            photoponCouponModel.couponURL = coupon_url;
            photoponCouponModel.couponType = [NSString stringWithFormat:@"%i", [couponSrcType intValue]];
            
            NSNumber *rating = [[NSNumber alloc] initWithInt:0];
            
            photoponCouponModel.place = [[PhotoponPlaceModel alloc] init];
            photoponCouponModel.place.publicID = public_id8Coupons;
            photoponCouponModel.place.name = name;
            photoponCouponModel.place.street = street;//[NSString stringWithString:@"245 Maple Grove%@"];
            photoponCouponModel.place.city = city;//[NSString stringWithString:@"Ceaver Circle%@"];
            photoponCouponModel.place.zip = postal_code;
            photoponCouponModel.place.phone = phone;//[[NSString alloc] initWithFormat:@"@%", @"555-755-7755"];
            photoponCouponModel.place.category = categoryID;
            [photoponCouponModel.place setImageUrl:image_url];
            photoponCouponModel.place.bio = @"";
            photoponCouponModel.place.locationIdentifier = public_id8Coupons;
            photoponCouponModel.place.locationLatitude = lat;//[NSString stringWithString:@"34.045%@"];
            photoponCouponModel.place.locationLongitude = lon;
            photoponCouponModel.place.rating = rating;
            photoponCouponModel.place.url = place_url;//@"";//[NSString stringWithString:(NSString*)[offer objectForKey:@"homepage"]];
            //[photoponCouponModel.place setUrl:place_url];
            
     
            / *
             photoponCouponModel.startString = postDate;
             photoponCouponModel.expirationString = expirationDate;
             
             
             NSDateFormatter *postDateFormatter = [[NSDateFormatter alloc] init];
             [postDateFormatter setDateFormat:@"Y-m-d H:i:s HH:mm:ss Z"];
             NSDate *pDate = [postDateFormatter dateFromString:postDate];
             [postDateFormatter release];
             
             NSDateFormatter *expFormatter = [[NSDateFormatter alloc] init];
             [expFormatter setDateFormat:@"Y-m-d H:i:s HH:mm:ss Z"];
             NSDate *expDate = [expFormatter dateFromString:expirationDate];
             [expFormatter release];
             
             photoponCouponModel.start = pDate;
             photoponCouponModel.expiration = expDate;
             * /
            [couponCollection addObject:photoponCouponModel];
            * /
            
            
            //[photoponCouponModel release];
            
        }
        NSLog(@"HERE 3");
        
        
        
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        NSLog( @"Description: %@", exception.description );
        NSLog( @"debugDescription: %@", exception.debugDescription );
        NSLog( @"accessibilityHint: %@", exception.accessibilityHint );
        NSLog( @"accessibilityLabel: %@", exception.accessibilityLabel );
        
        
        
        
        
        UIAlertView *coupon2Alert = [[UIAlertView alloc] initWithTitle:@"NSException2 caught"
                                                               message:[NSString stringWithFormat:@"Name: %@ Reason: %@", exception.name, exception.description]
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                     otherButtonTitles:nil];
        [coupon2Alert show];
        
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog( @"In finally block");
        
        
    }
    
    
    
    
    
}
* /
- (void)processQueryResults:(NSArray *)results error:(NSError *)error callback:(void (^)(NSError *error))callback {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"query results not processed on main queue");
    
    
    if (results != nil && ![results isKindOfClass:[NSArray class]]) {
        [NSException raise:NSInternalInconsistencyException
                    format:NSLocalizedString(@"Query did not return a result NSArray or nil", nil)];
        return;
    } else if ([results isKindOfClass:[NSArray class]]) {
        for (id object in results) {
            if (!([object isKindOfClass:[PhotoponModel class]] || [object isKindOfClass:[NSDictionary class]])) {
                [NSException raise:NSInternalInconsistencyException
                            format:NSLocalizedString(@"Query results contained invalid objects", nil)];
                return;
            }
        }
    }
    
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Results", nil)
     message:[NSString stringWithFormat:@"Count: %i", results.count]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
     [alert show];
     
    if (results.count > 0) {
        // temp fix
		[self.objects addObjectsFromArray:results];
        //self.objects = [NSMutableArray arrayWithArray:results];
    }
    
    self.isLoading = NO;
    
    
    self.tableView.userInteractionEnabled = YES;
    
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
    // Post process results
    dispatch_queue_t q = dispatch_get_main_queue();// _current_queue();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self postProcessResults];
        
        dispatch_async(q, ^{
            
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"%@ :: %@            [self objectsWillLoad];", self, NSStringFromSelector(_cmd));
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            [self objectsWillLoad];
            
			[self.tableView reloadData];
            
            [self objectsDidLoad:error];
            
            if (callback != NULL) {
                callback(error);
            }
        });
    });
}*/

- (Photopon8CouponsModel*)objectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    return [Photopon8CouponsModel modelWithDictionary:[self.objects objectAtIndex:indexPath.row]];
}

- (void)cell:(PhotoponOffersTableViewCell *)cellView didTapCouponButton:(Photopon8CouponsModel *)aCoupon{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (self.delegate && [delegate respondsToSelector:@selector(photoponOffersTableViewController:didTapCouponButton:offer:)]) {
        [delegate photoponOffersTableViewController:self didTapCouponButton:cellView.photoponBtnCouponTitle offer:aCoupon];
    }
}

- (void) configureCell:(PhotoponOffersTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(Photopon8CouponsModel*)object{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    cell.delegate = self;
    [cell setUpWithObject:object];
}

- (UITableViewCell *)newCellWithObject:(Photopon8CouponsModel*)object {
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    // To comply with apple ownership and naming conventions, returned cell should have a retain count > 0, so retain the dequeued cell.
    NSString *cellIdentifier = [NSString stringWithFormat:@"_PhotoponOffersTableViewCellIdentifier"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [PhotoponOffersTableViewCell photoponOffersTableViewCell];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (indexPath.row == self.objects.count) {
        return 44.0f;
    }
    return 125.0f;
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
                               [[NSNumber alloc] initWithInt:
                                [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]],
                               nil];
    
    
    
    
    /*
     
     NSArray *paramsArrExtra = [NSArray arrayWithObjects:[NSString stringWithString:(NSString*)[self.photoponFeedItemsTableViewController.photoponModelDictionary objectForKey:@"identifier"]], [NSNumber numberWithInt:num], nil];
     
     */
    
    
    /* temp fix until brian uploads updated php server file
     NSMutableArray *params =  [[NSMutableArray alloc] initWithObjects:
     self.identifier,
     [[NSNumber alloc] initWithInt:
     [[self.methodParams objectForKey:kPhotoponCurrentOffsetKey] integerValue]  +
     [[self.methodParams objectForKey:kPhotoponObjectsPerPageKey] integerValue]],
     nil];
     */
    return params;
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
