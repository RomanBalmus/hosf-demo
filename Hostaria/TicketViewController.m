//
//  TicketViewController.m
//  Hostaria
//
//  Created by iOS on 16/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "TicketViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TicketMainViewController.h"
#import "InputSceneOneViewController.h"
#import "InputSceneTwoViewController.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "InputSceneThreeViewController.h"
#import "InputSceneFourViewController.h"
#import "TicketListViewController.h"

/*
 loginType
 0 = app
 1 = fb
 2 = g+
 3 = tw
 */

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox
typedef NS_ENUM(NSInteger, ViewControllerTransition) {
    ViewControllerTransitionSlideFromTop   = 0,
    ViewControllerTransitionSlideFromLeft,
    ViewControllerTransitionSlideFromBottom,
    ViewControllerTransitionSlideFromRight,
    ViewControllerTransitionRotateFromRight
};
@interface TicketViewController ()<UITextFieldDelegate,TicketMainDelegate,APIManagerDelegate,InputSceneThreeDelegate,TicketListDelegate>{
    CGPoint lastLocation;
    CGPoint startLocation;
    UISwipeGestureRecognizer *swipe;
    UITextField *topTF;
    UITextField *bottomTF;
    NSMutableDictionary *userDataDictionary;
    

}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation TicketViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        
       // [self.view setFrame:CGRectMake(self.view.frame.origin.x - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        
    }
    return self;
}
- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    //[pan setMaximumNumberOfTouches:1];
    swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeSelfUp)];
    swipe.direction=UISwipeGestureRecognizerDirectionUp;
    swipe.enabled=YES;
    [self.view addGestureRecognizer:swipe];
    
    
   /* TicketMainViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ticketMainContainerVC"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;*/
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.merchantName = @"Hostaria";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://gestione.hostariaverona.com/privacypolicy"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://gestione.hostariaverona.com/privacypolicy"];
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    
    TicketMainViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ticketMainContainerVC"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    newViewController.delegate=self;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;


    
    [self.skipBtn addTarget:self action:@selector(swipeSelfUp) forControlEvents:UIControlEventTouchUpInside];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]) {
        userDataDictionary = [[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]];
    }else{
    userDataDictionary = [[NSMutableDictionary alloc]init];
    }
    
    
}

-(void)doneAction:(id)sender{
    NSLog(@"done click : %@",NSStringFromClass([sender class]));
    
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    [self checkEmail];

}

-(void)nextAction:(id)sender{
    NSLog(@"next click : %@",NSStringFromClass([sender class]));
    [[IQKeyboardManager sharedManager]goNext];
    [self checkEmail];

}
-(void)previousAction:(id)sender{
    NSLog(@"previous click : %@",NSStringFromClass([sender class]));
    [[IQKeyboardManager sharedManager]goPrevious];
    [self checkEmail];

}


-(void)checkEmail{
  if([self.currentViewController isKindOfClass:[InputSceneTwoViewController class]]){
        InputSceneTwoViewController *tmvc=(InputSceneTwoViewController*)self.currentViewController;
        NSLog(@"checkEmail : INPUTSCENETwoCONTROLLER");


    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"end editing");
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
- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                         
                         if ([newViewController isKindOfClass:[TicketMainViewController class]]) {
                             NSLog(@"SPARTAAAAAAA : TICKETMAINVIEWCONTROLELER");
                             TicketMainViewController *tmn=(TicketMainViewController*)newViewController;
                             [tmn.loginButton addTarget:self action:@selector(goToSceneThree:) forControlEvents:UIControlEventTouchUpInside];

                             
                             if ([[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"]) {
                                 [tmn.loginButton setHidden:YES];
                             }else{
                                 [tmn.loginButton setHidden:NO];
                             }

                         }
                     }];
}


-(void)buyClick:(id)sender{
    [self goToTicketList:sender];
}



-(void)goToTicketList:(id)sender{
    
    TicketListViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TICKET_LIST_CONTROLLER_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}


-(void)goToSceneThree:(id)sender{
    InputSceneThreeViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"INPUT_SCENE_THREE_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}
-(void)goToSceneFour:(id)sender{
    InputSceneFourViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"INPUT_SCENE_FOUR_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}

-(void)goToSceneOne:(id)sender{
    
    InputSceneOneViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"INPUT_SCENE_ONE_ID"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self slideFromViewController:self.currentViewController toViewController:newViewController];
    if ([self dictionary:userDataDictionary hasKey:@"surname"]) {
        newViewController.surnameTF.text = [userDataDictionary objectForKey:@"surname"];
        [newViewController.surnameTF setUserInteractionEnabled:NO];
    }
    if ([self dictionary:userDataDictionary hasKey:@"name"]) {
        newViewController.nameTF.text=[userDataDictionary objectForKey:@"name"];
        [newViewController.nameTF setUserInteractionEnabled:NO];
    }
    self.currentViewController = newViewController;
}


-(void)goToSceneTwo:(id)sender{
    
    if (topTF.text.length ==0 || bottomTF.text.length==0) {
        NSLog(@"scene one empty field");
    }else{
        NSLog(@"scene one no empty field %@ %@",topTF.text,bottomTF.text);
        
        [userDataDictionary setObject:topTF.text forKey:@"name"];
        [userDataDictionary setObject:bottomTF.text forKey:@"surname"];
        
        
        
        InputSceneTwoViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"INPUT_SCENE_TWO_ID"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self slideFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
    
    
    
  
}


-(void)loginUserWithData:(id)sender{
    if (topTF.text.length ==0 || bottomTF.text.length==0) {
        NSLog(@"scene three empty field");
    }else{
        NSLog(@"scene three no empty field %@ %@",topTF.text,bottomTF.text);
        
        [userDataDictionary setObject:topTF.text forKey:@"email"];
        [userDataDictionary setObject:bottomTF.text forKey:@"password"];
        
        
        
        
        
        NSLog(@"ok to login user: %@",userDataDictionary);
        [API loginUser:userDataDictionary onView:self.view];
    }
}
-(void)registerUserWithData:(id)sender{
    if (topTF.text.length ==0 || bottomTF.text.length==0) {
        NSLog(@"scene two empty field");
    }else{
        NSLog(@"scene two no empty field %@ %@",topTF.text,bottomTF.text);
        
        

        [userDataDictionary setObject:topTF.text forKey:@"email"];
        [userDataDictionary setObject:bottomTF.text forKey:@"password"];
        API.delegate=self;
        [API registerUser:userDataDictionary onView:self.view];
        //NSLog(@"ok to reg user: %@",userDataDictionary);
    }
}

- (CGAffineTransform)startingTransformForViewControllerTransition:(ViewControllerTransition)transition
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (transition)
    {
        case ViewControllerTransitionSlideFromTop:
            transform = CGAffineTransformMakeTranslation(0, -height);
            break;
        case ViewControllerTransitionSlideFromLeft:
            transform = CGAffineTransformMakeTranslation(-width, 0);
            break;
        case ViewControllerTransitionSlideFromRight:
            transform = CGAffineTransformMakeTranslation(width, 0);
            break;
        case ViewControllerTransitionSlideFromBottom:
            transform = CGAffineTransformMakeTranslation(0, height);
            break;
        case ViewControllerTransitionRotateFromRight:
            transform = CGAffineTransformMakeTranslation(width, 0);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        default:
            break;
    }
    
    return transform;
}


- (void)slideFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    [newViewController.view layoutIfNeeded];
  /*
    // set starting state of the transition
    CGRect newFrame = self.containerView.frame;
    newFrame.origin.x += self.view.bounds.size.width;
    newFrame.size.width = self.view.bounds.size.width;
    newViewController.view.frame = newFrame;

    CGRect oldFrame = self.containerView.frame;
    oldViewController.view.frame=oldFrame;
    newFrame = self.containerView.frame;
    newFrame.size.width = self.view.bounds.size.width;


    [self transitionFromViewController:oldViewController
                      toViewController:newViewController
                              duration:1.35
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                // no further animations required
                                NSLog(@"oldframe %@",NSStringFromCGRect(oldViewController.view.frame));

                                newViewController.view.frame = newFrame;

                            }
                            completion:^(BOOL finished) {
                                [oldViewController.view removeFromSuperview];
                                [oldViewController removeFromParentViewController];
                                [newViewController didMoveToParentViewController:self];
                                if ([newViewController isKindOfClass:[InputSceneOneViewController class]]) {
                                    NSLog(@"SPARTAAAAAAA : INPUTSCENEONECONTROLLER");
                                    
                                    //TicketMainViewController *tmvc=(TicketMainViewController*)newViewController;
                                    //[tmvc.regBtn addTarget:self action:@selector(goToNextScene:) forControlEvents:UIControlEventTouchUpInside];
                                   // [tmvc.skipBtn addTarget:self action:@selector(swipeSelfUp) forControlEvents:UIControlEventTouchUpInside];
                                    
                                    
                                }
                                
                            }];
    
    */
    newViewController.view.transform = [self startingTransformForViewControllerTransition:3];
    
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.6 options:0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-newViewController.view.transform.tx * 1, -newViewController.view.transform.ty * 1);
        transform = CGAffineTransformRotate(transform, acosf(newViewController.view.transform.a));
        oldViewController.view.transform = CGAffineTransformScale(transform, 1, 1);
        
        newViewController.view.transform = CGAffineTransformIdentity;
        
        if ([newViewController isKindOfClass:[InputSceneFourViewController class]]) {
            [self.skipBtn setAlpha:0];

        }
    } completion:^(BOOL finished) {
        [oldViewController.view removeFromSuperview];
        [oldViewController removeFromParentViewController];
        [newViewController didMoveToParentViewController:self];
        
        if ([newViewController isKindOfClass:[InputSceneOneViewController class]]) {
            NSLog(@"SPARTAAAAAAA : INPUTSCENEONECONTROLLER");
            
            InputSceneOneViewController *tmvc=(InputSceneOneViewController*)newViewController;
            [tmvc.nextSceneBtn addTarget:self action:@selector(goToSceneTwo:) forControlEvents:UIControlEventTouchUpInside];
            swipe.enabled=NO;
            [tmvc.nameTF addPreviousNextDoneOnKeyboardWithTarget:self previousAction:NULL nextAction:@selector(nextAction:) doneAction:@selector(doneAction:)];

            [tmvc.surnameTF addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousAction:) nextAction:NULL doneAction:@selector(doneAction:)];
            topTF=tmvc.nameTF;
            bottomTF=tmvc.surnameTF;

        }
        if ([newViewController isKindOfClass:[InputSceneTwoViewController class]]) {
            NSLog(@"SPARTAAAAAAA : INPUTSCENETWOCONTROLLER");
            swipe.enabled=NO;

            InputSceneTwoViewController *tmvc=(InputSceneTwoViewController*)newViewController;
            [tmvc.doneBtn addTarget:self action:@selector(registerUserWithData:) forControlEvents:UIControlEventTouchUpInside];
            // [tmvc.skipBtn addTarget:self action:@selector(swipeSelfUp) forControlEvents:UIControlEventTouchUpInside];
            [tmvc.emailTF addPreviousNextDoneOnKeyboardWithTarget:self previousAction:NULL nextAction:@selector(nextAction:) doneAction:@selector(doneAction:)];
            
            [tmvc.passwordTF addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousAction:) nextAction:NULL doneAction:@selector(doneAction:)];
            topTF=tmvc.emailTF;
            bottomTF=tmvc.passwordTF;
            
            
            if ([self dictionary:userDataDictionary hasKey:@"email"]) {
                tmvc.emailTF.text = [userDataDictionary objectForKey:@"email"];
                [tmvc.emailTF setUserInteractionEnabled:NO];
            }
            
            
        }
        if ([newViewController isKindOfClass:[InputSceneThreeViewController class]]) {
            NSLog(@"SPARTAAAAAAA : INPUTSCENETHREECONTROLLER");
            swipe.enabled=NO;
            
            InputSceneThreeViewController *tmvc=(InputSceneThreeViewController*)newViewController;
            [tmvc.doneBtn addTarget:self action:@selector(loginUserWithData:) forControlEvents:UIControlEventTouchUpInside];
            // [tmvc.skipBtn addTarget:self action:@selector(swipeSelfUp) forControlEvents:UIControlEventTouchUpInside];
            [tmvc.emailTF addPreviousNextDoneOnKeyboardWithTarget:self previousAction:NULL nextAction:@selector(nextAction:) doneAction:@selector(doneAction:)];
            
            [tmvc.passwordTF addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousAction:) nextAction:NULL doneAction:@selector(doneAction:)];
            topTF=tmvc.emailTF;
            bottomTF=tmvc.passwordTF;
            tmvc.delegate=self;

            
        }
        
        if ([newViewController isKindOfClass:[InputSceneFourViewController class]]) {
            NSLog(@"SPARTAAAAAAA : INPUTSCENEFOURCONTROLLER");
            InputSceneFourViewController *four=(InputSceneFourViewController*)newViewController;
            topTF = four.emailTF;
            [four.doneBtn addTarget:self action:@selector(loginUserWithData:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if ([newViewController isKindOfClass:[TicketListViewController class]]) {
            NSLog(@"SPARTAAAAAAA : TICKETLISTVIEWCONTROLLER");
            TicketListViewController *list=(TicketListViewController*)newViewController;
            list.delegate=self;

        }


    }];

}
-(void)nextSceneWithSummaryData:(NSMutableArray *)sumData andToken:(NSString *)tokect{
   // NSLog(@"sum data: %@ \ntoken: %@ \n currentuser: %@",sumData,tokect,userDataDictionary);
    [userDataDictionary setObject:sumData forKey:@"tickets"];
    [userDataDictionary setObject:tokect forKey:@"bt_token"];
    [self goToSceneOne:self];
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
-(void)loggedInWithUserInfo:(id)userInfo{
    NSLog(@"logged with this: %@",userInfo);
    NSDictionary *info = (NSDictionary*)userInfo;
    BOOL haveEmail;
    if (info[@"email"]){
        NSLog(@"Exists");
        if( [info objectForKey:@"email"] == nil ||
           [[info objectForKey:@"email"] isEqual:[NSNull null]] ||
           [info objectForKey:@"email"] == [NSNull null])
        {
            NSLog(@"email is null");
            haveEmail = NO;
        }
        else
        {
            NSLog(@"%@",[info valueForKey:@"email"]);
            haveEmail = YES;
        }
    }else{
        NSLog(@"Does not exist");
        haveEmail=NO;
    }
    
    
    [userDataDictionary addEntriesFromDictionary:info];
    if (haveEmail){
        
        [self saveUserDataAndDismiss:userDataDictionary swipe:YES];
        
    }else{

        [self goToSceneFour:self];
    }
}
-(void)saveUserDataAndDismiss:(NSDictionary*)info swipe:(BOOL)swipeBool{
    [[NSUserDefaults standardUserDefaults]setObject:info forKey:@"current_user_data"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (swipeBool) {
        [self swipeSelfUp];

    }else{
        
        [self bUYWithData:info];
    }
}
-(void)swipeSelfUp{
    [self willMoveToParentViewController:nil];
    [self beginAppearanceTransition:NO animated:YES];
    [UIView
     animateWithDuration:0.6
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^(void){
         self.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
         
         //self.view.alpha = 0.0;
     }
     completion:^(BOOL finished) {
         [self endAppearanceTransition];
         [self.view removeFromSuperview];
         [self removeFromParentViewController];
         swipe.enabled=YES;

     }
     ];
}


- (void)pan:(UIPanGestureRecognizer *)sender
{
    
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            startLocation = [sender locationInView:self.view];

            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                
                CGPoint velocity = [sender velocityInView:self.view];
                
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {

                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                
                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;
                    }
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    [self handleUpwardsGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    [self handleDownwardsGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                    [self handleLeftGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    [self handleRightGesture:sender];
                    break;
                }
                default: {
                    break;
                }
            }
        }
            
        case UIGestureRecognizerStateEnded: { // switch with ended
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    [self handleUpwardsGesture:sender];
                    break;
                }
                    default: {
                                    direction = UIPanGestureRecognizerDirectionUndefined;

                    break;
                }
            }
            break;
        }
            
        default:
            break;
    }
    
}

- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender
{
        CGPoint stopLocation = [sender locationInView:self.view];
        CGFloat dy = stopLocation.y - startLocation.y;
        NSLog(@"Distancevertical: %f", dy);
        if (dy < -200) {
            NSLog(@"Up");
            [self swipeSelfUp];
            return;
        }
    
    
  
   /* [self willMoveToParentViewController:nil];
    [self beginAppearanceTransition:NO animated:YES];
    [UIView
     animateWithDuration:0.6
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^(void){
         self.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);

         //self.view.alpha = 0.0;
     }
     completion:^(BOOL finished) {
         [self endAppearanceTransition];
         [self.view removeFromSuperview];
         [self removeFromParentViewController];
     }
     ];*/
}

- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Down");
    if (sender.state == UIGestureRecognizerStateChanged) {
        startLocation = [sender locationInView:self.view];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint stopLocation = [sender locationInView:self.view];
        CGFloat dx = stopLocation.x - startLocation.x;
        CGFloat dy = stopLocation.y - startLocation.y;
        CGFloat distance = sqrt(dx*dx + dy*dy );
        NSLog(@"Distance: %f", distance);
    }

}

- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Left");
}

- (void)handleRightGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Right");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setPayPalEnvironment:self.environment];


}
- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)skipButton:(id)sender {
    NSLog(@"skipButton");
}


-(void)registerUser:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"show explicit error :%@",error.localizedDescription);
    
}
-(void)registerUser:(APIManager *)manager didFinishLoading:(id)item{
    NSDictionary * data=(NSDictionary*)item;
    if ([data objectForKey:@"id_user"]!=NULL) {
        [userDataDictionary setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"event_id"] forKey:@"id_event"];
        [userDataDictionary setObject:[data objectForKey:@"id_user"] forKey:@"id_user"];
        
        [self saveUserDataAndDismiss:userDataDictionary swipe:NO];
    }
 
    
    //BUY
    
    
    
}
-(void)bUYWithData:(id)item{
    NSDictionary * userInfo = (NSDictionary*)item;

    NSLog(@"buy with data: %@",userInfo);
   // NSString *clientToken = [userInfo objectForKey:@"bt_token"];
    // NSLog(@"token : %@",clientToken);
   // self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
    
    /*[self.braintreeClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        NSLog(@"configuration %@",configuration.json);
        
    }];*/
    NSMutableArray *items =[NSMutableArray new];

    NSArray *tickets = userInfo[@"tickets"];
    float total = 0.0f;
    for (NSDictionary *tkct in tickets) {
        total += [tkct[@"partialAmount"]floatValue];
        
        PayPalItem *item3 = [PayPalItem itemWithName:tkct[@"ticketName"]
                                        withQuantity:[tkct[@"ticketPaid"]integerValue]
                                           withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",tkct[@"fullPrice"]]]
                                        withCurrency:@"EUR"
                                             withSku:[NSString stringWithFormat:@"SKU_00112334%@",tkct[@"id"]]];
        [items addObject:item3];
    }
    NSLog(@"total: %.02f",total);
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.02f",total] forKey:@"price_to_pay"];
    /*BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
    paymentRequest.summaryTitle = nil;
    
    paymentRequest.summaryDescription = nil;
    paymentRequest.displayAmount = [NSString stringWithFormat:@"%.02f",total];
    paymentRequest.amount = [NSString stringWithFormat:@"%.02f",total];
    paymentRequest.callToActionText = [NSString stringWithFormat:@"%.02f - Paga ora",total];
    paymentRequest.shouldHideCallToAction = NO;
    paymentRequest.noShipping = YES;
    paymentRequest.currencyCode=@"EUR";
    
    // Create a BTDropInViewController
    
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    dropInViewController.paymentRequest = paymentRequest;
    
    
    // This is where you might want to customize your view controller (see below)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:
    
    
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = itembar;
    [dropInViewController.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];

  //  [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_red"]forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:navigationController animated:YES completion:nil];*/
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *totalpaypal = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = totalpaypal;
    payment.currencyCode = @"EUR";
    payment.shortDescription = @"Hostaria Tickets";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    // [self presentViewController:paymentViewController animated:YES completion:nil];
    
    
    
    /*
     BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
     paymentRequest.summaryTitle = nil;
     
     paymentRequest.summaryDescription = nil;
     paymentRequest.displayAmount = [NSString stringWithFormat:@"%.02f",total];
     paymentRequest.amount = [NSString stringWithFormat:@"%.02f",total];
     paymentRequest.callToActionText = [NSString stringWithFormat:@"%.02f - Paga ora",total];
     paymentRequest.shouldHideCallToAction = NO;
     paymentRequest.noShipping = YES;
     paymentRequest.currencyCode=@"EUR";
     
     // Create a BTDropInViewController
     
     BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
     initWithAPIClient:self.braintreeClient];
     dropInViewController.delegate = self;
     dropInViewController.paymentRequest = paymentRequest;
     */
    
    // This is where you might want to customize your view controller (see below)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:
    
    
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                target:self
                                action:@selector(userDidCancelPayment)];
    paymentViewController.navigationItem.leftBarButtonItem = itembar;
    [paymentViewController.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
 
    
    //[navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_red"]forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:paymentViewController animated:YES completion:nil];

    //done here
}
-(void)userDidCancelPayment{
    NSLog(@"dismiss payment by user");
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
/*- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    // NSLog(@"nonce to server: %@",paymentMethodNonce.nonce);
    [self dismissViewControllerAnimated:YES completion:^{
        
        [API pasteNonceToServer:paymentMethodNonce.nonce withData:userDataDictionary onView:self.view];
    }];
}*/
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success! :%@",[completedPayment description]);
    
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    [API pasteNonceToServer:completedPayment.confirmation withData:userDataDictionary onView:self.view];

}

-(void)pasteNonceToServer:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"pasteNonceToServer %@",error.localizedDescription);
}
-(void)pasteNonceToServer:(APIManager *)manager didFinishLoading:(id)item{
    NSLog(@"pasteNonceToServer %@",(NSDictionary*)item);

}
/*- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}*/
-(void)loginUser:(APIManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"show explicit error :%@",error.localizedDescription);

}
-(void)loginUser:(APIManager *)manager didFinishLoading:(id)item{
    NSLog(@"logged in: %@",(NSDictionary*)item);
    
   
    [self saveUserDataAndDismiss:(NSDictionary*)item swipe:YES];

   // [[NSUserDefaults standardUserDefaults]setObject:userDataDictionary forKey:@"current_user_data"];
    //[[NSUserDefaults standardUserDefaults]synchronize];
    [self swipeSelfUp];

}

@end
