//
//  PhotoponImagePickerController.m
//  Photopon
//
//  Created by Brad McEvilly on 9/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponImagePickerController.h"
#import "PhotoponUIImagePickerController.h"

@interface PhotoponImagePickerController ()

@end

@implementation PhotoponImagePickerController

//@synthesize photoPickerController;

-(id) init{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        
        /*
         self.mediaUI = [PhotoponUIImagePickerController new];
         
         
         
         self.mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
         self.mediaUI.delegate = delegate;
         self.mediaUI.allowsEditing = NO;
         self.mediaUI.showsCameraControls = NO;
         */
        
    }
    return self;
}

- (id)initWithDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    self = [super init];
    if (self) {
        
        /*
        self.mediaUI = [PhotoponUIImagePickerController new];
        
        
        
        self.mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.mediaUI.delegate = delegate;
        self.mediaUI.allowsEditing = NO;
        self.mediaUI.showsCameraControls = NO;
         */
        
    }
    return self;
}

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
    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    /*
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CATransition *shutterAnimation = [CATransition animation];
    [shutterAnimation setDelegate:self];
    [shutterAnimation setDuration:0.6];
    
    shutterAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    [shutterAnimation setType:@"cameraIris"];
    [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
    CALayer *cameraShutter = [[CALayer alloc] init];
    [cameraShutter setBounds:CGRectMake(0.0, 0.0, 320.0, 320.0)];
    [self.view.layer addSublayer:cameraShutter];
    [self.view.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
    */
    
    
    /*
    // add as child view controller
    [self addChildViewController:self.mediaUI];
    [self.view addSubview:self.mediaUI.view];
    [self.mediaUI didMoveToParentViewController:self];
    */
    
    
    // Do any additional setup after loading the view.
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
