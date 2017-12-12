//
//  OrderListViewController.m
//  Hostaria
//
//  Created by iOS on 05/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderCell.h"
#import "OrderItem.h"
@interface OrderListViewController ()<APIManagerDelegate>
{
    CGFloat originX;
    UIImageView *circle;
    NSMutableArray *orderList;
   // UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UINib *orderCell;

@end

@implementation OrderListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Aggiorna" style:UIBarButtonItemStylePlain target:self action:@selector(getOrdersFromServer:)];

    
}-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getOrdersFromServer:nil];

   
}
-(void)updateOrderTable{
    
    
    NSLog(@"update order from init");
    
 
    
    if (orderList.count==0) {
        
        UIView *empty = [[UIView alloc]initWithFrame:self.view.frame];
        UILabel *emptylabel = [[UILabel alloc]init];
        emptylabel.textAlignment=NSTextAlignmentCenter;
        emptylabel.text=@"Nessun ordine";
        [emptylabel sizeToFit];
        [empty addSubview:emptylabel];
        emptylabel.center=empty.center;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(empty.frame.size.width/2-100,20+emptylabel.frame.origin.y+ emptylabel.frame.size.height, 200, 44)];
        [btn setTitle:@"Aggiorna" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [empty addSubview:btn];

        [btn addTarget:self action:@selector(getOrdersFromServer:) forControlEvents:UIControlEventTouchUpInside];
        [self.orderTableView setBackgroundView:empty];
        self.orderTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }else{
        [self.orderTableView setBackgroundView:nil];
        self.orderTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
    }
    [self.orderTableView reloadData];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.orderCell = [UINib nibWithNibName:@"OrderCell" bundle:nil];
    
    [self.orderTableView registerNib:self.orderCell forCellReuseIdentifier:@"OrderCell"];
    // Do any additional setup after loading the view from its nib.
    self.orderTableView.delegate=self;
    self.orderTableView.dataSource=self;
    
    
   /* refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor purpleColor];
    [refreshControl addTarget:self
                            action:@selector(getOrdersFromServer:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.orderTableView setRefreshControl:refreshControl];*/



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getOrdersFromServer:(id)sender{
    NSLog(@"load orders from server");
    
    NSLog(@"user data: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]);
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]objectForKey:@"id_user"]!=[NSNull null]) {
        API.delegate=self;
        [API getOrderForUser:[NSDictionary dictionaryWithObjectsAndKeys:[[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]objectForKey:@"id_user"], @"idUser", nil] onView:self.view];
        
    }else{
        [self updateOrderTable];
    }
}
-(void)getOrderForUser:(APIManager *)manager didFailWithError:(NSError *)error{
    [self updateOrderTable];
   

}
-(void)getOrderForUser:(APIManager *)manager didFinishLoading:(id)item{
    orderList=[[NSMutableArray alloc]init];

    
    NSDictionary*rsps=(NSDictionary*)item;
    orderList=(NSMutableArray*)[rsps objectForKey:@"orders"];
    
    
    
    
    [self updateOrderTable];
  


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [orderList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *item = [orderList objectAtIndex:indexPath.row];
    
    OrderCell *cell = (OrderCell*)[self.orderTableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    NSString *productString = @"";
    
    
    cell.lblOne.text=[NSString stringWithFormat:@"#%@\nTotale prodotti: %@ pz.\nPrezzo totale: %@ €\nTotale spedizione: %@ €",[item objectForKey:@"numberOfOrder"],[item objectForKey:@"totalQuantity"],[item objectForKey:@"totalPrice"],[item objectForKey:@"orderShippingAmount"]];
    cell.lblTwo.text=productString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:[[item objectForKey:@"createdAt"]objectForKey:@"date"]];
    [dateFormatter setDateFormat:@"dd/MM/YYYY HH:mm"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    cell.lblThree.text=[NSString stringWithFormat:@"Stato ordine: %@\n%@",[item objectForKey:@"statusName"],stringDate];
    
    
    
    NSMutableArray *prods = [item objectForKey:@"products"];
    NSInteger inntgs=0;
    for (NSDictionary *prd in prods) {
        inntgs++;
        
        NSString *newline=nil;
        
        if (inntgs==1) {
            newline=@"";
        }else{
            newline=@"\n";

        }
        productString = [productString stringByAppendingFormat:@"%@%ld. %@\nPrezzo: %@",newline,(long)inntgs, [prd objectForKey:@"productName"],[prd objectForKey:@"price"]];

    }
    
    cell.lblTwo.text=productString;
    
    /*NSLog(@"the cart: %@",[item debugDescription]);
    cell.cartItemLabelProduct.text=[NSString stringWithFormat:@"%@",item.name];
    cell.cartItemLabelCompany.text=[NSString stringWithFormat:@"%@",item.companyName];
    cell.cartItemLabelPrice.text=[NSString stringWithFormat:@"Prezzo:%@ €",item.price];
    [cell.quantityButton setTitle:[NSString stringWithFormat:@"Qtà°:%@",item.quantity] forState:UIControlStateNormal];
    cell.quantityButton.tag=indexPath.row;
    [cell.quantityButton addTarget:self action:@selector(selectQuantity:) forControlEvents:UIControlEventTouchUpInside];
    if ([item.winecategoryId isEqualToString:@"3"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_white"];
    }else if ([item.winecategoryId  isEqualToString:@"4"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_rose"];
    }else if ([item.winecategoryId isEqualToString:@"1"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_red"];
    }else if ([item.winecategoryId isEqualToString:@"5"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }
    
    [cell.quantityButton setTitle:[NSString stringWithFormat:@"Qtà: %@",item.quantity] forState:UIControlStateNormal];//=;
    cell.quantityButton.tag=indexPath.row;
    [cell.quantityButton addTarget:self action:@selector(selectQuantity:) forControlEvents:UIControlEventTouchUpInside];*/
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
