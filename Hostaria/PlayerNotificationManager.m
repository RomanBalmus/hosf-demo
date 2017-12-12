//
//  PlayerNotificationManager.m
//  Hostaria
//
//  Created by iOS on 10/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "PlayerNotificationManager.h"

@implementation PlayerNotificationManager
+ (instancetype)sharedInstance
{
    static PlayerNotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PlayerNotificationManager alloc] init];
        
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)playSpot{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playSpot" object:nil];
}
-(void)stopSpot{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopSpot" object:nil];

}
@end
