//
//  ChildTableViewCell.h
//  Hostaria
//
//  Created by iOS on 29/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *numerationLbl;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@end
