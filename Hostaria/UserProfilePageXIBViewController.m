//
//  UserProfilePageXIBViewController.m
//  Hostaria
//
//  Created by iOS on 26/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "UserProfilePageXIBViewController.h"
#import "MyTicketCell.h"
#import "FXBlurView.h"
#import "StickHeader.h"
#import "ProfileViewController.h"
#import "MyTicketViewController.h"
#import "BuyView.h"
#import "LoginCell.h"
#import "ScannerViewController.h"

@interface UserProfilePageXIBViewController (){
    NSMutableDictionary *userData;
    BOOL haveTickets;
    BOOL isLogged;
    UINavigationController *parentNav;

}
@property (nonatomic, strong) UINib *ticketCell;
@property (nonatomic, strong) UINib *stickHeader;
@property (nonatomic, strong) UINib *loginCell;


@end

@implementation UserProfilePageXIBViewController
-(void)setupNavigation:(UINavigationController *)navctrl{
    parentNav=navctrl;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    //  let fileURL2 = NSBundle.mainBundle().URLForResource("Image", withExtension:"jpg"),
    
    
   /* UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;*/

    NSLog(@"will appear");
  
    
    NSLog(@"im on profile");

    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.my.backgroundQueue", NULL);
    dispatch_async(concurrentQueue, ^{
        [self reloadDatas];
    });
    
}

-(void)reloadDatas
{
    // Expensive operations i.e pull data from server and add it to NSArray or NSDictionary
    userData = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];
    //  NSLog(@"userdata: %@",userData);
    isLogged=[[NSUserDefaults standardUserDefaults]boolForKey:@"logged"];
    
    if (isLogged) {
        NSLog(@"this is my user data mytickets %@",userData);
        
        if ([userData[@"myTickets"]count]==0) {
            NSLog(@"dont have tickets show ask to buy");
            
            haveTickets=NO;
            
        }else{
            haveTickets=YES;
            
            
        }
    }
    
    if (![userData objectForKey:@"name"] && ![userData objectForKey:@"surname"]) {
        // [self.letterCircle removeFromSuperview];
    }else{
        
        // [self.letterCircle setInitials:[NSString stringWithFormat:@"%@%@",[[userData objectForKey:@"name"] substringToIndex:1].uppercaseString,[[userData objectForKey:@"surname"] substringToIndex:1].uppercaseString] bgColor:[UIColor greenColor]];
        // ASK IF NEED TO ADD
        
    }
    
    // Operation done - now let's update our table cells on the main thread
    
    dispatch_queue_t mainThreadQueue = dispatch_get_main_queue();
    dispatch_async(mainThreadQueue, ^{
        
        [self.myTableView reloadData];
        [self updateTicket:nil];
    });
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
  


   
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [WAMP startReconnect];
    // Do any additional setup after loading the view from its nib.
    self.loginCell = [UINib nibWithNibName:@"LoginCell" bundle:nil];
    [self.myTableView registerNib:self.loginCell forCellReuseIdentifier:@"logincell"];

        self.ticketCell = [UINib nibWithNibName:@"MyTicketCell" bundle:nil];
        self.stickHeader = [UINib nibWithNibName:@"StickHeader" bundle:nil];
    UINib*buy = [UINib nibWithNibName:@"BuyView" bundle:nil];
    [self.myTableView registerNib:buy forCellReuseIdentifier:@"buy"];

 
    
        [self.myTableView registerNib:self.stickHeader forCellReuseIdentifier:@"stickHeader"];
        
        [self.myTableView registerNib:self.ticketCell forCellReuseIdentifier:@"myticketcell"];
        // self.theTable.tableHeaderView = self.stickHeader;
        self.myTableView.delegate=self;
        self.myTableView.dataSource=self;
        self.growImageView.image=[[UIImage imageNamed:@"profile_logo"]blurredImageWithRadius:1 iterations:34 tintColor:[UIColor clearColor]];
  
   // NSLog(@"profile data: %@",userData);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableData:) name:@"updateTable" object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTicket:) name:@"updateTicket" object:nil];

    
    
    
}
-(void)showMyTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMyTicket" object:nil];
}
-(void)updateTicket:(id)sender{
    UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
    if ([userData[@"myTickets"]count]==0) {
        NSLog(@"dont have tickets show ask to buy");
        
        haveTickets=NO;
        
    }else{
        haveTickets=YES;
        
        
    }
    if (haveTickets) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];

    }else{
        [ticket removeFromSuperview];
        self.navigationItem.rightBarButtonItem=nil;

    }
    
    
}


-(void)dealloc{
   // [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)updateTableData:(id)sender{
    userData = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];
    
    isLogged=[[NSUserDefaults standardUserDefaults]boolForKey:@"logged"];
    
    if (isLogged) {
        if ([userData[@"myTickets"]count]==0) {
            NSLog(@"dont have tickets show ask to buy");
            haveTickets=NO;
            
        }else{
                haveTickets=YES;
          
        }
    }
    
    if (![userData objectForKey:@"name"] && ![userData objectForKey:@"surname"]) {
        // [self.letterCircle removeFromSuperview];
    }else{
        
        // [self.letterCircle setInitials:[NSString stringWithFormat:@"%@%@",[[userData objectForKey:@"name"] substringToIndex:1].uppercaseString,[[userData objectForKey:@"surname"] substringToIndex:1].uppercaseString] bgColor:[UIColor greenColor]];
        // ASK IF NEED TO ADD
        
    }
    
    //NSLog(@"updated table data: %@",userData);
    [self.myTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (haveTickets && isLogged) {
        return [userData[@"myTickets"]count];//ticket count TODO
    }else if(!haveTickets && isLogged){
        return 1;
  
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (haveTickets) {
        NSDictionary*data=[userData[@"myTickets"]objectAtIndex:indexPath.row];
        MyTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myticketcell" forIndexPath:indexPath];
        NSString * title = [NSString stringWithFormat:@"%@",[data objectForKey:@"participationDate"]];
        if ([[data objectForKey:@"validityDay"]intValue]==3) {
            title = @"da 14/10/16 a 16/10/16 Hostaria 2016";

        }else if(title.length>2){
            title = [NSString stringWithFormat:@"Data: %@",title];

        }else{
            title = @"Biglietto omaggio";
        }
        
        cell.titleTextLabel.text=title;////@"da 14/10/16 a 16/10/16 Hostaria 2016";
        cell.nameTextLabel.text=[NSString stringWithFormat:@"%@",[data objectForKey:@"ticketName"]];
        
        
        
        NSDictionary*fav=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_favorite_ticket"];
        
        if ([[fav objectForKey:@"ticketQrcode"] isEqualToString:[data objectForKey:@"ticketQrcode"]]) {
            [cell.favoriteIv setHidden:NO];

        }else{
            [cell.favoriteIv setHidden:YES];

        }
      
        if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"bus"]] isEqualToString:@"1"]) {
            [cell.atmIv setHidden:NO];
        }else{
            [cell.atmIv setHidden:YES];
            
        }
        return cell;
    }else{
        BuyView *cell = [tableView dequeueReusableCellWithIdentifier:@"buy" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
         /*  SponsorCell     *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorcell" forIndexPath:indexPath];
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
        */
        return cell;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 112;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (isLogged) {
        StickHeader *header = [tableView dequeueReusableCellWithIdentifier:@"stickHeader"];
        
        NSString *name = [NSString stringWithFormat:@"%@ %@",[userData objectForKey:@"name"] ,[userData objectForKey:@"surname"] ];
        NSString *normaltext =nil;//
        if(haveTickets){
            normaltext=@"questi sono i tuoi biglietti di Hostaria Verona:";
        }else{
            normaltext=@"qui verranno visualizzati i tuoi acquisti.";
        }
        NSString *greetings = [NSString stringWithFormat:@"Ciao %@,\n\n%@",name.length > 3 ? name : [userData objectForKey:@"email"] ,normaltext];
        NSMutableAttributedString *greetNamemutable = [[NSMutableAttributedString alloc] initWithString:greetings];
        [greetNamemutable addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"PierSans" size:20]
                                 range:NSMakeRange(0, name.length+6)];
        [greetNamemutable addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"PierSans" size:12]
                                 range:[greetings rangeOfString:normaltext]];
        header.usernameTextLabel.attributedText=greetNamemutable;
        [header.actionButton addTarget:self action:@selector(showActions:) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }else{
        NSLog(@"show emty table view and ask register");
        LoginCell *logincell = [tableView dequeueReusableCellWithIdentifier:@"logincell"];


        
        logincell.loginTitle.text=@"Accedi a Hostaria per vedere i tuoi biglietti.";
        logincell.loginBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [logincell.loginBtn setTitle:@"ACCEDI" forState:UIControlStateNormal];
        [logincell.loginBtn setTitleColor:[self getUIColorObjectFromHexString:@"#CBBBA0" alpha:1] forState:UIControlStateNormal];
        logincell.loginBtn.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
        logincell.loginBtn.selectiveBordersColor = [UIColor blackColor];
        logincell.loginBtn.selectiveBordersWidth = 1.0;
        [logincell.loginBtn addTarget:self action:@selector(showLogin:) forControlEvents:UIControlEventTouchUpInside];
       // [logincell.configbtn addTarget:self action:@selector(showConfig:) forControlEvents:UIControlEventTouchUpInside];

        return logincell;
    }
  
    
    
    
}

-(void)showActions:(id)sender{
    NSLog(@"click");
    ActionViewController *detailViewController = [[ActionViewController alloc] initWithNibName:NSStringFromClass([ActionViewController class]) bundle:nil];
    detailViewController.delegate=self;

    [parentNav presentViewController:detailViewController animated:YES completion:nil];
    
    
   /* UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Seleziona un'azione:"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction
                                     actionWithTitle:@"Annulla"
                                     style:UIAlertActionStyleCancel
                                     handler:^(UIAlertAction *action)
                                     {
                                         if (alertController!=NULL) {
                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                         }
                                         NSLog(@"Cancel action");
                                     }]; // UIAlertActionStyleCancel
    UIAlertAction *receiveTicket = [UIAlertAction
                                   actionWithTitle:@"Ricevi biglietto \n Ricevi un "
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }]; // UIAlertActionStyleDestructive
    UIAlertAction *coupleTransfer = [UIAlertAction
                                    actionWithTitle:@"Biglietto di coppia"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSLog(@"Cancel action");
                                    }]; // UIAlertActionStyleDefault
    
    [online setValue:[[UIImage imageNamed:@"online.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [offline setValue:[[UIImage imageNamed:@"offline.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];

    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil]*/
}

-(void)showLogin:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showLogin" object:nil];
}

-(void)showConfig:(id)sender{
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
   // ProfileViewController *profile = [storyboard instantiateViewControllerWithIdentifier:@"profileContainer"];
    //[self.navigationController pushViewController:profile animated:YES];
    
    NSLog(@"this will be the transfer");
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!haveTickets) {
        NSLog(@"show buy here");
        [self showLogin:nil];
        return;
    }
    MyTicketViewController *myTicket=[[MyTicketViewController alloc]initWithNibName:@"MyTicketViewController" bundle:nil];
    [myTicket setTicketData:[userData[@"myTickets"]objectAtIndex:indexPath.row]];
    [parentNav pushViewController:myTicket animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)clickedCouple:(id)sender{
    NSLog(@"cpl click");
    ScannerViewController *myTicket=[[ScannerViewController alloc]initWithNibName:@"ScannerViewController" bundle:nil];
    [myTicket setScanType:RPC_COUPLE];
    [parentNav pushViewController:myTicket animated:YES];
}
-(void)clickedReceive:(id)sender{
    NSLog(@"rcv click");
    ScannerViewController *myTicket=[[ScannerViewController alloc]initWithNibName:@"ScannerViewController" bundle:nil];
    [myTicket setScanType:RPC_TRANSFER];
    [parentNav pushViewController:myTicket animated:YES];
}


@end
