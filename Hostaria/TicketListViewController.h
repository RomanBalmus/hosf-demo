//
//  TicketListViewController.h
//  Hostaria
//
//  Created by iOS on 29/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketTableViewCell.h"
@protocol TicketListDelegate <NSObject>
@optional
-(void)nextSceneWithSummaryData:(NSMutableArray*)sumData andToken:(NSString*)tokect;


@end
@interface TicketListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TicketCellDelegate>{
    NSInteger ticketAmount;
}
@property (nonatomic, weak) id <TicketListDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *ticketTableView;
@property (weak, nonatomic) IBOutlet UIButton *nextScene;

@end
