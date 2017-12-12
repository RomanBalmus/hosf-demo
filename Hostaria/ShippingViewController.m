//
//  ShippingViewController.m
//  Hostaria
//
//  Created by iOS on 06/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ShippingViewController.h"

@interface ShippingViewController (){
    NSMutableDictionary*user;
    NSMutableArray * countryList;
    NSLocale *locale ;
    NSMutableDictionary *shippData;
    NSMutableDictionary *facturedata;
    BOOL isSelectedSwitch;
    UIPickerView *pickerView;
}

@end

@implementation ShippingViewController
-(void)setUserData:(NSMutableDictionary *)dictionary{
    user=dictionary;
}
-(void)setFactureData:(NSMutableDictionary *)dictionary{
    facturedata=dictionary;
    
 
    NSLog(@"set inside 1: %@",dictionary);

    NSLog(@"set inside 2: %@",facturedata);


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
-(void)generateCoutryList{
    
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
    
    for (NSString *countryCode in countryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country];
    }
    
    NSDictionary *codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    
    
    
    countryList = [[NSMutableArray alloc]init];
    Country *Italy=[[Country alloc] init];
    Italy.more6b=@"0.00";
    Italy.less6b=@"0.00";
    Italy.countryIso=[codeForCountryDictionary objectForKey:@"Italy"];
    Italy.countryDisplayName=@"Italy";
    [countryList addObject:Italy];
    
    Country *Austria=[[Country alloc] init];
    Austria.more6b=@"10.00";
    Austria.less6b=@"45.00";
    Austria.countryIso=[codeForCountryDictionary objectForKey:@"Austria"];
    Austria.countryDisplayName=@"Austria";
    [countryList addObject:Austria];
    
    
    Country *Belgium=[[Country alloc] init];
    Belgium.more6b=@"10.00";
    Belgium.less6b=@"45.00";
    Belgium.countryIso=[codeForCountryDictionary objectForKey:@"Belgium"];
    Belgium.countryDisplayName=@"Belgium";
    [countryList addObject:Belgium];
    Country *Bulgaria=[[Country alloc] init];
    Bulgaria.more6b=@"10.00";
    Bulgaria.less6b=@"45.00";
    Bulgaria.countryIso=[codeForCountryDictionary objectForKey:@"Bulgaria"];
    Bulgaria.countryDisplayName=@"Bulgaria";
    [countryList addObject:Bulgaria];
    Country *UK=[[Country alloc] init];
    UK.more6b=@"10.00";
    UK.less6b=@"45.00";
    UK.countryIso=[codeForCountryDictionary objectForKey:@"United Kingdom"];
    UK.countryDisplayName=@"United Kingdom";
    [countryList addObject:UK];
    Country *TheCzechRepublic=[[Country alloc] init];
    TheCzechRepublic.more6b=@"10.00";
    TheCzechRepublic.less6b=@"45.00";
    TheCzechRepublic.countryIso=[codeForCountryDictionary objectForKey:@"Czech Republic"];
    TheCzechRepublic.countryDisplayName=@"Czech Republic";
    [countryList addObject:TheCzechRepublic];
    Country *Denmark=[[Country alloc] init];
    Denmark.more6b=@"10.00";
    Denmark.less6b=@"45.00";
    Denmark.countryIso=[codeForCountryDictionary objectForKey:@"Denmark"];
    Denmark.countryDisplayName=@"Denmark";
    [countryList addObject:Denmark];
    Country *Finland=[[Country alloc] init];
    Finland.more6b=@"10.00";
    Finland.less6b=@"45.00";
    Finland.countryIso=[codeForCountryDictionary objectForKey:@"Finland"];
    Finland.countryDisplayName=@"Finland";
    [countryList addObject:Finland];
    Country *France=[[Country alloc] init];
    France.more6b=@"10.00";
    France.less6b=@"45.00";
    France.countryIso=[codeForCountryDictionary objectForKey:@"France"];
    France.countryDisplayName=@"France";
    [countryList addObject:France];
    Country *Germany=[[Country alloc] init];
    Germany.more6b=@"10.00";
    Germany.less6b=@"45.00";
    Germany.countryIso=[codeForCountryDictionary objectForKey:@"Germany"];
    Germany.countryDisplayName=@"Germany";
    [countryList addObject:Germany];
    Country *Greece=[[Country alloc] init];
    Greece.more6b=@"10.00";
    Greece.less6b=@"45.00";
    Greece.countryIso=[codeForCountryDictionary objectForKey:@"Greece"];
    Greece.countryDisplayName=@"Greece";
    [countryList addObject:Greece];
    Country *Hungary=[[Country alloc] init];
    Hungary.more6b=@"10.00";
    Hungary.less6b=@"45.00";
    Hungary.countryIso=[codeForCountryDictionary objectForKey:@"Hungary"];
    Hungary.countryDisplayName=@"Hungary";
    [countryList addObject:Hungary];
    Country *NorthernIreland=[[Country alloc] init];
    NorthernIreland.more6b=@"10.00";
    NorthernIreland.less6b=@"45.00";
    NorthernIreland.countryIso=@"NIR";
    NorthernIreland.countryDisplayName=@"Northern Ireland";
    [countryList addObject:NorthernIreland];
    Country *Luxembourg=[[Country alloc] init];
    Luxembourg.more6b=@"10.00";
    Luxembourg.less6b=@"45.00";
    Luxembourg.countryIso=[codeForCountryDictionary objectForKey:@"Luxembourg"];
    Luxembourg.countryDisplayName=@"Luxembourg";
    [countryList addObject:Luxembourg];
    Country *Monaco=[[Country alloc] init];
    Monaco.more6b=@"10.00";
    Monaco.less6b=@"45.00";
    Monaco.countryIso=[codeForCountryDictionary objectForKey:@"Monaco"];
    Monaco.countryDisplayName=@"Monaco";
    [countryList addObject:Monaco];
    Country *TheNetherlands=[[Country alloc] init];
    TheNetherlands.more6b=@"10.00";
    TheNetherlands.less6b=@"45.00";
    TheNetherlands.countryIso=@"NL";
    TheNetherlands.countryDisplayName=@"The Netherlands";
    [countryList addObject:TheNetherlands];
    Country *Sweden=[[Country alloc] init];
    Sweden.more6b=@"10.00";
    Sweden.less6b=@"45.00";
    Sweden.countryIso=[codeForCountryDictionary objectForKey:@"Sweden"];
    Sweden.countryDisplayName=@"Sweden";
    [countryList addObject:Sweden];
    Country *Poland=[[Country alloc] init];
    Poland.more6b=@"10.00";
    Poland.less6b=@"45.00";
    Poland.countryIso=[codeForCountryDictionary objectForKey:@"Poland"];
    Poland.countryDisplayName=@"Poland";
    [countryList addObject:Poland];
    Country *Portugal=[[Country alloc] init];
    Portugal.more6b=@"10.00";
    Portugal.less6b=@"45.00";
    Portugal.countryIso=[codeForCountryDictionary objectForKey:@"Portugal"];
    Portugal.countryDisplayName=@"Portugal";
    [countryList addObject:Portugal];
    Country *Rumania=[[Country alloc] init];
    Rumania.more6b=@"10.00";
    Rumania.less6b=@"45.00";
    Rumania.countryIso=[codeForCountryDictionary objectForKey:@"Romania"];
    Rumania.countryDisplayName=@"Romania";
    [countryList addObject:Rumania];
    Country *Slovakia=[[Country alloc] init];
    Slovakia.more6b=@"10.00";
    Slovakia.less6b=@"45.00";
    Slovakia.countryIso=[codeForCountryDictionary objectForKey:@"Slovakia"];
    Slovakia.countryDisplayName=@"Slovakia";
    [countryList addObject:Slovakia];
    Country *Slovenia=[[Country alloc] init];
    Slovenia.more6b=@"10.00";
    Slovenia.less6b=@"45.00";
    Slovenia.countryIso=[codeForCountryDictionary objectForKey:@"Slovenia"];
    Slovenia.countryDisplayName=@"Slovenia";
    [countryList addObject:Slovenia];
    Country *Spain=[[Country alloc] init];
    Spain.more6b=@"10.00";
    Spain.less6b=@"45.00";
    Spain.countryIso=[codeForCountryDictionary objectForKey:@"Spain"];
    Spain.countryDisplayName=@"Spain";
    [countryList addObject:Spain];
    
    Country *Cyprus=[[Country alloc] init];
    Cyprus.more6b=@"15.00";
    Cyprus.less6b=@"60.00";
    Cyprus.countryIso=[codeForCountryDictionary objectForKey:@"Cyprus"];
    Cyprus.countryDisplayName=@"Cyprus";
    [countryList addObject:Cyprus];
    Country *Estonia=[[Country alloc] init];
    Estonia.more6b=@"15.00";
    Estonia.less6b=@"60.00";
    Estonia.countryIso=[codeForCountryDictionary objectForKey:@"Estonia"];
    Estonia.countryDisplayName=@"Estonia";
    [countryList addObject:Estonia];
    Country *Latvia=[[Country alloc] init];
    Latvia.more6b=@"15.00";
    Latvia.less6b=@"60.00";
    Latvia.countryIso=[codeForCountryDictionary objectForKey:@"Latvia"];
    Latvia.countryDisplayName=@"Latvia";
    [countryList addObject:Latvia];
    Country *Lithuania=[[Country alloc] init];
    Lithuania.more6b=@"15.00";
    Lithuania.less6b=@"60.00";
    Lithuania.countryIso=[codeForCountryDictionary objectForKey:@"Lithuania"];
    Lithuania.countryDisplayName=@"Lithuania";
    [countryList addObject:Lithuania];
    Country *Malta=[[Country alloc] init];
    Malta.more6b=@"15.00";
    Malta.less6b=@"60.00";
    Malta.countryIso=[codeForCountryDictionary objectForKey:@"Malta"];
    Malta.countryDisplayName=@"Malta";
    [countryList addObject:Malta];
    Country *NORWAY=[[Country alloc] init];
    NORWAY.more6b=@"15.00";
    NORWAY.less6b=@"54.00";
    NORWAY.countryIso=[codeForCountryDictionary objectForKey:@"Norway"];
    NORWAY.countryDisplayName=@"Norway";
    [countryList addObject:NORWAY];
    Country *SWITZERLAND=[[Country alloc] init];
    SWITZERLAND.more6b=@"15.00";
    SWITZERLAND.less6b=@"54.00";
    SWITZERLAND.countryIso=[codeForCountryDictionary objectForKey:@"Switzerland"];
    SWITZERLAND.countryDisplayName=@"Switzerland";
    [countryList addObject:SWITZERLAND];
    Country *LICHTENSTEIN=[[Country alloc] init];
    LICHTENSTEIN.more6b=@"15.00";
    LICHTENSTEIN.less6b=@"54.00";
    LICHTENSTEIN.countryIso=[codeForCountryDictionary objectForKey:@"Liechtenstein"];
    LICHTENSTEIN.countryDisplayName=@"Liechtenstein";
    [countryList addObject:LICHTENSTEIN];
    Country *AUSTRALIA=[[Country alloc] init];
    AUSTRALIA.more6b=@"65.00";
    AUSTRALIA.less6b=@"115.00";
    AUSTRALIA.countryIso=[codeForCountryDictionary objectForKey:@"Australia"];
    AUSTRALIA.countryDisplayName=@"Australia";
    [countryList addObject:AUSTRALIA];
    Country *BRAZIL=[[Country alloc] init];
    BRAZIL.more6b=@"70.00";
    BRAZIL.less6b=@"200.00";
    BRAZIL.countryIso=[codeForCountryDictionary objectForKey:@"Brazil"];
    BRAZIL.countryDisplayName=@"Brazil";
    [countryList addObject:BRAZIL];
    Country *CANADA=[[Country alloc] init];
    CANADA.more6b=@"70.00";
    CANADA.less6b=@"200.00";
    CANADA.countryIso=[codeForCountryDictionary objectForKey:@"Canada"];
    CANADA.countryDisplayName=@"Canada";
    [countryList addObject:CANADA];
    Country *CHILE=[[Country alloc] init];
    CHILE.more6b=@"65.00";
    CHILE.less6b=@"115.00";
    CHILE.countryIso=[codeForCountryDictionary objectForKey:@"Chile"];
    CHILE.countryDisplayName=@"Chile";
    [countryList addObject:CHILE];
    Country *CHINA=[[Country alloc] init];
    CHINA.more6b=@"65.00";
    CHINA.less6b=@"115.00";
    CHINA.countryIso=[codeForCountryDictionary objectForKey:@"China"];
    CHINA.countryDisplayName=@"China";
    [countryList addObject:CHINA];
    Country *HONGKONG=[[Country alloc] init];
    HONGKONG.more6b=@"65.00";
    HONGKONG.less6b=@"115.00";
    HONGKONG.countryIso=[codeForCountryDictionary objectForKey:@"Hong Kong"];
    HONGKONG.countryDisplayName=@"Hong Kong";
    [countryList addObject:HONGKONG];
    Country *ISRAEL=[[Country alloc] init];
    ISRAEL.more6b=@"80.00";
    ISRAEL.less6b=@"80.00";
    ISRAEL.countryIso=[codeForCountryDictionary objectForKey:@"Israel"];
    ISRAEL.countryDisplayName=@"Israel";
    [countryList addObject:ISRAEL];
    Country *JAPAN=[[Country alloc] init];
    JAPAN.more6b=@"115.00";
    JAPAN.less6b=@"115.00";
    JAPAN.countryIso=[codeForCountryDictionary objectForKey:@"Japan"];
    JAPAN.countryDisplayName=@"Japan";
    [countryList addObject:JAPAN];
    Country *NEWZEELAND=[[Country alloc] init];
    NEWZEELAND.more6b=@"65.00";
    NEWZEELAND.less6b=@"115.00";
    NEWZEELAND.countryIso=[codeForCountryDictionary objectForKey:@"New Zealand"];
    NEWZEELAND.countryDisplayName=@"New Zealand";
    [countryList addObject:NEWZEELAND];
    Country *PHILIPPINES=[[Country alloc] init];
    PHILIPPINES.more6b=@"95.00";
    PHILIPPINES.less6b=@"170.00";
    PHILIPPINES.countryIso=[codeForCountryDictionary objectForKey:@"Philippines"];
    PHILIPPINES.countryDisplayName=@"Philippines";
    [countryList addObject:PHILIPPINES];
    Country *SINGAPORE=[[Country alloc] init];
    SINGAPORE.more6b=@"65.00";
    SINGAPORE.less6b=@"115.00";
    SINGAPORE.countryIso=[codeForCountryDictionary objectForKey:@"Singapore"];
    SINGAPORE.countryDisplayName=@"Singapore";
    [countryList addObject:SINGAPORE];
    Country *SOUTHAFRICA=[[Country alloc] init];
    SOUTHAFRICA.more6b=@"95.00";
    SOUTHAFRICA.less6b=@"170.00";
    SOUTHAFRICA.countryIso=[codeForCountryDictionary objectForKey:@"South Africa"];
    SOUTHAFRICA.countryDisplayName=@"South Africa";
    [countryList addObject:SOUTHAFRICA];
    Country *SOUTHKOREA=[[Country alloc] init];
    SOUTHKOREA.more6b=@"65.00";
    SOUTHKOREA.less6b=@"115.00";
    SOUTHKOREA.countryIso=[codeForCountryDictionary objectForKey:@"South Korea"];
    SOUTHKOREA.countryDisplayName=@"South Korea";
    [countryList addObject:SOUTHKOREA];
    Country *USA=[[Country alloc] init];
    USA.more6b=@"95.00";
    USA.less6b=@"95.00";
    USA.countryIso=@"US";
    USA.countryDisplayName=@"United States";
    [countryList addObject:USA];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self generateCoutryList];

    shippData=[[NSMutableDictionary alloc]init];
    
  
    if ([self dictionary:user hasKey:@"email"] ) {
        [shippData setObject:[user objectForKey:@"email"] forKey:@"email"];
        
    }
    
    for (id v in self.myScrollView.subviews) {
        if ([v isKindOfClass:[UITextField class]]){
            UITextField*tf=(UITextField*)v;
            tf.delegate=self;
            [tf setBackgroundColor:[UIColor whiteColor]];
            
            if (tf.tag==41) {
                if ([self dictionary:user hasKey:@"name"] ) {
                    
                    [shippData setObject:[user objectForKey:@"name"] forKey:@"name"];
                    
                    [tf setText:[shippData objectForKey:@"name"]];
                }
                
                
            }
            if (tf.tag==42) {
                
                if ([self dictionary:user hasKey:@"surname"] ) {
                    [shippData setObject:[user objectForKey:@"surname"] forKey:@"surname"];
                    
                    [tf setText:[shippData objectForKey:@"surname"]];
                }
                
            }
            if (tf.tag==43) {
                    [shippData setObject:tf.text forKey:@"dayPhone"];
              
            }
            if (tf.tag==44) {
                [shippData setObject:tf.text forKey:@"eveningPhone"];
                
            } if (tf.tag==45) {
                [shippData setObject:tf.text forKey:@"cellPhone"];
                
            } if (tf.tag==46) {
                [shippData setObject:tf.text forKey:@"countryDisplayName"];
                [shippData setObject:tf.text forKey:@"countryIso"];
            } if (tf.tag==47) {
                [shippData setObject:tf.text forKey:@"addressLine1"];

            }  if (tf.tag==48) {
                [shippData setObject:tf.text forKey:@"addressLine2"];
                
            } if (tf.tag==49) {
                [shippData setObject:tf.text forKey:@"city"];
                
            } if (tf.tag==50) {
                [shippData setObject:tf.text forKey:@"province"];
                
            } if (tf.tag==51) {
                [shippData setObject:tf.text forKey:@"zipCode"];
                
            } if (tf.tag==52) {
                [shippData setObject:tf.text forKey:@"note"];
                
            }
         
            
            
        }
    }
    
    [self pickerview:self];

}
#pragma mark -  picker view Custom Method
-(void)pickerview:(id)sender{
     pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.countryTF.inputView = pickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    //UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects: [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.countryTF.inputAccessoryView = toolBar;
}
#pragma mark - doneTouched
- (void)cancelTouched:(UIBarButtonItem *)sender{
    // hide the picker view
    [self.countryTF resignFirstResponder];
}
#pragma mark - doneTouched
- (void)doneTouched:(UIBarButtonItem *)sender{
    // hide the picker view
    [self.countryTF resignFirstResponder];
    // perform some action
    Country *country=[countryList objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    self.countryTF.text = country.countryDisplayName;
    [shippData setObject:country.countryIso forKey:@"countryIso"];
    [shippData setObject:country.countryDisplayName forKey:@"countryDisplayName"];
}
#pragma mark - The Picker Challenge
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [countryList count];
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component{
    
    Country * country = [countryList objectAtIndex:row];
    
    return [NSString stringWithFormat:@"%@\nNO. 6 bottles = %@ €\nFurther 6 bottles = %@ €",country.countryDisplayName,country.less6b,country.more6b];
}
/*-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectZero];
    [label sizeToFit];
    Country * country = [countryList objectAtIndex:row];
    
    label.text= [NSString stringWithFormat:@"%@\nNO. 6 bottles = %@\nFurther 6 bottles = %@",country.countryDisplayName,country.less6b,country.more6b];
    return label;
}*/

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    Country * country = [countryList objectAtIndex:row];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=0;
    label.text= [NSString stringWithFormat:@"%@\nNO. 6 bottles = %@ €\nFurther 6 bottles = %@ €",country.countryDisplayName,country.less6b,country.more6b];
    [label sizeToFit];
  
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 75;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (![[countryList objectAtIndex:row] isKindOfClass:[Country class]]) {
        return;
    }
    Country * country = [countryList objectAtIndex:row];

    self.countryTF.text = country.countryDisplayName;
    [shippData setObject:country.countryIso forKey:@"countryIso"];
    [shippData setObject:country.countryDisplayName forKey:@"countryDisplayName"];
    if ([_delegate respondsToSelector:@selector(updateTitle:)]) {
        [_delegate updateTitle:country];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UIColor *color = [UIColor whiteColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    [textField setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"end editing");
    
    switch (textField.tag) {
        case 41:
            [shippData setObject:textField.text forKey:@"name"];
            break;
        case 42:
            [shippData setObject:textField.text forKey:@"surname"];
            break;
        case 43:
            [shippData setObject:textField.text forKey:@"dayPhone"];
            break;
        case 44:
            [shippData setObject:textField.text forKey:@"eveningPhone"];
            break;
        case 45:
            [shippData setObject:textField.text forKey:@"cellPhone"];
            break;
        case 47:
            [shippData setObject:textField.text forKey:@"addressLine1"];
            break;
        case 48:
            [shippData setObject:textField.text forKey:@"addressLine2"];
            break;
        case 49:
            [shippData setObject:textField.text forKey:@"city"];
            break;
        case 50:
            [shippData setObject:textField.text forKey:@"province"];
            break;
        case 51:
            [shippData setObject:textField.text forKey:@"zipCode"];
            break;
        case 52:
            [shippData setObject:textField.text forKey:@"note"];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonCliked:(id)sender {
    
    BOOL isGoodData=YES;
    for (id v in self.myScrollView.subviews) {
        if ([v isKindOfClass:[UITextField class]]){
            UITextField*tf=(UITextField*)v;
            if (tf.tag==41 || tf.tag==42 || tf.tag==43|| tf.tag==46|| tf.tag==47|| tf.tag==49|| tf.tag==51) {
                if (tf.text.length==0) {
                    NSLog(@"some of obbligatory fields empty");
                    
                    UIColor *color = [UIColor whiteColor];
                    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Dato obbligatorio" attributes:@{NSForegroundColorAttributeName: color}];
                    
                    [tf setBackgroundColor:[UIColor redColor]];
                    
                    
                    [self.myScrollView scrollRectToVisible:tf.frame animated:YES];
                    isGoodData=NO;
                    break;
                    
                }
            }
        }
    }
    
    
    
    NSLog(@"start to store data %@ data is good: %d",shippData,isGoodData);
    
    
    if (isGoodData) {
        
      
            if ([self.delegate respondsToSelector:@selector(shippData:)]) {
                [shippData removeObjectForKey:@"vatNumber"];
                [shippData removeObjectForKey:@"fiscalCode"];
                [shippData removeObjectForKey:@"businessName"];
                [self.delegate shippData:shippData];
            }
            
            
        
        
        
    }
    
    
}

- (IBAction)mySwitchChanged:(id)sender {
    
    UISwitch *swith = (UISwitch*)sender;
    isSelectedSwitch = swith.isOn;
    NSLog(@"switch status: %d",swith.isOn);
    if (isSelectedSwitch) {
        
        [shippData addEntriesFromDictionary:facturedata];
            // Set stop to YES when you wanted to break the iteration.
            for (id v in self.myScrollView.subviews) {
                if ([v isKindOfClass:[UITextField class]]){
                    UITextField*tf=(UITextField*)v;
                    tf.delegate=self;
                    [tf setBackgroundColor:[UIColor whiteColor]];
                    
                    if (tf.tag==41) {
                        
                            
                            [tf setText:[shippData objectForKey:@"name"]];
                        
                        
                        
                    }
                    if (tf.tag==42) {
                        
                        
                            [tf setText:[shippData objectForKey:@"surname"]];
                        
                        
                    }
                    if (tf.tag==43) {
                        [tf setText:[shippData objectForKey:@"dayPhone"]];

                    }
                    if (tf.tag==44) {
                        [shippData setObject:tf.text forKey:@"eveningPhone"];
                        [tf setText:[shippData objectForKey:@"eveningPhone"]];

                    } if (tf.tag==45) {
                        [shippData setObject:tf.text forKey:@"cellPhone"];
                        [tf setText:[shippData objectForKey:@"cellPhone"]];

                    } if (tf.tag==46) {
                        

                    } if (tf.tag==47) {
                        [tf setText:[shippData objectForKey:@"addressLine1"]];

                    }  if (tf.tag==48) {
                        [tf setText:[shippData objectForKey:@"addressLine2"]];

                    } if (tf.tag==49) {
                        [tf setText:[shippData objectForKey:@"city"]];

                    } if (tf.tag==50) {
                        [tf setText:[shippData objectForKey:@"province"]];

                    } if (tf.tag==51) {
                        [tf setText:[shippData objectForKey:@"zipCode"]];

                    } if (tf.tag==52) {
                        
                    }
                    
                    
                    
                }
            }

        NSLog(@"clicked data: %@",shippData);

        
    }else{
        [shippData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [shippData setObject:@"" forKey:key];
            
        }];
        for (id v in self.myScrollView.subviews) {
            if ([v isKindOfClass:[UITextField class]]){
                UITextField*tf=(UITextField*)v;
                tf.delegate=self;
                [tf setBackgroundColor:[UIColor whiteColor]];
            
                tf.text=@"";
                
                
            }
        }
        
        NSLog(@"shipp data: %@",shippData);
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

@end
