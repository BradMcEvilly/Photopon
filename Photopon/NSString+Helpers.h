//
//  NSString+Helpers.h
//  WordPress
//
//  Created by John Bickerstaff on 9/9/09.
// //

#import <UIKit/UIKit.h>

@interface NSString (Helpers)

// helper functions
- (NSString *) stringByUrlEncoding;
- (NSString *) md5;
+ (NSString *) openTagWithName:(NSString*)tagName;
+ (NSString *) closeTagWithName:(NSString*)tagName;
+ (NSString *) scanString:(NSString *)aSourceString
                 startTag:(NSString *)startTag
                   endTag:(NSString *)endTag;

- (NSString *) wrapInTagNamed:(NSString *)tagName;
- (NSString *) stringFromTagNamed:(NSString*)tagName;
- (NSMutableDictionary *) dictionaryFromQueryString;

- (NSString *)stringByReplacingHTMLEmoticonsWithEmoji;
- (NSString *)stringByStrippingHTML;




/*
- (NSString *) stringByStrippingHTML;
- (NSString *) openTagWithName:(NSString *)tagName;
- (NSString *) closeTagWithName:(NSString *)tagName;
- (NSString *) stringFromTagNamed:(NSString*)tagName;
- (NSMutableDictionary *) dictionaryFromQueryString;
*/

@end
