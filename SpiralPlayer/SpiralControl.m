#import "SpiralControl.h"
#import "math.h"

#define DEGREES_PER_UNIT_VALUE 1 // how many degress are per second of audio for example
#define ARCLENGTH_PER_UNIT_VALUE 3

@interface SpiralControl(PrivateMethods)
- (void) setCurrentAngleDegrees: (double) angleDeg;
- (void) setCurrentAngleRadians: (double) angleRad;
- (void) setCurrentArcLength:    (double) arclength;
- (void) updateNeedlePosition;
- (void) drawSpiral;
- (void) numOfTurns;
@end

@implementation SpiralControl     

@synthesize value = value_, maximumValue = maximumValue_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
               
        self.backgroundColor = [UIColor lightGrayColor];        
        
        //centerX_ = 380; // x-coordinate of the center of the spiral
        //centerY_ = 512; // y-coordinate of the center of the spiral 
        centerX_ = 360/2;
        centerY_ = 480/2;
        dSpace_ = 50.0; // space between succesive turns of the spiral
        currentAngleRad_ = 0;
        currentAngleDeg_ = 0;
        currentLevel_ = 0;
        //Player thumb needle
        thumb_ = [UIButton buttonWithType:UIButtonTypeCustom];
        thumb_.frame=CGRectMake(0, 0, 50, 52);
        thumb_.center = CGPointMake(centerX_, centerY_);         
        [thumb_ addTarget:self action:@selector(dragThumbBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
        [thumb_ addTarget:self action:@selector(dragThumbContinue:withEvent:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
        [thumb_ addTarget:self action:@selector(dragThumbEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [thumb_ setImage:[UIImage imageNamed:@"handle"] forState:UIControlStateNormal];
        [self addSubview:thumb_];
     
    }
    return self;
}

#pragma mark - THUMB NEEDLE TOUCH EVENT HANDLERS

/*Handle event of first touch of the thumb needle*/
- (void) dragThumbBegan:(UIControl *)control withEvent:(UIEvent *)event {
    currentLevel_ = (int)ceil(currentAngleDeg_/360.0) - 1;
    degreeAtCurrentLevel_ = currentAngleDeg_ - currentLevel_*360;
    radianAtCurrentLevel_ = currentAngleRad_ - currentLevel_*2*M_PI;
    
    if (degreeAtCurrentLevel_ <= 90) {
        currentQuarter_ = 1;
    } else if (degreeAtCurrentLevel_>90 && degreeAtCurrentLevel_<=180) {
        currentQuarter_ = 2;
    } else if (degreeAtCurrentLevel_>180 && degreeAtCurrentLevel_ <=270) {
        currentQuarter_ = 3;
    } else if (degreeAtCurrentLevel_>270 && degreeAtCurrentLevel_<=360){
        currentQuarter_ = 4;
    }
    NSLog(@"Began Drag Thumb -- Degree:%f Rad:%f Level:%i", degreeAtCurrentLevel_, radianAtCurrentLevel_, currentLevel_);
}

/*
 * Handle events of dragging the thumb needle
 */
- (void) dragThumbContinue:(UIControl*)control withEvent:(UIEvent *)event {
    CGPoint p =[[[event allTouches] anyObject] locationInView:self];
    
    //Move the (x,y) coordinates back to the origin
    double x = p.x - centerX_;
    double y = p.y - centerY_;
  
    //Determine which quarter of the circle we touched. Adjust angle accordingly.
    double cur_level_angle = atan((double)abs(y)/abs(x)); //angle at teh current level only
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
    } else if (x > 0 && y < 0) { 
        cur_level_angle = 2*M_PI - cur_level_angle; //IV
        if (currentQuarter_ == 1) currentLevel_ -= 1;
        currentQuarter_ = 4;
    }  
    
    // Add number of 360 degree turns depending on the turn number
    double total_angle = cur_level_angle + 2*currentLevel_*M_PI;  
    
    // Calculate total arclength
    float arclength = 0;  
    for (int cur = 0; cur < currentLevel_ ; cur++) {
        arclength += 2*M_PI*currentLevel_*dSpace_;
    }
    arclength += cur_level_angle * (currentLevel_ + 1) * dSpace_; //arclength at current level
        
    NSLog(@"LEVEL: %i, ANGLE: %f, ARCLENGTH: %f, MAXARCLENTGH: %f", currentLevel_, cur_level_angle*(180.0/M_PI), arclength, maxArcLength_);
    if (arclength > maxArcLength_ || total_angle < 0) 
        return;   
    // If (angle > maxAngleRad_ || angle<0) return; // exceed turn number limit
               
    // Calculate the final coordinates
    [self setCurrentAngleRadians:total_angle]; //update metrics
    [self setCurrentArcLength:arclength];
    [self updateNeedlePosition]; 
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/* Handle event of final touch of the thumb needle */
- (void) dragThumbEnded:(UIControl *)control withEvent:(UIEvent *)event {
    NSLog(@"DRAG ENDED");
}

#pragma mark - DRAWING THE SPIRAL
/*
 * Draw a spiral using Bezier Curve (faster drawing method)
 */
- (UIBezierPath *)spiralPath {
	
	//int iDegrees = DEGREES_PER_UNIT_VALUE;			// Angle between points. 15, 20, 24, 30.
	int totalPoints = 360 / DEGREES_PER_UNIT_VALUE;		// Total number of points.
    //int totalPoints = (2*M_PI*pow(dSpace_,2)) / ARCLENGTH_PER_UNIT_VALUE;
	double iDegreesRadian= M_PI * DEGREES_PER_UNIT_VALUE / 180.0;;			// iDegrees as radians.
	double dAngle;				// Cumulative radians while stepping.
	double dSpaceStep = 0;		// dSpace/iN.
	double insideCircleRadius = 0;				// Radius of inside circle. 
	double X = 0.0;				// x co-ordinate of a point.
	double Y = 0.0;				// y co-ordinate of a point.
    
    // Control- and end-points. First 2 points are control-points. Third point is end-point.

	dSpaceStep = 0; 
	double iCount = -1;      
	
	CGPoint c1 = CGPointMake(0, 0);
	CGPoint c2 = CGPointMake(0, 0);
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(centerX_, centerY_)];
	//CGContextRef context = UIGraphicsGetCurrentContext();

    int level = 0;
    int currentArc = 0;
    for (int i = DEGREES_PER_UNIT_VALUE; i <= maxAngleDeg_; i += DEGREES_PER_UNIT_VALUE) {
        dSpaceStep += dSpace_/(double)totalPoints;
        
        int j = i;
        level = 0;
        while (j>=0) {
            level +=1;
            currentArc = j;
            j  = j - level*2*M_PI*dSpace_; 
        }
        
        dAngle = (double)currentArc/((double)level*(double)dSpace_) + 2*M_PI*(level-1);


        // Get points.
        iCount += 1;
        if ((iCount == 0) || (iCount == 1)) {
            // Control-point.
            X = ((insideCircleRadius + dSpaceStep) / cos(iDegreesRadian)) * cos(dAngle) + centerX_;
            Y = ((insideCircleRadius + dSpaceStep) / cos(iDegreesRadian)) * sin(dAngle) + centerY_;
            
            if (iCount == 0){
                c1 = CGPointMake(X, Y);
            } else {
                c2 = CGPointMake(X, Y);
            }
        } else {
            // End-point.
            X = (insideCircleRadius + dSpaceStep) * cos(dAngle) + centerX_;
            Y = (insideCircleRadius + dSpaceStep) * sin(dAngle) + centerY_;
            //NSLog(@"End point: X:%f Y:%f", X-centerX, Y-centerY);
            iCount = -1;
            [path addCurveToPoint:CGPointMake(X, Y) controlPoint1:c1 controlPoint2:c2];
        }

        //float arclength = 0.5 * dSpace_*(sqrt(pow(dAngle,2) + 1)*dAngle + pow(sinh(dAngle),-1));
        //float arclength = 0.5 * dSpace_ * (dAngle*sqrt(1+pow(dAngle, 2)) + log10(dAngle+sqrt(1+pow(dAngle, 2))));
        //NSLog(@"AngleDEG:%i AngleRAD:%f Arc Length: %f\n", i, dAngle, arclength);

        // Draw circle after each turn
//        if (i%360 == 0) {            
//            CGContextSetLineWidth(context, 1.0);
//            CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//            int k = i/360;
//            float circleRad = k*dSpace_;
//            CGRect rectangle = CGRectMake(centerX_-circleRad, centerY_-circleRad, 2*circleRad, 2*circleRad);
//            CGContextAddEllipseInRect(context, rectangle);
//            CGContextStrokeEllipseInRect(context, rectangle);
//           // CGContextStrokePath(context);
//        }
    }
       
    

    return path;
}

/*
 * Draw Spiral by drawing a line between each points. (slower method)
 */
- (void)drawSpiralSlow {
    double angle = 0.0;	// Cumulative radians while stepping.
	double newX = centerX_;
    double newY = centerY_;

	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);

//	for (int i = DEGREES_PER_UNIT_VALUE; i <= maximumValue_; i += DEGREES_PER_UNIT_VALUE) {
//            angle = (M_PI*i/180.0);// + 2*k*M_PI;CGContextMoveToPoint(context, newX, newY);
//            newX = (dSpace_*angle*cos(angle))/(2*M_PI) + centerX_; newY = (dSpace_*angle*sin(angle))/(2*M_PI) + centerY_;
//            //NSLog(@"Drawing:k:%i angle:%i  newX: %0.0f newY: %0.0f", k, i, newX, newY);
//            CGContextAddLineToPoint(context, newX, newY); }
     
    int level = 0;
    double currentArc = 0.0;
    int j = 0;
    for (int i = 0; i <= maxArcLength_; i += ARCLENGTH_PER_UNIT_VALUE) {

        // Find current level based on arclength
        j = i;
        level = 0;
        while(j >= 0) {
            level += 1;
            currentArc = j;
            j  = j - 2*M_PI*(level*dSpace_); 
        }
        
        angle = currentArc/(level*dSpace_) + 2*M_PI*(level-1); //total angle
        CGContextMoveToPoint(context, newX, newY);
        newX = (dSpace_*angle*cos(angle))/(2*M_PI) + centerX_;
        newY = (dSpace_*angle*sin(angle))/(2*M_PI) + centerY_;
        NSLog(@"Drawing:level:%i i:%i angle:%f newX: %0.0f newY: %0.0f", level, i, angle , newX, newY);
        CGContextAddLineToPoint(context, newX, newY);
    }
    CGContextStrokePath(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //UIBezierPath *path = [self spiralPath]; // get your bezier path, perhaps from an ivar?
  	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //[path stroke];
    //CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    [self drawSpiralSlow];
}
 
#pragma mark - UIControl TOUCH EVENTS

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Touch Began");
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Touch Continued");
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //NSLog(@"Touch Ended");
    CGPoint p = [touch locationInView:self];
    
    //Move the (x,y) coordinates back to the origin
    double x = p.x - centerX_;
    double y = p.y - centerY_;
    //Calculate turn number based on the distance from the of origin
    currentLevel_ = floor(sqrt(pow(x,2) + pow(y,2)) / dSpace_); 
    
    //Determine which quarter of the circle we touched. Adjust angle accrodingly.
    double cur_level_angle = atan((double)abs(y)/abs(x));
    
    if  (x>=0 && y>=0) {
        cur_level_angle = cur_level_angle; //I quarter - do nothing.
        currentQuarter_ = 1;
    } else if (x<=0 && y>0) {
        cur_level_angle = M_PI - cur_level_angle; //II
        currentQuarter_ = 2;
    } else if (x<0 && y<=0) { 
        cur_level_angle = M_PI + cur_level_angle; //III
        currentQuarter_ = 3;
    } else if (x>0 && y<0) { 
        cur_level_angle = 2*M_PI - cur_level_angle; //IV
        currentQuarter_ = 4;
    }      
    
    // Add number of 360 degree turns depending on the turn number
    double total_angle = cur_level_angle + 2*currentLevel_*M_PI;  
    // Calculate total arclength
    float arclength = 0;  
    for (int cur = 0; cur < currentLevel_ ; cur++) {
        arclength += 2*M_PI*currentLevel_*dSpace_;
    }
    arclength += cur_level_angle * (currentLevel_ + 1) * dSpace_; //arclength at current level
    
    NSLog(@"LEVEL: %i, ANGLE: %f, ARCLENGTH: %f, MAXARCLENTGH: %f", currentLevel_, cur_level_angle*(180.0/M_PI), arclength, maxArcLength_);
    if (arclength > maxArcLength_ || total_angle < 0) return;   
 
    //Calculate the final coordinates
    [self setCurrentAngleRadians:total_angle]; // update metrics 
    [self setCurrentArcLength:arclength];
    [self updateNeedlePosition];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {[super touchesBegan:touches withEvent:event];}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {[super touchesMoved:touches withEvent:event];}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {[super touchesEnded:touches withEvent:event];}

#pragma mark - CUSTOM PUBLIC GETTERS AND SETTERS 
-(double) value {
    return value_/ARCLENGTH_PER_UNIT_VALUE;
}

-(void) setValue:(double)value {
    value_ = value * ARCLENGTH_PER_UNIT_VALUE;
    double arclen_temp = value_;
    int level_temp = 0;
    //NSLog(@"%f %f %f", value, value_, arclen_temp);
    //calculete angle using arclength given
    currentAngleRad_ = 0;
    while (arclen_temp >= 0) {
        if (arclen_temp - 2*M_PI*((level_temp+1)*dSpace_) <= 0) {
            currentAngleRad_ += arclen_temp/((level_temp+1)*dSpace_);
        } else  {
            currentAngleRad_ += 2*M_PI;
        }
        arclen_temp -= 2*M_PI*((level_temp+1)*dSpace_); // decrease full circle of arclength
        level_temp++; // advance to next level
    }
    //currentAngleDeg_ = value * DEGREES_PER_UNIT_VALUE;
    //currentAngleRad_ = value_ * (M_PI/180.0);
    currentAngleDeg_ = currentAngleRad_ * (180.0/M_PI);
    //NSLog(@"Upadated Angle Rad: %f", currentAngleRad_);
    [self updateNeedlePosition];
}

-(double) maximumValue{
    return maximumValue_;
}

-(void) setMaximumValue:(double)maximumValue {
    maximumValue_ = maximumValue; 
    
    maxAngleDeg_ = maximumValue * DEGREES_PER_UNIT_VALUE; // convert value to degrees
    maxAngleRad_ = maxAngleDeg_ * (M_PI/180.0); // convert to radians
    maxArcLength_ = maximumValue * ARCLENGTH_PER_UNIT_VALUE;
}

#pragma mark - CUSTOM PRIVATE METHODS

- (void) setCurrentAngleDegrees: (double) angleDeg {
    //value_ = angleDeg;
    currentAngleDeg_ = angleDeg;
    currentAngleRad_ = angleDeg * (180.0/M_PI);
}

- (void) setCurrentAngleRadians: (double) angleRad {
    //value_ = (angleRad *(180.0/M_PI));
    currentAngleDeg_ = value_;
    currentAngleRad_ = angleRad;    
}

-(void) setCurrentArcLength: (double) arclength {
    value_ = arclength;
}

/*
 * Update needle position depending on the current angle 
 */
-(void) updateNeedlePosition {
    double newX = (dSpace_*currentAngleRad_*cos(currentAngleRad_))/(2*M_PI) + centerX_;
    double newY = (dSpace_*currentAngleRad_*sin(currentAngleRad_))/(2*M_PI) + centerY_;
    thumb_.center = CGPointMake(newX, newY);
    //NSLog(@"Continue --    turn:%i newX:%0.0f newY:%0.0f x:%0.0f y:%0.0f", turnNum, newX, newY, p.x, p.y);
}

@end
