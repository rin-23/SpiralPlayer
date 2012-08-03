//
//  ExperimentView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExperimentView.h"

@implementation ExperimentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            centerX_ = 380; // x-coordinate of the center of the spiral
            centerY_ = 512; // y-coordinate of the center of the spiral 
        } else {
            centerX_ = 320/2;
            centerY_ = 480/2 + 30; 
        }
        
        maxArclength_ = 45000;
        radiusStep_ = 10 ;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef maskImage;
    
    /**************************BEGIN CREATE A PIZZA LAYER MASK******************/
    CGSize layerSize = CGSizeMake(rect.size.width/2, rect.size.height/2);
    CGLayerRef pizzaSliceLayer = CGLayerCreateWithContext(context, layerSize, NULL); 
    CGContextRef pizzaSliceLayerContext = CGLayerGetContext(pizzaSliceLayer);
   
    CGContextSetRGBFillColor (pizzaSliceLayerContext, 0, 0, 0, 0);
    CGContextFillRect(pizzaSliceLayerContext, CGRectMake(0, 0, layerSize.width, layerSize.height));
    
    int level = 20;
    CGContextBeginPath(pizzaSliceLayerContext);
    CGContextSetRGBStrokeColor(pizzaSliceLayerContext, 1, 1, 1, 1);
    //CGContextRotateCTM(context, 10.0 * (M_PI/180));  
    CGContextSetLineWidth(pizzaSliceLayerContext, 3);
    double x;
    int old_y = rect.origin.y;
    double old_x = (((double)old_y/(double)layerSize.height) * (layerSize.width/2) * sin(((level*old_y) % 360) * M_PI/180)) + layerSize.width/2;
    
    for (double y = rect.origin.y; y < layerSize.height; y += 0.1) {
        x = ((y/(double)layerSize.height) * (layerSize.width/2) * sin(fmod(level*y, 360.0) * M_PI/180)) + layerSize.width/2;
        
        CGContextMoveToPoint(pizzaSliceLayerContext, old_x, old_y);
        CGContextAddLineToPoint(pizzaSliceLayerContext, x, y);
        CGContextStrokePath(pizzaSliceLayerContext);
        
        old_x = x;
        old_y = y;
    }
    /**************************END CREATE A PIZZA LAYER MASK******************/
    
    /**************************BEGIN DRAW PIZZA SLICES*****************************/
    CGContextSaveGState(context);
    CGContextDrawLayerAtPoint(context, CGPointMake((rect.size.width/2) - (layerSize.width/2), rect.size.height/2), pizzaSliceLayer);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
   
    CGContextTranslateCTM(context, 450, -160);

    CGContextRotateCTM(context, 50.0 * (M_PI/180));  
       CGContextDrawLayerAtPoint(context, CGPointMake((rect.size.width/2) - (layerSize.width/2), rect.size.height/2), pizzaSliceLayer);
    
    CGContextRestoreGState(context);
//    CGContextRotateCTM(context, 20.0 * (M_PI/180));  
//    CGContextDrawLayerAtPoint(context, CGPointMake((rect.size.width/2) - (layerSize.width/2), rect.size.height/2), pizzaSliceLayer);
//    CGContextRotateCTM(context, 20.0 * (M_PI/180));  
//    CGContextDrawLayerAtPoint(context, CGPointMake((rect.size.width/2) - (layerSize.width/2), rect.size.height/2), pizzaSliceLayer);

    
    
    
    
    /**************************END DRAW PIZZA SLICES*****************************/
    
    
    
        
    maskImage = CGBitmapContextCreateImage(context);
    
    
    /****************************BEGIN CREATE A MASK********************************/
//    CGContextSaveGState(context);
//    
//
//    CGContextSetRGBFillColor (context, 0, 0, 0, 0);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
//    double angle = 0.0;	// Cumulative radians while stepping.
//    centerX_ = rect.size.width/2;
//    centerY_ = rect.size.height/2;
//    
//	double newX = centerX_;
//    double newY = centerY_;    
//	   
//    CGContextSetLineWidth(context, 2);
//    //CGColorRef leftcolor = [[UIColor whiteColor] CGColor]; 
//    //CGColorRef rightcolor = [[UIColor colorWithRed:0.7 green:0 blue:0 alpha:0] CGColor];
//   
//    int level = 0;
//    double currentArc = 0.0;
//    int j = 0;    
//    for (int i = 0; i <= maxArclength_; i += 1) {
//        j = i;
//        level = 0;
//        while (j >= 0) {
//            level += 1;
//            currentArc = j;
//            j = j - 2*M_PI*(level*radiusStep_); 
//        }   
//        
//        angle = currentArc/(level*radiusStep_) + 2*M_PI*(level-1); //total angle
//        CGContextMoveToPoint(context, newX, newY);
//        newX = (radiusStep_*angle*cos(angle))/(2*M_PI) + centerX_;
//        newY = (radiusStep_*angle*sin(angle))/(2*M_PI) + centerY_;
//        
//        //if (i%2 == 0) { CGContextSetStrokeColorWithColor(context, leftcolor);
//        //} else {
//       // CGContextSetStrokeColorWithColor(context, rightcolor);
//        //}
//               
//        CGContextAddLineToPoint(context, newX, newY);
//        CGContextStrokePath(context);
//    } 
//
//    maskImage = CGBitmapContextCreateImage(context);
////    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage)
////                                                    , CGImageGetHeight(maskImage)
////                                                    , CGImageGetBitsPerComponent(maskImage)
////                                                    , CGImageGetBitsPerPixel(maskImage)
////                                                    , CGImageGetBytesPerRow(maskImage)
////                                                    ,  CGImageGetDataProvider(maskImage)
////                                                    , NULL
////                                                    , false);
//    CGContextRestoreGState(context);
    /****************************END CREATE A MASK********************************/
    
    
    CGImageRef cgimage = [UIImage imageNamed:@"morcheeba-skye"].CGImage;

    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
   
    CGContextClipToMask(context, rect, maskImage); 
    //Draw Album Cover
  
    CGContextDrawImage(context, rect, cgimage);
    
   
    
    
    
//    CGContextBeginTransparencyLayer(context, NULL);
//    //CGContextBeginPath (context);
//    //CGContextSetRGBFillColor (context, 0, 1, 0, 0.2);
//    CGContextFillEllipseInRect(context, rect);
//    CGContextClip(context);
//    CGContextSetRGBFillColor (context, 1, 0, 0, 1);
//    CGContextFillRect (context, rect);
    
    /*
    double angle = 0.0;	// Cumulative radians while stepping.
    centerX_ = rect.size.width/2;
    centerY_ = rect.size.height/2;
	double newX = centerX_;
    double newY = centerY_;
    
	
    CGContextSetLineWidth(context, 2);
    //CGColorRef leftcolor = [[UIColor whiteColor] CGColor]; 
    CGColorRef rightcolor = [[UIColor colorWithRed:0.7 green:0 blue:0 alpha:0] CGColor];
   // CGColorRef middleColor = [[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1] CGColor];
    
    //NSLog(@"SampleCount: %i MaxArc:%f", sampleCount_, maxArcLength_);
    
    int level = 0;
    double currentArc = 0.0;
    int j = 0;
    //SInt16* temp_sample = (SInt16*) self.samples.bytes;
    
    for (int i = 0; i <= maxArclength_; i += 1) {
        //for (int i = 0; i <= sampleCount_; i += 1) {
        j = i;
        level = 0;
        while (j >= 0) {
            level += 1;
            currentArc = j;
            j = j - 2*M_PI*(level*radiusStep_); 
        }   
        
        angle = currentArc/(level*radiusStep_) + 2*M_PI*(level-1); //total angle
        
        CGContextMoveToPoint(context, newX, newY);
        newX = (radiusStep_*angle*cos(angle))/(2*M_PI) + centerX_;
        newY = (radiusStep_*angle*sin(angle))/(2*M_PI) + centerY_;
        
        //if (i%2 == 0) {
          //  CGContextSetStrokeColorWithColor(context, leftcolor);
        //} else {
         CGContextSetStrokeColorWithColor(context, rightcolor);
        //}
        
        
        
        CGContextAddLineToPoint(context, newX, newY);
        CGContextStrokePath(context);
    } 
    
    */
    
   // CGContextEndTransparencyLayer(context);  
    
    
    
}


@end
