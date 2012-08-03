//
//  CoverImageView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoverImageView.h"


@implementation CoverImageView 

@synthesize bitmapData, pixelData, pixelByteData;

- (void) covertImageToBitmap {
    CGImageRef cgImage = [self.image CGImage];
    [self   setBitmapData:CGDataProviderCopyData( CGImageGetDataProvider(cgImage))];
    
    //  Create a buffer to store bitmap data (unitialized memory as long as the data)
    [self   setPixelByteData:malloc( CFDataGetLength( bitmapData ) )];
    
    //  Copy image data into allocated buffer
    CFDataGetBytes( bitmapData, CFRangeMake( 0, CFDataGetLength( bitmapData ) ), pixelByteData );
    
    //  Essentially what we're doing is making a second pointer that divides the byteData's units differently - instead of dividing each unit as 1 byte we will divide each unit as 3 bytes (1 pixel).
    pixelData   = (RGBPixel*) pixelByteData;
}

- (RGBPixel*) pixelDataForRow:(int)row column:(int)column {
    //  Return a pointer to the pixel data
    return &pixelData[ row * column ];      
}

@end
