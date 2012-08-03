//
//  CoverImageView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef unsigned char byte;

typedef struct RGBPixel {
    byte    red;
    byte    green;
    byte    blue;
}   RGBPixel;

@interface CoverImageView : UIImageView {
    //  Reference to Quartz CGImage for receiver (self)
    CFDataRef       bitmapData; 
   
    //  Buffer holding raw pixel data copied from Quartz CGImage held in receiver (self)
    UInt8*          pixelByteData;
    
    //  A pointer to the first pixel element in an array
    RGBPixel*           pixelData;
}
@property (nonatomic, assign) CFDataRef bitmapData;
@property (nonatomic, assign) UInt8* pixelByteData;
@property (nonatomic, assign) RGBPixel* pixelData;
@end
