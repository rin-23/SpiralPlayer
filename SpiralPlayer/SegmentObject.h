//
//  SegmentObject.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaveAudioPlayer.h"
@interface SegmentObject : NSObject {    
    UIImage* image_;      
    int index_;
    int type_;
    NSString* audioName_;
}

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) NSString* audioName;

- (id) initWithAudio:(NSString*)audioName ;

@end
