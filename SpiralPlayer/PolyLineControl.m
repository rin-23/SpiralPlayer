#import "PolyLineControl.h"
#import "DataPointsManager.h"
#import <QuartzCore/QuartzCore.h>
#define START_POINT_X 100
#define START_POINT_Y 400

@interface PolyLineControl(PrivateMethods)
- (NSMutableArray*) getDataPoints;
@end

@implementation PolyLineControl

@synthesize dataPoints = dataPoints_, thumb = thumb_, thumbCurrentPosition = thumbCurrentPosition_, gridHashTable = gridHashTable_, tracklength = tracklength_, value = value_, drawingPoints = drawingPoints_/*, playButton = playButton_, moveButton = moveButton_*/;


-(id) initSineWaveWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame dataPointsFile:@"sineWaveDataPoints" ofType:@"txt"];
}

- (id) initWithFrame:(CGRect)frame dataPointsFile:(NSString*)fileName ofType:(NSString*)type {
    self = [super initWithFrame:frame];
    if (self) {
   

        self.backgroundColor = [UIColor clearColor];
        
        // Initialize hast table for all of the points
        self.gridHashTable = [[GridHashTable alloc] init];
         
        // Thumb control
        thumb_ = [UIButton buttonWithType:UIButtonTypeCustom];
        thumb_.frame=CGRectMake(0, 0, 50, 52);
        [thumb_ addTarget:self action:@selector(dragThumbBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
        [thumb_ addTarget:self action:@selector(dragThumbContinue:withEvent:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
        [thumb_ addTarget:self action:@selector(dragThumbEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        thumb_.opaque = YES;
        [thumb_ setImage:[UIImage imageNamed:@"handle"] forState:UIControlStateNormal];
        [self addSubview:thumb_];
        
        cgimage = [UIImage imageNamed:@"lana"].CGImage;
      
        
        //Get Data Points
        NSMutableDictionary* pointsDictionary = [[DataPointsManager sharedInstance] getPointsForFile:fileName ofType:type];
        self.dataPoints = [pointsDictionary objectForKey:@"dataPoints"];
        self.drawingPoints =[pointsDictionary objectForKey:@"drawingPoints"];
    }
    return self;
}



- (void) drawRect:(CGRect)rect {
        //NSLog(@"Started Drawing");

        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.gridHashTable clear];
           
        CGContextSaveGState(context);
        CGContextSetRGBFillColor (context, 1, 0, 0, 1);
        CGContextFillRect(context, rect);
     
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);    

        CGContextBeginPath(context);
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
          
        maskImage = CGBitmapContextCreateImage(context);
        
        CGContextRestoreGState(context);

    
    
//    CGContextTranslateCTM(context, 0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextClipToMask(context, rect, maskImage); 
//    CGContextDrawImage(context, rect, cgimage);
   // NSLog(@"Finished Drawing");
    
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

#pragma mark - PUBLIC GETTERS AND SETTERS

- (void)correctLayerPosition {
	CGPoint position = self.layer.position;
	CGPoint anchorPoint = self.layer.anchorPoint;
	CGRect bounds = self.bounds;
	// 0.5, 0.5 is the default anchorPoint; calculate the difference
	// and multiply by the bounds of the view
	position.x = (0.5 * bounds.size.width) + (anchorPoint.x - 0.5) * bounds.size.width;
	position.y = (0.5 * bounds.size.height) + (anchorPoint.y - 0.5) * bounds.size.height;
	self.layer.position = position;
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

                                                              
#pragma mark - UIControl touch evnets
- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    NSLog(@"begin touch track");
//    CGPoint touchPoint = [touch locationInView:self];
//    NSValue* closestTrackValue = [self getClosestGridPointToPoint:touchPoint];
//    if (closestTrackValue == nil) {
//        NSLog(@"Touched outside of the track area");
//    } else {
//        CGPoint closestTrackPoint = [[self getClosestGridPointToPoint:touchPoint] CGPointValue];
//        currentMovingPointIndex_ = [self.dataPoints indexOfObject:closestTrackValue];
//        currentMovingPoint_ = closestTrackPoint;
//        
//    }
    return YES;    
}
- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    NSLog(@"continue touch track");
//    CGPoint touchPoint = [touch locationInView:self];
//    NSValue* touchPointValue = [NSValue valueWithCGPoint:touchPoint];
//    [self.dataPoints replaceObjectAtIndex:currentMovingPointIndex_ withObject:touchPointValue];
//    [self setNeedsDisplay];
          
    return YES; 
    
}
- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint touchPoint = [touch locationInView:self];
//    NSValue* touchPointValue = [NSValue valueWithCGPoint:touchPoint];
//    [self.dataPoints replaceObjectAtIndex:currentMovingPointIndex_ withObject:touchPointValue];
//    [self setNeedsDisplay];
    
    
    NSLog(@"end touch track");
    CGPoint touchPoint = [touch locationInView:self];
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

#pragma mark - Touch events
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {[super touchesBegan:touches withEvent:event];}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {[super touchesMoved:touches withEvent:event];}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {[super touchesEnded:touches withEvent:event];}

@end
