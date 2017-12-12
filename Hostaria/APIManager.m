//
//  APIManager.m
//  Hostaria
//
//  Created by iOS on 17/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "APIManager.h"
#import "RoutePoint.h"
#import "Service.h"
#import "MapGPoint.h"
#import "AppDelegate.h"
static NSString * const kAuthName = @"utente1";
static NSString * const kAuthPassword = @"utente1repo";
static NSString * const kRequestSerializer = @"application/x-www-form-urlencoded";

@implementation APIManager

/*REGISTRATION PARAMETERS: name*,surname*,businessName,pI,cf,address,zipCode,city,province,country,officePhone,mobilePhone,email*,password*,language,appid,pushtoken,os,chatDomain,photoName,photoPath,photoThumbPath*/
@synthesize delegate;
+ (instancetype)sharedInstance
{
    static APIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIManager alloc] init];

        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
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

//Call this method for start explosion animation
-(void)getWampConfiguration{
    [AppDel huddie];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
     manager.securityPolicy.allowInvalidCertificates = YES;
    

    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIGetWampDataUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [AppDel.hud hide:YES];

        if (error) {
            NSLog(@"Error wampcfg: %@", error);
            
            if ([delegate respondsToSelector:@selector(wampCfg:didFailWithError:)]) {
                [delegate wampCfg:self didFailWithError:error];
            }
        } else {
            NSLog(@"%@ \nobj: %@", response, responseObject);
            NSDictionary * rsp = (NSDictionary*)responseObject;

            if ([[rsp objectForKey:@"status"]isEqualToString:@"success"]) {
                if ([delegate respondsToSelector:@selector(wampCfg:didFinishLoading:)]) {
                    [delegate wampCfg:self didFinishLoading:responseObject];
                }
            }else{
                if ([delegate respondsToSelector:@selector(wampCfg:didFailWithError:)]) {
                    [delegate wampCfg:self didFailWithError:[NSError errorWithDomain:@"wamp cfg" code:21 userInfo:responseObject]];
                }
            }
           
            
        }
        
        
        
    }];
    
    [dataTask resume];

}


-(void)resetPassword:(NSString *)email onView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:email forKey:@"email"];
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIResetPasswordURL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        if (error) {
            NSLog(@"Error resetPassword: %@", error);
            
            if ([delegate respondsToSelector:@selector(resetPassword:didFailWithError:)]) {
                [delegate resetPassword:self didFailWithError:error];
            }
        } else {
            NSLog(@"%@ resetPassword\nobj: %@", response, responseObject);
          //  NSDictionary * rsp = (NSDictionary*)responseObject;
            
                if ([delegate respondsToSelector:@selector(resetPassword:didFinishLoading:)]) {
                    [delegate resetPassword:self didFinishLoading:responseObject];
                }
            
            
            
        }
    }];
    
    [dataTask resume];

}

-(void)getCellarDataForEvent:(NSString*)event_id{
    [AppDel huddie];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
     manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:event_id forKey:@"id_event"];

    NSLog(@"cellardata %@",dataToPost);
    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIGetCellarDataURL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [AppDel.hud hide:YES];

        if (error) {
            NSLog(@"Error cellardata: %@", error);
            
        } else {
            NSLog(@"%@ \nobj: %@", response, responseObject);
            
            
            NSArray *companies =[responseObject objectForKey:@"companies"];
            
            
            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            
            // Begin a write transaction to save to the default Realm
            [defaultRealm beginWriteTransaction];
            for (NSDictionary *cmp in companies) {
                
                
                
                Cellar *cantina = [[Cellar alloc]init]; // Create a new object
              
                
                cantina._id = [NSString stringWithFormat:@"%@",cmp[@"id"]];
                cantina.name = [NSString stringWithFormat:@"%@",cmp[@"name"]];
                cantina.address = [NSString stringWithFormat:@"%@",cmp[@"address"]];
                cantina.revision = [NSString stringWithFormat:@"%@",cmp[@"revision"]];
                //cantina.lng = [NSString stringWithFormat:@"%@",cmp[@"lng"]];
                //cantina.lat = [NSString stringWithFormat:@"%@",cmp[@"lat"]];

                for (NSDictionary *prd in cmp[@"products"]) {
                    
                    Product *product = [[Product alloc]init]; // Create a new object
                    product.name = [NSString stringWithFormat:@"%@",prd[@"productName"]];
                    product._id = [NSString stringWithFormat:@"%@",prd[@"id"]];
                    product.revision =[NSString stringWithFormat:@"%@", prd[@"revision"]];
                    product.price =[NSString stringWithFormat:@"%@", prd[@"productPrice"]];
                    product.winetype =[NSString stringWithFormat:@"%@", prd[@"productType"]];
                    product.winecolor =[NSString stringWithFormat:@"%@", prd[@"productColor"]];
                    product.credits = [NSString stringWithFormat:@"%@",prd[@"productCredits"]];
                    product.winecategoryId=[NSString stringWithFormat:@"%@",prd[@"productCategory"]];
                    product.quantity=@"";

                    product.cellar=cantina;
                    [cantina.products addObject:product];

                }
                [defaultRealm addObject:cantina];
            }
            [defaultRealm commitWriteTransaction];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updatestandlist" object:nil];
            
            
            
            
            
            
            [self getWampConfiguration];
            
        }
    }];
    
    [dataTask resume];
}



-(void)getStandDataForEvent:(NSString*)event_id{
    [AppDel huddie];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
     manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:event_id forKey:@"id_event"];
    
    NSLog(@"standdata %@",dataToPost);
    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIGetStandDataURL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [AppDel.hud hide:YES];
        if (error) {
            NSLog(@"Error stand data: %@", error);
            
        } else {
            NSLog(@"%@ \nobj: %@", response, responseObject);
            
            NSArray *stands =[responseObject objectForKey:@"stands"];


            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            
            // Begin a write transaction to save to the default Realm
            [defaultRealm beginWriteTransaction];
            for (NSDictionary *std in stands) {
           
                
                
                
                
                Stand *stand = [[Stand alloc]init]; // Create a new object
              
                stand._id = [NSString stringWithFormat:@"%@",std[@"standId"]];
                stand.name = [NSString stringWithFormat:@"%@",std[@"standName"]];
                stand.address = [NSString stringWithFormat:@"%@",std[@"standAddress"]];
                stand.revision =[NSString stringWithFormat:@"%@", std[@"standRevision"]];
                stand.cellarId = [NSString stringWithFormat:@"%@",std[@"idCompany"]];
                stand._description = [NSString stringWithFormat:@"%@",std[@"standDescription"]];

                
                
                
                
                
                
                MapGPoint *point = [[MapGPoint alloc]init];
                point.lng = [NSString stringWithFormat:@"%@",std[@"standLng"]];
                point.lat = [NSString stringWithFormat:@"%@",std[@"standLat"]];
                point.type= TYPE_STAND;
                point.stand=stand;

                [defaultRealm addObject:point];

                
            }
            [defaultRealm commitWriteTransaction];
            
            
            
            [self getCellarDataForEvent:event_id];

        }

    }];
    
    [dataTask resume];
}




-(void)getAppData{
    [AppDel huddie];
  
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"deleterealm"]==nil){
        [[NSFileManager defaultManager] removeItemAtURL:[RLMRealmConfiguration defaultConfiguration].fileURL error:nil];
        NSLog(@"delete realm");
        [[NSUserDefaults standardUserDefaults]setObject:@"passed" forKey:@"deleterealm"];
        
        [NSUserDefaults standardUserDefaults];
    }
    

    NSLog(@"getAppData");
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    NSLog(@"getAppData %@",dataToPost);
    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIAppDataUrl parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
   // [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [AppDel.hud hide:YES];
        if (error) {
            NSLog(@"Error getappdata1: %@", error);
            
        } else {
            NSLog(@"%@ \nobj: %@", response, responseObject);
            
            [self writeJsonToFile:(NSDictionary*)responseObject];
        }
    }];
    
    [dataTask resume];

}
- (void)writeJsonToFile:(NSDictionary*)json
{
    
    
    [AppDel huddie];
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
        
        NSFileManager *fileManager = [NSFileManager defaultManager];

        
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        
        RLMRealm *defaultRealm = [RLMRealm defaultRealm];
        [defaultRealm beginWriteTransaction];
        [defaultRealm deleteAllObjects];
        [defaultRealm commitWriteTransaction];
        
        
        
        [jsonData writeToFile:filePath atomically:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"appDataOnce"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        NSString * currentversiorn=[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        currentversiorn = [currentversiorn stringByReplacingOccurrencesOfString:@"."
                                                                     withString:@""];
        
        NSLog(@"current version %@",currentversiorn);
        
        if ([[[json objectForKey:@"mobileAppVersion"]objectForKey:@"ios"]integerValue]==[currentversiorn integerValue]) {
            NSLog(@"version is the same");
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"versionupdate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
        }else{
            NSLog(@"need update");
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"versionupdate"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        
        
        
        
        NSArray *events =[[json objectForKey:@"data"]objectForKey:@"events"];
        
        
        if (events.count==0) {
            [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"noevent"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return;
        }
        
        for (NSDictionary *evnt  in events) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[[evnt objectForKey:@"dateStop"]objectForKey:@"date"]] forKey:@"endTime"];
            [[NSUserDefaults standardUserDefaults]setObject:[evnt objectForKey:@"timeStop"]forKey:@"endHour"];
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"noevent"];

            [[NSUserDefaults standardUserDefaults]setObject:[evnt objectForKey:@"idEvent"] forKey:@"event_id"];

            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            
            break;
        }
        
        // Begin a write transaction to save to the default Realm
        [defaultRealm beginWriteTransaction];
        NSArray *route =[[json objectForKey:@"data"]objectForKey:@"route"];
        for (NSDictionary *rp in route) {
            RoutePoint *point = [[RoutePoint alloc]init];
            point.lat = [NSString stringWithFormat:@"%@",rp[@"lat"]];
            point.lng = [NSString stringWithFormat:@"%@",rp[@"lng"]];
            point.number = [NSString stringWithFormat:@"%@",rp[@"routeNumber"]];

            
            [defaultRealm addObject:point];
        }
        [defaultRealm commitWriteTransaction];

        

        [defaultRealm beginWriteTransaction];
        NSArray *services =[[json objectForKey:@"data"]objectForKey:@"services"];
        for (NSDictionary *sr in services) {
            
          
            

            
            
            NSString *hiddenStr= [NSString stringWithFormat:@"%@",sr[@"isHidden"]];
            NSString *event= [NSString stringWithFormat:@"%@",sr[@"idEvent"]];
            NSString *status= [NSString stringWithFormat:@"%@",sr[@"serviceStatus"]];

         
            
            if ([hiddenStr isEqualToString:@"0"] && [event isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"event_id"]]] && [status isEqualToString:@"1"]) {
                
                Service *srv = [[Service alloc]init];

                
                srv._description = [NSString stringWithFormat:@"%@",sr[@"servicesDefinition"]];
                srv.revision = [NSString stringWithFormat:@"%@",sr[@"revision"]];
                srv.name = [NSString stringWithFormat:@"%@",sr[@"typeName"]];
                srv.serviceNameDefinition = [NSString stringWithFormat:@"%@",sr[@"servicesDefinition"]];
                
                NSString *stypid=[NSString stringWithFormat:@"%@",sr[@"typeId"]];
                
                srv.serviceTypeId=stypid;
               
                if ([stypid isEqualToString:@"1"]){
                    srv.serviceLocalType  = TYPE_RISTORANTI;
                    
                }
                if ([stypid isEqualToString:@"2"]){
                    srv.serviceLocalType  = TYPE_TYPIC_PRODUCTS;
                    
                }
                
                if ([stypid isEqualToString:@"3"]){
                    srv.serviceLocalType  = TYPE_INFO_POINT;
                    
                }
                if ([stypid isEqualToString:@"4"]){
                    srv.serviceLocalType  = TYPE_HO_SHOP;
                    
                }
                if ([stypid isEqualToString:@"5"]){
                    srv.serviceLocalType  = TYPE_ENTRANCE;
                    
                }
                
                if ([stypid isEqualToString:@"6"]){
                    srv.serviceLocalType  = TYPE_GEN_SPONSOR;
                    // srv.numeration = [NSString stringWithFormat:@"%@",sr[@"numeration"]];  TODO
                    srv.fired = @"0";
                    NSLog(@"arrived millis: %@",sr[@"timeServiceStart"]);
                    NSLog(@"sr millis: %@",sr);
                    
                    
                    NSDate * sdate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStart"]intValue]];
                    NSLog(@"sdate millis: %@",sdate);
                    
                    srv.starttime=sdate;
                    NSDate * edate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStop"]intValue]];
                    NSLog(@"edate millis: %@",edate);
                    srv.endtime=edate;

                }
                if ([stypid isEqualToString:@"7"]){
                    srv.serviceLocalType  = TYPE_WINE_SELL;
                    
                }
                if ([stypid isEqualToString:@"8"]){
                    srv.serviceLocalType  = TYPE_BABY_HO;
                    
                }
                if ([stypid isEqualToString:@"9"]){
                    srv.serviceLocalType  = TYPE_TOILETE;
                    
                }
                if ([stypid isEqualToString:@"10"]){
                    srv.serviceLocalType  = TYPE_EVENT_AREA;
                   // srv.numeration = [NSString stringWithFormat:@"%@",sr[@"numeration"]];  TODO
                    srv.fired = @"0";
                    NSLog(@"arrived millis: %@",sr[@"timeServiceStart"]);
                    NSLog(@"sr millis: %@",sr);
                    
                    
                    NSDate * sdate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStart"]intValue]];
                    NSLog(@"sdate millis: %@",sdate);

                    srv.starttime=sdate;
                    NSDate * edate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStop"]intValue]];
                    NSLog(@"edate millis: %@",edate);
                    srv.endtime=edate;

                }
                
                if ([stypid isEqualToString:@"11"]){
                    srv.serviceLocalType  = TYPE_PARKING;
                    
                }
                if ([stypid isEqualToString:@"12"]){
                    srv.serviceLocalType = TYPE_MONTE_VERONESE;
                    // srv.numeration = [NSString stringWithFormat:@"%@",sr[@"numeration"]];  TODO
                    srv.fired = @"0";
                    NSLog(@"arrived millis: %@",sr[@"timeServiceStart"]);
                    NSLog(@"sr millis: %@",sr);
                    
                    
                    NSDate * sdate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStart"]intValue]];
                    NSLog(@"sdate millis: %@",sdate);
                    
                    srv.starttime=sdate;
                    NSDate * edate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStop"]intValue]];
                    NSLog(@"edate millis: %@",edate);
                    srv.endtime=edate;

                }

                if ([stypid isEqualToString:@"13"]){
                    srv.serviceLocalType = TYPE_PARTNER;
                }
                if ([stypid isEqualToString:@"14"]){
                    srv.serviceLocalType = TYPE_FOOD_AREA;
                }
                if ([stypid isEqualToString:@"15"]){
                    srv.serviceLocalType = TYPE_NORMAL_EVENT;
                    // srv.numeration = [NSString stringWithFormat:@"%@",sr[@"numeration"]];  TODO
                    srv.fired = @"0";
                    NSLog(@"arrived millis: %@",sr[@"timeServiceStart"]);
                    NSLog(@"sr millis: %@",sr);
                    
                    
                    NSDate * sdate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStart"]intValue]];
                    NSLog(@"sdate millis: %@",sdate);
                    
                    srv.starttime=sdate;
                    NSDate * edate = [NSDate dateWithTimeIntervalSince1970:[[sr objectForKey:@"timeServiceStop"]intValue]];
                    NSLog(@"edate millis: %@",edate);
                    srv.endtime=edate;

                }
                srv._id = [NSString stringWithFormat:@"%@",sr[@"id"]];
                srv.address = [NSString stringWithFormat:@"%@",sr[@"address"]];
                srv.numeration = [NSString stringWithFormat:@"%@",sr[@"numeration"]];

                
                
                NSLog(@"service to add: %@",srv);
                
                MapGPoint *point = [[MapGPoint alloc]init]; // Create a new object
                
                point.lng = [NSString stringWithFormat:@"%@",sr[@"lng"]];
                point.lat = [NSString stringWithFormat:@"%@",sr[@"lat"]];
                point.type= TYPE_SERVICE;

                point.service = srv;

                
                [defaultRealm addObject:point];
                
                

                
            }
        }
        [defaultRealm commitWriteTransaction];
        
        [AppDel.hud hide:YES];
        [self getStandDataForEvent:[[NSUserDefaults standardUserDefaults] objectForKey:@"event_id"]];

        

        
    }else{
        NSLog(@"write error: %@",error.localizedDescription);
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"appDataOnce"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}
-(void)registerUser:(NSDictionary *)postData onView:(UIView*)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    hud.color = [UIColor clearColor];
    // Set the custom view mode to show any view.
    // Set an image view with a checkmark.
   // UIImage *image = [[UIImage imageNamed:@"loader"] imageWithRenderingMode:UIImageRenderingModeAutomatic];

    // Looks a bit nicer if we make it square.
    // Optional label text.
    //hud.label.text = NSLocalizedString(@"Done", @"HUD done title");
    
    NSLog(@"register user");
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;

   // NSDictionary *parametersDictionary = @{ @"name": @"n1amess", @"surname": @"da1sss", @"email": @"ass1sda@emil.com", @"password": @"fds1ssf",@"os":@"0"};
   // NSLog(@"params : %@",parametersDictionary);
   
  /*  NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersDictionary // Here you can pass array or dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);*/
    
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];//WithDictionary:postData];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"0" forKey:@"os"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:[postData objectForKey:@"email"] forKey:@"email"];
    [dataToPost setObject:[postData objectForKey:@"surname"] forKey:@"surname"];
    [dataToPost setObject:[postData objectForKey:@"name"] forKey:@"name"];
    [dataToPost setObject:[postData objectForKey:@"password"] forKey:@"password"];
    [dataToPost setObject:[postData objectForKey:@"loginType"] forKey:@"loginType"];

    
    NSLog(@"register userssss %@",dataToPost);

    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIUsersRegisterUrl parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
   // [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        if (error) {
            NSLog(@"Error: %@", error);
            if ([delegate respondsToSelector:@selector(registerUser:didFailWithError:)]) {
                [delegate registerUser:self didFailWithError:error];
            }
        } else {
            NSLog(@"%@ \nobj: %@", response, responseObject);

            if ([delegate respondsToSelector:@selector(registerUser:didFinishLoading:)]) {
                [delegate registerUser:self didFinishLoading:responseObject];
            }
        }
    }];
    
    [dataTask resume];
}


-(void)loginUser:(NSDictionary *)postData onView:(UIView*)view{
   __block MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [self animatedCustomImage];
        hud.customView.backgroundColor=[UIColor clearColor];
        hud.square=YES;
        hud.color = [UIColor clearColor];
    });
    
  
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;

      // NSDictionary *parametersDictionary = @{ @"name": @"", @"surname": @"", @"email": @"", @"password": @"",@"os":@"0"};
      //NSLog(@"params : %@",parametersDictionary);
    
    /*  NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersDictionary // Here you can pass array or dictionary
     options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
     error:&error];
     NSString *jsonString;
     if (jsonData) {
     jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //This is your JSON String
     //NSUTF8StringEncoding encodes special characters using an escaping scheme
     } else {
     NSLog(@"Got an error: %@", error);
     jsonString = @"";
     }
     NSLog(@"Your JSON String is %@", jsonString);*/
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]initWithDictionary:postData];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:@"0" forKey:@"os"];
    NSLog(@"login user %@",dataToPost);

    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIUsersLoginUrl parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
   // [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
        if (error) {
            NSLog(@"Error: %@", error);
            if ([delegate respondsToSelector:@selector(loginUser:didFailWithError:)]) {
                [delegate loginUser:self didFailWithError:error];
            }
        } else {
            NSLog(@"%@ \nobj: %@", response, responseObject);
            
            if ([delegate respondsToSelector:@selector(loginUser:didFinishLoading:)]) {
                [delegate loginUser:self didFinishLoading:responseObject];
            }
        }
    }];
    
    [dataTask resume];

}

-(void)updateToken:(NSString *)token forUser:(NSDictionary *)postData onView:(UIView*)view{
    NSLog(@"update token for user user");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;

    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;

    /*  NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersDictionary // Here you can pass array or dictionary
     options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
     error:&error];
     NSString *jsonString;
     if (jsonData) {
     jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //This is your JSON String
     //NSUTF8StringEncoding encodes special characters using an escaping scheme
     } else {
     NSLog(@"Got an error: %@", error);
     jsonString = @"";
     }
     NSLog(@"Your JSON String is %@", jsonString);*/
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]initWithDictionary:postData];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:@"0" forKey:@"os"];

    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIUsersLoginUrl parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    //[apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        if (error) {
            //NSLog(@"Error: %@", error);
            if ([delegate respondsToSelector:@selector(updateToken:didFailWithError:forToken:)]) {
                [delegate updateToken:self didFailWithError:error forToken:token];
            }
        } else {
            // NSLog(@"%@ \nobj: %@", response, responseObject);
            
            if ([delegate respondsToSelector:@selector(updateToken:didFinishLoading:forToken:)]) {
                [delegate updateToken:self didFinishLoading:responseObject forToken:token];
            }
        }
    }];
    
    [dataTask resume];
}

-(void)pasteLemonWayDataToServer:(NSDictionary *)cardData withData:(NSDictionary *)data onView:(UIView *)view{
    // Update URL with your server
    
    NSDictionary *dataToEncrypt = @{@"tickets":[data objectForKey:@"tickets"]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataToEncrypt // Here you can pass array or dictionary
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);
    
    
    
    NSError *error2;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:cardData // Here you can pass array or dictionary
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
    
    
    NSLog(@"pasteNonceToServerr");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    
    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    
      manager.securityPolicy.allowInvalidCertificates = YES;
    
    /*  NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersDictionary // Here you can pass array or dictionary
     options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
     error:&error];
     NSString *jsonString;
     if (jsonData) {
     jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //This is your JSON String
     //NSUTF8StringEncoding encodes special characters using an escaping scheme
     } else {
     NSLog(@"Got an error: %@", error);
     jsonString = @"";
     }
     NSLog(@"Your JSON String is %@", jsonString);*/
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    
    [dataToPost setObject:jsonString2 forKey:@"payment_responce"];
    
    [dataToPost setObject:@"0" forKey:@"os"];
    [dataToPost setObject:[data objectForKey:@"price_to_pay"] forKey:@"price_to_pay"];
    [dataToPost setObject:[data objectForKey:@"id_user"] forKey:@"id_user"];
    [dataToPost setObject:[data objectForKey:@"id_event"] forKey:@"id_event"];
    [dataToPost setObject:[data objectForKey:@"email"] forKey:@"email"];
    [dataToPost setObject:@"lemonway" forKey:@"payment_method"];

    [dataToPost setObject:[data objectForKey:@"participation_date"]  forKey:@"participation_date"];

    [dataToPost setObject:jsonString  forKey:@"tickets"]; // json get objectFrominput (@tickets) //TODO
    
    NSLog(@"datatopost : %@",dataToPost);
    
    
    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APILemonWayGetPaymentNonceURL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    // [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
        NSLog(@"response description: %@",response.description);
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            if ([delegate respondsToSelector:@selector(pasteNonceToServer:didFailWithError:)]) {
                [delegate pasteNonceToServer:self didFailWithError:error];
            }
        } else {
            // NSLog(@"%@ \nobj: %@", response, responseObject);
            
            if ([delegate respondsToSelector:@selector(pasteNonceToServer:didFinishLoading:)]) {
                [delegate pasteNonceToServer:self didFinishLoading:responseObject];
            }
        }
    }];
    
    [dataTask resume];
    
    
    
    
}
-(void)pasteNonceToServer:(NSDictionary *)nonce withData:(NSDictionary*)data onView:(UIView *)view{
    // Update URL with your server
 
    NSDictionary *dataToEncrypt = @{@"tickets":[data objectForKey:@"tickets"]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataToEncrypt // Here you can pass array or dictionary
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);


    
    NSError *error2;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:nonce // Here you can pass array or dictionary
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
    
    
    NSLog(@"pasteNonceToServerr");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;

    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    
   manager.securityPolicy.allowInvalidCertificates = YES;

    /*  NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersDictionary // Here you can pass array or dictionary
     options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
     error:&error];
     NSString *jsonString;
     if (jsonData) {
     jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //This is your JSON String
     //NSUTF8StringEncoding encodes special characters using an escaping scheme
     } else {
     NSLog(@"Got an error: %@", error);
     jsonString = @"";
     }
     NSLog(@"Your JSON String is %@", jsonString);*/
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:jsonString2 forKey:@"payment_responce"];
    [dataToPost setObject:@"0" forKey:@"os"];
    [dataToPost setObject:[data objectForKey:@"price_to_pay"] forKey:@"price_to_pay"];
    [dataToPost setObject:[data objectForKey:@"id_user"] forKey:@"id_user"];
    [dataToPost setObject:[data objectForKey:@"id_event"] forKey:@"id_event"];
    [dataToPost setObject:[data objectForKey:@"email"] forKey:@"email"];
    [dataToPost setObject:@"paypal" forKey:@"payment_method"];
    [dataToPost setObject:[data objectForKey:@"participation_date"]  forKey:@"participation_date"];

    
    [dataToPost setObject:jsonString  forKey:@"tickets"]; // json get objectFrominput (@tickets) //TODO

    NSLog(@"datatopost : %@",dataToPost);
    
    

    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIPayPalGetPaymentNonceURL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
   // [apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
        NSLog(@"response description: %@",response.debugDescription);
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            if ([delegate respondsToSelector:@selector(pasteNonceToServer:didFailWithError:)]) {
                [delegate pasteNonceToServer:self didFailWithError:error];
            }
        } else {
            // NSLog(@"%@ \nobj: %@", response, responseObject);
            
            if ([delegate respondsToSelector:@selector(pasteNonceToServer:didFinishLoading:)]) {
                [delegate pasteNonceToServer:self didFinishLoading:responseObject];
            }
        }
    }];
    
    [dataTask resume];
    
    
    

}
-(void)getPaymentTokenOnView:(UIView*)view{

    
    NSLog(@"getPaymentTokenOnView");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;

    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
   [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];    
   manager.securityPolicy.allowInvalidCertificates = YES;

    /*  NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersDictionary // Here you can pass array or dictionary
     options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
     error:&error];
     NSString *jsonString;
     if (jsonData) {
     jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //This is your JSON String
     //NSUTF8StringEncoding encodes special characters using an escaping scheme
     } else {
     NSLog(@"Got an error: %@", error);
     jsonString = @"";
     }
     NSLog(@"Your JSON String is %@", jsonString);*/
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:@"0" forKey:@"os"];

    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:APIGenerateTokenURL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",kAuthName, kAuthPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    //[apiRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        
        NSLog(@"token: %@ error: %@",responseObject,error.localizedDescription);
        if (error==NULL) {
            if ([delegate respondsToSelector:@selector(getPaymentToken:didFinishLoading:)]) {
                [delegate getPaymentToken:self didFinishLoading:responseObject];
            }
        }else{
            if ([delegate respondsToSelector:@selector(getPaymentToken:didFailWithError:)]) {
                [delegate getPaymentToken:self didFailWithError:error];
            }
        }
    }];
    
    [dataTask resume];

    
}






-(void)saveOrder:(NSDictionary *)data onView:(UIView *)view{
    
    NSLog(@"saveOred: %@",data);
    
   // [userData setObject:[userData objectForKey:@"price_to_pay"] forKey:@"priceToPay"];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    
    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
      NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(NSDictionary*)[data objectForKey:@"shippingData"] // Here you can pass array or dictionary
     options:0 // Pass 0 if you don't care about the readability of the generated string
     error:&error];
     NSString *jsonString;
     if (jsonData) {
     jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //This is your JSON String
     //NSUTF8StringEncoding encodes special characters using an escaping scheme
     } else {
     NSLog(@"Got an error: %@", error);
     jsonString = @"";
     }
     NSLog(@"Your JSON shipping is %@", jsonString);
    ///////////SHIPPING DATA////////////////////////
    
    
    
    NSError *errorf;
    NSData *jsonDataF = [NSJSONSerialization dataWithJSONObject:(NSDictionary*)[data objectForKey:@"factureData"] // Here you can pass array or dictionary
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
    
    
    ///////////////FACTUREDATA
    
    
    
    
    NSError *errorp;
    NSData *jsonDataP = [NSJSONSerialization dataWithJSONObject:(NSMutableArray*)[data objectForKey:@"itemsToBuy"] // Here you can pass array or dictionary
                                                        options:0 // Pass 0 if you don't care about the readability of the generated string
                                                          error:&errorp];
    NSString *jsonStringP;
    if (jsonDataP) {
        jsonStringP = [[NSString alloc] initWithData:jsonDataP encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", errorp);
        jsonStringP = @"";
    }
    NSLog(@"Your JSON products is %@", jsonStringP);
    
    
    ///////////////FACTUREDATA
    
    
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:@"0" forKey:@"os"];
    
    
    [dataToPost setObject:jsonStringP forKey:@"products"];
    [dataToPost setObject:jsonStringF forKey:@"invoiceData"];
    [dataToPost setObject:jsonString forKey:@"shippingData"];
    
    [dataToPost setObject:[data objectForKey:@"totalNumProducts"] forKey:@"totalNumProducts"];
    [dataToPost setObject:[data objectForKey:@"totNumQuantity"] forKey:@"totNumQuantity"];
    [dataToPost setObject:[data objectForKey:@"surname"] forKey:@"surname"];
    [dataToPost setObject:[data objectForKey:@"name"] forKey:@"name"];
    [dataToPost setObject:[data objectForKey:@"email"] forKey:@"email"];
    [dataToPost setObject:[data objectForKey:@"eventId"] forKey:@"eventId"];
    [dataToPost setObject:[data objectForKey:@"id_user"] forKey:@"userId"];
    [dataToPost setObject:[data objectForKey:@"paymentMethod"] forKey:@"paymentMethod"];
    [dataToPost setObject:[data objectForKey:@"paymentResponce"] forKey:@"paymentResponce"];
    [dataToPost setObject:[data objectForKey:@"price_to_pay"] forKey:@"priceToPay"];

    [dataToPost setObject:[data objectForKey:@"shippingAmount"] forKey:@"shippingAmount"];

    NSLog(@"save order with: %@",dataToPost);
    
    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:SAVEORDER_URL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        
        NSLog(@"token: %@ error: %@",responseObject,error.localizedDescription);
        if (error==NULL) {
            if ([delegate respondsToSelector:@selector(orderSaved:didFinishLoading:)]) {
                NSMutableDictionary *dataObj=[NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
                
                [delegate orderSaved:self didFinishLoading:dataObj];
            }
        }else{
            if ([delegate respondsToSelector:@selector(orderSaved:didFailWithError:)]) {
                [delegate orderSaved:self didFailWithError:error];
            }
        }
    }];
    
    [dataTask resume];

}


-(void)buyWineWithPayPal:(NSDictionary *)data onView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    
    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:@"0" forKey:@"os"];
    
    
    
    
    
    [dataToPost addEntriesFromDictionary:data];
    [dataToPost setObject:[data objectForKey:@"price_to_pay"] forKey:@"priceToPay"];

    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:BUY_WINE_URL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        
        NSLog(@"token: %@ error: %@",responseObject,error.localizedDescription);
        if (error==NULL) {
            if ([delegate respondsToSelector:@selector(buyWine:didFinishLoading:)]) {
                
                [delegate buyWine:self didFinishLoading:responseObject];
            }
        }else{
            if ([delegate respondsToSelector:@selector(buyWine:didFailWithError:)]) {
                [delegate buyWine:self didFailWithError:error];
            }
        }
    }];
    
    [dataTask resume];
}
-(void)buyWineWithLemonWay:(NSDictionary *)data onView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    
    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:@"0" forKey:@"os"];
    
    
    [dataToPost addEntriesFromDictionary:data];
    [dataToPost setObject:[data objectForKey:@"price_to_pay"] forKey:@"priceToPay"];

    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:BUY_WINE_URL parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        
        NSLog(@"token: %@ error: %@",responseObject,error.localizedDescription);
        if (error==NULL) {
            if ([delegate respondsToSelector:@selector(buyWine:didFinishLoading:)]) {
                
                [delegate buyWine:self didFinishLoading:responseObject];
            }
        }else{
            if ([delegate respondsToSelector:@selector(buyWine:didFailWithError:)]) {
                [delegate buyWine:self didFailWithError:error];
            }
        }
    }];
    
    [dataTask resume];
}


-(void)getOrderForUser:(NSDictionary *)data onView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self animatedCustomImage];
    hud.customView.backgroundColor=[UIColor clearColor];
    hud.square=YES;
    
    hud.color = [UIColor clearColor];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:kRequestSerializer forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSMutableDictionary * dataToPost = [[NSMutableDictionary alloc]init];
    [dataToPost setObject:@"hosteria_appUser" forKey:@"basicUser"];
    [dataToPost setObject:@"-5kew-pruthuzu?23q*z$?udru6uJeb4" forKey:@"basicPass"];
    [dataToPost setObject:@"0" forKey:@"os"];
    
    
    [dataToPost addEntriesFromDictionary:data];
    
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /*AFJSONRequestSerializer*/ serializer] multipartFormRequestWithMethod:@"POST" URLString:ORDER_LIST parameters:dataToPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES ];
        });
        
        NSLog(@"token: %@ error: %@",responseObject,error.localizedDescription);
        if (error==NULL) {
            if ([delegate respondsToSelector:@selector(getOrderForUser:didFinishLoading:)]) {
                
                [delegate getOrderForUser:self didFinishLoading:responseObject];
            }
        }else{
            if ([delegate respondsToSelector:@selector(getOrderForUser:didFailWithError:)]) {
                [delegate getOrderForUser:self didFailWithError:error];
            }
        }
    }];
    
    [dataTask resume];
}


/*-(void)makeUpload{
    //Creating an Upload Task for a Multi-Part Request, with Progress
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                         // [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
}
-(void)makeDownload{
    
    //Creating a Download Task
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}*/

/*-(void)makePost{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *URL =@"http://example.com/download.zip";
    NSDictionary *parametersDictionary = @{@"singleparameter": @"bar", @"array of items": @[@{@"itemkey1": @"itemvalue1",@"itemkey2":@"itemvalue2"}, @{@"itemkey3": @"itemvalue3",@"itemkey4":@"itemvalue4"}, @"singleitem"]};
    NSMutableURLRequest *apiRequest = [[AFHTTPRequestSerializer /AFJSONRequestSerializer/ serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:parametersDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      //TODO  [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:apiRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if ([delegate respondsToSelector:@selector(registerUser:didFailWithError:)]) {
                [delegate registerUser:self didFailWithError:error];
            }
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
            if ([delegate respondsToSelector:@selector(registerUser:didFinishLoading:)]) {
                [delegate registerUser:self didFinishLoading:responseObject];
            }
        }
    }];
    [dataTask resume];
    
    
 
}*/
@end
