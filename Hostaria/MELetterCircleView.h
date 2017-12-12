//
//  MELetterCircleView.h
//  Hostaria
//
//  Created by iOS on 25/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MELetterCircleView : UIView
@property (nonatomic, strong) NSString *text;

-(void)setInitials:(NSString *)initials bgColor:(UIColor*)colorcircle;

@end
