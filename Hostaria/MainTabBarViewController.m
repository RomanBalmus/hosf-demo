//
//  MainTabBarViewController.m
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "ProfileViewController.h"
#import "MyTicketViewController.h"
#import "UserProfilePageXIBViewController.h"
#import "MyGlobalTicketViewController.h"
#import "PageSwipeViewController.h"
#import "StandListViewController.h"
#import "FeedbackViewController.h"
#import "CartViewController.h"
#import "CleanWelcomeViewController.h"
#import "OrderListViewController.h"
@interface MainTabBarViewController ()<CleanWelcomeDelegate>{
    UIViewController* child;
    BOOL showTicket;
}

@end

@implementation MainTabBarViewController

-(NSArray*)generateViewControllers{
    UIStoryboard *storyBoadr = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];

    PageSwipeViewController *home = [storyBoadr instantiateViewControllerWithIdentifier:@"PAGE_VIEW_CONTROLLER_ID"];

    
    UINavigationController * homenav = [[UINavigationController alloc]initWithRootViewController:home];
    homenav.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Home"
                                  image:[[UIImage imageNamed:@"tab_home_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                    selectedImage:[[UIImage imageNamed:@"tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    MapViewController *map = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    UINavigationController * projectnav = [[UINavigationController alloc]initWithRootViewController:map];
    projectnav.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Mappa"
                                  image:[[UIImage imageNamed:@"tab_map_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   selectedImage:[[UIImage imageNamed:@"tab_map_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    StandListViewController *standlist = [storyBoadr instantiateViewControllerWithIdentifier:@"STAND_LIST_VIEW_CONTROLLER_ID"];
    UINavigationController * myareanav = [[UINavigationController alloc]initWithRootViewController:standlist];
    myareanav.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Elenco stand"
                                  image:[[UIImage imageNamed:@"stand_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                    selectedImage:[[UIImage imageNamed:@"stand_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//was tag 3
   
    
    
    CartViewController *cart = [[CartViewController alloc]initWithNibName:@"CartViewController" bundle:nil];
    
    
    UINavigationController * cartnav = [[UINavigationController alloc]initWithRootViewController:cart];
    cartnav.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Carrello"
                                  image:[[UIImage imageNamed:@"tab_cart_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:[[UIImage imageNamed:@"tab_cart_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [cart LoadIt];
    
    
    
    OrderListViewController *orderList = [[OrderListViewController alloc]initWithNibName:@"OrderListViewController" bundle:nil];
    
    
    UINavigationController * ordernav = [[UINavigationController alloc]initWithRootViewController:orderList];
    ordernav.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Ordini"
                                  image:[[UIImage imageNamed:@"tab_order_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:[[UIImage imageNamed:@"tab_order_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    return @[homenav, projectnav, myareanav,cartnav,ordernav];
}




-(void)goToWelcomeController{
  
    
    
    UIStoryboard *sotryboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    child = [sotryboard instantiateViewControllerWithIdentifier:@"CLEAN_INVITE_TO_BUY_MAIN_CONTROLLER_ID"];

    child.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    
    // child.view.alpha = 0.0;
    [child beginAppearanceTransition:YES animated:YES];
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^(void){
         //child.view.alpha = 1.0;
         child.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
         
         
     }
     completion:^(BOOL finished) {
         [child endAppearanceTransition];
         [child didMoveToParentViewController:self];
         [SPOT stopSpot];
     }
     ];

   
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)showfeedback:(NSNotification*)notification{
    
    NSLog(@"show feedback: %@ ",notification.userInfo);
    
    NSDictionary*item=(NSDictionary*)notification.userInfo;
    
    FeedbackViewController *ctrl = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    [ctrl setFeedBackDataToWorkWith:item];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)viewDidLoad {
    
   
    
    
    
    [super viewDidLoad];
    self.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    NSLog(@"thec nav class of tab:%@",NSStringFromClass([self.navigationController class]));
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
  
    
    [self setViewControllers:[self generateViewControllers]];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dragChildRigth) name:@"showTicket" object:nil];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dragMyChildRigth) name:@"showMyTicket" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dragChildRigth) name:@"showLogin" object:nil];

    
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dragChildRigth) name:@"showLogin" object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showfeedback:) name:@"showfeedback" object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToWelcomeController) name:@"goToWelcome" object:nil];

    
    /*if (![[NSUserDefaults standardUserDefaults]boolForKey:@"asked"]) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hostaria vorrebbe inviarti notifiche push" message:@"Per favore abbilità le notifiche, riceverai solo notifiche informative che riguarda eventi di Hostaria" preferredStyle:UIAlertControllerStyleAlert]; // 7
        
        UIAlertAction *consentiAction = [UIAlertAction actionWithTitle:@"Consenti" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
            UIApplication *application = [UIApplication sharedApplication];
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                                 |UIUserNotificationTypeSound
                                                                                                 |UIUserNotificationTypeAlert) categories:nil];
            [application registerUserNotificationSettings:settings];
        }]; // 8
        UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"No, grazie" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button No");
        }]; // 8
        [alert addAction:consentiAction]; // 9
        [alert addAction:rejectAction]; // 9
        
     
        
        [[[[UIApplication sharedApplication ]keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil]; // 11
    }else{
        [self checkNotifications];
    }*/
    
  
    
  
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    
    if ([[dict objectForKey:@"myTickets"]count]>0) {
        showTicket= YES;
    }else{
        showTicket = NO;
        
    }
    if (!showTicket) {
        [self dragChildRigth];
        showTicket = YES;
    }
    
}
- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
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

-(void)dragMyChildRigth{
    
    
   NSDictionary *myTicket=[[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_favorite_ticket"]];
    
    
    NSLog(@"myticket: %@",myTicket);
    
    if (![self dictionary:myTicket hasKey:@"ticketQrcode"]) {
        
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Attenzione"
                                                                            message: @"Per visualizzare il biglietto vai nel tuo Profilo, seleziona il biglietto e clicca sulla stella per aggiungerlo come preferito."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction *action) {
                                                                       NSLog(@"ok button tapped!");
                                                                       
                                                                       
                                                                       
                                                                   }];
        
        [controller addAction: alertActionConfirm];
        
        
        
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }
    
    
    UIStoryboard *sotryboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    
    child = [sotryboard instantiateViewControllerWithIdentifier:@"MY_GLOBAL_TICKET_ID"];
    
    
    if ([child isKindOfClass:[MyGlobalTicketViewController class]]) {
        MyGlobalTicketViewController *global = (MyGlobalTicketViewController*)child;
        [global setNaviGation:self.navigationController];
    }
    
    child.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    
    // child.view.alpha = 0.0;
    [child beginAppearanceTransition:YES animated:YES];
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^(void){
         //child.view.alpha = 1.0;
         child.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
         
         
     }
     completion:^(BOOL finished) {
         [child endAppearanceTransition];
         [child didMoveToParentViewController:self];
         [SPOT stopSpot];
     }
     ];
}


-(void)dragChildRigth{
  
    
  
    
    
    UIStoryboard *sotryboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    
    child = [sotryboard instantiateViewControllerWithIdentifier:@"INVITE_TO_BUY_MAIN_CONTROLLER_ID"];
    
    child.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:child];
    [self.view addSubview:child.view];

   // child.view.alpha = 0.0;
    [child beginAppearanceTransition:YES animated:YES];
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^(void){
         //child.view.alpha = 1.0;
         child.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);

       
     }
     completion:^(BOOL finished) {
         [child endAppearanceTransition];
         [child didMoveToParentViewController:self];
         [SPOT stopSpot];
     }
     ];
}


-(void)checkNotifications{
    UIApplication *application= [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(currentUserNotificationSettings)]){ // Check it's iOS 8 and above
        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (grantedSettings.types == UIUserNotificationTypeNone) {
            NSLog(@"No permiossion granted");
            [self pushAskAlert];
        }
        else if (grantedSettings.types & UIUserNotificationTypeSound & UIUserNotificationTypeAlert ){
            NSLog(@"Sound and alert permissions ");
            if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                /*UIMutableUserNotificationAction *action1;
                 action1 = [[UIMutableUserNotificationAction alloc] init];
                 [action1 setActivationMode:UIUserNotificationActivationModeBackground];
                 [action1 setActivationMode:UIUserNotificationActivationModeForeground];
                 
                 [action1 setTitle:@"Action 1"];
                 [action1 setIdentifier:NotificationActionOneIdent];
                 [action1 setDestructive:NO];
                 [action1 setAuthenticationRequired:NO];
                 
                 UIMutableUserNotificationAction *action2;
                 action2 = [[UIMutableUserNotificationAction alloc] init];
                 [action2 setActivationMode:UIUserNotificationActivationModeBackground];
                 [action2 setActivationMode:UIUserNotificationActivationModeForeground];
                 
                 [action2 setTitle:@"Vedi"];
                 [action2 setIdentifier:NotificationActionTwoIdent];
                 [action2 setDestructive:NO];
                 [action2 setAuthenticationRequired:NO];
                 
                 UIMutableUserNotificationCategory *actionCategory;
                 actionCategory = [[UIMutableUserNotificationCategory alloc] init];
                 [actionCategory setIdentifier:NotificationCategoryIdent];
                 [actionCategory setActions:@[action1, action2]
                 forContext:UIUserNotificationActionContextDefault];
                 [actionCategory setActions:@[action1, action2]
                 forContext:UIUserNotificationActionContextMinimal];
                 NSSet *categories = [NSSet setWithObject:actionCategory];*/
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                                     |UIUserNotificationTypeSound
                                                                                                     |UIUserNotificationTypeAlert) categories:nil];
                [application registerUserNotificationSettings:settings];
            }
        }
        else if (grantedSettings.types  & UIUserNotificationTypeAlert){
            NSLog(@"Alert Permission Granted");
            if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                /*UIMutableUserNotificationAction *action1;
                 action1 = [[UIMutableUserNotificationAction alloc] init];
                 [action1 setActivationMode:UIUserNotificationActivationModeBackground];
                 [action1 setActivationMode:UIUserNotificationActivationModeForeground];
                 
                 [action1 setTitle:@"Action 1"];
                 [action1 setIdentifier:NotificationActionOneIdent];
                 [action1 setDestructive:NO];
                 [action1 setAuthenticationRequired:NO];
                 
                 UIMutableUserNotificationAction *action2;
                 action2 = [[UIMutableUserNotificationAction alloc] init];
                 [action2 setActivationMode:UIUserNotificationActivationModeBackground];
                 [action2 setActivationMode:UIUserNotificationActivationModeForeground];
                 
                 [action2 setTitle:@"Vedi"];
                 [action2 setIdentifier:NotificationActionTwoIdent];
                 [action2 setDestructive:NO];
                 [action2 setAuthenticationRequired:NO];
                 
                 UIMutableUserNotificationCategory *actionCategory;
                 actionCategory = [[UIMutableUserNotificationCategory alloc] init];
                 [actionCategory setIdentifier:NotificationCategoryIdent];
                 [actionCategory setActions:@[action1, action2]
                 forContext:UIUserNotificationActionContextDefault];
                 [actionCategory setActions:@[action1, action2]
                 forContext:UIUserNotificationActionContextMinimal];
                 NSSet *categories = [NSSet setWithObject:actionCategory];*/
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                                     |UIUserNotificationTypeSound
                                                                                                     |UIUserNotificationTypeAlert) categories:nil];
                [application registerUserNotificationSettings:settings];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   /* if ([[NSUserDefaults standardUserDefaults]boolForKey:@"askTWemail"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"twEmail"]== NULL && [[[NSUserDefaults standardUserDefaults]objectForKey:@"loginType"]isEqualToString:@"tw"]) {
        if ([[Twitter sharedInstance] sessionStore]) {
            TWTRShareEmailViewController* shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString* email, NSError* error) {
                NSLog(@"Email %@, Error: %@", email, error);
                if (email.length>0) {
                    [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"twEmail"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                   // [self performSegueWithIdentifier:@"goToMainContent" sender:self];
                    
                }
            }];
                [self presentViewController:shareEmailViewController animated:YES completion:nil];
                
            
        } else {
            // TODO: Handle user not signed in (e.g. attempt to log in or show an alert)
        }
    }
    
    */
    
    

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

- (void)openSettings
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNotifications) name:UIApplicationWillEnterForegroundNotification object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    });
    
    
}
-(void)pushAskAlert{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hostaria vorrebbe inviarti notifiche push" message:@"Per favore abbilità le notifiche, riceverai solo notifiche informative che riguarda eventi di Hostaria" preferredStyle:UIAlertControllerStyleAlert]; // 7
    
    UIAlertAction *consentiAction = [UIAlertAction actionWithTitle:@"Impostazioni" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
        /* UIApplication *application = [UIApplication sharedApplication];
         
         UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
         |UIUserNotificationTypeSound
         |UIUserNotificationTypeAlert) categories:nil];
         [application registerUserNotificationSettings:settings];*/
        [self openSettings];
    }]; // 8
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"No, grazie" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button No");
    }]; // 8
    [alert addAction:consentiAction]; // 9
    [alert addAction:rejectAction]; // 9
    
    /* [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
     textField.placeholder = @"Input data...";
     }];*/ // 10
    
    [[[[UIApplication sharedApplication ]keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil]; // 11
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    
    NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
    NSLog(@"controller title: %lu", (unsigned long)tabBarController.selectedIndex);
    [self.navigationController setNavigationBarHidden:NO];


    

   
}

@end
