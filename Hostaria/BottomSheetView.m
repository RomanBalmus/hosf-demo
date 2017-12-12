//
//  BottomSheetView.m
//  Hostaria
//
//  Created by iOS on 30/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "BottomSheetView.h"

@implementation BottomSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (id)customView
{
    BottomSheetView *customView = [[[NSBundle mainBundle] loadNibNamed:@"BottomSheetView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[BottomSheetView class]])
        return customView;
    else
        return nil;
}

-(void)updateFrame{
    CGRect frame = self.frame;
    
    frame.size.height=_container.frame.size.height;
    [self setFrame:frame];
    
}

-(void)updateContainerFrame{
    CGRect frame = _container.frame;
    
    frame.size.height=self.frame.size.height;
    [self.container setFrame:frame];
    
}

- (IBAction)directionButtonClick:(id)sender {
    
    CLLocationCoordinate2D coordinate =    CLLocationCoordinate2DMake([self.latitude doubleValue],[self.longitude doubleValue]);
    
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
    {
        //using iOS6 native maps app
            [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
    
        
    } else{
        
        //using iOS 5 which has the Google Maps application
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", [self.latitude doubleValue], [self.longitude doubleValue]];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
    
}


@end
