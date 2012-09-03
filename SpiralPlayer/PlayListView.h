//
//  PlayListView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentView.h"
#import "SegmentObject.h"
#import "ContainerView.h"
#import "CoverSegment.h"

@interface PlayListView : UIControl {
    int numOfItemsChosen;
    int dimension;
    UIScrollView* scrollView;
    
    
    NSMutableArray* slidingWindow_;
    NSMutableArray* segmentObjectsArray_;
  
    //Draw Wheel Vars
    double anglePerSector_;
    
    //Touches Var
    double beginTouchAngleRad_;
    int currentLevel_;
    int currentQuarter_;
    
    double current_rad; 
    double total_rad;   
    
    //Window indexes and sizes    
    double windowAngleSpanRad_;
    int windowStartIndex_;
    int windowEndIndex_;
    int windowSize_;  
    
    BOOL continueTouch_;
    
    ContainerView* container_;
    CoverSegment* hidingSegment_;
}

@property (nonatomic, assign) int numOfSectionsVisible;
@property (nonatomic, assign) int numOfSectionsTotal;

@property (nonatomic, assign) CGAffineTransform startTransform;
@property (nonatomic, retain) NSMutableArray* slidingWindow;
@property (nonatomic, retain) NSMutableArray* segmentObjectsArray;

-(void)addSong:(SegmentView*)seg;

@end
