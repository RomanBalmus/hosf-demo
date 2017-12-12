//
//  ActionViewController.h
//  Hostaria
//
//  Created by iOS on 09/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActionViewDelegate <NSObject>
@optional
- (void)clickedReceive:(id)sender;
- (void)clickedCouple:(id)sender;

@end
@interface ActionViewController : UIViewController
@property (nonatomic, weak) id <ActionViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *receiveTextLabel;
@property (weak, nonatomic) IBOutlet UIView *receiveContainer;

@property (weak, nonatomic) IBOutlet UIView *coupleContainer;
@property (weak, nonatomic) IBOutlet UILabel *coupleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *coupleBtn;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
- (IBAction)receiveClicked:(id)sender;
- (IBAction)coupleClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;
@end
