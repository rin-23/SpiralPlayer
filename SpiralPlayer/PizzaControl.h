//
//  PizzaControl.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PizzaControl : UIControl {    
    double maxArclength_;
    double radiusStep_;
    double angleDeg_;
    double angleRad_;
    
    UIButton* thumb_; //seek thumb button
    NSMutableArray* dataPoints_;
}


@property (nonatomic, assign) double maxArcLength;
@property (nonatomic, assign) double radiusStep;
@property (nonatomic, assign) double angleDeg;
@property (nonatomic, assign) double angleRad;

@end
