//
//  SeekControl.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
 
#import "LyricsControl.h"
#import "TextSegment.h"
#import "Utilities.h"
#import  <QuartzCore/QuartzCore.h>
#import "LyricsManager.h"

@interface LyricsControl() 
-(void)drawSegments;
@end

@implementation LyricsControl

@synthesize startTransform;
@synthesize slidingWindow = _slidingWindow; 
//@synthesize segmentObjectsArray = _segmentObjectsArray;
@synthesize audioFilesArray = _audioFilesArray;
@synthesize container = _container;
@synthesize letters = _letters;
@synthesize karaokeData = _karaokeData;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* data = [[LyricsManager sharedInstance] getKaraokeFromFile:kLYRICS_FILE ofType:@"txt"];
        self.letters = [[data objectAtIndex:0] retain];
        self.karaokeData = [[data objectAtIndex:1] retain];
        
        numOfSectionsVisible_ = 80;
        numOfSectionsTotal_ = [self.letters count];
        
        if (numOfSectionsTotal_ < numOfSectionsVisible_) {
            NSLog(@"ERROR: More Visible Sections than Total");
            numOfSectionsVisible_ = numOfSectionsTotal_;
        }
        
        anglePerSector_ = 2*M_PI/numOfSectionsVisible_;
        current_rad = 0.0f;
        total_rad = 0.0f;
        currentLevel_ = 0;
        currentQuarter_ = 0;
               
        windowSize_ = numOfSectionsVisible_;
        windowStartIndex_ = 0;
        windowEndIndex_ = windowStartIndex_ + windowSize_ - 1;  
        windowAngleSpanRad_ = anglePerSector_ * (numOfSectionsTotal_ - numOfSectionsVisible_);
        
        self.slidingWindow = [[NSMutableArray alloc] initWithCapacity:numOfSectionsVisible_];
        //self.segmentObjectsArray = [[NSMutableArray alloc] initWithCapacity:numOfSectionsTotal_];
        
        [self drawSegments];        
    }
    return self;
}

- (void) drawSegments {
    self.container = [[ContainerView alloc] initWithFrame:self.frame];
    [self addSubview:self.container];
    [self.container release];
    
    int segmentheight = self.frame.size.height/2;
    int segmentwidth = 2*(segmentheight * tan(anglePerSector_/2));  
    NSLog(@"Height:%i Width: %i", segmentwidth, segmentheight);
       
    for (int i = 0; i < numOfSectionsVisible_; i++) {
        //char* letter = [[Utilities sharedInstance] randomLetter];
        //[self.segmentObjectsArray addObject:[NSString stringWithUTF8String:letter]];
                
        TextSegment* im = [[TextSegment alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        im.userInteractionEnabled = YES;
        im.bgColor = CGColorRetain([UIColor clearColor].CGColor);
        im.index = i;
        strcpy(im.letter, [[self.letters objectAtIndex:i] UTF8String]);
        im.unitAngle = anglePerSector_;
        im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        im.layer.position = CGPointMake(self.bounds.size.width/2.0-self.frame.origin.x, 
                                        self.bounds.size.height/2.0-self.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(-anglePerSector_*(i + 1));
        [self.container addSubview:im]; 
        [im release];      
        
        [self.slidingWindow addObject:im];

    }    
    
//    for (int i = numOfSectionsVisible_; i<numOfSectionsTotal_; i++) {
//        char* letter = [[Utilities sharedInstance] randomLetter];
//        [self.segmentObjectsArray addObject:[NSString stringWithUTF8String:letter]];
//    }
    
    //for (int i = -4; i < 4; i++) {
              
        TextSegment* im = [[TextSegment alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        im.userInteractionEnabled = YES;
        im.bgColor = CGColorRetain([UIColor redColor].CGColor);
        im.letter = " ";
        im.unitAngle = anglePerSector_;
        im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        im.layer.position = CGPointMake(self.bounds.size.width/2.0-self.frame.origin.x, 
                                        self.bounds.size.height/2.0-self.frame.origin.y); 
        //im.transform = CGAffineTransformMakeRotation(-anglePerSector_*(i + 1));
        [self addSubview:im]; 
        [im release]; 
    //}
    //self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
}

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    //NSLog(@"Begin Track Seek Control");
    
    CGPoint touchPoint = [touch locationInView:self];
    float x = touchPoint.x - self.container.center.x;
    float y = touchPoint.y - self.container.center.y;
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
    startTransform = self.container.transform;
    
    currentLevel_ = 0;
    NSLog(@"BEGAIN TRACKING: Total Deg:%i BeginDeg:%i Quarter:%i Level:%i", [[Utilities sharedInstance] toDeg:total_rad], [[Utilities sharedInstance] toDeg:beginTouchAngleRad_], currentQuarter_, currentLevel_);
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    float x = pt.x  - self.container.center.x;
    float y = pt.y  - self.container.center.y;
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
        NSLog(@"        TotalDeg:%i", [[Utilities sharedInstance] toDeg:current_rad]);
        current_rad = oldcurrentrad;
        currentLevel_ = oldLevel;
        currentQuarter_ = oldQuarter;
        return NO; 
    } 
    
    int newStartIndex = floor(current_rad/anglePerSector_);
    TextSegment* textUnit = (TextSegment*)[self.slidingWindow objectAtIndex:0];
    
    int curStartIndex = textUnit.index;
    int indexDelta = newStartIndex - curStartIndex;
    
    NSLog(@"        TotalDeg:%i NewIndex:%i CurIndex:%i", [[Utilities sharedInstance] toDeg:current_rad], newStartIndex, curStartIndex);
    
    if (indexDelta > 0) {
        NSLog(@"        MOVED CLOCKWISE");
        for (int i = 0; i < indexDelta; i++) {
            TextSegment* textUnit = (TextSegment*)[self.slidingWindow objectAtIndex:0];
            int newSegIndex = textUnit.index + windowSize_;
            NSString* newLetter = [self.letters objectAtIndex:newSegIndex];
            strcpy(textUnit.letter, [newLetter UTF8String]);
            textUnit.index = newSegIndex;
            [textUnit setNeedsDisplay];
            [self.slidingWindow sortUsingSelector:@selector(compareIndexes:)];
        }  
    } else if (indexDelta < 0) {
        NSLog(@"        MOVED COUNTER CLOKWISE");
        for (int i = 0; i < abs(indexDelta); i++) {
            int lastindex = [self.slidingWindow count] - 1;
            TextSegment* textUnit = [self.slidingWindow objectAtIndex:lastindex];
            int newSegIndex = textUnit.index - windowSize_;
            NSString* newLetter = [self.letters objectAtIndex:newSegIndex];
            strcpy(textUnit.letter, [newLetter UTF8String]);
            textUnit.index = newSegIndex;
            [textUnit setNeedsDisplay];
            [self.slidingWindow sortUsingSelector:@selector(compareIndexes:)];
        }
    } else {
        NSLog(@"        INDEX HASN'T CHANGED");
    }
    NSLog(@"        ************************************************");
    self.container.transform = CGAffineTransformRotate(startTransform, current);
    return YES;
}

-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"End Track Seek Control");
    total_rad = current_rad;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    NSLog(@"Touch Began For LYRICS CONTROL");
    continueTouch_ = YES;
    [self beginTrackingWithTouch:touch withEvent:event];
    [self.superview touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    NSLog(@"Touch Continue For LYRICS CONTROL");
    UITouch *touch = [[event allTouches] anyObject];
    if (continueTouch_) {
        continueTouch_ = [self continueTrackingWithTouch:touch withEvent:event];
    }
    [self.superview touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Ended For LYRICS CONTROL");
    UITouch *touch = [[event allTouches] anyObject];
    total_rad = current_rad;
    continueTouch_ = YES;
    [self endTrackingWithTouch:touch withEvent:event];
    [self.superview touchesEnded:touches withEvent:event];
}
@end
