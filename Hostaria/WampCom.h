//
//  WampCom.h
//  Hostaria
//
//  Created by iOS on 11/07/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
@class WampCom;
@protocol WampComDelegate <NSObject>
@optional

- (void)wampRequestRPC:(WampCom*)manager didFinishLoading:(id)item;
- (void)gotErrorRPC:(WampCom*)manager didFailWithError:(NSError *)error;

- (void)wampRPCResponceSuccess:(WampCom*)manager withData:(id)item andType:(NSString*)type;

- (void)wampRPCResponceError:(WampCom*)manager withData:(id)item andType:(NSString*)type;



- (void)wampTOPICResponceError:(WampCom*)manager withData:(id)item;
- (void)wampTOPICResponceSuccess:(WampCom*)manager withData:(id)item;


@end

@interface WampCom : NSObject<MDWampClientDelegate,APIManagerDelegate>{
    MDWamp *wampConnection;
    NSString *ownerTopic;
    
}
@property (strong, nonatomic) MDWamp *wampConnection;
@property (strong, nonatomic) NSTimer *pinpongTimer;

@property (nonatomic, weak) id <WampComDelegate> delegate;
@property (strong, nonatomic) NSTimer *reconnectTimer;
@property (nonatomic) BOOL byHand;
@property (strong, nonatomic) NSString *theTopic;


+ (instancetype)sharedInstance;
-(void)startReconnect;
-(void)closeWamp;
-(void)openWamp;
-(void)callCouple:(NSDictionary*)dict;
-(void)callTransfer:(NSDictionary*)dict;
-(void)subScribeToOwner:(NSString*)topic;
-(void)UnSubscribeFromOwner;
-(void)setOwnerTopicNull;

@end
