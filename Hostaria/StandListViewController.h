//
//  StandListViewController.h
//  Hostaria
//
//  Created by iOS on 28/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M6UniversalParallaxViewController.h"
#import "M6TouchForwardView.h"
#import "Section.h"
@interface StandListViewController : M6UniversalParallaxViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@end
