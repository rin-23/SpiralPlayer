//
//  GridHashTable.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridHashTable : NSObject {
    NSMutableDictionary* gridHashTable_; //hash table of all of the data points
    
}

@property (nonatomic, retain) NSMutableDictionary* gridHashTable; 

- (void) hashPointToGrid:(CGPoint)point;
- (NSValue*) getClosestGridPointToPoint:(CGPoint)touchPoint;
- (void) clear;
@end
