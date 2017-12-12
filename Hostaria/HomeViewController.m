//
//  HomeViewController.m
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "HomeViewController.h"
#import "PrePayViewController.h"
@interface HomeViewController (){
    CGFloat originX;
    UIImageView *circle;

}

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  /*  if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    
  circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
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
   // originX = self.navigationController.navigationBar.frame.size.width/2- (circle.frame.size.width/2);
   // UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
   // [keyWindow addSubview:circle];
  //  [self.navigationController.navigationBar addSubview:circle];
    /* Screen width: the initial position of the circle = center + screen width. */
   // CGFloat width = self.view.bounds.size.width;
    
   // CGRect destination = circle.frame;
   // destination.origin.x = originX;
    
    /* The transition coordinator is only available for animated transitions. */
    /*if (animated) {
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
    //circle.frame = destination;
   // self.corneredView.layer.borderColor = [self getUIColorObjectFromHexString:@"#AD0020" alpha:1].CGColor;
   // [self updateTicket:nil];
    NSLog(@"im on home");
  
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self updateTicket:nil];

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
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
   
   /* NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [NSURL fileURLWithPath:[bundle pathForResource:@"spot" ofType:@"mp4"]];
    
   self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];*/
    
    //moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
   // moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
   /* self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayer.controlStyle=MPMovieControlStyleNone;
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.repeatMode = MPMovieRepeatModeOne;*/
   // [self.moviePlayer prepareToPlay];

    //[self addSubview:self.moviePlayer.view toView:self.videoView];

    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTicket:) name:@"updateTicket" object:nil];
    
    
    
    
}
/*-(void)updateTicket:(id)sender{
    
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    
    UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
    if ([[dict objectForKey:@"myTickets"]count]>0) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];
        
    }else{
        [ticket removeFromSuperview];
        self.navigationItem.rightBarButtonItem=nil;
        
    }
    
    
}*/

-(void)dealloc{
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [self.buyLabel convertPoint:locationPoint fromView:self.view];
    if ([self.buyLabel pointInside:viewPoint withEvent:event]) {
        [self showTicket];
        
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

/*-(void)showMyTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMyTicket" object:nil];
}
*/
-(void)showTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTicket" object:nil];
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
