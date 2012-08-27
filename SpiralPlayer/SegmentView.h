//
//  SegmentView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentObject.h"
#import "GridHashTable.h"
#import "Constants.h"
@interface SegmentView : UIControl <UIGestureRecognizerDelegate>{
    UIImage* image_;
    SegmentObject* object_;    
    CGImageRef maskImage;
    
      
    UIButton* thumb_; //seek thumb button
    GridHashTable* gridHashTable_; //hash table of all of the data points
    CGPoint thumbCurrentPosition_; //current x, y coordinates of the thumb
    NSMutableArray* dataPoints_; //contains all of the data points that will be drawn
    NSMutableArray* drawingPoints_;
    
    double tracklength_;
    double value_;
    int numOfDataPoints_;
    double milisecondsPerPoint_;
    double secondsPerPoint_;
    
    CGPoint currentMovingPoint_;
    int currentMovingPointIndex_;
    
    int lastPointIndex_;  
    
    int type;

}

@property (nonatomic, readonly) int index;
@property (nonatomic, assign) CGColorRef bgColor;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) SegmentObject* object;


@property (nonatomic, retain) NSMutableArray* dataPoints;
@property (nonatomic, retain) NSMutableArray* drawingPoints;
@property (nonatomic, retain) UIButton* thumb;
@property (nonatomic, assign) CGPoint thumbCurrentPosition;
@property (nonatomic, retain) GridHashTable* gridHashTable; 
@property (nonatomic, assign) double tracklength;
@property (nonatomic, assign) double value;

- (NSComparisonResult) compareIndexes:(SegmentView*)otherEvenet;
-(id) initAlbumTypeWithFrame:(CGRect)frame;
@end
