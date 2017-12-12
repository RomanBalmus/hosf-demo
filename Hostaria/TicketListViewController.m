//
//  TicketListViewController.m
//  Hostaria
//
//  Created by iOS on 29/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "TicketListViewController.h"
#import "AlertViewController.h"
#import "FooterLabel.h"

@interface TicketListViewController ()<AlertViewDelegate,APIManagerDelegate>{
    NSArray *ticketList;
    float totalSelectedPrice;
    NSMutableArray * totalTickets;
    FooterLabel *label;
    NSMutableDictionary *summaryDict;
    NSMutableArray * summaryTickets;

}
@property (nonatomic, strong) UINib *cellNib;

@end

@implementation TicketListViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.cellNib = [UINib nibWithNibName:@"TicketTableViewCell" bundle:nil];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"event_data.json"];
        
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
   
       /* NSArray *discount =[[jsonObject objectForKey:@"data"]objectForKey:@"discounts"];
        for (NSDictionary *disc  in discount) {
            if ([[disc objectForKey:@"discountName"] isEqualToString:@"app"]) {
                [[NSUserDefaults standardUserDefaults]setObject:disc[@"discountPercent"] forKey:@"event_discount"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                break;
            }
        }*/
        ticketList = [[jsonObject objectForKey:@"data"] objectForKey:@"ticket_type"];
        
        for (NSDictionary*tkct in ticketList) {
            [[NSUserDefaults standardUserDefaults]setObject:tkct[@"ticketCurrency"] forKey:@"ticketCurrency"];

            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        }
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //self.ticketTableView.contentOffset = CGPointMake(0, 1);
[self.ticketTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
   
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [self.ticketTableView registerNib:self.cellNib forCellReuseIdentifier:@"ticketCell"];
    self.ticketTableView.estimatedRowHeight = 44;
    self.ticketTableView.rowHeight = UITableViewAutomaticDimension;
    self.ticketTableView.delegate=self;
    self.ticketTableView.dataSource=self;
    ticketAmount = 0;
  
    totalSelectedPrice = 0.00;
    totalTickets = [[NSMutableArray alloc]init];
    summaryDict = [[NSMutableDictionary alloc]init];
    [self.nextScene addTarget:self action:@selector(showallticket:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)showallticket:(id)sender{
  //  NSLog(@"all tickets: %@",summaryDict);
    summaryTickets = [[NSMutableArray alloc]init];
    
    NSCountedSet *filter = [NSCountedSet setWithArray:totalTickets];
   // NSLog(@"%@", @([filter countForObject:@"2"])); // Outputs 3
    for (NSDictionary *item in filter) {
        NSMutableDictionary * intern = [[NSMutableDictionary alloc]initWithDictionary:item];
        NSInteger count = [filter countForObject: item];
       // NSLog(@"the obj ' %@ ' appears %ld times in the array",item,(long)count);
        [intern setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"ticketPaid"];
       // float result = ((float)[item[@"fullPrice"]floatValue ]*(float)[[[NSUserDefaults standardUserDefaults]objectForKey:@"event_discount"]floatValue])/100;
        [intern setObject:[NSString stringWithFormat:@"%.02f",[item[@"fullPrice"]floatValue ]*count] forKey:@"partialAmount"];
        
        
        
       // [summaryDict addEntriesFromDictionary:intern];
        [summaryTickets addObject:intern];

    }

    NSLog(@"summary tickets: %@",summaryTickets);
    if (summaryTickets.count==0) {
        NSLog(@" please select something first");
    }else{
       // API.delegate=self;
        [self nextWithSummaryData:summaryTickets andToken:TOKENIZATION_KEY]; //TO DO THIS ON PRODUCTION

        
      //  [API getPaymentTokenOnView:self.view];
    }
  
}

-(void)getPaymentToken:(APIManager *)manager didFailWithError:(NSError *)error{
    
}
-(void)getPaymentToken:(APIManager *)manager didFinishLoading:(id)item{
    NSDictionary *json = (NSDictionary*)item;
   // NSLog(@"payment token did finish: %@",json);
    if (summaryTickets!=NULL) {
        NSString *clientToken = [json objectForKey:@"data"];
       // NSLog(@"got token and go forward: %@ , %@",summaryTickets,clientToken);
        [self nextWithSummaryData:summaryTickets andToken:clientToken];

    }
}

-(void)nextWithSummaryData:(NSMutableArray*)sumData andToken:(NSString*)tokect{
    if ([self.delegate respondsToSelector:@selector(nextSceneWithSummaryData:andToken:)]) {
        [self.delegate nextSceneWithSummaryData:sumData andToken:tokect];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSLog(@"get and pass this tixke number: %ld",[cell getCurrentTicketNumber]);
    
    NSDictionary * item = [ticketList objectAtIndex:indexPath.row];
    [self alertMessageticketName:item[@"ticketName"] ticketDescription:item[@"ticketDescription"] amountTicket:[cell getCurrentTicketNumber] indexPath:indexPath limit:[[item objectForKey:@"maxTicketAvailable"]integerValue]];

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
-(void)dismissSelfFromParent{
    
}
#pragma MARK alertdelegate
-(void)incrementBy:(NSInteger)value indexPath:(NSIndexPath *)index{
    TicketTableViewCell *cell = [self.ticketTableView cellForRowAtIndexPath:index];
    [cell setCurrentTicketNumber:value];
    [cell.ticketCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)value] forState:UIControlStateNormal];
    [totalTickets addObject:[ticketList objectAtIndex:index.row]];
    totalSelectedPrice= totalSelectedPrice + cell.finalPrice.floatValue;
    [self setAttrsText];

}
-(void)decrementBy:(NSInteger)value indexPath:(NSIndexPath *)index{
    TicketTableViewCell *cell = [self.ticketTableView cellForRowAtIndexPath:index];
    [cell setCurrentTicketNumber:value];
    [cell.ticketCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)value] forState:UIControlStateNormal];

    [totalTickets removeObject:[ticketList objectAtIndex:index.row]];
    totalSelectedPrice= totalSelectedPrice - cell.finalPrice.floatValue;
    [self setAttrsText];

}



-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
