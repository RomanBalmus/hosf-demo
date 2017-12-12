//
//  FeedbackListViewController.h
//  Hostaria
//
//  Created by iOS on 10/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *feedbackTableView;

@end
