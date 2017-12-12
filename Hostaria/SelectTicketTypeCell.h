//
//  SelectTicketTypeCell.h
//  Hostaria
//
//  Created by iOS on 24/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTicketTypeCell : UITableViewCell
@property (strong, nonatomic) UIStackView *stackView;
-(void)setStackViewArray:(NSArray*)views;
-(void)changeCellStatus:(BOOL)status;

@end
