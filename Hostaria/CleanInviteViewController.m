//
//  CleanInviteViewController.m
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//
typedef NS_ENUM(NSInteger, ViewControllerTransition) {
    ViewControllerTransitionSlideFromTop   = 0,
    ViewControllerTransitionSlideFromLeft,
    ViewControllerTransitionSlideFromBottom,
    ViewControllerTransitionSlideFromRight,
    ViewControllerTransitionRotateFromRight
};
#import "CleanInviteViewController.h"

@interface CleanInviteViewController (){
    BOOL simpleReg;
    NSMutableDictionary *userDataDictionary;
    
    
}
@property (weak, nonatomic) UIViewController *currentViewController;

@end

@implementation CleanInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]) {
        userDataDictionary = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];
    }else{
        userDataDictionary = [[NSMutableDictionary alloc]init];
        
    }
    
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(skipProcess:)];
    swipe.direction=UISwipeGestureRecognizerDirectionUp;
    swipe.enabled=YES;
    [self.mainContainer addGestureRecognizer:swipe];
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
- (void)slideFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.view];
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
            
            
            if ([tmn isKindOfClass:[MissingDataOrBuyController class]]) {
                NSLog(@"SPARTAAAAAAA : %@",NSStringFromClass([tmn class]));
                MissingDataOrBuyController *amt=(MissingDataOrBuyController*)tmn;
                amt.delegate=self;
                [amt setWelcome:simpleReg];
                [amt setDataToWorkWith:userDataDictionary];
                [amt.ticket addTarget:self action:@selector(skipProcess:) forControlEvents:UIControlEventTouchUpInside];
                [amt.goButton addTarget:self action:@selector(regWithdata) forControlEvents:UIControlEventTouchUpInside];

                
            }
            
        }
        
        
    }];
    
}


-(void)regWithdata{
    
    if ([self.currentViewController isKindOfClass:[UINavigationController class]]) {
        NSLog(@"SPARTAAAAAAA : NAVHERE");
        UINavigationController*mynav = (UINavigationController*)self.currentViewController;
        UIViewController * tmn=(UIViewController*)[mynav.viewControllers objectAtIndex:0];
        
        
        if ([tmn isKindOfClass:[MissingDataOrBuyController class]]) {
            NSLog(@"SPARTAAAAAAA : %@",NSStringFromClass([tmn class]));
            MissingDataOrBuyController *amt=(MissingDataOrBuyController*)tmn;
            [self simpleRegisterCallUserData2:[amt getTheDataToRegister]];
            
            
        }
        
    }
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
-(void)simpleRegisterCallUserData2:(id)userInfo{
    NSLog(@"simple callback called");
    NSDictionary*userData=(NSDictionary*)userInfo;
    if ([self dictionary:userData hasKey:@"email"]&&[self dictionary:userData hasKey:@"name"]&&[self dictionary:userData hasKey:@"surname"]&&[self dictionary:userData hasKey:@"password"]) {
        
        NSLog(@"register and buy");
        [userDataDictionary addEntriesFromDictionary:(NSDictionary*)userInfo];
        API.delegate=self;
        simpleReg=YES;
        [API registerUser:userDataDictionary onView:self.view];
    }
  
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


-(void)goToMissingDataOrBuy{
    UINavigationController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NAV_MISSINGDATA_CONTROLLER_ID"];
    
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)welcomeGoToLogin{
    [self goToLogin:nil];
}
-(void)welcomeGoToRegister{
    NSLog(@"welcome to reg");
    
    simpleReg=YES;
    [self goToMissingDataOrBuy];
}


-(void)welcomeGoToSkip{
    [self skipProcess:nil];
}
-(void)goToWelcome:(id)sender{
    CleanWelcomeViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CLEAN_WELCOME_CONTROLLER_ID"];
    newViewController.delegate=self;
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}

-(void)goToLogin:(id)sender{
    InputUserOneViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"INPUT_USER_ONE_CONTROLLER_ID"];
    newViewController.delegate=self;
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIStoryboard *iphonestor=[UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    CleanWelcomeViewController *newViewController = [iphonestor instantiateViewControllerWithIdentifier:@"CLEAN_WELCOME_CONTROLLER_ID"];
    // SponsorOneViewController*newViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"SPONSOR_ONE_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
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
                         
                         if ([newViewController isKindOfClass:[CleanWelcomeViewController class]]) {
                             NSLog(@"SPARTAAAAAAA : %@",NSStringFromClass([CleanWelcomeViewController class]));
                             CleanWelcomeViewController *tmn=(CleanWelcomeViewController*)newViewController;
                             tmn.delegate=self;
                             [tmn.signInBtn addTarget:self action:@selector(goToLogin:) forControlEvents:UIControlEventTouchUpInside];
                             [tmn.dismissButton addTarget:self action:@selector(skipProcess:) forControlEvents:UIControlEventTouchUpInside];
                             [tmn.regBtn addTarget:self action:@selector(goToMissingDataOrBuy) forControlEvents:UIControlEventTouchUpInside];
                          
                         }
                         [userDataDictionary removeObjectForKey:@"participation_date"];
                         
                         NSLog(@"current logged user: %@",userDataDictionary);
                     }];
}
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
