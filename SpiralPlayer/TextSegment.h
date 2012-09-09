//
//  TextSegment.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextSegment : UIView
@property (nonatomic, assign) CGColorRef bgColor;
@property (nonatomic, assign) double unitAngle;
@property (nonatomic, assign) char* letter;

@end
