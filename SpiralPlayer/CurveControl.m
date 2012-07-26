#import "CurveControl.h"

#define START_POINT_X 100
#define START_POINT_Y 400

#define X_NUM_OF_CELLS 32
#define Y_NUM_OF_CELLS 32

@interface CurveControl(PrivateMethods)
- (NSMutableArray*) getDataPoints;
- (NSValue*) getClosestGridPointToPoint:(CGPoint) touchpoint;
- (void) hashPointToGrid:(CGPoint)point;
@end

@implementation CurveControl

@synthesize dataPoints = dataPoints_, pathLength = pathLength_, thumb = thumb_, thumbCurrentPosition = thumbCurrentPosition_, gridHashTable = gridHashTable_, tracklength = tracklength_, value = value_;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
                                                                     
        // Initialization code
        self.pathLength = 0; 
        
        // Initialize hast table for all of the points
        self.gridHashTable = [[NSMutableDictionary alloc] init];
        
        // Thumb control
        thumb_ = [UIButton buttonWithType:UIButtonTypeCustom];
        thumb_.frame=CGRectMake(0, 0, 50, 52);
        [thumb_ addTarget:self action:@selector(dragThumbBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
        [thumb_ addTarget:self action:@selector(dragThumbContinue:withEvent:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
        [thumb_ addTarget:self action:@selector(dragThumbEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [thumb_ setImage:[UIImage imageNamed:@"handle"] forState:UIControlStateNormal];
        [self addSubview:thumb_];
    }
    
    return self;
}

- (void) getDataPoints {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"hendrix" ofType:@"ma"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray* lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    numOfDataPoints_ = [(NSString*)[lines objectAtIndex:0] intValue];
    NSLog(@"Capacity: %i", numOfDataPoints_);
    
    self.dataPoints = [[NSMutableArray alloc] initWithCapacity:numOfDataPoints_];    
    for (int i = 1; i < numOfDataPoints_; i += 1) {
        NSArray* coordinates = [(NSString*)[lines objectAtIndex:i] componentsSeparatedByString:@" "];
        float x_f = [[coordinates objectAtIndex:0] floatValue];
        float y_f = [[coordinates objectAtIndex:1] floatValue];
        int x = (int)(x_f+0.5);
        int y = (int)(y_f+0.5) + 130;
        //NSLog(@"Read a point X:%i, Y:%i", x, y);
        CGPoint point = CGPointMake(x, y);
        [self.dataPoints addObject:[NSValue valueWithCGPoint:point]];
    }
     
//    // every second of track is a pixel
//    for (int x = START_POINT_X; x < START_POINT_X + tracklength_/2; x++) {
//        CGPoint point = CGPointMake(x, START_POINT_Y);
//        [marray addObject:[NSValue valueWithCGPoint:point]];
//    }
//    
//    for (int y = START_POINT_Y; y < START_POINT_Y + tracklength_/2; y++) {
//        CGPoint point = CGPointMake(START_POINT_X + tracklength_/2, y);
//        [marray addObject:[NSValue valueWithCGPoint:point]];
//    }
//       
    //return [marray autorelease];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect {
    // Drawing code
    //self.dataPoints = [[self getDataPoints] retain];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2);
    CGColorRef leftcolor = [[UIColor whiteColor] CGColor];
    CGContextSetStrokeColorWithColor(context, leftcolor);

    CGPoint startPoint = [(NSValue*)[self.dataPoints objectAtIndex:0] CGPointValue];
    self.thumb.center = startPoint;
    [self hashPointToGrid:startPoint];
    
    CGPoint pastPoint = startPoint;
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    for (int i = 1; i < [self.dataPoints count]; i++) {
        //draw line
        CGPoint currentPoint = [(NSValue*)[self.dataPoints objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);  
        [self hashPointToGrid:currentPoint];
        
        //calculate total length of the line as we draw it
        float curLength = sqrtf(pow(currentPoint.x-pastPoint.x, 2) + pow(currentPoint.y - pastPoint.y, 2));
        self.pathLength += curLength; 
        pastPoint = currentPoint;
    }
    NSLog(@"Path Length: %f", self.pathLength);
    CGContextStrokePath(context);
}

#pragma mark - HASH TABLE METHODS

- (void) hashPointToGrid:(CGPoint)point {
    int bucket_x = floor(point.x / X_NUM_OF_CELLS);
    int bucket_y = floor(point.y / Y_NUM_OF_CELLS);

    NSString* key = [NSString stringWithFormat:@"%i-%i", bucket_x, bucket_y];
    NSValue* value = [NSValue valueWithCGPoint:point];
    
    NSMutableArray* values_array = [self.gridHashTable objectForKey:key];
    if (values_array == nil) { //key doesnt exists so create
        values_array = [[NSMutableArray alloc] initWithObjects:value, nil];
        [self.gridHashTable setValue:values_array forKey:key];
        [values_array release];
    } else { 
        [values_array addObject:value];
        [self.gridHashTable setValue:values_array forKey:key];       
    }
}
- (NSValue*) getClosestGridPointToPoint:(CGPoint)touchPoint {
    int bucket_x = floor(touchPoint.x / X_NUM_OF_CELLS);
    int bucket_y = floor(touchPoint.y / Y_NUM_OF_CELLS);
    NSString* key = [NSString stringWithFormat:@"%i-%i", bucket_x, bucket_y];
    NSMutableArray* values_array = [self.gridHashTable objectForKey:key];

    if (values_array == nil) { 
        return nil; // no point found
    } else { 
        float min_distance;
        float cur_distance;
        CGPoint currentPoint;
        CGPoint minPoint;
        //find the closest point to the touchPoint
        for (int i = 0 ; i < [values_array count]; i++) {
            currentPoint = [(NSValue*)[values_array objectAtIndex:i] CGPointValue];
            cur_distance = sqrtf(pow(currentPoint.x-touchPoint.x, 2) + pow(currentPoint.y - touchPoint.y, 2));
            if (i == 0) { 
                min_distance = cur_distance; 
                minPoint = currentPoint;
            } else {
                if (min_distance > cur_distance) {
                    min_distance = cur_distance;
                    minPoint = currentPoint; 
                }
            }
        }
        return [NSValue valueWithCGPoint:minPoint];        
    }
}


#pragma mark - THUMB NEEDLE TOUCH EVENT HANDLERS

/* Handle event of first touch of the thumb needle */
- (void) dragThumbBegan:(UIControl*)control withEvent:(UIEvent*)event {
    NSLog(@"DRAG STARTED");    
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self];
    NSValue* closestTrackValue = [self getClosestGridPointToPoint:touchPoint];
    if (closestTrackValue == nil) {
        NSLog(@"Touched outside of the track area");
    } else {
        CGPoint closestTrackPoint = [[self getClosestGridPointToPoint:touchPoint] CGPointValue];
        self.thumbCurrentPosition = closestTrackPoint;        
        NSLog(@"Closes track point is X:%0.1f Y:%0.1f", closestTrackPoint.x, closestTrackPoint.y);
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

/* Handle events of dragging the thumb needle */
- (void) dragThumbContinue:(UIControl*)control withEvent:(UIEvent*)event {
    NSLog(@"DRAG CONTINUED");
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self];
    NSValue* closestTrackValue = [self getClosestGridPointToPoint:touchPoint];
    if (closestTrackValue == nil) {
        NSLog(@"Touched outside of the track area");
    } else {
        CGPoint closestTrackPoint = [[self getClosestGridPointToPoint:touchPoint] CGPointValue];
        self.thumbCurrentPosition = closestTrackPoint;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        NSLog(@"Closes track point is X:%0.1f Y:%0.1f", closestTrackPoint.x, closestTrackPoint.y);
    }
}

/* Handle event of final touch of the thumb needle */
- (void) dragThumbEnded:(UIControl*)control withEvent:(UIEvent*)event {
    NSLog(@"DRAG ENDED");
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self];
    NSValue* closestTrackValue = [self getClosestGridPointToPoint:touchPoint];
    if (closestTrackValue == nil) {
        NSLog(@"Touched outside of the track area");
    } else {
        CGPoint closestTrackPoint = [[self getClosestGridPointToPoint:touchPoint] CGPointValue];
        self.thumbCurrentPosition = closestTrackPoint;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        NSLog(@"Closes track point is X:%0.1f Y:%0.1f", closestTrackPoint.x, closestTrackPoint.y);
    }
}

#pragma mark - PUBLIC GETTERS AND SETTERS

- (double) value {
    int point = [dataPoints_ indexOfObject:[NSValue valueWithCGPoint:self.thumbCurrentPosition]];
    return point * secondsPerPoint_;
}

- (void) setValue:(double)value {
    int currentPoint = (int)(value/secondsPerPoint_);
    NSLog(@"Value:  %f, Point Index: %i", value, currentPoint);
    if (currentPoint < [self.dataPoints count]) {
        self.thumbCurrentPosition = [(NSValue*)[dataPoints_ objectAtIndex:currentPoint] CGPointValue];
    }
}

- (void) setThumbCurrentPosition:(CGPoint)thumbCurrentPosition {
    thumbCurrentPosition_ = thumbCurrentPosition;
    self.thumb.center = thumbCurrentPosition;    
}

- (void) setTracklength:(double)tracklength {
    [self getDataPoints];
    secondsPerPoint_ = tracklength/numOfDataPoints_;
    milisecondsPerPoint_ = (tracklength * 1000)/numOfDataPoints_;
}

                                                              
#pragma mark - UIControl touch evnets
- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"begin touch track");
    return YES;    
}
- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"continue touch track");
    return YES;    
}
- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"end touch track");
    CGPoint touchPoint = [touch locationInView:self];
    NSValue* closestTrackValue = [self getClosestGridPointToPoint:touchPoint];
    if (closestTrackValue == nil) {
        NSLog(@"Touched outside of the track area");
    } else {
        CGPoint closestTrackPoint = [[self getClosestGridPointToPoint:touchPoint] CGPointValue];
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
