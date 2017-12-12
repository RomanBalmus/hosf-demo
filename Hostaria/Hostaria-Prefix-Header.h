//
//  Hostaria-Prefix-Header.h
//  Hostaria
//
//  Created by iOS on 13/02/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#ifndef Hostaria_Prefix_Header_h
#define Hostaria_Prefix_Header_h


#define AppDel ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#import "APIManager.h"
#import "PlayerNotificationManager.h"
#import "MDWamp.h"
#import "WampCom.h"
#define API [APIManager sharedInstance]
#define WAMP [WampCom sharedInstance]

#define SPOT [PlayerNotificationManager sharedInstance]
#import "UIDevice+RExtension.h"
#import <Reachability.h>
//#import <PushKit/PushKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Google/SignIn.h>
#import "HomeViewController.h"
#import "MapViewController.h"
#import "ProjectViewController.h"
#import "MyAreaViewController.h"
#import "LoginParentViewController.h"
#import "RegisterParentViewController.h"
//#import <Fabric/Fabric.h>
#import "QuartzCore/QuartzCore.h"
#import <Realm/Realm.h>
//#import <TwitterKit/TwitterKit.h>
#import "CAPSPageMenu.h"
#import "CardIO.h"
#import "PayPalMobile.h"
#import "TicketViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+Letters.h"
#import "IQKeyboardManager.h"
#import "UIView+AUISelectiveBorder.h"
#import "UIImageViewAligned.h"
#import "VIMVideoPlayer.h"
#import "VIMVideoPlayerView.h"

/*
#define APIGetWampDataUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/config/getwamp"
#define APIAppDataUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/events/listactive"
#define APIUsersUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/"
#define APIUsersRegisterUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/users/register"
#define APIUsersLoginUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/users/login"
#define APIGetPaymentNonceURL @"https://gestione.hostariaverona.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APIPayPalGetPaymentNonceURL @"https://gestione.hostariaverona.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APILemonWayGetPaymentNonceURL @"https://gestione.hostariaverona.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APIGetCellarDataURL @"https://gestione.hostariaverona.com/api/V.0.1/post/companies/getallactivecompanies"
#define APIGetStandDataURL @"https://gestione.hostariaverona.com/api/V.0.1/post/companies/getstandcoordinates"
#define APISendFeedbackDataURL @"https://gestione.hostariaverona.com/api/V.0.1/post/companies/products/feedback/save"
#define APIResetPasswordURL @"https://gestione.hostariaverona.com/api/V.0.1/post/users/updatepwdlost"
#define SAVEORDER_URL @"https://gestione.hostariaverona.com/api/V.0.1/post/order/create/new"
#define BUY_WINE_URL @"https://gestione.hostariaverona.com/api/V.0.1/post/ecommerce/order/send-payment"
#define ORDER_LIST @"https://gestione.hostariaverona.com/api/V.0.1/post/order/user/getall"

*/
#define APIGetWampDataUrl @"http://demo.smartfiera.com/api/V.0.1/post/config/getwamp"
#define APIAppDataUrl @"http://demo.smartfiera.com/api/V.0.1/post/events/listactive"
#define APIUsersUrl @"http://demo.smartfiera.com/api/V.0.1/post/"
#define APIUsersRegisterUrl @"http://demo.smartfiera.com/api/V.0.1/post/users/register"
#define APIUsersLoginUrl @"http://demo.smartfiera.com/api/V.0.1/post/users/login"
#define APIGetPaymentNonceURL @"http://demo.smartfiera.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APIPayPalGetPaymentNonceURL @"http://demo.smartfiera.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APILemonWayGetPaymentNonceURL @"http://demo.smartfiera.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APIGetCellarDataURL @"http://demo.smartfiera.com/api/V.0.1/post/companies/getallactivecompanies"
#define APIGetStandDataURL @"http://demo.smartfiera.com/api/V.0.1/post/companies/getstandcoordinates"
#define APISendFeedbackDataURL @"http://demo.smartfiera.com/api/V.0.1/post/companies/products/feedback/save"
#define APIResetPasswordURL @"http://demo.smartfiera.com/api/V.0.1/post/users/updatepwdlost"
#define SAVEORDER_URL @"http://demo.smartfiera.com/api/V.0.1/post/order/create/new"
#define BUY_WINE_URL @"http://demo.smartfiera.com/api/V.0.1/post/ecommerce/order/send-payment"
#define ORDER_LIST @"http://demo.smartfiera.com/api/V.0.1/post/order/user/getall"
/*
#define BUY_WINE_URL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/ecommerce/order/send-payment"
#define ORDER_LIST @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/order/user/getall"
#define SAVEORDER_URL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/order/create/new"
#define APIGetWampDataUrl @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/config/getwamp"
#define APIAppDataUrl @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/events/listactive"
#define APIUsersUrl @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/"
#define APIUsersRegisterUrl @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/users/register"
#define APIUsersLoginUrl @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/users/login"
#define APIGetPaymentNonceURL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APIPayPalGetPaymentNonceURL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APILemonWayGetPaymentNonceURL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/ecommerce/getpaymentnonce"
#define APIGetCellarDataURL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/companies/getallactivecompanies"
#define APIGetStandDataURL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/companies/getstandcoordinates"
#define APISendFeedbackDataURL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/companies/products/feedback/save"
#define APIResetPasswordURL @"http://hostaria-sviluppo.tulain.com/api/V.0.1/post/users/updatepwdlost"
 


*/


//#define APIAppDataUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/events/listactive"
//#define APIUsersUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/"
//#define APIUsersRegisterUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/users/register"
//#define APIUsersLoginUrl @"https://gestione.hostariaverona.com/api/V.0.1/post/users/login"
//#define APIGetPaymentNonceURL @"https://gestione.hostariaverona.com/api/V.0.1/post/ecommerce/getpaymentnonce"
//#define APIPayPalGetPaymentNonceURL @"https://gestione.hostariaverona.com/api/V.0.1/post/ecommerce/getpaymentnonce"
//#define APIResetPasswordURL @"https://gestione.hostariaverona.com/api/V.0.1/post/users/updatepwdlost"
//#define APIGetPaymentNonceURL @"http://hostaria.tulain.com/ecommerce/api/getpaymentnoncetest"
//#define APIGenerateTokenURL @"https://gestione.hostariaverona.com/api/V.0.1/post/ecommerce/createpaypaltoken"
#define APIGenerateTokenURL @"http://hostaria.tulain.com/ecommerce/api/createpaypalproductiontoken"
#define TOKENIZATION_KEY @"sandbox_v6krtpxx_q9k7hcp7c3xwgxwk" // sandbox
//#define TOKENIZATION_KEY @"production_sstdj9nt_df5v7j6t6y4jk9q5"




#define RPC_PINGPONG @"1"
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


#define RPC_DECREMENTCREDITS @"3" //id 3
#define RPC_CHECKCHASDESK @"2" //id 3
#define RPC_TRANSFER @"4" //id 3
#define RPC_COUPLE @"5" //id 3


/*"id","type_name","status","date_creation","revision","is_hidden"
 1,"Ristoranti/Reataurants",1,"2016-09-26 00:00:00",0,0ì
 2,"Sbecolerie / Typical Products",1,"2016-09-26 00:00:01",0,0ì
 3,"Info Point",1,"2016-09-26 00:00:02",0,0
 4,"Hostaria Shop",1,"2016-09-26 00:00:03",0,0
 5,"Ingressi / Entry-info points",1,"2016-09-26 00:00:04",0,0ì
 6,"Conad ",1,"2016-09-26 00:00:05",0,0ì
 7,"Vendita Vino",1,"2016-09-26 00:00:06",0,0ì
 8,"Baby Hostaria",1,"2016-09-26 00:00:07",0,0ì
 9,"Wc",1,"2016-09-26 00:00:08",0,0ì
 10,"Cantoni AGSM - Musica Area",1,"2016-09-26 00:00:09",0,0ì
 11,"Parcheggi",1,"2016-09-26 00:00:10",0,0ì
 
 12,"Monte Veronese Village",1,"2016-09-26 00:00:11",0,0
 13,"Partner",1,"2016-09-26 00:00:12",0,0
 
 14,"Aree Degustazione ",1,"2016-09-26 00:00:13",0,0
 15,"Eventi",1,"2016-09-26 00:00:13",0,0

 */

#define TYPE_CELLAR  @"cellar"

#define TYPE_RISTORANTI  @"ristor"
#define TYPE_TYPIC_PRODUCTS @"typicproducts"
#define TYPE_EVENT_AREA @"eventarea"
#define TYPE_INFO_POINT @"infopoint"

#define TYPE_HO_SHOP @"hoshop"
#define TYPE_PARTNER @"partner"
#define TYPE_FOOD_AREA @"foodarea"



#define TYPE_STAND @"stand"
#define TYPE_WINE @"wine"
#define TYPE_ENTRANCE @"entrance"
#define TYPE_PARKING @"parking"
#define TYPE_SERVICE @"service"
#define TYPE_TOILETE @"toilete"
#define TYPE_WINE_SELL @"winesell"
#define TYPE_SPECIAL_RISTOR @"specristor"
#define TYPE_BABY_HO @"babyho"
#define TYPE_GEN_SPONSOR @"conad"
#define TYPE_NORMAL_EVENT @"eventinormali"

#define TYPE_MONTE_VERONESE @"monteveronese"



/* winecategoryId
 6 vino spumante
 5 	vino rose
 3 	vino bianco
 1 	vino rosso*/


/*V0.0.3 12 sept 2016 16:33*/

#endif /* Hostaria_Prefix_Header_h */
