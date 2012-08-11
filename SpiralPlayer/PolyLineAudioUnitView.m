//
//  PolyLineAudioUnitView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PolyLineAudioUnitView.h"

@implementation PolyLineAudioUnitView

@synthesize control = control_, audioPlayer = audioPlayer_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];

        
        self.audioPlayer = [[WaveAudioPlayer alloc] init];
        NSURL* audioUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Jimmy Hendrix  – Voodoo Child" ofType:@"mp3"]];
        [self.audioPlayer loadNextAudioAsset:audioUrl];
        [self.audioPlayer.player setNumberOfLoops:10];
        
        CGSize polyLineSize = CGSizeMake(200, 768/2);
        self.control = [[PolyLineControl alloc] initSineWaveWithFrame:CGRectMake(0, 0, polyLineSize.width, polyLineSize.height)]; 
        self.control.tracklength = [self.audioPlayer.player duration];
        [self.control addTarget:self action:@selector(curveValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.control];
        
    }
    return self;
}

- (void) updateProgressBar {
    self.control.value = audioPlayer_.player.currentTime;    
}

- (void) curveValueChanged { 
    self.audioPlayer.player.currentTime = self.control.value;
}


@end
