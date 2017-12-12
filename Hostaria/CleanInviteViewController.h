//
//  CleanInviteViewController.h
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputUserOneViewController.h"
#import "MissingDataOrBuyController.h"
#import "CleanWelcomeViewController.h"
@interface CleanInviteViewController : UIViewController<UIPopoverControllerDelegate,InputUserOneDelegate,MissingDelegate,APIManagerDelegate,CleanWelcomeDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainContainer;
-(void)skipProcess:(id)sender;


@end
