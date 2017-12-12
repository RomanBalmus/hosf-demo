//
//  PrePayViewController.m
//  Hostaria
//
//  Created by iOS on 13/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "PrePayViewController.h"

@interface PrePayViewController () <APIManagerDelegate>

@end

@implementation PrePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    API.delegate=self;
    
    [API getPaymentTokenOnView:self.view];

    // Do any additional setup after loading the view from its nib.

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"pay" style:UIBarButtonItemStylePlain target:self action:@selector(tappedMyPayButton)];
    // TODO: Switch this URL to your own authenticated API
 
}
-(void)getPaymentToken:(APIManager *)manager didFinishLoading:(id)item{
    NSDictionary *json = (NSDictionary*)item;



    NSString *clientToken = [json objectForKey:@"data"];
   // NSLog(@"token : %@",clientToken);
   // self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
}
-(void)getPaymentToken:(APIManager *)manager didFailWithError:(NSError *)error{
    
}
-(void)pasteNonceToServer:(APIManager *)manager didFinishLoading:(id)item{
    NSData *data = (NSData*)item;
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    
    
    
    NSLog(@"pasteNonceToServer json: %@",json);
}
-(void)pasteNonceToServer:(APIManager *)manager didFailWithError:(NSError *)error{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)tappedMyPayButton {
    
    // If you haven't already, create and retain a `BTAPIClient` instance with a tokenization
    // key or a client token from your server.
    // Typically, you only need to do this once per session.
    //self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:aClientToken];
    
    
    BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
    paymentRequest.summaryTitle = @"Our Fancy Magazine";
    paymentRequest.summaryDescription = @"53 Week Subscription";
    paymentRequest.displayAmount = @"$19.00";
    paymentRequest.amount = @"103.01";
    paymentRequest.callToActionText = @"$19 - Pay Now";
    paymentRequest.shouldHideCallToAction = NO;
    
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    dropInViewController.paymentRequest = paymentRequest;
    dropInViewController.title = @"Check Out";

    // This is where you might want to customize your view controller (see below)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:

    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
   // NSLog(@"nonce to server: %@",paymentMethodNonce.nonce);
    [self dismissViewControllerAnimated:YES completion:^{
        [API pasteNonceToServer:paymentMethodNonce.nonce withData:nil onView:self.view];
    }];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}*/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
