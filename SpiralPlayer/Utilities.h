//
//  Utilities.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (Utilities*) sharedInstance;
- (NSMutableArray*) intepolateFromPoint:(CGPoint) p0 toPoint:(CGPoint) p1;
- (NSMutableArray*) intepolateFromValue:(NSValue*) p0 toValue:(NSValue*) p1;


@end
