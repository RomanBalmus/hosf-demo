//
//  BottomSheetView.h
//  Hostaria
//
//  Created by iOS on 30/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BottomSheetView : UIView
@property (weak, nonatomic) IBOutlet UIButton *directionBtn;

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet NSString *latitude;
@property (weak, nonatomic) IBOutlet NSString *longitude;


+ (id)customView;
-(void)updateFrame;
-(void)updateContainerFrame;

- (IBAction)directionButtonClick:(id)sender;
@end
