//
//  TicketViewController.h
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TicketViewController : UIViewController <PayPalPaymentDelegate,UIPopoverControllerDelegate>
/*@property (nonatomic, strong) BTAPIClient *braintreeClient;*/
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property (weak, nonatomic) IBOutlet UIView *infoContainer;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
- (IBAction)skipButton:(id)sender;
@end
