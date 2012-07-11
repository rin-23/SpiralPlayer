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
 
@interface WaveAudioPlayer : NSObject {
    AVAudioPlayer* audioPlayer_;
    MPMediaItem* mediaItem_;
    
}


@property (nonatomic, retain) MPMediaItem* mediaItem;
@property (nonatomic, retain) AVAudioPlayer* player;

@end
