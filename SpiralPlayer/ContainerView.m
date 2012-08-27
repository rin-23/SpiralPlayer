//
//  ContainerView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContainerView.h"

@implementation ContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Container View touch began");
    [self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Container View touch moved");
    [self.superview touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Container View touch ended");
    [self.superview  touchesEnded:touches withEvent:event];
}
@end
