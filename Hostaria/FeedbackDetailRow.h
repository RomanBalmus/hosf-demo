//
//  FeedbackDetailRow.h
//  Hostaria
//
//  Created by iOS on 11/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView/HCSStarRatingView.h"

@interface FeedbackDetailRow : UITableViewCell

@property (weak, nonatomic) IBOutlet HCSStarRatingView *theStarController;
@property (weak, nonatomic) IBOutlet UILabel *ttlLabel;

@end
