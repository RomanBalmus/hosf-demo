//
//  Stand.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Realm/Realm.h>

@interface Stand : RLMObject
@property NSString * _id;
@property NSString * name;
@property NSString * address;
@property NSString * cellarId;
@property NSString * lat;
@property NSString * lng;
@property NSString * _description;
@property NSString * imgUrl;
@property NSString * revision;
@end
