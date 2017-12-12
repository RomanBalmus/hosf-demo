//
//  SelectTicketTypeCell.m
//  Hostaria
//
//  Created by iOS on 24/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "SelectTicketTypeCell.h"

@implementation SelectTicketTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)setStackViewArray:(NSArray*)viewcs{
    if (self.stackView!=NULL) {
        return;
    }
    self.stackView = [[UIStackView alloc]initWithArrangedSubviews:viewcs];
    [self.stackView setFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,  self.contentView.frame.size.height)];
    self.stackView.axis=UILayoutConstraintAxisVertical;
    self.stackView.distribution=UIStackViewDistributionFillEqually;
    for (UIView*view in self.stackView.arrangedSubviews) {
        view.hidden=YES;
    }
    self.stackView.arrangedSubviews.firstObject.hidden =
    NO;
    self.stackView.translatesAutoresizingMaskIntoConstraints=NO;
    [self layoutIfNeeded];
    [self.contentView addSubview:self.stackView];
    NSDictionary *viewsDictionary=@{@"stackView":self.stackView};
    NSArray *stackView_H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[stackView]-10-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *stackView_V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[stackView]-15-|" options:0 metrics:nil views:viewsDictionary];

    [self.contentView addConstraints:stackView_H ];
    [self.contentView addConstraints:stackView_V ];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)changeCellStatus:(BOOL)status{
    [self setNeedsLayout];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        for (UIView*view in self.stackView.arrangedSubviews) {
            view.hidden=!status;
        }
    } completion:^(BOOL finished) {
        [self layoutIfNeeded];
        
    }];
}

@end
