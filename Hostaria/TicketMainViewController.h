//
//  TicketMainViewController.h
//  Hostaria
//
//  Created by iOS on 04/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TicketMainDelegate <NSObject>
@optional
- (void)buyClick:(id)sender;
- (void)loginClick:(id)sender;

@end
@interface TicketMainViewController : UIViewController
@property (nonatomic, weak) id <TicketMainDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *inviteContainer;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
