//
//  ProductWineListViewController.m
//  Hostaria
//
//  Created by iOS on 05/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ProductWineListViewController.h"
#import "ResultsTableViewController.h"
#import "ProductToBuyCell.h"
#import "Product.h"
#import "Cellar.h"
#import "ProductToBuy.h"

@interface ProductWineListViewController (){
    NSIndexPath *selectedIndexPath;

}
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ResultsTableViewController *resultsTableController;
@property (nonatomic, strong) NSMutableArray *suggestions;
@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic, strong) UINib *cellNib;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@end

@implementation ProductWineListViewController

- (CGRect)frameForTabInTabBar:(UITabBar*)tabBar withIndex:(NSUInteger)index
{
    NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:[tabBar.items count]];
    for (UIView *view in tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")] && [view respondsToSelector:@selector(frame)]) {
            // check for the selector -frame to prevent crashes in the very unlikely case that in the future
            // objects thar don't implement -frame can be subViews of an UIView
            [tabBarItems addObject:view];
        }
    }
    if ([tabBarItems count] == 0) {
        // no tabBarItems means either no UITabBarButtons were in the subView, or none responded to -frame
        // return CGRectZero to indicate that we couldn't figure out the frame
        return CGRectZero;
    }
    
    // sort by origin.x of the frame because the items are not necessarily in the correct order
    [tabBarItems sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        if (view1.frame.origin.x < view2.frame.origin.x) {
            return NSOrderedAscending;
        }
        if (view1.frame.origin.x > view2.frame.origin.x) {
            return NSOrderedDescending;
        }
        NSAssert(NO, @"%@ and %@ share the same origin.x. This should never happen and indicates a substantial change in the framework that renders this method useless.", view1, view2);
        return NSOrderedSame;
    }];
    
    CGRect frame = CGRectZero;
    if (index < [tabBarItems count]) {
        // viewController is in a regular tab
        UIView *tabView = tabBarItems[index];
        if ([tabView respondsToSelector:@selector(frame)]) {
            frame = tabView.frame;
        }
    }
    else {
        // our target viewController is inside the "more" tab
        UIView *tabView = [tabBarItems lastObject];
        if ([tabView respondsToSelector:@selector(frame)]) {
            frame = tabView.frame;
        }
    }
    return frame;
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cellNib = [UINib nibWithNibName:@"ProductToBuyCell" bundle:nil];
    
    [self.productTableView registerNib:self.cellNib forCellReuseIdentifier:@"ProductToBuyCell"];
    self.productTableView.dataSource=self;
    self.productTableView.delegate=self;
    _resultsTableController = [[ResultsTableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.navigationItem.titleView = _searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fillTableViewWithData) name:@"updatestandlist" object:nil];
    [self fillTableViewWithData
     ];
    
    
    
   
   
   
}

-(void)fillTableViewWithData{
    self.suggestions = [NSMutableArray new];
    //RLMResults<Service *> *services_prem =[Service objectsWhere:[NSString stringWithFormat:@"serviceLocalType = '%@' or serviceLocalType = '%@'",TYPE_RISTOR,TYPE_SPECIAL_RISTOR]];
    RLMResults<Product *> *prods =[[Product allObjects] sortedResultsUsingProperty:@"name" ascending:YES];
    

    _productList=[NSMutableArray new];
    
    for (Product *prd in prods) {
        
        
        ProductToBuy *ptobuy=[[ProductToBuy alloc]init];
        ptobuy.quantity=@"1";
        ptobuy.name=prd.name;
        ptobuy._id=prd._id;
        ptobuy.companyId=prd.cellar._id;
        ptobuy.companyName=prd.cellar.name;
        ptobuy.winecategoryId=prd.winecategoryId;
        ptobuy.price=prd.price;

        
        
        [_productList addObject:ptobuy];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ptobuy.name,@"name",prd.winecategoryId,@"typeId",prd._id,@"productpk",ptobuy.companyId,@"companypk",ptobuy.companyName,@"companyname", nil];
        [_suggestions addObject:dict];
    }
    
    
    
    
    
    
    [self.productTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _productList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id selectedProduct = (tableView == self.productTableView) ?
    self.productList[indexPath.row] : self.resultsTableController.filteredProducts[indexPath.row];
    
    
    if ([selectedProduct isKindOfClass:[NSDictionary class]])  {
        _searchController.active=NO;
        NSDictionary*item = (NSDictionary*)selectedProduct;
        
        for (int i= 0; i<_productList.count; i++) {
            ProductToBuy * prd = [_productList objectAtIndex:i];
            if ([[NSString stringWithFormat:@"%@",prd._id]isEqualToString:[NSString stringWithFormat:@"%@",[item objectForKey:@"productpk"]]]) {
                
                NSLog(@"prudct: %@",prd.debugDescription);
                
                NSLog(@"obj: %@",item);
                
                
                NSLog(@"the index of product: %d",i);
                
                NSIndexPath *toscrollpath=[NSIndexPath indexPathForRow:i inSection:0];
                [self.productTableView scrollToRowAtIndexPath:toscrollpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self.productTableView selectRowAtIndexPath:toscrollpath
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionNone];
                break;
            }
            
        }
    }
    
    
    
        

      
        
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductToBuyCell *cell = (ProductToBuyCell*)[self.productTableView dequeueReusableCellWithIdentifier:@"ProductToBuyCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductToBuyCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    ProductToBuy *product = [_productList objectAtIndex:indexPath.row];
    
    cell.productPrice.text=[NSString stringWithFormat:@"Prezzo: %@ €",product.price];
    cell.productName.text=[NSString stringWithFormat:@"%@",product.name];
    cell.productCompany.text=[NSString stringWithFormat:@"%@",product.companyName];
  
    cell.addToCartButton.tag=indexPath.row;
    [cell.addToCartButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    if ([product.winecategoryId isEqualToString:@"3"]) {
        cell.productTypeIcon.image=[UIImage imageNamed:@"ic_wine_white"];
    }else if ([product.winecategoryId isEqualToString:@"4"]) {
        cell.productTypeIcon.image=[UIImage imageNamed:@"ic_wine_rose"];
    }else if ([product.winecategoryId isEqualToString:@"1"]) {
        cell.productTypeIcon.image=[UIImage imageNamed:@"ic_wine_red"];
    }else if ([product.winecategoryId isEqualToString:@"5"]) {
        cell.productTypeIcon.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }else if ([product.winecategoryId isEqualToString:@"2"]) {
        cell.productTypeIcon.image=[UIImage imageNamed:@"ic_wine_sparkling"];
    }
    
    
    if (product.price.floatValue == 0.00) {
        [cell.addToCartButton setHidden:YES];
        [cell.productPrice setHidden:YES];
    }else{
        [cell.addToCartButton setHidden:NO];
        [cell.productPrice setHidden:NO];
        
    }
    
    return cell;
    
}



-(void)addToCart:(id)sender{
    //  NSLog(@"userdata: %@",userData);
    BOOL isLogged=[[NSUserDefaults standardUserDefaults]boolForKey:@"logged"];
    if(!isLogged){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"goToWelcome" object:nil];
        
        
        return;
    }
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"stopBuyWine"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Vendite chiuse\nGrazie per aver partecipato a Hostaria 2016"
                                                                            message: nil
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"ok button tapped!");
                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        return;
        
    }
    
    
    UIButton *btn=(UIButton*)sender;
    selectedIndexPath = [NSIndexPath indexPathForRow:btn.tag  inSection:0];
    ProductToBuy *gotoCartPrd= [_productList objectAtIndex:selectedIndexPath.row];

    NSMutableDictionary *cart=[[NSMutableDictionary alloc]init];
    [cart setObject:gotoCartPrd._id forKey:@"productId"];
    [cart setObject:gotoCartPrd.name forKey:@"productName"];
    [cart setObject:gotoCartPrd.price forKey:@"productPrice"];
    [cart setObject:gotoCartPrd.quantity forKey:@"quantity"];
    [cart setObject:gotoCartPrd.companyId forKey:@"productCompanyId"];
    [cart setObject:gotoCartPrd.winecategoryId forKey:@"productTypeIcon"];
    [cart setObject:gotoCartPrd.companyName forKey:@"productCompanyName"];

    [cart setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"s"];

    NSMutableArray *data = [[NSMutableArray alloc]init];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cart_items"] != nil) {
        [data addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_items"]];
        NSLog(@"data inside: %@",data);
        
        
        
        
        
        
        
    }
    [data addObject:cart];
    
    
    
    ProductToBuyCell * cell = (ProductToBuyCell*)[self.productTableView cellForRowAtIndexPath:selectedIndexPath];
    
    UIView *ds=[cell.contentView snapshotViewAfterScreenUpdates:NO];
    CGPoint newPoint = [self.view convertPoint:ds.center fromView:cell];
    [ds setCenter:newPoint];
    
    [self.view addSubview:ds];
    [self.view bringSubviewToFront:ds];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         ds.alpha=.6f;
                         ds.frame = CGRectMake(self.view.frame.size.width-20, self.view.frame.size.height, 20, 20);
                     }
                     completion:^(BOOL finished){
                         [ds removeFromSuperview];
                         [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"cart_items"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"updatecarttable" object:nil];
                     }];
    
    
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
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.suggestions mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        /*
         // yearIntroduced field matching
         NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
         numberFormatter.numberStyle = NSNumberFormatterNoStyle;
         NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
         if (targetNumber != nil) {   // searchString may not convert to a number
         lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
         rhs = [NSExpression expressionForConstantValue:targetNumber];
         finalPredicate = [NSComparisonPredicate
         predicateWithLeftExpression:lhs
         rightExpression:rhs
         modifier:NSDirectPredicateModifier
         type:NSEqualToPredicateOperatorType
         options:NSCaseInsensitivePredicateOption];
         [searchItemsPredicate addObject:finalPredicate];
         
         // price field matching
         lhs = [NSExpression expressionForKeyPath:@"introPrice"];
         rhs = [NSExpression expressionForConstantValue:targetNumber];
         finalPredicate = [NSComparisonPredicate
         predicateWithLeftExpression:lhs
         rightExpression:rhs
         modifier:NSDirectPredicateModifier
         type:NSEqualToPredicateOperatorType
         options:NSCaseInsensitivePredicateOption];
         [searchItemsPredicate addObject:finalPredicate];
         }*/
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    ResultsTableViewController *tableController = (ResultsTableViewController *)self.searchController.searchResultsController;
    tableController.filteredProducts = searchResults;
    [tableController.tableView reloadData];
}


#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey2 = @"ViewControllerTitleKey22";
NSString *const SearchControllerIsActiveKey2 = @"SearchControllerIsActiveKey22";
NSString *const SearchBarTextKey2 = @"SearchBarTextKey22";
NSString *const SearchBarIsFirstResponderKey2 = @"SearchBarIsFirstResponderKey22";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey2];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey2];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey2];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey2];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey2];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey2];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey2];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey2];
}





@end
