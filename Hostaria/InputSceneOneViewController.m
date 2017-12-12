//
//  InputSceneOneViewController.m
//  Hostaria
//
//  Created by iOS on 04/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "InputSceneOneViewController.h"

@interface InputSceneOneViewController ()

@end

@implementation InputSceneOneViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   /* CALayer *borderUsername = [CALayer layer];
    CGFloat borderWidth = 2;
    borderUsername.borderColor = [UIColor darkGrayColor].CGColor;
    borderUsername.frame = CGRectMake(0, self.nameTF.frame.size.height - borderWidth, self.nameTF.frame.size.width, self.nameTF.frame.size.height);
    borderUsername.borderWidth = borderWidth;
    [self.nameTF.layer addSublayer:borderUsername];
    self.nameTF.layer.masksToBounds = YES;
    
    CALayer *borderTopUsername = [CALayer layer];
    borderTopUsername.borderColor = [UIColor darkGrayColor].CGColor;
    borderTopUsername.frame = CGRectMake(0, self.nameTF.frame.size.height/2 -borderWidth, self.nameTF.frame.size.width, self.nameTF.frame.size.height);
    borderTopUsername.borderWidth = borderWidth;
    [self.nameTF.layer addSublayer:borderTopUsername];
    self.nameTF.layer.masksToBounds = YES;*/
 
    
    
 //// [self prefix_addBorder:UIRectEdgeBottom color:[self getUIColorObjectFromHexString:@"#9D9D9C" alpha:0.7] thickness:2 view:self.nameTF];
    //[self prefix_addBorder:UIRectEdgeLeft color:[self getUIColorObjectFromHexString:@"#9D9D9C" alpha:0.7] thickness:2 view:self.nameTF];
    //[self prefix_addBorder:UIRectEdgeRight color:[self getUIColorObjectFromHexString:@"#9D9D9C" alpha:0.7] thickness:2 view:self.nameTF];

    
    
    
    
    //[self.surnameTF.layer addSublayer:border];
    //self.surnameTF.layer.masksToBounds = YES;
    
    
    
   /* CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;*/
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
- (CALayer *)prefix_addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness view:(UIView*)view
{
    
    NSLog(@"f1ramew  : %f",view.frame.size.width);
    [self.view layoutIfNeeded];
    NSLog(@"2framew  : %f",view.frame.size.width);

    [view layoutIfNeeded];
    NSLog(@"3framew  : %f",view.frame.size.width);
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(view.frame) - thickness, CGRectGetWidth(view.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, CGRectGetHeight(view.frame)-(CGRectGetHeight(view.frame)/4), thickness, CGRectGetHeight(view.frame)/4);
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(view.frame) - (thickness*2), CGRectGetHeight(view.frame)-(CGRectGetHeight(view.frame)/4), thickness, CGRectGetHeight(view.frame)/4);
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [view.layer addSublayer:border];
    NSLog(@"ret frame: %@",NSStringFromCGRect(border.frame));
    
    return border;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
