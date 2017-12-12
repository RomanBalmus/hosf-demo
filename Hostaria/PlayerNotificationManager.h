//
//  PlayerNotificationManager.h
//  Hostaria
//
//  Created by iOS on 10/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerNotificationManager : NSObject
+ (instancetype)sharedInstance;


-(void)playSpot;
-(void)stopSpot;
@end
