//
//  InviteToBuyMainViewController.m
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "InviteToBuyMainViewController.h"
#import "InviteToBuyViewController.h"
#import "InputUserOneViewController.h"
#import "ChooseTicketViewController.h"
#import "AlmostThereViewController.h"
#import "MissingDataOrBuyController.h"
#import "SponsorOneViewController.h"
#import "SponsorOneViewController.h"
#import "ScannerView.h"
#import "WelcomeViewController.h"

/*
 loginType
 0 = app
 1 = fb
 2 = g+
 3 = tw
 */
// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox

typedef NS_ENUM(NSInteger, ViewControllerTransition) {
    ViewControllerTransitionSlideFromTop   = 0,
    ViewControllerTransitionSlideFromLeft,
    ViewControllerTransitionSlideFromBottom,
    ViewControllerTransitionSlideFromRight,
    ViewControllerTransitionRotateFromRight
};
@interface InviteToBuyMainViewController ()<WelcomeDelegate,InputUserOneDelegate,ChooseTicketDelegate,APIManagerDelegate,AlmostThereDelegate,MissingDelegate,CardIOPaymentViewControllerDelegate,ScannerViewDelegate>{
    UITextField *topTF;
    UITextField *bottomTF;
    NSMutableDictionary *userDataDictionary;
    NSInteger type;
    BOOL simpleReg;
    NSMutableDictionary *ticketList;

}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property (nonatomic, strong) ScannerView *codeScannerView;

@property (weak, nonatomic) UIViewController *currentViewController;

@end

@implementation InviteToBuyMainViewController
- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setPayPalEnvironment:self.environment];
    [CardIOUtilities preload];
    
    
    

}

-(void)generateData{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"appDataOnce"]) {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"event_data.json"];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        NSDictionary *jsonObject= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
            
            
            return;
        }
        NSArray *events =[[jsonObject objectForKey:@"data"]objectForKey:@"events"];
        for (NSDictionary *evnt  in events) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[evnt objectForKey:@"idEvent"] forKey:@"event_id"];
            [[NSUserDefaults standardUserDefaults]setObject:[evnt objectForKey:@"maxTicketEvent"] forKey:@"maxTicketEvent"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        }
        
        /* NSArray *discount =[[jsonObject objectForKey:@"data"]objectForKey:@"discounts"];
         for (NSDictionary *disc  in discount) {
         if ([[disc objectForKey:@"discountName"] isEqualToString:@"app"]) {
         [[NSUserDefaults standardUserDefaults]setObject:disc[@"discountPercent"] forKey:@"event_discount"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         break;
         }
         }*/
        ticketList = [[jsonObject objectForKey:@"data"] objectForKey:@"ticket_type"];
        
        for (NSDictionary*tkct in ticketList) {
            [[NSUserDefaults standardUserDefaults]setObject:tkct[@"ticketCurrency"] forKey:@"ticketCurrency"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        }
        
    }
}
- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(skipProcess:)];
    swipe.direction=UISwipeGestureRecognizerDirectionUp;
    swipe.enabled=YES;
    [self.mainContainer addGestureRecognizer:swipe];
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;

    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.merchantName = @"Hostaria";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"http://gestione.hostariaverona.com/privacypolicy"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"http://gestione.hostariaverona.com/privacypolicy"];
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIStoryboard *iphonestor=[UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    InviteToBuyViewController *newViewController = [iphonestor instantiateViewControllerWithIdentifier:@"INVITE_TO_BUY_CONTROLLER_ID"];
    // SponsorOneViewController*newViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"SPONSOR_ONE_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}
- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.mainContainer];
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                         
                         if ([newViewController isKindOfClass:[InviteToBuyViewController class]]) {
                             NSLog(@"SPARTAAAAAAA : InviteToBuyViewController");
                             InviteToBuyViewController *tmn=(InviteToBuyViewController*)newViewController;
                             [tmn.loginButton addTarget:self action:@selector(goToWelcome:) forControlEvents:UIControlEventTouchUpInside];
                             [tmn.skipButton addTarget:self action:@selector(skipProcess:) forControlEvents:UIControlEventTouchUpInside];
                             [tmn.ticketBuyButton addTarget:self action:@selector(goToTicketList:) forControlEvents:UIControlEventTouchUpInside];
                             if ([[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]) {
                                 userDataDictionary = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];
                                 [tmn.loginButton setFrame:CGRectZero];
                             }else{
                                 userDataDictionary = [[NSMutableDictionary alloc]init];
                                 [tmn.loginButton setHidden:NO];

                             }
                         }
                         [userDataDictionary removeObjectForKey:@"participation_date"];

                         NSLog(@"current logged user: %@",userDataDictionary);
                     }];
}

-(void)welcomeGoToLogin{
    [self goToLogin:nil];
}
-(void)welcomeGoToRegister{
    NSLog(@"welcome to reg");
    
    simpleReg=YES;
    [self goToMissingDataOrBuy];
}


-(void)simpleRegisterCallUserData:(id)userInfo{
    NSLog(@"register and buy");
    [userDataDictionary addEntriesFromDictionary:(NSDictionary*)userInfo];
    API.delegate=self;
    simpleReg=YES;
    [API registerUser:userDataDictionary onView:self.view];
}
-(void)welcomeGoToSkip{
    [self skipProcess:nil];
}
-(void)goToWelcome:(id)sender{
    WelcomeViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WELCOME_CONTROLLER_ID"];
    newViewController.delegate=self;
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}

-(void)goToLogin:(id)sender{
    InputUserOneViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"INPUT_USER_ONE_CONTROLLER_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}
-(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"UTC"];
    [calendar setTimeZone:tz];
    return [calendar dateFromComponents:components];
}

-(void)goToTicketList:(id)sender{
    NSLog(@"aasdsadas: %@ === %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"endHour"],[[NSUserDefaults standardUserDefaults]objectForKey:@"endTime"]);
    
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
     NSCalendar *calendar = [NSCalendar currentCalendar];
    NSLog(@"1");

    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];

    NSDate *dateTimestamp = [dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"endHour"]];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dateTimestamp];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSLog(@"2");

    NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    NSCalendar *calendar2 = [NSCalendar currentCalendar];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];

    NSDate *dateTime = [dateFormatter2 dateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"endTime"]];
    NSDateComponents *components2 = [calendar2 components:(NSCalendarUnitYear  |NSCalendarUnitDay| NSCalendarUnitMonth) fromDate:dateTime];
    NSLog(@"3");

    NSInteger year = [components2 year];
    NSInteger month = [components2 month];
    NSInteger day = [components2 day];


    NSDate *oldDate = [self dateWithYear:2020 month:month day:day hour:hour minute:minute];
    
    
  
    

    NSDate* currentDate = [NSDate date];
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    
    NSLog(@"new date:%@ old date: %@",nowDate,oldDate);

    if ([nowDate compare:oldDate] == NSOrderedDescending) {
        //"date1 is later than date2
        NSLog(@"date1 is later than date2");
        
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Attenzione"
                                                                            message: @"L'evento e finito, acquisto non disponibile. Grazie."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction *action) {
                                                                       NSLog(@"ok button tapped!");
                                                                       
                                                                       
                                                                       
                                                                   }];
        
        [controller addAction: alertActionConfirm];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        
        return;
        
    } else if ([nowDate compare:oldDate] == NSOrderedAscending) {
        //date1 is earlier than date2
        NSLog(@"date1 is earlier than date2");

    } else {
        //dates are the same
        NSLog(@"dates are the same");

    }
    
    
    
    [self generateData];

    
    
    
   
    
    
    
    
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"appDataOnce"] || ticketList.count==0) {
        
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile trovare i dati necessari."
                                                                            message: @"Si prega di verificare la connessione internet e sincronizzare."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Sincronizza"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                
                                                                
                                                                [API getAppData];
                                                                
                                                            }];
        
        [controller addAction: alertAction];
        
        
        UIAlertAction *impAction = [UIAlertAction actionWithTitle: @"Impostazzioni"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                
                                                                
                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
                                                                /*prefs:root=General&path=About
                                                                 prefs:root=General&path=ACCESSIBILITY
                                                                 prefs:root=AIRPLANE_MODE
                                                                 prefs:root=General&path=AUTOLOCK
                                                                 prefs:root=General&path=USAGE/CELLULAR_USAGE
                                                                 prefs:root=Brightness
                                                                 prefs:root=Bluetooth
                                                                 prefs:root=General&path=DATE_AND_TIME
                                                                 prefs:root=FACETIME
                                                                 prefs:root=General
                                                                 prefs:root=General&path=Keyboard
                                                                 prefs:root=CASTLE
                                                                 prefs:root=CASTLE&path=STORAGE_AND_BACKUP
                                                                 prefs:root=General&path=INTERNATIONAL
                                                                 prefs:root=LOCATION_SERVICES
                                                                 prefs:root=ACCOUNT_SETTINGS
                                                                 prefs:root=MUSIC
                                                                 prefs:root=MUSIC&path=EQ
                                                                 prefs:root=MUSIC&path=VolumeLimit
                                                                 prefs:root=General&path=Network
                                                                 prefs:root=NIKE_PLUS_IPOD
                                                                 prefs:root=NOTES
                                                                 prefs:root=NOTIFICATIONS_ID
                                                                 prefs:root=Phone
                                                                 prefs:root=Photos
                                                                 prefs:root=General&path=ManagedConfigurationList
                                                                 prefs:root=General&path=Reset
                                                                 prefs:root=Sounds&path=Ringtone
                                                                 prefs:root=Safari
                                                                 prefs:root=General&path=Assistant
                                                                 prefs:root=Sounds
                                                                 prefs:root=General&path=SOFTWARE_UPDATE_LINK
                                                                 prefs:root=STORE
                                                                 prefs:root=TWITTER
                                                                 prefs:root=FACEBOOK
                                                                 prefs:root=General&path=USAGE prefs:root=VIDEO
                                                                 prefs:root=General&path=Network/VPN
                                                                 prefs:root=Wallpaper
                                                                 prefs:root=WIFI
                                                                 prefs:root=INTERNET_TETHERING*/
                                                                
                                                            }];
        
        [controller addAction: impAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
        return;
    }
    
    
    
        UINavigationController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NAV_CHOOSE_TICKET_CONTROLLER_ID"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self slideFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    
    
    
    
    
  
}

-(void)dismisProcess{
    [self skipProcess:nil];
}

-(void)skipProcess:(id)sender{
    
   // dispatch_async(dispatch_get_main_queue(), ^{
        //code
      //  [self willMoveToParentViewController:nil];
        [self beginAppearanceTransition:YES animated:YES];
        [UIView
         animateWithDuration:0.6
         delay:0.0
         options:UIViewAnimationOptionCurveEaseOut
         animations:^(void){
             self.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
             
             //self.view.alpha = 0.0;
         }
         completion:^(BOOL finished) {
             [self endAppearanceTransition];
             [self willMoveToParentViewController:nil];
             [self.view removeFromSuperview];
             [self removeFromParentViewController];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTable" object:nil];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTicket" object:nil];
             simpleReg = NO;
         }
         ];
   // });
    
 

}



- (CGAffineTransform)startingTransformForViewControllerTransition:(ViewControllerTransition)transition
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (transition)
    {
        case ViewControllerTransitionSlideFromTop:
            transform = CGAffineTransformMakeTranslation(0, -height);
            break;
        case ViewControllerTransitionSlideFromLeft:
            transform = CGAffineTransformMakeTranslation(-width, 0);
            break;
        case ViewControllerTransitionSlideFromRight:
            transform = CGAffineTransformMakeTranslation(width, 0);
            break;
        case ViewControllerTransitionSlideFromBottom:
            transform = CGAffineTransformMakeTranslation(0, height);
            break;
        case ViewControllerTransitionRotateFromRight:
            transform = CGAffineTransformMakeTranslation(width, 0);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        default:
            break;
    }
    
    return transform;
}


- (void)slideFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.mainContainer];
    [newViewController.view layoutIfNeeded];

    newViewController.view.transform = [self startingTransformForViewControllerTransition:3];
    
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.7 options:0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-newViewController.view.transform.tx * 1, -newViewController.view.transform.ty * 1);
        transform = CGAffineTransformRotate(transform, acosf(newViewController.view.transform.a));
        oldViewController.view.transform = CGAffineTransformScale(transform, 1, 1);
        
        newViewController.view.transform = CGAffineTransformIdentity;
        
      
    } completion:^(BOOL finished) {
        [oldViewController.view removeFromSuperview];
        [oldViewController removeFromParentViewController];
        [newViewController didMoveToParentViewController:self];
        
        if ([newViewController isKindOfClass:[InputUserOneViewController class]]) {
            NSLog(@"SPARTAAAAAAA : InputUserOneViewController");
            InputUserOneViewController *tmn=(InputUserOneViewController*)newViewController;
            [tmn.skipButton addTarget:self action:@selector(skipProcess:) forControlEvents:UIControlEventTouchUpInside];
            tmn.delegate=self;
            
        }
        if ([newViewController isKindOfClass:[UINavigationController class]]) {
            NSLog(@"SPARTAAAAAAA : NAVHERE");
            UINavigationController*mynav = (UINavigationController*)newViewController;
            UIViewController * tmn=(UIViewController*)[mynav.viewControllers objectAtIndex:0];
           
            if ([tmn isKindOfClass:[ChooseTicketViewController class]]) {
                NSLog(@"SPARTAAAAAAA : ChooseTicketViewController");
                
                ChooseTicketViewController *chs=(ChooseTicketViewController*)tmn;
                chs.delegate=self;
                [chs.ticket addTarget:self action:@selector(skipProcess:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            if ([tmn isKindOfClass:[AlmostThereViewController class]]) {
                NSLog(@"SPARTAAAAAAA : AlmostThereViewController");
                AlmostThereViewController *amt=(AlmostThereViewController*)tmn;
                amt.delegate=self;
                [amt setDataToWorkWith:userDataDictionary];
             
                
            }
            if ([tmn isKindOfClass:[MissingDataOrBuyController class]]) {
                NSLog(@"SPARTAAAAAAA : MissingDataOrBuyController");
                MissingDataOrBuyController *amt=(MissingDataOrBuyController*)tmn;
                amt.delegate=self;
                [amt setWelcome:simpleReg];
                [amt setDataToWorkWith:userDataDictionary];
                [amt.ticket addTarget:self action:@selector(skipProcess:) forControlEvents:UIControlEventTouchUpInside];

                
            }
            
        }
      

    }];
    
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
-(void)goToFromMissingNextWithUserData:(id)userInfo{
    NSLog(@"register and buy");
    [userDataDictionary addEntriesFromDictionary:(NSDictionary*)userInfo];
    API.delegate=self;
    [API registerUser:userDataDictionary onView:self.view];
}

-(void)loggedInWithUserInfo:(id)userInfo{
    if (userDataDictionary == NULL) {
        userDataDictionary = [[NSMutableDictionary alloc]init];
    }
    [userDataDictionary addEntriesFromDictionary:(NSDictionary*)userInfo];
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:userDataDictionary forKey:@"current_user_data"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"logged"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    NSLog(@"mainBuy: %@",userDataDictionary);
    [self skipProcess:nil];
}

-(void)registerUser:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"show explicit error :%@",error.localizedDescription);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare la registrazione"
                                                                        message: @"Si prega di riprovare più tardi, il sistema è in manutenzione"
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"ok button tapped!");
                                                            
                                                        }];
    
    [controller addAction: alertAction];
    
    [self presentViewController: controller animated: YES completion: nil];
    return;
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
    
    [API pasteLemonWayDataToServer:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",info.cardNumber],@"card_number",[NSString stringWithFormat:@"%02lu",info.expiryMonth],@"card_expiry_month",[NSString stringWithFormat:@"%02lu",info.expiryYear],@"card_expiry_year",[NSString stringWithFormat:@"%@",info.cvv],@"card_cvv",[NSString stringWithFormat:@"%@",info.cardholderName],@"card_holder_name",[CardIOCreditCardInfo displayStringForCardType:info.cardType usingLanguageOrLocale:@"IT"],@"card_type", nil] withData:userDataDictionary onView:self.view];
  

    
    
}

-(void)registerUser:(APIManager *)manager didFinishLoading:(id)item{
    
    

    NSDictionary * data=(NSDictionary*)item;
    if ([data objectForKey:@"id_user"]!=NULL && [[item objectForKey:@"status"]isEqualToString:@"success"]) {
        [userDataDictionary setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"event_id"] forKey:@"id_event"];
        [userDataDictionary setObject:[data objectForKey:@"id_user"] forKey:@"id_user"];
        
        
        
        
        if (simpleReg) {
            
            
            
            
            UIAlertController *alertController1 = [UIAlertController
                                                   alertControllerWithTitle:@"Congratulazioni!"
                                                   message:@"Registrazione avvenuta con successo"
                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Ok"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                               if (userDataDictionary == NULL) {
                                                   userDataDictionary = [[NSMutableDictionary alloc]init];
                                               }
                                               [[NSUserDefaults standardUserDefaults]setObject:userDataDictionary forKey:@"current_user_data"];
                                               [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"logged"];
                                               [[NSUserDefaults standardUserDefaults]synchronize];
                                               
                                               NSLog(@"mainBuy: %@",userDataDictionary);
                                               [self skipProcess:nil];
                                               
                                               
                                           }];
         
            [alertController1 addAction:cancelAction];
            
            
            
         
                [self presentViewController:alertController1 animated:YES completion:nil];
                
            
            
            
            
        }else{
        
        
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            // Cancel button tappped do nothing.
            
            [self dismissViewControllerAnimated:actionSheet completion:nil];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"via PayPal" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // take photo button tapped.
            [self bUYWithData:userDataDictionary];

            
        }]];
        
       [actionSheet addAction:[UIAlertAction actionWithTitle:@"via Credit/Debit Card" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // choose photo button tapped.
        
            
            
            [self bUYLemonWithData:userDataDictionary];
            
        }]]; ///*******************************************THIS IS DISABLED************************************************
        

        
        [self presentViewController:actionSheet animated:YES completion:nil];
        
        
        }
        
        
        //TODO check all here
        
        
    }else if([[item objectForKey:@"status"]isEqualToString:@"warning"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: [item objectForKey:@"error"]
                                                                            message: [item objectForKey:@"description"]
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare la registrazione"
                                                                            message: @"Si prega di riprovare più tardi, il sistema è in manutenzione"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }
    
    
    //BUY
    
    
    
}



-(void)startScanning{
    NSLog(@"start scanning");
    if (self.codeScannerView ==nil) {
        
        
        self.codeScannerView = [[ScannerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        self.codeScannerView.center=self.view.center;
        self.codeScannerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.codeScannerView.delegate = self;
        [self.view addSubview:[self codeScannerView]];
        [self.view bringSubviewToFront:self.view];
        [self.codeScannerView start];
        
        
    }else{
        [self.codeScannerView start];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissReader:)];
    tap.numberOfTapsRequired=2;
    [self.codeScannerView addGestureRecognizer:tap];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        NSLog(@"authorized");
        
        
        
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        NSLog(@"denied");
     
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Camera device not allowed" message:@"This app needs you to authorize camera device to work." preferredStyle:UIAlertControllerStyleAlert];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:actionSheet completion:nil];

            // Cancel button tappped do nothing.
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

            
        }]];
        
      
        
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
        NSLog(@"restricted");
        
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        NSLog(@"not determined");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access");
                
            } else {
                NSLog(@"Not granted access");
            }
        }];
    }
    
    
    
}

-(void)dismissReader:(id)sender{
    [self.codeScannerView stop];
    [self.codeScannerView removeFromSuperview];
    self.codeScannerView=nil;

}

-(void)scannerView:(ScannerView *)scannerView didReadCode:(NSString *)code atTime:(NSString *)time{
    NSLog(@"read this code: %@",code);
    [scannerView start];
}

-(void)nextSceneWithSummaryData:(NSMutableArray *)sumData andToken:(NSString *)tokect andDTime:(NSString *)time{
    [userDataDictionary setObject:sumData forKey:@"tickets"];
    [userDataDictionary setObject:time forKey:@"participation_date"];

    BOOL email=NO,name=NO,surname=NO,password=NO;
    if ([self dictionary:userDataDictionary hasKey:@"email"]) {
        email=YES;
    }
    if ([self dictionary:userDataDictionary hasKey:@"name"]) {
        name=YES;
    }
    if ([self dictionary:userDataDictionary hasKey:@"surname"]) {
        surname=YES;
    }
    if ([self dictionary:userDataDictionary hasKey:@"password"]) {
        password=YES;
    }
    
    if (email || name || surname || password) {
        NSLog(@"start buy here");
       // [userDataDictionary setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"event_id"] forKey:@"id_event"];

        //[self bUYWithData:userDataDictionary];
        API.delegate=self;
        [API registerUser:userDataDictionary onView:self.view];
        
        
        
    }else{
        [self goToMissingDataOrBuy];
    }
  
    
   

    
}

-(void)goToMissingDataOrBuy{
    UINavigationController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NAV_MISSINGDATA_CONTROLLER_ID"];
    
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}

-(void)goToNextWithUserData:(id)userInfo{
    NSLog(@"almost check user data exists and make new controller");
}
-(void)goToAlmostThere{
    
    UINavigationController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NAV_ALMOST_THERE_CONTROLLER_ID"];

    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}


-(void)bUYLemonWithData:(id)item{
    NSDictionary * userInfo = (NSDictionary*)item;
    
    NSLog(@"buy with data stop for now and show sponsor: %@",userInfo);
    
    
    
    NSArray *tickets = userInfo[@"tickets"];
    float total = 0.0f;
    for (NSDictionary *tkct in tickets) {
        total += [tkct[@"partialAmount"]floatValue];
  
        
    }
    NSLog(@"totallemon: %.02f",total);
    
    
    
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.02f",total] forKey:@"price_to_pay"];
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.collectCVV=YES;
    scanViewController.useCardIOLogo=NO;
    scanViewController.collectCardholderName=YES;
    scanViewController.hideCardIOLogo=YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

-(void)bUYWithData:(id)item{
    
    NSLog(@"buy with data: %@",item);
    /*UINavigationController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NAV_SPONSOR_ONE_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;*/
    
    NSDictionary * userInfo = (NSDictionary*)item;
    
    NSLog(@"buy with data stop for now and show sponsor: %@",userInfo);
    
 
    
    NSArray *tickets = userInfo[@"tickets"];
    NSMutableArray *items =[NSMutableArray new];
    float total = 0.0f;
    for (NSDictionary *tkct in tickets) {
        total += [tkct[@"partialAmount"]floatValue];
        //S
        
        PayPalItem *item3 = [PayPalItem itemWithName:tkct[@"ticketName"]
                                        withQuantity:[tkct[@"ticketPaid"]integerValue]
                                           withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",tkct[@"fullPrice"]]]
                                        withCurrency:@"EUR"
                                             withSku:[NSString stringWithFormat:@"SKU_00112334%@",tkct[@"id"]]];
        [items addObject:item3];
        
    }
    NSLog(@"total: %.02f",total);
    NSLog(@"paypal items %@",items);
    
    
    
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.02f",total] forKey:@"price_to_pay"];
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *totalpaypal = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    NSLog(@"paypal items total %@",totalpaypal);

    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = totalpaypal;
    payment.currencyCode = @"EUR";
    payment.shortDescription = @"Biglietti - Hostaria";
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
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
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
    //done here
}
-(void)userDidCancelPayment{
    NSLog(@"dismiss payment by user");
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_currentViewController isKindOfClass:[ChooseTicketViewController class]]) {
        ChooseTicketViewController *cds=(ChooseTicketViewController*)_currentViewController;
        [cds clearDataToBuy];
        NSLog(@"clear all data to buy");
    }
    
}
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success! :%@",[completedPayment description]);
    
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
  
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_currentViewController isKindOfClass:[ChooseTicketViewController class]]) {
        ChooseTicketViewController *cds=(ChooseTicketViewController*)_currentViewController;
        [cds clearDataToBuy];
        NSLog(@"clear all data to buy");
    }
}
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    [API pasteNonceToServer:completedPayment.confirmation withData:userDataDictionary onView:self.view];

}



/*- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    // NSLog(@"nonce to server: %@",paymentMethodNonce.nonce);
    [self dismissViewControllerAnimated:YES completion:^{
        
        [API pasteNonceToServer:paymentMethodNonce.nonce withData:userDataDictionary onView:self.view];
    }];
}*/
-(void)pasteNonceToServer:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"pasteNonceToServer %@",error.localizedDescription);
    NSLog(@"pasteNonceToServercode %ld",error.code);

    if(error.code==-1011){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"L’acquisto non è andato a buon fine"
                                                                            message: @"Si prega di riprovare più tardi, il sistema è in manutenzione."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction *action) {
                                                                       NSLog(@"ok button tapped!");
                                                                       
                                                                       //  [self skipProcess:nil];
                                                                       
                                                                   }];
        
        [controller addAction: alertActionConfirm];
        
       // domanda qui
        
        
        [self presentViewController: controller animated: YES completion: nil];
        return;

    }
    
}
-(void)pasteNonceToServer:(APIManager *)manager didFinishLoading:(id)item{
    NSLog(@"pasteNonceToServer %@",(NSDictionary*)item);
    if ([[item objectForKey:@"status"]isEqualToString:@"success"]) {
        
        
        NSLog(@"current user data: %@",userDataDictionary);
        [userDataDictionary removeObjectForKey:@"participation_date"];
        [[NSUserDefaults standardUserDefaults]setObject:userDataDictionary forKey:@"current_user_data"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"logged"];

        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSMutableArray *oldTickets =[userDataDictionary objectForKey:@"tickets"];
        
        NSMutableArray *newTicket = [[item objectForKey:@"data"]objectForKey:@"ticket"];
        
        
        
        
       // NSLog(@"newTicket%@",newTicket );
        __block NSMutableArray *newData = [NSMutableArray new];
        [oldTickets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            __block NSDictionary *object = (NSDictionary *)obj;
            
            __block BOOL isExisting = NO;
            [[newTicket objectAtIndex:0] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *innerObject = (NSDictionary *)obj;
                
                if ([[NSString stringWithFormat:@"%@",[object objectForKey:@"id"]]isEqualToString:[NSString stringWithFormat:@"%@",[innerObject objectForKey:@"ticketType"]]]) {
                    isExisting = YES;
                    // NSLog(@"existing: %@ need to add",innerObject);
                    NSMutableDictionary * newObj=[[NSMutableDictionary alloc]initWithDictionary:object];
                    [newObj addEntriesFromDictionary:innerObject];
                    [newObj setObject:@"0" forKey:@"favorite"];
                   // [newObj setObject:[userDataDictionary objectForKey:@"id_user"] forKey:@"idUser"];
                    [newData addObject:newObj];
                }
                
                
                //if([object objectForKey:@"id"] == [innerObject objectForKey:@"ticketType"])
                
            }];
            //if(!isExisting)
                //[newData addObject:object];
        }];
        
        
        
        NSLog(@"show me new data: %@",newData);
        
        [userDataDictionary removeObjectForKey:@"tickets"];
        
        NSMutableDictionary *userData= [[NSMutableDictionary alloc]initWithDictionary:userDataDictionary];
        NSMutableDictionary *myTickets=[[NSMutableDictionary alloc]init];
        
        if ([self dictionary:userData hasKey:@"myTickets"]) {
            
            [newData addObjectsFromArray:[userData objectForKey:@"myTickets"]];
        
        }
        
        [myTickets setObject:newData forKey:@"myTickets"];
        [myTickets setObject:[userData objectForKey:@"email"] forKey:@"owner_email"];
        
        [userData addEntriesFromDictionary:myTickets ];
        
        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"current_user_data"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"this is your current data that you bougth: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]);
        
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"L’acquisto è andato a buon fine"
                                                                            message: @"Il suo biglietto è disponibile nella sezione Profilo."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction *action) {
                                                                       NSLog(@"ok button tapped!");
                                                                       
                                                                         [self skipProcess:nil];
                                                                       
                                                                   }];
        
        [controller addAction: alertActionConfirm];
        
        
        
        
        [self presentViewController: controller animated: YES completion: nil];
        return;


      
    }else{
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"L’acquisto non è andato a buon fine"
                                                                            message: @"Si prega di riprovare più tardi, il sistema è in manutenzione."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction *action) {
                                                                       NSLog(@"ok button tapped!");
                                                                       
                                                                     //  [self skipProcess:nil];
                                                                       
                                                                   }];
        
        [controller addAction: alertActionConfirm];
        
        
        
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }
    
}

/*- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
  
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
