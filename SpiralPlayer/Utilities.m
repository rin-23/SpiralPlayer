//
//  Utilities.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

static Utilities* instance;

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (Utilities*) sharedInstance {
    @synchronized(instance) {
        if (instance == nil) {
            instance = [[Utilities alloc] init];
        }
        return instance;
    }
}


/* 
 * Perform linear interpolation between Point p0 and Point p1
 * and return the interpolated points as array.
 */

- (NSMutableArray*) intepolateFromValue:(NSValue *)p0 toValue:(NSValue *)p1 {
    return [self intepolateFromPoint:[p0 CGPointValue] toPoint:[p1 CGPointValue]];
}


- (NSMutableArray*) intepolateFromPoint:(CGPoint) p0 toPoint:(CGPoint) p1 {
    
    NSMutableArray* extraPoints = [[[NSMutableArray alloc] init] autorelease];
    int x0 = p0.x; 
    int y0 = p0.y;
    int x1 = p1.x; 
    int y1 = p1.y;	
    
    if (abs(x0 - x1) > abs(y0 - y1)) {
        // Interpolate over x
        if (x0 > x1) {
            for (int x = x0 - 1; x > x1; x--) {
                float y = (float)y0 + ((float)((x - x0) * y1
                                               - (x - x0) * y0))/(float)(x1 - x0);
                CGPoint p = CGPointMake(x, (int)(y+0.5));
                [extraPoints addObject:[NSValue valueWithCGPoint:p]];
            }
        } else {
            for (int x = x0 + 1; x < x1; x++) {
                float y = (float)y0 + ((float)((x - x0) * y1
                                               - (x - x0) * y0))/(float)(x1 - x0);
                CGPoint p = CGPointMake(x, (int)(y+0.5));
                [extraPoints addObject:[NSValue valueWithCGPoint:p]];
            }
        }
    } else {
        // Interpolate over y
        if (y0 > y1) {
            for (int y = y0 - 1; y > y1; y--) {
                float x = (float)x0 + ((float)((y - y0) * x1
                                               - (y - y0) * x0))/(float)(y1 - y0);
                CGPoint p = CGPointMake((int)(x+0.5), y);
                [extraPoints addObject:[NSValue valueWithCGPoint:p]];
            }
        } else {
            for (int y = y0 + 1; y < y1; y++) {
                float x = (float)x0 + ((float)((y - y0) * x1
                                               - (y - y0) * x0))/(float)(y1 - y0);
                CGPoint p = CGPointMake((int)(x+0.5), y);
                [extraPoints addObject:[NSValue valueWithCGPoint:p]];
            }
        }

    
    }

    return  extraPoints;
    
}

@end
