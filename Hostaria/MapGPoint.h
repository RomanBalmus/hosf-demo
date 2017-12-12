//
//  MapGPoint.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Realm/Realm.h>
#import "Stand.h"
#import "Cellar.h"
#import "Service.h"
#import "EntrancePoint.h"
#import "ParkingPoint.h"
#import "Event.h"
@interface MapGPoint : RLMObject
@property NSString * _id;
@property NSString * lat;
@property NSString * lng;
@property NSString * type;

@property Stand *stand;
@property Event *event;
@property ParkingPoint *parking;
@property EntrancePoint *entrance;
@property Service *service;
@property Cellar *cellar;

@end
