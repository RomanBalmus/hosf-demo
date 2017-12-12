//
//  ChooseTicketViewController.h
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketTableViewCell.h"
@protocol ChooseTicketDelegate <NSObject>
@optional
-(void)nextSceneWithSummaryData:(NSMutableArray*)sumData andToken:(NSString*)tokect andDTime:(NSString*)time;
-(void)dismisProcess;

@end
@interface ChooseTicketViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TicketCellDelegate>
{
    NSInteger ticketAmount;
}
@property (weak, nonatomic) IBOutlet UILabel *ttlLabel;
@property (nonatomic, weak) id <ChooseTicketDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *ticketTableView;
@property (nonatomic, strong)UIButton *ticket;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
-(void)clearDataToBuy;

-(void)updateTitle:(NSString*)ttl;
@end
