//
//  FeedbackCategory.h
//  Hostaria
//
//  Created by iOS on 10/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackCategory : NSObject


@property (retain,nonatomic)NSString*name;
@property (retain,nonatomic)NSString*descr;
@property (retain,nonatomic)NSString*catid;

@property (retain,nonatomic)NSArray*detailList;
- (NSDictionary *)dictionaryValue;

@end
