//
//  TicketTableViewCell.m
//  Hostaria
//
//  Created by iOS on 15/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "TicketTableViewCell.h"

@implementation TicketTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSLog(@"awake ticket cell");
    ticketCount = 0;
   // [self.ticketCountBtn addTarget:self action:@selector(updateTicketCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.preiceLabel setText:self.finalPrice];
}
-(void)setCurrentTicketNumber:(NSInteger)nr{
    ticketCount=nr;
   
}
-(NSInteger)getCurrentTicketNumber{
    return ticketCount;
}
-(void)updateTicketCount:(id)sender{
    ticketCount ++;

    if (ticketCount<=10) {
        UIButton *btn = (UIButton*)sender;
        [btn setTitle:[NSString stringWithFormat:@"%ld",(long)ticketCount] forState:UIControlStateNormal];

    }else{

    }

    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    //self.myLabel.preferredMaxLayoutWidth = self.myLabel.frame.size.width;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
