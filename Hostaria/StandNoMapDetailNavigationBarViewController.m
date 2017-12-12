//
//  StandNoMapDetailNavigationBarViewController.m
//  Hostaria
//
//  Created by iOS on 01/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "StandNoMapDetailNavigationBarViewController.h"
#import "Product.h"
#import "Cellar.h"
#import "Service.h"
#import "MapGPoint.h"
#import "MyAnnotation.h"
#import "RoutePoint.h"
@interface StandNoMapDetailNavigationBarViewController (){
    CGFloat originX;
    UIImageView *circle;
    CLLocation * userLocation;
    UILabel *ttlLbl;
    RLMResults<MapGPoint *> *points;
    NSMutableArray *coordinates1;
  //  NSMutableArray *coordinates2;
    NSString * pKey;
    Service *currentService;
    UILabel *nrLabele;
    
}



@end

@implementation StandNoMapDetailNavigationBarViewController
-(void)dealloc{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"visibleNav"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeTop;
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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style: UIBarButtonItemStylePlain target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
   // [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];

    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"visibleNav"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlertWithinController:) name:@"showAlertWithinController" object:nil];
    
}
-(void)showAlertWithinController:(NSNotification*)notification{
    Service*evnt=[[Service objectsWhere:[NSString stringWithFormat:@"_id = '%@'",[notification.userInfo objectForKey:@"id"]]]firstObject];
    
    
    NSLog(@"the event:%@",[evnt debugDescription]);
    
    
    RLMRealm *rlm = [RLMRealm defaultRealm];
    [rlm beginWriteTransaction];
    //  evnt.fired=@"1";
    [rlm commitWriteTransaction];
    
    
    UIAlertController *alertController1 = [UIAlertController
                                           alertControllerWithTitle:@"Non perdere nessun evento!"
                                           message:[NSString stringWithFormat:@"In %@ sta per iniziare il %@ alle %@",evnt.address,evnt.serviceNameDefinition,evnt.starttime ]
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Annulla"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Vai"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   
                                   
                                   self.data = evnt; // hand off the current product to the detail view controller
                                   
                                   [self.view setNeedsDisplay];
                                   
                                   
                                   
                               }];
    [alertController1 addAction:cancelAction];
    
    [alertController1 addAction:okAction];
    
 
   [self presentViewController:alertController1 animated:YES completion:nil];
        
    
    

}
- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
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
    
   // self.lblDetailBottom.text = [NSString stringWithFormat:@"Stand N. %@ - %@ ",currentService._id,currentService.address];
    
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
            [self loadServiceData];
        }
    }
    
    [self getDataFormap];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}

-(void)loadServiceData{
    NSLog(@"service data");
    
    
    currentService = (Service*)_data;
    [self setMyTitle:currentService.serviceNameDefinition linetwo:currentService.address];
    
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
    
  //  [self drawRouteLine2Onmap];
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
  //  coordinates2=[NSMutableArray new];
    
    
    
    
    
    
    for (RoutePoint *rpg in rpoints) {
        if ([rpg.number isEqualToString:@"1"]) {
            
            
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[rpg.lat doubleValue] longitude:[rpg.lng doubleValue]];
            
            [coordinates1 addObject:loc];
            
        }
       /* if ([rpg.number isEqualToString:@"2"]) {
            
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

NSString *const ViewControllerProductKey3 = @"ViewControllerProductKey3";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the product
    [coder encodeObject:self.data forKey:ViewControllerProductKey3];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the product
    self.data = [coder decodeObjectForKey:ViewControllerProductKey3];
}



@end
