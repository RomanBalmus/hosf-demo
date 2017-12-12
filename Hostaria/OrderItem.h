//
//  OrderItem.h
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductToBuy.h"

@interface OrderItem : NSObject
@property NSString * number;
@property NSString * totalquantity;
@property NSString * totalprice;
@property NSString * createdAt;
@property NSString * status;

@property NSDictionary * factureData;
@property NSDictionary * shippingData;
@property NSArray * products;

@end
