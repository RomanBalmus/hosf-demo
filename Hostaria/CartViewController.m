//
//  CartViewController.m
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"
#import "ProductWineListViewController.h"
#import "ProductToBuy.h"
#import "CheckoutViewController.h"
@interface CartViewController (){
    CGFloat originX;
    UIImageView *circle;
    NSMutableArray * cartItems;
    NSArray *_pickerData;
    NSIndexPath *selectedIndexPath;

    UIBarButtonItem *editBtn;
    UIBarButtonItem *checkoutBtn;
    UITextField *activeTextField;
    UIPickerView *thePickerView;


}
@property (nonatomic, strong) UINib *cartCell;

@end

@implementation CartViewController
-(void)LoadIt{
    [self updateCartTable];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"init cart");
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCartTable) name:@"updatecarttable" object:nil];

    }
    return self;
}

-(NSMutableArray*)generateDataSourceQuantity{
    NSMutableArray *ret=[[NSMutableArray alloc]init];
    
    for (int i=0;i<100;i++) {
        [ret addObject:[NSString stringWithFormat:@"%d",i+1]];
        
    }
    
    
    return ret;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cartCell = [UINib nibWithNibName:@"CartCell" bundle:nil];
    
    [self.cartTableView registerNib:self.cartCell forCellReuseIdentifier:@"CartCell"];
    // Do any additional setup after loading the view from its nib.
    self.cartTableView.delegate=self;
    self.cartTableView.dataSource=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCartTable) name:@"updateCartTable" object:nil];
    
    
    activeTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    [self.view addSubview:activeTextField];
    API.delegate=self;
    
    /* [[NSUserDefaults standardUserDefaults] addObserver:self
     forKeyPath:@"cart_items" options:NSKeyValueObservingOptionNew
     context:NULL];*/
    
    
    _pickerData=[self generateDataSourceQuantity];
  //  self.thePickerView.dataSource = self;
  //  self.thePickerView.delegate = self;
     editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Modifica" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked:)];
    checkoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Acquista" style:UIBarButtonItemStylePlain target:self action:@selector(checkOut:)];

    self.navigationItem.leftBarButtonItem = editBtn;
    self.navigationItem.rightBarButtonItem = checkoutBtn;
    [self pickerview:self];

}


-(void)pickerview:(id)sender{
    thePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    thePickerView.showsSelectionIndicator = YES;
    thePickerView.dataSource = self;
    thePickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    activeTextField.inputView = thePickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    //UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects: [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    activeTextField.inputAccessoryView = toolBar;
}
#pragma mark - doneTouched
- (void)cancelTouched:(UIBarButtonItem *)sender{
    // hide the picker view
    [activeTextField resignFirstResponder];
}
#pragma mark - doneTouched
- (void)doneTouched:(UIBarButtonItem *)sender{
    // hide the picker view
    [activeTextField resignFirstResponder];
    // perform some action
}
/*

-(void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject
                       change:(NSDictionary *)aChange context:(void *)aContext
{
    //
    NSLog(@"changes key: %@",aKeyPath);
    NSLog(@"changes obj: %@",anObject);

    NSLog(@"changes here: %@",aChange);
}*/
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateCartTable];

}
-(void)updateTitle{
    if (cartItems.count>0) {
     float   totalAmount=0.0;
        [checkoutBtn setEnabled:YES];
        [editBtn setEnabled:YES];

        NSInteger prodsnumber=0;
        for (ProductToBuy*prd in cartItems) {
            
            
            prodsnumber=prodsnumber+prd.quantity.integerValue;
            totalAmount= totalAmount + (prd.price.floatValue*prd.quantity.integerValue);
            prd.productTotalPrice=[NSString stringWithFormat:@"%.02f",(prd.price.floatValue*prd.quantity.integerValue)];

        }
        
        
        
        
        [self.ttlLbl setHidden:NO];
        
        NSString * productString =nil;
        
        if (cartItems.count==1) {
            productString=@"Prodotto";
        }else{
            productString=@"Prodotti";
        }
        
        self.ttlLbl.text = [NSString stringWithFormat:@"%lu %@: Totale (escluso spedizione) %.02f €",(unsigned long)prodsnumber,productString,totalAmount];
        
        [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",(long)prodsnumber]];

        
    }else{
        [self.ttlLbl setHidden:YES];
        [checkoutBtn setEnabled:NO];
        [editBtn setEnabled:NO];

    }
    
    
    NSLog(@"update title");
}
-(void)updateCartTable{
    
    
    
    NSLog(@"update cart from init");
    cartItems=[NSMutableArray new];
    
    NSMutableArray *carts=[NSMutableArray new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cart_items"] != nil) {
        [carts addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_items"]];
        NSLog(@"data inside: %@",carts);
    }

    for (NSDictionary *clr in carts) {

        ProductToBuy * prd=[[ProductToBuy alloc]init];
        
        
        prd._id=[clr objectForKey:@"productId"];
        prd.name=[clr objectForKey:@"productName"];
        prd.price=[clr objectForKey:@"productPrice"];
        prd.quantity=[clr objectForKey:@"quantity"];//[NSString stringWithFormat:@"%lu",(unsigned long)[filter countForObject:clr]];
        prd.companyId=[clr objectForKey:@"productCompanyId"];
        prd.winecategoryId=[clr objectForKey:@"productTypeIcon"];
        prd.companyName=[clr objectForKey:@"productCompanyName"];

        
        [cartItems addObject:prd];
        // NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:clr.productName,@"name",clr.productCompanyName,@"companyName",clr.productCompanyId,@"companyId",clr.productId,@"productId", nil];
        
        

    }
    
    
    if (cartItems.count==0) {
        
        UIView *empty = [[UIView alloc]initWithFrame:self.view.frame];
        UILabel *emptylabel = [[UILabel alloc]init];
        emptylabel.textAlignment=NSTextAlignmentCenter;
        emptylabel.text=@"Carrello vuoto";
        [emptylabel sizeToFit];
        [empty addSubview:emptylabel];
        emptylabel.center=empty.center;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(empty.frame.size.width/2-100,20+emptylabel.frame.origin.y+ emptylabel.frame.size.height, 200, 44)];
        [btn setTitle:@"Vedi prodotti" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [empty addSubview:btn];
        
        [btn addTarget:self action:@selector(showProductController:) forControlEvents:UIControlEventTouchUpInside];
        [self.cartTableView setBackgroundView:empty];
        self.cartTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.cartTableView reloadData];
        [self updateTitle];
        [self.navigationController.tabBarItem setBadgeValue:nil];
        return;
    }else{
        [self.cartTableView setBackgroundView:nil];
        self.cartTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self updateTitle];
        
    }
    [self.cartTableView reloadData];
    

    
}
-(void)showProductController:(id)sender{
    
    
    ProductWineListViewController *detailViewController = [[ProductWineListViewController alloc] initWithNibName:@"ProductWineListViewController" bundle:nil];;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [cartItems count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    ProductToBuy *item = [cartItems objectAtIndex:indexPath.row];
    
    CartCell *cell = (CartCell*)[self.cartTableView dequeueReusableCellWithIdentifier:@"CartCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    NSLog(@"the cart: %@",[item debugDescription]);
    cell.cartItemLabelProduct.text=[NSString stringWithFormat:@"%@",item.name];
    cell.cartItemLabelCompany.text=[NSString stringWithFormat:@"%@",item.companyName];
    cell.cartItemLabelPrice.text=[NSString stringWithFormat:@"Prezzo:%@ €",item.price];
    [cell.quantityButton setTitle:[NSString stringWithFormat:@"Qtà°:%@",item.quantity] forState:UIControlStateNormal];
    cell.quantityButton.tag=indexPath.row;
    [cell.quantityButton addTarget:self action:@selector(selectQuantity:) forControlEvents:UIControlEventTouchUpInside];
    if ([item.winecategoryId isEqualToString:@"3"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_white"];
    }else if ([item.winecategoryId  isEqualToString:@"4"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_rose"];
    }else if ([item.winecategoryId isEqualToString:@"1"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_red"];
    }else if ([item.winecategoryId isEqualToString:@"5"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }else if ([item.winecategoryId isEqualToString:@"5"]) {
        cell.cartItemImage.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }
    
    [cell.quantityButton setTitle:[NSString stringWithFormat:@"Qtà: %@",item.quantity] forState:UIControlStateNormal];//=;
    cell.quantityButton.tag=indexPath.row;
    [cell.quantityButton addTarget:self action:@selector(selectQuantity:) forControlEvents:UIControlEventTouchUpInside];
   
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}



// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    
    NSLog(@"fixed here %@",[_pickerData objectAtIndex:row]);
    ProductToBuy *toupdate=[cartItems objectAtIndex:selectedIndexPath.row];
    
    toupdate.quantity=[NSString stringWithFormat:@"%@",[_pickerData objectAtIndex:row]];
    
    NSMutableArray *innerOld=[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_items"];
    NSMutableArray *innerNew=[NSMutableArray arrayWithArray:innerOld];
    
    
    for (int i=0; i<innerNew.count; i++) {
        NSDictionary *dct=[innerNew objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%@",[dct objectForKey:@"productId"]]isEqualToString:toupdate._id]) {
            
            NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:dct];
            [dict setObject:toupdate.quantity forKey:@"quantity"];
            
            [innerNew replaceObjectAtIndex:i withObject:dict];
            

            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cart_items"];
            
            [[NSUserDefaults standardUserDefaults]setObject:innerNew forKey:@"cart_items"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            break;
        }

    }
        
  
    [cartItems replaceObjectAtIndex:selectedIndexPath.row withObject:toupdate];

    [self.cartTableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self updateTitle];

    
}


-(void)selectQuantity:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    
    
    
        selectedIndexPath = [NSIndexPath indexPathForRow:btn.tag  inSection:0];
        
        ProductToBuy *selected=[cartItems objectAtIndex:selectedIndexPath.row];
        NSInteger value = selected.quantity.integerValue;
        
        [thePickerView selectRow:value-1 inComponent:0 animated:NO];
    [activeTextField becomeFirstResponder];
}
- (IBAction)clickedDoneButton:(id)sender {
    NSLog(@"clickdone");
    if (![self.pickerViewContainer isHidden]) {
        [self.pickerViewContainer setHidden:YES];
    }
    
    [self updateTitle];
}
-(void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        //assumption: self.myTableData is the model object
        //remove the row data at the given index in your table.
        
        ProductToBuy *toupdate=[cartItems objectAtIndex:indexPath.row];
        
        NSMutableArray *innerOld=[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_items"];
        NSMutableArray *innerNew=[NSMutableArray arrayWithArray:innerOld];
        
        
        for (int i=0; i<innerNew.count; i++) {
            NSDictionary *dct=[innerNew objectAtIndex:i];
            if ([[NSString stringWithFormat:@"%@",[dct objectForKey:@"productId"]]isEqualToString:toupdate._id]) {
                
                NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:dct];
                
                [innerNew removeObject:dict];
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cart_items"];
                
                [[NSUserDefaults standardUserDefaults]setObject:innerNew forKey:@"cart_items"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                break;
            }
            
        }
        
        
        
        
        
        [cartItems removeObjectAtIndex:indexPath.row];
        //the rows at the given index will be deleted with animation
        [self.cartTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        
        if (cartItems.count == 0) {
            NSLog(@"0 items");
            [editBtn setTitle:@"Modifica"];
            [self updateCartTable];

        }else{
            [self updateTitle];
  
        }

    }
}

- (IBAction)editBtnClicked:(id)sender {
    //we are not in edit mode yet
    if([self.cartTableView isEditing] == NO){
        //up the button so that the user knows to click it when they
        //are done
        [editBtn setTitle:@"Fine"];
        //set the table to editing mode
        [self.cartTableView setEditing:YES animated:YES];
    }else{
        //we are currently in editing mode
        //change the button text back to Edit
        [editBtn setTitle:@"Modifica"];
        //take the table out of edit mode
        [self.cartTableView setEditing:NO animated:YES];
    }
}



-(void)checkOut:(id)sender{
    CheckoutViewController *checkoutvc=[[CheckoutViewController alloc]initWithNibName:@"CheckoutViewController" bundle:nil];
    
    [checkoutvc setProducts:cartItems];
    UINavigationController *navctrl = [[UINavigationController alloc]initWithRootViewController:checkoutvc];
    [self presentViewController:navctrl animated:YES completion:nil];
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
