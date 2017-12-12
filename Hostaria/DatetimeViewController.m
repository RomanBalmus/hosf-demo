//
//  DatetimeViewController.m
//  Hostaria
//
//  Created by iOS on 02/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "DatetimeViewController.h"
#import "DateCell.h"
#import "KTCenterFlowLayout.h"

@interface DatetimeViewController ()

@end

@implementation DatetimeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"event_data.json"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *jsonObject= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    
    self.dataArray=[[NSMutableArray alloc]init];
    NSArray *events =[[jsonObject objectForKey:@"data"]objectForKey:@"events"];
    for (NSDictionary *evnt  in events) {
        
        NSLog(@"vvvv:%@",evnt);
        
        
        NSString *start = [[evnt objectForKey:@"dateStart"]objectForKey:@"date"];
        
       /*
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];

        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        // voila!
        NSDate*   StartdateFromString = [dateFormatter dateFromString:start];*/
        
        NSString *end = [[evnt objectForKey:@"dateStop"]objectForKey:@"date"];
       /* NSDateFormatter *sdateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [sdateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];

        [sdateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
        // voila!
        NSDate*   enddateFromString = [sdateFormatter dateFromString:end];*/
       /* NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        
        components
        NSLog(@"days: %ld", [components day]);*/
        
        // minDate and maxDate represent your date range
       /* NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *days = [[NSDateComponents alloc] init];
        
        [gregorianCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];

        [days setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];
        
        NSInteger dayCount = -1;
        while ( TRUE ) {
            [days setDay: ++dayCount];
            NSDate *date = [gregorianCalendar dateByAddingComponents: days toDate: StartdateFromString options: 0];
            
            if ( [date compare: enddateFromString] == NSOrderedDescending )
                break;
            // Do something with date like add it to an array, etc.
            [self.dataArray addObject:date];
        }
       
        
        
        
        NSString *start = @"2010-09-01";
        NSString *end = @"2010-12-05";
        */
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
       // [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.

        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
        
      //  NSMutableArray *dates = [@[startDate] mutableCopy];
        
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        
        for (int i = 1; i < components.day+1; ++i) {
            NSDateComponents *newComponents = [NSDateComponents new];
            newComponents.day = i;
            
            NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents
                                                              toDate:startDate
                                                             options:0];
            [self.dataArray addObject:date];
        }
        
        [self.dataArray addObject:startDate];
        
        [self.dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        break;
    }
    
    
 

    
    
}
- (void)viewDidLoad {
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    UINib *cellNib = [UINib nibWithNibName:@"DateCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"DateCell"];
    
    /*
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(95, 81)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    */
    
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;
    [layout setItemSize:CGSizeMake(95, 81)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
   // [[UICollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self.collectionView setCollectionViewLayout:layout];

    
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.collectionView reloadData];
    
    self.cancelButton.layer.borderColor=[self getUIColorObjectFromHexString:@"#6F3222" alpha:1].CGColor;//  AD0020
    self.cancelButton.layer.borderWidth=1;
    self.cancelButton.layer.cornerRadius=15;
    
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *data = [self.dataArray objectAtIndex:indexPath.row];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:data]; // Get necessary date components
    
    NSLog(@"date: %@",data);
    static NSString *cellIdentifier = @"DateCell";
    
    DateCell *cell = (DateCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:([components month]-1)];

    
    cell.dayLbl.text=[NSString stringWithFormat:@"%ld",(long)[components day]];
    cell.monthLbl.text=@"";
    cell.yearLbl.text=monthName;////[NSString stringWithFormat:@"%ld",(long)[components year]];

    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if ([self.delegate respondsToSelector:@selector(selectedTheDate:)]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:[self.dataArray objectAtIndex:indexPath.row]]; // Convert date to string
        
        [self.delegate selectedTheDate:date];
        [self dismissSelf];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closePopup:(id)sender {
    [self dismissSelf];
    if ([self.delegate respondsToSelector:@selector(dismissWithNoSelection)]) {
        [self.delegate dismissWithNoSelection];
    }
}
-(void)dismissSelf{
    NSLog(@"dismiss self2222232");
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alertContainerVisible"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    /*if ([delegate respondsToSelector:@selector(dismissSelfFromParent)]) {
     [delegate dismissSelfFromParent];
     NSLog(@"dismiss self;from parent");
     }*/
}
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}
@end
