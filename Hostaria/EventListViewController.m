//
//  EventListViewController.m
//  Hostaria
//
//  Created by iOS on 29/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "EventListViewController.h"
#import "Service.h"
#import "EventCell.h"
#import "StandNoMapDetailViewController.h"

@interface EventListViewController (){
    RLMResults<Service *> *events;
    UINavigationController *parentNav;
    

}
@property (nonatomic, strong) UINib *eventCell;
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@end

@implementation EventListViewController
-(void)setupNavigation:(UINavigationController *)navctrl{
    parentNav=navctrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    self.eventCell = [UINib nibWithNibName:@"EventCell" bundle:nil];

    [self.eventTableView registerNib:self.eventCell forCellReuseIdentifier:@"EventCell"];

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self loadDataSource];
}

-(void)loadDataSource{
    
    events = [Service objectsWhere:[NSString stringWithFormat:@"serviceLocalType = '%@' or serviceLocalType = '%@' or serviceLocalType = '%@' or serviceLocalType = '%@'",TYPE_EVENT_AREA,TYPE_GEN_SPONSOR,TYPE_NORMAL_EVENT,TYPE_MONTE_VERONESE]];
    NSLog(@"events %@",[events debugDescription]);

    
    if (events.count==0) {
        
        
        UILabel *emptylabel = [[UILabel alloc]init];
        emptylabel.textAlignment=NSTextAlignmentCenter;
        emptylabel.text=@"Nessun evento presente";
        [emptylabel sizeToFit];
        [self.eventTableView setBackgroundView:emptylabel];
        self.eventTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.eventTableView reloadData];

        return;
    }else{
        [self.eventTableView setBackgroundView:nil];
        self.eventTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;


    }
    [self.eventTableView reloadData];
    
    
    

    
    self.sections = [NSMutableDictionary dictionary];
    for (Service *event in events)
    {
        // Reduce event start date to date components (year, month, day)
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.starttime];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:event];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];

}
- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (events.count==0) {
        return 0;
    }
    return [self.sections count];

    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
  

    
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Service *sEvent = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    EventCell *cell = (EventCell*)[self.eventTableView dequeueReusableCellWithIdentifier:@"EventCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    NSLog(@"the event: %@",[sEvent debugDescription]);
    cell.ttlLabel.text=[NSString stringWithFormat:@"%@\n%@\n%@",sEvent.name,sEvent.serviceNameDefinition,sEvent.address];
    
    
    
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd/MM/yy HH:mm"];
   // [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
    
    NSString *startDate = [f stringFromDate:sEvent.starttime];
    NSString *endDate = [f stringFromDate:sEvent.endtime];
    cell.subttlLabel.text=[NSString stringWithFormat:@"%@ - %@",startDate,endDate];
    
    
    
    if ([sEvent.serviceLocalType isEqualToString:TYPE_EVENT_AREA]) {
         cell.eventImgView.image = [UIImage imageNamed:@"ic_event"];
        
        
    } else if ([sEvent.serviceLocalType isEqualToString:TYPE_GEN_SPONSOR]) {
        cell.eventImgView.image = [UIImage imageNamed:@"ic_gen_sponsor"];
        
        
    }else if ([sEvent.serviceLocalType isEqualToString:TYPE_NORMAL_EVENT]) {
         cell.eventImgView.image = [UIImage imageNamed:@"ic_n_event"];
        

    }else if ([sEvent.serviceLocalType isEqualToString:TYPE_MONTE_VERONESE]) {
        cell.eventImgView.image=[UIImage imageNamed:@"ic_cheese"];
        
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    StandNoMapDetailViewController *detailViewController = [[StandNoMapDetailViewController alloc] initWithNibName:@"StandNoMapDetailViewController" bundle:nil];;
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];

    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Service *sEvent = [eventsOnThisDay objectAtIndex:indexPath.row];
    detailViewController.data = sEvent; // hand off the current product to the detail view controller

    
    [detailViewController setClicked:YES];
    [parentNav pushViewController:detailViewController animated:YES];
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
