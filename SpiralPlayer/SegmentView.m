//
//  SegmentView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentView.h"

@implementation SegmentView 

@synthesize index, bgColor, image = image_, object = object_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bgColor = [UIColor whiteColor].CGColor;  
        self.backgroundColor = [UIColor clearColor];
                
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
      
    CGContextSaveGState(context);
    CGContextSetRGBFillColor (context, 0, 0, 0, 0);
    CGContextFillRect(context, rect);
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
    CGContextAddLineToPoint(context, pR.x, pR.y);
    
    CGFloat radius = rect.size.height;
    CGFloat radius2 = sqrt(pow(halfwayR.x - pT.x, 2) + pow(halfwayR.y - pT.y, 2));
    
    double totalAngle = 45.0 * (M_PI/180.0);
    CGContextAddArc(context, pT.x, pT.y, radius-2, (M_PI - totalAngle)/2, (M_PI - totalAngle)/2 + totalAngle, 0);
    CGContextMoveToPoint(context, pL.x - 0.075*vectorL.x, pL.y - 0.075*vectorL.y);
    CGContextAddLineToPoint(context, halfwayL.x, halfwayL.y);

    CGContextAddArc(context, pT.x, pT.y, radius2, (M_PI - totalAngle)/2 + totalAngle, (M_PI - totalAngle)/2, 1);
    
    //CGContextAddLineToPoint(context, halfwayR.x, halfwayR.y);
    CGContextSetRGBFillColor (context, 1, 1, 1, 1);
    //CGContextSetFillColorWithColor(context, self.bgColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGImageRef maskImage = CGBitmapContextCreateImage(context);
       
    CGContextRestoreGState(context);
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
   
    CGContextClipToMask(context, rect, maskImage); 
    CGContextDrawImage(context, rect, self.object.image.CGImage);
    CGImageRelease(maskImage);

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
