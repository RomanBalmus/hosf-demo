//
//  FeedbackDetailItem.h
//  Hostaria
//
//  Created by iOS on 11/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackDetailItem : NSObject

@property (retain,nonatomic)NSString*detailId;
@property (retain,nonatomic)NSString *imgID;
@property (retain,nonatomic)NSString*name;
@property (retain,nonatomic)NSString*descr;
@property (retain,nonatomic)NSString*key;
@property (retain,nonatomic)NSString*value;

- (NSDictionary *)dictionaryValue;

@end
