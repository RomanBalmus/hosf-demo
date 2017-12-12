//
//  Section.h
//  Hostaria
//
//  Created by iOS on 29/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject


@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSMutableArray * data;
@property (nonatomic) BOOL collapsed;


-(instancetype)initWithName:(NSString*)aName data:(NSMutableArray *)aData collapsed:(BOOL)acollapsed;
@end
