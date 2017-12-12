//
//  FacturableViewController.h
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FactureDelegate <NSObject>
@optional
- (void)factureData:(id)userInfo;
- (void)bothData:(id)userInfo;

@end
@interface FacturableViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)nextButtonCliked:(id)sender;
- (IBAction)mySwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
-(void)setUserData:(NSMutableDictionary*)dictionary;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;

@property (nonatomic, weak) id <FactureDelegate> delegate;
-(void)setParent:(UIViewController*)controller;


@end
