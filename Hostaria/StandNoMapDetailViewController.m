//
//  StandNoMapDetailViewController.m
//  Hostaria
//
//  Created by iOS on 01/07/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "StandNoMapDetailViewController.h"
#import "Product.h"
#import "Cellar.h"
#import "Service.h"
#import "MapGPoint.h"
#import "MyAnnotation.h"
#import "RoutePoint.h"
#import "BottomSheetView.h"
#import "ZoomRotatePanImageView.h"
@interface StandNoMapDetailViewController (){
    CGFloat originX;
    UIImageView *circle;
    CLLocation * userLocation;
    UILabel *ttlLbl;
    RLMResults<MapGPoint *> *points;
    NSMutableArray *coordinates1;
 //   NSMutableArray *coordinates2;
    NSString * pKey;
    Service *currentService;
    UILabel *nrLabele;
    BottomSheetView *customView;
    UIView *theView;
    BOOL clicked;

}


@end

@implementation StandNoMapDetailViewController
-(void)setClicked:(BOOL)clk{
    clicked=clk;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"full_red"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    nrLabele=[[UILabel alloc]initWithFrame:frame];
    [circle addSubview:nrLabele];
    nrLabele.textAlignment=NSTextAlignmentCenter;
    [nrLabele setText:currentService._id];
    [nrLabele setTextColor:[self getUIColorObjectFromHexString:@"#CBBBA0" alpha:1]];
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:circle];
    
    
}


-(void)setMyTitle:(NSString*)lineOne linetwo:(NSString*)lineTwo{
    NSString *fullstr = [NSString stringWithFormat:@"%@\n%@",lineOne,lineTwo];
    ttlLbl= [[UILabel alloc]initWithFrame:CGRectZero] ;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentRight ;
    
    
    
    NSDictionary *attrs = @{
                            NSFontAttributeName:[UIFont fontWithName:@"PierSans" size:16],
                            NSForegroundColorAttributeName:[self getUIColorObjectFromHexString:@"#6F3222" alpha:1]
                            };
    NSDictionary *subAttrs = @{
                               NSFontAttributeName:[UIFont fontWithName:@"PierSans" size:9],
                               NSForegroundColorAttributeName:[self getUIColorObjectFromHexString:@"#6F3222" alpha:1]
                               };
    
    // Range of " 2012/10/14 " is (8,12). Ideally it shouldn't be hardcoded
    // This example is about attributed strings in one label
    // not about internationalization, so we keep it simple :)
    
    const NSRange range = [fullstr rangeOfString:lineTwo];
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullstr
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
  //  [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [fullstr length])];
    // Set it in our UILabel and we are done!
    
    
    //  ttlLbl.text=@"test title \n dasdashfbjdskgdfg";
    ttlLbl.lineBreakMode=NSLineBreakByWordWrapping;
    ttlLbl.numberOfLines=0;
    [ttlLbl setAttributedText:attributedText];
    ttlLbl.adjustsFontSizeToFitWidth=YES;
    ttlLbl.minimumScaleFactor=0.5;
    ttlLbl.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView = ttlLbl;
    [ttlLbl sizeToFit];
    
  //  self.lblDetailBottom.text = [NSString stringWithFormat:@"Stand N. %@ - %@ ",currentService._id,currentService.address];

}
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


-(void)somethinghappened{
    NSLog(@"somethinghappened");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(somethinghappened)];
    
    // Location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.theMap.delegate=self;

    
    NSLog(@"data: %@",self.data);
    
    if([self.data isKindOfClass:[Service class]]){
        [self loadServiceData];
        
    }else{
        NSDictionary * dict =(NSDictionary*)self.data;
       if ([dict[@"type"]isEqualToString:TYPE_SERVICE]) {
            [self loadServiceDataDict];
        }
    }
    [self.legendButton addTarget:self action:@selector(expandLegendClick:) forControlEvents:UIControlEventTouchUpInside];

    [self getDataFormap];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
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


-(void)loadServiceDataDict{
    NSLog(@"service data");
    
    NSDictionary*dict=(NSDictionary*
                       )_data;
    
    currentService =[[Service objectsWhere:@"_id = %@",[dict objectForKey:@"pk"]]firstObject]; //(Product*)_data;

    
    
    NSString*name=nil;
    
    if (currentService.name!= nil || currentService.name.length>0) {
        name = currentService.name;
    }
    
    if (currentService.serviceNameDefinition!= nil || currentService.serviceNameDefinition.length>0) {
        name = currentService.serviceNameDefinition;
    }
    
    [self setMyTitle:name linetwo:currentService.address];
    
    pKey = currentService._id;
    

    
}


-(void)loadServiceData{
    NSLog(@"service data");
    
    
    currentService = (Service*)_data;
    
    NSString*name=nil;
    
    if (currentService.name!= nil || currentService.name.length>0) {
        name = currentService.name;
    }
    
    if (currentService.serviceNameDefinition!= nil || currentService.serviceNameDefinition.length>0) {
        name = currentService.serviceNameDefinition;
    }
    
    [self setMyTitle:name linetwo:currentService.address];
    
    pKey = currentService._id;
    
 
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    for (MapGPoint *mp in points) {
        MyAnnotation *myAn = [[MyAnnotation alloc]init];
        myAn.point = mp;
        
        
        if ([mp.type isEqualToString:TYPE_STAND]) {
            myAn.grey=YES;

        }else if ([mp.type isEqualToString:TYPE_SERVICE]) {
            if ([pKey isEqualToString:mp.service._id]) {
                myAn.grey = NO;
                [self zoomToAnnotation:myAn];
                
                
               // [self.theMap selectAnnotation:myAn animated:YES];
                
                /*if (clicked) {
                    [self showCustomViewHere:myAn];
                }*/
                
                
            }else{
                myAn.grey=YES;
            }
            
            
            
        }
        
        [self.theMap addAnnotation:myAn];
    }
    
    
    
}

-(void)zoomToAnnotation:(MyAnnotation*)annotation{
    [self.theMap showAnnotations:@[annotation] animated:YES];
    
}

-(void)zoomToFitAllExceptMyLocation{
    [self.theMap showAnnotations:self.theMap.annotations animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        
        
        MyAnnotation * myAn= (MyAnnotation*)annotation;
        
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
    
    
    
    
    
    
    for (RoutePoint *rpg in rpoints) {
        if ([rpg.number isEqualToString:@"1"]) {
            
            
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[rpg.lat doubleValue] longitude:[rpg.lng doubleValue]];
            
            [coordinates1 addObject:loc];
            
        }
     /*   if ([rpg.number isEqualToString:@"2"]) {
            
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[rpg.lat doubleValue] longitude:[rpg.lng doubleValue]];
            
            
            [coordinates2 addObject:loc];
        }*/
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

#pragma mark - UIStateRestoration

NSString *const ViewControllerProductKey2 = @"ViewControllerProductKey2";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the product
    [coder encodeObject:self.data forKey:ViewControllerProductKey2];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the product
    self.data = [coder decodeObjectForKey:ViewControllerProductKey2];
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    NSLog(@"tap ???");
    
    
    
    
    if (![view.annotation isKindOfClass:[MyAnnotation class]]) {
        
        return;
    }
    NSLog(@"ok my go and work ???");
    
    
    
    NSString*title=nil;
    NSString*description=nil;
    
    MyAnnotation *myan = (MyAnnotation*)view.annotation;
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
                         NSLog(@"finished");
                     }];
    
    
    
    
    
    
  
}

-(void)showCustomViewHere:(MyAnnotation*)ann{
    NSString*title=nil;
    NSString*description=nil;
    MapGPoint *point = ann.point;
    
    
    
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
    
    
    
    NSLog(@"title : %@",title);
    
    if (customView==NULL) {
        
        
        
        customView = [BottomSheetView customView];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownBottomSheet)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
        [customView addGestureRecognizer: swipeGesture];
        
        [self.view addSubview:customView];
        [customView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
        
        
    }
    
    
    
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
