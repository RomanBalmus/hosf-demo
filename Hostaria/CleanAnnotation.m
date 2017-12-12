//
//  CleanAnnotation.m
//  Hostaria
//
//  Created by iOS on 11/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "CleanAnnotation.h"

@implementation CleanAnnotation

@synthesize point,grey;

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.point.lat doubleValue];
    theCoordinate.longitude = [self.point.lng doubleValue];
    return theCoordinate;
}


-(MKAnnotationView*)annotationView{
    MKAnnotationView *view = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"MapPoint"];
    view.enabled=YES;
    view.canShowCallout=NO;
    
    
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor whiteColor];
    lbl.tag = 42;
    [lbl setText:@""];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl sizeToFit];
    [lbl setFont:[UIFont systemFontOfSize:7]];
    [view setHidden:NO];

    if (self.grey) {
        //TODO ALL IMAGES TO GREY
        if ([self.point.type isEqualToString:TYPE_STAND] ) {
            
            view.image = [UIImage imageNamed:@"ic_cellar_g"];
            [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
            [lbl setText:point.stand.cellarId];
            
            [view addSubview:lbl];
            return view;
            
        }else if ([self.point.type isEqualToString:TYPE_SERVICE]) {
            
            Service *srv = self.point.service;
            [lbl setText:srv.numeration];
            
            if ([srv.serviceLocalType isEqualToString:TYPE_PARKING]) {
                view.image = [UIImage imageNamed:@"ic_park_g"];
                
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_EVENT_AREA]) {
                view.image = [UIImage imageNamed:@"ic_event_g"];
                [view setHidden:YES];

                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_ENTRANCE]) {
                view.image = [UIImage imageNamed:@"ic_entrance_g"];
                
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_WINE_SELL]) {
                view.image = [UIImage imageNamed:@"ic_shop_wine_g"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_BABY_HO]) {
                view.image = [UIImage imageNamed:@"ic_bh_g"];
                
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_TOILETE]) {
                view.image = [UIImage imageNamed:@"ic_wc_g"];
                
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_TYPIC_PRODUCTS]) {
                view.image = [UIImage imageNamed:@"ic_stand_g"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_FOOD_AREA]) {
                view.image = [UIImage imageNamed:@"ic_food_g"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_PARTNER]) {
                view.image = [UIImage imageNamed:@"ic_partner_g"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_RISTORANTI]) {
                view.image = [UIImage imageNamed:@"ic_special_stand_big_g"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_MONTE_VERONESE]) {
                view.image = [UIImage imageNamed:@"ic_cheese_g"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                [view setHidden:YES];

                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_GEN_SPONSOR]) {
                view.image = [UIImage imageNamed:@"ic_gen_sponsor"];
                [view setHidden:YES];

                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_NORMAL_EVENT]) {
                view.image = [UIImage imageNamed:@"ic_n_event_grey"];
                [view setHidden:YES];

                return view;
                
            }
            
            
        }
        
    }else{
        
        if ([self.point.type isEqualToString:TYPE_STAND] ) {
            
            view.image = [UIImage imageNamed:@"ic_cellar"];
            [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
            [lbl setText:point.stand.cellarId];
            
            [view addSubview:lbl];
            return view;
            
        }else if ([self.point.type isEqualToString:TYPE_SERVICE]) {
            
            Service *srv = self.point.service;
            [lbl setText:srv.numeration];
            
            if ([srv.serviceLocalType isEqualToString:TYPE_PARKING]) {
                view.image = [UIImage imageNamed:@"ic_park"];
                
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_EVENT_AREA]) {
                view.image = [UIImage imageNamed:@"ic_event"];
                [view setHidden:YES];

                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_ENTRANCE]) {
                view.image = [UIImage imageNamed:@"ic_entrance"];
                
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_WINE_SELL]) {
                view.image = [UIImage imageNamed:@"ic_shop_wine"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_BABY_HO]) {
                view.image = [UIImage imageNamed:@"ic_bh"];
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_TOILETE]) {
                view.image = [UIImage imageNamed:@"ic_wc"];
                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_TYPIC_PRODUCTS]) {
                view.image = [UIImage imageNamed:@"ic_stand"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_FOOD_AREA]) {
                view.image = [UIImage imageNamed:@"ic_food"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_PARTNER]) {
                view.image = [UIImage imageNamed:@"ic_partner"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_RISTORANTI]) {
                view.image = [UIImage imageNamed:@"ic_special_stand_big"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                
                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_MONTE_VERONESE]) {
                view.image = [UIImage imageNamed:@"ic_cheese"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height)];
                [view setHidden:YES];

                [view addSubview:lbl];
                return view;
                
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_GEN_SPONSOR]) {
                view.image = [UIImage imageNamed:@"ic_gen_sponsor"];
                [view setHidden:YES];

                return view;
                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_NORMAL_EVENT]) {
                view.image = [UIImage imageNamed:@"ic_n_event"];
                [view setHidden:YES];

                return view;
                
            }
            
            
        }
        
    }
    
    
    return view;
}


@end
