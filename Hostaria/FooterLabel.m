//
//  FooterLabel.m
//  Hostaria
//
//  Created by iOS on 15/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "FooterLabel.h"

@implementation FooterLabel




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {10, 0, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
