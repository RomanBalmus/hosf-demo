//
//  MyAnnotation.m
//  Hostaria
//
//  Created by iOS on 30/06/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

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
                return view;

                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_ENTRANCE]) {
                view.image = [UIImage imageNamed:@"ic_entrance_g"];
               
                return view;

            }else if ([srv.serviceLocalType isEqualToString:TYPE_RISTORANTI]) {
                view.image = [UIImage imageNamed:@"ic_special_stand_big_g"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height-6)];
                
                [view addSubview:lbl];
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
                return view;

                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_GEN_SPONSOR]) {
                view.image = [UIImage imageNamed:@"ic_gen_sponsor"];
                
                return view;

              }else if ([srv.serviceLocalType isEqualToString:TYPE_NORMAL_EVENT]) {
                view.image = [UIImage imageNamed:@"ic_n_event_grey"];
                
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
              
                return view;

                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_ENTRANCE]) {
                view.image = [UIImage imageNamed:@"ic_entrance"];
             
                return view;

                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_RISTORANTI]) {
                view.image = [UIImage imageNamed:@"ic_special_stand_big"];
                [lbl setFrame:CGRectMake(0, 0, view.image.size.width, view.image.size.height-6)];
                
                [view addSubview:lbl];
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
                
                [view addSubview:lbl];
                return view;

                
            }else if ([srv.serviceLocalType isEqualToString:TYPE_GEN_SPONSOR]) {
                view.image = [UIImage imageNamed:@"ic_gen_sponsor"];
                return view;

            }else if ([srv.serviceLocalType isEqualToString:TYPE_NORMAL_EVENT]) {
                view.image = [UIImage imageNamed:@"ic_n_event"];
                
                return view;
                
            }
            
            
        }

    }
    
    
    return view;
}


/*if ([mp.type isEqualToString:TYPE_STAND] ) {
 
 // GroundOverlayOptions newarkMap = new GroundOverlayOptions();
 
 
 // newarkMap.image(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona_a));
 // newarkMap.position(new LatLng(Double.valueOf(point.getLat()),Double.valueOf(point.getLng())),7f);
 // GroundOverlay go= mMap.addGroundOverlay(newarkMap);
 
 // haspMapGo.put(go, point);
 // builder.include(go.getPosition()); // TODO: 15/06/16 included all items on map should delete (maybe)
 
 
 
 
 Marker m = mMap.addMarker(new MarkerOptions().icon(BitmapDescriptorFactory.fromBitmap(drawTextToBitmap(this, R.drawable.mappa_icona_c, point.getStand().getCellarId()))).position(new LatLng(Double.valueOf(point.getLat()), Double.valueOf(point.getLng()))));
 haspMap.put(m, point);
 builder.include(m.getPosition()); // TODO: 15/06/16 included all items on map should delete (maybe)
 
 }
 
 if ([mp.type isEqualToString:TYPE_SERVICE]) {
 Marker m = mMap.addMarker(new MarkerOptions().position(new LatLng(Double.valueOf(point.getLat()), Double.valueOf(point.getLng()))));
 
 Service *srv = mp.service;
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_PARKING)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona_a));
 
 
 }
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_EVENT)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona9));
 
 
 }
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_ENTRANCE)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona1));
 
 
 }
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_RISTOR)) {
 m.setIcon(BitmapDescriptorFactory.fromBitmap(drawTextToBitmapP(this, R.drawable.mappa_icona_b, srv.getNumeration())));
 
 }
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_WINE_SELL)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona6));
 
 
 }
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_BABY_HO)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona7));
 
 }
 
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_TOILETE)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona12));
 
 }
 
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_FF)) {
 m.setIcon(BitmapDescriptorFactory.fromBitmap(drawTextToBitmap(this, R.drawable.mappa_icona11, srv.getNumeration())));
 
 
 }
 
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_TIPIC)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona8));
 
 
 }
 
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_SPECIAL_RISTOR)) {
 m.setIcon(BitmapDescriptorFactory.fromBitmap(drawTextToBitmap(this, R.drawable.mappa_icona10, srv.getNumeration())));
 
 Log.e("CANCAN", "CAN CAN CAN GRAN CAN");
 
 }
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_CHEESE)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona5));
 
 
 }
 if (srv.getServiceLocalType().equalsIgnoreCase(Constants.TYPE_GEN_SPONSOR)) {
 m.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.mappa_icona4));
 }
 
 
 haspMap.put(m, point);
 builder.include(m.getPosition()); // TODO: 15/06/16 included all items on map should delete (maybe)
 
 
 }
*/
@end
