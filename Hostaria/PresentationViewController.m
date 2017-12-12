//
//  PresentationViewController.m
//  Hostaria
//
//  Created by iOS on 31/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "PresentationViewController.h"

@interface PresentationViewController (){
    NSInteger additional;
}

@end

@implementation PresentationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    additional=0;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupScrollView];
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

-(void)setAdditional{
    additional=20;
}
-(void) setupScrollView {
    //add the scrollview to the view
    //self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    
    NSLog(@"additional: %ld",(long)additional);
    
    
    //[self.navigationController.navigationBar setHidden:YES];
    //[self setHideStatusBar:YES];
    //[self setNeedsStatusBarAppearanceUpdate];
    self.myScrollView.pagingEnabled = YES;
    [self.myScrollView setAlwaysBounceVertical:NO];
    //setup internal views
    
    float targetHeight = self.navigationController.navigationBar.frame.size.height+additional;
    
    
    NSInteger numberOfViews = 5;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *image = [[UIImageView alloc] initWithFrame:
                              CGRectMake(xOrigin, targetHeight-30,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height-targetHeight)];
        if (i==0) {
            image.image = [UIImage imageNamed:@"to1"];
        }else if (i==1){
            image.image = [UIImage imageNamed:@"to2"];
            
        }else if (i==2){
            image.image = [UIImage imageNamed:@"to3"];
            
        }else if (i==3){
            image.image = [UIImage imageNamed:@"to4"];
            
        }else if (i==4){
            image.image = [UIImage imageNamed:@"to5"];
            
        }
        
        image.contentMode = UIViewContentModeScaleAspectFit;
        [self.myScrollView addSubview:image];
    }
    //set the scroll view content size
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width *
                                            numberOfViews,
                                            self.view.frame.size.height);
    
    self.myScrollView.bounces = NO;
    
   // UIImageView *iv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_bg"]];
    //[iv setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.myScrollView.contentSize.width, self.view.frame.size.height)];
   // iv.contentMode = UIViewContentModeScaleAspectFill;
    
   // [self.myScrollView addSubview:iv];
   // [self.myScrollView sendSubviewToBack:iv];
    self.myScrollView.delegate=self;
    self.myPageControl.currentPage=0;
    //self.theTitleLabel.text=@"CERTIFICARE";
    //self.theLabel.text = @"tulain® permette di certificare l’autenticità di un prodotto, tutelando in tal modo il produttore, il cliente finale e la qualità del prodotto stesso.";
    
    
    
    
    
    // self.theLabel.numberOfLines=0;
    
    //add the scrollview to this view
    //[self.view addSubview:self.scrollView];
    
}
// handle the swipes here
- (void)didSwipeScreen:(UISwipeGestureRecognizer *)gesture
{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            // you can include this case too
            NSLog(@"UISwipeGestureRecognizerDirectionUp");
            break;
        case UISwipeGestureRecognizerDirectionDown:
            // you can include this case too
            NSLog(@"UISwipeGestureRecognizerDirectionDown");
            
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"UISwipeGestureRecognizerDirectionLeft");
            
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"UISwipeGestureRecognizerDirectionRight");
            
            // disable timer for both left and right swipes.
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    NSLog(@"dddd %ld",(long)page);
    if (previousPage != page) {
        previousPage = page;
        /* Page did change */
        
        self.myPageControl.currentPage=previousPage;
        
         
       
        // Change the text
        
        
        
    }
    
}

@end
