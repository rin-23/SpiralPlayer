//
//  ZhengControl.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhengControl : UIControl {
    
    NSMutableArray* segmentArray_;
    //Draw Wheel Vars
    double angleSizeRad;
    int angleSizeDeg;

    int lastAngleDeg;
    
    //Touches Var
    double beginTouchAngleRad_;
    int beginTouchAngleDeg_;
    int currentLevel_;
    int currentQuarter_;
    int indexOffset;

    
}

@property (nonatomic, assign) int numOfSectionsVisible;
@property (nonatomic, assign) int numOfSectionsTotal;
@property (nonatomic, retain) UIView* container;
@property (nonatomic, assign) CGAffineTransform startTransform;
@property (nonatomic, retain) NSMutableArray* segmentArray;
@end
