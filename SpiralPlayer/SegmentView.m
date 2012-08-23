//
//  SegmentView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentView.h"

@implementation SegmentView

@synthesize index, bgColor, image = image_;

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
    CGContextSetRGBFillColor (context, 0, 0, 0, 0);
    CGContextFillRect(context, rect);
    CGContextBeginPath (context);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);  
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, rect.size.width, rect.size.height/2);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    //CGContextSetRGBFillColor (context, 1, 1, 1, 1);
    CGContextSetFillColorWithColor(context, self.bgColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
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
