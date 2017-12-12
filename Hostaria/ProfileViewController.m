//
//  ProfileViewController.m
//  Hostaria
//
//  Created by iOS on 29/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuickLook/QuickLook.h>
#import "UserProfilePageViewController.h"
#import "SponsorPageViewController.h"
#import "PresentationViewController.h"

@interface ProfileViewController ()<QLPreviewControllerDataSource>{
   // UIImageView *circle;
   // CGFloat originX;
    NSArray *documents;
    UINavigationController *parentNav;

}



@end

@implementation ProfileViewController
-(void)setupNavigation:(UINavigationController *)navctrl{
    parentNav=navctrl;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    
  //  let fileURL2 = NSBundle.mainBundle().URLForResource("Image", withExtension:"jpg"),

  
    /*circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;*/
    //[circle setFrame:CGRectMake(0, 0, 88, 88)];
    // circle.layer.cornerRadius = circle.frame.size.width/2;
    // _circle.layer.borderColor = [UIColor whiteColor].CGColor;
    // _circle.layer.borderWidth = 10;
    //circle.layer.masksToBounds = YES;
  //  originX = self.navigationController.navigationBar.frame.size.width/2- (circle.frame.size.width/2);
   // UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    // [keyWindow addSubview:circle];
  //  [self.navigationController.navigationBar addSubview:circle];
    /* Screen width: the initial position of the circle = center + screen width. */
   // CGFloat width = self.view.bounds.size.width;
    
   // CGRect destination = circle.frame;
  //  destination.origin.x = originX;
    
    /* The transition coordinator is only available for animated transitions. */
    /* if (animated) {
     CGRect frame = destination;
     frame.origin.x += width;
     circle.frame = frame;
     
     void (^animation)(id context) = ^(id context) {
     circle.frame = destination;
     };
     
     [self.transitionCoordinator animateAlongsideTransitionInView:circle
     animation:animation
     completion:animation];
     }else {
     circle.frame = destination;
     }*/
  //  circle.frame = destination;
  //  [self.tableView setContentInset:UIEdgeInsetsMake(destination.size.height/3,0,0,0)];

    
}
-(void)showMyTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMyTicket" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.usernameLabel setText:@"Roman Balmus"];
    //[self.initialsImageView setImageWithString:self.usernameLabel.text color:nil circular:YES];
  
    
 
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"hasTicket"]) {
        self.navigationController.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];
        
    }*/
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3; // show 3 with  cell.textLabel.text = @"Valuta l'applicazione nell'App Store";

    }else if (section == 1) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"logged"]){
            return 4;
 
        }else{
            return 3;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Mi piace su Facebook";
         
        }else if (indexPath.row==1){
            cell.textLabel.text = @"Seguici su Twitter";

        }else if (indexPath.row==2){
            cell.textLabel.text = @"Valuta l'applicazione nell'App Store";

        }
    }else if (indexPath.section==1){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        if (indexPath.row==0) {
            cell.textLabel.text = @"Aiuto";
        }else if (indexPath.row==1){
            cell.textLabel.text = @"Privacy e Termini";
            
        }else  if (indexPath.row==2){
            cell.textLabel.text = @"Ringraziamenti";
            
        }else if (indexPath.row==3) {
                cell.textLabel.text = @"Esci";
            [cell.textLabel setTextColor:[UIColor redColor]];
            }
            
        
       
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)viewDidLayoutSubviews
{
    for (int section = 0; section < [self.tableView numberOfSections]; section++)
    {
        if (section==2) {
            [self.tableView footerViewForSection:section].textLabel.textAlignment = NSTextAlignmentCenter;
        }

        }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return @"VALUTACI";
    }else if(section==1){
        return @"IMPOSTAZIONI";
    }
    return @"";
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section ==2) {
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

        return [NSString stringWithFormat:@"Versione %@",appVersion];
    }else{
        return @"";
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
           
            NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/455065717980881"];
            if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
                [[UIApplication sharedApplication] openURL:facebookURL];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/HostariaVerona/"]];
            }
        }else if(indexPath.row==1){
            NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=HostariaVerona"];
            if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
                [[UIApplication sharedApplication] openURL:twitterURL];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/hostariaverona/"]];
            }
        }else if(indexPath.row==2){
           // NSString *iTunesLink = @"https://itunes.apple.com/us/app/calcfast/id876781417?mt=8";
            NSString *iTunesLink = @"itms-apps://itunes.apple.com/app/id1092567818";

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            
           // QLPreviewController *previewQL = [[QLPreviewController alloc]init];
          //  previewQL.dataSource = self;
            //previewQL.currentPreviewItemIndex = 0;
           // [self showViewController:previewQL sender:nil];
            
            PresentationViewController *present=[[PresentationViewController alloc]initWithNibName:@"PresentationViewController" bundle:nil];
            [parentNav pushViewController:present animated:YES];
            
            
        }
        if (indexPath.row==1) {
            NSURL *fileUrl1 = [[NSBundle mainBundle]URLForResource:@"privacy" withExtension:@"docx"];
            documents = [NSArray arrayWithObjects:fileUrl1, nil];
            QLPreviewController *previewQL = [[QLPreviewController alloc]init];
            previewQL.dataSource = self;
            previewQL.currentPreviewItemIndex = 0;
           // previewQL.edgesForExtendedLayout = UIRectEdgeNone;
            

          //  [self showViewController:previewQL sender:nil];
        //    [self presentViewController:previewQL animated:YES completion:nil];
            [parentNav pushViewController:previewQL animated:YES];
            
        }
        if (indexPath.row==2) {
            SponsorPageViewController *sponsor=[[SponsorPageViewController alloc]initWithNibName:@"SponsorPageViewController" bundle:nil];
            [parentNav pushViewController:sponsor animated:YES];
            
        }
        if (indexPath.row==3) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Vuoi davvero disconnettere tuo account?"
                                                                                message: nil
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Si"
                                                                  style: UIAlertActionStyleDefault
                                                                handler: ^(UIAlertAction *action) {
                                                                    NSLog(@"ok button tapped!");
                                                                    [self clearAllData];
                                                                    
                                                                }];
            UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle: @"No"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                    NSLog(@"ok button tapped!");
                                                                    
                                                                }];
            [controller addAction: alertAction];
            [controller addAction: alertAction2];

            
            [self presentViewController: controller animated: YES completion: nil];
        }
        
    }
  
}
-(void)clearAllData{
    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"current_user_data"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logged"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasTicket"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"appDataOnce"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart_items"];

    
    /*[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults]synchronize];*/
    
    //[self.navigationController popViewControllerAnimated:YES];
    //[self resetDefaults];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTicket" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatecarttable" object:nil];

    [self.tableView reloadData];

    
}
- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return documents.count;
}
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    return [documents objectAtIndex:index];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
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
