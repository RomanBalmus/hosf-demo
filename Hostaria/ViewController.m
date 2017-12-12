//
//  ViewController.m
//  Hostaria
//
//  Created by iOS on 13/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () 

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*for(UIView *view in [self.view subviews]){
        if ([view isKindOfClass:[UIButton class]]) {
            [view setHidden:YES];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"loginType"]!=NULL) {
        [self performSegueWithIdentifier:@"goToMainContent" sender:self];

    }else{
        NSLog(@"show controller");
        for(UIView *view in [self.view subviews]){
            if ([view isKindOfClass:[UIButton class]]) {
                [view setHidden:NO];
            }
        }
    }*/
    //[self performSegueWithIdentifier:@"goToMainContent" sender:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
  

    // Do any additional setup after loading the view, typically from a nib.
  
    
    [self.myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
    [self.twitterLogin addTarget:self action:@selector(twittLogin) forControlEvents:UIControlEventTouchUpInside];
    }
-(void)twittLogin{
    
    
  /*
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [[NSUserDefaults standardUserDefaults]setObject:@"tw" forKey:@"loginType"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self performSegueWithIdentifier:@"goToMainContent" sender:self];

    
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];*/
}
-(void)loginButtonClicked
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"loginType"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self performSegueWithIdentifier:@"goToMainContent" sender:self];
        return;
        
        
        
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    
    
    
    
    [login logInWithReadPermissions:@[@"public_profile",@"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"Login process error");
             
         }
         else if (result.isCancelled)
         {
             NSLog(@"User cancelled login");
             
         }
         else
         {
             NSLog(@"Login Success");
             
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 NSLog(@"result is:%@",result);
                 [self fetchUserInfo];
             }else
             {
                 NSLog(@"Facebook public email permission error");
                 
             }
             
             
         }
     }];
    
    

    
    
  
}
-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email,picture ,friends"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"results:%@",result);
                 
                 NSString *email = [result objectForKey:@"email"];
                 //NSString *userId = [result objectForKey:@"id"];
                 //NSString *name = [result objectForKey:@"name"];
                 
                 if (email.length >0 )
                 {
                     //Start you app Todo
                     [self performSegueWithIdentifier:@"goToMainContent" sender:self];
                   
                     [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"fbEmail"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                 }
                 else
                 {
                     
                     NSLog(@"Facebook email is not verified");
                 }
                 
                 [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"loginType"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
             }
             else
             {
                 NSLog(@"Error %@",error);
                 
             }
         }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"goToMainContent"]) {
        //LoginTableViewController * childViewController = (LoginTableViewController *) [segue destinationViewController];
        // do something with the AlertView's subviews here...
        
    }
}

@end
