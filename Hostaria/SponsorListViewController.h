//
//  SponsorListViewController.h
//  Hostaria
//
//  Created by iOS on 31/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsorListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
