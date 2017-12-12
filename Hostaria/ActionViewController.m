//
//  ActionViewController.m
//  Hostaria
//
//  Created by iOS on 09/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController ()


@end

@implementation ActionViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.coupleContainer.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop;
    self.coupleContainer.selectiveBordersColor = [UIColor lightGrayColor];
    self.coupleContainer.selectiveBordersWidth = 1.0;
    
    self.receiveContainer.selectiveBorderFlag = AUISelectiveBordersFlagTop;
    self.receiveContainer.selectiveBordersColor = [UIColor lightGrayColor];
    self.receiveContainer.selectiveBordersWidth = 1.0;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UITapGestureRecognizer *receiveTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(receiveClicked:)];
    receiveTap.numberOfTapsRequired=1;
    [self.receiveContainer addGestureRecognizer:receiveTap];
    
    UITapGestureRecognizer *coupleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coupleClicked:)];
    coupleTap.numberOfTapsRequired=1;
    [self.coupleContainer addGestureRecognizer:coupleTap];
  

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
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





- (IBAction)receiveClicked:(id)sender {
  
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(clickedReceive:)]) {
            [self.delegate clickedReceive:sender];
            
        }
    }];
}

- (IBAction)coupleClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(clickedCouple:)]) {
            [self.delegate clickedCouple:sender];
            
        }
    }];
    
    
   
    
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
