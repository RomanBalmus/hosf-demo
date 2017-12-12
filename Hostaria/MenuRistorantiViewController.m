//
//  MenuRistorantiViewController.m
//  Hostaria
//
//  Created by iOS on 19/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MenuRistorantiViewController.h"

@interface MenuRistorantiViewController (){
    CGFloat originX;
    UIImageView *circle;
    MBProgressHUD *hud;
    UINavigationController *parentNav;

}

@end

@implementation MenuRistorantiViewController
-(void)setupNavigation:(UINavigationController *)navctrl{
    parentNav=navctrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTicket:) name:@"updateTicket" object:nil];
    self.myWebView.delegate=self;
[self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.100menu-di.it/menu-hostaria-2/"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
    [self updateTicket:nil];
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    
    
    //  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.theMap];
    //  self.navigationItem.leftBarButtonItem = buttonItem;
    
}
-(void)updateTicket:(id)sender{
    
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    
    UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
    if ([[dict objectForKey:@"myTickets"]count]>0) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];
        
    }else{
        [ticket removeFromSuperview];
        self.navigationItem.rightBarButtonItem=nil;
        
    }
    
    
}
#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    
    hud.color = [UIColor clearColor];
    
}
- (UIImageView *) animatedCustomImage{
    UIImageView*  imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 136, 136)];
    imgV.contentMode=UIViewContentModeScaleAspectFit;
    
    //Position the explosion image view somewhere in the middle of your current view. In my case, I want it to take the whole view.Try to make the png to mach the view size, don't stretch it
    
    
    //Add images which will be used for the animation using an array. Here I have created an array on the fly
    imgV.animationImages =  @[[UIImage imageNamed:@"Bicchiere GIF.1"],[UIImage imageNamed:@"Bicchiere GIF.2"],[UIImage imageNamed:@"Bicchiere GIF.3"],[UIImage imageNamed:@"Bicchiere GIF.4"],[UIImage imageNamed:@"Bicchiere GIF.5"],[UIImage imageNamed:@"Bicchiere GIF.6"], [UIImage imageNamed:@"Bicchiere GIF.7"],[UIImage imageNamed:@"Bicchiere GIF.8"],[UIImage imageNamed:@"Bicchiere GIF.9"],[UIImage imageNamed:@"Bicchiere GIF.10"],[UIImage imageNamed:@"Bicchiere GIF.11"],[UIImage imageNamed:@"Bicchiere GIF.12"],[UIImage imageNamed:@"Bicchiere GIF.13"],[UIImage imageNamed:@"Bicchiere GIF.14"], [UIImage imageNamed:@"Bicchiere GIF.15"],[UIImage imageNamed:@"Bicchiere GIF.16"],[UIImage imageNamed:@"Bicchiere GIF.17"],[UIImage imageNamed:@"Bicchiere GIF.18"],[UIImage imageNamed:@"Bicchiere GIF.19"],[UIImage imageNamed:@"Bicchiere GIF.20"],[UIImage imageNamed:@"Bicchiere GIF.21"],[UIImage imageNamed:@"Bicchiere GIF.22"],[UIImage imageNamed:@"Bicchiere GIF.23"],[UIImage imageNamed:@"Bicchiere GIF.24"],[UIImage imageNamed:@"Bicchiere GIF.25"],[UIImage imageNamed:@"Bicchiere GIF.26"],[UIImage imageNamed:@"Bicchiere GIF.27"],[UIImage imageNamed:@"Bicchiere GIF.28"]];
    
    //Set the duration of the entire animation
    imgV.animationDuration = 1.2;
    imgV.backgroundColor=[UIColor clearColor];
    //Set the repeat count. If you don't set that value, by default will be a loop (infinite)
    // imgV.animationRepeatCount = 1;
    
    //Start the animationrepeatcount
    [imgV startAnimating];
    
    return imgV;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:errorString
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Carica menù"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.100menu-di.it/menu-hostaria-2/"]]];
                                   
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)showMyTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMyTicket" object:nil];
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
