//
//  ChooseTicketViewController.m
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ChooseTicketViewController.h"
#import "AlertViewController.h"
#import "FooterLabel.h"
#import "HeaderLabel.h"
#import "DatetimeViewController.h"
#import "InviteToBuyMainViewController.h"

@interface ChooseTicketViewController ()<AlertViewDelegate,APIManagerDelegate,DatetimeDelegate>{
    NSMutableArray *ticketList;
    float totalSelectedPrice;
    NSMutableArray * totalTickets;
    FooterLabel *label;
    NSMutableDictionary *summaryDict;
    NSMutableArray * summaryTickets;
    BOOL haveEventData;
    NSInteger totalTicketSelected;
    NSDictionary *lastincremented;
    NSString *selectedDateForTicket;
    NSString *string;
}
@property (nonatomic, strong) UINib *cellNib;

@end

@implementation ChooseTicketViewController
@synthesize delegate;

-(void)updateTitle:(NSString *)ttl{
    string = ttl;
    [self.ttlLabel setText:string];
    
    NSLog(@"reload table title: %@",ttl);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.cellNib = [UINib nibWithNibName:@"TicketTableViewCell" bundle:nil];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"event_data.json"];
        
        if (filePath!=NULL) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            NSDictionary *jsonObject= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"Error parsing JSON.");
            }
            NSArray *events =[[jsonObject objectForKey:@"data"]objectForKey:@"events"];
            for (NSDictionary *evnt  in events) {
                
                [[NSUserDefaults standardUserDefaults]setObject:[evnt objectForKey:@"idEvent"] forKey:@"event_id"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[evnt objectForKey:@"maxTicketEvent"] forKey:@"maxTicketEvent"];

                
                [[NSUserDefaults standardUserDefaults]synchronize];
                break;
            }
            
            /*NSArray *discount =[[jsonObject objectForKey:@"data"]objectForKey:@"discounts"];
            for (NSDictionary *disc  in discount) {
                if ([[disc objectForKey:@"discountName"] isEqualToString:@"app"]) {
                    [[NSUserDefaults standardUserDefaults]setObject:disc[@"discountPercent"] forKey:@"event_discount"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    break;
                }
            }*/
           NSMutableArray* innerticketList = [[jsonObject objectForKey:@"data"] objectForKey:@"ticket_type"];
            
            ticketList = [NSMutableArray new];
            NSMutableArray *myArray =[NSMutableArray new];
            for (NSDictionary*inner in innerticketList) {
                NSMutableDictionary *copy=[[NSMutableDictionary alloc]initWithDictionary:inner];
                [copy setObject:@"0" forKey:@"ticketPaid"];
                [myArray addObject:copy];
            }
            NSSortDescriptor*  brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticketName" ascending:NO];
            NSArray*   sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            ticketList = [NSMutableArray arrayWithArray:[myArray sortedArrayUsingDescriptors:sortDescriptors]];
            
            for (NSDictionary*tkct in ticketList) {
                [[NSUserDefaults standardUserDefaults]setObject:tkct[@"ticketCurrency"] forKey:@"ticketCurrency"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                break;
            }
            haveEventData=YES;
        }else{
            haveEventData=NO;
        }
        

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
    
    self.ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ticket setImage:[UIImage imageNamed:@"next_dark"] forState:UIControlStateNormal];
    [self.ticket setTitleColor:[self getUIColorObjectFromHexString:@"#575756" alpha:1] forState:UIControlStateNormal];
    [self.ticket setTitle:@"salta" forState:UIControlStateNormal];
    [self.ticket setFrame:CGRectMake(0, 3, 54, 44)];
    self.ticket.titleLabel.font = [UIFont fontWithName:@"PierSans" size:19];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.ticket];
    
    
    totalTicketSelected=0;
    string = @"Scegli il tipo di biglietto:";

}



-(void)setupArcBtn:(UIButton*)arcBtn{
    // the space between the image and text
    
    // lower the text and push it left so it appears centered
    //  below the image
    arcBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - 33, 12, 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    arcBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                              23, 14, 0.0, 8.0);
    arcBtn.contentEdgeInsets = UIEdgeInsetsMake(
                                                0.0, -7, 0.0, 8.0);
    arcBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupArcBtn:self.ticket];
}

-(void)dismissWithNoSelection{


    
//InviteToBuyMainViewController *prnt = [
    if ([self.delegate respondsToSelector:@selector(dismisProcess)]) {
        
        
        
        
        
        [self.delegate dismisProcess];
    }

}

-(void)selectedTheDate:(NSString *)datetime{
    selectedDateForTicket=nil;
    selectedDateForTicket=datetime;
    NSLog(@"selected: %@",selectedDateForTicket);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // voila!
    
    NSDate*dateFromString = [dateFormatter dateFromString:selectedDateForTicket];
    
    
    
    
    [dateFormatter setDateFormat:@"dd/MM"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    [self updateTitle:[NSString stringWithFormat:@"Scegli il tipo di biglietto per il giorno %@",stringDate]];
    
}

-(void)showDattimePopUp{
    
   DatetimeViewController* datepopup=[[DatetimeViewController alloc]initWithNibName:@"DatetimeViewController" bundle:nil];
    datepopup.delegate=self;
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    datepopup.view.frame = CGRectMake(0, -window.bounds.size.height, window.bounds.size.width, 0);
    [window addSubview:datepopup.view];
    /*Calling the addChildViewController: method also calls
     the child’s willMoveToParentViewController: method automatically */
    //[self addChildViewController:newViewController];
    
    [self addChildViewController:datepopup];
    
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         datepopup.view.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         [self didMoveToParentViewController:self];
                         
                         
                         
                     }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self showDattimePopUp];
    
 
    
    // Do any additional setup after loading the view.
    self.goButton.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.goButton.selectiveBordersColor = [UIColor blackColor];
    self.goButton.selectiveBordersWidth = 1.0;
    
    [self.ticketTableView registerNib:self.cellNib forCellReuseIdentifier:@"ticketCell"];
    self.ticketTableView.estimatedRowHeight = 44;
    self.ticketTableView.rowHeight = UITableViewAutomaticDimension;
    self.ticketTableView.delegate=self;
    self.ticketTableView.dataSource=self;
    ticketAmount = 0;
    
    totalSelectedPrice = 0.00;
    totalTickets = [[NSMutableArray alloc]init];
    summaryDict = [[NSMutableDictionary alloc]init];
    [self.goButton addTarget:self action:@selector(showallticket:) forControlEvents:UIControlEventTouchUpInside];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alertContainerVisible"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"curretn ticket list: %@",ticketList);
    

}
/*-(void)updateAllData:(id)sender{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile procedere all’acquisto"
                                                                        message: @"Si prega di selezionare almeno un biglietto."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                 style: UIAlertActionStyleDefault
                                                               handler: ^(UIAlertAction *action) {
                                                                   NSLog(@"ok button tapped!");
                                                                   
                                                                   
                                                                   
                                                               }];
    
    [controller addAction: alertActionConfirm];
    
    
    
    
    [self presentViewController: controller animated: YES completion: nil];
    return;
}*/
-(void)clearDataToBuy{

}
-(void)showallticket:(id)sender{
    //  NSLog(@"all tickets: %@",summaryDict);
    summaryTickets = [[NSMutableArray alloc]init];
    NSLog(@"total tickets: %ld",(long)totalTicketSelected);
    totalTicketSelected=0;
   /* NSMutableArray *normalClear = [NSMutableArray new];
    for (NSDictionary *aa in totalTickets) {
        NSMutableDictionary *dd=[[NSMutableDictionary alloc]initWithDictionary:aa];
        [dd removeObjectForKey:@"how_much"];
        [normalClear addObject:dd];
    }*/
   /* if(totalTicketSelected>10){
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Numero massimo di biglietti raggiunti."
                                                                            message: @"Puoi ordinare al massimo 10 biglietti."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
        
    }*/
    
   // NSLog(@"total  normal tickets: %@",totalTickets);

    
   // NSCountedSet *filter = [NSCountedSet setWithArray:totalTickets];
    // NSLog(@"%@", @([filter countForObject:@"2"])); // Outputs 3
    for (NSDictionary *item in ticketList) {
        NSMutableDictionary * intern = [[NSMutableDictionary alloc]initWithDictionary:item];
        NSInteger count = [[item objectForKey:@"ticketPaid"]integerValue];
        // NSLog(@"the obj ' %@ ' appears %ld times in the array",item,(long)count);
       // [intern setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"ticketPaid"];
       // float result = ((float)[item[@"fullPrice"]floatValue ]*(float)[[[NSUserDefaults standardUserDefaults]objectForKey:@"event_discount"]floatValue])/100;
        [intern setObject:[NSString stringWithFormat:@"%.02f",[item[@"fullPrice"]floatValue ]*count] forKey:@"partialAmount"];
       // [intern setObject:@"0" forKey:@"owner"]; 

        
        totalTicketSelected+=count;
        // [summaryDict addEntriesFromDictionary:intern];
        if (count>0) {
            [summaryTickets addObject:intern];

        }
        
        
    }
    NSLog(@"total ticket: %ld",totalTicketSelected);
    NSLog(@"summary tickets: %@",summaryTickets);

    if(totalTicketSelected>[[[NSUserDefaults standardUserDefaults]objectForKey:@"maxTicketEvent"]integerValue]){
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Numero massimo di biglietti raggiunti."
                                                                            message: [NSString stringWithFormat:@"Puoi ordinare al massimo %@ biglietti.",[[NSUserDefaults standardUserDefaults]objectForKey:@"maxTicketEvent"]]
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
        
    }
    if (summaryTickets.count==0) {
        NSLog(@" please select something first");
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Impossibile procedere all’acquisto."
                                                                            message: @"Si prega di selezionare almeno un biglietto."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction *action) {
                                                                       NSLog(@"ok button tapped!");
                                                                       
                                                                   
                                                                       
                                                                   }];
        
        [controller addAction: alertActionConfirm];
        
     
        
        
        [self presentViewController: controller animated: YES completion: nil];
        return;

        
        
    }else{
        // API.delegate=self;
       
        
        
                if ([delegate respondsToSelector:@selector(nextSceneWithSummaryData:andToken:andDTime:)]) {
                    [delegate nextSceneWithSummaryData:summaryTickets andToken:TOKENIZATION_KEY andDTime:selectedDateForTicket];
                    
        
        
        
        
        //  [API getPaymentTokenOnView:self.view];
    }
}
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ticketList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketCell" forIndexPath:indexPath];
    NSDictionary *ticketObj = [ticketList objectAtIndex:indexPath.row];
    // Configure Cell
    //[cell.textLabel setText:[NSString stringWithFormat:@"Row %i in Section %i", [indexPath row], [indexPath section]]];
    
    
   // float result = ((float)[ticketObj[@"fullPrice"]floatValue ]*(float)[[[NSUserDefaults standardUserDefaults]objectForKey:@"event_discount"]floatValue])/100;
    /* float total = [totalField.text floatValue];
     float percent = [percentField.text floatValue] / 100.0f;
     float answer = total * percent;*/
    cell.ticketNameLabel.text = ticketObj[@"ticketName"];
    [cell setFinalPrice:[NSString stringWithFormat:@"%.02f",[ticketObj[@"fullPrice"]floatValue ]] ];
    cell.preiceLabel.text =[NSString stringWithFormat:@"%.02f %@",[ticketObj[@"fullPrice"]floatValue ],ticketObj[@"ticketCurrency"]] ;
    cell.delegate = self;
    return cell;
}
-(void)incrementBy:(NSInteger)value type:(NSString *)type atIndexPath:(TicketTableViewCell *)cell{
    // NSIndexPath *indexPath = [self.ticketTableView indexPathForCell:cell];
    // NSLog(@"ticket total: %f",cell.finalPrice.floatValue*value);
    
    //[totalTickets addObject:[ticketList objectAtIndex:indexPath.row]];
    // totalSelectedPrice= totalSelectedPrice + cell.finalPrice.floatValue;
    // [self setAttrsText];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    

    
    
    TicketTableViewCell *cell = [self.ticketTableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"get and pass this tixke number: %ld index %@",(long)[cell getCurrentTicketNumber],indexPath);
    
    NSDictionary * item = [ticketList objectAtIndex:indexPath.row];
   if( ![[NSUserDefaults standardUserDefaults]boolForKey:@"alertContainerVisible"]){
       [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"alertContainerVisible"];
       [[NSUserDefaults standardUserDefaults]synchronize];
       [self alertMessageticketName:item[@"ticketName"] ticketDescription:item[@"ticketDescription"] amountTicket:[cell getCurrentTicketNumber] indexPath:indexPath limit:[[item objectForKey:@"maxTicketAvailable"]integerValue]];
 
    }
    
}
-(void)alertMessageticketName:(NSString*)ticketname ticketDescription:(NSString*)ticketdescription amountTicket:(NSInteger)initialcount indexPath:(NSIndexPath*)index limit:(NSInteger)limit
{
    
    
    
    AlertViewController* content = [[AlertViewController alloc]initWithNibName:@"AlertViewController" bundle:nil];
    content.delegate=self;
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    content.view.frame = CGRectMake(0, -window.bounds.size.height, window.bounds.size.width, 0);
    [window addSubview:content.view];
    /*Calling the addChildViewController: method also calls
     the child’s willMoveToParentViewController: method automatically */
    //[self addChildViewController:newViewController];
    
    [self addChildViewController:content];
    
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         content.view.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         [self didMoveToParentViewController:self];
                         
                         [content setTicketName:ticketname ticketDescription:ticketdescription andCount:initialcount indexPath:index limit:limit];
                         
                         
                     }];
    
}
#pragma MARK alertdelegate
-(void)incrementBy:(NSInteger)value indexPath:(NSIndexPath *)index{
    TicketTableViewCell *cell = [self.ticketTableView cellForRowAtIndexPath:index];
    [cell setCurrentTicketNumber:value];
    [cell.ticketCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)value] forState:UIControlStateNormal];
    totalSelectedPrice= totalSelectedPrice + cell.finalPrice.floatValue;
    [self setAttrsText];
    
    NSMutableDictionary *current=[[NSMutableDictionary alloc]initWithDictionary:[ticketList objectAtIndex:index.row]];
   // [totalTickets addObject:[ticketList objectAtIndex:index.row]];
    
    NSInteger curPaid= [[current objectForKey:@"ticketPaid"]integerValue];
    curPaid++;
    
            [current setObject:[NSString stringWithFormat:@"%ld",(long)curPaid] forKey:@"ticketPaid"];
    [ticketList replaceObjectAtIndex:index.row withObject:current];
   // NSLog(@"total + tickets: %@ %@",ticketList,index);

    
}
-(void)decrementBy:(NSInteger)value indexPath:(NSIndexPath *)index{
//
 //   NSLog(@"total tickets: %@",totalTickets);
    TicketTableViewCell *cell = [self.ticketTableView cellForRowAtIndexPath:index];
    [cell setCurrentTicketNumber:value];
    [cell.ticketCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)value] forState:UIControlStateNormal];
    
   // [totalTickets removeObject:[ticketList objectAtIndex:index.row]];
    totalSelectedPrice= totalSelectedPrice - cell.finalPrice.floatValue;
    [self setAttrsText];
    
    NSMutableDictionary *current=[[NSMutableDictionary alloc]initWithDictionary:[ticketList objectAtIndex:index.row]];
    NSInteger curPaid= [[current objectForKey:@"ticketPaid"]integerValue];
    curPaid--;
    
    [current setObject:[NSString stringWithFormat:@"%ld",curPaid] forKey:@"ticketPaid"];
    [ticketList replaceObjectAtIndex:index.row withObject:current];
   
    
  //  NSLog(@"total - tickets: %@ %@",ticketList,index);

    

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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    label= [[FooterLabel alloc]initWithFrame:CGRectZero];
    UIFont *font = [UIFont fontWithName:@"PierSans" size:14.0];
    NSString *string = [NSString stringWithFormat:@"Totale: %.02f %@",totalSelectedPrice,[[NSUserDefaults standardUserDefaults]objectForKey:@"ticketCurrency"]];
    
    NSMutableAttributedString *attrstr =[[NSMutableAttributedString alloc] initWithString:string];
    
    [attrstr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [attrstr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    
    label.attributedText =attrstr;
    label.textAlignment=NSTextAlignmentRight;
    label.numberOfLines=1;
    [label sizeToFit];
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  25;
    
}
-(void)setAttrsText{
    UIFont *font = [UIFont fontWithName:@"PierSans" size:14.0];
    NSString *string = [NSString stringWithFormat:@"Totale: %.02f %@",totalSelectedPrice,[[NSUserDefaults standardUserDefaults]objectForKey:@"ticketCurrency"]];
    
    NSMutableAttributedString *attrstr =[[NSMutableAttributedString alloc] initWithString:string];
    
    [attrstr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [attrstr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    
    label.attributedText =attrstr;
    
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

@end
