//
//  CheckoutViewController.h
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController<PayPalPaymentDelegate,CardIOPaymentViewControllerDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
-(void)setProducts:(NSMutableArray*)products;
@end
