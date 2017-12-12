//
//  AlmostThereViewController.m
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "AlmostThereViewController.h"
#import "CheckMarkCell.h"
#import "HeaderLabel.h"

@interface AlmostThereViewController (){
    NSMutableDictionary *userData;
    NSMutableArray*ticketsSelected;
    NSIndexPath *lastSelectedIndexPath;
    BOOL readyToGo;
}
@property (nonatomic, strong) UINib *cellNibSelect;
@property (nonatomic, strong) NSMutableArray *selectedCells;

@end

@implementation AlmostThereViewController
@synthesize delegate;
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.cellNibSelect = [UINib nibWithNibName:@"CheckMarkCell" bundle:nil];
        
      
        
        
    }
    return self;
}

-(void)setDataToWorkWith:(id)data{
    userData = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)data];
    NSLog(@"almost here this data: %@",userData);
    
    ticketsSelected = [NSMutableArray arrayWithArray:[userData objectForKey:@"tickets"]];
    self.selectedCells = [NSMutableArray array];

    [self.ticketTableView reloadData];
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    readyToGo=NO;
    // Do any additional setup after loading the view.
    [self.ticketTableView registerNib:self.cellNibSelect forCellReuseIdentifier:@"checkMarkCell"];
    self.ticketTableView.estimatedRowHeight = 44;
    self.ticketTableView.rowHeight = UITableViewAutomaticDimension;
    self.ticketTableView.delegate=self;
    self.ticketTableView.dataSource=self;
    self.goButton.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.goButton.selectiveBordersColor = [UIColor blackColor];
    self.goButton.selectiveBordersWidth = 1.0;
    [self.goButton addTarget:self action:@selector(goToInsertDataIfNeed:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)goToInsertDataIfNeed:(id)sender{
    if (readyToGo) {
        [userData setObject:ticketsSelected forKey:@"tickets"];
        if ([delegate respondsToSelector:@selector(goToNextWithUserData:)]) {
            [delegate goToNextWithUserData:userData];
        }
    }
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ticketsSelected.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *ticketObj = [ticketsSelected objectAtIndex:indexPath.row];
   /* if (indexPath.row==0) {
     SelectTicketTypeCell*   cell = (SelectTicketTypeCell*)[tableView dequeueReusableCellWithIdentifier:@"selecttypecell" forIndexPath:indexPath];
        [cell setStackViewArray:[self buttonArray]];
        return cell;
    }*/
    
    
    /* float total = [totalField.text floatValue];
     float percent = [percentField.text floatValue] / 100.0f;
     float answer = total * percent;*/
   
  CheckMarkCell*   cell = [tableView dequeueReusableCellWithIdentifier:@"checkMarkCell" forIndexPath:indexPath];
    [cell fillButton:[self isRowSelectedOnTableView:tableView atIndexPath:indexPath]];
    cell.ticketCheckBtn.tag = indexPath.row;
    [cell.ticketCheckBtn addTarget:self action:@selector(clickedCheckMark:) forControlEvents:UIControlEventTouchUpInside];
    cell.ticketNameLabel.text = ticketObj[@"ticketName"];
    [cell setFinalPrice:[NSString stringWithFormat:@"%@",ticketObj[@"partialAmount"]] ];
    cell.preiceLabel.text =@"";//[NSString stringWithFormat:@"%@ %@",ticketObj[@"partialAmount"],ticketObj[@"ticketCurrency"]] ;
        return cell;
}
-(void)clickedCheckMark:(id)sender{
    UIButton*sbtn=(UIButton*)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:sbtn.tag inSection:0];
    if(lastSelectedIndexPath) {
        NSDictionary *selectedObj=[ticketsSelected objectAtIndex:lastSelectedIndexPath.row];

        NSMutableDictionary *ticketObj = [[NSMutableDictionary alloc]initWithDictionary:selectedObj];
        [ticketObj setObject:@"0" forKey:@"owner"];
        CheckMarkCell *lastCell = [self.ticketTableView cellForRowAtIndexPath:lastSelectedIndexPath];
        [lastCell fillButton:NO];
        [self.selectedCells removeObject:lastSelectedIndexPath];
        [ticketsSelected replaceObjectAtIndex:lastSelectedIndexPath.row withObject:ticketObj];
        [self.ticketTableView reloadRowsAtIndexPaths:@[lastSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    NSDictionary *selectedObj=[ticketsSelected objectAtIndex:path.row];

    CheckMarkCell *currentCell = [self.ticketTableView cellForRowAtIndexPath:path];
    [currentCell fillButton:YES];
    [self.selectedCells addObject:path];
    lastSelectedIndexPath = path;
    NSMutableDictionary *ticketObj = [[NSMutableDictionary alloc]initWithDictionary:selectedObj];
    [ticketObj setObject:@"1" forKey:@"owner"];
    NSLog(@"path: %@",path);
    [ticketsSelected replaceObjectAtIndex:lastSelectedIndexPath.row withObject:ticketObj];
    [self.ticketTableView reloadRowsAtIndexPaths:@[lastSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    readyToGo=YES;

}
-(BOOL)isRowSelectedOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    return ([self.selectedCells containsObject:indexPath]) ? YES : NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   /*
    if (indexPath.row==0) {
        SelectTicketTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [tableView beginUpdates];
        [cell changeCellStatus:YES];
        [tableView endUpdates];
    }*/

    if(lastSelectedIndexPath) {
        NSDictionary *selectedObj=[ticketsSelected objectAtIndex:lastSelectedIndexPath.row];

        NSMutableDictionary *ticketObj = [[NSMutableDictionary alloc]initWithDictionary:selectedObj];
        [ticketObj setObject:@"0" forKey:@"owner"];
        CheckMarkCell *lastCell = [tableView cellForRowAtIndexPath:lastSelectedIndexPath];
        [lastCell fillButton:NO];
        [self.selectedCells removeObject:lastSelectedIndexPath];
        [ticketsSelected replaceObjectAtIndex:lastSelectedIndexPath.row withObject:ticketObj];
        [self.ticketTableView reloadRowsAtIndexPaths:@[lastSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    NSDictionary *selectedObj=[ticketsSelected objectAtIndex:indexPath.row];

    CheckMarkCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    [currentCell fillButton:YES];
    [self.selectedCells addObject:indexPath];
    lastSelectedIndexPath = indexPath;
    NSMutableDictionary *ticketObj = [[NSMutableDictionary alloc]initWithDictionary:selectedObj];
    [ticketObj setObject:@"1" forKey:@"owner"];
    [ticketsSelected replaceObjectAtIndex:lastSelectedIndexPath.row withObject:ticketObj];
    [self.ticketTableView reloadRowsAtIndexPaths:@[lastSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    readyToGo=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HeaderLabel *labell= [[HeaderLabel alloc]initWithFrame:CGRectZero];
    UIFont *font = [UIFont fontWithName:@"PierSans" size:17.0];
    NSString *string = @"Clicca il riquadro corrispondente al tuo biglietto elettronico (unico e incedibile), che utilizzerai attraverso l’app Hostaria per usufruire delle degustazioni presso gli stand delle cantine.\n";
    
    NSMutableAttributedString *attrstr =[[NSMutableAttributedString alloc] initWithString:string];
    
    // [attrstr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [attrstr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    
    labell.attributedText =attrstr;
    labell.textAlignment=NSTextAlignmentCenter;
    labell.numberOfLines=0;
    labell.lineBreakMode=NSLineBreakByWordWrapping;
    [labell sizeToFit];
    [labell setTextColor:[self getUIColorObjectFromHexString:@"#808080" alpha:1]];
    [labell layoutIfNeeded];
    
    return labell;
}


/*- (NSArray *)buttonArray {
    UILabel *labl= [[UILabel alloc]init];
    [labl setText:@"dasdasd"];
    [labl sizeToFit];
    UIButton*btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 84)];
    [btn1 setTitle:@"1" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor yellowColor]];
    UILabel *labl2= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [labl2 setText:@"dasdasd"];
    return @[labl,btn1,labl2];
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
