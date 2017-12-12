//
//  MyTicketViewController.h
//  Hostaria
//
//  Created by iOS on 12/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WampCom.h"
#import "WSCoachMarksView.h"

@interface MyTicketViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,WampComDelegate,WSCoachMarksViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
- (IBAction)segmentChangedTheValue:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *ticketView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *ticketType;
@property (weak, nonatomic) IBOutlet UILabel *countLeft;
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@property (weak, nonatomic) IBOutlet UIImageView *glassView;
@property (weak, nonatomic) IBOutlet UIButton *showMineBtn;

@property (weak, nonatomic) IBOutlet UIImageView *atvImageView;
@property (weak, nonatomic) IBOutlet UIButton *pref;
@property (weak, nonatomic) IBOutlet UIView *helpView;

@property (weak, nonatomic) IBOutlet UIButton *transferActionButton;
-(void)setTicketData:(NSDictionary*)ticketData;
- (IBAction)degustazioniBtn:(id)sender;
@end
