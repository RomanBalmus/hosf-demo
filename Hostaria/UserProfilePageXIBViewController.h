//
//  UserProfilePageXIBViewController.h
//  Hostaria
//
//  Created by iOS on 26/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M6UniversalParallaxViewController.h"
#import "MELetterCircleView.h"
#import "M6TouchForwardView.h"
#import "ActionViewController.h"

@interface UserProfilePageXIBViewController : M6UniversalParallaxViewController<UITableViewDelegate,UITableViewDataSource,ActionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *growImageView;
@property (weak, nonatomic) IBOutlet MELetterCircleView *letterCircle;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

-(void)setupNavigation:(UINavigationController*)navctrl;

@end
