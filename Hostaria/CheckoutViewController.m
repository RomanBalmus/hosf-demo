//
//  CheckoutViewController.m
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "CheckoutViewController.h"
#import "FacturableViewController.h"
#import "ShippingViewController.h"
#import "ProductToBuy.h"
#define kPayPalEnvironment PayPalEnvironmentSandbox
//#define kPayPalEnvironment PayPalEnvironmentProduction

@interface CheckoutViewController ()<CAPSPageMenuDelegate,FactureDelegate,ShippDelegate,APIManagerDelegate>{
    NSMutableDictionary *userData;
    NSMutableArray *itemsToBuy;
    UIBarButtonItem *closeBtn;
    NSInteger totalProducts;
    float totalProductPrice;
    float totalShippingPrice;

}
@property (nonatomic) CAPSPageMenu *pageMenu;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation CheckoutViewController

-(void)setProducts:(NSMutableArray *)products{
    itemsToBuy=products;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
   /* UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;*/
   // UILabel *titleView = [UILabel new];
   // titleView.numberOfLines = 0;
   // titleView.textAlignment = NSTextAlignmentCenter;
   
    

    
    totalProducts = 0;
    totalProductPrice = 0.f;
    for (ProductToBuy *prd in itemsToBuy) {
        totalProducts = totalProducts +  prd.quantity.integerValue;
        totalProductPrice = totalProductPrice + prd.productTotalPrice.floatValue;
    }
    
    //titleView.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld Prodotti: Totale (escluso spedizione) %.02f €)",(long)totalProducts,totalProductPrice] attributes: self.navigationController.navigationBar.titleTextAttributes];
    //titleView.textColor=[UIColor blackColor];
    //[titleView sizeToFit];
   // self.navigationItem.titleView = titleView;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 4;
    label.font = [UIFont boldSystemFontOfSize: 12.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%ld Prodotti: Totale (escluso spedizione) %.02f €)",(long)totalProducts,totalProductPrice];
    self.navigationItem.titleView = label;
    [self setPayPalEnvironment:self.environment];

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

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStylePlain target:self action:@selector(userDidCancelPayment)];
    
    self.navigationItem.rightBarButtonItem = closeBtn;
  
    userData = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];
    if ([self dictionary:userData hasKey:@"myTickets"]) {
        [userData removeObjectForKey:@"myTickets"];
    }
    
    if ([self dictionary:userData hasKey:@"tickets"]) {
        [userData removeObjectForKey:@"tickets"];
    }
    
    NSLog(@"user data: %@",userData);

    FacturableViewController *facture = [[FacturableViewController alloc]initWithNibName:@"FacturableViewController" bundle:nil];
    facture.delegate=self;
    ShippingViewController *ship = [[ShippingViewController alloc]initWithNibName:@"ShippingViewController" bundle:nil];
    ship.delegate=self;
    [facture setUserData:userData];
    [ship setUserData:userData];

    facture.title = @"Fatturazione";
    ship.title = @"Spedizione";

  
    NSArray *controllerArray = @[facture, ship];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl:@(NO),
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [self getUIColorObjectFromHexString:@"#BD172C" alpha:1],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor:[self getUIColorObjectFromHexString:@"#BD172C" alpha:1],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"PierSans" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 1.5, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    _pageMenu.delegate=self;
    for (UIView*view in _pageMenu.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView*scv=(UIScrollView*)view;
            scv.scrollEnabled=NO;
        }
    }
    
    [_pageMenu setCannotTypeMenuItem:YES];
    [self.view addSubview:_pageMenu.view];
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.merchantName = @"Hostaria";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"http://gestione.hostariaverona.com/privacypolicy"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"http://gestione.hostariaverona.com/privacypolicy"];
    self.environment = kPayPalEnvironment;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)dictionary:(NSDictionary*)info hasKey:(NSString*)key{
    BOOL haveKey;
    
    if (info[key]){
        NSLog(@"Exists");
        if( [info objectForKey:key] == nil ||
           [[info objectForKey:key] isEqual:[NSNull null]] ||
           [info objectForKey:key] == [NSNull null])
        {
            NSLog(@"key is null");
            
            haveKey = NO;
        }
        else
        {
            NSLog(@"%@",[info valueForKey:key]);
            haveKey = YES;
        }
    }else{
        NSLog(@"Does not exist");
        haveKey=NO;
        
    }
    
    
    return haveKey;
}
#pragma mark - FactureDelegate
-(void)factureData:(id)userInfo{
    [userData setObject:userInfo forKey:@"factureData"];
    
    if ([self dictionary:userData hasKey:@"shippingData"]) {
        [userData removeObjectForKey:@"shippingData"];
    }

    [_pageMenu myMoveToPage:1];
}
/*-(void)bothData:(id)userInfo{
    [userData setObject:userInfo forKey:@"factureData"];
    [userData setObject:userInfo forKey:@"shippingData"];
    [self showBuyOption];

}
*/
-(void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index{
    if ([controller isKindOfClass:[ShippingViewController class]]) {
        ShippingViewController *ship=(ShippingViewController*)controller;
        
        NSLog(@"go to ship: %@",userData);
        
        [ship setFactureData:[userData objectForKey:@"factureData"]];
    }
}

-(void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index{
    if ([controller isKindOfClass:[ShippingViewController class]]) {
        ShippingViewController *ship=(ShippingViewController*)controller;
        
        NSLog(@"will ship: %@",userData);
        
        [ship setFactureData:[userData objectForKey:@"factureData"]];
    }
}
#pragma mark - ShippingDelegate

-(void)shippData:(id)userInfo{
    [userData setObject:userInfo forKey:@"shippingData"];
   // [self showBuyOption];
    NSMutableArray*cleanData=[[NSMutableArray alloc]init];
    for (ProductToBuy*prd in itemsToBuy) {
        NSMutableDictionary *dcit =[[NSMutableDictionary alloc]init];
        [dcit setObject:prd.productTotalPrice forKey:@"productTotalPrice"];
        [dcit setObject:prd.price forKey:@"productPrice"];
        [dcit setObject:prd.quantity forKey:@"productQuantity"];
        [dcit setObject:prd._id forKey:@"productId"];
        [cleanData addObject:dcit];
        
        
    }
    [userData setObject:[userData objectForKey:@"id_user"] forKey:@"userId"];
    [userData setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"event_id"] forKey:@"eventId"];

    
    [userData setObject:cleanData forKey:@"itemsToBuy"];
    [userData setObject:[NSString stringWithFormat:@"%ld",(long)totalProducts] forKey:@"totNumQuantity"];

    [userData setObject:[NSString stringWithFormat:@"%lu",(unsigned long)cleanData.count] forKey:@"totalNumProducts"];
    [userData setObject:@"" forKey:@"paymentMethod"];
    [userData setObject:@"" forKey:@"paymentResponce"];
    
    [userData setObject:[NSString stringWithFormat:@"%.02f",totalProductPrice] forKey:@"price_to_pay"];

    
    [userData setObject:[NSString stringWithFormat:@"%.02f",totalShippingPrice] forKey:@"shippingAmount"];

    
    [self saveOrder:userData];

}


-(void)updateTitle:(Country *)userInfo{
    NSString* shippTotalString=@"";
    float shippingPrice = 0;
    
    shippingPrice=shippingPrice+ userInfo.less6b.floatValue;
    
    float packageFloat=(float) totalProducts/6;
    int totalPackages =(int) ceil(packageFloat);
    
    NSLog(@"pacakges ceil %d",totalPackages);
    
    totalPackages=totalPackages-1;
    NSLog(@"pacakges for -1 %d",totalPackages);

    if (totalPackages>0){
        shippingPrice=shippingPrice+(userInfo.more6b.floatValue*totalPackages);//new BigDecimal(shippingObj.get("more6b")).multiply(totalPackages);
    }
    
    
    shippTotalString=[NSString stringWithFormat:@"%.02f",shippingPrice];//String.format("%.2f", shippingPrice);
    NSLog(@"totashipping %f",shippingPrice);

    totalShippingPrice=shippingPrice;
  
    shippTotalString=[NSString stringWithFormat:@"Spedizione: +%@ €",shippTotalString];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 4;
    label.font = [UIFont boldSystemFontOfSize: 12.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%ld Prodotti: Totale (escluso spedizione) %.02f €) %@",(long)totalProducts,totalProductPrice,shippTotalString];
    self.navigationItem.titleView = label;
}
-(void)saveOrder:(NSDictionary*)tosave{
    
    
    API.delegate=self;
    
    [API saveOrder:tosave onView:self.view];
}

#pragma - mark DELEGATE ORDER SAVED

-(void)orderSaved:(APIManager *)manager didFinishLoading:(id)item{
    [self showBuyOption:(NSDictionary*)item];
}
-(void)orderSaved:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"errore%@",error.debugDescription);
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Errore"
                                                                        message: error.localizedDescription
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                 style: UIAlertActionStyleDefault
                                                               handler: ^(UIAlertAction *action) {
                                                                   NSLog(@"ok button tapped!");
                                                                   
                                                                  
                                                               }];
    
    [controller addAction: alertActionConfirm];
    

    
    
    
    [self presentViewController: controller animated: YES completion: nil];

}
-(void)showBuyOption:(NSDictionary*)dict{
    
    [userData setObject:[dict objectForKey:@"orderNumber"] forKey:@"orderNumber"];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
        [self dismissViewControllerAnimated:actionSheet completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"via PayPal" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // take photo button tapped.
        [self buyWithPayPal];
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"via Credit/Debit Card" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        
        
        
        [self buyWithLemonWay];
        
    }]]; ///*******************************************THIS IS DISABLED************************************************
    
    
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}



-(void)buyWithPayPal
{
  
    
    
    NSMutableArray *items =[NSMutableArray new];
    float total = 0.0f;
    for (ProductToBuy *prd in itemsToBuy) {
        
        
        total += [prd.price floatValue]*[prd.quantity integerValue];
        //S
        
        PayPalItem *item3 = [PayPalItem itemWithName:prd.name
                                        withQuantity:[prd.quantity integerValue]
                                           withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",prd.price]]
                                        withCurrency:@"EUR"
                                             withSku:[NSString stringWithFormat:@"SKU_00112334%@",prd._id]];
        [items addObject:item3];
        
    }
    NSLog(@"total: %.02f",total);
    NSLog(@"paypal items %@",items);
    
    
    
    [userData setObject:[NSString stringWithFormat:@"%.02f",total] forKey:@"price_to_pay"];

    if ([self dictionary:userData hasKey:@"myTickets"]) {
        [userData removeObjectForKey:@"myTickets"];
    }
    
    
    if ([self dictionary:userData hasKey:@"tickets"]) {
        [userData removeObjectForKey:@"tickets"];
    }
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:[userData objectForKey:@"shippingAmount"]];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *totalpaypal = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    NSLog(@"paypal items total %@",totalpaypal);
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = totalpaypal;
    payment.currencyCode = @"EUR";
    payment.shortDescription = @"Vini - Hostaria";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
        NSLog(@"payment not processable %d",payment.processable);
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = NO;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    
    
    
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                target:self
                                action:@selector(userDidCancelPayment)];
    paymentViewController.navigationItem.leftBarButtonItem = itembar;
    [paymentViewController.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
    
    //[navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_red"]forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
}



#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success! :%@",[completedPayment description]);
    
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    
    
    

    
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSString* shippTotalString=[NSString stringWithFormat:@"Spedizione: +%.02f €",totalShippingPrice];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 4;
        label.font = [UIFont boldSystemFontOfSize: 12.0f];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"%ld Prodotti: Totale (escluso spedizione) %.02f €) %@",(long)totalProducts,totalProductPrice,shippTotalString];
        self.navigationItem.titleView = label;
    }];
    
}
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    NSLog(@"all data: %@",userData);
    [userData setObject:@"paypal" forKey:@"paymentMethod"];
    
    NSError *error2;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation // Here you can pass array or dictionary
                                                        options:0 // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error2];
    NSString *jsonString2;
    if (jsonData2) {
        jsonString2 = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error2);
        jsonString2 = @"";
    }
    NSLog(@"Your JSON String2 is %@", jsonString2);
    
    
    [userData setObject:jsonString2 forKey:@"paymentResponce"];
    
   /* NSMutableArray*cleanData=[[NSMutableArray alloc]init];
    for (ProductToBuy*prd in itemsToBuy) {
        NSMutableDictionary *dcit =[[NSMutableDictionary alloc]init];
        [dcit setObject:prd.productTotalPrice forKey:@"productTotalPrice"];
        [dcit setObject:prd.price forKey:@"productPrice"];
        [dcit setObject:prd.quantity forKey:@"productQuantity"];
        [dcit setObject:prd._id forKey:@"productId"];
        [cleanData addObject:dcit];


    }
    
    NSLog(@"itemsToBuy: %@",cleanData);
*/
    NSLog(@"paymentNonce: %@",completedPayment.confirmation);

   [API buyWineWithPayPal:userData onView:self.view];
    
}

-(void)userDidCancelPayment{
    NSLog(@"dismiss payment by user");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - LemonWay

-(void)buyWithLemonWay{
    
    
    
    
    float total = 0.0f;
    for (ProductToBuy *prd in itemsToBuy) {
        total += [prd.price floatValue]*[prd.quantity integerValue];
        
        
    }
    NSLog(@"totallemon: %.02f",total);
    
    
    
    [userData setObject:[NSString stringWithFormat:@"%.02f",total] forKey:@"price_to_pay"];
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.collectCVV=YES;
    scanViewController.useCardIOLogo=NO;
    scanViewController.collectCardholderName=YES;
    scanViewController.hideCardIOLogo=YES;
    [self presentViewController:scanViewController animated:YES completion:nil];

}



#pragma - mark WINEBUY DELEGATE

-(void)buyWine:(APIManager *)manager didFailWithError:(NSError *)error{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Errore"
                                                                        message:error.localizedDescription
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                 style: UIAlertActionStyleDefault
                                                               handler: ^(UIAlertAction *action) {
                                                                   NSLog(@"ok button tapped!");
                                                                   
                                                                   
                                                               }];
    
    [controller addAction: alertActionConfirm];

    
    [self presentViewController: controller animated: YES completion: nil];

    
}
-(void)buyWine:(APIManager *)manager didFinishLoading:(id)item{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:[item objectForKey:@"description"]
                                                                        message:nil
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                 style: UIAlertActionStyleDefault
                                                               handler: ^(UIAlertAction *action) {
                                                                   NSLog(@"ok button tapped!");
                                                                   [self dismissViewControllerAnimated:YES completion:^(void){
                                                                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart_items"];
                                                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCartTable" object:nil];

                                                                   }];
                                                                   
                                                               
        
                                                               }];
    
    [controller addAction: alertActionConfirm];
    
   
    
    [self presentViewController: controller animated: YES completion: nil];

    
}

#pragma CARD.IO
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv);
    // Use the card info...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
    NSDictionary * carddata = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",info.cardNumber],@"card_number",[NSString stringWithFormat:@"%02lu",info.expiryMonth],@"card_expiry_month",[NSString stringWithFormat:@"%02lu",info.expiryYear],@"card_expiry_year",[NSString stringWithFormat:@"%@",info.cvv],@"card_cvv",[NSString stringWithFormat:@"%@",info.cardholderName],@"card_holder_name",[CardIOCreditCardInfo displayStringForCardType:info.cardType usingLanguageOrLocale:@"IT"],@"card_type", nil] ;
    
    
    NSLog(@"card dadta %@",carddata);
    [userData setObject:@"lemonway" forKey:@"paymentMethod"];
    NSError *errorf;
    NSData *jsonDataF = [NSJSONSerialization dataWithJSONObject:carddata // Here you can pass array or dictionary
                                                        options:0 // Pass 0 if you don't care about the readability of the generated string
                                                          error:&errorf];
    NSString *jsonStringF;
    if (jsonDataF) {
        jsonStringF = [[NSString alloc] initWithData:jsonDataF encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", errorf);
        jsonStringF = @"";
    }
    NSLog(@"Your JSON facture is %@", jsonStringF);
    [userData setObject:jsonStringF forKey:@"paymentResponce"];
    [API buyWineWithLemonWay:userData onView:self.view];
    
    
    
    
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
