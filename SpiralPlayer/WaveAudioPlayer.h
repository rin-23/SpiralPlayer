//
//  WaveAudioPlayer.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
 
@protocol WaveAudioPlayerDelegate <NSObject>
- (void) finishedConvertingToPCM;
@end


@interface WaveAudioPlayer : NSObject {
    id<WaveAudioPlayerDelegate> delegate_;
    AVAudioPlayer* audioPlayer_;
    MPMediaItem* mediaItem_;
}

@property (nonatomic, retain) id <WaveAudioPlayerDelegate> delegate;
@property (nonatomic, retain) MPMediaItem* mediaItem;
@property (nonatomic, retain) AVAudioPlayer* player;

- (void) loadNextMediaItem:(MPMediaItem*) mediaItem;

@end
