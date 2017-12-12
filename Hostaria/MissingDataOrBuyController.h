//
//  MissingDataOrBuyController.h
//  Hostaria
//
//  Created by iOS on 24/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MissingDelegate <NSObject>
@optional
- (void)goToFromMissingNextWithUserData:(id)userInfo;
- (void)simpleRegisterCallUserData:(id)userInfo;
- (void)simpleRegisterCallUserData2:(id)userInfo;

@end
@interface MissingDataOrBuyController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <MissingDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *ticketTableView;
@property (nonatomic, strong)UIButton *ticket;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
-(void)setDataToWorkWith:(id)data;

-(void)setWelcome:(BOOL)action;
-(NSDictionary*)getTheDataToRegister;
@end
