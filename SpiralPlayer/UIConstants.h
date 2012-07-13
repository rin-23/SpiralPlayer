//
//  UIConstants.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef SpiralPlayer_UIConstants_h
#define SpiralPlayer_UIConstants_h

#define MAIN_BACKGROUND_COLOR 0x276FA7

//Color Macros
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbValue & 0xFF) )/255.0]


#endif
