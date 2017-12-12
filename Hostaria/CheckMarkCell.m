//
//  CheckMarkCell.m
//  Hostaria
//
//  Created by iOS on 24/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "CheckMarkCell.h"

@implementation CheckMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}
- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
-(void)fillButton:(BOOL)value{
    [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (value) {
            [self.ticketCheckBtn setBackgroundColor:[self getUIColorObjectFromHexString:@"#BFA372" alpha:1]];
        }else{
            [self.ticketCheckBtn setBackgroundColor:[UIColor whiteColor]];
            self.ticketCheckBtn.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop |AUISelectiveBordersFlagLeft |AUISelectiveBordersFlagRight;
            self.ticketCheckBtn.selectiveBordersColor = [self getUIColorObjectFromHexString:@"#BFA372" alpha:1];
            self.ticketCheckBtn.selectiveBordersWidth = 10.0;
        }
    } completion:^(BOOL finished) {
        [self layoutIfNeeded];
       
    }];
}
@end
