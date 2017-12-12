//
//  TheFeedback.h
//  Hostaria
//
//  Created by iOS on 30/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "MyKV.h"

@interface TheFeedback : RLMObject
@property NSInteger  id_scan_history;
@property NSInteger  ticket_id;
@property RLMArray<MyKV *><MyKV> * kvs;
@property NSInteger saved;
@property NSInteger uploaded;
- (NSDictionary *)dictionaryValue;

@end

