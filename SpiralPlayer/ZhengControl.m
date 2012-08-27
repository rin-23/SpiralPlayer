//
//  ZhengControl.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZhengControl.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>
#import "Constants.h"
#import  "SegmentObject.h"
#import "SegmentAudioUnit.h"
#define ARC4RANDOM_MAX      0x100000000

@interface ZhengControl()
- (void) drawWheel;
- (CGColorRef) randomColor;
- (int) toDeg:(double)rad;
- (double) toRad:(int)deg;
-(void)loadAlbums;
-(void)loadSongs;
-(void)drawSongsWheel;
@end

@implementation ZhengControl 

@synthesize numOfSectionsVisible, startTransform, numOfSectionsTotal, slidingWindow = slidingWindow_, segmentObjectsArray = segmentObjectsArray_, audioFilesArray = audioFilesArray_;

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        container_ = [[ContainerView alloc] initWithFrame:self.frame];
        [self loadAlbums];
    }
    return self;    
}

- (void) loadAlbums {
    self.numOfSectionsVisible = 8;
    self.numOfSectionsTotal = 24;
    self.slidingWindow = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsVisible];
    self.segmentObjectsArray = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsTotal];
    
    current_rad = 0.0f;
    total_rad = 0.0f;
    
    
    currentLevel_ = 0;
    currentQuarter_ = 0;
        
    windowSize_ = self.numOfSectionsVisible;
    windowStartIndex_ = 0;
    windowEndIndex_ = windowStartIndex_ + windowSize_ - 1;    
    [self drawWheel];  
}

-(void) loadSongs{
    self.numOfSectionsVisible = 8;
    self.numOfSectionsTotal = 12;
    
    current_rad = 0.0f;
    total_rad = 0.0f;
    
    currentLevel_ = 0;
    currentQuarter_ = 0;
           
    windowSize_ = self.numOfSectionsVisible;
    windowStartIndex_ = 0;
    windowEndIndex_ = windowStartIndex_ + windowSize_ - 1;    
    [self drawSongsWheel];  
}

- (void) drawSongsWheel {    
    for (SegmentAudioUnit* unit in self.slidingWindow) {
        [unit.segmentView removeFromSuperview];
    }
    
    self.slidingWindow = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsVisible];
    self.segmentObjectsArray = [[NSMutableArray alloc] initWithCapacity:self.numOfSectionsTotal];
    
    container_.transform = CGAffineTransformIdentity;
    windowAngleSpanRad_ = anglePerSector_ * (self.numOfSectionsTotal - self.numOfSectionsVisible);
    
    int segmentheight = self.frame.size.height/2;
    int segmentwidth = 2*(segmentheight * tan(anglePerSector_/2));   
    NSLog(@"Segment W:%i H:%i", segmentwidth, segmentheight);
    
    for (int i = 0; i < self.numOfSectionsVisible; i++) {
        SegmentObject* segObject = [[SegmentObject alloc] initWithAudio:[NSString stringWithFormat:@"%i", i]];
        segObject.type = kSegmentTypeSong;
        segObject.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]] retain];
        segObject.index = i;
        [segmentObjectsArray_ addObject:segObject];
        [segObject release];
        
        SegmentAudioUnit* audioUnit = [[SegmentAudioUnit alloc] init];
        audioUnit.type = kSegmentTypeSong;
        [audioUnit createAudioPlayer:[NSString stringWithFormat:@"%i", i]];
        [audioUnit createSegmentViewWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        
        //SegmentView* im = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        
        SegmentView* im = audioUnit.segmentView;
        im.userInteractionEnabled = YES;
        im.object = segObject;
        im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        im.layer.position = CGPointMake(container_.bounds.size.width/2.0-container_.frame.origin.x, 
                                        container_.bounds.size.height/2.0-container_.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(-anglePerSector_*(i + 1));
        
        [container_ addSubview:im]; 
        [im release];        
        
        [slidingWindow_ addObject:audioUnit];
    }    
    
    for (int i = self.numOfSectionsVisible; i < self.numOfSectionsTotal; i++) {
        SegmentObject* segObject = [[SegmentObject alloc] init];
        segObject.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]]retain];
        segObject.index = i;
        [segmentObjectsArray_ addObject:segObject];
        [segObject release];
    }        
   
}

- (void) drawWheel {
    if (container_ !=nil) {
        [container_ removeFromSuperview];
        [hidingSegment_ removeFromSuperview];
    }
  
    container_.userInteractionEnabled = YES;
    anglePerSector_ = 2*M_PI/self.numOfSectionsVisible;
    windowAngleSpanRad_ = anglePerSector_ * (self.numOfSectionsTotal - self.numOfSectionsVisible);
        
    int segmentheight = self.frame.size.height/2;
    int segmentwidth = 2*(segmentheight * tan(anglePerSector_/2));   
    NSLog(@"Segment W:%i H:%i", segmentwidth, segmentheight);
   
    for (int i = 0; i < self.numOfSectionsVisible; i++) {
        SegmentObject* segObject = [[SegmentObject alloc] init];
        segObject.type = kSegmentTypeAbum;
        segObject.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]] retain];
        segObject.index = i;
        [segmentObjectsArray_ addObject:segObject];
        [segObject release];
        
//        SegmentAudioUnit* audioUnit = [[SegmentAudioUnit alloc] init];
//        [audioUnit createAudioPlayer:[NSString stringWithFormat:@"%i", i]];
//        [audioUnit createSegmentViewWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];

        SegmentAudioUnit* audioUnit = [[SegmentAudioUnit alloc] init];
        [audioUnit createAlbumSegmentViewWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        audioUnit.type = kSegmentTypeAbum;
        
        //SegmentView* im = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        
        SegmentView* im = audioUnit.segmentView;

        
        im.userInteractionEnabled = YES;
        //im.bgColor = [self randomColor];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(segmentPressed:)];
        tap.numberOfTapsRequired = 2;
        [im addGestureRecognizer:tap];
        [tap release];
        
        im.object = segObject;
        im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        im.layer.position = CGPointMake(container_.bounds.size.width/2.0-container_.frame.origin.x, 
                                        container_.bounds.size.height/2.0-container_.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(-anglePerSector_*(i + 1));
  
      
        [container_ addSubview:im]; 
        [im release];        
        
        [slidingWindow_ addObject:audioUnit];
    }    
        
    for (int i = self.numOfSectionsVisible; i < self.numOfSectionsTotal; i++) {
        SegmentObject* segObject = [[SegmentObject alloc] init];
        segObject.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]]retain];
        segObject.index = i;
        [segmentObjectsArray_ addObject:segObject];
        [segObject release];
    }                 
    [self addSubview:container_];
    [container_ release];
        
    hidingSegment_ = [[CoverSegment alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
    hidingSegment_.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
    hidingSegment_.layer.position = CGPointMake(container_.bounds.size.width/2.0-container_.frame.origin.x, 
                                    container_.bounds.size.height/2.0-container_.frame.origin.y); 
    [self addSubview:hidingSegment_];
    [hidingSegment_ release];            
}

-(void) segmentPressed:(UIGestureRecognizer*)gesture {
    NSLog(@"Segement Pressed");
    UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
    //SegmentView* segView = (SegmentView*)tapGesture.view;
    [self loadSongs];
    //    for (SegmentView* view in slidingWindow_) {
//        if ([view isEqual:segView]) {
//            NSLog(@"Segment Index %i", view.index);
//            [self loadSongs];
//        }
//    }
}

- (double) toRad:(int) deg { return deg*(M_PI/180.0); }
- (int) toDeg:(double) rad { return (int)(rad*(180.0/M_PI) + 0.5); }

- (CGColorRef) randomColor {
    double r = ((double)arc4random() / ARC4RANDOM_MAX);
    double g = ((double)arc4random() / ARC4RANDOM_MAX);
    double b = ((double)arc4random() / ARC4RANDOM_MAX);
    return CGColorRetain([UIColor colorWithRed:r green:g blue:b alpha:1].CGColor);
}

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
          
    float x = touchPoint.x - container_.center.x;
    float y = touchPoint.y - container_.center.y;
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
    startTransform = container_.transform;
    
    currentLevel_ = 0;
    NSLog(@"BEGAIN TRACKING: Total Deg:%i BeginDeg:%i Quarter:%i Level:%i", [self toDeg:total_rad], [self toDeg:beginTouchAngleRad_], currentQuarter_, currentLevel_);
    return YES;
}

- (BOOL) continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    CGPoint pt = [touch locationInView:self];
    float x = pt.x  - container_.center.x;
    float y = pt.y  - container_.center.y;
    double cur_level_angle = atan((double)abs(y)/abs(x));
    
    int oldQuarter = currentQuarter_;
    int oldLevel = currentLevel_;
    double oldcurrentrad = current_rad;
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

    double current = cur_level_angle + 2*currentLevel_*M_PI - beginTouchAngleRad_;   
    current_rad = total_rad + current;
    
    //check if we havent violated size constraints
    if (current_rad < 0 || current_rad > windowAngleSpanRad_) {
        NSLog(@"        TRIED TO MOVE OUT OF BOUNDS");
        NSLog(@"        TotalDeg:%i", [self toDeg:current_rad]);
        current_rad = oldcurrentrad;
        currentLevel_ = oldLevel;
        currentQuarter_ = oldQuarter;
        return NO; 
    } 
    
    int newStartIndex = floor(current_rad/anglePerSector_);
    SegmentAudioUnit* audioUnit = (SegmentAudioUnit*)[slidingWindow_ objectAtIndex:0];
      
    int curStartIndex = audioUnit.segmentView.index;
    int indexDelta = newStartIndex - curStartIndex;
    
    NSLog(@"        TotalDeg:%i NewIndex:%i CurIndex:%i", [self toDeg:current_rad], newStartIndex, curStartIndex);
    
    if (indexDelta > 0) {
        NSLog(@"        MOVED CLOCKWISE");
        for (int i = 0; i < indexDelta; i++) {
            SegmentAudioUnit* audioUnit = [slidingWindow_ objectAtIndex:0];
            SegmentView* seg = audioUnit.segmentView;
            int newSegIndex = seg.index + windowSize_;
            seg.object = [segmentObjectsArray_ objectAtIndex:newSegIndex];
            
            if (audioUnit.type == kSegmentTypeSong) {
                [audioUnit createAudioPlayer:[NSString stringWithFormat:@"%i", newSegIndex]];
                [audioUnit sync];
            }
                [seg setNeedsDisplay];
            //[slidingWindow_ replaceObjectAtIndex:0 withObject:audioUnit];
            [slidingWindow_ sortUsingSelector:@selector(compareIndexes:)];
        }
    } else if (indexDelta < 0) {
        NSLog(@"        MOVED COUNTER CLOKWISE");
        for (int i = 0; i < abs(indexDelta); i++) {
            int lastindex = [slidingWindow_ count] - 1;
            SegmentAudioUnit* audioUnit = [slidingWindow_ objectAtIndex:lastindex];
            SegmentView* seg = audioUnit.segmentView;
            int newSegIndex = seg.index - windowSize_;
            seg.object = [segmentObjectsArray_ objectAtIndex:newSegIndex];
            if (audioUnit.type == kSegmentTypeSong) {
                [audioUnit createAudioPlayer:[NSString stringWithFormat:@"%i", newSegIndex]];
                [audioUnit sync];
            }
            [seg setNeedsDisplay];
            //[slidingWindow_ replaceObjectAtIndex:lastindex withObject:seg];
            [slidingWindow_ sortUsingSelector:@selector(compareIndexes:)];
        }

    } else {
        NSLog(@"        INDEX HASN'T CHANGED");
    }
    
    NSLog(@"        ************************************************");
//    
    container_.transform = CGAffineTransformRotate(startTransform, current);
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
      NSLog(@"END TRACKING");
      total_rad = current_rad;
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    NSLog(@"Touch Began For Control");
    continueTouch_ = YES;
    [self beginTrackingWithTouch:touch withEvent:event];
    //[super touchesBegan:touches withEvent:event];   
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    NSLog(@"Touch Continue For Control");
    UITouch *touch = [[event allTouches] anyObject];
    if (continueTouch_) {
        continueTouch_ = [self continueTrackingWithTouch:touch withEvent:event];
    }

    //[super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Ended For Control");
    UITouch *touch = [[event allTouches] anyObject];
    total_rad = current_rad;
    continueTouch_ = YES;
    [self endTrackingWithTouch:touch withEvent:event];
    
    
    
    //[super touchesEnded:touches withEvent:event];
}


@end
