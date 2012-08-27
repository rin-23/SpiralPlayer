//
//  SegmentAudioUnit.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-27.   
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentAudioUnit.h"


@implementation SegmentAudioUnit 
@synthesize segmentView = segmentView_, audioPlayer = audioPlayer_, type;

-(id)init {
    self = [super init];
    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayNotification:) name:@"PlayClicked" object:nil];
        
        self.audioPlayer = [[WaveAudioPlayer alloc] init];
    }
    return self;
}

- (void) receivePlayNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"PlayClicked"])
        if ([notification.object isEqual:self]) {
            NSLog(@"Sent to myself");
        } else  {
            NSLog(@"Need to pause audio");
            if (self.audioPlayer.player.playing) {
                [self.audioPlayer.player pause];
            }
        }
}
    
- (void) createAudioPlayer:(NSString*)audioName {
    
    NSLog(@"%@", audioName);
    NSURL* audioUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audioName ofType:@"mp3"]];
    [self.audioPlayer loadNextAudioAsset:audioUrl];
    [self.audioPlayer.player setNumberOfLoops:1];
    
}

- (void) createSegmentViewWithFrame:(CGRect) rect {
    self.segmentView = [[SegmentView alloc] initWithFrame:rect];
    self.segmentView.tracklength = self.audioPlayer.player.duration;
    [self.segmentView addTarget:self action:@selector(curveValueChanged) forControlEvents:UIControlEventValueChanged];

    UITapGestureRecognizer* thumbDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbTapped)];
    thumbDoubleTap.numberOfTapsRequired = 1;
    [self.segmentView.thumb addGestureRecognizer:thumbDoubleTap];
    [thumbDoubleTap release];
}

- (void) createAlbumSegmentViewWithFrame:(CGRect) rect {
    self.segmentView = [[SegmentView alloc] initAlbumTypeWithFrame:rect];
}


-(void) sync {
    self.segmentView.tracklength = self.audioPlayer.player.duration;
}
-(void) thumbTapped {     
    if (self.audioPlayer.player == nil) return;
    
    if (self.audioPlayer.player.playing) {
        [self.audioPlayer.player pause];
    } else {
        [self.audioPlayer.player play];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayClicked" object:self];

    }
}
- (NSComparisonResult) compareIndexes:(SegmentAudioUnit*)otherEvenet {
    return [self.segmentView compareIndexes:otherEvenet.segmentView];
}
- (void) updateProgressBar {
    self.segmentView.value = self.audioPlayer.player.currentTime;    
}

- (void) curveValueChanged { 
    self.audioPlayer.player.currentTime =  self.segmentView.value;
}
           
- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
                        
@end
