//
//  SponsorTwoViewController.m
//  Hostaria
//
//  Created by iOS on 31/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "SponsorTwoViewController.h"

@interface SponsorTwoViewController (){
    NSDictionary *data;
}

@end

@implementation SponsorTwoViewController
-(void)setUserData:(NSDictionary*)info{
    data=info;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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