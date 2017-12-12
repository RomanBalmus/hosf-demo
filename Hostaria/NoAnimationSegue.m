//
//  NoAnimationSegue.m
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "NoAnimationSegue.h"

@implementation NoAnimationSegue
- (void)perform {
    
    [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:NO];
}
@end
