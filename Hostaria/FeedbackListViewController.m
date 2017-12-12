//
//  FeedbackListViewController.m
//  Hostaria
//
//  Created by iOS on 10/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "FeedbackListViewController.h"
#import "FeedbackRow.h"
#import "FeedbackDetailViewController.h"
@interface FeedbackListViewController (){
    NSMutableArray *feedbackList;
    CGFloat originX;
    UIImageView *circle;
}
@property (nonatomic, strong) UINib *orderCell;

@end

@implementation FeedbackListViewController
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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.orderCell = [UINib nibWithNibName:@"FeedbackRow" bundle:nil];
    
    [self.feedbackTableView registerNib:self.orderCell forCellReuseIdentifier:@"FeedbackRow"];
    // Do any additional setup after loading the view from its nib.
    self.feedbackTableView.delegate=self;
    self.feedbackTableView.dataSource=self;
    feedbackList=[[NSMutableArray alloc]init];

    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"feddsArray"]!=[NSNull null]) {
        [feedbackList addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"feddsArray"]];
    }
    
    NSLog(@"we are here1 %@", feedbackList);

    NSLog(@"we are here2 %lu", (unsigned long)feedbackList.count);

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (feedbackList.count==0) {
        
        UIView *empty = [[UIView alloc]initWithFrame:self.feedbackTableView.frame];
        UILabel *emptylabel = [[UILabel alloc]init];
        emptylabel.textAlignment=NSTextAlignmentCenter;
        emptylabel.textColor=[UIColor blackColor];
        emptylabel.text=@"Nessun feedback";
        [emptylabel sizeToFit];
        emptylabel.center=empty.center;
        [empty addSubview:emptylabel];
        
        /* UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(empty.frame.size.width/2-100,20+emptylabel.frame.origin.y+ emptylabel.frame.size.height, 200, 44)];
         [btn setTitle:@"Aggiorna" forState:UIControlStateNormal];
         [btn setBackgroundColor:[UIColor blackColor]];
         [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         
         [empty addSubview:btn];
         [btn addTarget:self action:@selector(getOrdersFromServer:) forControlEvents:UIControlEventTouchUpInside];*/
        [self.feedbackTableView setBackgroundView:empty];
        self.feedbackTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }else{
        [self.feedbackTableView setBackgroundView:nil];
        self.feedbackTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
    }
    [self.feedbackTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [feedbackList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *item = [feedbackList objectAtIndex:indexPath.row];
    FeedbackRow *cell = (FeedbackRow*)[self.feedbackTableView dequeueReusableCellWithIdentifier:@"FeedbackRow"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedbackRow"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.productName.text=[item objectForKey:@"productName"];
    cell.cellarName.text=[item objectForKey:@"cellarName"];
    cell.cellarNumeration.text=[item objectForKey:@"cellarId"];
    cell.cellarAddress.text=[item objectForKey:@"cellarAddress"];
    
    if ([[item objectForKey:@"productCategoryId" ] isEqualToString:@"3"]) {
        cell.wineType.image=[UIImage imageNamed:@"ic_wine_white"];
    }else if ([[item objectForKey:@"productCategoryId" ] isEqualToString:@"4"]) {
        cell.wineType.image=[UIImage imageNamed:@"ic_wine_rose"];
    }else if ([[item objectForKey:@"productCategoryId" ] isEqualToString:@"1"]) {
        cell.wineType.image=[UIImage imageNamed:@"ic_wine_red"];
    }else if ([[item objectForKey:@"productCategoryId" ] isEqualToString:@"5"]) {
        cell.wineType.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }else if ([[item objectForKey:@"productCategoryId" ] isEqualToString:@"2"]) {
        cell.wineType.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }
    
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
    
    
    FeedbackDetailViewController *detail=[[FeedbackDetailViewController alloc]initWithNibName:@"FeedbackDetailViewController" bundle:nil];
    [detail setFeedBackDataToWorkWith:[feedbackList objectAtIndex:indexPath.row]];
    
    
    [self presentViewController:detail animated:YES completion:nil];
    
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
