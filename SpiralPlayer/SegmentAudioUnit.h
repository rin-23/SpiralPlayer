//
//  SegmentAudioUnit.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaveAudioPlayer.h"
#import "SegmentView.h"
@interface SegmentAudioUnit : NSObject {
        SegmentView* segmentView_;
        WaveAudioPlayer* audioPlayer_;
    }
    
@property (nonatomic, retain) SegmentView* segmentView;
@property (nonatomic, retain) WaveAudioPlayer* audioPlayer;

- (void) createAudioPlayer:(NSString*)audioName;
- (void) createSegmentViewWithFrame:(CGRect) rect;
- (NSComparisonResult) compareIndexes:(SegmentAudioUnit*)otherEvenet;
- (void) sync;
@end
