//
//  MapViewController.m
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MapViewController.h"
#import "MapGPoint.h"
#import "RoutePoint.h"
#import "CleanAnnotation.h"
#import "BottomSheetView.h"
#import "ZoomRotatePanImageView.h"

@interface MapViewController (){
    CGFloat originX;
    UIImageView *circle;
    RLMResults<MapGPoint *> *points;
    NSMutableArray *coordinates1;
  //  NSMutableArray *coordinates2;
    BottomSheetView *customView;
    CLLocation * userLocation;
    UIView *theView;
}

@end

@implementation MapViewController
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}
- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
    [self updateTicket:nil];
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    
    
  //  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.theMap];
  //  self.navigationItem.leftBarButtonItem = buttonItem;
   
}
-(void)somethinghappened{
    NSLog(@"somethinghappened");
}
-(void)showMyTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMyTicket" object:nil];
}
-(void)updateTicket:(id)sender{
    
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    
    UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
    if ([[dict objectForKey:@"myTickets"]count]>0) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];
        
    }else{
        [ticket removeFromSuperview];
        self.navigationItem.rightBarButtonItem=nil;
        
    }
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTicket:) name:@"updateTicket" object:nil];

    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(somethinghappened)];
    
    // Location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.theMap.delegate=self;
    [self.returnButton addTarget:self action:@selector(zoomToFitAllExceptMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.legendButton addTarget:self action:@selector(expandLegendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn addTarget:self action:@selector(goToUserLocation:) forControlEvents:UIControlEventTouchUpInside];

    //self.legendButton.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop| AUISelectiveBordersFlagLeft | AUISelectiveBordersFlagRight;
   // self.legendButton.selectiveBordersColor = [self getUIColorObjectFromHexString:@"6F3222" alpha:1];
  //  self.legendButton.selectiveBordersWidth = 1.0;
    
    [self getDataFormap];
    

    

}

-(void)goToUserLocation:(id)sender{
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Location services not authorized"
                                                  message:@"This app needs you to authorize locations services to work."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Allow"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                           
                                       }];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [self.theMap setCenterCoordinate:self.theMap.userLocation.coordinate animated:NO];
 
        }
    }
    
    

}


-(void)expandLegendClick:(id)sender{
    
    if (theView!=NULL) {
        return;
    }
    
   theView = [[UIView alloc] initWithFrame:self.legendButton.frame];
    theView.backgroundColor = [UIColor blackColor];
    theView.alpha=0.9;
    
    
    
    
    [self.view addSubview:theView];
    
    [UIView animateWithDuration:.25f
                     animations:^{
                         theView.frame = self.view.bounds;
                       

                         ZoomRotatePanImageView *zoomIv=[[ZoomRotatePanImageView alloc]initWithFrame:CGRectMake(theView.frame.origin.x,theView.frame.origin.y,theView.frame.size.width,theView.frame.size.height)];
                         [zoomIv setImage:[UIImage imageNamed:@"legend"]];
                         [zoomIv setBackgroundColor:[UIColor whiteColor]];
                         UIButton *closebtn=[[UIButton alloc]initWithFrame:CGRectMake(zoomIv.frame.size.width-64, zoomIv.frame.origin.y+44, 60, 60)];
                         [closebtn setTitle:@"Chiudi" forState:UIControlStateNormal];
                         [closebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                         [closebtn addTarget:self action:@selector(collapseExpandView) forControlEvents:UIControlEventTouchUpInside];
                         //closebtn.layer.cornerRadius = closebtn.bounds.size.width / 2.0;
                        // closebtn.layer.borderWidth=1;
                         
                         closebtn.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop| AUISelectiveBordersFlagLeft | AUISelectiveBordersFlagRight;
                         closebtn.selectiveBordersColor = [self getUIColorObjectFromHexString:@"6F3222" alpha:1];
                         closebtn.selectiveBordersWidth = 1.0;
                         
                         [zoomIv addSubview:closebtn];

                         [theView addSubview:zoomIv];

                     }];
}
-(void)collapseExpandView{
    if (theView!=NULL) {
        
        CGRect frame = self.legendButton.frame;
        
        [UIView animateWithDuration:.25f
                         animations:^{
                             theView.frame = frame;
                             [theView removeFromSuperview];
                             theView = NULL;
                             
                         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Location Manager delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    userLocation=[locations lastObject];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];

    
        NSLog(@"start working on map");
        
        
        
    } else if (status == kCLAuthorizationStatusDenied) {
   
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Location services not authorized"
                                              message:@"This app needs you to authorize locations services to work."
                                              preferredStyle:UIAlertControllerStyleAlert];
   
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Allow"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else
        NSLog(@"Wrong location status");
}


-(void)drawRouteLine1Onmap{

 
    
    NSInteger pointCount = [coordinates1 count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [coordinates1 objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    MKGeodesicPolyline *routeLine = [MKGeodesicPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.theMap addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
    
   // [self drawRouteLine2Onmap];
    [self drawMarkersOnMap];

    
}
/*-(void)drawRouteLine2Onmap{

    NSInteger pointCount = [coordinates2 count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [coordinates2 objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    MKGeodesicPolyline *routeLine = [MKGeodesicPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    [self.theMap addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
    
    
    [self drawMarkersOnMap];

}*/
-(void)drawMarkersOnMap{
    
    NSLog(@"points: %@",points);
    for (MapGPoint *mp in points) {
        CleanAnnotation *myAn = [[CleanAnnotation alloc]init];
        myAn.point = mp;
        [self.theMap addAnnotation:myAn];
    }
    
    
    
    [self zoomToFitAllExceptMyLocation];
}

-(void)zoomToFitAllExceptMyLocation{
    
  //  [self.theMap showAnnotations:self.theMap.annotations animated:YES];
    //Mapview is your map on display,
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(45.439701, 10.987339);
    
    //Create a region with a 1000x1000 meter around the user location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    //Set the region of your mapview so the user location is in center and update
    [self.theMap setRegion:viewRegion];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    
    if ([annotation isKindOfClass:[CleanAnnotation class]]) {
        
        
        CleanAnnotation * myAn= (CleanAnnotation*)annotation;
        
        NSLog(@"my annotation");
        
        MKAnnotationView *annotationView = [self.theMap dequeueReusableAnnotationViewWithIdentifier:identifier];
      
        annotationView=myAn.annotationView;
        
        return annotationView;
    }
 
    
    return nil;
}
-(void)getDataFormap{
    points =[MapGPoint allObjects];
    
    

    
    RLMResults<RoutePoint *> *rpoints =[RoutePoint allObjects];
    coordinates1=[NSMutableArray new];
   // coordinates2=[NSMutableArray new];
    
    
    NSLog(@"points a: %lu",(unsigned long)rpoints.count);
 
    
    
    NSInteger position=0;
    
    
    for (RoutePoint *rpg in rpoints) {
        NSLog(@"points singlea: %@",rpg);

        
        position++;
        if ([rpg.number isEqualToString:@"1"]) {

        
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[rpg.lat doubleValue] longitude:[rpg.lng doubleValue]];

            [coordinates1 addObject:loc];
            
        }
        /*if ([rpg.number isEqualToString:@"2"]) {
            
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[rpg.lat doubleValue] longitude:[rpg.lng doubleValue]];


            [coordinates2 addObject:loc];
        }
        */
        NSLog(@"position %ld",(long)position);
    }
    
    [self drawRouteLine1Onmap];
}



// for iOS7+; see `viewForOverlay` for earlier versions

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 2;
        
        return renderer;
    }

    return nil;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    NSLog(@"tap ???");
   
    
   
    
    if (![view.annotation isKindOfClass:[CleanAnnotation class]]) {
        
        return;
    }
    NSLog(@"ok my go and work ???");

    
    
    NSString*title=nil;
    NSString*description=nil;
    
    CleanAnnotation *myan = (CleanAnnotation*)view.annotation;
    MapGPoint *point = myan.point;
    
    
    
    if ([point.type isEqualToString:TYPE_STAND]) {
        Stand *stnd = point.stand;
        title= stnd.name;
        description = stnd.address;
        NSLog(@"stand: %@",stnd);
    }
    
    if ([point.type isEqualToString:TYPE_SERVICE]) {
        Service *srv = point.service;
        title= srv.serviceNameDefinition;
        description = srv.address;
        NSLog(@"srv: %@",srv);

    }
    
    
    if (customView==NULL) {
        
   
    
        customView = [BottomSheetView customView];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownBottomSheet)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
        [customView addGestureRecognizer: swipeGesture];
        
        [self.view addSubview:customView];
        [customView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];


    }
        
    
    NSLog(@"clicked: %@ \n %@",title, description);
    
    customView.latitude=point.lat;
    customView.longitude=point.lng;
        customView.lblTitle.text=title;
        customView.lblDescription.text=description;
        [customView layoutIfNeeded];
        [customView updateFrame];
    
        
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [customView setFrame:CGRectMake(0, self.view.frame.size.height-customView.frame.size.height, self.view.frame.size.width, customView.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                     }];
    
    
   

    
    
    
   /* DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
    controller.annotation = view.annotation;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.delegate = self;
    [self.popover presentPopoverFromRect:view.frame
                                  inView:view.superview
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];*/
}
-(void)swipeDownBottomSheet{
    
    
    customView.container.alpha=0;
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         
                         [customView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
                     }
                     completion:^(BOOL finished){
                         [customView removeFromSuperview];
                         customView = nil;
                     }];
}

@end
