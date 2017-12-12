//
//  UserProfilePageViewController.h
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MELetterCircleView.h"
@interface UserProfilePageViewController : UIViewController{
    
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;

@property (retain, nonatomic)  UIImageView *blurredHeaderImageView;



@property (weak, nonatomic) IBOutlet UITableView *theTable;
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UIImageView *growimageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet MELetterCircleView *meletterView;


@end
