//
//  ProjectViewController.m
//  Hostaria
//
//  Created by iOS on 05/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ProjectViewController.h"
#import "HostariaDescriptionCell.h"
#import "ProjectTopHeader.h"
#import "NSMutableAttributedString+Color.h"
@interface ProjectViewController ()<HostariaCellDelegate>{
    CGFloat originX;
  //  UIImageView *circle;
    ProjectTopHeader *topheader;
    NSIndexPath *lastSelectedIndexPath;

}
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) UINib *cellNib;
@property (strong, nonatomic) NSDictionary *titleDescriptions;
@property (strong, nonatomic) NSArray *descrTitles;
@property (strong, nonatomic) NSMutableSet *expandedIndexPaths;
@end

@implementation ProjectViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
            
        self.headerNib = [UINib nibWithNibName:@"ProjectTopHeader" bundle:nil];
        self.cellNib = [UINib nibWithNibName:@"HostariaDescriptionCell" bundle:nil];

    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
  //  [self.navigationController setNavigationBarHidden:YES];
    
    
   /* circle= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44px"]] ;
    CGRect frame=circle.frame;
    frame.size.height=44;
    frame.size.width=44;
    
    circle.frame = frame;
    circle.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = circle;*/
    
    //[circle setFrame:CGRectMake(0, 0, 88, 88)];
    // circle.layer.cornerRadius = circle.frame.size.width/2;
    // _circle.layer.borderColor = [UIColor whiteColor].CGColor;
    // _circle.layer.borderWidth = 10;
    //circle.layer.masksToBounds = YES;
   // originX = self.navigationController.navigationBar.frame.size.width/2- (circle.frame.size.width/2);
    // UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    // [keyWindow addSubview:circle];
   // [self.navigationController.navigationBar addSubview:circle];
    /* Screen width: the initial position of the circle = center + screen width. */
   // CGFloat width = self.view.bounds.size.width;
    
  //  CGRect destination = circle.frame;
  //  destination.origin.x = originX;
    
    /* The transition coordinator is only available for animated transitions. */
  /*  if (animated) {
        CGRect frame = destination;
        frame.origin.x += width;
        circle.frame = frame;
        
        void (^animation)(id context) = ^(id context) {
            circle.frame = destination;
        };
        
        [self.transitionCoordinator animateAlongsideTransitionInView:circle
                                                           animation:animation
                                                          completion:animation];
    }else {
        circle.frame = destination;
    }*/

    [self updateTicket:nil];
    NSLog(@"im on project");


}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    for (NSIndexPath *indexPath in self.myTable.indexPathsForSelectedRows) {
        [self.myTable deselectRowAtIndexPath:indexPath animated:NO];
    }
    [self.myTable reloadData];
    NSLog(@"reload dataa");
}
-(void)showMyTicket{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMyTicket" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Locate your layout
    
  

    // Also insets the scroll indicator so it appears below the search bar
    //self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
   // self.headerNib = [UINib nibWithNibName:@"ProjectTopHeader" bundle:nil];
    self.cellNib = [UINib nibWithNibName:@"HostariaDescriptionCell" bundle:nil];

   [self.myTable registerNib:self.cellNib forCellReuseIdentifier:@"descriptionCell"];
   // [self.myTable registerNib:self.headerNib forCellReuseIdentifier:@"header"];
    self.myTable.delegate=self;
    self.myTable.dataSource=self;
    self.expandedIndexPaths = [NSMutableSet set];
   
   // self.myTable.contentInset=UIEdgeInsetsMake(20, 0, 0, 0);


    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTicket:) name:@"updateTicket" object:nil];

    
    
    
}
-(void)updateTicket:(id)sender{
    
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"current_user_data"];
    
    UIButton *ticket =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ticket setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [ticket addTarget:self action:@selector(showMyTicket)forControlEvents:UIControlEventTouchUpInside];
    [ticket setFrame:CGRectMake(0, 0, 54, 44)];
    if ([[dict objectForKey:@"myTickets"]count]>0) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ticket];
        
    }else{
        [ticket removeFromSuperview];
        self.navigationItem.rightBarButtonItem=nil;
        
    }
    
    
}
-(void)dealloc{
   // [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(CGFloat)indipendentFrame{
    /* NSLog(@"current size: %f",screenHeight);
     
     if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
     {
     NSLog(@"All iPads");
     }
     else
     {
     if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
     {
     if( screenHeight == 568 )
     {
     NSLog(@"iPhone 5/5c/5s");
     CGRect newFrame = self.videoView.frame;
     newFrame.size = CGSizeMake(self.videoView.frame.size.width, 180);
     self.videoView.frame = newFrame;
     }
     else if ( screenHeight == 736 )
     {
     NSLog(@" iPhones 6+/6s+ ");
     CGRect newFrame = self.videoView.frame;
     newFrame.size = CGSizeMake(self.videoView.frame.size.width, 233);
     self.videoView.frame = newFrame;
     }
     else if ( screenHeight == 667 )
     {
     NSLog(@" iPhones 6/6s ");
     }
     else
     {
     NSLog(@"iPhone 4s and others");
     CGRect newFrame = self.videoView.frame;
     newFrame.size = CGSizeMake(self.videoView.frame.size.width, 180);
     self.videoView.frame = newFrame;
     
     }
     }
     }*/
   // NSLog(@"check");
    CGFloat h = 218; //iphone 6 / 6s - good
  //  NSLog(@"current %lu",(unsigned long)[[UIDevice currentDevice]ntnu_deviceType]);
    
    switch ([[UIDevice currentDevice]ntnu_deviceType]) {
            
        case DeviceAppleiPhone4S:
            NSLog(@"iPhone 4s"); //good
            h= 186;
            break;
        case DeviceAppleiPhone5S:
            NSLog(@"iPhone 5s");
            h= 186;
            break;
        case DeviceAppleiPhone5C:
            NSLog(@"iPhone 5c");
            h= 186;
            break;
            
        case DeviceAppleiPhone5:
            NSLog(@"iPhone 5");
            h= 186;
            break;
        case DeviceAppleiPhone6_Plus:
            NSLog(@"iPhone 6+");
            h= 233;
            break;
        default:
            break;
    }
    
    
    return h;
}



/*-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self indipendentFrame];
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
  // [topheader.playerView.player play];
}
-(void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
   // [topheader.playerView.player pause];
}
/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (topheader==NULL) {
        topheader=(ProjectTopHeader*)[self.myTable dequeueReusableCellWithIdentifier:@"header"];
       // NSBundle *bundle = [NSBundle mainBundle];
       // NSURL *url = [NSURL fileURLWithPath:[bundle pathForResource:@"spot" ofType:@"mp4"]];
        //[topheader.playerView.player setURL:url];
        //[topheader.playerView.player setLooping:YES];
       // [topheader.playerView.player play];
    }
    CGRect freame = topheader.frame;
    freame.size.width = tableView.bounds.size.width;
    freame.size.height = [self indipendentFrame];

    [topheader setFrame:freame];
    UIView *view = [[UIView alloc] initWithFrame:[topheader frame]];
    [view addSubview:topheader];
    
    return view;

    //return topheader;
}
*/
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HostariaDescriptionCell *cell = [self.myTable dequeueReusableCellWithIdentifier:@"descriptionCell" forIndexPath:indexPath];
  
    cell.delegate = self;
    /*NSString *title = @"";
    NSString *description=@"";
    NSMutableAttributedString *titleAttrString = nil;
    NSMutableAttributedString *descriptionAttrString = nil;*/
    
    
    NSString*colored=@"\"DATE E ORARI MANIFESTAZIONE\"\n\nVenerdì 14 ottobre: 18:00-24:00\nSabato 15 ottobre: 11:00-22:00\nDomenica 16 ottobre: 11:00-20:00\n\nChiusura casse 2 ore prima del termine della manifestazione";

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Tutte le formule di biglietto prevedono la possibilità di acquistare il biglietto giornaliero degli autobus cittadini del’Azienda Trasporti Verona, aggiungendo solo 1 € (nel caso del biglietto di coppia 2€)\n\n\"DATE E ORARI MANIFESTAZIONE\"\n\nVenerdì 14 ottobre: 18:00-24:00\nSabato 15 ottobre: 11:00-22:00\nDomenica 16 ottobre: 11:00-20:00\n\nChiusura casse 2 ore prima del termine della manifestazione"];
    [string setColorForText:colored withColor:[self getUIColorObjectFromHexString:@"BFA372" alpha:1]];
    switch (indexPath.row) {
        case 0:
           // @"IL PROGETTO HOSTARIA": @"\"Hostaria""\" nasce per esprimere il concetto popolare di ospitalità legata alla degustazione dei vini. Evoca luoghi di incontro, convivialità, divertimento e libertà comunicativa.",
           
           // titleAttrString = [[NSMutableAttributedString alloc] initWithString:title];
            /*[titleAttrString beginEditing];
            [titleAttrString applyFontTraits:NSBoldFontMask
                                  range:NSMakeRange(22, 4)];
            [titleAttrString endEditing];*/
            cell.titleLabel.text = @"IL PROGETTO HOSTARIA";
            
            
            
            
            cell.descriptionLabel.text = @"“Hostaria” è il Festival nato per esprimere il concetto popolare di ospitalità legata alla degustazione dei vini. Evoca luoghi di incontro, convivialità, divertimento e libertà comunicativa. Attraverso un percorso lungo 3 chilometri all’interno del centro storico di Verona il pubblico partecipante diventa il protagonista attivo della festa degustando i vini proposti dalle cantine presenti e fermandosi nelle grandi “hostarie” delle eccellenze gastronomiche veronesi e le “sbecolerie” dislocate nell’itinerario della festa.\nAd Hostaria aderiscono decine di ristoranti e osterie del centro storico che prepareranno speciali menù tipici ispirati all’idea del Festival.\nHostaria ospita conferenze pubbliche ed è animato da suggestioni e intrattenimenti artistici.\nCon Hostaria, la cultura del vino torna popolare.";
            
            
            
           /* cell.descriptionLabel.attributedText = [self normalString:@"“Hostaria“ nasce per esprimere il concetto popolare di ospitalità legata alla degustazione dei vini. Evoca luoghi di incontro, convivialità, divertimento e libertà comunicativa.\n\nLa manifestazione nasce come FESTA POPOLARE attorno alle produzioni vinicole veronesi nello speciale periodo della vendemmia.\n\nAttraverso un percorso all’interno del centro storico della città il pubblico partecipante diventa il protagonista attivo della festa decidendo di “fare il percorso” degustando i vini proposti dalle cantine presenti e fermandosi nelle grandi “hostarie” di promozione delle eccellenze  gastronomiche veronesi, dislocate nell’itinerario della festa, e assaggiando i Speciali menù proposti dai ristoranti e locali aderenti al progetto.\n\nIl progetto intende coinvolgere tutti i territori di produzione presenti nella provincia di Verona. Uniti possono fare la differenza nel panorama turistico/enologico italiano ed internazionale.\n\nHostaria, la cultura del vino torna popolare." boldString:@"concetto popolare di ospitalità legata alla degustazione dei vini"];*/
            break;
        case 1:
            // @"IL PROGETTO HOSTARIA": @"\"Hostaria""\" nasce per esprimere il concetto popolare di ospitalità legata alla degustazione dei vini. Evoca luoghi di incontro, convivialità, divertimento e libertà comunicativa.",
            
            cell.titleLabel.text = @"NOVITA’ 2016:  CON 1 € SI VIAGGIA TUTTO IL GIORNO CON GLI AUTOBUS ATV!";
            cell.descriptionLabel.attributedText = string;
            break;
        case 2:
            // @"IL PROGETTO HOSTARIA": @"\"Hostaria""\" nasce per esprimere il concetto popolare di ospitalità legata alla degustazione dei vini. Evoca luoghi di incontro, convivialità, divertimento e libertà comunicativa.",
            
            cell.titleLabel.text = @"COMPRA ORA: RISPARMI E SALTI LA FILA!";
            cell.descriptionLabel.text = @"Comprando ora il tuo biglietto elettronico per Hostaria: lo paghi 15 € invece che 20 €!\n\nNon devi fare la fila e ti assicuri il tagliando scontato per la seconda edizione del Festival della vendemmia e del vino di Verona.\n\nINGRESSO 1 GIORNO\n\nIngresso giornaliero: 15€\n\nIl biglietto dà diritto a massimo 10 degustazioni di vino (alcuni vini pregiati definiti “gold” varranno 2 degustazioni), valide solo nel giorno selezionato presso gli stand delle cantine in centro storico.Ad ogni partecipante verrà consegnato presso i 6 punti di distribuzione un porta bicchiere e un bicchiere celebrativo, con i quali potrà liberamente scegliere le proprie degustazioni fra tutte le cantine presenti. Il biglietto elettronico è utilizzabile attraverso l’APP. Hostaria ed è inviato anche via mail per la stampa.\n\nABBONAMENTO 3 GIORNI\n\nPrezzo abbonamento 3 giorni: 30€\nIl biglietto dà diritto a massimo 10 degustazioni di vino al giorno (alcuni vini pregiati definiti “gold” varranno 2 degustazioni), presso gli stand delle cantine in centro storico.\n\nAd ogni partecipante verrà consegnato presso i 6 punti di distribuzione un porta bicchiere e un bicchiere celebrativo, con i quali potrà liberamente scegliere le proprie degustazioni fra tutte le cantine presenti. Il biglietto elettronico è utilizzabile attraverso l’APP Hostaria ed è inviato anche via mail per la stampa.\n\nBIGLIETTO di coppia\n\nIngresso di coppia: 20€\n\nIl biglietto dà diritto a massimo 10 degustazioni di vino (alcuni vini pregiati definiti “gold” varranno 2 degustazioni), valide solo nel giorno selezionato presso gli stand delle cantine in centro storico.\n\nAd ogni coppia partecipante verranno consegnati presso i 6 punti di distribuzione due porta bicchiere e due bicchieri celebrativi, con i quali la coppia potrà liberamente scegliere le proprie degustazioni fra tutte le cantine presenti. Durante la giornata la coppia potrà visitare gratuitamente la Torre dei Lamberti dove le verrà offerta una bevanda calda e dei dolci. Il biglietto elettronico è utilizzabile attraverso l’APP Hostaria ed è inviato anche via mail per la stampa.";
            break;
        case 3:
            // @"IL PROGETTO HOSTARIA": @"\"Hostaria""\" nasce per esprimere il concetto popolare di ospitalità legata alla degustazione dei vini. Evoca luoghi di incontro, convivialità, divertimento e libertà comunicativa.",
            
            cell.titleLabel.text = @"LA BABY HOSTARIA";
            cell.descriptionLabel.text = @"In Piazza delle Erbe sarà allestita un’area bambini in cui i nostri partner Rigoni di Asiago e Morato Pane offriranno gratuitamente una merenda “naturale” a tutti i bambini e l’Associazione Rido Ridò animerà con i giochi del Ludobus la piazza che diventerà un punto di divertimento e relax per i più piccoli.";
            break;
       
        default:
            break;
    }
 

    
    
    return  cell;
}

/*-(NSMutableAttributedString*)normalString:(NSString*)yourString boldString:(NSString*)boldString {
  //  NSLog(@"normal: %@ \n bold: %@",yourString,boldString);

    NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:yourString];
   
    NSRange boldRange = [yourString rangeOfString:boldString];
    [yourAttributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"PierSansBold" size:15] range:NSMakeRange(11, 44)];
    return yourAttributedString;
}
*/
/*-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selectedIndex = [tableView indexPathForSelectedRow];
    if (selectedIndex == indexPath) {
        
        HostariaDescriptionCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        [tableView beginUpdates];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //[cell changeCellStatus:YES];
        [tableView endUpdates];
        
        return selectedIndex;
        
    }else{
        
    }

    return indexPath;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  /*
    
    if(lastSelectedIndexPath) {
        
        HostariaDescriptionCell *cell =[tableView cellForRowAtIndexPath:lastSelectedIndexPath];
        [tableView beginUpdates];
        [cell changeCellStatus:NO];
        [tableView endUpdates];
        [self.myTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
    HostariaDescriptionCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [tableView beginUpdates];
    [cell changeCellStatus:YES];
    [tableView endUpdates];
    [self.myTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    lastSelectedIndexPath = indexPath;
 */


  
}
-(BOOL)isCellAlreadyExpanded:(HostariaDescriptionCell*)cell{
    return [[NSUserDefaults standardUserDefaults]boolForKey:cell.titleLabel.text];
}
-(void)setCellExpanded:(HostariaDescriptionCell*)cell atindex:(NSIndexPath*)index{
    NSLog(@"tite: %@",cell.titleLabel.text);
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:cell.titleLabel.text];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 //   HostariaDescriptionCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    //    [tableView beginUpdates];
   // [cell changeCellStatus:NO];
     //   [tableView endUpdates];
    
}
-(void)changedStatus:(BOOL)value atIndexPath:(HostariaDescriptionCell *)cell{
  
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

#pragma mark - Private

/*- (NSArray *)descrTitles {
    if (!_descrTitles) {
        _descrTitles = [self.titleDescriptions allKeys];
    }
    return _descrTitles;
}

- (NSDictionary *)titleDescriptions {
    if (!_titleDescriptions) {
        _titleDescriptions = @{
                              @"IL PROGETTO HOSTARIA": @"\"Hostaria""\" nasce per esprimere il concetto popolare di ospitalità legata alla degustazione dei vini. Evoca luoghi di incontro, convivialità, divertimento e libertà comunicativa.",
                              @"A Tale of Two Cities": @"It was the best of times, when Mr. Dickens loved rhymes.",
                              @"A Tree Grows in Brooklyn": @"Also, a young author grows up in Brooklyn.",
                              @"Moby Dick" : @"This book is a whale of a good time!",
                              @"Great Gatsby" : @"The book that inspired thousands of obliviously themed parties!",
                              };
    }
    return _titleDescriptions;
}*/
@end
