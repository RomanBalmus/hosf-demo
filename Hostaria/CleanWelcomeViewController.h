//
//  CleanWelcomeViewController.h
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CleanWelcomeDelegate <NSObject>
@optional
- (void)cleanWelcomeGoToRegister;
- (void)cleanWelcomeGoToLogin;
- (void)cleanWelcomeGoToSkip;

@end
@interface CleanWelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (nonatomic, weak) id <CleanWelcomeDelegate> delegate;


@end
