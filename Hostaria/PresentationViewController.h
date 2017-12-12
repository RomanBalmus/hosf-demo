//
//  PresentationViewController.h
//  Hostaria
//
//  Created by iOS on 31/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentationViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


-(void)setAdditional;

@end
