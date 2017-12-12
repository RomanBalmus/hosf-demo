//
//  ShippingViewController.h
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
@protocol ShippDelegate <NSObject>
@optional
- (void)shippData:(id)userInfo;
- (void)updateTitle:(Country*)userInfo;

@end
@interface ShippingViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
-(void)setUserData:(NSMutableDictionary*)dictionary;
@property (nonatomic, weak) id <ShippDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
- (IBAction)nextButtonCliked:(id)sender;
- (IBAction)mySwitchChanged:(id)sender;
-(void)setFactureData:(NSMutableDictionary*)dictionary;

@end
