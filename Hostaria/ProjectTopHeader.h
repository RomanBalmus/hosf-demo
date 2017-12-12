//
//  ProjectTopHeader.h
//  Hostaria
//
//  Created by iOS on 10/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "HostariaDescriptionCell.h"

@interface ProjectTopHeader : UITableViewCell{
    CGFloat systemVolume;
}
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;

@property (weak, nonatomic) IBOutlet VIMVideoPlayerView *playerView;
@end
