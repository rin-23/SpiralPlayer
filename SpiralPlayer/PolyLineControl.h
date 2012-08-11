//
//  LineView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridHashTable.h"
@interface PolyLineControl : UIControl {
    
    UIButton* thumb_; //seek thumb button
    CGPoint thumbCurrentPosition_; //current x, y coordinates of the thumb
    NSMutableArray* dataPoints_; //contains all of the data points that will be drawn
    NSMutableArray* drawingPoints_;
    float pathLength_; //length of the path created by data points
    GridHashTable* gridHashTable_; //hash table of all of the data points
    double tracklength_;
    double value_;
    int numOfDataPoints_;
    double milisecondsPerPoint_;
    double secondsPerPoint_;
    
    CGPoint currentMovingPoint_;
    int currentMovingPointIndex_;
    
    int lastPointIndex_;   
    
} 

@property (nonatomic, retain) NSMutableArray* dataPoints;
@property (nonatomic, retain) NSMutableArray* drawingPoints;
@property (nonatomic, assign) float pathLength;
@property (nonatomic, retain) UIButton* thumb;
@property (nonatomic, assign) CGPoint thumbCurrentPosition;
@property (nonatomic, retain) GridHashTable* gridHashTable; 
@property (nonatomic, assign) double tracklength;
@property (nonatomic, assign) double value;

- (id) initWithFrame:(CGRect)frame dataPointsFile:(NSString*)fileName ofType:(NSString*)type;
- (id) initSineWaveWithFrame:(CGRect)frame; 
- (void)correctLayerPosition;


@end
