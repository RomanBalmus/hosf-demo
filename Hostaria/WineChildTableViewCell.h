//
//  WineChildTableViewCell.h
//  Hostaria
//
//  Created by iOS on 01/07/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WineChildTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToCartBtn;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@end
