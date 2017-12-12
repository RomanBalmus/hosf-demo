//
//  SponsorPageViewController.m
//  Hostaria
//
//  Created by iOS on 03/05/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "SponsorPageViewController.h"

@interface SponsorPageViewController (){
    NSInteger curretnPage;

}

@end

@implementation SponsorPageViewController

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
    self.arrowButton.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.arrowButton.selectiveBordersColor = [UIColor blackColor];
    self.arrowButton.selectiveBordersWidth = 1.0;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
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
-(void) setupScrollView {
    //add the scrollview to the view
    //self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    
    curretnPage=1;
    
    
    //[self.navigationController.navigationBar setHidden:YES];
    //[self setHideStatusBar:YES];
    //[self setNeedsStatusBarAppearanceUpdate];
    self.myScrollView.pagingEnabled = YES;
    [self.myScrollView setAlwaysBounceVertical:NO];
    //setup internal views
    
    float targetHeight = self.navigationController.navigationBar.frame.size.height;
    
    
    NSInteger numberOfViews = 2;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *image = [[UIImageView alloc] initWithFrame:
                              CGRectMake(xOrigin, 0,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height-self.arrowButton.frame.size.height)];
        if (i==0) {
            image.image = [UIImage imageNamed:@"ahs1"];
        }else if (i==1){
            image.image = [UIImage imageNamed:@"ahs2"];
            
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
        

        
        
        // Change the text
        
        
        
    }
    
}


- (IBAction)clickePager:(id)sender {
    NSLog(@"current page: %ld",(long)curretnPage);
    if (curretnPage==1) {
        CGRect frame = self.myScrollView.frame;
        frame.origin.x = frame.size.width * curretnPage+1;
        frame.origin.y = 0;
        [self.myScrollView scrollRectToVisible:frame animated:YES];
        curretnPage+=1;
    }else if(curretnPage==2){
        [self.navigationController popViewControllerAnimated:YES];

    }
   
    
}
@end
