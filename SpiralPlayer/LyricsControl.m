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

@interface LyricsControl() 
-(void)drawSegments;
@end

@implementation LyricsControl

@synthesize startTransform;
@synthesize slidingWindow = _slidingWindow; 
@synthesize segmentObjectsArray = _segmentObjectsArray;
@synthesize audioFilesArray = _audioFilesArray;
@synthesize container = _container;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        numOfSectionsVisible_ = 170;
        numOfSectionsTotal_ = 1000;
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
        self.segmentObjectsArray = [[NSMutableArray alloc] initWithCapacity:numOfSectionsTotal_];
        
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
        TextSegment* im = [[TextSegment alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
        im.userInteractionEnabled = YES;
        im.bgColor = [[Utilities sharedInstance] randomColor];
        im.letter = [[Utilities sharedInstance] randomLetter];
        im.unitAngle = anglePerSector_;
        im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        im.layer.position = CGPointMake(self.bounds.size.width/2.0-self.frame.origin.x, 
                                        self.bounds.size.height/2.0-self.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(-anglePerSector_*(i + 1));
        [self.container addSubview:im]; 
        [im release];        
    }    
    
    TextSegment* im = [[TextSegment alloc] initWithFrame:CGRectMake(0, 0, segmentwidth, segmentheight)];
    im.userInteractionEnabled = YES;
    im.bgColor = CGColorRetain([UIColor darkGrayColor].CGColor);
    im.letter = " ";
    im.unitAngle = anglePerSector_;
    im.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
    im.layer.position = CGPointMake(self.bounds.size.width/2.0-self.frame.origin.x, 
                                    self.bounds.size.height/2.0-self.frame.origin.y); 
    [self addSubview:im]; 
    [im release]; 
    
        
}


//- (void) drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetRGBFillColor (context,0, 0, 0, 0);
//    CGContextFillRect(context, rect);
//   
//    int width = 50;
//    CGContextSetLineWidth(context, width);
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    CGContextAddEllipseInRect(context, CGRectMake(width/2, width/2, rect.size.width - width, rect.size.height-width));
//    CGContextStrokePath(context);    
//}


- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Begin Track Seek Control");
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Continue Track Seek Control");
    return YES;
}

-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"End Track Seek Control");
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event   {
    [self.superview touchesBegan:touches withEvent:event];
    NSLog(@"Touch Began For Seek Control");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Moved For Seek Control");
    [self.superview touchesMoved:touches withEvent:event];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touch Ended For Seek Control");
    [self.superview touchesEnded:touches withEvent:event];
}


@end
