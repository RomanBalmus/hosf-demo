//
//  ScannerViewController.m
//  Hostaria
//
//  Created by iOS on 10/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ScannerViewController.h"
#import "NSData+IDZGunzip.h"
#import "Base64.h"
#import "RPC.h"
@interface ScannerViewController (){
    NSString *rpcType;
    NSMutableDictionary *userData;

}
@property (nonatomic, strong) ScannerView *codeScannerView;

@end

@implementation ScannerViewController
-(void)setScanType:(NSString*)rpc{
    rpcType=rpc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    
    UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startScanning];
}

-(void)startScanning{
    NSLog(@"start scanning");
    
    
    WAMP.delegate=self;
    [WAMP setOwnerTopicNull];
    if (self.codeScannerView ==nil) {
        
        
        self.codeScannerView = [[ScannerView alloc] initWithFrame:self.scannView.frame];
        self.codeScannerView.center=self.scannView.center;
        self.codeScannerView.delegate = self;
        [self.view addSubview:[self codeScannerView]];
        [self.view bringSubviewToFront:self.scannerImageView];
        [self.codeScannerView start];
        
    }else{
        [self.codeScannerView start];
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        NSLog(@"authorized");
        [WAMP openWamp];

        
        
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        NSLog(@"denied");
        
        
        UIAlertController *alertController1 = [UIAlertController
                                              alertControllerWithTitle:@"Camera device not allowed"
                                              message:@"This app needs you to authorize camera device to work."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                           
                                           
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                                   }];
        
        [alertController1 addAction:cancelAction];
        [alertController1 addAction:okAction];
        
        
        [self presentViewController:alertController1 animated:YES completion:nil];
        
   
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
        NSLog(@"restricted");
        
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        NSLog(@"not determined");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access");
                
                
                
                [WAMP startReconnect];

            } else {
                NSLog(@"Not granted access");
            }
        }];
    }
    
    
    
}
-(void)scannerView:(ScannerView *)scannerView didReadCode:(NSString *)code atTime:(NSString *)time{
    
    NSLog(@"code: %@",code);
    
    [self.codeScannerView stop];

    
        NSString *dec = [NSString stringWithBase64EncodedString:code];
    if (dec!=NULL) {
        
        NSData *jsonData = [dec dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
        
        
        NSLog(@"decoded %@", dict); // foo
        if([dict objectForKey:@"transfer"]!=NULL){
            
            NSMutableDictionary *dicttoWorkWith= [NSMutableDictionary dictionaryWithDictionary:dict];
            userData = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];

            [dicttoWorkWith removeObjectForKey:@"transfer"];
            
            NSLog(@"user data: %@",userData);
        

            
            
            
            if ([rpcType isEqualToString:RPC_TRANSFER]) {
                
                [dicttoWorkWith setObject:[userData objectForKey:@"id_user"] forKey:@"id_user_new"];
                RPC *rpc = [[RPC objectsWhere:[NSString stringWithFormat:@"type = '%@' ",rpcType]]firstObject];
                
                
                if (rpc == NULL) {
                    
                    NSLog(@"please close and re-open sender app1");
                    return;
                }
                
                NSLog(@"show teh rpc: %@",rpc);
                
                [dicttoWorkWith setObject:rpc.name forKey:@"rpcname"];
                [dicttoWorkWith setObject:@"0" forKey:@"paper"];

                [WAMP callTransfer:dicttoWorkWith];
            }
            if ([rpcType isEqualToString:RPC_COUPLE]) {
                
                [dicttoWorkWith setObject:[userData objectForKey:@"id_user"] forKey:@"id_user_new"];
                RPC *rpc = [[RPC objectsWhere:[NSString stringWithFormat:@"type = '%@' ",rpcType]]firstObject];
                if (rpc == NULL) {
                    
                    NSLog(@"please close and re-open sender app2");
                    return;
                }
                NSLog(@"show teh rpc: %@",rpc);
                
                [dicttoWorkWith setObject:rpc.name forKey:@"rpcname"];
                
                [dicttoWorkWith setObject:[userData objectForKey:@"email"] forKey:@"id_user_couple_mail"];
                [dicttoWorkWith setObject:@"0" forKey:@"paper"];

                [WAMP callCouple:dicttoWorkWith];
            }
        }else{
            NSLog(@"is not enabled for transfer %@", code); // foo

        }

    }else{
        
        
        if ([rpcType isEqualToString:RPC_TRANSFER]) {
            NSMutableDictionary *dicttoWorkWith= [[NSMutableDictionary alloc]init];
            userData = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];
            [dicttoWorkWith setObject:[userData objectForKey:@"id_user"] forKey:@"id_user_new"];
            RPC *rpc = [[RPC objectsWhere:[NSString stringWithFormat:@"type = '%@' ",rpcType]]firstObject];
            if (rpc == NULL) {
                
                NSLog(@"please close and re-open sender app2");
                return;
            }
            NSLog(@"show teh rpc: %@",rpc);
            
            [dicttoWorkWith setObject:rpc.name forKey:@"rpcname"];
            
            [dicttoWorkWith setObject:code forKey:@"qr_code"];

            
            [dicttoWorkWith setObject:@"1" forKey:@"paper"];
            
            [WAMP callTransfer:dicttoWorkWith];
            return;
        }
        
        
        
        NSLog(@"not decoded %@", code); // foo
        UIAlertController *alertController1 = [UIAlertController
                                               alertControllerWithTitle:@"Si è verificato un errore!"
                                               message:@""
                                               preferredStyle:UIAlertControllerStyleAlert];
        
    
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       
                                   }];
        
        [alertController1 addAction:okAction];
        
        
        [self presentViewController:alertController1 animated:YES completion:nil];
        

    }
  
    
    
    
    
  
   /*
    // Assuming data holds valid gzipped data
    NSError* error = nil;
    // gunzip the data
    NSData* gunzippedData = [checkdata gunzip:&error];
    if(!gunzippedData)
    {
        // Handle error
        NSLog(@"data not gzipped %@ error: %@",code,[error debugDescription]);
        
    }
    else
    {
        // Success use gunzippedData
        NSString *outputString = [[NSString alloc] initWithData:gunzippedData encoding:NSUTF8StringEncoding];
        NSLog(@"out %@",outputString);
    }
    */
 
    
}



-(void)wampRPCResponceError:(WampCom *)manager withData:(id)item andType:(NSString *)type{
    NSDictionary *arg=(NSDictionary*)item;
    
    UIAlertController *alertController1 = [UIAlertController
                                           alertControllerWithTitle:[arg objectForKey:@"status"]
                                           message:[arg objectForKey:@"description"]
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Esci"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                       
                                       [self.navigationController popViewControllerAnimated:YES];
                                       

                                   }];

    
    [alertController1 addAction:cancelAction];
    
    
    [self presentViewController:alertController1 animated:YES completion:nil];
    
    
}

-(void)wampRPCResponceSuccess:(WampCom *)manager withData:(id)item andType:(NSString *)type{
    NSDictionary *arg=(NSDictionary*)item;

    if ([type isEqualToString:RPC_COUPLE]) {
        
        NSMutableArray *mytick=[[userData objectForKey:@"myTickets"]mutableCopy];
        NSMutableArray *data = [arg objectForKey:@"data"];
        
        for (NSDictionary *tckt in data) {
            [mytick addObject:tckt];
        }
        
        
        NSMutableDictionary *innuserData= [[NSMutableDictionary alloc]initWithDictionary:userData];
        NSMutableDictionary *myTickets=[[NSMutableDictionary alloc]init];
        
        [myTickets setObject:mytick forKey:@"myTickets"];
        
        [innuserData addEntriesFromDictionary:myTickets ];
        
        [[NSUserDefaults standardUserDefaults]setObject:innuserData forKey:@"current_user_data"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
        NSLog(@"userdata now:%@",userData);
        
    }
    if ([type isEqualToString:RPC_TRANSFER]) {
        
        NSMutableArray *mytick=[[userData objectForKey:@"myTickets"]mutableCopy];
        NSMutableArray *data = [arg objectForKey:@"data"];
        
        for (NSDictionary *tckt in data) {
            [mytick addObject:tckt];
        }
        
        
        NSMutableDictionary *innuserData= [[NSMutableDictionary alloc]initWithDictionary:userData];
        NSMutableDictionary *myTickets=[[NSMutableDictionary alloc]init];
        
        [myTickets setObject:mytick forKey:@"myTickets"];
        
        [innuserData addEntriesFromDictionary:myTickets ];
        
        [[NSUserDefaults standardUserDefaults]setObject:innuserData forKey:@"current_user_data"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
        NSLog(@"userdata now:%@",userData);

    }
    
    
    UIAlertController *alertController1 = [UIAlertController
                                           alertControllerWithTitle:[arg objectForKey:@"status"]
                                           message:nil
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Esci"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                       
                                       [self.navigationController popViewControllerAnimated:YES];
                                       [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTable" object:nil];
                                   }];
    
    
    [alertController1 addAction:cancelAction];
    
    
    [self presentViewController:alertController1 animated:YES completion:nil];
}








-(BOOL)isBase64Data:(NSString *)input
{
    
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}

@end
