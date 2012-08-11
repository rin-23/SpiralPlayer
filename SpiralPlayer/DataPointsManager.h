//
//  DataPointsManager.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPointsManager : NSObject{
    
    NSMutableDictionary* filesRead_;
    

}

@property (nonatomic, retain) NSMutableDictionary* filesRead;

+ (DataPointsManager*) sharedInstance;
- (NSMutableDictionary*) getPointsForFile:(NSString*)fileName ofType:(NSString*)type;
- (NSMutableArray*) intepolateFromValue:(NSValue *)p0 toValue:(NSValue *)p1;
- (NSMutableArray*) intepolateFromPoint:(CGPoint) p0 toPoint:(CGPoint) p1;
@end
