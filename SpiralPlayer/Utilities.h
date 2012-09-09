//
//  Utilities.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject


- (double) toRad:(int) deg;
- (int) toDeg:(double) rad;
- (CGColorRef) randomColor;
- (char*) randomLetter;
+ (Utilities*) sharedInstance;

@end
