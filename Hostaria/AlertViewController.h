//
//  AlertViewController.h
//  Hostaria
//
//  Created by iOS on 15/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlertViewDelegate <NSObject>
@optional
- (void)dismissSelfFromParent;
- (void)decrementBy:(NSInteger)value indexPath:(NSIndexPath*)index;
- (void)incrementBy:(NSInteger)value indexPath:(NSIndexPath*)index;


@end
@interface AlertViewController : UIViewController
{
    NSIndexPath *cellPath;
}
@property (nonatomic, weak) id <AlertViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *ticketName;
- (IBAction)incrementTicket:(id)sender;
- (IBAction)decrementTicket:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *incrBtn;
@property (weak, nonatomic) IBOutlet UIButton *decrBtn;

@property (weak, nonatomic) IBOutlet UIButton *ticketCount;
@property (weak, nonatomic) IBOutlet UILabel *ticketDescription;
-(void)setTicketName:(NSString*)ticketName ticketDescription:(NSString*)description andCount:(NSInteger)count indexPath:(NSIndexPath*)index limit:(NSInteger)limit;
- (IBAction)goNext:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
