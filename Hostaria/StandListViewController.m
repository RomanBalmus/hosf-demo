//
//  StandListViewController.m
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "StandListViewController.h"
#import "Cellar.h"
#import "ExpandableTableViewCell.h"
#import "Service.h"
#import "ChildTableViewCell.h"
#import "HeaderTapRecognizer.h"
#import "MapGPoint.h"
#import "ResultsTableViewController.h"
#import "StandDetailViewController.h"
#import "StandNoMapDetailViewController.h"
@interface StandListViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>


@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ResultsTableViewController *resultsTableController;
@property (nonatomic, strong) NSMutableArray *suggestions;

@property (nonatomic, strong) UINib *cellChild;
@property (nonatomic, strong) UINib *cellNib;
// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@end

@implementation StandListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fillTableViewWithData
     ];
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
    // Do any additional setup after loading the view.
    
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.cellNib = [UINib nibWithNibName:@"ExpandableTableViewCell" bundle:nil];
    self.cellChild = [UINib nibWithNibName:@"ChildTableViewCell" bundle:nil];

    [self.myTable registerNib:self.cellNib forHeaderFooterViewReuseIdentifier:@"Cell"];
    [self.myTable registerNib:self.cellChild forCellReuseIdentifier:@"ChildCell"];

    
    



    
    
    
    
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
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fillTableViewWithData{
    self.sectionsArray = [NSMutableArray new];
    self.suggestions = [NSMutableArray new];
    RLMResults<Cellar *> *cellars =[Cellar allObjects];
    RLMResults<Service *> *services_ff =[Service objectsWhere:[NSString stringWithFormat:@"serviceLocalType = '%@' or serviceLocalType = '%@' or serviceLocalType = '%@'",TYPE_TYPIC_PRODUCTS,TYPE_FOOD_AREA,TYPE_RISTORANTI]];
    //RLMResults<Service *> *services_prem =[Service objectsWhere:[NSString stringWithFormat:@"serviceLocalType = '%@' or serviceLocalType = '%@'",TYPE_RISTOR,TYPE_SPECIAL_RISTOR]];
    RLMResults<Product *> *prods =[[Product allObjects] sortedResultsUsingProperty:@"name" ascending:YES];

    
    NSMutableArray *clrs=[NSMutableArray new];
    for (Cellar *clr in cellars) {
        [clrs addObject:clr];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:clr.name,@"name",TYPE_CELLAR,@"type",clr._id,@"pk", nil];
        [_suggestions addObject:dict];
    }
    
    Section *cs=[[Section alloc]initWithName:@"CANTINE" data:clrs collapsed:NO];
    [self.sectionsArray addObject:cs];
    
    
    NSMutableArray *prds=[NSMutableArray new];

    for (Product *prd in prods) {
        [prds addObject:prd];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:prd.name,@"name",TYPE_WINE,@"type",prd._id,@"pk", nil];
        [_suggestions addObject:dict];
    }
    
    Section *vs=[[Section alloc]initWithName:@"VINO" data:prds collapsed:NO];
    [self.sectionsArray addObject:vs];

    
    
    
    NSMutableArray *srvfs=[NSMutableArray new];

    for (Service *srvf in services_ff) {
        [srvfs addObject:srvf];
        
        NSString*name=nil;
        
        if (srvf.name!= nil || srvf.name.length>0) {
            name = srvf.name;
        }
        
        if (srvf.serviceNameDefinition!= nil || srvf.serviceNameDefinition.length>0) {
            name = srvf.serviceNameDefinition;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",TYPE_SERVICE,@"type",srvf._id,@"pk", nil];
        [_suggestions addObject:dict];

    }
    Section *ssf=[[Section alloc]initWithName:@"LE AREE DEGUSTAZIONE" data:srvfs collapsed:NO];
    [self.sectionsArray addObject:ssf];


  /*  NSMutableArray *srvps=[NSMutableArray new];

    for (Service *srvp in services_prem) {
        [srvps addObject:srvp];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:srvp.serviceNameDefinition,@"name",TYPE_SERVICE,@"type",srvp._id,@"pk", nil];
        [_suggestions addObject:dict];

    }*/
  //  Section *ssp=[[Section alloc]initWithName:@"RISTORANTI" data:srvps collapsed:NO];
  //  [self.sectionsArray addObject:ssp];



    
    [self.myTable reloadData];

}


#pragma mark - SLExpandableTableViewDatasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if (tableView==self.myTable) {
        return 44;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return (![(Section*)self.sectionsArray[section]collapsed]) ? 0 : [[(Section*)self.sectionsArray[section]data ]count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.myTable) {
        return self.sectionsArray.count;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (tableView==self.myTable) {
        Section *mysection = self.sectionsArray[section];
        
        ExpandableTableViewCell *cell = (ExpandableTableViewCell*)[self.myTable dequeueReusableHeaderFooterViewWithIdentifier:@"Cell"];
        
        cell.lblTitle.text=mysection.name;
        HeaderTapRecognizer * recognizer = [[HeaderTapRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        recognizer.index=section;
        [cell addGestureRecognizer:recognizer];
        return  cell;
    }else{
        return nil;
   
    }
    
   
    
}
-(void)handleTap:(HeaderTapRecognizer*)recognizer{
    NSLog(@"tap : %ld",(long)recognizer.index);
    NSInteger section = recognizer.index;
    
    Section *sin= (Section*)self.sectionsArray[section];
    
    
    BOOL collapsed = sin.collapsed;
    
    
    
    sin.collapsed = !collapsed;
    // Toggle collapse
    [UIView setAnimationsEnabled:NO];

    [self.myTable reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    // Reload section
    
    [UIView setAnimationsEnabled:YES];

    
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

   
    id selectedProduct = (tableView == self.myTable) ?
    [(Section*)self.sectionsArray[indexPath.section] data][indexPath.row] : self.resultsTableController.filteredProducts[indexPath.row];
    
    
    
    if([selectedProduct isKindOfClass:[Service class]]){
        StandNoMapDetailViewController *detailViewController = [[StandNoMapDetailViewController alloc] initWithNibName:@"StandNoMapDetailViewController" bundle:nil];;
        detailViewController.data = selectedProduct; // hand off the current product to the detail view controller
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        return;
        
    }else if ([selectedProduct isKindOfClass:[NSDictionary class]]){
        NSDictionary * dict =(NSDictionary*)selectedProduct;
         if ([dict[@"type"]isEqualToString:TYPE_SERVICE]) {
             StandNoMapDetailViewController *detailViewController = [[StandNoMapDetailViewController alloc] initWithNibName:@"StandNoMapDetailViewController" bundle:nil];;
             detailViewController.data = selectedProduct; // hand off the current product to the detail view controller
             
             [self.navigationController pushViewController:detailViewController animated:YES];
         }else{
             StandDetailViewController *detailViewController = [[StandDetailViewController alloc] initWithNibName:@"StandDetailViewController" bundle:nil];;
             detailViewController.data = selectedProduct; // hand off the current product to the detail view controller
             
             [self.navigationController pushViewController:detailViewController animated:YES];
         }
        
        return;
    }else{
        StandDetailViewController *detailViewController = [[StandDetailViewController alloc] initWithNibName:@"StandDetailViewController" bundle:nil];;
        detailViewController.data = selectedProduct; // hand off the current product to the detail view controller
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    
  
    
    
   /* APLProduct *selectedProduct = (tableView == self.tableView) ?
    self.products[indexPath.row] : self.resultsTableController.filteredProducts[indexPath.row];
    
    APLDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"APLDetailViewController"];
    detailViewController.product = selectedProduct; // hand off the current product to the detail view controller
    
    [self.navigationController pushViewController:detailViewController animated:YES];*/
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    ChildTableViewCell *cell = (ChildTableViewCell*)[self.myTable dequeueReusableCellWithIdentifier:@"ChildCell"];

    
    id obj=[(Section*)self.sectionsArray[indexPath.section] data][indexPath.row];
    
    if (indexPath.section==0) {
        Cellar *clr = (Cellar*)obj;
        cell.lbl.text=clr.name;
        cell.imgV.image=[UIImage imageNamed:@"ic_cellar"];
        cell.numerationLbl.text=clr._id;
    }else if(indexPath.section==1){
        Product *prd = (Product*)obj;
        cell.lbl.text=prd.name;
        cell.numerationLbl.text=@"";

        /*if ([prd.winecolor isEqualToString:@"bianco"]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_white"];
            
        }else if ([prd.winecolor isEqualToString:@"rosato"]){
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_rose"];

        }else if([prd.winecolor isEqualToString:@"rosso"]){
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_red"];

        }*/
        
        
        
        if ([prd.winecategoryId isEqualToString:@"3"]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_white"];
        }else if ([prd.winecategoryId isEqualToString:@"4"]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_rose"];
        }else if ([prd.winecategoryId isEqualToString:@"1"]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_red"];
        }else if ([prd.winecategoryId isEqualToString:@"5"]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_sparkling"];
        }else if ([prd.winecategoryId isEqualToString:@"2"]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_wine_sparkling"];
        }
        
    }else if(indexPath.section==2){
        Service *srv = (Service*)obj;
        cell.lbl.text = srv.serviceNameDefinition;
        cell.numerationLbl.text=srv.numeration;

       if ([srv.serviceLocalType isEqualToString:TYPE_TYPIC_PRODUCTS]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_stand"];
            
        }else if ([srv.serviceLocalType isEqualToString:TYPE_FOOD_AREA]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_food"];
            
        }else if ([srv.serviceLocalType isEqualToString:TYPE_MONTE_VERONESE]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_cheese"];
            
        }else if ([srv.serviceLocalType isEqualToString:TYPE_RISTORANTI]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_special_stand_big"];
            
        }
    }else if(indexPath.section==3){
        Service *srv = (Service*)obj;
        cell.lbl.text = srv.serviceNameDefinition;
        cell.numerationLbl.text=srv.numeration;
        if ([srv.serviceLocalType isEqualToString:TYPE_RISTORANTI]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_special_stand_big"];
            
        }if ([srv.serviceLocalType isEqualToString:TYPE_SPECIAL_RISTOR]) {
            cell.imgV.image=[UIImage imageNamed:@"ic_special_stand_big"];
            
        }

    }
    

    
    return cell;

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

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

@end
