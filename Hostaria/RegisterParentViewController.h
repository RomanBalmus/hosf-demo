//
//  RegisterParentViewController.h
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterParentViewController : UIViewController
-(void)addReturnButton:(BOOL)add;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
-(void)checkDataAndRegister:(id)sender;

@end
