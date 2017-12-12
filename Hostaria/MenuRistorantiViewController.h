//
//  MenuRistorantiViewController.h
//  Hostaria
//
//  Created by iOS on 19/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuRistorantiViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
-(void)setupNavigation:(UINavigationController*)navctrl;

@end
