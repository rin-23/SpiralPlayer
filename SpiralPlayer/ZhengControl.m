//
//  ZhengControl.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZhengControl.h"
#import <QuartzCore/QuartzCore.h>
#import "SegmentView.h"
#include <stdlib.h>

@interface ZhengControl()
-(void) drawWheel;
@end

@implementation ZhengControl 

@synthesize numOfSectionsVisible, container, startTransform, numOfSectionsTotal, segmentViewsArray = segmentViewsArray_, segmentObjectsArray = segmentObjectsArray_;

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.numOfSectionsVisible = 8;
        self.numOfSectionsTotal = 24;
        leading_ = 0;
        self.segmentViewsArray = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsVisible];
        self.segmentObjectsArray = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsTotal];
        [self drawWheel];     
    }
    return self;
    
}

- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe received.");
}

- (void) drawWheel {
    self.container = [[UIView alloc] initWithFrame:self.frame];
    
    angleSizeRad = 2*M_PI/self.numOfSectionsVisible; 
    angleSizeDeg = (int)((angleSizeRad *(180.0/M_PI)) + 0.5) ;
    
    int s = 5;
    
    for (int i = -s; i < self.numOfSectionsVisible - s; i++) {
        int l = i + s;
        
        UIImage* image = [UIImage imageNamed:@"segment.png"];
        SegmentView* im = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
       
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                        container.bounds.size.height/2.0-container.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(-angleSizeRad*i);
        im.tag = l;

        im.signImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", l]];
       
        [container addSubview:im];
        [im release];
        
        [segmentViewsArray_ addObject:im];
        
    }
    
    
    container.userInteractionEnabled = YES;
    [self addSubview:container];
    [container release];
        
    int i = self.numOfSectionsVisible-1;
    UIImage* image = [UIImage imageNamed:@"segment_black.png"];
    SegmentView* im = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    im.imageView.image = image;
    
    im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
    im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                    container.bounds.size.height/2.0-container.frame.origin.y); 
    im.transform = CGAffineTransformMakeRotation(angleSizeRad*(i-1));
    im.tag = i;
        
    [self addSubview:im];
    [im release];            
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return NO;
    // 1 - Get touch position
    CGPoint touchPoint = [touch locationInView:self];
    // 2 - Calculate distance from center
    float x = touchPoint.x - container.center.x;
    float y = touchPoint.y - container.center.y;
    double cur_level_angle = atan((double)abs(y)/abs(x));
    
    if  (x >= 0 && y >= 0) {
        cur_level_angle = cur_level_angle; //I quarter - do nothing.
        currentQuarter_ = 1;
    } else if (x <= 0 && y > 0) {
        cur_level_angle = M_PI - cur_level_angle; //II
        currentQuarter_ = 2;
    } else if (x < 0 && y <= 0) { 
        cur_level_angle = M_PI + cur_level_angle; //III
        currentQuarter_ = 3;
    } else if (x >= 0 && y < 0) { 
        cur_level_angle = 2*M_PI - cur_level_angle; //IV
        currentQuarter_ = 4;
    } else {
        NSLog(@"WTF: %f %f",x,y);
    }
    
    beginTouchAngleRad_ = cur_level_angle;
    beginTouchAngleDeg_ = (int)(beginTouchAngleRad_*(180.0/M_PI) + 0.5);
    startTransform = container.transform;
    
    currentLevel_ = 0;
    indexOffset_ = 0;
    NSLog(@"Began: Deg:%i Quarter:%i",beginTouchAngleDeg_, currentQuarter_);
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    return NO;
    CGPoint pt = [touch locationInView:self];
    float x = pt.x  - container.center.x;
    float y = pt.y  - container.center.y;
    double cur_level_angle = atan((double)abs(y)/abs(x));
    
    if  (x >= 0 && y >= 0) {
        cur_level_angle = cur_level_angle; //I quarter - do nothing.
        if (currentQuarter_ == 4) currentLevel_ += 1;
        currentQuarter_ = 1;
    } else if (x <= 0 && y > 0) {
        cur_level_angle = M_PI - cur_level_angle; //II
        currentQuarter_ = 2;
    } else if (x < 0 && y <= 0) { 
        cur_level_angle = M_PI + cur_level_angle; //III
        currentQuarter_ = 3;
    } else if (x >= 0 && y < 0) { 
        cur_level_angle = 2*M_PI - cur_level_angle; //IV
        if (currentQuarter_ == 1) currentLevel_ -= 1;
        currentQuarter_ = 4;
    } else {
        NSLog(@"WTF: %f %f",x,y);
    }   

    double total_angle_rad = cur_level_angle + 2*currentLevel_*M_PI - beginTouchAngleRad_;  
    int total_angle_deg = (int)(total_angle_rad *(180.0/M_PI) +0.5);
    
    int newIndex = floor(total_angle_deg/angleSizeDeg);
    int indexDelta = newIndex - indexOffset_;
   // NSLog(@"New Index:%i Old Index:%i", newIndex, indexOffset_);
    
    if (indexDelta > 0) {
        NSLog(@"Index Delta is POZITIVE");
        for (int j = 0; j < indexDelta; j++) {
            NSLog(@"Leading: %i", leading_);
            SegmentView* segment = [segmentViewsArray_ objectAtIndex:(leading_ % self.numOfSectionsVisible)];
            NSLog(@"Segment Tag:%i", segment.tag);
            segment.signImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", arc4random_uniform(self.numOfSectionsVisible)]];
            leading_ += 1;
        }
        NSLog(@"************************************************");
        indexOffset_ = newIndex;        
    } else if (indexDelta < 0) {
     //   NSLog(@"Index Delta is NEGATIVE");
        
    } else {
       // NSLog(@"Index Delta is ZERO");
    }
    
        
    
   // NSLog(@"Total: %i, Index: %i", total_angle_deg, indexOffset_);
    //NSLog(@"************************************************");
    
    
    
    
    
       
//    //float ang = atan2(dy,dx);
//    float angleDifference = beginTouchAngleRad_ - cur_level_angle;
//    int deg = (int)((angleDifference *(180.0/M_PI)) +0.5);
//    
//    if (abs(deg%angleSizeDeg) == 0) {
//       // NSLog(@"SEGMENT TURNED");
//        lastAngleDeg = deg;
//    }
    
    //NSLog(@"%i - %f -  %f - %i", currentQuarter_, cur_level_angle * (180.0/M_PI), angleDifference, deg);
    
     
    
    
    //if ((abs(abs(deg) - abs(lastAngleDeg))) / angleSizeDeg  > 1) {
        //NSLog(@"TURN TOO BIG");
    //}
    
    //NSLog(@"%i %i %i", deg, angleSizeDeg, abs(deg%angleSizeDeg));
    
    
    
    container.transform = CGAffineTransformRotate(startTransform, total_angle_rad);
    

    return YES;
}



@end
