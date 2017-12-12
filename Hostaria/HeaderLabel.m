//
//  HeaderLabel.m
//  Hostaria
//
//  Created by iOS on 24/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "HeaderLabel.h"

@implementation HeaderLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 40, 0, 40};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
