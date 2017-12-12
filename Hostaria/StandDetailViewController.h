//
//  StandDetailViewController.h
//  Hostaria
//
//  Created by iOS on 29/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface StandDetailViewController : UIViewController<MKMapViewDelegate,  CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
}
@property (weak, nonatomic) IBOutlet MKMapView *theMap;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@property (weak, nonatomic) IBOutlet UITableView *theTableView;

@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (nonatomic, strong) id data;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

@end
