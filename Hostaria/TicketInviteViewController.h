//
//  TicketInviteViewController.h
//  Hostaria
//
//  Created by iOS on 08/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TicketInviteDelegate <NSObject>
@optional
- (void)clickedBuy:(id)sender;

@end
@interface TicketInviteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ticketInviteBuyBtn;
@property (nonatomic, weak) id <TicketInviteDelegate> delegate;

@end
