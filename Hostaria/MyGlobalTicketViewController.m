//
//  MyGlobalTicketViewController.m
//  Hostaria
//
//  Created by iOS on 30/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MyGlobalTicketViewController.h"
#import "TicketInfoValidityCell.h"
#import "TicketInfoHeaderCell.h"
#import <Coreimage/CoreImage.h>
#import "Base64/Base64.h"
#import "FeedbackViewController.h"
#import "Event.h"
#import "PresentationViewController.h"
#import "FeedbackListViewController.h"

@interface MyGlobalTicketViewController (){
    NSInteger increment;
    UIColor *segmentSelectedColor;
    NSMutableDictionary *myTicket;
    BOOL shareable;
    WSCoachMarksView *coachMarksView;
    UIImageView *temptumb;
    UIImageView *fullview;
    BOOL feedbackFlag;
    NSDictionary*feedbackDictionaryToSend;
    UINavigationController*parentNav;
}

@end

@implementation MyGlobalTicketViewController
-(void)setNaviGation:(UINavigationController *)nav{
    parentNav=nav;
    
}
- (void)qrCodeTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"touch: %@", [gestureRecognizer view]);
    //create new image
    temptumb=(UIImageView *)gestureRecognizer.view;
    //temptumb=thumbnail;
    fullview=[[UIImageView alloc]init];
    [fullview setContentMode:UIViewContentModeScaleAspectFit];
    fullview.image = [(UIImageView *)gestureRecognizer.view image];
    CGRect point=[self.view convertRect:gestureRecognizer.view.bounds fromView:gestureRecognizer.view];
    [fullview setFrame:point];
    [self.qrImageView setHidden:YES];

    [self.view addSubview:fullview];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [fullview setFrame:CGRectMake(0,
                                                       0,
                                                       self.view.bounds.size.width,
                                                       self.view.bounds.size.height)];
                     }];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullimagetapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [fullview addGestureRecognizer:singleTap];
    [fullview setUserInteractionEnabled:YES];
}
- (void)fullimagetapped:(UIGestureRecognizer *)gestureRecognizer {
    
    CGRect point=[self.view convertRect:temptumb.bounds fromView:temptumb];
    
    gestureRecognizer.view.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.5
                     animations:^{
                         [(UIImageView *)gestureRecognizer.view setFrame:point];
                     }];
    [self performSelector:@selector(animationDone:) withObject:[gestureRecognizer view] afterDelay:0.4];
    
}

-(void)animationDone:(UIView  *)view
{
    [self.qrImageView setHidden:NO];

    [fullview removeFromSuperview];
    fullview=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.countLeft setHidden:YES];

    myTicket=[[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:@"current_favorite_ticket"]];

    increment = 0;
    // Do any additional setup after loading the view from its nib.
  //  UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnView:)];
  //  tap.numberOfTapsRequired=1;
  //  [self.view addGestureRecognizer:tap];
    
    
    UISwipeGestureRecognizer*swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeSelfUp)];
    swipe.direction=UISwipeGestureRecognizerDirectionUp;
     swipe.enabled=YES;
     [self.view addGestureRecognizer:swipe];
    UINib *header = [UINib nibWithNibName:@"TicketInfoHeaderCell" bundle:nil];
    UINib *valCell = [UINib nibWithNibName:@"TicketInfoValidityCell" bundle:nil];
    
    [self.infoTableView registerNib:header forCellReuseIdentifier:@"ticketheadercell"];
    [self.infoTableView registerNib:valCell forCellReuseIdentifier:@"ticketinfovaliditycell"];
    self.infoTableView.delegate=self;
    self.infoTableView.dataSource=self;
    
    NSMutableDictionary *togodata = [[NSMutableDictionary alloc]init];
    
    NSString *topic = [NSString stringWithFormat:@"com.%@.%@",[myTicket objectForKey:@"ticketQrcode"],[myTicket objectForKey:@"idUser"]].lowercaseString;
    
    NSLog(@"topic: %@",topic);
    
    [togodata setObject:topic forKey:@"topic"];
    [togodata setObject:[myTicket objectForKey:@"ticketQrcode"] forKey:@"qr_code"];
    [togodata setObject:[myTicket objectForKey:@"idUser"] forKey:@"id_user"];
    [togodata setObject:[myTicket objectForKey:@"ticketNumber"] forKey:@"ticket_id"];
    [togodata setObject:[myTicket objectForKey:@"userCredits"] forKey:@"user_credits"];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:togodata options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    
    WAMP.delegate=self;
    [WAMP subScribeToOwner:topic];
    
    
    self.qrImageView.image=[self getQRimageFromString:[myString base64EncodedString]];

    NSDictionary *userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    NSString *name = [NSString stringWithFormat:@"%@ %@",[userData objectForKey:@"name"] ,[userData objectForKey:@"surname"] ];
    NSString *greetings = [NSString stringWithFormat:@"%@",name.length > 3 ? name : [userData objectForKey:@"email"]];
    
    self.ownerName.text=greetings;
    self.ticketType.text=[myTicket objectForKey:@"ticketName"];
    if ([[NSString stringWithFormat:@"%@",[myTicket objectForKey:@"bus"]] isEqualToString:@"1"]) {
        [self.atvTicketImageView setHidden:NO];
    }else{
        [self.atvTicketImageView setHidden:YES];
        
    }
    [self.skipButton addTarget:self action:@selector(swipeSelfUp) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"my ticket : %@",myTicket);
    [self.infoTableView reloadData];
    
    
    [self.transferActionButton addTarget:self action:@selector(showShareAlert) forControlEvents:UIControlEventTouchUpInside];

    [self updateCount];
    
    
    PresentationViewController *present=[[PresentationViewController alloc]initWithNibName:@"PresentationViewController" bundle:nil];
    [present.view setFrame:self.helpView.frame];
    [present setAdditional];
    [self addChildViewController:present];
    [self.helpView addSubview:present.view];
    [present didMoveToParentViewController:self];
    self.qrImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qrCodeTapped:)];
    tap.numberOfTapsRequired=1;
    [self.qrImageView addGestureRecognizer:tap];

}
-(void)updateCount{
    self.totalCount.text=[NSString stringWithFormat:@"%@",[myTicket objectForKey:@"userCredits"]];
    [self.countLeft setText:[NSString stringWithFormat:@"Ti rimangono %@ degustazioni",self.totalCount.text]];
    
    if ([[myTicket objectForKey:@"userCredits"]integerValue]==0) {
        [self.countLeft setText:@"Degustazioni Esaurite!"];
    }
}

-(void)wampTOPICResponceError:(WampCom *)manager withData:(id)item{
    ///
}
-(void)wampTOPICResponceSuccess:(WampCom *)manager withData:(id)item{
    feedbackFlag=NO;
    feedbackDictionaryToSend=nil;
    NSDictionary *userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    NSMutableArray *newtickets=[[NSMutableArray alloc]init];
    NSMutableDictionary *innuserData= [[NSMutableDictionary alloc]initWithDictionary:userData];
    NSMutableDictionary *myTickets=[[NSMutableDictionary alloc]init];
    NSMutableArray *mytick=[[userData objectForKey:@"myTickets"]mutableCopy];
    
    
    
    NSLog(@"item : %@",item);
    NSDictionary *data = (NSDictionary*)item;
    
    
    
    if([[NSString stringWithFormat:@"%@",[data objectForKey:@"type_request"]]isEqualToString:RPC_TRANSFER]){
        
        for (NSDictionary *tckt in mytick) {
            
            if ([[tckt objectForKey:@"ticketNumber"]isEqual:[data objectForKey:@"ticket_id"]]) {
                
            }else{
                [newtickets addObject:tckt];
                
            }
            
        }
        
        
        
        
        [myTickets setObject:newtickets forKey:@"myTickets"];
        
        [innuserData addEntriesFromDictionary:myTickets ];
        
        [[NSUserDefaults standardUserDefaults]setObject:innuserData forKey:@"current_user_data"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        NSLog(@"userdata now:%@",userData);
    }
    if([[NSString stringWithFormat:@"%@",[data objectForKey:@"type_request"]]isEqualToString:RPC_COUPLE]){
        
        
        for (NSDictionary *tckt in mytick) {
            
            if ([[tckt objectForKey:@"ticketNumber"]isEqual:[data objectForKey:@"ticket_id"]]) {
                NSMutableDictionary *mdict=[[NSMutableDictionary alloc]initWithDictionary:tckt];
                [mdict setObject:@"1" forKey:@"shared"];
            }
            
            [newtickets addObject:tckt];
        }
        
        
        
        
        [myTickets setObject:newtickets forKey:@"myTickets"];
        
        [innuserData addEntriesFromDictionary:myTickets ];
        
        [[NSUserDefaults standardUserDefaults]setObject:innuserData forKey:@"current_user_data"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        NSLog(@"userdata now:%@",userData);
        
        
    }
    if([[NSString stringWithFormat:@"%@",[data objectForKey:@"type_request"]]isEqualToString:RPC_DECREMENTCREDITS]){
        
        
        for (NSDictionary *tckt in mytick) {
            
            NSMutableDictionary *mdict=[[NSMutableDictionary alloc]initWithDictionary:tckt];
            
            if ([[tckt objectForKey:@"ticketNumber"]isEqual:[data objectForKey:@"ticket_id"]]) {
                [mdict setObject:[data objectForKey:@"current_credits"] forKey:@"userCredits"];
                
                NSLog(@"need to update this one: %@",mdict);
                
                NSDictionary*fav=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_favorite_ticket"];

                if ([[tckt objectForKey:@"ticketNumber"]isEqual:[fav objectForKey:@"ticketNumber"]]) {
                    NSMutableDictionary *favdict=[[NSMutableDictionary alloc]initWithDictionary:fav];
                    [favdict setObject:[data objectForKey:@"current_credits"] forKey:@"userCredits"];
                    [[NSUserDefaults standardUserDefaults]setObject:favdict forKey:@"current_favorite_ticket"];
                    [[NSUserDefaults standardUserDefaults]synchronize];

                }
                
       


            }
            
            
            [newtickets addObject:mdict];
            
        }
        
        
        
        [myTickets setObject:newtickets forKey:@"myTickets"];
        
        [innuserData addEntriesFromDictionary:myTickets ];
        
        [[NSUserDefaults standardUserDefaults]setObject:innuserData forKey:@"current_user_data"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.view setNeedsDisplay];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTable" object:nil];

        NSLog(@"userdata now:%@",userData);
        
        if ([item objectForKey:@"feedback"] == [NSNull null]) {
            // Display the alert
            NSLog(@"null feedback");

            return;
        }
        NSMutableArray *feedbackgroups = [(NSDictionary*)item objectForKey:@"feedback"];
        
      
        if (feedbackgroups.count==0) {
            NSLog(@"no sufficient credits error");
            return;
        }
        feedbackFlag=YES;
        
        feedbackDictionaryToSend=[NSDictionary dictionaryWithDictionary:(NSDictionary*)item];

    }
    if([[NSString stringWithFormat:@"%@",[data objectForKey:@"type_request"]]isEqualToString:RPC_CHECKCHASDESK]){
        NSLog(@"activity data here:%@",data);
        
        //NSMutableArray * events = [data objectForKey:@"events"];
        
        if (/*events.count>0 && */![self notificationsEnabled]) {
            
            
            [self prePermissionAsk];
        }
        /*for (NSDictionary *evnt in events) {
            NSLog(@"activity here:%@",evnt);
            //  [self scheduledEventNotificationWithTime:15 andEvent:evnt];
            
            Event *vnt = [[Event alloc]init];
            vnt.address=[evnt objectForKey:@"address"];
            vnt.name=[evnt objectForKey:@"typeName"];
            // TOADD STARTDATE INIT DATE STOP DATE
            vnt._id=[NSString stringWithFormat:@"%ld",[[evnt objectForKey:@"id"]integerValue]];
            vnt.fired=@"0";
            RLMRealm *rlm = [RLMRealm defaultRealm];
            [rlm beginWriteTransaction];
            [rlm addObject:vnt];
            [rlm commitWriteTransaction];
            
        }*/
    }
    
    [self removeTransfer];
    [self swipeSelfUp];
     

}
- (BOOL)notificationsEnabled {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return settings.types != UIUserNotificationTypeNone;
}




-(void)prePermissionAsk{
    
    UIAlertController *alertController1 = [UIAlertController
                                           alertControllerWithTitle:@"Non perdere nessun evento!"
                                           message:@"Permette all'app di inviarti una notifica quando un evento sta per iniziare!"
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Annulla"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Vai"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"Cancel action");
                                   
                                   
                                   // The following line must only run under iOS 8. This runtime check prevents
                                   // it from running if it doesn't exist (such as running under iOS 7 or earlier).
                                   if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                                       [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
                                   }
                                   
                                   
                                   
                               }];
    [alertController1 addAction:cancelAction];
    
    [alertController1 addAction:okAction];
    
    [self presentViewController:alertController1 animated:YES completion:nil];
}

-(void)swipeSelfUp{
    [UIView
     animateWithDuration:0.5
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^(void){
         self.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
         
         //self.view.alpha = 0.0;
     }
     completion:^(BOOL finished) {
         [self dismissViewControllerAnimated:YES completion:^(void){
           
         }];
         [WAMP UnSubscribeFromOwner];

         if (feedbackFlag) {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"showfeedback" object:self userInfo:feedbackDictionaryToSend];
             
         }
     }
     ];
}
-(void)scheduledEventNotificationWithTime:(NSInteger)seconds andEvent:(NSDictionary*)evnt{
    UILocalNotification* n1 = [[UILocalNotification alloc] init];
    n1.fireDate = [NSDate dateWithTimeIntervalSinceNow: seconds];
    n1.alertBody = @"one";
    [[UIApplication sharedApplication] scheduleLocalNotification: n1];
    
}




-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [WAMP UnSubscribeFromOwner];
}

-(void)singleTapOnView:(UIGestureRecognizer*)gesture{
    
    
    
    
    
    if (increment==10) {
        //increment = 0;
        //[self.glassView setImage:[UIImage imageNamed:@"log-half-empty0"]];
        if (self.countLeft.hidden) {
            [self.countLeft setText:@"Degustazioni Esaurite!"];
            [self.countLeft setHidden:NO];
        }
    }else{
        increment ++;
        
        NSLog(@"increment: %ld",(long)increment);
        [self.totalCount setText:[NSString stringWithFormat:@"%ld",(long)increment]];
        [self.glassView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"log-half-empty%ld",(long)increment]]];
    }
    /*switch (increment) {
     case 0:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 1:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 2:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 3:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 4:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 5:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 6:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 7:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 8:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 9:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     case 10:
     [botoomIV setImage:[UIImage imageNamed:@""]];
     
     break;
     default:
     break;
     }*/
    
}
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}
- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
-(void)incrementImageView:(UIImageView*)imageView label:(UILabel*)labl byIncrement:(NSInteger*)integer{
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // [self animateSplitAndMove];
    if (shareable) {
        [self.transferActionButton setHidden:NO];
    }else{
        [self.transferActionButton setHidden:YES];
        
        
    }
}
/*-(void)animateSplitAndMove{
 botoomIV=[[UIImageView alloc]initWithFrame:CGRectMake(self.logoImageView.frame.origin.x, 0,  self.logoImageView.frame.size.width, self.logoImageView.frame.size.height / 2.0)];
 [botoomIV setImage:[UIImage imageNamed:@"log-half-empty0"]];
 botoomIV.contentMode=UIViewContentModeScaleAspectFit;
 [self.otherHalfView addSubview:botoomIV];
 [self animateImageView:botoomIV];
 }
 
 -(void)animateImageView:(UIImageView*)vottomIv{
 countLabel = [[UILabel alloc]init];
 countLabel.textAlignment=NSTextAlignmentCenter;
 qrCodeView = [[UIView alloc]init];
 [self.otherHalfView addSubview:qrCodeView];
 [self.otherHalfView bringSubviewToFront:vottomIv];
 [vottomIv addSubview:countLabel];
 [qrCodeView setBackgroundColor:[UIColor colorWithPatternImage:[self createNonInterpolatedUIImageFromCIImage:[self createQRForString:@"456456"] withSize:CGSizeMake( self.otherHalfView.frame.size.width-80, self.otherHalfView.frame.size.height-vottomIv.frame.size.height-80)]]];
 qrCodeView.contentMode=UIViewContentModeScaleAspectFit;
 [UIView animateWithDuration:0.1 animations:^{
 
 
 qrCodeView.frame = CGRectMake(40, 40, self.otherHalfView.frame.size.width-80, self.otherHalfView.frame.size.height-vottomIv.frame.size.height-80 );
 
 vottomIv.frame =CGRectMake(vottomIv.frame.origin.x,
 self.otherHalfView.bounds.size.height-vottomIv.frame.size.height,
 vottomIv.frame.size.width,
 vottomIv.frame.size.height);
 [countLabel setFrame: CGRectMake(vottomIv.frame.size.width/2-10, self.otherHalfView.bounds.origin.y-7.5, 20, 15)];
 [countLabel setText:[NSString stringWithFormat:@"%ld",(long)increment]];
 
 
 
 }];
 }
 */
- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}



- (UIImage *)fixOrientationForImage:(UIImage*)neededImage {
    
    // No-op if the orientation is already correct
    if (neededImage == UIImageOrientationUp) return neededImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (neededImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.width, neededImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, neededImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (neededImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, neededImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, neededImage.size.width, neededImage.size.height,
                                             CGImageGetBitsPerComponent(neededImage.CGImage), 0,
                                             CGImageGetColorSpace(neededImage.CGImage),
                                             CGImageGetBitmapInfo(neededImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (neededImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,neededImage.size.height,neededImage.size.width), neededImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,neededImage.size.width,neededImage.size.height), neededImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
    
    segmentSelectedColor =  [self getUIColorObjectFromHexString:@"#BD172C" alpha:1] ;
    UIImageView* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;
    [self.mySegment setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [self.mySegment setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    if ([[[self.mySegment subviews] firstObject] respondsToSelector:@selector(setTintColor:)]) {
        for (id segment in [self.mySegment subviews]) {
            if ([segment respondsToSelector:@selector(isSelected)] && [segment isSelected]) {
                [segment setTintColor:segmentSelectedColor];
            } else {
                [segment setTintColor:[UIColor grayColor]];
            }
        }
    }
    [self.mySegment setSelectedSegmentIndex:0];
    
    [self updateTicket:nil];

}



-(void)showShareAlert{
    NSLog(@"click");
    UIAlertController *alertController1 = [UIAlertController
                                           alertControllerWithTitle:@"Invia questo biglietto ad un'altra persona!"
                                           message:@"Per trasferire il tuo biglietto mostra il seguente Qr-Code ad un'altra persona che usa l'app Hostaria, attraverso la funzionalità Trasferisci, che troverà in  Profilo > Trasferisci.\nNB. Il biglietto è trasferibile fino al suo utilizzo."
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Annulla"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Vai"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"Cancel action");
                                   
                                   
                                   
                                   
                                   
                                   if (shareable) {
                                       [self setupTransfer];
                                   }else{
                                       [self showNoTrnsferError];
                                   }
                                   
                                   
                                   
                                   
                               }];
    [alertController1 addAction:cancelAction];
    
    [alertController1 addAction:okAction];
    
    [self presentViewController:alertController1 animated:YES completion:nil];
}
-(void)updateTicket:(id)sender{
    
    if ([[NSString stringWithFormat:@"%@", myTicket[@"shared"]]isEqualToString:@"0"]) {
        NSLog(@"shjareable");
        
        shareable=YES;
        
    }else{
        shareable=NO;
        
        
    }
    
    
    
}

-(void)showNoTrnsferError{
    UIAlertController *alertController1 = [UIAlertController
                                           alertControllerWithTitle:@"Il ticket:"
                                           message:@"Non è piu shareable."
                                           preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"Cancel action");
                              
                                   
                               }];
    
    [alertController1 addAction:okAction];
    
    [self presentViewController:alertController1 animated:YES completion:nil];
}

-(void)setupTransfer{
    // Setup coach marks
    [self.mySegment setEnabled:NO];

    NSMutableDictionary *togodata = [[NSMutableDictionary alloc]init];
    
    NSString *topic = [NSString stringWithFormat:@"com.%@.%@",[myTicket objectForKey:@"ticketQrcode"],[myTicket objectForKey:@"idUser"]].lowercaseString;
    
    NSLog(@"topic: %@",topic);
    
    [togodata setObject:topic forKey:@"topic"];
    
    
    
    
    [togodata setObject:[myTicket objectForKey:@"ticketQrcode"] forKey:@"qr_code"];
    [togodata setObject:[myTicket objectForKey:@"idUser"] forKey:@"id_user_owner"];
    [togodata setObject:[myTicket objectForKey:@"ticketNumber"] forKey:@"ticket_id"];
    [togodata setObject:@"1" forKey:@"transfer"];
    
    
    
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:togodata options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    self.qrImageView.image=[self getQRimageFromString:[myString base64EncodedString]];
    
    
    
    
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:CGRectMake(self.qrImageView.frame.origin.x, self.ticketView.frame.origin.y, self.qrImageView.frame.size.width, self.qrImageView.frame.size.height) ],
                                @"caption": @"Pronto per il transferimento!",
                                @"shape": @"circle",
                                }
                            ];
    
    if (coachMarksView==NULL) {
        coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.frame coachMarks:coachMarks];
        coachMarksView.delegate=self;

    }
    [self.view addSubview:coachMarksView];
    [coachMarksView start];
}

-(void)coachMarksViewDidCleanup:(WSCoachMarksView *)coachMarksView{
    NSLog(@"cleanup did");
    [self removeTransfer];
}


-(void)removeTransfer{
    [self.mySegment setEnabled:YES];

    NSMutableDictionary *togodata = [[NSMutableDictionary alloc]init];
    
    NSString *topic = [NSString stringWithFormat:@"com.%@.%@",[myTicket objectForKey:@"ticketQrcode"],[myTicket objectForKey:@"idUser"]].lowercaseString;
    
    NSLog(@"topic: %@",topic);
    
    [togodata setObject:topic forKey:@"topic"];
    [togodata setObject:[myTicket objectForKey:@"ticketQrcode"] forKey:@"qr_code"];
    [togodata setObject:[myTicket objectForKey:@"idUser"] forKey:@"id_user"];
    [togodata setObject:[myTicket objectForKey:@"ticketNumber"] forKey:@"ticket_id"];
    [togodata setObject:[myTicket objectForKey:@"userCredits"] forKey:@"user_credits"];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:togodata options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    self.qrImageView.image=[self getQRimageFromString:[myString base64EncodedString]];

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)segmentChangedTheValue:(id)sender {
    
    NSLog(@"changed value: %ld",self.mySegment.selectedSegmentIndex);
    if ([[[sender subviews] firstObject] respondsToSelector:@selector(setTintColor:)]) {
        for (id segment in [sender subviews]) {
            if ([segment respondsToSelector:@selector(isSelected)] && [segment isSelected]) {
                [segment setTintColor:segmentSelectedColor];
            } else {
                [segment setTintColor:[UIColor grayColor]];
            }
        }
    }
    
    if (self.mySegment.selectedSegmentIndex==0) {
        
        [self showTicket];
    }else if (self.mySegment.selectedSegmentIndex==1){
        [self showInfo];
        
    }else if (self.mySegment.selectedSegmentIndex==2){
        [self showHelp];
        
    }
    
    
}

-(void)showTicket{
    [self.ticketView setHidden:NO];
    [self.infoView setHidden:YES];
    [self.helpView setHidden:YES];
    
    
}
-(void)showInfo{
    [self.infoView setHidden:NO];
    [self.ticketView setHidden:YES];
    [self.helpView setHidden:YES];
    [self.infoTableView reloadData];
    
}
-(void)showHelp{
    [self.ticketView setHidden:YES];
    [self.infoView setHidden:YES];
    [self.helpView setHidden:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TicketInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketheadercell"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 127;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketInfoValidityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketinfovaliditycell" forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.validityLabel.text=@"Venerdì 14 ottobre: 18:00-24:00\nSabato 15 ottobre: 11:00-22:00\nDomenica 16 ottobre: 11:00-20:00\n\nChiusura casse 2 ore prima del termine della manifestazione\n";//OLD @"Venerdi 14 ottobre e Sabato 15 ottobre 2016\n@20:00 - 24:00\nDomenica 16 ottobre 2016\n@16:00 - 22:00";
        cell.validityLabel.textAlignment=NSTextAlignmentCenter;

    }else{
        //NSBundle *myBundle = [NSBundle mainBundle];
       // NSString *sFile= [myBundle pathForResource:@"operativity" ofType:@"docx"];
        NSError * error;
        NSURL *fileUrl1 = nil ;
        
        if ([[[myTicket objectForKey:@"ticketName"]lowercaseString]isEqualToString:@"ingresso di coppia"]) {
            fileUrl1=[[NSBundle mainBundle]URLForResource:@"couple" withExtension:@"txt"];
        }else if ([[[myTicket objectForKey:@"ticketName"]lowercaseString]isEqualToString:@"ingresso giornaliero"]){
            fileUrl1=[[NSBundle mainBundle]URLForResource:@"obedayticket" withExtension:@"txt"];

        }else if ([[[myTicket objectForKey:@"ticketName"]lowercaseString]isEqualToString:@"ingresso di coppia + bus"]){
            fileUrl1=[[NSBundle mainBundle]URLForResource:@"couplebus" withExtension:@"txt"];

        }else if ([[[myTicket objectForKey:@"ticketName"]lowercaseString]isEqualToString:@"ingresso giornaliero + bus"]){
            fileUrl1=[[NSBundle mainBundle]URLForResource:@"onedaybus" withExtension:@"txt"];

        }else if ([[[myTicket objectForKey:@"ticketName"]lowercaseString]isEqualToString:@"abbonamento 3 giorni + bus"]){
            fileUrl1=[[NSBundle mainBundle]URLForResource:@"threedaybus" withExtension:@"txt"];

        }else if ([[[myTicket objectForKey:@"ticketName"]lowercaseString]isEqualToString:@"abbonamento 3 giorni"]){
            fileUrl1=[[NSBundle mainBundle]URLForResource:@"threeday" withExtension:@"txt"];
        }else{
            fileUrl1=[[NSBundle mainBundle]URLForResource:@"oper" withExtension:@"txt"];
        }

        NSString *myText = [NSString stringWithContentsOfURL:fileUrl1 encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"error: %@",[error localizedDescription]);
        cell.validityLabel.text=myText;//@"fdslouyfhasdukfgd hgufdisghdfsiughdfusi gdfshgui dshgio shduif hsdfu hdsf husdfhg lidsfhguidfn lkghsdu ihsdfoiu hgsdflhgsldiughfdiugsh uigfhdsghfd lgudfhiusldf";
        cell.validityLabel.textAlignment=NSTextAlignmentLeft;
        
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - Private

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}
-(UIImage*)getQRimageFromString:(NSString*)text{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //    NSLog(@"filterAttributes:%@", filter.attributes);
    
    [filter setDefaults];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:10.0];
    
    
    CGImageRelease(cgImage);
    return resized;
}
/*-(void)disableTicket:(NSDictionary*)ticket{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Split the date into components but only take the year, month and day and leave the rest behind
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]]; // Current Date
    
    // Build the date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    // Convert the string time into an NSDate
    NSDate *time = [formatter dateFromString:@"1:59 PM"]; //your hour:minutes am/pm values
    
    // Split this one in components as well but take the time part this time
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:time];
    
    // Do some merging between the two date components
    dateComponents.hour = timeComponents.hour;
    dateComponents.minute = timeComponents.minute;
    
    // Extract the NSDate object again
    NSDate *fireTime = [calendar dateFromComponents:dateComponents];
    
    NSLog(@"Fire Time is  FireTime %@", fireTime);
    localNotification.fireDate = fireTime;
}*/
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (IBAction)degustazioniBtn:(id)sender {
    NSLog(@"cliocked");
  
    [self swipeSelfUp2];
    
}

-(void)swipeSelfUp2{
    [UIView
     animateWithDuration:0.5
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^(void){
         self.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
         
         //self.view.alpha = 0.0;
     }
     completion:^(BOOL finished) {
         [self dismissViewControllerAnimated:YES completion:^(void){
             
         }];
         [WAMP UnSubscribeFromOwner];
         
         [[NSNotificationCenter defaultCenter]postNotificationName:@"showFeedbackList" object:nil];

     }
     ];
}
@end
