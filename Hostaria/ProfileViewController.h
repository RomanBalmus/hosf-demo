//
//  ProfileViewController.h
//  Hostaria
//
//  Created by iOS on 29/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProfileViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *initialsImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *menuContainer;
-(void)setupNavigation:(UINavigationController*)navctrl;

@end
