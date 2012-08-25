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
        recognizer.cancelsTouchesInView = YES;
        [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:recognizer];
        [recognizer release];
    }
    return self;
}

- (int) index {
    return self.object.index;
}

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
    CGContextMoveToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    //CGContextAddLineToPoint(context, 0, rect.size.height);
    CGPoint p1 = CGPointMake(rect.size.width/2, 0);
    CGPoint p2 = CGPointMake(rect.size.width/2, rect.size.height);
    CGFloat radius = sqrtf(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
    double totalAngle = 45.0 * (M_PI/180.0);
    CGContextAddArc(context, rect.size.width/2, 0, radius-2, (M_PI - totalAngle)/2, (M_PI - totalAngle)/2 + totalAngle , 0);
    
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width/2, 0);
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
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}



@end
