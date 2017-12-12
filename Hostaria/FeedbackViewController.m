//
//  FeedbackViewController.m
//  Hostaria
//
//  Created by iOS on 10/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedBackHeader.h"
#import "FeedbackDetailRow.h"
#import "FeedbackCategory.h"
#import "HCSStarRatingView.h"
#import "FeedbackDetailItem.h"
#import "FeedbackInfoHeader.h"
#import "Product.h"
#import "TheFeedback.h"
#import "Cellar.h"
#import "Stand.h"
#import "MapGPoint.h"
#import "NSDictionary+PropertiesOfObject.h"
@interface FeedbackViewController ()<FBSDKSharingDelegate>{
    NSDictionary *tempData;
    Product *currentProduct;
    TheFeedback * theFeedback;
}

@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) UINib *cellChild;
@property (nonatomic, strong) UINib *cellNib;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.feedbackTableView.dataSource=self;
    self.feedbackTableView.delegate=self;
    self.cellNib = [UINib nibWithNibName:@"FeedBackHeader" bundle:nil];
    self.cellChild = [UINib nibWithNibName:@"FeedbackDetailRow" bundle:nil];
    
    [self.feedbackTableView registerNib:self.cellNib forHeaderFooterViewReuseIdentifier:@"Header"];
    [self.feedbackTableView registerNib:self.cellChild forCellReuseIdentifier:@"FeedbackDetailRow"];

    
    [self.sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.condividiBtn addTarget:self action:@selector(fbPostWithContent) forControlEvents:UIControlEventTouchUpInside];
    self.condividiBtn.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop | AUISelectiveBordersFlagLeft |AUISelectiveBordersFlagRight;
    self.condividiBtn.selectiveBordersColor = [UIColor blackColor];
    self.condividiBtn.selectiveBordersWidth = 1.0;
    
    self.sendBtn.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop | AUISelectiveBordersFlagLeft |AUISelectiveBordersFlagRight;
    self.sendBtn.selectiveBordersColor = [UIColor blackColor];
    self.sendBtn.selectiveBordersWidth = 1.0;
}

-(void)fbPostWithContent{
    
 /*   FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = self;
    dialog.content = content;
    dialog.mode = FBSDKShareDialogModeShareSheet;
    [dialog show];
    */
    
    
    
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    //content.contentDescription = [NSString stringWithFormat:@"Sto degustando un %@ della cantina %@ presso Hostaria Verona (https://www.facebook.com/HostariaVerona)",currentProduct.name, currentProduct.cellar.name];
    content.contentURL=[NSURL URLWithString:@"https://www.facebook.com/HostariaVerona"];
    content.contentTitle=[NSString stringWithFormat:@"Sto degustando un %@ \ndella cantina %@",currentProduct.name, currentProduct.cellar.name];
   // content.contentDescription=[NSString stringWithFormat:@"presso Hostaria Verona (https://www.facebook.com/HostariaVerona)"];

    
    FBSDKShareDialog *dialog= [[FBSDKShareDialog alloc]init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]){
        dialog.mode = FBSDKShareDialogModeNative;
    }
    else {
        dialog.mode = FBSDKShareDialogModeBrowser; //or FBSDKShareDialogModeAutomatic
    }
    dialog.shareContent=content;
    dialog.fromViewController=self;
    dialog.delegate=self;
    
    [dialog show];

    

    MapGPoint *point = [[MapGPoint objectsWhere:@"stand.cellarId = %@",currentProduct.cellar._id]lastObject];
    NSLog(@"got point: %@",point.debugDescription);

   /* [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/search?type=place&center=%@,%@&distance=10",point.lat,point.lng] parameters:@{@"fields": @"id, name"} HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"result GRAPH %@",result);
    }];*/
  /*  NSMutableDictionary *params2 = [NSMutableDictionary dictionaryWithCapacity:3L];
    
    [params2 setObject:[NSString stringWithFormat:@"%@,%@",point.lat,point.lng] forKey:@"center"];
    [params2 setObject:@"place" forKey:@"type"];
    [params2 setObject:@"10" forKey:@"distance"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/search" parameters:params2 HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"RESPONSE!!! /search");
        NSLog(@"result %@",result);
        NSLog(@"error %@",error);
    }];
    */
    
   
}
-(void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"sharerDidCancel: ");

    
}
-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"error: %@",error.debugDescription);
   
}

-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"complete share: %@",results);
   
}

-(void)sendBtnClicked:(id)sender{
    
    
    
    NSMutableArray * farr= [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"feddsArray"]!=[NSNull null]) {
        [farr addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"feddsArray"]];
    }
   
    
    theFeedback.saved=1;
    theFeedback.uploaded=0;
    for (int e=0; e<self.headerArray.count; e++) {
        FeedbackCategory *cat = [self.headerArray objectAtIndex:e];
        
        
        for (int w=0; w<cat.detailList.count; w++) {
            FeedbackDetailItem *detit = [cat.detailList objectAtIndex:w];
            
            MyKV * kv = [[MyKV alloc]init];
            kv.keyname=detit.name;
            if (detit.value!=NULL) {
                
                NSInteger result = (NSInteger)roundf([detit.value floatValue] );
                
                kv.valuename= [@(result) stringValue];
                
            }else{
                kv.valuename=@"";
            }
            NSString *keynumber = [[detit.key componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
            
            kv.keynumber=[NSString stringWithFormat:@"key%@",keynumber];
            kv.valuenumber=[NSString stringWithFormat:@"value%@",keynumber];
            
            
            [theFeedback.kvs addObject:kv];
        }
        
        
        
        
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        
        
        [realm addObject:theFeedback];
    }];
    

    
    

    NSMutableDictionary * datas = [[NSMutableDictionary alloc]init];
    [datas setObject:currentProduct.name forKey:@"productName"];
    [datas setObject:currentProduct.winecategoryId forKey:@"productCategoryId"];
    [datas setObject:currentProduct.price forKey:@"productPrice"];
    [datas setObject:currentProduct.cellar._id forKey:@"cellarId"];
    [datas setObject:currentProduct.cellar.address forKey:@"cellarAddress"];
    [datas setObject:currentProduct.cellar.name forKey:@"cellarName"];
    [datas setObject:currentProduct._id forKey:@"productId"];

    NSMutableArray * arracats=[[NSMutableArray alloc]init];
    for (FeedbackCategory *cat in self.headerArray) {
       // NSMutableDictionary * catdict = [NSMutableDictionary dictionaryWithDictionary:cat.dictionaryValue];
       // NSLog(@"cat converted: %@",catdict);
        //[catdict removeObjectForKey:@"catid"];
        //[catdict removeObjectForKey:@"descr"];
        [arracats addObject:[NSDictionary dictionaryWithPropertiesOfObject:cat] ];
      //  NSLog(@"cat converted: %@",[NSDictionary dictionaryWithPropertiesOfObject:cat]);

    }
    
    [datas setObject:arracats forKey:@"categories"];

    
    [farr addObject:datas];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"feddsArray"];
    
    [[NSUserDefaults standardUserDefaults]setObject:farr forKey:@"feddsArray"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    
    /*

    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Vuoi condividere su Facebook?"
                                                                        message: nil
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Si"
                                                          style: UIAlertActionStyleCancel
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"ok button tapped!");
                                                            
                                                            
                                                            [self fbPostWithContent];
     
                                                            
                                                        }];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle: @"No"
                                                          style: UIAlertActionStyleDefault
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"ok button tapped!");
                                                            
                                                            [self dismissViewControllerAnimated:YES completion:^(void){
                                                                NSLog(@"the feedbacktogo: %@",[theFeedback debugDescription]);
                                                                
                                                              
                                                                
                                                            }];
                                                            
                                                        }];
    [controller addAction: cancelAlert];

    [controller addAction: alertAction];
    
    [self presentViewController: controller animated: YES completion: nil];*/
    
 
    
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        
        
    }];

    
    /*for (FeedbackCategory *cat in self.headerArray) {
        NSLog(@"cat name:%@",cat.name);
     
        for (FeedbackDetailItem *detit in cat.detailList) {
            NSLog(@"det name:%@",detit.name);
            NSLog(@"det value:%@",detit.value);
            NSLog(@"det key:%@",detit.key);

        }
        
    }
    
    */
    
    
    
   
}

-(void)setFeedBackDataToWorkWith:(NSDictionary *)data{
    tempData=data;
    
   
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self generateTableData:tempData];
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


-(void)generateTableData:(NSDictionary*)dict{
    
    self.headerArray=[[NSMutableArray alloc]init];
    NSLog(@"feedback1:%@",dict);

    NSMutableArray *feedbackgroups = [dict objectForKey:@"feedback"];

    if (feedbackgroups.count==0) {
        NSLog(@"no sufficient credits error");
        return;
    }
    
    
    currentProduct =[[Product objectsWhere:[NSString stringWithFormat:@"_id = '%@'",[dict objectForKey:@"id_product"]]]firstObject];
    NSLog(@"product %@",currentProduct.debugDescription);
    for (NSDictionary *obj in feedbackgroups) {
        
        

        
        
        self.standNrLbl.text=currentProduct.cellar._id;
        self.cellarNameLbl.text=currentProduct.cellar.name;
        self.productNameLbl.text=currentProduct.name;
        self.cellarAddrLbl.text=currentProduct.cellar.address;
        self.priceLabel.text=[NSString stringWithFormat:@"%@ €",currentProduct.price];

        if ([currentProduct.winecategoryId isEqualToString:@"3"]) {
            self.wineTypeIv.image=[UIImage imageNamed:@"ic_wine_white"];
        }else if ([currentProduct.winecategoryId isEqualToString:@"4"]) {
            self.wineTypeIv.image=[UIImage imageNamed:@"ic_wine_rose"];
        }else if ([currentProduct.winecategoryId isEqualToString:@"1"]) {
            self.wineTypeIv.image=[UIImage imageNamed:@"ic_wine_red"];
        }else if ([currentProduct.winecategoryId isEqualToString:@"5"]) {
            self.wineTypeIv.image=[UIImage imageNamed:@"ic_wine_sparkling"];
        }else if ([currentProduct.winecategoryId isEqualToString:@"2"]) {
            self.wineTypeIv.image=[UIImage imageNamed:@"ic_wine_sparkling"];
        }
        
        
        if (currentProduct.price.floatValue == 0.00) {
            [self.addToCartBtn setHidden:YES];
            [self.priceLabel setHidden:YES];
        }else{
            [self.addToCartBtn setHidden:NO];
            [self.priceLabel setHidden:NO];
            
        }
        
        
        FeedbackCategory *cat = [[FeedbackCategory alloc]init];
        
        [obj enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
            cat.name=key;
            
            NSMutableArray * arrayForKey = [obj objectForKey:key];
            
            
            for (NSDictionary *aobj in arrayForKey) {
                NSMutableArray *ndetarr= [[NSMutableArray alloc]init];
                
                [aobj enumerateKeysAndObjectsUsingBlock:^(id   key2, id   value2, BOOL *  stop) {
                    
                    FeedbackDetailItem *item = [[FeedbackDetailItem alloc]init];
                    item.name=value2;
                    item.key=key2;
                    [ndetarr addObject:item];
                }];
                
                cat.detailList=ndetarr;
                
            }
            
            
            
            
            [self.headerArray addObject:cat];

            
        }];
        
        
    }
    
 
    [self.feedbackTableView reloadData];
    
    
    theFeedback = [[TheFeedback alloc]init];
    
    theFeedback.id_scan_history=[[dict objectForKey:@"id_scan_history"]integerValue];
    theFeedback.ticket_id=[[dict objectForKey:@"ticket_id"]integerValue];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
        return 44;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    FeedbackCategory * catfeed = [self.headerArray objectAtIndex:section];
    
    return catfeed.detailList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.headerArray.count;
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
   
        FeedbackCategory *cat = self.headerArray[section];
    
        FeedBackHeader *head = (FeedBackHeader*)[self.feedbackTableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        
        head.ttlLabel.text=cat.name;
    [head.contentView setBackgroundColor:[UIColor whiteColor]];
    
        return  head;
 
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedbackDetailRow *cell = (FeedbackDetailRow*)[self.feedbackTableView dequeueReusableCellWithIdentifier:@"FeedbackDetailRow"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedbackDetailRow"owner:self options:nil];
        cell = [nib objectAtIndex:0];

    }
    FeedbackCategory *cat = [self.headerArray objectAtIndex:indexPath.section];
    FeedbackDetailItem *item = [cat.detailList objectAtIndex:indexPath.row];
    
    
    cell.ttlLabel.text=item.name;

    if (item.value==nil) {
        [cell.theStarController setValue:0.0f];
    }else{
        [cell.theStarController setValue:[item.value floatValue]];
    }
    
    cell.theStarController.tag=indexPath.section+indexPath.row;
    [cell.theStarController addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    
    return cell;
    
}
- (void)didChangeValue:(HCSStarRatingView*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.feedbackTableView];
    NSIndexPath *indexPath = [self.feedbackTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        FeedbackCategory *cat = [self.headerArray objectAtIndex:indexPath.section];
        FeedbackDetailItem *item = [cat.detailList objectAtIndex:indexPath.row];
        item.value=[NSString stringWithFormat:@"%f",sender.value];
        
        NSMutableArray*tochangedetlst = [NSMutableArray arrayWithArray:cat.detailList];
        [tochangedetlst replaceObjectAtIndex:indexPath.row withObject:item];
        cat.detailList=tochangedetlst;
        
        [self.headerArray replaceObjectAtIndex:indexPath.section withObject:cat];
    }
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (IBAction)addToCart:(id)sender {
    
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

    
    
    
    Product *obj = currentProduct;
    
    NSMutableDictionary *cart=[[NSMutableDictionary alloc]init];
    [cart setObject:obj._id forKey:@"productId"];
    [cart setObject:obj.name forKey:@"productName"];
    [cart setObject:obj.price forKey:@"productPrice"];
    [cart setObject:@"1" forKey:@"quantity"];
    [cart setObject:obj.cellar._id forKey:@"productCompanyId"];
    [cart setObject:obj.winecategoryId forKey:@"productTypeIcon"];
    [cart setObject:obj.cellar.name forKey:@"productCompanyName"];
    
    
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cart_items"] != nil) {
        [data addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_items"]];
        NSLog(@"data inside: %@",data);
        
    }
    [cart setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"s"];

    [data addObject:cart];
    
    
    
    
    UIView *ds=[self.wineContainerView snapshotViewAfterScreenUpdates:NO];
    CGPoint newPoint = [self.view convertPoint:ds.center fromView:self.wineContainerView];
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
@end
