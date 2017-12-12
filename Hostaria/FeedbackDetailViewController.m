//
//  FeedbackDetailViewController.m
//  Hostaria
//
//  Created by iOS on 11/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "FeedbackDetailViewController.h"
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
@interface FeedbackDetailViewController ()<FBSDKSharingDelegate>{
    NSDictionary *tempData;
    Product *currentProduct;
}

@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) UINib *cellChild;
@property (nonatomic, strong) UINib *cellNib;
@end

@implementation FeedbackDetailViewController

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
    
    NSLog(@"send btn clicked");
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    
    
    
    currentProduct =[[Product objectsWhere:[NSString stringWithFormat:@"_id = '%@'",[dict objectForKey:@"productId"]]]firstObject];
    NSLog(@"product %@",currentProduct.debugDescription);
    
        
        
        
        
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
        
    
    for (NSDictionary *dicts in [dict objectForKey:@"categories"]) {
        
        FeedbackCategory *cat = [[FeedbackCategory alloc]init];
        
            cat.name=[dicts objectForKey:@"name"];
            
            NSMutableArray * arrayForKey = [dicts objectForKey:@"detailList"];
            
            NSMutableArray *ndetarr= [[NSMutableArray alloc]init];

            for (NSDictionary *aobj in arrayForKey) {
                
                
                NSLog(@"aobj: %@",aobj);
                
                
                    FeedbackDetailItem *item = [[FeedbackDetailItem alloc]init];
                    item.name=[aobj objectForKey:@"name"];
                
                
                    item.value=[aobj objectForKey:@"value"];
                    
                    [ndetarr addObject:item];
               
                NSLog(@"ndetarr: %@",ndetarr);

                
            }
            
            
        cat.detailList=ndetarr;

        
            [self.headerArray addObject:cat];
            
            
      
        

    }
    
    
    
    
    
    [self.feedbackTableView reloadData];
    
    
    
    
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
    
    
    NSLog(@"detail : %@",item.debugDescription);
    
    
    cell.ttlLabel.text=item.name;
    
    if (item.value==nil) {
        [cell.theStarController setValue:0.0f];
    }else{
        [cell.theStarController setValue:[item.value floatValue]];
    }
    
    //cell.theStarController.tag=indexPath.section+indexPath.row;
    [cell.theStarController setUserInteractionEnabled:NO];
   // [cell.theStarController addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    
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
    
    [cart setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"s"];
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cart_items"] != nil) {
        [data addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_items"]];
        NSLog(@"data inside: %@",data);
        
    }
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
