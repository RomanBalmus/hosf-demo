//
//  ProductWineListViewController.h
//  Hostaria
//
//  Created by iOS on 05/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductWineListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *productTableView;


@end
