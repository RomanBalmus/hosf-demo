//
//  MyAreaViewController.m
//  Hostaria
//
//  Created by iOS on 25/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MyAreaViewController.h"
#import "LoginSignUpViewController.h"
#import "TestCircle.h"
@interface MyAreaViewController (){
    UIImageView *circle;
    CGFloat originX;
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;
@property (nonatomic)BOOL loadYN;

@end

@implementation MyAreaViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;

    }
    circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_logo_1"]] ;
    //[circle setFrame:CGRectMake(0, 0, 88, 88)];
    // circle.layer.cornerRadius = circle.frame.size.width/2;
    // _circle.layer.borderColor = [UIColor whiteColor].CGColor;
    // _circle.layer.borderWidth = 10;
    //circle.layer.masksToBounds = YES;
    originX = self.navigationController.navigationBar.frame.size.width/2- (circle.frame.size.width/2);
    // UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    // [keyWindow addSubview:circle];
    [self.navigationController.navigationBar addSubview:circle];
    /* Screen width: the initial position of the circle = center + screen width. */
   // CGFloat width = self.view.bounds.size.width;
    
    CGRect destination = circle.frame;
    destination.origin.x = originX;
    
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
    circle.frame = destination;

}
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /* Screen width: the initial position of the circle = center + screen width. */
  //  CGFloat width = self.view.bounds.size.width;
    
    /*CGRect destination = _circle.frame;
    destination.origin.x = originX + width;*/
    
    /* The transition coordinator is only available for animated transitions. */
   /* if (animated) {
        CGRect frame = destination;
        frame.origin.x = originX;
        _circle.frame = frame;
        
        void (^animation)(id context) = ^(id context) {
            _circle.frame = destination;
        };
        
        [self.transitionCoordinator animateAlongsideTransitionInView:_circle
                                                           animation:animation
                                                          completion:animation];
    }else {
        _circle.frame = destination;
    }*/
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    /* Remove the circle from your key window. */
    //[_circle removeFromSuperview];
}
- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                         
                         if ([newViewController isKindOfClass:[LoginSignUpViewController class]]) {
                             LoginSignUpViewController *ls=(LoginSignUpViewController*)newViewController;
                            
                                 [ls.regButton addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

                                   [ls.loginButton addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                         
                         }
                     }];
}

-(void)loadLoginSignUp:(BOOL)YN{
    if (YN) {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginSignUpContainer"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    } else {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileContainer"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
 
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchContainers)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    [API registerUser:NULL onView:self.view];
    
  //  [self.regButton addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.loginButton addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)switchContainers{
    
    if (self.loadYN) {
        [self loadLoginSignUp:YES];
        self.loadYN = NO;

    }else{
        [self loadLoginSignUp:NO];
        self.loadYN = YES;
    }

}
-(void)registerBtnClicked:(id)sender{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    RegisterParentViewController *regParent = [storyboard instantiateViewControllerWithIdentifier:@"REGISTER_PARENT_CONTROLLER"];
    UINavigationController *regNav = [[UINavigationController alloc]initWithRootViewController:regParent];

    [self presentViewController:regNav animated:YES completion:^(void){
        [regParent addReturnButton:YES];
        
    }];
    
}
-(void)loginBtnClicked:(id)sender{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    LoginParentViewController *loginParent = [storyboard instantiateViewControllerWithIdentifier:@"LOGIN_PARENT_CONTROLLER"];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginParent];

    [self presentViewController:loginNav animated:YES completion:^(void){
        [loginParent addReturnButton:YES];

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

@end
