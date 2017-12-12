//
//  TicketTableViewCell.h
//  Hostaria
//
//  Created by iOS on 15/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//
@class TicketTableViewCell;
#import <UIKit/UIKit.h>
@protocol TicketCellDelegate <NSObject>
@optional
- (void)incrementBy:(NSInteger)value type:(NSString*)type atIndexPath:(TicketTableViewCell*)cell;
- (void)decrementBy:(NSInteger)value type:(NSString*)type atIndexPath:(TicketTableViewCell*)cell;

@end
@interface TicketTableViewCell : UITableViewCell{
     NSInteger ticketCount;
}
@property (nonatomic, weak) id <TicketCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *preiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *ticketCountBtn;
@property (retain, nonatomic)  NSString *ticketType;
@property (retain, nonatomic)  NSString *finalPrice;

-(void)setCurrentTicketNumber:(NSInteger)nr;
-(NSInteger)getCurrentTicketNumber;
@end
