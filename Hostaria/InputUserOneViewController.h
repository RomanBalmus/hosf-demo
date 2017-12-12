//
//  InputUserOneViewController.h
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InputUserOneDelegate <NSObject>
@optional
- (void)loggedInWithUserInfo:(id)userInfo;

@end
@interface InputUserOneViewController : UIViewController
@property (nonatomic, weak) id <InputUserOneDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *gplusBtn;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *resetPswrdBtn;

@end
