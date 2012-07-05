//
//  DrawView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "math.h"
@interface SpiralControl : UIControl {
    UIButton* thumb_;
    double centerX_;
    double centerY_;
    double radiusStep_;
    
    int currentLevel_;
    double degreeAtCurrentLevel_;
    double radianAtCurrentLevel_;
    int currentQuarter_;    
    
    //Current values
    double value_;
    double currentAngleDeg_;
    double currentAngleRad_;
    double waveFormHeight_;
    
    //Maximum values
    double maximumValue_;
    double maxAngleDeg_;
    double maxAngleRad_;
    double maxArcLength_;
    
    BOOL dataReady_;
   
    // Song data
    NSMutableData* samples_;
    SInt16  normalizeMax_;
    NSInteger sampleCount_; 
    NSInteger channelCount_;
    NSInteger averageSample_;
    
   
   
    
}

@property (nonatomic, assign) double value;
@property (nonatomic, assign) double maximumValue;
@property (nonatomic, retain) NSMutableData* samples;
@property (nonatomic, assign) double waveFormHeight;
@property (nonatomic, assign) double radiusStep;

- (void) drawSpiralForAsset:(AVURLAsset*) songAsset;

@end
