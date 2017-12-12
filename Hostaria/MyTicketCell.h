//
//  MyTicketCell.h
//  Hostaria
//
//  Created by iOS on 25/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTicketCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *atmIv;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoIv;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteIv;

@end
