//
//  PolyLineAudioUnitView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolyLineControl.h"
#import "WaveAudioPlayer.h"
@interface PolyLineAudioUnitView : UIView {
    PolyLineControl* control_;
    WaveAudioPlayer* audioPlayer_;
    UIButton* moveButton_;
    UIButton* playButton_;
    
}

- (id)initWithFrame:(CGRect)frame andAudio:(NSString*) audioFile;
@property (nonatomic, retain) PolyLineControl* control;
@property (nonatomic, retain) WaveAudioPlayer* audioPlayer;

- (void)correctLayerPosition;

@end
