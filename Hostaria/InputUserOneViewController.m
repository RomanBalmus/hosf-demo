//
//  InputUserOneViewController.m
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "InputUserOneViewController.h"


@interface InputUserOneViewController ()<GIDSignInUIDelegate,GIDSignInDelegate,APIManagerDelegate>{
    NSMutableDictionary *userData;
}

@end

@implementation InputUserOneViewController
@synthesize delegate;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
      //  self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneBtn.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.doneBtn.selectiveBordersColor = [UIColor blackColor];
    self.doneBtn.selectiveBordersWidth = 1.0;
    [GIDSignIn sharedInstance].uiDelegate=self;
    [self.gplusBtn addTarget:self action:@selector(googleLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.fbButton addTarget:self action:@selector(facebookLogin) forControlEvents:UIControlEventTouchUpInside];
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance]signOut];
    [self.doneBtn addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];
    userData=[[NSMutableDictionary alloc]init];
    
    
    [self.resetPswrdBtn addTarget:self action:@selector(showResetPopup) forControlEvents:UIControlEventTouchUpInside];

}


-(void)showResetPopup{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Reimposta la password"
                                          message:@"Inserisci l'indirizzo email:"
                                          preferredStyle:UIAlertControllerStyleAlert];

    
  
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"E-mail";
         [textField addTarget:self
                       action:@selector(alertTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
     }];
    
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
                                   
                                   
                                   UITextField *email = alertController.textFields.firstObject;
                                   
                                   API.delegate = self;
                                   [API resetPassword:email.text onView:self.view];
                                   NSLog(@"OK action");
                               }];
    okAction.enabled = NO;
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 2;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)resetPassword:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"show explicit reset error :%@",error.debugDescription);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare l'operazione"
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
-(void)resetPassword:(APIManager *)manager didFinishLoading:(id)item{
    NSLog(@"reset in: %@",(NSDictionary*)item);
    
    if ([[item objectForKey:@"status"]isEqualToString:@"success"]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Operazione eseguita con successo."
                                                                            message: @"Si prega di controllare l-email per il passo successivo."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }else if([[item objectForKey:@"status"]isEqualToString:@"warning"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Operazione fallita."
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
    }else if([[item objectForKey:@"status"]isEqualToString:@"error"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Operazione fallita."
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
    }else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare l'operazione"
                                                                            message: @"Si prega di riprovare più tardi, il sistema è in manutenzione."
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
    NSLog(@"show reset finish");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loginUser:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"show explicit login error :%@",error.debugDescription);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare il login"
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
- (void)exchangeKey:(NSString *)aKey withKey:(NSString *)aNewKey inMutableDictionary:(NSMutableDictionary *)aDict
{
    if (![aKey isEqualToString:aNewKey]) {
        id objectToPreserve = [aDict objectForKey:aKey];
        [aDict setObject:objectToPreserve forKey:aNewKey];
        [aDict removeObjectForKey:aKey];
    }
}
-(void)loginUser:(APIManager *)manager didFinishLoading:(id)item{
    NSLog(@"logged in: %@",(NSDictionary*)item);
    
    if ([[item objectForKey:@"status"]isEqualToString:@"success"]) {
        
        if ([delegate respondsToSelector:@selector(loggedInWithUserInfo:)]) {
            
            
            [userData addEntriesFromDictionary:(NSDictionary*)item];
            [self exchangeKey:@"tickets" withKey:@"myTickets" inMutableDictionary:userData];
            [delegate loggedInWithUserInfo:userData];
            
            
        }
    }else if([[item objectForKey:@"status"]isEqualToString:@"warning"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare il login"
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
    }else if ([[item objectForKey:@"status"]isEqualToString:@"error"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare il login"
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
    }else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile effettuare il login"
                                                                            message: @"Si prega di riprovare più tardi, il sistema è in manutenzione."
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
    NSLog(@"show login error");
    
}
-(void)normalLogin{
    if (self.emailTF.text.length>0 && self.passwordTF.text.length>0) {
        API.delegate=self;
        userData=[[NSMutableDictionary alloc]init];
        [userData setObject:self.emailTF.text forKey:@"email"];
        [userData setObject:self.passwordTF.text forKey:@"password"];
        [userData setObject:@"0" forKey:@"loginType"];
        
        [API loginUser:userData onView:self.view];
    }
}

-(void)googleLogin{
    [[GIDSignIn sharedInstance]signOut];
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
    [login logOut];
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [login logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
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
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email,picture,first_name,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"results fetch:%@",result);
                 
                 NSString *email = [result objectForKey:@"email"];
                 //NSString *userId = [result objectForKey:@"id"];
                 //NSString *name = [result objectForKey:@"name"];
                 
                 if (email.length >0 )
                 {
                     //Start you app Todo
                     // [self performSegueWithIdentifier:@"goToMainContent" sender:self];
                     
                     //  [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"fbEmail"];
                     // [[NSUserDefaults standardUserDefaults]synchronize];
                     /*if ([delegate respondsToSelector:@selector(loggedInWithUserInfo:)]) {
                         [delegate loggedInWithUserInfo:@{@"loginType":@"1",@"name":[result objectForKey:@"first_name"],@"surname":[result objectForKey:@"last_name"],@"email":[result objectForKey:@"email" ],@"password":[[FBSDKAccessToken currentAccessToken]tokenString]}];
                     }*/
                     
                     API.delegate=self;
                     userData=[[NSMutableDictionary alloc]init];
                     [userData setObject:[result objectForKey:@"email"] forKey:@"email"];
                     [userData setObject:[[FBSDKAccessToken currentAccessToken]tokenString] forKey:@"password"];
                     [userData setObject:[result objectForKey:@"first_name"] forKey:@"name"];
                     [userData setObject:[result objectForKey:@"last_name"] forKey:@"surname"];

                     [userData setObject:@"1" forKey:@"loginType"];
                     
                     [API loginUser:userData onView:self.view];
                     
                 }
                 else
                 {
                     NSLog(@"ask user for email input");
                     NSLog(@"Facebook email is not verified");
                     
                     
                     UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Ops!"
                                                                                         message: @"Vogliamo che Hostaria Verona sia per te un'esperienza indimenticabile.\nAcconsenti Facebook di fornirci la tua e-mail per poterti far vivere appieno questo straordinario evento."
                                                                                  preferredStyle: UIAlertControllerStyleAlert];
                     
                     UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                                           style: UIAlertActionStyleDestructive
                                                                         handler: ^(UIAlertAction *action) {
                                                                             NSLog(@"ok button tapped!");
                                                                             
                                                                         }];
                     
                     [controller addAction: alertAction];
                     
                     [self presentViewController: controller animated: YES completion: nil];
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
            
            if (error==nil) {
                
           
            
            name = [skillData objectForKey:@"given_name"];
            surname = [skillData objectForKey:@"family_name"];
            NSString *email = [skillData objectForKey:@"email"];
            if (email.length>0) {
                
              /*  if ([delegate respondsToSelector:@selector(loggedInWithUserInfo:)]) {
                    [delegate loggedInWithUserInfo:@{@"loginType":@"2",@"username":username,@"email":email,@"name":name,@"surname":surname,@"password":user.authentication.accessToken}];
                }
                */
                API.delegate=self;
                userData=[[NSMutableDictionary alloc]init];
                [userData setObject:email forKey:@"email"];
                [userData setObject:user.authentication.accessToken forKey:@"password"];
                [userData setObject:name forKey:@"name"];
                [userData setObject:surname forKey:@"surname"];
                
                [userData setObject:@"2" forKey:@"loginType"];
              
                [API loginUser:userData onView:self.view];
            }else{
                
                UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Ops!"
                                                                                    message: @"Vogliamo che Hostaria Verona sia per te un'esperienza indimenticabile.\nAcconsenti Google di fornirci la tua e-mail per poterti far vivere appieno questo straordinario evento."
                                                                             preferredStyle: UIAlertControllerStyleAlert];
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                                      style: UIAlertActionStyleDestructive
                                                                    handler: ^(UIAlertAction *action) {
                                                                        NSLog(@"ok button tapped!");
                                                                        
                                                                    }];
                
                [controller addAction: alertAction];
                
                [self presentViewController: controller animated: YES completion: nil];
               
            }
           
            
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });
            }
            
           
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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTable" object:nil];

}

@end
