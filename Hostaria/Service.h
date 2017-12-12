//
//  Service.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Realm/Realm.h>

@interface Service : RLMObject
@property NSString * _id;
@property NSString * name;
@property NSString * serviceNameDefinition;
@property NSString * serviceLocalType;
@property NSString * serviceTypeId;
@property NSString * numeration;
@property NSString * address;
@property NSString * lat;
@property NSString * lng;
@property NSString * _description;
@property NSString * imgUrl;
@property NSString * revision;

@property NSDate  *starttime;
@property NSDate  *endtime;
@property NSDate  *firedate;
@property NSString* fired;

/*
 1 - ristoranti/bar
 2- sbecolerie/tasting food
 3- tipicità
 4- prodotti speciali
 5- ingressi
 6- conad
 7- vendita vino
 8- baby hostaria
 9- wc
 10- cartoni/events area
 11- parcheggi
 */
@end
