//
//  CheckMarkCell.h
//  Hostaria
//
//  Created by iOS on 24/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckMarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *preiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *ticketCheckBtn;
@property (retain, nonatomic)  NSString *ticketType;
@property (retain, nonatomic)  NSString *finalPrice;

-(void)fillButton:(BOOL)value;

@end
