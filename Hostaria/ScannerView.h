//
//  WECodeScannerView.h
//  WECodeScanner
//
//  Created by Werner Altewischer on 10/11/13.
//  Copyright (c) 2013 Werner IT Consultancy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScannerView;

@protocol ScannerViewDelegate < NSObject >

- (void)scannerView:(ScannerView *)scannerView didReadCode:(NSString*)code atTime:(NSString*)time;
- (void)scannerView:(ScannerView *)scannerView didReadImage:(UIImage*)thisimage;


@optional
- (void)scannerViewDidStartScanning:(ScannerView *)scannerView;
- (void)scannerViewDidStopScanning:(ScannerView *)scannerView;

@end

@interface ScannerView : UIView{
    
}

@property (nonatomic, weak) id <ScannerViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval quietPeriodAfterMatch;

- (void)setMetadataObjectTypes:(NSArray *)metaDataObjectTypes;
- (void)start;
- (void)stop;
- (void)changeCamera;
- (void)toggleTorch;
- (void) focusAtPoint:(CGPoint)point;

@end
