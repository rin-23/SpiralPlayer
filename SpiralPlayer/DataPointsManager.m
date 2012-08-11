//
//  DataPointsManager.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataPointsManager.h"


@implementation DataPointsManager

@synthesize filesRead = filesRead_;

static DataPointsManager* instance;

-(id)init{
    self = [super init];
    if (self) {
        self.filesRead = [[NSMutableDictionary alloc] init];
    }
    return self;
}


+ (DataPointsManager*) sharedInstance {
    if (instance == nil) instance = [[DataPointsManager alloc] init];
    return instance;
}


//Reads the file and returns all read data points as well as the interpolated data points from the dictionary
- (NSMutableDictionary*) getPointsForFile:(NSString*)fileName ofType:(NSString*)type{
    
    //check of the file was already read before
    NSMutableDictionary* returnDictionary = [self.filesRead objectForKey:fileName]; 
    if (returnDictionary != nil) return returnDictionary;
   
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray* lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    int numOfDataPoints_ = [lines count] - 1;//[(NSString*)[lines objectAtIndex:0] intValue];
    NSLog(@"Capacity: %i", numOfDataPoints_);
    
    NSMutableArray* dataPoints = [[NSMutableArray alloc] initWithCapacity:numOfDataPoints_];  
    NSMutableArray* drawingPoints = [[NSMutableArray alloc] initWithCapacity:numOfDataPoints_];
    
    //Starting Point
    NSArray* coordinates = [(NSString*)[lines objectAtIndex:0] componentsSeparatedByString:@" "];
    float x_f = [[coordinates objectAtIndex:0] floatValue];
    float y_f = [[coordinates objectAtIndex:1] floatValue];
    int old_x = (int)(x_f+0.5);
    int old_y = (int)(y_f+0.5);
       
    for (int i = 1; i < numOfDataPoints_; i += 1) {
        NSArray* coordinates = [(NSString*)[lines objectAtIndex:i] componentsSeparatedByString:@" "];
        float x_f = [[coordinates objectAtIndex:0] floatValue];
        float y_f = [[coordinates objectAtIndex:1] floatValue];
        int x = (int)(x_f+0.5);
        int y = (int)(y_f+0.5);
        
        double distance = sqrt(pow(x-old_x, 2) + pow(y-old_y, 2));
        if (distance > 2) {
            NSMutableArray* extraPoints = [self intepolateFromPoint:CGPointMake(old_x, old_y) toPoint:CGPointMake(x, y)];
            [dataPoints addObjectsFromArray:extraPoints];
        }
        // NSLog(@"Read a point X:%i, Y:%i", x, y);
        CGPoint point = CGPointMake(x, y);
        [dataPoints addObject:[NSValue valueWithCGPoint:point]];
        [drawingPoints addObject:[NSValue valueWithCGPoint:point]];
        old_x = x;
        old_y = y;
    }
    NSLog(@"Done reading data points from file");
    
    returnDictionary = [[NSMutableDictionary alloc] init];
    [returnDictionary setObject:dataPoints forKey:@"dataPoints"];
    [returnDictionary setObject:drawingPoints forKey:@"drawingPoints"];

    [self.filesRead setObject:returnDictionary forKey:fileName];
    
    [dataPoints release];[drawingPoints release];
    
    return [returnDictionary autorelease];      
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
