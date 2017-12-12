//
//  CartCell.h
//  Hostaria
//
//  Created by iOS on 05/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cartItemLabelProduct;
@property (weak, nonatomic) IBOutlet UILabel *cartItemLabelCompany;
@property (weak, nonatomic) IBOutlet UILabel *cartItemLabelPrice;

@property (weak, nonatomic) IBOutlet UIButton *quantityButton;
@property (weak, nonatomic) IBOutlet UIImageView *cartItemImage;
@end
