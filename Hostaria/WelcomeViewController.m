//
//  WelcomeViewController.m
//  Hostaria
//
//  Created by iOS on 01/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        //  self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.skipBtn addTarget:self action:@selector(skipClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
    self.loginButton.layer.borderColor=[self getUIColorObjectFromHexString:@"#6F3222" alpha:1].CGColor;//  AD0020
    self.loginButton.layer.borderWidth=1;
    self.loginButton.layer.cornerRadius=15;
    
    
    self.registerBtn.layer.borderColor=[self getUIColorObjectFromHexString:@"#6F3222" alpha:1].CGColor;//  AD0020
    self.registerBtn.layer.borderWidth=1;
    self.registerBtn.layer.cornerRadius=15;
    
    

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

-(void)loginClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(welcomeGoToLogin)]) {
        
        [self.delegate welcomeGoToLogin];
    }
}

-(void)registerClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(welcomeGoToRegister)]) {
        
        [self.delegate welcomeGoToRegister];
    }
}
-(void)skipClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(welcomeGoToSkip)]) {
        
        [self.delegate welcomeGoToSkip];
    }
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
