//
//  Utilities.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

#define  ARC4RANDOM_MAX 0x100000000

@implementation Utilities


static Utilities* instance;

-(id)init{
    self = [super init];
    if (self) {

    }
    return self;
}


+ (Utilities*) sharedInstance {
    if (instance == nil) instance = [[Utilities alloc] init];
    return instance;
}


- (double) toRad:(int) deg { return deg*(M_PI/180.0); }
- (int) toDeg:(double) rad { return (int)(rad*(180.0/M_PI) + 0.5); }

- (char*) randomLetter {
    char* alpahbet = "abcdefghijklmnopqrstuvxyz ";
    int index = arc4random_uniform(33);
    char* c = malloc(2*sizeof(char));
    c[0] = alpahbet[index];
    c[1] = '\0';
    //printf(c);
    return c ;
}

- (CGColorRef) randomColor {
    double r = ((double)arc4random() / ARC4RANDOM_MAX);
    double g = ((double)arc4random() / ARC4RANDOM_MAX);
    double b = ((double)arc4random() / ARC4RANDOM_MAX);
    return CGColorRetain([UIColor colorWithRed:r green:g blue:b alpha:1].CGColor);
}


@end
