//
//  InputSceneThreeViewController.m
//  Hostaria
//
//  Created by iOS on 09/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "InputSceneThreeViewController.h"

@interface InputSceneThreeViewController ()<GIDSignInUIDelegate,GIDSignInDelegate>

@end

@implementation InputSceneThreeViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GIDSignIn sharedInstance].uiDelegate=self;
    [self.googleLoginBtn addTarget:self action:@selector(googleLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.fbLoginBtn addTarget:self action:@selector(facebookLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.twLoginBtn addTarget:self action:@selector(twitterLogin) forControlEvents:UIControlEventTouchUpInside];
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance]signOut];
}

-(void)twitterLogin{
    
    
    /*[[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
           // [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"askTWemail"];

            //[[NSUserDefaults standardUserDefaults]setObject:@"tw" forKey:@"loginType"];
          //  [[NSUserDefaults standardUserDefaults]synchronize];
            //[self performSegueWithIdentifier:@"goToMainContent" sender:self];
           // [self askTwitterEmail];
            
            if ([delegate respondsToSelector:@selector(loggedInWithUserInfo:)]) {
                [delegate loggedInWithUserInfo:@{@"askTWemail":@YES,@"loginType":@"tw",@"username":[session userName]}];
            }
            
            
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];*/

}
-(void)askTwitterEmail{
   /* if ([[NSUserDefaults standardUserDefaults]boolForKey:@"askTWemail"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"twEmail"]== NULL && [[[NSUserDefaults standardUserDefaults]objectForKey:@"loginType"]isEqualToString:@"tw"]) {
        if ([[Twitter sharedInstance] sessionStore]) {
            TWTRShareEmailViewController* shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString* email, NSError* error) {
                NSLog(@"Email %@, Error: %@", email, error);
                if (email.length>0) {
                    //[[NSUserDefaults standardUserDefaults]setObject:email forKey:@"twEmail"];
                   // [[NSUserDefaults standardUserDefaults]synchronize];
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
-(void)googleLogin{
    [[GIDSignIn sharedInstance]signIn];
}
-(void)facebookLogin{
  
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
       // [[NSUserDefaults standardUserDefaults]setObject:@"fb" forKey:@"loginType"];
       // [[NSUserDefaults standardUserDefaults]synchronize];
       // [self performSegueWithIdentifier:@"goToMainContent" sender:self];
       // return;
        
        
        
    }
    
 
    
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logInWithReadPermissions:@[@"public_profile",@"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"Login process error: %@",error.localizedDescription);
             
         }
         else if (result.isCancelled)
         {
             NSLog(@"User cancelled login");
             
         }
         else
         {
             NSLog(@"Login Success");
             
           //  if ([result.grantedPermissions containsObject:@"email"])
            // {
                 NSLog(@"result is:%@",result);
                 [self fetchUserInfo];
             //}else
             //{
             //    NSLog(@"Facebook public email permission error");
                 
            // }
             
             
         }
     }];
    

}
-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email,picture ,friends,first_name,last_name"}]
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
                    // [self performSegueWithIdentifier:@"goToMainContent" sender:self];
                     
                   //  [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"fbEmail"];
                    // [[NSUserDefaults standardUserDefaults]synchronize];
                     if ([delegate respondsToSelector:@selector(loggedInWithUserInfo:)]) {
                         [delegate loggedInWithUserInfo:@{@"loginType":@"1",@"name":[result objectForKey:@"first_name"],@"surname":[result objectForKey:@"last_name"],@"email":[result objectForKey:@"email"]}];
                     }
                     
                 }
                 else
                 {
                     if ([delegate respondsToSelector:@selector(loggedInWithUserInfo:)]) {
                         [delegate loggedInWithUserInfo:@{@"loginType":@"1",@"name":[result objectForKey:@"first_name"],@"surname":[result objectForKey:@"last_name"],@"username":[result objectForKey:@"name"],@"email":@""}];
                     }
                     NSLog(@"Facebook email is not verified");
                 }
                 
                // [[NSUserDefaults standardUserDefaults]setObject:@"fb" forKey:@"loginType"];
                // [[NSUserDefaults standardUserDefaults]synchronize];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma MARK GOOGLE

// [START signin_handler]
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
  //  NSString *userId = user.userID;                  // For client-side use only!
   // NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *username = user.profile.name;
    NSString *email = user.profile.email;
  __block  NSString *name = @"";
   __block NSString *surname = @"";
    // [START_EXCLUDE]
 
    
    
    if (error==nil) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/userinfo?access_token=%@",user.authentication.accessToken]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *skillData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"go data: %@",skillData);
            
            // use `skillData` here
            
            // finally, any UI/model updates should happen on main queue
            
            

            name = [skillData objectForKey:@"given_name"];
            surname = [skillData objectForKey:@"family_name"];

            if ([delegate respondsToSelector:@selector(loggedInWithUserInfo:)]) {
                [delegate loggedInWithUserInfo:@{@"loginType":@"2",@"username":username,@"email":email,@"name":name,@"surname":surname}];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
              
                
            });
        }];
        
        [dataTask resume];
        
    }
    
   
    
    // [END_EXCLUDE]
}
// [END signin_handler]
// This callback is triggered after the disconnect call that revokes data
// access to the user's resources has completed.
// [START disconnect_handler]
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // [START_EXCLUDE]
    NSLog(@"google error: %@",error.localizedDescription);
    // [END_EXCLUDE]
}
// [END disconnect_handler]
// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
