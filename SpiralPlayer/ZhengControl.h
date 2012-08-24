//
//  ZhengControl.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhengControl : UIControl {
    
    NSMutableArray* segmentViewsArray_;
    NSMutableArray* segmentObjectsArray_;

    //Draw Wheel Vars
    double angleSizeRad;
    int angleSizeDeg;

    //Touches Var
    double beginTouchAngleRad_;
    int beginTouchAngleDeg_;
    int currentLevel_;
    int currentQuarter_;
    double total_angle_rad;
    int total_angle_deg; 
    
    int indexOffset_;
    
    int leading_;
   
}

@property (nonatomic, assign) int numOfSectionsVisible;
@property (nonatomic, assign) int numOfSectionsTotal;
@property (nonatomic, retain) UIView* container;
@property (nonatomic, assign) CGAffineTransform startTransform;
@property (nonatomic, retain) NSMutableArray* segmentViewsArray;
@property (nonatomic, retain) NSMutableArray* segmentObjectsArray;
@end
