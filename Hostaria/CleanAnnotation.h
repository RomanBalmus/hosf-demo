//
//  CleanAnnotation.h
//  Hostaria
//
//  Created by iOS on 11/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapGPoint.h"
#import "Service.h"
#import <MapKit/MapKit.h>
@interface CleanAnnotation : NSObject<MKAnnotation>{
    MapGPoint *point;
    BOOL grey;
}
@property (nonatomic, retain) MapGPoint *point;
@property (nonatomic) BOOL grey;

-(MKAnnotationView*)annotationView;
@end
