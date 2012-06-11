//
//  DrawView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"
#import "math.h"

@interface DrawView(PrivateMethods)
- (void)drawSpiral;
@end

@implementation DrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
               
        self.backgroundColor = [UIColor lightGrayColor];        
        
        centerX_ = 380; //x-coordinate of the center of the spiral
        centerY_ = 512; //y-coordinate of the center of the spiral 
        dSpace_ = 70; // space between succesive turns of the spiral
        iTurns_ = 5; // Number of turns.
               
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

/*
 * Handle event of first touch of the thumb needle
 */
- (void) dragThumbBegan:(UIControl *)control withEvent:(UIEvent *)event {    
}

/*
 * Handle events of dragging the thumb needle
 */
- (void) dragThumbContinue:(UIControl *)control withEvent:(UIEvent *)event {
    
    //UIButton *bt = (UIButton *)control;
    CGPoint p =[[[event allTouches] anyObject] locationInView:self];
    
    //Move the (x,y) coordinates back to the origin
    double x = p.x - centerX_;
    double y = p.y - centerY_;
    //Calculate turn number based on the distance from the of origin
    int turnNum = floor(sqrt(pow(x,2) + pow(y,2)) / dSpace_); 
    if (turnNum >iTurns_-1) return; // exceed turn number limit
        
    //Determine which quarter of the circle we touched. Adjust angle accrodingly.
    double angle = atan((double)abs(y)/abs(x));
    
    if      (x>=0 && y>=0) angle = angle; //I quarter - do nothing.
    else if (x<=0 && y>=0) angle = M_PI - angle; //II
    else if (x<=0 && y<=0) angle = M_PI + angle; //III
    else if (x>=0 && y<=0) angle = 2*M_PI - angle;  //IV
         
    //add number of 360 degree turns depending on the turn number
    angle = angle + 2*turnNum*M_PI;  
    
    //Calculate the final coordinates
    double newX = (dSpace_*angle*cos(angle))/(2*M_PI) + centerX_;
    double newY = (dSpace_*angle*sin(angle))/(2*M_PI) + centerY_;
    NSLog(@"Continue --    turn:%i newX:%0.0f newY:%0.0f x:%0.0f y:%0.0f", turnNum, newX, newY, p.x, p.y);
       
    thumb_.center = CGPointMake(newX, newY); 

}

/*
 * Handle event of final touch of the thumb needle
 */
- (void) dragThumbEnded:(UIControl *)control withEvent:(UIEvent *)event {
}

#pragma mark - DRAWING THE SPIRAL
/*
 * Draw a spiral using Bezier Curve (faster drawing method)
 */

- (UIBezierPath *)spiralPath {
	
	int iDegrees = 30;			// Angle between points. 15, 20, 24, 30.
	int totalPoints = 360 / iDegrees;		// Total number of points.

	double iDegreesRadian= M_PI * iDegrees / 180.0;;			// iDegrees as radians.
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
	
  	for (int k = 0; k < iTurns_; k++) {
		for (int i = iDegrees; i <= 360; i += iDegrees)	{
            
            dSpaceStep += dSpace_/(double)totalPoints;
			dAngle = M_PI * i / 180.0;
               
			// Get points.
			iCount += 1;
			if ((iCount == 0) || (iCount == 1)) {
				// Control-point.
				X = ((insideCircleRadius + dSpaceStep) / cos(iDegreesRadian)) * cos(dAngle) + centerX_;
 				Y = ((insideCircleRadius + dSpaceStep) / cos(iDegreesRadian)) * sin(dAngle) + centerY_;
                
				if (iCount == 0){
					c1 = CGPointMake(X, Y);
                   // NSLog(@"Control Point 1: X:%f Y:%f", X-centerX, Y-centerY);
                } else {
					c2 = CGPointMake(X, Y);
                    //NSLog(@"Control Point 2: X:%f Y:%f", X-centerX, Y-centerY);
                }
			} else {
				// End-point.
				X = (insideCircleRadius + dSpaceStep) * cos(dAngle) + centerX_;
                Y = (insideCircleRadius + dSpaceStep) * sin(dAngle) + centerY_;
                //NSLog(@"End point: X:%f Y:%f", X-centerX, Y-centerY);
				iCount = -1;
			    [path addCurveToPoint:CGPointMake(X, Y) controlPoint1:c1 controlPoint2:c2];
            }
        }
//        CGContextSetLineWidth(context, 1.0);
//        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//        float circleRad = (k+1)*dSpace_;
//        CGRect rectangle = CGRectMake(centerX_-circleRad, centerY_-circleRad, 2*circleRad, 2*circleRad);
//       // CGContextAddEllipseInRect(context, rectangle);
//        CGContextStrokeEllipseInRect(context, rectangle);
        //CGContextStrokePath(context);
    }
    return path;
}

/*
 * Draw Spiral by drawing a line between each points. (slower method)
 */
- (void)drawSpiral {
    double angle = 0.0;	// Cumulative radians while stepping.
	double newX = centerX_;
    double newY = centerY_;
	    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);
    
	for (int k = 0; k < iTurns_; k++) {
		for (int i = 1; i <= 360; i++)	{
            
            angle = (M_PI*i/180.0) + 2*k*M_PI;
            
            CGContextMoveToPoint(context, newX, newY);
            
            newX = (dSpace_*angle*cos(angle))/(2*M_PI) + centerX_;
            newY = (dSpace_*angle*sin(angle))/(2*M_PI) + centerY_;
            //NSLog(@"Drawing:k:%i angle:%i  newX: %0.0f newY: %0.0f", k, i, newX, newY);
        
            CGContextAddLineToPoint(context, newX, newY);
        }
    }
    CGContextStrokePath(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [self spiralPath]; // get your bezier path, perhaps from an ivar?
    [path stroke];
    //[self drawSpiral];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Touch Began");
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Touch Continued");
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
}



@end
