//
//  SegmentView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentView.h"
#import "DataPointsManager.h"
@implementation SegmentView 

@synthesize index, bgColor, image = image_, object = object_, dataPoints = dataPoints_, thumb = thumb_, thumbCurrentPosition = thumbCurrentPosition_, gridHashTable = gridHashTable_, tracklength = tracklength_, value = value_, drawingPoints = drawingPoints_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
  
        self.bgColor = [UIColor whiteColor].CGColor;  
        self.backgroundColor = [UIColor clearColor];
                
        dataPoints_ = [[NSMutableArray alloc] init];
        
        
        // Initialize hast table for all of the points
        self.gridHashTable = [[GridHashTable alloc] init];
        
        // Thumb control
        thumb_ = [UIButton buttonWithType:UIButtonTypeCustom];
        //thumb_.backgroundColor = [UIColor redColor];
        thumb_.frame=CGRectMake(0, 0, 50, 52);
        [thumb_ addTarget:self action:@selector(dragThumbBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
        [thumb_ addTarget:self action:@selector(dragThumbContinue:withEvent:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
        [thumb_ addTarget:self action:@selector(dragThumbEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        thumb_.opaque = YES;
        [thumb_ setImage:[UIImage imageNamed:@"handle"] forState:UIControlStateNormal];
        [self addSubview:thumb_];
        
        //Get Data Points
        NSMutableDictionary* pointsDictionary = [[DataPointsManager sharedInstance] getPointsForFile:@"segmentData" ofType:@"txt"];
        self.dataPoints = [pointsDictionary objectForKey:@"dataPoints"];
        self.drawingPoints =[pointsDictionary objectForKey:@"drawingPoints"];
                
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        [self addGestureRecognizer:recognizer];
        [recognizer release];
        

    }
    return self;
}


- (int) index {
    return self.object.index;
}

- (double) toRad:(int) deg { return deg*(M_PI/180.0); }
- (int) toDeg:(double) rad { return (int)(rad*(180.0/M_PI) + 0.5); }

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"Gesture 1");
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Gesture 2");
    return YES;
}

- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe received 2.");
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    if (maskImage == NULL) {
        CGContextSaveGState(context);
        //Fill Background
        CGContextSetRGBFillColor (context, 0, 0, 0, 0);
        CGContextFillRect(context, rect);
        
        //Start Drawing Segment
        CGContextBeginPath (context);               
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);  
        CGContextSetLineWidth(context, 1);
        
        CGPoint pT = CGPointMake(rect.size.width/2, 0);
        CGPoint pL = CGPointMake(0, rect.size.height);
        CGPoint pR = CGPointMake(rect.size.width, rect.size.height);
        CGPoint vectorL = CGPointMake(pL.x - pT.x, pL.y- pT.y);
        CGPoint vectorR = CGPointMake(pR.x - pT.x, pR.y - pT.y);
        CGPoint halfwayL = CGPointMake(pT.x + 0.5*vectorL.x, pT.y + 0.5*vectorL.y);
        CGPoint halfwayR = CGPointMake(pT.x + 0.5*vectorR.x, pT.y + 0.5*vectorR.y);
        
        CGContextMoveToPoint(context, halfwayR.x, halfwayR.y);
        CGContextAddLineToPoint(context, pR.x - 0.075*vectorR.x, pR.y - 0.075*vectorR.y);
        
        CGFloat radius = rect.size.height;
        CGFloat radius2 = sqrt(pow(halfwayR.x - pT.x, 2) + pow(halfwayR.y - pT.y, 2));
        
        double totalAngle = 45.0 * (M_PI/180.0);
        CGContextAddArc(context, pT.x, pT.y, radius-2, (M_PI - totalAngle)/2, (M_PI - totalAngle)/2 + totalAngle, 0);
        CGContextMoveToPoint(context, pL.x - 0.075*vectorL.x, pL.y - 0.075*vectorL.y);
        CGContextAddLineToPoint(context, halfwayL.x, halfwayL.y);
        CGContextAddArc(context, pT.x, pT.y, radius2, (M_PI - totalAngle)/2 + totalAngle, (M_PI - totalAngle)/2, 1);
        
        //CGContextAddLineToPoint(context, halfwayR.x, halfwayR.y);
        //CGContextSetRGBFillColor (context, 1, 1, 1, 1);
        //CGContextSetFillColorWithColor(context, self.bgColor);
        //CGContextFillPath(context);
        //CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        //DRAW SINE WAVE
        [self.gridHashTable clear];
        CGContextSaveGState(context);
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);    
        
        CGContextSetLineWidth(context, 2);
        CGPoint currentPoint = [(NSValue*)[self.drawingPoints objectAtIndex:0] CGPointValue];
        self.thumb.center = currentPoint;
        CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
        [self.gridHashTable hashPointToGrid:currentPoint];
        //  CGPoint pastPoint = startPoint;
        for (int i = 0; i < [self.drawingPoints count]; i += 1) {
            //draw line
            currentPoint = [(NSValue*)[self.drawingPoints objectAtIndex:i] CGPointValue];
            CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y); 
            [self.gridHashTable hashPointToGrid:currentPoint];
            
        }
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
        
      
        maskImage = CGBitmapContextCreateImage(context);
        //CGImageRetain(maskImage);    
    }
    
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);   
    CGContextClipToMask(context, rect, maskImage); 
    CGContextDrawImage(context, rect, self.object.image.CGImage);
    //CGImageRelease(maskImage);

}

#pragma mark - THUMB NEEDLE TOUCH EVENT HANDLERS

/* Handle event of first touch of the thumb needle */
- (void) dragThumbBegan:(UIControl*)control withEvent:(UIEvent*)event {
    NSLog(@"DRAG STARTED");    
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self];
    NSValue* closestTrackValue = [self.gridHashTable getClosestGridPointToPoint:touchPoint];
    if (closestTrackValue == nil) {
        NSLog(@"Touched outside of the track area");
    } else {
        CGPoint closestTrackPoint = [[self.gridHashTable getClosestGridPointToPoint:touchPoint] CGPointValue];
        self.thumbCurrentPosition = closestTrackPoint;        
        NSLog(@"Closes track point is X:%0.1f Y:%0.1f", closestTrackPoint.x, closestTrackPoint.y);
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

/* Handle events of dragging the thumb needle */
- (void) dragThumbContinue:(UIControl*)control withEvent:(UIEvent*)event {
    NSLog(@"DRAG CONTINUED");
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self];
    NSValue* closestTrackValue = [self.gridHashTable getClosestGridPointToPoint:touchPoint];
    if (closestTrackValue == nil) {
        NSLog(@"Touched outside of the track area");
    } else {
        CGPoint closestTrackPoint = [[self.gridHashTable getClosestGridPointToPoint:touchPoint] CGPointValue];
        self.thumbCurrentPosition = closestTrackPoint;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        NSLog(@"Closes track point is X:%0.1f Y:%0.1f", closestTrackPoint.x, closestTrackPoint.y);
    }
}

/* Handle event of final touch of the thumb needle */
- (void) dragThumbEnded:(UIControl*)control withEvent:(UIEvent*)event {
    NSLog(@"DRAG ENDED");
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self];
    NSValue* closestTrackValue = [self.gridHashTable getClosestGridPointToPoint:touchPoint];
    if (closestTrackValue == nil) {
        NSLog(@"Touched outside of the track area");
    } else {
        CGPoint closestTrackPoint = [[self.gridHashTable getClosestGridPointToPoint:touchPoint] CGPointValue];
        self.thumbCurrentPosition = closestTrackPoint;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        NSLog(@"Closes track point is X:%0.1f Y:%0.1f", closestTrackPoint.x, closestTrackPoint.y);
    }
}


- (double) value {
    int point = [dataPoints_ indexOfObject:[NSValue valueWithCGPoint:self.thumbCurrentPosition]];
    return point * secondsPerPoint_;
}

- (void) setValue:(double)value {
    int currentPoint = (int)(value/secondsPerPoint_);
    //NSLog(@"Value:  %f, Point Index: %i", value, currentPoint);
    if (currentPoint < [self.dataPoints count]) {
        self.thumbCurrentPosition = [(NSValue*)[dataPoints_ objectAtIndex:currentPoint] CGPointValue];
    }
}

- (void) setThumbCurrentPosition:(CGPoint)thumbCurrentPosition {
    thumbCurrentPosition_ = thumbCurrentPosition;
    self.thumb.center = thumbCurrentPosition;    
}

- (void) setTracklength:(double)tracklength {
    //[self getDataPoints];
    secondsPerPoint_ = tracklength/[self.dataPoints count];
    milisecondsPerPoint_ = (tracklength * 1000)/[self.dataPoints count];
}

- (NSComparisonResult) compareIndexes:(SegmentView*)otherEvenet {
    if (self.index < otherEvenet.index) {
        return NSOrderedAscending;
    } else if (self.index> otherEvenet.index) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}



- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Segment View touch began");
    [self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Segment View touch moved");
    [self.superview touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Segment View touch ended");
    [self.superview  touchesEnded:touches withEvent:event];
}



@end
