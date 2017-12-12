//
//  DateCell.h
//  Hostaria
//
//  Created by iOS on 02/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLbl;
@property (weak, nonatomic) IBOutlet UILabel *monthLbl;
@property (weak, nonatomic) IBOutlet UILabel *yearLbl;

@end
