//
//  TicketMainViewController.m
//  Hostaria
//
//  Created by iOS on 04/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "TicketMainViewController.h"
#import "TicketInviteViewController.h"

@interface TicketMainViewController ()<TicketInviteDelegate>{
    TicketInviteViewController *ticketinvite;
}

@end

@implementation TicketMainViewController
@synthesize delegate;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    

    NSLog(@"appeared ticket main");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view setNeedsLayout];
    [self.loginButton setNeedsDisplay];
    [self.loginButton setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.loginButton layoutIfNeeded];

    self.loginButton.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.loginButton.selectiveBordersColor = [UIColor blackColor];
    self.loginButton.selectiveBordersWidth = 1.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"ticketInviteAccess"]) {
        NSLog(@"invite segue");
        ticketinvite = (TicketInviteViewController *) [segue destinationViewController];
        ticketinvite.delegate=self;
    

    }
}

-(void)clickedBuy:(id)sender{
    if ([delegate respondsToSelector:@selector(buyClick:)]) {
        [delegate buyClick:sender];
    }

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
