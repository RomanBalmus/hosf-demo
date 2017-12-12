//
//  UserProfilePageViewController.m
//  Hostaria
//
//  Created by iOS on 23/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "UserProfilePageViewController.h"
#import "FXBlurView.h"
//#import "StickHeader.h"
#import "MyTicketCell.h"
#import "UIImageView+Letters.h"

CGFloat kTableHeaderHeight = 256.0;
CGFloat offset_HeaderStop = 40.0; // At this offset the Header stops its transformations
CGFloat offset_B_LabelHeader = 95.0; // At this offset the Black label reaches the Header
CGFloat distance_W_LabelHeader = 35.0; // The distance between the bottom of the Header and the top of the White Label
@interface UserProfilePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
}
//@property (nonatomic, strong) StickHeader *stickHeader;
@property (nonatomic, strong) UINib *ticketCell;

@end

@implementation UserProfilePageViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.ticketCell = [UINib nibWithNibName:@"MyTicketCell" bundle:nil];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    //  let fileURL2 = NSBundle.mainBundle().URLForResource("Image", withExtension:"jpg"),
    
    
   UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
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
    
    [self.disconnectButton addTarget:self action:@selector(clearAllData) forControlEvents:UIControlEventTouchUpInside];
   // self.scrollView.delegate = self;

   // self.stickHeader = [[[NSBundle mainBundle] loadNibNamed:@"StickHeader" owner:self options:nil] firstObject];
    self.headerView=self.theTable.tableHeaderView;
    self.theTable.tableHeaderView=nil;
    [self.theTable addSubview:self.headerView];
    //With this method you can load any xib for header view
    [self.theTable registerNib:self.ticketCell forCellReuseIdentifier:@"myticketcell"];
   // self.theTable.tableHeaderView = self.stickHeader;
    self.theTable.delegate=self;
    self.theTable.dataSource=self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   /* UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
   
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"hasTicket"]) {
        self.navigationController.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];
        
    }*/
    

   /* // Header - Image
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    self.headerImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.headerImageView.center = self.stickHeader.header.center;
    [self.headerImageView setImageWithString:@"Roman Balmus" color:nil circular:YES];
    [self.stickHeader.header insertSubview:self.headerImageView belowSubview:self.stickHeader.headerInitials];
    
    // Header - Blurred Image
    self.headerBlurImageView = [[UIImageView alloc]initWithFrame:self.stickHeader.header.bounds];
    self.headerBlurImageView.image=[[UIImage imageNamed:@"home_bg"]blurredImageWithRadius:10 iterations:20 tintColor:[UIColor clearColor]];
    self.headerBlurImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.headerBlurImageView.alpha=0.0;
    [self.stickHeader.header insertSubview:self.headerBlurImageView belowSubview:self.stickHeader.headerInitials];
    self.stickHeader.header.clipsToBounds = YES;*/
    self.theTable.contentInset=UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
    self.theTable.contentOffset=CGPointMake(0, -kTableHeaderHeight);
    self.growimageView.image=[[UIImage imageNamed:@"home_bg"]blurredImageWithRadius:3 iterations:4 tintColor:[UIColor clearColor]];
   
    [self.meletterView setInitials:@"RB" bgColor:[UIColor greenColor]];
    
    [self transformHeader];
    //[self.growimageView setImageWithString:@"Roman Balmus" color:[UIColor blackColor] circular:NO];

}

-(void)transformHeader{
    //CGRect lblframe = self.lbl.frame;
     CGFloat offset = self.theTable.contentOffset.y;

    CGRect headerFrame=CGRectMake(0, -kTableHeaderHeight, self.theTable.bounds.size.width, kTableHeaderHeight);
    if (offset < -kTableHeaderHeight) {
        headerFrame.origin.y=offset;
        headerFrame.size.height=-offset;
        NSLog(@"change %f",offset);
        self.headerView.frame=headerFrame;

    }else{
        NSLog(@"change back %f",offset);

    }
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self transformHeader];
   /* CGFloat offset = scrollView.contentOffset.y;
    //CATransform3D avatarTransform = CATransform3DIdentity;
    CATransform3D headerTransform = CATransform3DIdentity;
    
    // PULL DOWN -----------------
    
    if (offset < 0 ){
        
        CGFloat headerScaleFactor = -(offset) / self.stickHeader.headerInitials.bounds.size.height;
        CGFloat headerSizevariation = ((self.stickHeader.headerInitials.bounds.size.height * (1.0 + headerScaleFactor)) - self.stickHeader.headerInitials.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.stickHeader.headerInitials.layer.transform = headerTransform;
    } else {
    
    
   // SCROLL UP/DOWN ------------

        
        // Header -----------
        
      //  headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offset), 0);
        
        //  ------------ Label
        
      //  CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0);
       // self.stickHeader.headerInitials.layer.transform = labelTransform;
        
        //  ------------ Blur
        
        //self.headerBlurImageView.alpha = MIN (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader);
        
        // Avatar -----------
        
       // CGFloat avatarScaleFactor = (MIN(offset_HeaderStop, offset)) / self.avatarImage.bounds.size.height / 1.4 ;// Slow down the animation
       // CGFloat avatarSizeVariation = ((self.avatarImage.bounds.size.height  * (1.0 + avatarScaleFactor)) - self.avatarImage.bounds.size.height ) / 2.0;
       // avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0);
       // avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
        
        if (offset <= offset_HeaderStop ){
            
           // if (self.avatarImage.layer.zPosition < self.stickHeader.header.layer.zPosition){
                self.stickHeader.headerInitials.layer.zPosition = 0;
           // }
            
        }else {
           // if (self.avatarImage.layer.zPosition >= self.stickHeader.header.layer.zPosition){
                self.stickHeader.headerInitials.layer.zPosition = 2;
            //}
        }
    }
    
    // Apply Transformations
    
    self.stickHeader.headerInitials.layer.transform = headerTransform;*/
   // self.avatarImage.layer.transform = avatarTransform;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 133;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myticketcell" forIndexPath:indexPath];
   
    return cell;
}
-(void)clearAllData{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];

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

@end
