//
//  FeedbackViewController.h
//  Hostaria
//
//  Created by iOS on 10/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *feedbackTableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UILabel *cellarNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *cellarAddrLbl;
@property (weak, nonatomic) IBOutlet UILabel *standNrLbl;
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;

@property (weak, nonatomic) IBOutlet UIImageView *wineTypeIv;
-(void)setFeedBackDataToWorkWith:(NSDictionary*)data;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addToCartBtn;
@property (weak, nonatomic) IBOutlet UIView *wineContainerView;
@property (weak, nonatomic) IBOutlet UIButton *condividiBtn;

@end
