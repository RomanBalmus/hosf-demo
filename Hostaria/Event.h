//
//  Event.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Realm/Realm.h>

@interface Event : RLMObject
@property NSString * _id;
@property NSString * name;

@property NSString * address;
@property BOOL allowed;
@property NSString * notificationid;

@end
