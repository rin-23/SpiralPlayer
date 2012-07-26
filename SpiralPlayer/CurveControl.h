//
//  LineView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurveControl : UIControl {
    UIButton* thumb_; //seek thumb button
    CGPoint thumbCurrentPosition_; //current x, y coordinates of the thumb
    NSMutableArray* dataPoints_; //contains all of the data points that will be drawn
    float pathLength_; //length of the path created by data points
    NSDictionary* gridHashTable_; //hash table of all of the data points
    double tracklength_;
    double value_;
    int numOfDataPoints_;
    double milisecondsPerPoint_;
    double secondsPerPoint_;
    
} 

@property (nonatomic, retain) NSMutableArray* dataPoints;
@property (nonatomic, assign) float pathLength;
@property (nonatomic, retain) UIButton* thumb;
@property (nonatomic, assign) CGPoint thumbCurrentPosition;
@property (nonatomic, retain) NSDictionary* gridHashTable; 
@property (nonatomic, assign) double tracklength;
@property (nonatomic, assign) double value;

@end
