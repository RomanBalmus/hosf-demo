//
//  APIManager.h
//  Hostaria
//
//  Created by iOS on 17/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class APIManager;
@protocol APIManagerDelegate <NSObject>
@optional

- (void)wampCfg:(APIManager*)manager didFinishLoading:(id)item;
- (void)wampCfg:(APIManager*)manager didFailWithError:(NSError *)error;

- (void)registerUser:(APIManager*)manager didFinishLoading:(id)item;
- (void)registerUser:(APIManager*)manager didFailWithError:(NSError *)error;
- (void)loginUser:(APIManager*)manager didFinishLoading:(id)item;
- (void)loginUser:(APIManager*)manager didFailWithError:(NSError *)error;
- (void)updateToken:(APIManager*)manager didFinishLoading:(id)item forToken:(NSString*)token;
- (void)updateToken:(APIManager*)manager didFailWithError:(NSError *)error forToken:(NSString*)token;
- (void)getPaymentToken:(APIManager*)manager didFinishLoading:(id)item;
- (void)getPaymentToken:(APIManager*)manager didFailWithError:(NSError *)error;
- (void)pasteNonceToServer:(APIManager*)manager didFinishLoading:(id)item;
- (void)pasteNonceToServer:(APIManager*)manager didFailWithError:(NSError *)error;

- (void)gotData:(APIManager*)manager didFinishLoading:(id)item;
- (void)gotData:(APIManager*)manager didFailWithError:(NSError *)error;

- (void)pasteLemonWayDataToServer:(APIManager*)manager didFinishLoading:(id)item;
- (void)pasteLemonWayDataToServer:(APIManager*)manager didFailWithError:(NSError *)error;

- (void)resetPassword:(APIManager*)manager didFinishLoading:(id)item;
- (void)resetPassword:(APIManager*)manager didFailWithError:(NSError *)error;

- (void)orderSaved:(APIManager*)manager didFinishLoading:(id)item;
- (void)orderSaved:(APIManager*)manager didFailWithError:(NSError *)error;


- (void)buyWine:(APIManager*)manager didFinishLoading:(id)item;
- (void)buyWine:(APIManager*)manager didFailWithError:(NSError *)error;


- (void)getOrderForUser:(APIManager*)manager didFinishLoading:(id)item;
- (void)getOrderForUser:(APIManager*)manager didFailWithError:(NSError *)error;

@end
@interface APIManager : NSObject
@property (nonatomic, weak) id <APIManagerDelegate> delegate;
+ (instancetype)sharedInstance;
-(void)registerUser:(NSDictionary*)postData onView:(UIView*)view;
-(void)loginUser:(NSDictionary*)postData onView:(UIView*)view;
-(void)updateToken:(NSString*)token forUser:(NSDictionary*)postData onView:(UIView*)view;
- (void)getPaymentTokenOnView:(UIView*)view;
- (void)pasteNonceToServer:(NSDictionary*)nonce withData:(NSDictionary*)data onView:(UIView*)view;
- (void)pasteLemonWayDataToServer:(NSDictionary*)cardData withData:(NSDictionary*)data onView:(UIView*)view;

-(void)resetPassword:(NSString*)email onView:(UIView*)view;

- (void)getAppData;

- (void)getCellarData;
- (void)getMapData;
- (void)getWampConfiguration;
-(void)saveOrder:(NSDictionary*)data onView:(UIView*)view;


-(void)buyWineWithLemonWay:(NSDictionary*)data onView:(UIView*)view;
-(void)buyWineWithPayPal:(NSDictionary*)data onView:(UIView*)view;
-(void)getOrderForUser:(NSDictionary *)data onView:(UIView *)view;


@end
