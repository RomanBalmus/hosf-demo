//
//  ProjectTopHeader.m
//  Hostaria
//
//  Created by iOS on 10/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ProjectTopHeader.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation ProjectTopHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    NSLog(@"header awake");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playSpot) name:@"playSpot" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopSpot) name:@"stopSpot" object:nil];

    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"wasMuted"]) {
        [self.playerView.player setVolume:0];
        [volumeViewSlider setValue:0.0f animated:YES];
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"wasMuted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.muteBtn setSelected:YES];

    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeChanged:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];

}

- (void)volumeChanged:(NSNotification *)notification
{
    float volume =
    [[[notification userInfo]
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     floatValue];
    
    // Do stuff with volume
    if (volume > 0) {
        [self.muteBtn setSelected:NO];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"wasMuted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else if (volume == 0.0){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"wasMuted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.muteBtn setSelected:YES];
 
    }
}
-(void)playSpot{
    [self.playerView.player play];
    
}
-(void)stopSpot{
    [self.playerView.player pause];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"call init on top header");
    }
    return self;
}



/*- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    float desiredWidth = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    CGRect frame = attributes.frame;
    frame.size.width = desiredWidth;
    attributes.frame = frame;
    return attributes;
}*/
-(IBAction)muteButtonClick :(id)sender{
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    UIButton *button = (UIButton *)sender;
    button.selected = ![button isSelected]; // Important line
    if (button.selected)
    {
        NSLog(@"Selected");
        NSLog(@"%li",(long)button.tag);
       [self.playerView.player setVolume:0];
        [volumeViewSlider setValue:0.0f animated:YES];
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"wasMuted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else
    {
        NSLog(@"Un Selected");
        NSLog(@"%li",(long)button.tag);
        [self.playerView.player setVolume:0.3f];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"wasMuted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [volumeViewSlider setValue:0.3f animated:YES];
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }
    //[self.playerView.player fadeInVolume];
}
@end
