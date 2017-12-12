//
//  FeedbackRow.h
//  Hostaria
//
//  Created by iOS on 11/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackRow : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellarName;
@property (weak, nonatomic) IBOutlet UILabel *cellarAddress;
@property (weak, nonatomic) IBOutlet UILabel *cellarNumeration;

@property (weak, nonatomic) IBOutlet UIImageView *wineType;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@end
