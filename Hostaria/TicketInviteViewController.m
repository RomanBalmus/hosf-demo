//
//  TicketInviteViewController.m
//  Hostaria
//
//  Created by iOS on 08/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "TicketInviteViewController.h"

@interface TicketInviteViewController ()

@end

@implementation TicketInviteViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.ticketInviteBuyBtn addTarget:self action:@selector(clickBuy:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickBuy:(id)sender{
    
    NSLog(@"clickBuy");
    
    if ([delegate respondsToSelector:@selector(clickedBuy:)]) {
        [delegate clickedBuy:sender];
    }
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.ticketInviteBuyBtn.layer.borderColor=[self getUIColorObjectFromHexString:@"#6F3222" alpha:1].CGColor;
    self.ticketInviteBuyBtn.layer.borderWidth=2;
    self.ticketInviteBuyBtn.layer.cornerRadius=15;
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)checkForiPhone4S{
    if ([UIScreen mainScreen].bounds.size.height == 400) {
        NSLog(@"iphone 4s");
    }else{
        CGRect frame=self.ticketInviteBuyBtn.frame;
        self.ticketInviteBuyBtn.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+30);
    }
}
/*func checkForiPhone4S()
{
    if (UIScreen.mainScreen().bounds.size.height == 480) {
        println("It is an iPhone 4S - Set constraints")
        
        listPickerView.transform = CGAffineTransformMakeScale(1, 0.8);
        
        var constraintHeight = NSLayoutConstraint(item: listPickerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        
        self.view.addConstraint(constraintHeight)
        
        datePickerView.transform = CGAffineTransformMakeScale(1, 0.8);
        
        var constraintHeightDate = NSLayoutConstraint(item: datePickerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        
        self.view.addConstraint(constraintHeightDate)
        
    }
}*/
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
