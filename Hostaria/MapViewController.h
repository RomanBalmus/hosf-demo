//
//  MapViewController.h
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapViewController : UIViewController<MKMapViewDelegate,  CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *theMap;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *legendButton;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@end
