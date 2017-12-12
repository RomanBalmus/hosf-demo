//
//  AppDelegate.m
//  Hostaria
//
//  Created by iOS on 13/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "TheFeedback.h"
#import "Service.h"
#import "StandNoMapDetailNavigationBarViewController.h"




@interface AppDelegate ()/*<PKPushRegistryDelegate>*/{
}


@end

@implementation AppDelegate
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
-(void)huddie
{
    // centralised location for MBProgressHUD
    [self.hud hide:YES];
    
    UIWindow *windowForHud = [[UIApplication sharedApplication] delegate].window;
    self.hud = [MBProgressHUD showHUDAddedTo:windowForHud animated:YES];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.customView = [self animatedCustomImage];
    self.hud.customView.backgroundColor=[UIColor clearColor];
    self.hud.square=YES;
    self.hud.color = [UIColor clearColor];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"white-red-white"]forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance]setTranslucent:NO];
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor lightGrayColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [self getUIColorObjectFromHexString:@"#BD172C" alpha:1] }// AD0020
                                             forState:UIControlStateSelected];
    

    
    
    // set the schema verion and migration block for the defualt realm
    
    [RLMRealmConfiguration setDefaultConfiguration:[RLMRealmConfiguration defaultConfiguration]];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    
    [WAMP openWamp];
    
    
    //[navigation setNavigationBarHidden:YES];
    
   // [self voipRegistration];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //[[Twitter sharedInstance] startWithConsumerKey:@"L0qUlFKgoSslVW77puoVbsWXL" consumerSecret:@"mebbUTpjAGpc369ppY1a9dHTSKzHtnJt7PCtkOcHtQoBpdift5"];
   // [Fabric with:@[[Twitter class]]];
   // [BTAppSwitch setReturnURLScheme:@"com.romanbalmus.tulain.hostaria.payments"];
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AZFCgZQKOuIasM8dq1bvapD9Feq1tLr3bHdrjaQUttQozfiPsx6jJ0SMDV4SZtf_79Y8owNx7dgO3cbo",
                                                           PayPalEnvironmentSandbox : @"AYLWgnScIKsASFCm-q3M8vZlY8E2ygccHpFEkFiNLDtI4A9AglYx42tte2bFVyCOawS_AlKiykp49Oxg"}];
   
    
    
    
    
 //   [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [self getUIColorObjectFromHexString:@"#AD0020" alpha:1] } forState:UIControlStateNormal];
    [IQKeyboardManager sharedManager].enable=YES;
    [IQKeyboardManager sharedManager].shouldAdoptDefaultKeyboardAnimation=YES;
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"14071989com.roman.hostaria" accessGroup:nil];
    if ([keychainItem objectForKey:(__bridge id)kSecAttrAccount] != NULL && [keychainItem objectForKey:(__bridge id)kSecValueData]!=NULL) {
        NSString *password = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
        NSString *username = [keychainItem objectForKey:(__bridge id)kSecValueData];
        NSLog(@"keychain: %@ psw: %@",username,password);
    }
        [keychainItem setObject:@"password hjyou are saving" forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:@"username ydddou are saving" forKey:(__bridge id)kSecValueData];
    
   // if (![[NSUserDefaults standardUserDefaults]boolForKey:@"appDataOnce"]) {
        [API getAppData];

  //  }
   // [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:17];
    [comps setMonth:10];
    [comps setYear:2027];
    [comps setHour:23];
    [comps setMinute:59];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    [[NSUserDefaults standardUserDefaults]setBool:[self isEndDateIsSmallerThanCurrent:date] forKey:@"stopBuyWine"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"buy wine: %d",[[NSUserDefaults standardUserDefaults]boolForKey:@"stopBuyWine"]);
    
    id notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notification isKindOfClass:[NSNotification class]]) {
        
        
        NSLog(@"app recieved notification from local%@",notification);
        [self application:application didReceiveLocalNotification:(UILocalNotification*)notification];
    }else{
        NSLog(@"app did not recieve notification");
    }
    return YES;
}
- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}
-(NSString *)getDocPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
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


-(void)scheduledEventNotificationWithTime:(NSDate*)time andEvent:(Service*)evnt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"dd/MM HH:mm"];
    NSString *stringDate = [dateFormatter stringFromDate:evnt.starttime];
    


    UILocalNotification* n1 = [[UILocalNotification alloc] init];
    n1.fireDate = time;
    n1.userInfo=[[NSDictionary alloc]initWithObjectsAndKeys:evnt._id,@"id", nil];
    NSString*data=[stringDate substringToIndex:5];
    NSString*ora=[stringDate substringFromIndex: [stringDate length] - 5];
    n1.alertBody =[NSString stringWithFormat:@"%@ - In %@ alle %@ sta per iniziare %@ ",data,evnt.address,ora,evnt.serviceNameDefinition];
    [[UIApplication sharedApplication] scheduleLocalNotification: n1];
    
}

-(NSString*)formattedDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MMM/dd HH:mm"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}


-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    //NSLog(@"registered %d",[application isRegisteredForRemoteNotifications]);
        NSLog(@"Something changed in notifications check it");

      /*  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network unreachable" message:@"the network is not detected!" preferredStyle:UIAlertControllerStyleAlert]; // 7
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Determine" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }]; // 8
        
        [alert addAction:defaultAction]; // 9
        
        / [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = @"Input data...";
         }];*/ // 10
        
        //[[[[UIApplication sharedApplication ]keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil]; // 11
    
    
    
    
    RLMResults<Service*>*revnts = [Service objectsWhere:[NSString stringWithFormat:@"serviceLocalType = '%@' or serviceLocalType = '%@' or serviceLocalType = '%@' and fired = '0'",TYPE_EVENT_AREA,TYPE_MONTE_VERONESE,TYPE_GEN_SPONSOR]];

    NSLog(@"got revents:%@",[revnts debugDescription]);
    
    RLMResults<Service*>*evnts = [revnts objectsWhere:@"starttime > %@",[NSDate date]];

    
   // RLMResults<Event*>*evnts=[Event objectsWhere:@"fired = '0'"];
    for (Service *vnt  in evnts) {
        
        
        
        
        
        
        NSDate *newDate = [vnt.starttime dateByAddingTimeInterval:-60*10]; // 10 minuti
        
        [self scheduledEventNotificationWithTime:newDate andEvent:vnt];
    }
    
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    Service*evnt=[[Service objectsWhere:[NSString stringWithFormat:@"_id = '%@'",[notification.userInfo objectForKey:@"id"]]]firstObject];
    
    NSLog(@"received notification:%@",notification.alertBody);
    NSLog(@"received notification:%@",[notification.userInfo objectForKey:@"id"]);
   
  
    
    
    
    NSLog(@"the event:%@",[evnt debugDescription]);
    
    
    RLMRealm *rlm = [RLMRealm defaultRealm];
    [rlm beginWriteTransaction];
  //  evnt.fired=@"1";
    [rlm commitWriteTransaction];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   

    [dateFormatter setDateFormat:@"dd/MM HH:mm"];
    NSString *stringDate = [dateFormatter stringFromDate:evnt.starttime];

    
    NSString*data=[stringDate substringToIndex:5];
    NSString*ora=[stringDate substringFromIndex: [stringDate length] - 5];
    
    UIAlertController *alertController1 = [UIAlertController
                                           alertControllerWithTitle:@"Non perdere nessun evento!"
                                           message:[NSString stringWithFormat:@"%@ - In %@ alle %@ sta per iniziare %@ ",data,evnt.address,ora,evnt.serviceNameDefinition]
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Annulla"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Vai"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                            

                                     StandNoMapDetailNavigationBarViewController*  eventController = [[StandNoMapDetailNavigationBarViewController alloc] initWithNibName:@"StandNoMapDetailNavigationBarViewController" bundle:nil];;
                                       UINavigationController * navevnt = [[UINavigationController alloc]initWithRootViewController:eventController];
                                       eventController.data = evnt; // hand off the current product to the detail view controller
                                       
                                       [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navevnt animated:YES completion:nil];
                               
                                   
                                  

                               }];
    [alertController1 addAction:cancelAction];
    
    [alertController1 addAction:okAction];
    
   

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"visibleNav"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showAlertWithinController" object:nil userInfo:[[NSDictionary alloc]initWithDictionary:notification.userInfo]];
    }else{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController1 animated:YES completion:nil];
 
    }
    
    /* [application cancelLocalNotification:notification];
     if (application.applicationState==UIApplicationStateActive && application.applicationState!=UIApplicationStateBackground) {
     // return;
     }
     if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
     {
     //opened from a push notification when the app was on background
     
     
     return;
     }
     
     */
    
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    //NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        NSLog(@"Not reachable");
     /*   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network unreachable" message:@"the network is not detected!" preferredStyle:UIAlertControllerStyleAlert]; // 7
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Determine" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }]; // 8
        
        [alert addAction:defaultAction];*/ // 9
        
        /* [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = @"Input data...";
         }];*/ // 10
        
       // [[[[UIApplication sharedApplication ]keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil]; // 11
        
    }
    
    
    
    
    
    
}
- (void)writeJsonToFile:(NSDictionary*)json
{
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:kNilOptions
                                                         error:&error];
    //attempt to download live data
    if (error==nil)
    {
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"event_data.json"];
        [jsonData writeToFile:filePath atomically:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"appDataOnce"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"updateAllData"];

        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        NSLog(@"write error: %@",error.localizedDescription);
    }
    
}
- (void)application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    
   __block BOOL appdata,feeddata = false;
    static NSString * const kAuthName = @"utente1";
    static NSString * const kAuthPassword = @"utente1repo";
    static NSString * const kRequestSerializer = @"application/x-www-form-urlencoded";
    NSLog(@"getAppData");
     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost=33;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
   // manager.securityPolicy.allowInvalidCertificates = YES;

    
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    NSLog(@"getAppData %@",dataToPost);
    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIAppDataUrl parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
   // NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
   // NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    //NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    //[apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error getappdata: %@", error);
            appdata=NO;

            
        } else {
            NSLog(@"%@ \nobj: %@", response, responseObject);
            
            [self writeJsonToFile:(NSDictionary*)responseObject];
            appdata=YES;
         

        }
    }];
    
    [dataTask resume];
    
    
    
    
    

    RLMResults<TheFeedback*> *tfeedback=[TheFeedback objectsWhere:@"uploaded = 0 and saved = 1"];
  
    if (tfeedback.count==0) {
        NSLog(@"no feedback to upload");
        
        feeddata=NO;

    }else{
    
    
    NSLog(@"feedback to upload :%@",[tfeedback debugDescription]);

    
    for (TheFeedback *fbck in tfeedback) {
        
        
        NSMutableDictionary * fdataToPost = [[NSMutableDictionary alloc]init];
        [fdataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
        [fdataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
        
        [fdataToPost setValue:[NSNumber numberWithInteger:fbck.id_scan_history] forKey:@"id_scan_history"];
        NSLog(@"feeddata %@",fdataToPost);


        for (MyKV *kv in fbck.kvs) {
            [fdataToPost setObject:kv.valuename forKey:kv.valuenumber];
            [fdataToPost setObject:kv.keyname forKey:kv.keynumber];
            
         
        }
        
        
        
        NSMutableURLRequest *fapiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APISendFeedbackDataURL parameters:fdataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        } error:nil];
        
        //[apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        
        NSURLSessionDataTask *fdataTask = [manager dataTaskWithRequest:fapiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            if (error) {
                NSLog(@"Error feedback: %@", error);
                
                feeddata=NO;
            } else {
                NSLog(@"%@ \nobj: %@", response, responseObject);
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                
                [realm beginWriteTransaction];
                fbck.uploaded=1;
                [realm commitWriteTransaction];
                
                
                feeddata=YES;
                
            }
        }];
        
        [fdataTask resume];
    }
    
    }
    
    
    
    if (feeddata || appdata) {
        
        completionHandler(UIBackgroundFetchResultNewData);
    }else{
        completionHandler(UIBackgroundFetchResultNoData);

    }
 
    
    
   /* //SEND FEEDBACK TO SERVER
    
     NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
     
     NSURL *url = [[NSURL alloc] initWithString:APISendFeedbackDataURL];
     NSURLSessionDataTask *task = [session dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     
     if (error) {
     completionHandler(UIBackgroundFetchResultFailed);
     return;
     }
     
     // Parse response/data and determine whether new content was available
         BOOL hasNewData =;
     if (hasNewData) {
     completionHandler(UIBackgroundFetchResultNewData);
     } else {
     completionHandler(UIBackgroundFetchResultNoData);
     }
     }];
     
     // Start the tas
     [task resume];*/
    

}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"asked"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"asked"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (NSString *)hexadecimalString:(NSData*)data
{
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
    }
    
    return hexString;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [WAMP closeWamp];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"enter foreground");
    [WAMP startReconnect];
    [WAMP openWamp];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:17];
    [comps setMonth:10];
    [comps setYear:2017];
    [comps setHour:23];
    [comps setMinute:59];

    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    [[NSUserDefaults standardUserDefaults]setBool:[self isEndDateIsSmallerThanCurrent:date] forKey:@"stopBuyWine"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"buy wine: %d",[[NSUserDefaults standardUserDefaults]boolForKey:@"stopBuyWine"]);
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    NSLog(@"url scheme 9: %@",url.scheme);
    BOOL callback;
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.roman.Hostaria.payments"] == NSOrderedSame) {
     callback=   [BTAppSwitch handleOpenURL:url options:options];
    }else if ([url.scheme localizedCaseInsensitiveCompare:@"com.googleusercontent.apps.689478910757-d46jhmevs6md6pj7r7v0aq9e5gbnjkuo"] == NSOrderedSame) {
        callback= [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];

    }else if ([url.scheme localizedCaseInsensitiveCompare:@"fb187740274924972"] == NSOrderedSame) {
        callback= [[FBSDKApplicationDelegate sharedInstance]application:app didFinishLaunchingWithOptions:options];

        
    }
    return callback;
    
}*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"url scheme 8: %@",url.scheme);
    BOOL callback;

    
    //apps.googleusercontent.com
   
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.googleusercontent.apps.689478910757-pb1v4lm3rovb5956u4kq0qf5gem6ul5l"] == NSOrderedSame) {
        callback=  [[GIDSignIn sharedInstance] handleURL:url
                                           sourceApplication:sourceApplication
                                                  annotation:annotation];
    }/*else if ([url.scheme localizedCaseInsensitiveCompare:@"com.romanbalmus.tulain.hostaria.payments"] == NSOrderedSame) {
        callback=  [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }*/else if ([url.scheme localizedCaseInsensitiveCompare:@"fb187740274924972"] == NSOrderedSame ) {
        callback=  [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return callback;
    
}

@end
