//
//  TextSegment.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextSegment.h"
#import "Utilities.h"
@implementation TextSegment

@synthesize bgColor=_bgColor;
@synthesize unitAngle = _unitAngle;
@synthesize letter = _letter;
@synthesize index = _index;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.letter = malloc(2*sizeof(2));
        self.backgroundColor = [UIColor clearColor];
        self.unitAngle = 0;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {   
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
    double vectorLlength = sqrt(pow(vectorL.x, 2) + pow(vectorL.y, 2));
    CGPoint vectorLUnit = CGPointMake(vectorL.x/vectorLlength, vectorL.y/vectorLlength);
    
    CGPoint vectorR = CGPointMake(pR.x - pT.x, pR.y - pT.y);
    double vectorRlength = sqrt(pow(vectorR.x, 2) + pow(vectorR.y, 2));
    CGPoint vectorRUnit = CGPointMake(vectorR.x/vectorRlength, vectorR.y/vectorRlength);

    CGFloat radius = rect.size.height;

    int segHeight = 20;
    CGPoint halfwayL = CGPointMake(pT.x + (radius-segHeight)*vectorLUnit.x, pT.y + (radius-segHeight)*vectorLUnit.y);
    CGPoint halfwayR = CGPointMake(pT.x + (radius-segHeight)*vectorRUnit.x, pT.y + (radius-segHeight    )*vectorRUnit.y);
    CGPoint bottomL = CGPointMake(pT.x + radius*vectorLUnit.x, pT.y + radius*vectorLUnit.y);
    CGPoint bottomR = CGPointMake(pT.x + radius*vectorRUnit.x, pT.y + radius*vectorRUnit.y);

    CGContextMoveToPoint(context, halfwayR.x, halfwayR.y);
    CGContextAddLineToPoint(context, bottomR.x , bottomR.y);
    
    CGFloat radius2 = sqrt(pow(halfwayR.x - pT.x, 2) + pow(halfwayR.y - pT.y, 2));
    
    double totalAngle = self.unitAngle;
    CGContextAddArc(context, pT.x, pT.y, radius-2, (M_PI - totalAngle)/2, (M_PI - totalAngle)/2 + totalAngle, 0);
    CGContextMoveToPoint(context, bottomL.x, bottomL.y);
    CGContextAddLineToPoint(context, halfwayL.x, halfwayL.y);
    CGContextAddArc(context, pT.x, pT.y, radius2, (M_PI - totalAngle)/2 + totalAngle, (M_PI - totalAngle)/2, 1);
    
    //CGContextAddLineToPoint(context, halfwayR.x, halfwayR.y);
    //CGContextSetRGBFillColor (context, 1, 1, 1, 1);
    CGContextSetFillColorWithColor(context, self.bgColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSelectFont (context, "Helvetica-Light", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode (context, kCGTextStroke); // 5
    CGContextSetRGBStrokeColor (context, 1, 1, 1, 1); // 7
    CGContextShowTextAtPoint (context, rect.size.width/2 - 5, 5, self.letter, 1);
}

- (NSComparisonResult) compareIndexes:(TextSegment*)otherEvenet {
    if (self.index < otherEvenet.index) { 
        return NSOrderedAscending;
    } else if (self.index > otherEvenet.index) { 
        return NSOrderedDescending;
    } else { 
        return NSOrderedSame;
    }
}

@end
