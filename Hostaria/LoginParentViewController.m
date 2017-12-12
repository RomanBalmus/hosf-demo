//
//  LoginParentViewController.m
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "LoginParentViewController.h"
#import "LoginTableViewController.h"
@interface LoginParentViewController (){
    LoginTableViewController * childRef;
}
@property (nonatomic) BOOL returnButton;
@end

@implementation LoginParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;

   
    [self.signInButton addTarget:self action:@selector(checkDataAndLogin:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)checkDataAndLogin:(id)sender{
    NSDictionary *logData=[childRef getDataToLogin];
    NSLog(@"logData: %@",logData);
    [API loginUser:logData onView:self.view];
}
-(void)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}
-(void)addReturnButton:(BOOL)add{
    self.returnButton = add;
    if (self.returnButton) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
        
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"loginView"]) {
        childRef = (LoginTableViewController *) [segue destinationViewController];
        // do something with the AlertView's subviews here...
    }
}
@end
