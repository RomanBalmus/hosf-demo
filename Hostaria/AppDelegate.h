//
//  AppDelegate.h
//  Hostaria
//
//  Created by iOS on 13/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic, strong) PKPushRegistry* voipRegistry;
@property (nonatomic, strong) MBProgressHUD *hud;
-(void)huddie;
-(NSString*)getDocPath;
@end

