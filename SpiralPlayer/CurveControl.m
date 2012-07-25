#import "CurveControl.h"

#define START_POINT_X 100
#define START_POINT_Y 400

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

- (NSMutableArray*) getDataPoints {
    
    
    NSMutableArray* marray = [[NSMutableArray alloc] initWithCapacity:300];    
    // draw staright line

    // every second of track is a pixel
    for (int x = START_POINT_X; x < START_POINT_X + tracklength_; x++) {
        CGPoint point = CGPointMake(x, START_POINT_Y);
        [marray addObject:[NSValue valueWithCGPoint:point]];
    }
    return [marray autorelease];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect {
    // Drawing code
    self.dataPoints = [[self getDataPoints] retain];
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
    int bucket_x = floor(point.x / 64);
    int bucket_y = floor(point.y / 64);

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
    int bucket_x = floor(touchPoint.x / 64);
    int bucket_y = floor(touchPoint.y / 64);
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
    return [dataPoints_ indexOfObject:[NSValue valueWithCGPoint:self.thumbCurrentPosition]];
}

- (void) setValue:(double)value {
    self.thumbCurrentPosition = [(NSValue*)[dataPoints_ objectAtIndex:value] CGPointValue];
}

- (void) setThumbCurrentPosition:(CGPoint)thumbCurrentPosition {
    thumbCurrentPosition_ = thumbCurrentPosition;
    self.thumb.center = thumbCurrentPosition;    
    
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
