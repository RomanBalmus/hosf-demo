//
//  SponsorListViewController.m
//  Hostaria
//
//  Created by iOS on 31/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "SponsorListViewController.h"
#import "SponsorCell.h"

@interface SponsorListViewController ()

@end

@implementation SponsorListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
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
     UINib*buy = [UINib nibWithNibName:@"SponsorCell" bundle:nil];
      [self.myTableView registerNib:buy forCellReuseIdentifier:@"sponsorcell"];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.myTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return 10;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
         SponsorCell     *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorcell" forIndexPath:indexPath];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
         
         if (indexPath.row==0) {
         cell.ivOne.image=[UIImage imageNamed:@"1"];
         cell.ivTwo.image=[UIImage imageNamed:@"2"];
         
         }else if(indexPath.row==1){
         cell.ivOne.image=[UIImage imageNamed:@"3"];
         cell.ivTwo.image=[UIImage imageNamed:@"4"];
         }
         else if(indexPath.row==2){
         cell.ivOne.image=[UIImage imageNamed:@"5"];
         cell.ivTwo.image=[UIImage imageNamed:@"6"];
         }else if(indexPath.row==3){
         cell.ivOne.image=[UIImage imageNamed:@"7"];
         cell.ivTwo.image=[UIImage imageNamed:@"8"];
         }else if(indexPath.row==4){
         cell.ivOne.image=[UIImage imageNamed:@"9"];
         cell.ivTwo.image=[UIImage imageNamed:@"10"];
         }else if(indexPath.row==5){
         cell.ivOne.image=[UIImage imageNamed:@"11"];
         cell.ivTwo.image=[UIImage imageNamed:@"12"];
         }else if(indexPath.row==6){
         cell.ivOne.image=[UIImage imageNamed:@"13"];
         cell.ivTwo.image=[UIImage imageNamed:@"14"];
         }else if(indexPath.row==7){
         cell.ivOne.image=[UIImage imageNamed:@"15"];
         cell.ivTwo.image=[UIImage imageNamed:@"16"];
         }else if(indexPath.row==8){
         cell.ivOne.image=[UIImage imageNamed:@"17"];
         cell.ivTwo.image=[UIImage imageNamed:@"18"];
         }else if(indexPath.row==9){
         cell.ivOne.image=[UIImage imageNamed:@"19"];
         cell.ivTwo.image=[UIImage imageNamed:@"20"];
         }else if(indexPath.row==10){
         cell.ivOne.image=[UIImage imageNamed:@""];
         cell.ivTwo.image=[UIImage imageNamed:@""];
         }
         
        return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
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
