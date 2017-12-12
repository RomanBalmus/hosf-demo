//
//  AlertViewController.m
//  Hostaria
//
//  Created by iOS on 15/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController (){
    NSInteger ticketAmount;
    NSInteger ticketlimit;

}

@end

@implementation AlertViewController
@synthesize delegate;




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.ticketCount.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop |AUISelectiveBordersFlagRight | AUISelectiveBordersFlagLeft ;
    self.ticketCount.selectiveBordersColor = [self getUIColorObjectFromHexString:@"#6F3222" alpha:1] ;
    self.ticketCount.selectiveBordersWidth = 1.0;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
    self.containerView.layer.borderWidth =0.8f;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.masksToBounds=YES;
    
    self.nextButton.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.nextButton.selectiveBordersColor = [UIColor blackColor];
    self.nextButton.selectiveBordersWidth = 1.0;
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)dismissSelf{
    NSLog(@"dismiss self2222232");
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alertContainerVisible"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    /*if ([delegate respondsToSelector:@selector(dismissSelfFromParent)]) {
        [delegate dismissSelfFromParent];
        NSLog(@"dismiss self;from parent");
    }*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setTicketName:(NSString *)ticketName ticketDescription:(NSString *)description andCount:(NSInteger )count indexPath:(NSIndexPath*)index limit:(NSInteger)limit{
    cellPath = index;
    ticketAmount = count;
    ticketlimit=limit;
    [self.ticketCount setTitle:[NSString stringWithFormat:@"%ld",(long)ticketAmount] forState:UIControlStateNormal];
    self.ticketDescription.text = description;
    self.ticketName.text = ticketName;
    NSLog(@"ticket amount on alert: %ld",(long)ticketAmount);

    if (ticketAmount==0) {
        [self.decrBtn setEnabled:NO];
    }else if (ticketAmount==ticketlimit){
        [self.incrBtn setEnabled:NO];
    }else{
        [self.incrBtn setEnabled:YES];
        [self.decrBtn setEnabled:YES];

    }

}

- (IBAction)goNext:(id)sender {
    [self dismissSelf];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [self.containerView convertPoint:locationPoint fromView:self.view];
    if (![self.containerView pointInside:viewPoint withEvent:event]) {
        [self dismissSelf];
           
            }
}
- (IBAction)incrementTicket:(id)sender {
    
    ticketAmount ++;
    [self.ticketCount setTitle:[NSString stringWithFormat:@"%ld",(long)ticketAmount] forState:UIControlStateNormal];
    
    if ([delegate respondsToSelector:@selector(incrementBy:indexPath:)]) {
        [delegate incrementBy:ticketAmount indexPath:cellPath];
        NSLog(@"dismiss self;");
    }
    
    if (ticketAmount == ticketlimit) {
        UIButton *btn = (UIButton*)sender;
        [btn setEnabled:NO];
    }else{
        [self.decrBtn setEnabled:YES];
    }
}

- (IBAction)decrementTicket:(id)sender {
    ticketAmount --;

    [self.ticketCount setTitle:[NSString stringWithFormat:@"%ld",(long)ticketAmount] forState:UIControlStateNormal];
    if ([delegate respondsToSelector:@selector(decrementBy:indexPath:)]) {
        [delegate decrementBy:ticketAmount indexPath:cellPath];
        NSLog(@"dismiss self;");
    }
    if (ticketAmount == 0) {
        UIButton *btn = (UIButton*)sender;
        [btn setEnabled:NO];
    }else{
        [self.incrBtn setEnabled:YES];
    }
}
@end
