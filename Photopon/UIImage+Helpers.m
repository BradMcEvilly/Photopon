//
//  UIImage+Helpers.m
//  Photopon
//
//  Created by Brad McEvilly on 3/25/13.
//
//

#import "UIImage+Helpers.h"
#import "PhotoponUtility.h"

#define kTallSuffix @"-568h"

@implementation UIImage (Helpers)

static BOOL mayUseTallerImages;

/*
CGRect screenBounds = [[UIScreen mainScreen] bounds];
if (screenBounds.size.height == 568) {
    // code for 4-inch screen
} else {
    // code for 3.5-inch screen
}   
*/

#pragma mark Helpers
+ (void)load
{
    mayUseTallerImages = CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size);
}
+ (UIImage *)photoponImageNamed:(NSString *)name {
    
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    NSLog(@"%@ :: %@            BEGIN BEGIN BEGIN", self, NSStringFromSelector(_cmd));
    NSLog(@"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    
    NSLog(@"name == %@", name);
    
    if (IS_IPAD) {
        return [UIImage imageNamed:name];
    }
    
    NSString *photoponImageSuffix = [[NSString alloc] initWithFormat:@"%@", kTallSuffix];
    BOOL isTall = NO;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height >= 568)
    isTall = YES;
    
    if (isTall && [name length] > 0  && [name rangeOfString:photoponImageSuffix].location == NSNotFound)
    {
        //Check if is there a path extension or not
        NSString *testName = name;
        if (testName.pathExtension.length > 0) {
            testName = [[[testName stringByDeletingPathExtension] stringByAppendingString:photoponImageSuffix] stringByAppendingPathExtension:[name pathExtension]];
            NSLog(@"if .....    testName == %@", testName);
        } else {
            
            testName = [testName stringByAppendingString:photoponImageSuffix];
            testName = [testName stringByAppendingString:@"@2x.png"];
            NSLog(@"else .....  testName == %@", testName);
        }
        
        UIImage *image = [UIImage imageNamed:testName];
        if (image) {
        
            return [self imageWithCGImage:image.CGImage scale:2.0f orientation:image.imageOrientation];
        
        }
    }
    
    return [self imageNamed:name];
    
}




@end
