//
//  WelcomeViewController.h
//  Hostaria
//
//  Created by iOS on 01/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WelcomeDelegate <NSObject>
@optional
- (void)welcomeGoToRegister;
- (void)welcomeGoToLogin;
- (void)welcomeGoToSkip;

@end
@interface WelcomeViewController : UIViewController
@property (nonatomic, weak) id <WelcomeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end
