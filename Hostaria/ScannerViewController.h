//
//  ScannerViewController.h
//  Hostaria
//
//  Created by iOS on 10/08/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerView.h"
#import "WampCom.h"
@interface ScannerViewController : UIViewController<ScannerViewDelegate,WampComDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *scannerImageView;

@property (weak, nonatomic) IBOutlet UIView *scannView;

-(void)setScanType:(NSString*)scan;
@end
