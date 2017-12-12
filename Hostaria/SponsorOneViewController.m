//
//  SponsorOneViewController.m
//  Hostaria
//
//  Created by iOS on 29/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "SponsorOneViewController.h"
#import "SponsorOneDoubleCell.h"
#import "SponsorOneSingleCell.h"

@interface SponsorOneViewController (){
    NSDictionary *data;
}


@end

@implementation SponsorOneViewController

-(void)setUserData:(NSDictionary*)info{
    data=info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   /* UINib *dblcell = [UINib nibWithNibName:@"SponsorOneDoubleCell" bundle:nil];
    UINib *valCell = [UINib nibWithNibName:@"SponsorOneSingleCell" bundle:nil];
    
    [self.sponsorTable registerNib:dblcell forCellReuseIdentifier:@"sponsordoublecell"];
    [self.sponsorTable registerNib:valCell forCellReuseIdentifier:@"sponsorsinglecell"];
    self.sponsorTable.delegate=self;
    self.sponsorTable.dataSource=self;*/
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
/*-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        SponsorOneDoubleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sponsordoublecell" forIndexPath:indexPath];
        cell.ivOne.image=[UIImage imageNamed:@""];
        cell.ivTwo.image=[UIImage imageNamed:@""];
        cell.sponsorTitle.text=@"È un evento organizzato";

        return cell;
    }else if(indexPath.row==1){
       
        SponsorOneDoubleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sponsordoublecell" forIndexPath:indexPath];
        cell.ivOne.image=[UIImage imageNamed:@""];
        cell.ivTwo.image=[UIImage imageNamed:@""];
        return cell;
    }else{
        SponsorOneSingleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorsinglecell" forIndexPath:indexPath];
        
        return cell;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}*/
@end
