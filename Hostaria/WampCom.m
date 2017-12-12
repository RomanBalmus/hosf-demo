//
//  WampCom.m
//  Hostaria
//
//  Created by iOS on 11/07/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "WampCom.h"
#import "Topic.h"
#import "RPC.h"

@implementation WampCom
@synthesize wampConnection;

+ (instancetype)sharedInstance
{
    static WampCom *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WampCom alloc] init];
        
        // Do any other initialisation stuff here
        
    });
    return sharedInstance;
}

- (void) mdwamp:(MDWamp *)wamp closedSession:(NSInteger)code reason:(NSString*)reason details:(NSDictionary *)details {
    NSLog(@"Closed session with reason: %@ and details: %@",reason,details);
    // [self logOutInspector];
    /*if (self.pinpongTimer != NULL) {
        [self.pinpongTimer invalidate];
        [self setPinpongTimer:nil];
    }*/
    if (!self.byHand) {
        [self startReconnect];
        
    }
    
}


-(void)startReconnect{
    NSLog(@"reconnect");
    NSLog(@"CONNECT IT FUCK");

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.reconnectTimer==NULL) {
            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                                 target:self
                                                               selector:@selector(doInvokerForDoStartMessageRefreshReconnect:)
                                                               userInfo:nil
                                                                repeats:YES];
        }
        
        
    });
}
-(void)setOwnerTopicNull{
    ownerTopic=NULL;
}


-(void)closeWamp{
    self.byHand=YES;
    
    
    [self.wampConnection disconnect];
    [self.pinpongTimer invalidate];
    [self setPinpongTimer:nil];
    [self.reconnectTimer invalidate];
    [self setReconnectTimer:nil];
}



- (void) doInvokerForDoStartMessageRefreshReconnect:(NSTimer *) theTimer
{
    //NSLog(@"%s", __FUNCTION__);
    //NSLog(@"%@", [self.pinpongTimer fireDate]);
    //NSLog(@"%@", [theTimer fireDate]);
    __block BOOL done = NO;
    
    
    
  done=  [self.wampConnection isConnected];
    
   
    
    if (!done ){
        
        
        [self openWamp];
    }
}

- (void) doInvokerForDoStartMessageRefresh:(NSTimer *) theTimer
{
    //NSLog(@"%s", __FUNCTION__);
    //NSLog(@"%@", [self.pinpongTimer fireDate]);
    //NSLog(@"%@", [theTimer fireDate]);
    
    
    
    if (![self.wampConnection isConnected]) {
        return;
    }
    
    __block BOOL done = NO;
    
    [[self wampConnection] call:[[NSUserDefaults standardUserDefaults]objectForKey:@"pingpongrpc"] args:nil kwArgs:nil options:nil complete:^(MDWampResult *result, NSError *error){
        NSLog(@"call inside");
        if (error== nil) {
            NSLog(@"Insp args: %@",result.arguments);
            done = YES;
        }else{
            NSLog(@"no pong");
        }
    }];
    
    NSLog(@"call outside");
    if (!done ){
        
        
        [self openWamp];
    }
}
- (void) mdwamp:(MDWamp*)wamp sessionEstablished:(NSDictionary*)info {
    /* NSLog(@"Session connected server details: %@", [NSString stringWithFormat:@"\n"\
     @"authid:\t %@\n"\
     @"authmethod:\t %@\n"\
     @"authrole:\t %@\n"\
     @"roles:\t %@\n", info[@"authid"], info[@"authmethod"], info[@"authrole"], [[info[@"roles"] allKeys] componentsJoinedByString:@", "]]);*/
    NSLog(@"server wamp connected: %@",info);

    
    [self getRPCList];
    //DEMO
    [self doStartMessageRefresh];

    
    
    if (ownerTopic!=NULL) {
        [self subScribeToOwner:ownerTopic];
    }
    
}
-(void)openWamp{
    if (![self.wampConnection isConnected]) {
        
        
        API.delegate=self;
        [API getWampConfiguration];
        
        
        
        
    }
    
    
}



-(void)wampCfg:(APIManager *)manager didFailWithError:(NSError *)error{
    
}
-(void)wampCfg:(APIManager *)manager didFinishLoading:(id)item{
    
    if ([self.wampConnection isConnected]) {
        
        
        [self getRPCList];
        return;
    }
    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    
    // Begin a write transaction to save to the default Realm
    [defaultRealm beginWriteTransaction];
    
    NSDictionary*result=(NSDictionary*)item;
    
    
    NSDictionary*topics = (NSDictionary*)[[result objectForKey:@"wampConfiguration"]objectForKey:@"topics"];
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];

    [topics enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        
        
        Topic *tpd = [[Topic alloc]init];
        tpd.type=key;
        tpd.name=object;
        
        [defaultRealm addObject:tpd];
    }];
    
    [defaultRealm commitWriteTransaction];
    
    NSString * wampurl = [NSString stringWithFormat:@"ws://%@:%@",[[result objectForKey:@"wampConfiguration"] objectForKey:@"ip"],[[result objectForKey:@"wampConfiguration"] objectForKey:@"port"] ];
    [def setObject:[[result objectForKey:@"wampConfiguration"] objectForKey:@"realm"] forKey:@"wamprealm"];
    [def setObject:wampurl forKey:@"wampurl"];
    [def setObject:[[result objectForKey:@"wampConfiguration"]objectForKey:@"generalRpc"] forKey:@"generalrpc"];
    [def synchronize];
    
    MDWampTransportWebSocket *transport = [[MDWampTransportWebSocket alloc] initWithServer:[NSURL URLWithString:[def objectForKey:@"wampurl"]] protocolVersions:@[kMDWampProtocolWamp2json,kMDWampProtocolWamp2msgpack]];
    
    // Test Raw socketws://79.60.190.92:9099"
    //  MDWampTransportRawSocket *transport = [[MDWampTransportRawSocket alloc] initWithHost:@"79.60.190.92" port:9099];
    //  [transport setSerialization:kMDWampSerializationJSON];
    //
    MDWamp *ws = [[MDWamp alloc] initWithTransport:transport realm:[def objectForKey:@"wamprealm"] delegate:self];
    /* NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"utenete4", @"rewtg"];
     NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
     NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedDataWithOptions:0]];
     [ws setValue:authValue forKey:@"Authorization"];
     [AppDel setWampConnection:ws];*/
    [self setWampConnection:ws];
    
    [ws connect];

}


-(void)getRPCList{
    
    
  
    
    NSLog(@"get rpc list %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"generalrpc"]);
    if (![self.wampConnection isConnected]) {
        return;
    }
    [self.wampConnection call:[[NSUserDefaults standardUserDefaults]objectForKey:@"generalrpc"] payload:@[] complete:^(MDWampResult *result, NSError *error) {
        NSLog(@"result:%@",result.arguments);
        [self saveDataToReal:result.arguments];
        
    }];
    
}

-(void)callCouple:(NSDictionary *)dict{
    NSLog(@"call couple %@",dict);
    if (![self.wampConnection isConnected]) {
        return;
    }
    [self.wampConnection call:[dict objectForKey:@"rpcname"] payload:@[dict] complete:^(MDWampResult *result, NSError *error) {
        NSLog(@"result couple :%@",result.arguments);
        for (NSDictionary *arg in result.arguments) {
            
            if ([[arg objectForKey:@"status"]isEqualToString:@"error"]) {
                if ([self.delegate respondsToSelector:@selector(wampRPCResponceError:withData:andType:)]) {
                    [self.delegate wampRPCResponceError:self withData:arg andType:RPC_COUPLE];
                }
            }
            if ([[arg objectForKey:@"status"]isEqualToString:@"success"]) {
                if ([self.delegate respondsToSelector:@selector(wampRPCResponceSuccess:withData:andType:)]) {
                    [self.delegate wampRPCResponceSuccess:self withData:arg andType:RPC_COUPLE];
                }
            }
            
        }
    }];
}

-(void)subScribeToOwner:(NSString *)topic{
    
    
    ownerTopic=topic;
    if (![self.wampConnection isConnected]) {
        return;
    }
    [self.wampConnection subscribe:ownerTopic onEvent:^(MDWampEvent *payload) {
        NSLog(@"sub rps:%@",payload.arguments);
        
        NSMutableArray * data = [payload.arguments objectAtIndex:0];
            if ([self.delegate respondsToSelector:@selector(wampTOPICResponceSuccess:withData:)]) {
                [self.delegate wampTOPICResponceSuccess:self withData:[data objectAtIndex:0]];
            }
        
        
       /* if ([self.delegate respondsToSelector:@selector(wampTOPICResponceSuccess:withData:)]) {
            [self.delegate wampTOPICResponceSuccess:self withData:arg];
        }*/
        
    } result:^(NSError *error) {
        
        if (error) {
            NSLog(@"sub err:%@",error.description);

            if ([self.delegate respondsToSelector:@selector(wampTOPICResponceError:withData:)]) {
                [self.delegate wampTOPICResponceError:self withData:error];
            }
            
        } else {
            NSLog(@"Connectd to %@",topic);
            //[[DataBase getSharedInstance:@"data"]updateTopic:[[topics objectAtIndex:i ] objectForKey:@"topic"] subscribed:@"yes"];
            
        }
        
       
    }];
}

-(void)UnSubscribeFromOwner{
    
    
    if (ownerTopic==NULL || ownerTopic.length==0) {
        
        return;
    }
    if (![self.wampConnection isConnected]) {
        return;
    }
    [self.wampConnection unsubscribe:ownerTopic result:^(NSError *error) {
        if (error) {
            NSLog(@"sub err:%@",error.description);
            
            if ([self.delegate respondsToSelector:@selector(wampTOPICResponceError:withData:)]) {
                [self.delegate wampTOPICResponceError:self withData:error];
            }
            
        } else {
            NSLog(@"unsub from %@",ownerTopic);
            //[[DataBase getSharedInstance:@"data"]updateTopic:[[topics objectAtIndex:i ] objectForKey:@"topic"] subscribed:@"yes"];
            
        }
        
    }];
    
   
}



-(void)callTransfer:(NSDictionary *)dict{
    NSLog(@"call transfer %@",dict);
    if (![self.wampConnection isConnected]) {
        return;
    }
    [self.wampConnection call:[dict objectForKey:@"rpcname"] payload:@[dict] complete:^(MDWampResult *result, NSError *error) {
        NSLog(@"result transfer :%@",result.arguments);
        for (NSDictionary *arg in result.arguments) {
            
            
            if ([[arg objectForKey:@"status"]isEqualToString:@"error"]) {
                if ([self.delegate respondsToSelector:@selector(wampRPCResponceError:withData:andType:)]) {
                    [self.delegate wampRPCResponceError:self withData:arg andType:RPC_TRANSFER];
                }
            }
            if ([[arg objectForKey:@"status"]isEqualToString:@"success"]) {
                if ([self.delegate respondsToSelector:@selector(wampRPCResponceSuccess:withData:andType:)]) {
                    [self.delegate wampRPCResponceSuccess:self withData:arg andType:RPC_TRANSFER];
                }
            }
           
        }
    }];
}


-(void)saveDataToReal:(NSArray*)args
{
    
    
    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    
    // Begin a write transaction to save to the default Realm
    [defaultRealm beginWriteTransaction];
    for (NSDictionary*dict in args) {
        
      
        
       RPC *rpc = [[RPC alloc]init]; // Create a new object
        rpc.type_id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"type_request"]];
        rpc.name=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        rpc.type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"type_request"]];
        
        
        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type_request"]]  isEqualToString:RPC_PINGPONG]) {
            [[NSUserDefaults standardUserDefaults]setObject:rpc.name forKey:@"pingpongrpc"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        
        [defaultRealm addObject:rpc];
        
    }
    
    [defaultRealm commitWriteTransaction];

}

- (void) doStartMessageRefresh {
    // NSLog(@"%s", __FUNCTION__);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.pinpongTimer==NULL) {
            self.pinpongTimer = [NSTimer scheduledTimerWithTimeInterval:59.f
                                                                 target:self
                                                               selector:@selector(doInvokerForDoStartMessageRefresh:)
                                                               userInfo:nil
                                                                repeats:YES];
        }
        
        
    });
}

@end
