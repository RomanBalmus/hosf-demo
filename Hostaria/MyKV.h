//
//  MyKV.h
//  Hostaria
//
//  Created by iOS on 30/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyKV : RLMObject

@property NSString * keyname;
@property NSString * valuenumber;
@property NSString * keynumber;
@property NSString * valuename;

@end
RLM_ARRAY_TYPE(MyKV)
