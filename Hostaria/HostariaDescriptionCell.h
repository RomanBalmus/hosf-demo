//
//  HostariaDescriptionCell.h
//  Hostaria
//
//  Created by iOS on 10/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HostariaDescriptionCell;
@protocol HostariaCellDelegate <NSObject>
@optional
- (void)changedStatus:(BOOL)value atIndexPath:(HostariaDescriptionCell*)cell;

@end
@interface HostariaDescriptionCell : UITableViewCell<UIWebViewDelegate>{
}
@property (nonatomic, weak) id <HostariaCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UIView *topView;

-(void)changeCellStatus:(BOOL)status;
@end
