//
//  SponsorPageViewController.h
//  Hostaria
//
//  Created by iOS on 03/05/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsorPageViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
- (IBAction)clickePager:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@end
