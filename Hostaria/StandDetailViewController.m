//
//  StandDetailViewController.m
//  Hostaria
//
//  Created by iOS on 29/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "StandDetailViewController.h"
#import "Product.h"
#import "Cellar.h"
#import "Service.h"
#import "MapGPoint.h"
#import "MyAnnotation.h"
#import "RoutePoint.h"
#import "WineTableViewCell.h"
#import "WineChildTableViewCell.h"

@interface StandDetailViewController (){
    CGFloat originX;
    UIImageView *circle;
    CLLocation * userLocation;
    UILabel *ttlLbl;
    RLMResults<MapGPoint *> *points;
    NSMutableArray *coordinates1;
   // NSMutableArray *coordinates2;
    NSString * pKey;
    NSMutableArray * productsArray;
    Cellar *currentCellarData;
    UILabel *nrLabele;
}

@end

@implementation StandDetailViewController
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
    [nrLabele setText:currentCellarData._id];
    nrLabele.textAlignment=NSTextAlignmentCenter;
    [nrLabele setTextColor:[self getUIColorObjectFromHexString:@"#CBBBA0" alpha:1]];

    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:circle];
 

}


-(void)setMyTitle:(NSString*)lineOne linetwo:(NSString*)lineTwo{
    NSString *fullstr = [NSString stringWithFormat:@"%@\n%@",lineOne,lineTwo];
    ttlLbl= [[UILabel alloc]initWithFrame:CGRectZero] ;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentJustified ;
    
    
    
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

    //self.lblDetailBottom.text = [NSString stringWithFormat:@"Stand N. %@ - %@ ",currentCellarData._id,currentCellarData.address];
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
    self.theTableView.delegate=self;
    self.theTableView.dataSource=self;
    [self.theTableView registerNib:[UINib nibWithNibName:@"WineTableViewCell" bundle:nil]  forHeaderFooterViewReuseIdentifier:@"headerView"];
    [self.theTableView registerNib:[UINib nibWithNibName:@"WineChildTableViewCell" bundle:nil]  forCellReuseIdentifier:@"wineCell"];
    productsArray = [[NSMutableArray alloc]init];
    self.theTableView.estimatedSectionHeaderHeight=44;
    self.theTableView.sectionHeaderHeight=UITableViewAutomaticDimension;

    self.theTableView.estimatedRowHeight=44;
    self.theTableView.rowHeight=UITableViewAutomaticDimension;
    
    NSLog(@"data: %@",self.data);
    
    if ([self.data isKindOfClass:[Cellar class]]) {
        [self loadCellarData];
    }else if([self.data isKindOfClass:[Product class]]){
        [self loadProductData];

    }else{
        NSDictionary * dict =(NSDictionary*)self.data;
        if ([dict[@"type"]isEqualToString:TYPE_CELLAR]) {
            [self loadCellarDataDict];
        }else  if ([dict[@"type"]isEqualToString:TYPE_WINE]) {
            [self loadProductDataDict];
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
-(void)loadCellarDataDict{
    NSDictionary * dict =(NSDictionary*)self.data;
    
    NSLog(@"cellar data2 %@",dict);
    
    Cellar *clar =[[Cellar objectsWhere:@"_id = %@",[dict objectForKey:@"pk"]]firstObject]; //(Product*)_data;
    currentCellarData = clar;
    [self setMyTitle:currentCellarData.name linetwo:currentCellarData.address];
    
    pKey = currentCellarData._id;
    
    for (Product * prd  in currentCellarData.products) {
        [productsArray addObject:prd];
    }
    if (productsArray.count==0) {
       [self.theTableView setHidden:YES];
    }else{
        [self.theTableView reloadData];
        
    }
   
}
-(void)loadCellarData{
    NSLog(@"cellar data");
    
   currentCellarData = (Cellar*)_data;
    [self setMyTitle:currentCellarData.name linetwo:currentCellarData.address];

    pKey = currentCellarData._id;
    
    for (Product * prd  in currentCellarData.products) {
        [productsArray addObject:prd];
    }
    if (productsArray.count==0) {
        [self.theTableView setHidden:YES];
    }else{
        [self.theTableView reloadData];
        
    }
    
}
-(void)loadProductDataDict{
    NSDictionary * dict =(NSDictionary*)self.data;

    NSLog(@"product data2 %@",dict);
    
    Product *prd =[[Product objectsWhere:@"_id = %@",[dict objectForKey:@"pk"]]firstObject]; //(Product*)_data;
    currentCellarData=prd.cellar;
    [self setMyTitle:currentCellarData.name linetwo:currentCellarData.address];
    
    pKey = currentCellarData._id;
    
    for (Product * prds  in currentCellarData.products) {
        [productsArray addObject:prds];
    }
    if (productsArray.count==0) {
        [self.theTableView setHidden:YES];
    }else{
        [self.theTableView reloadData];
        
    }
   

}

-(void)loadProductData{
    NSLog(@"product data");

    
    Product *prd = (Product*)_data;
    currentCellarData=prd.cellar;
    [self setMyTitle:currentCellarData.name linetwo:currentCellarData.address];

    pKey = currentCellarData._id;
    
    for (Product * prds  in currentCellarData.products) {
        [productsArray addObject:prds];
    }
    
    if (productsArray.count==0) {
        [self.theTableView setHidden:YES];
    }else{
        [self.theTableView reloadData];

    }
   

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return productsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WineChildTableViewCell *cell = (WineChildTableViewCell *)[self.theTableView dequeueReusableCellWithIdentifier:@"wineCell"];
    
    Product *obj = productsArray[indexPath.row];
    cell.lblName.text=obj.name;
    cell.lblPrice.text=obj.price;
    /*if ([obj.winecolor isEqualToString:@"bianco"]) {
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_white"];
        
    }else if ([obj.winecolor isEqualToString:@"rosato"]){
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_rose"];
        
    }else if([obj.winecolor isEqualToString:@"rosso"]){
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_red"];
        
    }*/
    cell.creditLabel.text=[NSString stringWithFormat:@"crediti: %@",obj.credits];
    if ([obj.winecategoryId isEqualToString:@"3"]) {
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_white"];
    }else if ([obj.winecategoryId isEqualToString:@"4"]) {
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_rose"];
    }else if ([obj.winecategoryId isEqualToString:@"1"]) {
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_red"];
    }else if ([obj.winecategoryId isEqualToString:@"5"]) {
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }else if ([obj.winecategoryId isEqualToString:@"2"]) {
        cell.imgV.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }
    
    
    
    if (obj.price.floatValue == 0.00) {
        [cell.addToCartBtn setHidden:YES];
        [cell.lblPrice setHidden:YES];
    }else{
        [cell.addToCartBtn setHidden:NO];
        [cell.lblPrice setHidden:NO];

    }
    cell.addToCartBtn.tag=indexPath.row;
    [cell.addToCartBtn addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)addToCart:(id)sender{
    
    
    BOOL isLogged=[[NSUserDefaults standardUserDefaults]boolForKey:@"logged"];
    if(!isLogged){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"goToWelcome" object:nil];
        
        
        return;
    }
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"stopBuyWine"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Vendite chiuse\nGrazie per aver partecipato a Hostaria 2016"
                                                                            message: nil
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
        
    }
    
    
    UIButton *btn=(UIButton*)sender;
  NSIndexPath * selectedIndexPath = [NSIndexPath indexPathForRow:btn.tag  inSection:0];
    Product *obj = productsArray[selectedIndexPath.row];
    
    NSMutableDictionary *cart=[[NSMutableDictionary alloc]init];
    [cart setObject:obj._id forKey:@"productId"];
    [cart setObject:obj.name forKey:@"productName"];
    [cart setObject:obj.price forKey:@"productPrice"];
    [cart setObject:@"1" forKey:@"quantity"];
    [cart setObject:obj.cellar._id forKey:@"productCompanyId"];
    [cart setObject:obj.winecategoryId forKey:@"productTypeIcon"];
    [cart setObject:obj.cellar.name forKey:@"productCompanyName"];
    [cart setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"s"];

    
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cart_items"] != nil) {
        [data addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_items"]];
        NSLog(@"data inside: %@",data);
        
    }
    [data addObject:cart];
    
    
    
    WineChildTableViewCell * cell = (WineChildTableViewCell*)[self.theTableView cellForRowAtIndexPath:selectedIndexPath];
    
    UIView *ds=[cell.contentView snapshotViewAfterScreenUpdates:NO];
    CGPoint newPoint = [self.view convertPoint:ds.center fromView:cell];
    [ds setCenter:newPoint];
    
    [self.view addSubview:ds];
    [self.view bringSubviewToFront:ds];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         ds.alpha=.6f;
                         ds.frame = CGRectMake(self.view.frame.size.width-20, self.view.frame.size.height, 20, 20);
                     }
                     completion:^(BOOL finished){
                         [ds removeFromSuperview];
                         [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"cart_items"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"updatecarttable" object:nil];
                     }];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (productsArray.count>0) {
        return 1;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    WineTableViewCell *cell = (WineTableViewCell *)[self.theTableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    return cell;

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
    [self drawMarkersOnMap];

   // [self drawRouteLine2Onmap];
   // /
    
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
            if ([pKey isEqualToString:mp.stand.cellarId]) {
                myAn.grey = NO;
                [self zoomToAnnotation:myAn];

            }else{
                myAn.grey=YES;
            }
            
            
            
        }else if([mp.type isEqualToString:TYPE_SERVICE]){
            myAn.grey=YES;

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

NSString *const ViewControllerProductKey = @"ViewControllerProductKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the product
    [coder encodeObject:self.data forKey:ViewControllerProductKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the product
    self.data = [coder decodeObjectForKey:ViewControllerProductKey];
}

@end
