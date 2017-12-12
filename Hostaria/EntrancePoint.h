//
//  EntrancePoint.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Realm/Realm.h>

@interface EntrancePoint : RLMObject
@property NSString * _id;
@property NSString * lat;
@property NSString * lng;
@property NSString * type;
@property NSString * number;
@property NSString * address;

@property NSString * name;
@property NSString * _description;
@end
