//
//  MyAnnotation.h
//  Hostaria
//
//  Created by iOS on 30/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapGPoint.h"
#import "Service.h"
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>{
    MapGPoint *point;
    BOOL grey;
}
@property (nonatomic, retain) MapGPoint *point;
@property (nonatomic) BOOL grey;

-(MKAnnotationView*)annotationView;
@end
