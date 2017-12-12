//
//  EventCell.h
//  Hostaria
//
//  Created by iOS on 31/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subttlLabel;

@property (weak, nonatomic) IBOutlet UIImageView *eventImgView;
@property (weak, nonatomic) IBOutlet UILabel *ttlLabel;
@end
