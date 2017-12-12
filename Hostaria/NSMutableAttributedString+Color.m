//
//  NSMutableAttributedString+Color.m
//  Hostaria
//
//  Created by iOS on 04/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "NSMutableAttributedString+Color.h"

@implementation NSMutableAttributedString (Color)

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color
{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment                = NSTextAlignmentCenter;
        [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }
}
@end
