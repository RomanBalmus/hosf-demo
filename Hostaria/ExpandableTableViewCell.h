//
//  ExpandableTableViewCell.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ExpandableTableViewCell : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *container;

@end
