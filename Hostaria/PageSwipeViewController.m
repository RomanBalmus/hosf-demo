//
//  PageSwipeViewController.m
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "PageSwipeViewController.h"
#import "UserProfilePageXIBViewController.h"
#import "ProfileViewController.h"
#import "EventListViewController.h"
#import "MenuRistorantiViewController.h"
#import "FeedbackListViewController.h"
@interface PageSwipeViewController (){
    CGFloat originX;
    UIImageView *circle;
}
@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation PageSwipeViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
    [self updateTicket:nil];
    
    

    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"noevent"]isEqualToString:@"no"]) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Attenzione"
                                                                            message: @"Non e attivo nessun evento. Grazie."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle: @"Ok"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction *action) {
                                                                       NSLog(@"ok button tapped!");
                                                                       exit(0);
                                                                   }];
        
        [controller addAction: alertActionConfirm];
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyBoadr = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    // Do any additional setup after loading the view.
    HomeViewController *home = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    home.title = @"Home";

    
    ProjectViewController *project =  [storyBoadr instantiateViewControllerWithIdentifier:@"PROJECT_VIEW_CONTROLLER_ID"];
    project.title = @"Progetto";
    EventListViewController *evnt = [[EventListViewController alloc]initWithNibName:@"EventListViewController" bundle:nil];
    [evnt setupNavigation:self.navigationController];

    evnt.title = @"Eventi";
    
    UserProfilePageXIBViewController *myArea = [[UserProfilePageXIBViewController alloc]initWithNibName:@"UserProfilePageXIBViewController" bundle:nil];
    myArea.title = @"Profilo";
    [myArea setupNavigation:self.navigationController];
    
    
    ProfileViewController *profile = [storyBoadr instantiateViewControllerWithIdentifier:@"profileContainer"];
    profile.title = @"Impostazioni";
    [profile setupNavigation:self.navigationController];
 
    MenuRistorantiViewController *menu = [[MenuRistorantiViewController alloc]initWithNibName:@"MenuRistorantiViewController" bundle:nil];
    [menu setupNavigation:self.navigationController];
    
    menu.title = @"Ristoranti";
    NSArray *controllerArray = @[home, project,evnt,menu,myArea,profile];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [self getUIColorObjectFromHexString:@"#BD172C" alpha:1],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor:[self getUIColorObjectFromHexString:@"#BD172C" alpha:1],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"PierSans" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 1.5, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
   

    [self.view addSubview:_pageMenu.view];
    
    
    
 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTicket:) name:@"updateTicket" object:nil];

    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFeedbackList) name:@"showFeedbackList" object:nil];

}
-(void)showFeedbackList{
    FeedbackListViewController *list = [[FeedbackListViewController alloc]initWithNibName:@"FeedbackListViewController" bundle:nil];
    [self.navigationController pushViewController:list animated:YES];
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
-(void)updateTicket:(id)sender{
    
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    
    UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
    
    NSMutableArray * array =[dict objectForKey:@"myTickets"];
    
    if ([array count]>0) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];
        
    }else{
        [ticket removeFromSuperview];
        self.navigationItem.rightBarButtonItem=nil;
        
    }
    
    
}
- (void)didTapGoToLeft {
    NSInteger currentIndex = self.pageMenu.currentPageIndex;
    
    if (currentIndex > 0) {
        [_pageMenu moveToPage:currentIndex - 1];
    }
}

- (void)didTapGoToRight {
    NSInteger currentIndex = self.pageMenu.currentPageIndex;
    
    if (currentIndex < self.pageMenu.controllerArray.count) {
        [self.pageMenu moveToPage:currentIndex + 1];
    }
}
-(void)showMyTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMyTicket" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UINavigationController *)pageNavigationController{
    return self.navigationController;
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
