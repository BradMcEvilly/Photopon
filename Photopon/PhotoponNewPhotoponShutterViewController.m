//
//  PhotoponNewPhotoponShutterViewController.m
//  Photopon
//
//  Created by Brad McEvilly on 9/19/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "PhotoponNewPhotoponShutterViewController.h"
#import "PhotoponNewPhotoponConstants.h"
#import "PhotoponNewPhotoponUtility.h"

@interface PhotoponNewPhotoponShutterViewController ()

@end

@implementation PhotoponNewPhotoponShutterViewController

@synthesize photoponShutterPanelBottom;
@synthesize photoponShutterPanelTop;
@synthesize photoponShutterSceneBackgroundView;
@synthesize photoponShutterSceneForegroundView;

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
    // Do any additional setup after loading the view from its nib.
    //[self configureViewForModeClose];
}

- (void) configureViewForModeOpen{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    //[self.photoponShutterPanelTop setAlpha:1.0f];
    //[self.photoponShutterPanelBottom setAlpha:1.0f];
    
    //self.photoponConfirmationToolBar.frame = CGRectMake(self.photoponConfirmationToolBar.frame.origin.x, self.photoponConfirmationToolBar.frame.size.height, self.photoponConfirmationToolBar.frame.size.width, self.photoponConfirmationToolBar.frame.size.height);
    
    //self.photoponCreationToolBar.frame = CGRectMake(self.photoponCreationToolBar.frame.origin.x, self.photoponCreationToolBar.frame.size.height, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height);
    
    // close shutter
    self.photoponShutterPanelTop.frame      = [PhotoponNewPhotoponUtility photoponShutterTopFrameOpen];
    self.photoponShutterPanelBottom.frame   = [PhotoponNewPhotoponUtility photoponShutterBottomFrameOpen];
    
    [self.photoponShutterSceneBackgroundView setFrame:[PhotoponNewPhotoponUtility photoponShutterSceneBackgroundFrameOpen]];
    [self.photoponShutterSceneForegroundView setFrame:[PhotoponNewPhotoponUtility photoponShutterSceneForegroundFrameOpen]];
    
    [self.view setHidden:NO];
    
    /*
    [self.photoponShutterSceneBackgroundView setAlpha:1.0f];
    [self.photoponShutterSceneForegroundView setAlpha:1.0f];
    */
}

- (void) configureViewForModeClose{
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    //[self.photoponShutterPanelTop setAlpha:1.0f];
    //[self.photoponShutterPanelBottom setAlpha:1.0f];
    
    //self.photoponConfirmationToolBar.frame = CGRectMake(self.photoponConfirmationToolBar.frame.origin.x, self.photoponConfirmationToolBar.frame.size.height, self.photoponConfirmationToolBar.frame.size.width, self.photoponConfirmationToolBar.frame.size.height);
    
    //self.photoponCreationToolBar.frame = CGRectMake(self.photoponCreationToolBar.frame.origin.x, self.photoponCreationToolBar.frame.size.height, self.photoponCreationToolBar.frame.size.width, self.photoponCreationToolBar.frame.size.height);
    
    
    // close shutter
    self.photoponShutterPanelTop.frame      = [PhotoponNewPhotoponUtility photoponShutterTopFrameDefault];
    self.photoponShutterPanelBottom.frame   = [PhotoponNewPhotoponUtility photoponShutterBottomFrameDefault];
    
    [self.photoponShutterSceneBackgroundView setFrame:[PhotoponNewPhotoponUtility photoponShutterSceneFrameDefault]];
    [self.photoponShutterSceneForegroundView setFrame:[PhotoponNewPhotoponUtility photoponShutterSceneFrameDefault]];
    
    //[self.photoponShutterSceneBackgroundView setAlpha:1.0f];
    //[self.photoponShutterSceneForegroundView setAlpha:1.0f];
    
    [self.view setHidden:NO];
    
}


/**
 OBSOLETE
 **
- (void) open {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (![NSThread isMainThread]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ON MAIN THREAD FAILURE!!! OPENSHUTTER IS NOT MAIN THREAD WARNING!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    } else {
		
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ALREADY ON MAIN THREAD!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
	}
    
    
    
    //[self.picker.mediaUI viewWillAppear:NO];
    //[self.picker.mediaUI viewDidAppear:NO];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.photoponShutterSceneBackgroundView.frame = CGRectMake(self.photoponShutterSceneBackgroundView.frame.origin.x + self.photoponShutterSceneBackgroundView.frame.size.width, self.photoponShutterSceneBackgroundView.frame.origin.y, self.photoponShutterSceneBackgroundView.frame.size.width, self.photoponShutterSceneBackgroundView.frame.size.height);
        
        self.photoponShutterSceneForegroundView.frame = CGRectMake(self.photoponShutterSceneForegroundView.frame.origin.x - self.photoponShutterSceneForegroundView.frame.size.width, self.photoponShutterSceneForegroundView.frame.origin.y, self.photoponShutterSceneForegroundView.frame.size.width, self.photoponShutterSceneForegroundView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                self.photoponShutterPanelTop.frame = CGRectMake(self.photoponShutterPanelTop.frame.origin.x, self.photoponShutterPanelTop.frame.origin.y - self.photoponShutterPanelTop.frame.size.height, self.photoponShutterPanelTop.frame.size.width, self.photoponShutterPanelTop.frame.size.height);
                
                self.photoponShutterPanelBottom.frame = CGRectMake(self.photoponShutterPanelBottom.frame.origin.x, self.photoponShutterPanelBottom.frame.origin.y + self.photoponShutterPanelBottom.frame.size.height, self.photoponShutterPanelBottom.frame.size.width, self.photoponShutterPanelBottom.frame.size.height);
                
            }completion:^(BOOL finished) {
                
                if (finished) {
                    
                    [self.view setHidden:YES];
                    
                    /*
                    [self.photoponShutterPanelTop setHidden:YES];
                    [self.photoponShutterPanelBottom setHidden:YES];
                    
                    [self.photoponShutterSceneBackgroundView setHidden:YES];
                    [self.photoponShutterSceneForegroundView setHidden:YES];
                    */
                    
                    
                    
                    
                    
                    
                    
                    /*
                    [self.photoponShutterPanelTop setAlpha:0.0f];
                    [self.photoponShutterPanelBottom setAlpha:0.0f];
                    
                    [self.photoponShutterSceneBackgroundView setAlpha:0.0f];
                    [self.photoponShutterSceneForegroundView setAlpha:0.0f];
                    * /
                    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidOpenShutter object:nil];
                    
                    
                    
                    //[self.view removeFromSuperview];
                    
                    
                    
                    /*
                    [UIView animateWithDuration:FADE_TIMING delay:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        
                        
                        //[NSNotificationCenter defaultCenter] postNotification:(NSNotification *)
                        
                        
                        
                        / * 
                        if (self.photoponNewPhotoponCompositionViewMode==PhotoponNewPhotoponCompositionViewModeCreate){
                            self.photoponHeaderPanel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:PHOTOPON_OVERLAY_ALPHA];
                            self.photoponFooterPanel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:PHOTOPON_OVERLAY_ALPHA];
                        }else{
                            self.photoponHeaderPanel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
                            self.photoponFooterPanel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
                        }* /
                        
                         
                         
                        //self.photoponShutterViewBottom.frame = CGRectMake(self.photoponShutterViewBottom.frame.origin.x, self.photoponShutterViewBottom.frame.origin.y + self.photoponShutterViewBottom.frame.size.height, self.photoponShutterViewBottom.frame.size.width, self.photoponShutterViewBottom.frame.size.height);
                        
                    }completion:nil];
                    * /
                    
                    
                }
                
            }];
            
        }
        
    }];
    
    
    
    
}
*/

- (void) open {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ON MAIN THREAD FAILURE!!! OPENSHUTTER IS NOT MAIN THREAD WARNING!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self performSelectorOnMainThread:@selector(openOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ALREADY ON MAIN THREAD!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self openOnMainThread];
    }
}

- (void) openOnMainThread {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    [self configureViewForModeClose];
    
    [UIView animateWithDuration:SLIDE_TIMING_EXTENDED delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.photoponShutterSceneForegroundView.frame = [PhotoponNewPhotoponUtility photoponShutterSceneBackgroundFrameOpen];
        
        self.photoponShutterSceneBackgroundView.frame = [PhotoponNewPhotoponUtility photoponShutterSceneForegroundFrameOpen];
        
        //CGRectMake(self.photoponShutterSceneForegroundView.frame.origin.x - self.photoponShutterSceneForegroundView.frame.size.width, self.photoponShutterSceneForegroundView.frame.origin.y, self.photoponShutterSceneForegroundView.frame.size.width, self.photoponShutterSceneForegroundView.frame.size.height);
        
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.photoponShutterPanelTop.frame = [PhotoponNewPhotoponUtility photoponShutterTopFrameOpen];
                
                self.photoponShutterPanelBottom.frame = [PhotoponNewPhotoponUtility photoponShutterBottomFrameOpen];
                
                // CGRectMake(self.photoponShutterPanelBottom.frame.origin.x, self.photoponShutterPanelBottom.frame.origin.y + self.photoponShutterPanelBottom.frame.size.height, self.photoponShutterPanelBottom.frame.size.width, self.photoponShutterPanelBottom.frame.size.height);
                
            }completion:^(BOOL finished) {
                
                if (finished) {
                    
                    
                    
                    [self configureViewForModeOpen];
                    
                    [self.view setHidden:YES];
                    
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidOpenShutter object:nil];
                    
                }
                
            }];
            
        }
        
    }];
    
}

- (void) close {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (![NSThread isMainThread]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ON MAIN THREAD FAILURE!!! OPENSHUTTER IS NOT MAIN THREAD WARNING!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self performSelectorOnMainThread:@selector(openOnMainThread) withObject:nil waitUntilDone:NO];
    } else {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ALREADY ON MAIN THREAD!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self openOnMainThread];
    }
}

- (void) closeOnMainThread {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    
    if (![NSThread isMainThread]) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ON MAIN THREAD FAILURE!!! OPENSHUTTER IS NOT MAIN THREAD WARNING!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
    } else {
		
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            OPENSHUTTER ALREADY ON MAIN THREAD!!!!!!!!!!!!", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
	}
    
    [self configureViewForModeOpen];
    
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.photoponShutterPanelTop.frame = [PhotoponNewPhotoponUtility photoponShutterTopFrameDefault];
        
        //CGRectMake(self.photoponShutterPanelTop.frame.origin.x, self.photoponShutterPanelTop.frame.origin.y - self.photoponShutterPanelTop.frame.size.height, self.photoponShutterPanelTop.frame.size.width, self.photoponShutterPanelTop.frame.size.height);
        
        self.photoponShutterPanelBottom.frame = [PhotoponNewPhotoponUtility photoponShutterBottomFrameDefault];
        
        // CGRectMake(self.photoponShutterPanelBottom.frame.origin.x, self.photoponShutterPanelBottom.frame.origin.y + self.photoponShutterPanelBottom.frame.size.height, self.photoponShutterPanelBottom.frame.size.width, self.photoponShutterPanelBottom.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            [UIView animateWithDuration:SLIDE_TIMING_EXTENDED delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.photoponShutterSceneBackgroundView.frame = [PhotoponNewPhotoponUtility photoponShutterSceneFrameDefault];
                
                //CGRectMake(self.photoponShutterSceneBackgroundView.frame.origin.x + self.photoponShutterSceneBackgroundView.frame.size.width, self.photoponShutterSceneBackgroundView.frame.origin.y, self.photoponShutterSceneBackgroundView.frame.size.width, self.photoponShutterSceneBackgroundView.frame.size.height);
                
                self.photoponShutterSceneForegroundView.frame = [PhotoponNewPhotoponUtility photoponShutterSceneFrameDefault];
                
                //CGRectMake(self.photoponShutterSceneForegroundView.frame.origin.x - self.photoponShutterSceneForegroundView.frame.size.width, self.photoponShutterSceneForegroundView.frame.origin.y, self.photoponShutterSceneForegroundView.frame.size.width, self.photoponShutterSceneForegroundView.frame.size.height);
                
            }completion:^(BOOL finished) {
                
                if (finished) {
                    
                    [self configureViewForModeClose];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoponNotificationPhotoponNewPhotoponShutterViewControllerDidCloseShutter object:nil];
                    
                }
                
            }];
            
            
        }
        
    }];
    
    
    
}

- (void) hide{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
