//
//  DataPointsManager.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataPointsManager.h"
#import "Utilities.h"

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
            NSMutableArray* extraPoints = [[Utilities sharedInstance] intepolateFromPoint:CGPointMake(old_x, old_y) toPoint:CGPointMake(x, y)];
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



@end
