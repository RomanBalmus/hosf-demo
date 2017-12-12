//
//  DatetimeViewController.h
//  Hostaria
//
//  Created by iOS on 02/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
@protocol DatetimeDelegate <NSObject>
@optional
- (void)dismissWithNoSelection;
- (void)selectedTheDate:(NSString*)datetime;

@end
@interface DatetimeViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) id <DatetimeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

@end
