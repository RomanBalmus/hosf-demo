//
//  InputSceneThreeViewController.h
//  Hostaria
//
//  Created by iOS on 09/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InputSceneThreeDelegate <NSObject>
@optional
- (void)loggedInWithUserInfo:(id)userInfo;

@end
@interface InputSceneThreeViewController : UIViewController
@property (nonatomic, weak) id <InputSceneThreeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginBtn;
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *twLoginBtn;
@end
