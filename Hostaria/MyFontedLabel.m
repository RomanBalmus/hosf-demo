//
//  MyFontedLabel.m
//  Hostaria
//
//  Created by iOS on 08/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MyFontedLabel.h"

@implementation MyFontedLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Implement font logic depending on screen size
    if ([self.font.fontName rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        NSLog(@"font is not bold");
        self.font = [UIFont fontWithName:@"Custom regular Font" size:self.font.pointSize];
    } else {
        NSLog(@"font is bold");
        self.font = [UIFont fontWithName:@"Custom bold Font" size:self.font.pointSize];
    }
    
}
@end
