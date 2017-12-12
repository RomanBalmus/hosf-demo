//
//  CartViewController.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,APIManagerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (weak, nonatomic) IBOutlet UILabel *ttlLbl;
//@property (weak, nonatomic) IBOutlet UIPickerView *thePickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;
- (IBAction)clickedDoneButton:(id)sender;

-(void)LoadIt;

@end
