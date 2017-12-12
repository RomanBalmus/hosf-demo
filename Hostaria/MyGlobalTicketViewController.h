//
//  MyGlobalTicketViewController.h
//  Hostaria
//
//  Created by iOS on 30/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WampCom.h"
#import "WSCoachMarksView.h"

@interface MyGlobalTicketViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,WampComDelegate,WSCoachMarksViewDelegate>
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
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@property (weak, nonatomic) IBOutlet UIImageView *atvTicketImageView;
@property (weak, nonatomic) IBOutlet UIButton *transferActionButton;
@property (weak, nonatomic) IBOutlet UIView *helpView;

-(void)setTicketData:(NSDictionary*)ticketData;
- (IBAction)degustazioniBtn:(id)sender;


-(void)setNaviGation:(UINavigationController*)nav;
@end
