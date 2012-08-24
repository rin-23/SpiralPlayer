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
#include "SegmentObject.h"
#define ARC4RANDOM_MAX      0x100000000


@interface ZhengControl()
-(void) drawWheel;
-(CGColorRef) randomColor;
@end

@implementation ZhengControl 

@synthesize numOfSectionsVisible, container, startTransform, numOfSectionsTotal, segmentViewsArray = segmentViewsArray_, segmentObjectsArray = segmentObjectsArray_;

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[NSTimer scheduledTimerWithTimeInterval:0.000001 target:self selector:@selector(check) userInfo:nil repeats:YES];
        
        self.numOfSectionsVisible = 8;
        self.numOfSectionsTotal = 24;
        leading_ = 0;
        
        self.segmentViewsArray = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsVisible];
        self.segmentObjectsArray = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsTotal];
        [self drawWheel];     
    }
    return self;    
}

- (void) check {
    NSLog(@"check");
}

- (void) drawWheel {
    self.container = [[UIView alloc] initWithFrame:self.frame];
    
    angleSizeRad = 2*M_PI/self.numOfSectionsVisible; 
    angleSizeDeg = (int)((angleSizeRad*(180.0/M_PI))+0.5) ;
    
    int segmentheight = self.frame.size.height/2;
    int segmentwidth = 2*(segmentheight * tan(angleSizeRad/2));   
    NSLog(@"Segment W:%i H:%i", segmentwidth, segmentheight);
    //int s = 5;
    
    for (int i = 0; i < self.numOfSectionsVisible; i++) {
        SegmentObject* segObject = [[SegmentObject alloc] init];
        segObject.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]] retain];
        segObject.index = i;
        [segmentObjectsArray_ addObject:segObject];
        [segObject release];
        
        SegmentView* im = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        //im.bgColor = [self randomColor];
        im.object = segObject;
        im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                        container.bounds.size.height/2.0-container.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(-angleSizeRad*(i + 1));
        im.tag = i;

        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(segmentwidth/2, segmentheight/2, 40, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%i", i];
        label.font = [UIFont boldSystemFontOfSize:25.0f];
        [im addSubview:label];
        [label release];
              
        [container addSubview:im];
        [im release];        
        
        [segmentViewsArray_ addObject:im];
    }    
        
    for (int i = self.numOfSectionsVisible; i < self.numOfSectionsTotal; i++) {
        SegmentObject* segObject = [[SegmentObject alloc] init];
        segObject.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]]retain];
        segObject.index = i;
        [segmentObjectsArray_ addObject:segObject];
        [segObject release];
    }        
         
    [self addSubview:container];
    [container release];
        
    SegmentView* im = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
    im.bgColor = [UIColor whiteColor].CGColor;
     
    im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
    im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                    container.bounds.size.height/2.0-container.frame.origin.y); 
    //im.transform = CGAffineTransformMakeRotation(angleSizeRad*(i-1));
    //im.tag = i;
        
    [self addSubview:im];
    [im release];            
}

- (CGColorRef) randomColor {
    double r = ((double)arc4random() / ARC4RANDOM_MAX);
    double g = ((double)arc4random() / ARC4RANDOM_MAX);
    double b = ((double)arc4random() / ARC4RANDOM_MAX);
    return CGColorRetain([UIColor colorWithRed:r green:g blue:b alpha:1].CGColor);
}

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
 
    CGPoint touchPoint = [touch locationInView:self];
    
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

- (BOOL) continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    
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
        NSLog(@"Quarter Not Determined: %f %f", x, y);
    }   

    total_angle_rad = cur_level_angle + 2*currentLevel_*M_PI - beginTouchAngleRad_;  
    total_angle_deg = (int)(total_angle_rad *(180.0/M_PI) +0.5);
    
    int newIndex = floor(total_angle_rad/angleSizeRad);
    int indexDelta = newIndex - indexOffset_;
    NSLog(@"New Index:%i Old Index:%i", newIndex, indexOffset_);
    NSLog(@"Degrees %i", total_angle_deg);    
    if (indexDelta > 0) { 
        NSLog(@"Index Delta is POZITIVE");
//        for (int j = 0; j < indexDelta; j++) {
//            NSLog(@"Leading %i: %i", j, leading_);
//            SegmentView* segment = [segmentViewsArray_ objectAtIndex:(leading_ % self.numOfSectionsVisible)];
//            segment.object = [segmentObjectsArray_ objectAtIndex:leading_ + self.numOfSectionsVisible];
//            NSLog(@"Segment Tag:%i Segment Object Index: %i", segment.tag, segment.object.index);
//            [segment setNeedsDisplay];
//            leading_ += 1;
//        }
        indexOffset_ = newIndex;        
    } else if (indexDelta < 0) {
        NSLog(@"Index Delta is NEGATIVE");
//        for (int j = 0; j < abs(indexDelta); j++) {
//            NSLog(@"Leading %i: %i", j, leading_);
//            SegmentView* segment = [segmentViewsArray_ objectAtIndex:(leading_ % self.numOfSectionsVisible)];
//            segment.object = [segmentObjectsArray_ objectAtIndex:leading_ + self.numOfSectionsVisible];
//            NSLog(@"Segment Tag:%i Segment Object Index: %i", segment.tag, segment.object.index);
//            [segment setNeedsDisplay];
//            leading_ -= 1;
//        }
       indexOffset_ = newIndex;  
    } else {
        //NSLog(@"Index Delta is ZERO");
    }
        
    NSLog(@"Total: %i, Index: %i", total_angle_deg, indexOffset_);
    NSLog(@"************************************************");
    
    //container.transform = CGAffineTransformRotate(startTransform, total_angle_rad);
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"End Tracking");
    if (leading_ + self.numOfSectionsVisible > 23) {
        return;
    }
    int k = (total_angle_deg/angleSizeDeg) + 1;
    total_angle_deg = k*angleSizeDeg - total_angle_deg;
    total_angle_rad = total_angle_deg * (M_PI/180.0);
    container.transform = CGAffineTransformRotate(container.transform, total_angle_rad);    
    SegmentView* segment = [segmentViewsArray_ objectAtIndex:(leading_ % self.numOfSectionsVisible)];
    segment.object = [segmentObjectsArray_ objectAtIndex:leading_ + self.numOfSectionsVisible];
    NSLog(@"Segment Tag:%i Segment Object Index: %i", segment.tag, segment.object.index);
    [segment setNeedsDisplay];
    leading_ += 1;
    indexOffset_ += 1;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    //NSLog(@"Touch Began For Container");
    UITouch *touch = [[event allTouches] anyObject];
    [self beginTrackingWithTouch:touch withEvent:event];    
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    //NSLog(@"Touch Continue For Container");
    UITouch *touch = [[event allTouches] anyObject];
    [self continueTrackingWithTouch:touch withEvent:event];   
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    [self endTrackingWithTouch:touch withEvent:event];  

}


@end
