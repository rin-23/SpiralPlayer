//
//  ZhengControl.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhengControl : UIControl {
    
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
    
    int indexOffset_;
    int leading_;
    
    //Window indexes and sizes    
    double windowAngleSpanRad_;
    int windowStartIndex_;
    int windowEndIndex_;
    int windowSize_;
    
    
   
}

@property (nonatomic, assign) int numOfSectionsVisible;
@property (nonatomic, assign) int numOfSectionsTotal;
@property (nonatomic, retain) UIView* container;
@property (nonatomic, assign) CGAffineTransform startTransform;
@property (nonatomic, retain) NSMutableArray* slidingWindow;
@property (nonatomic, retain) NSMutableArray* segmentObjectsArray;
@end
