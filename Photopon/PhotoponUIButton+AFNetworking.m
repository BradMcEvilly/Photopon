//
//  PhotoponUIButton+AFNetworking.h
//  Photopon
//
//  Created by Bradford McEvilly on 6/3/12.
//  Copyright (c) 2012 Insane Idea, Inc. All rights reserved.
//

#import "PhotoponUIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoponUIButton (_AFNetworking)

/*
-(UIImageView*)imageView
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (!self.imageView) {
        
    }
    return self.imageView;
}

- (void)setImageView:(UIImageView *)imageView{
    
    
    
}
* /


- (void)setImageWithURL:(NSURL *)url
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (url==nil) {
        return;
    }
    
    [self.imageView setImageWithURL:url placeholderImage:nil];
    
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    if (url == nil) {
        return;
    }
    
    @try {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            @try {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:[UIImage imageNamed:@"page3.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"            [self.imageView setImageWithURLRequest: ... {      SUCCESS SUCCESS SUCCESS");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            
            
        } failure:^(NSURLRequest* request, NSHTTPURLResponse *response, NSError *error){
            // create subview
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            NSLog(@"            [self.imageView setImageWithURLRequest: ...{      FAILURE FAILURE FAILURE");
            NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
            
            
            
        }];
        
        return;
            //reload data here } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){ //handle errors here }
        /*
        if ( placeholder != nil ) {
            [self.imageView setImageWithURL:url placeholderImage:placeholder];
        }else{
            [self.imageView setImageWithURL:url];
        }* /
    }
    @catch (NSException *exception) {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@            @catch (NSException *exception) { description: %@", self, NSStringFromSelector(_cmd), exception.description);
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
        return;
    }
    @finally {
        
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        NSLog(@"%@ :: %@           @finally {", self, NSStringFromSelector(_cmd));
        NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
        
        
    }
    
    
    
    
    
    /*
    self.progress = 0.0f;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/ *" forHTTPHeaderField:@"Accept"];
    
    [self.imageView setAlpha:0.0f];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.imageView setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest* request, NSHTTPURLResponse *response, UIImage *image){
        
        [weakSelf.imageView setImage:image];
        
        // Animate the image view so that it fades in
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.imageView.alpha = 1.0;
        }];
        
    } failure:^(NSURLRequest* request, NSHTTPURLResponse *response, NSError *error){
        // create subview
        
    }];
     * /
    
}*/

//const long long kDefaultImageSize = 200000; // what should we try for totalBytesExpected if server doesn't provide it
/*
- (void)updateProgressView
{
    double totalTotalBytesRead = 0;
    double totalTotalBytesExpected = 0;
            
    if (self.totalBytesExpected >= 0)
    {
        totalTotalBytesRead += imageDownload.totalBytesRead;
        totalTotalBytesExpected += imageDownload.totalBytesExpected;
    }
    else
    {
        totalTotalBytesRead += imageDownload.totalBytesRead;
        totalTotalBytesExpected += (imageDownload.totalBytesRead > kDefaultImageSize ? imageDownload.totalBytesRead + kDefaultImageSize : kDefaultImageSize);
    }
    
    
    
    if (totalTotalBytesExpected > 0)
        [self.progressView setProgress:totalTotalBytesRead / totalTotalBytesExpected animated:YES];
    else
        [self.progressView setProgress:0.0 animated:NO];
}
*/

@end
