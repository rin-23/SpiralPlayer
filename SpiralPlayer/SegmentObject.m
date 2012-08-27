//
//  SegmentObject.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentObject.h"

@implementation SegmentObject

@synthesize image = image_, index = index_, type = type_, audioName = audioName_;

-(id) init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(id) initWithAudio:(NSString*)audioName {
    self = [super init];
    if (self) {
        self.audioName = audioName;
    }
    return self;
}



@end
