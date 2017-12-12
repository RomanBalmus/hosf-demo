//
//  Section.m
//  Hostaria
//
//  Created by iOS on 29/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "Section.h"

@implementation Section


-(instancetype)initWithName:(NSString *)aName data:(NSMutableArray *)aData collapsed:(BOOL)acollapsed{
    if (self) {
        self.name=aName;
        self.data=aData;
        self.collapsed=acollapsed;
    }
    return self;
}
@end
