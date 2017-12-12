//
//  LoginParentViewController.h
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginParentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
-(void)checkDataAndLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
-(void)addReturnButton:(BOOL)add;
@end
