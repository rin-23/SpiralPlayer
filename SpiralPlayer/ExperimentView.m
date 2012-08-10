//
//  ExperimentView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExperimentView.h"

@interface ExperimentView (PrivateMethods)
- (void) drawSpiral:(CGRect)rect;
- (void) drawSineWave:(CGRect)rect;
- (void) drawBySpiralByPieces:(CGRect)rect;
@end

@implementation ExperimentView

- (id)initWithFrame:(CGRect)frame {
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

- (void) drawSpiral:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef maskImage;
    
    /****************************BEGIN CREATE A MASK********************************/
    CGContextSaveGState(context);
    CGContextSetRGBFillColor (context, 0, 0, 0, 0);
    CGContextFillRect(context, rect);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    
    double angle = 0.0;	// Cumulative radians while stepping.
    centerX_ = rect.size.width/2;
    centerY_ = rect.size.height/2;
    double newX = centerX_;
    double newY = centerY_;    
    
    CGContextSetLineWidth(context, 2);
    
    int level = 0;
    double currentArc = 0.0;
    int j = 0;    
    for (int i = 0; i <= maxArclength_; i += 1) {
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
        
        //if (i%2 == 0) { CGContextSetStrokeColorWithColor(context, leftcolor);
        //} else {
        //CGContextSetStrokeColorWithColor(context, rightcolor);
        //}
        
        CGContextAddLineToPoint(context, newX, newY);
        CGContextStrokePath(context);
    } 
    
    maskImage = CGBitmapContextCreateImage(context);
    CGContextRestoreGState(context);
    /****************************END CREATE A MASK********************************/
    
    //CGImageRef cgimage = [UIImage imageNamed:@"morcheeba-skye"].CGImage;
    CGImageRef cgimage = [UIImage imageNamed:@"lana"].CGImage;

    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, maskImage); 
    CGContextDrawImage(context, rect, cgimage);

}

- (void) drawSineWave:(CGRect) rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef maskImage;
    
    /**************************BEGIN CREATE A PIZZA LAYER MASK******************/
    double angle_deg = 40;
    double angle_rad = angle_deg * (M_PI/180);
    int height = rect.size.height/2;
    int width = 2*(height * tan(angle_rad/2));   
    CGSize layerSize = CGSizeMake(width, height);
    
    CGContextSaveGState(context);
 
//    CGContextSetRGBFillColor (context, 0, 0, 0, 0);
//    CGContextFillRect(context, rect);
    
    CGLayerRef pizzaSliceLayer = CGLayerCreateWithContext(context, layerSize, NULL); 
    CGContextRef pizzaSliceLayerContext = CGLayerGetContext(pizzaSliceLayer);
   
    CGContextSetRGBFillColor (pizzaSliceLayerContext, 0, 0, 0, 0);
    CGContextFillRect(pizzaSliceLayerContext, CGRectMake(0, 0, layerSize.width, layerSize.height));
    
    int level = 30;
    CGContextBeginPath(pizzaSliceLayerContext);
    CGContextSetRGBStrokeColor(pizzaSliceLayerContext, 1, 1, 1, 1);
    CGContextSetLineWidth(pizzaSliceLayerContext, 1);
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
    CGContextRestoreGState(context);
    /**************************END CREATE A PIZZA LAYER MASK******************/
    
    /**************************BEGIN DRAW PIZZA SLICES*****************************/
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.size.width/2 - layerSize.width/2, rect.size.height/2);
    
    for (int i = 0; i<360/angle_deg; i++) {
        
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, layerSize.width/2, 0);
        CGContextRotateCTM(context, i*angle_rad);
        CGContextTranslateCTM(context, -(layerSize.width/2), 0);
        CGContextDrawLayerAtPoint(context, CGPointMake(0, 0), pizzaSliceLayer);
        CGContextRestoreGState(context);
    }
    CGContextRestoreGState(context);
    /**************************END DRAW PIZZA SLICES*****************************/
    
    maskImage = CGBitmapContextCreateImage(context);
    CGImageRef cgimage = [UIImage imageNamed:@"morcheeba-skye"].CGImage;
    //CGImageRef cgimage = [UIImage imageNamed:@"lana"].CGImage;
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, maskImage); 
    CGContextDrawImage(context, rect, cgimage);
}


- (void) drawRect:(CGRect)rect {
    [self drawSineWave:rect];   
    //[self drawSpiral:rect];   
}


@end
