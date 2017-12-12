//
//  MissingDataOrBuyController.m
//  Hostaria
//
//  Created by iOS on 24/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MissingDataOrBuyController.h"
#import "InsertDataCell.h"
#import "HeaderLabel.h"
#import "IQUIView+IQKeyboardToolbar.h"

@interface MissingDataOrBuyController ()<UITextFieldDelegate>{
    NSMutableDictionary *userData;
    NSMutableArray*keysMissingArray;
    BOOL taction;

}
@property (nonatomic, strong) UINib *cellNibSelect;

@end

@implementation MissingDataOrBuyController
@synthesize delegate;
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.cellNibSelect = [UINib nibWithNibName:@"InsertDataCell" bundle:nil];
        
        
        
        
    }
    return self;
}

-(void)setWelcome:(BOOL)action{
    taction=action;
}
-(void)setDataToWorkWith:(id)data{
    keysMissingArray = [[NSMutableArray alloc]init];
    userData = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)data];
    NSLog(@"almost here this data: %@",userData);
    [keysMissingArray addObject:@"email"];
    if ([self dictionary:userData hasKey:@"name"]) {
    }else{
        [keysMissingArray addObject:@"name"];

    }
    if ([self dictionary:userData hasKey:@"surname"]) {
    }else{
        [keysMissingArray addObject:@"surname"];
        
    }
    if ([self dictionary:userData hasKey:@"loginType"]) {
        if ([[userData objectForKey:@"loginType"]isEqualToString:@"0"]) {
            [keysMissingArray addObject:@"password"];

        }
    }else{
        [keysMissingArray addObject:@"password"];

    }
    
   
    
    NSLog(@"missing keys:%@",keysMissingArray);
    [self.ticketTableView reloadData];
}
-(BOOL)dictionary:(NSDictionary*)info hasKey:(NSString*)key{
    BOOL haveKey;
    
    if (info[key]){
        NSLog(@"Exists");
        if( [info objectForKey:key] == nil ||
           [[info objectForKey:key] isEqual:[NSNull null]] ||
           [info objectForKey:key] == [NSNull null])
        {
            NSLog(@"key is null");
            
            haveKey = NO;
        }
        else
        {
            NSLog(@"%@",[info valueForKey:key]);
            haveKey = YES;
        }
    }else{
        NSLog(@"Does not exist");
        haveKey=NO;

    }
    
    
    return haveKey;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"tf tag: %ld",(long)textField.tag);
    switch (textField.tag) {
        case 0:
            if (textField.text>0) {
                [userData setObject:textField.text forKey:@"email"];
            }
            break;
        case 1:
            if (textField.text>0) {
                [userData setObject:textField.text forKey:@"name"];
            }
            break;
        case 2:
            if (textField.text>0) {
                [userData setObject:textField.text forKey:@"surname"];
            }
            break;
        case 3:
            if (textField.text>0) {
                [userData setObject:textField.text forKey:@"password"];
                [userData setObject:@"0" forKey:@"loginType"];

            }
            break;
        default:
            break;
    }
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.ticketTableView registerNib:self.cellNibSelect forCellReuseIdentifier:@"insertDataCell"];
    self.ticketTableView.estimatedRowHeight = 45;
    self.ticketTableView.rowHeight = UITableViewAutomaticDimension;
    self.ticketTableView.delegate=self;
    self.ticketTableView.dataSource=self;
    self.goButton.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.goButton.selectiveBordersColor = [UIColor blackColor];
    self.goButton.selectiveBordersWidth = 1.0;
    [self.goButton addTarget:self action:@selector(goToInsertDataIfNeed:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(NSDictionary *)getTheDataToRegister{
    return userData;
}
-(void)goToInsertDataIfNeed:(id)sender{
    NSLog(@"this data %@",userData);
    
    if ([self dictionary:userData hasKey:@"email"]&&[self dictionary:userData hasKey:@"name"]&&[self dictionary:userData hasKey:@"surname"]&&[self dictionary:userData hasKey:@"password"]) {
        NSLog(@"allgood");
        
        if (taction) {
            if ([delegate respondsToSelector:@selector(simpleRegisterCallUserData:)]) {
                [delegate simpleRegisterCallUserData:userData];
            }
            
           
        }else{
        
        
        if ([delegate respondsToSelector:@selector(goToFromMissingNextWithUserData:)]) {
            [delegate goToFromMissingNextWithUserData:userData];
        }
        }
    }else{
        NSLog(@"missing data");
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
    return keysMissingArray.count;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupArcBtn:self.ticket];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *ticketObj = [keysMissingArray objectAtIndex:indexPath.row];
    /* if (indexPath.row==0) {
     SelectTicketTypeCell*   cell = (SelectTicketTypeCell*)[tableView dequeueReusableCellWithIdentifier:@"selecttypecell" forIndexPath:indexPath];
     [cell setStackViewArray:[self buttonArray]];
     return cell;
     }*/
    
    
    /* float total = [totalField.text floatValue];
     float percent = [percentField.text floatValue] / 100.0f;
     float answer = total * percent;*/
    
    InsertDataCell*   cell = [tableView dequeueReusableCellWithIdentifier:@"insertDataCell" forIndexPath:indexPath];
    cell.inputTextField.delegate=self;

    if ([ticketObj isEqualToString:@"name"]) {
        [cell.inputTextField setPlaceholder:@"Nome"];
        cell.inputTextField.tag=1;

    }else if ([ticketObj isEqualToString:@"surname"]){
        [cell.inputTextField setPlaceholder:@"Cognome"];
        cell.inputTextField.tag=2;


    }else if ([ticketObj isEqualToString:@"email"]){
        cell.inputTextField.tag=0;
        [cell.inputTextField setPlaceholder:@"E-mail"];
        [cell.inputTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        if ([self dictionary:userData hasKey:@"email"]) {
            cell.inputTextField.text=[userData objectForKey:@"email"];
            [cell.inputTextField setUserInteractionEnabled:NO];
        }

    }else if ([ticketObj isEqualToString:@"password"]){
        [cell.inputTextField setPlaceholder:@"Password"];
        [cell.inputTextField setSecureTextEntry:YES];
        cell.inputTextField.tag=3;

    }
    
   
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 70;
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
    NSString *string = @"";//@"Clicca il riquadro corrispondente al tuo biglietto elettronico (unico e incedibile), che utilizzerai attraverso l’app Hostaria per usufruire delle degustazioni presso gli stand delle cantine.\n";
    if ([self dictionary:userData hasKey:@"loginType"]) {
        if ([[userData objectForKey:@"loginType"]isEqualToString:@"0"]) {
            string=@"Registrati con i tuoi dati per completare l'acquisto";
        }else{
            string=@"Inserisci i dati mancanti percompletare l'acquisto";
        }
    }else{
        string=@"Registrati con i tuoi dati per completare l'acquisto";
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
