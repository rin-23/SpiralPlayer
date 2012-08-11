//
//  GridHashTable.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridHashTable.h"
#import "Constants.h"

@implementation GridHashTable 

@synthesize gridHashTable = gridHashTable_;
-(id)init {
    self = [super init];
    if (self) {
        self.gridHashTable = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void) hashPointToGrid:(CGPoint)point {
    int bucket_x = floor(point.x / kX_NUM_OF_CELLS);
    int bucket_y = floor(point.y / kY_NUM_OF_CELLS);
    
    NSString* key = [NSString stringWithFormat:@"%i-%i", bucket_x, bucket_y];
    NSValue* value = [NSValue valueWithCGPoint:point];
    
    NSMutableArray* values_array = [self.gridHashTable objectForKey:key];
    if (values_array == nil) { //key doesnt exists so create
        values_array = [[NSMutableArray alloc] initWithObjects:value, nil];
        [self.gridHashTable setValue:values_array forKey:key];
        [values_array release];
    } else { 
        [values_array addObject:value];
        [self.gridHashTable setValue:values_array forKey:key];       
    }
}

- (NSValue*) getClosestGridPointToPoint:(CGPoint)touchPoint {
    int bucket_x = floor(touchPoint.x / kX_NUM_OF_CELLS);
    int bucket_y = floor(touchPoint.y / kY_NUM_OF_CELLS);
    NSString* key = [NSString stringWithFormat:@"%i-%i", bucket_x, bucket_y];
    NSMutableArray* values_array = [self.gridHashTable objectForKey:key];
    
    if (values_array == nil) { 
        return nil; // no point found
    } else { 
        float min_distance;
        float cur_distance;
        CGPoint currentPoint;
        CGPoint minPoint;
        //find the closest point to the touchPoint
        for (int i = 0 ; i < [values_array count]; i++) {
            currentPoint = [(NSValue*)[values_array objectAtIndex:i] CGPointValue];
            cur_distance = sqrtf(pow(currentPoint.x-touchPoint.x, 2) + pow(currentPoint.y - touchPoint.y, 2));
            if (i == 0) { 
                min_distance = cur_distance; 
                minPoint = currentPoint;
            } else {
                if (min_distance > cur_distance) {
                    min_distance = cur_distance;
                    minPoint = currentPoint; 
                }
            }
        }
        return [NSValue valueWithCGPoint:minPoint];        
    }
}

-(void) clear {
    [self.gridHashTable removeAllObjects];
}



@end
