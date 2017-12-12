//
//  SponsorOneViewController.h
//  Hostaria
//
//  Created by iOS on 29/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsorOneViewController : UIViewController
-(void)setUserData:(NSDictionary*)info;

@property (weak, nonatomic) IBOutlet UITableView *sponsorTable;
@end
