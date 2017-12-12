//
//  InviteToBuyMainViewController.h
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteToBuyMainViewController : UIViewController<PayPalPaymentDelegate,UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainContainer;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
-(void)skipProcess:(id)sender;

@end
