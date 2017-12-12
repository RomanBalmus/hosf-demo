//
//  Product.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//
@class Cellar;

#import <Realm/Realm.h>
@interface Product : RLMObject
@property NSString * _id;
@property NSString * name;
@property NSString * address;
@property Cellar *cellar;
@property NSString * lat;
@property NSString * lng;
@property NSString * _description;
@property NSString * imgUrl;
@property NSString * revision;
@property NSString * price;
@property NSString * credits;
@property NSString * winetype;
@property NSString * winecolor;
@property NSString * winecategoryId;
@property NSString * quantity;

@end
RLM_ARRAY_TYPE(Product) // define RLMArray<Dog>
