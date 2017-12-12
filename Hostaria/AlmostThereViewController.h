//
//  AlmostThereViewController.h
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlmostThereDelegate <NSObject>
@optional
- (void)goToNextWithUserData:(id)userInfo;

@end
@interface AlmostThereViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <AlmostThereDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *ticketTableView;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
-(void)setDataToWorkWith:(id)data;
@end
