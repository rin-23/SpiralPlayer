//
//  PizzaControl.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PizzaControl.h"

@implementation PizzaControl

@synthesize angleDeg = angleDeg_, angleRad = angleRad_;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        self.angleDeg = 45;
        self.angleRad = self.angleDeg * (M_PI/180);
        dataPoints_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef maskImage;
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/newfile.txt", documentsDirectory];
    NSString *content = @"";
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    
    /**************************BEGIN CREATE A PIZZA LAYER MASK******************/
    int height = rect.size.height/2;
    int width = 2*(height * tan(self.angleRad/2));   
    CGSize layerSize = CGSizeMake(width, height);
    
    CGContextSaveGState(context);
    
    CGContextSetRGBFillColor (context, 1, 0, 0, 1);
    CGContextFillRect(context, rect);
    
    CGLayerRef pizzaSliceLayer = CGLayerCreateWithContext(context, layerSize, NULL); 
    CGContextRef pizzaSliceLayerContext = CGLayerGetContext(pizzaSliceLayer);
    
    CGContextSetRGBFillColor (pizzaSliceLayerContext, 0, 0, 0, 0);
    CGContextFillRect(pizzaSliceLayerContext, CGRectMake(0, 0, layerSize.width, layerSize.height));
    
    int level = 15;
    CGContextBeginPath(pizzaSliceLayerContext);
    CGContextSetRGBStrokeColor(pizzaSliceLayerContext, 1, 1, 1, 1);
    CGContextSetLineWidth(pizzaSliceLayerContext, 1);
    double x;
    int old_y = rect.origin.y;
    double old_x = (((double)old_y/(double)layerSize.height) * (layerSize.width/2) * sin(((level*old_y) % 360) * M_PI/180)) + layerSize.width/2;
    [dataPoints_ addObject:[NSValue valueWithCGPoint:CGPointMake((int)(old_x +0.5), (int)old_y)]];
    
    [myHandle seekToEndOfFile];
    NSString* stringCoordinates = [NSString stringWithFormat:@"%i %i\n", (int)(old_x +0.5),(int)(old_y + 0.5)];
    [myHandle writeData:  [stringCoordinates dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (double y = rect.origin.y; y < layerSize.height; y += 1) {
        x = ((y/(double)layerSize.height) * (layerSize.width/2) * sin(fmod(level*y, 360.0) * M_PI/180)) + layerSize.width/2;
        
        if (![dataPoints_ containsObject:[NSValue valueWithCGPoint:CGPointMake((int)(x+0.5), (int)(y+0.5))]]) {
            [dataPoints_ addObject:[NSValue valueWithCGPoint:CGPointMake((int)(x+0.5), (int)(y+0.5))]];
            [myHandle seekToEndOfFile];
            NSString* stringCoordinates = [NSString stringWithFormat:@"%i %i\n", (int)(x+0.5),(int)(y+0.5)];
            [myHandle writeData: [stringCoordinates dataUsingEncoding:NSUTF8StringEncoding]];
            CGContextMoveToPoint(pizzaSliceLayerContext, old_x, old_y);
            CGContextAddLineToPoint(pizzaSliceLayerContext, x, y);
            CGContextStrokePath(pizzaSliceLayerContext);
            
            old_x = x; 
            old_y = y;
        }
        
        
        
    }
    CGContextRestoreGState(context);
    /**************************END CREATE A PIZZA LAYER MASK******************/
    
    /**************************BEGIN DRAW PIZZA SLICES*****************************/
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.size.width/2 - layerSize.width/2, rect.size.height/2);
    CGContextDrawLayerAtPoint(context, CGPointMake(0, 0), pizzaSliceLayer);
    //    for (int i = 0; i < 1; i++) {
    //        CGContextSaveGState(context);
    //        CGContextTranslateCTM(context, layerSize.width/2, 0);
    //        CGContextRotateCTM(context, i*self.angleRad);
    //        CGContextTranslateCTM(context, -(layerSize.width/2), 0);
    //        CGContextDrawLayerAtPoint(context, CGPointMake(0, 0), pizzaSliceLayer);
    //        CGContextRestoreGState(context);
    //    }
    CGContextRestoreGState(context);
    /**************************END DRAW PIZZA SLICES*****************************/
    
    maskImage = CGBitmapContextCreateImage(context);
    CGImageRef cgimage = [UIImage imageNamed:@"morcheeba-skye"].CGImage;
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, maskImage); 
    CGContextDrawImage(context, rect, cgimage);
    
    [myHandle closeFile];

    NSString *filecontent = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSLog(@"%@", filecontent);
}


#pragma mark - UIControl touch evnets
//- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    //    NSLog(@"begin touch track");
//    //    CGPoint touchPoint = [touch locationInView:self];
//    //    NSValue* closestTrackValue = [self getClosestGridPointToPoint:touchPoint];
//    //    if (closestTrackValue == nil) {
//    //        NSLog(@"Touched outside of the track area");
//    //    } else {
//    //        CGPoint closestTrackPoint = [[self getClosestGridPointToPoint:touchPoint] CGPointValue];
//    //        currentMovingPointIndex_ = [self.dataPoints indexOfObject:closestTrackValue];
//    //        currentMovingPoint_ = closestTrackPoint;
//    //        
//    //    }
//    return YES;    
//}
//- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    //    NSLog(@"continue touch track");
//    //    CGPoint touchPoint = [touch locationInView:self];
//    //    NSValue* touchPointValue = [NSValue valueWithCGPoint:touchPoint];
//    //    [self.dataPoints replaceObjectAtIndex:currentMovingPointIndex_ withObject:touchPointValue];
//    //    [self setNeedsDisplay];
//    
//    
//    return YES; 
//    
//}
//- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    //    CGPoint touchPoint = [touch locationInView:self];
//    //    NSValue* touchPointValue = [NSValue valueWithCGPoint:touchPoint];
//    //    [self.dataPoints replaceObjectAtIndex:currentMovingPointIndex_ withObject:touchPointValue];
//    //    [self setNeedsDisplay];
//    
//    
//    NSLog(@"end touch track");
//    CGPoint touchPoint = [touch locationInView:self];
//    NSValue* closestTrackValue = [self getClosestGridPointToPoint:touchPoint];
//    if (closestTrackValue == nil) {
//        NSLog(@"Touched outside of the track area");
//    } else {
//        CGPoint closestTrackPoint = [[self getClosestGridPointToPoint:touchPoint] CGPointValue];
//        self.thumbCurrentPosition = closestTrackPoint;
//        [self sendActionsForControlEvents:UIControlEventValueChanged];
//        NSLog(@"Closes track point is X:%0.1f Y:%0.1f", closestTrackPoint.x, closestTrackPoint.y);
//    }
//}

#pragma mark - Touch events
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {[super touchesBegan:touches withEvent:event];}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {[super touchesMoved:touches withEvent:event];}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {[super touchesEnded:touches withEvent:event];}




@end