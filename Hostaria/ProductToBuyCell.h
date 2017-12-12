//
//  ProductToBuyCell.h
//  Hostaria
//
//  Created by iOS on 05/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductToBuyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productCompany;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@property (weak, nonatomic) IBOutlet UIImageView *productTypeIcon;
@end
