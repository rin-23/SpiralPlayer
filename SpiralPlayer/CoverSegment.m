//
//  CoverSegment.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoverSegment.h"

@implementation CoverSegment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
           self.backgroundColor = [UIColor clearColor];
           self.userInteractionEnabled = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
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
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);


}

@end
