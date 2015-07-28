//
//  UIImageView+Scaling.m
//  Photopon
//
//  Created by Brad McEvilly on 7/21/13.
//  Copyright (c) 2013 Brad McEvilly. All rights reserved.
//

#import "UIImageView+Scaling.h"
#import <SDWebImage/SDImageCache.h>
#import "SDWebImageDownloader.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation UIImageView (Scaling)

-(void)setImageWithURL:(NSURL*)url scaleToSize:(BOOL)scale
{
    if(url.absoluteString.length < 10) return;
    if(!scale){
        [self setImageWithURL:url];
        return;
    }
    __block UIImageView* selfimg = self;
    __block NSString* prevKey = SPRINTF(@"%@_%ix%i", url.absoluteString, (int)self.frame.size.width, (int)self.frame.size.height);
    __block UIImage* prevImage = nil;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        prevImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:prevKey];
        if(prevImage){
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self setImage:prevImage];
            });
        }else{
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderFILOQueueMode progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if(error){
                    [selfimg setImageWithURL:url scaleToSize:scale];
                }else{
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^ {
                        prevImage = [image imageByScalingProportionallyToSize:self.frame.size];
                        if(finished)
                            [[SDImageCache sharedImageCache] storeImage:prevImage forKey:prevKey];
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [self setImage:prevImage];
                        });
                    });
                }
            }];
        }
    });
    
    return;
}

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder scaleToSize:(BOOL)scale
{
    [self setImage:placeholder];
    [self setImageWithURL:url scaleToSize:scale];
}


@end