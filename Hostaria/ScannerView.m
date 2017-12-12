






//
//  WECodeScannerView.m
//  WECodeScanner
//
//  Created by Werner Altewischer on 10/11/13.
//  Copyright (c) 2013 Werner IT Consultancy. All rights reserved.
//

#import "ScannerView.h"
#import "ScannerMatchView.h"
#import <AVFoundation/AVFoundation.h>

@interface ScannerView () <AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
@private
    BOOL isFocusing;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
//@property (nonatomic, strong) ScannerMatchView *matchView;
@property (nonatomic, strong) NSDate *lastDetectionDate;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;

@end

@implementation ScannerView {
    NSTimer *_timer;
    BOOL _scanning;
    BOOL _wasScanning;
    AVCaptureDevice*videoCaptureDevice;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tapToFocus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusCamera:)];
        tapToFocus.numberOfTapsRequired=1;
        [self addGestureRecognizer:tapToFocus];
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        
       videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        
        if ([videoCaptureDevice lockForConfiguration:&error]) {
            if ([videoCaptureDevice isFocusPointOfInterestSupported]){
                //[videoCaptureDevice setFocusPointOfInterest:CGPointMake(0.69,0.69)];
                //  [videoCaptureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                //videoCaptureDevice.videoZoomFactor = videoCaptureDevice.activeFormat.videoZoomFactorUpscaleThreshold;
            }
            /*  if (videoCaptureDevice.isAutoFocusRangeRestrictionSupported) {
             [videoCaptureDevice setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
             videoCaptureDevice.videoZoomFactor = videoCaptureDevice.activeFormat.videoZoomFactorUpscaleThreshold;
             
             }*/
            if ([videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                //[videoCaptureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                
                
            }
            if ([videoCaptureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                CGPoint exposurePoint = CGPointMake(0.6f, 0.6f);
                [videoCaptureDevice setExposurePointOfInterest:exposurePoint];
                [videoCaptureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                
            }
            if ([videoCaptureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
                [videoCaptureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
                
            }
            
            
            [videoCaptureDevice unlockForConfiguration];
        } else {
            NSLog(@"Could not configure video capture device: %@", error);
        }
        
        
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
        if(videoInput) {
            [self.captureSession addInput:videoInput];
        } else {
            NSLog(@"Could not create video input: %@", error);
        }
        
        AVCaptureVideoDataOutput *dataOutput = [AVCaptureVideoDataOutput new];
        dataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
        
        [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
        
        if ( [self.captureSession canAddOutput:dataOutput]){
            [self.captureSession addOutput:dataOutput];
        }
        
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
       
        
        [self.layer addSublayer:self.previewLayer];
        
       // dispatch_queue_t queue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
       // [dataOutput setSampleBufferDelegate:self queue:queue];
        
        
        
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:self.metadataOutput];
        [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]];
        
        //self.matchView = [[ScannerMatchView alloc] init];
        //[self addSubview:self.matchView];
         //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Struttura-tracciabilità-tulain-riquadro.png"]]];
        self.quietPeriodAfterMatch = 2.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deactivate)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:[UIApplication sharedApplication]];
        
        // Register for notification that app did enter foreground
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(activate)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:[UIApplication sharedApplication]];
        
    }
    return self;
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    
    // Get the number of bytes per row for the pixel buffer
    u_int8_t *baseAddress = (u_int8_t *)malloc(bytesPerRow*height);
    memcpy( baseAddress, CVPixelBufferGetBaseAddress(imageBuffer), bytesPerRow * height     );
    
    // size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    
    //The context draws into a bitmap which is `width'
    //  pixels wide and `height' pixels high. The number of components for each
    //      pixel is specified by `space'
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
    //kCGBitmapByteOrder32Little
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
    
    free(baseAddress);
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    
    return (image);
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMetadataObjectTypes:(NSArray *)metaDataObjectTypes {
    [self.metadataOutput setMetadataObjectTypes:metaDataObjectTypes];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewLayer.frame = self.bounds;
    //self.matchView.frame = self.bounds;
    
    /*
     //Doesn't work for some reason: CGAffineTransform error
     CGRect rect = [self.previewLayer metadataOutputRectOfInterestForRect:self.previewLayer.bounds];
     self.metadataOutput.rectOfInterest = rect;
     */
}

- (void)start {

    if (!_scanning) {
        _scanning = YES;
        //[self.matchView reset];
        [self.captureSession startRunning];
        
        if ([self.delegate respondsToSelector:@selector(scannerViewDidStartScanning:)]) {
            [self.delegate scannerViewDidStartScanning:self];
        }
    }
    
}

- (void)stop {
    if (_scanning) {
        _scanning = NO;
        [_timer invalidate];
        _timer = nil;
        [self.captureSession stopRunning];
        
        if ([self.delegate respondsToSelector:@selector(scannerViewDidStopScanning:)]) {
            [self.delegate scannerViewDidStopScanning:self];
        }
    }
}

- (void)deactivate {
    _wasScanning = _scanning;
    [self stop];
}

- (void)activate {
    if (_wasScanning) {
        [self start];
        _wasScanning = NO;
    }
}

/*- (CGPoint)pointFromArray:(NSArray *)points atIndex:(NSUInteger)index {
    NSDictionary *dict = [points objectAtIndex:index];
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict, &point);
    return [self.matchView convertPoint:point fromView:self];
}*/

- (BOOL)isInQuietPeriod {
    return self.lastDetectionDate != nil && (-[self.lastDetectionDate timeIntervalSinceNow]) <= self.quietPeriodAfterMatch;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([self isInQuietPeriod]) {
        return;
    }
    for(AVMetadataObject *metadataObject in metadataObjects)
    {
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            BOOL foundMatch = readableObject.stringValue != nil;
            NSArray *corners = readableObject.corners;
            if (corners.count == 4 && foundMatch) {
                
               /* CGPoint topLeftPoint = [self pointFromArray:corners atIndex:0];
               // CGPoint bottomLeftPoint = [self pointFromArray:corners atIndex:1];
               // CGPoint bottomRightPoint = [self pointFromArray:corners atIndex:2];
               // CGPoint topRightPoint = [self pointFromArray:corners atIndex:3];
                
                if (CGRectContainsPoint(self.matchView.bounds, topLeftPoint) &&
                    CGRectContainsPoint(self.matchView.bounds, topRightPoint) &&
                    CGRectContainsPoint(self.matchView.bounds, bottomLeftPoint) &&
                    CGRectContainsPoint(self.matchView.bounds, bottomRightPoint))
                {
                    [self stop];
                   // _timer = [NSTimer scheduledTimerWithTimeInterval:self.quietPeriodAfterMatch target:self selector:@selector(start) userInfo:nil repeats:NO];
                    self.lastDetectionDate = [NSDate date];
                    
                    [self.matchView setFoundMatchWithTopLeftPoint:topLeftPoint
                                                    topRightPoint:topRightPoint
                                                  bottomLeftPoint:bottomLeftPoint
                                                 bottomRightPoint:bottomRightPoint];*/
                 if (_scanning) {
                    NSDate *now = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterMediumStyle];
                    NSString *thedate=[formatter stringFromDate:now];
                     _scanning=NO;
                     [self.delegate scannerView:self didReadCode:readableObject.stringValue atTime:thedate];

                }
                //}
            }
        }
    }
}



- (void)toggleTorch
{
    if ([videoCaptureDevice isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSError *error;
        if ([videoCaptureDevice lockForConfiguration:&error]) {
            if ([videoCaptureDevice torchMode] == AVCaptureTorchModeOn)
                [videoCaptureDevice setTorchMode:AVCaptureTorchModeOff];
            else
                [videoCaptureDevice setTorchMode:AVCaptureTorchModeOn];
            if([videoCaptureDevice isFocusModeSupported: AVCaptureFocusModeContinuousAutoFocus])
                videoCaptureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [videoCaptureDevice unlockForConfiguration];
        } else {
            
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self toggleTorch];
    /*UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    if ([videoCaptureDevice isFocusPointOfInterestSupported] && [videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error;
        
        if ([videoCaptureDevice lockForConfiguration:&error]) {
            
            [videoCaptureDevice setFocusPointOfInterest:location];
            
            [videoCaptureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            
            [videoCaptureDevice unlockForConfiguration];
            
        }
    }*/
    
}


-(void)changeCamera{
    
    //Change camera source
    if(_captureSession)
    {
        //Indicate that some changes will be made to the session
        [self.captureSession beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
        [self.captureSession removeInput:currentCameraInput];
        
        //Get new input
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            videoCaptureDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            videoCaptureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:nil];
        [self.captureSession addInput:newVideoInput];
        
        //Commit all the configuration changes at once
        [self.captureSession commitConfiguration];
    }
}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}


# pragma mark - Focus Camera

- (void)focusCamera:(id)sender
{
    if (!isFocusing)
    {
        CGPoint touchPoint = [(UITapGestureRecognizer*)sender locationInView:self];
        double focus_x = touchPoint.x/self.frame.size.width;
        double focus_y = (touchPoint.y+66)/self.frame.size.height;
        NSError *error;
        NSArray *devices = [AVCaptureDevice devices];
        for (AVCaptureDevice *device in devices)
        {
            if ([device hasMediaType:AVMediaTypeVideo])
            {
                if ([device position] == AVCaptureDevicePositionBack)
                {
                    CGPoint point = CGPointMake(focus_y, 1-focus_x);
                    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && [device lockForConfiguration:&error])
                    {
                        isFocusing = YES;
                        [device setFocusPointOfInterest:point];
                        CGRect rect = CGRectMake(touchPoint.x-30, touchPoint.y-30, 60, 60);
                        UIView *focusRect = [[UIView alloc] initWithFrame:rect];
                        focusRect.layer.borderColor = [UIColor greenColor].CGColor;
                        focusRect.layer.borderWidth = 2;
                        [self addSubview:focusRect];
                        //[self performSelector:@selector(dismissFocusRect:) withObject:focusRect afterDelay:1.f];
                        [self dismissFocusRect:focusRect];
                        [device setFocusMode:AVCaptureFocusModeAutoFocus];
                        [device unlockForConfiguration];
                    }
                }
            }
        }
    }
}

- (void)dismissFocusRect:(id)object
{
    UIView *focusRect = (UIView *)object;
    focusRect.alpha = 0;
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            
            [focusRect removeFromSuperview];
            isFocusing = NO;
            
        }];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [animation setFromValue:[NSNumber numberWithFloat:0.0]];
        [animation setToValue:[NSNumber numberWithFloat:1.0]];
        [animation setDuration:0.2f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setAutoreverses:YES];
        [animation setRepeatCount:2];
        [[focusRect layer] addAnimation:animation forKey:@"opacity"];
    }
}
@end


















