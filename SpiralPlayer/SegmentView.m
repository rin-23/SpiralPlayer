//
//  SegmentView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentView.h"

@implementation SegmentView 

@synthesize index, bgColor, image = image_, object = object_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bgColor = [UIColor whiteColor].CGColor;  
        self.backgroundColor = [UIColor clearColor];
                
        dataPoints_ = [[NSMutableArray alloc] init];
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        [self addGestureRecognizer:recognizer];
        [recognizer release];
    }
    return self;
}

- (int) index {
    return self.object.index;
}

- (double) toRad:(int) deg { return deg*(M_PI/180.0); }
- (int) toDeg:(double) rad { return (int)(rad*(180.0/M_PI) + 0.5); }

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"Gesture 1");
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Gesture 2");
    return YES;
}

- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe received 2.");
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    if (maskImage == NULL) {
        
        CGContextSaveGState(context);
        //Fill Background
        CGContextSetRGBFillColor (context, 0, 0, 0, 0);
        CGContextFillRect(context, rect);
        
        //Start Drawing Segment
        CGContextBeginPath (context);               
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);  
        CGContextSetLineWidth(context, 1);
        
        CGPoint pT = CGPointMake(rect.size.width/2, 0);
        CGPoint pL = CGPointMake(0, rect.size.height);
        CGPoint pR = CGPointMake(rect.size.width, rect.size.height);
        CGPoint vectorL = CGPointMake(pL.x - pT.x, pL.y- pT.y);
        CGPoint vectorR = CGPointMake(pR.x - pT.x, pR.y - pT.y);
        CGPoint halfwayL = CGPointMake(pT.x + 0.5*vectorL.x, pT.y + 0.5*vectorL.y);
        CGPoint halfwayR = CGPointMake(pT.x + 0.5*vectorR.x, pT.y + 0.5*vectorR.y);
        
        CGContextMoveToPoint(context, halfwayR.x, halfwayR.y);
        CGContextAddLineToPoint(context, pR.x - 0.075*vectorR.x, pR.y - 0.075*vectorR.y);
        
        CGFloat radius = rect.size.height;
        CGFloat radius2 = sqrt(pow(halfwayR.x - pT.x, 2) + pow(halfwayR.y - pT.y, 2));
        
        double totalAngle = 45.0 * (M_PI/180.0);
        CGContextAddArc(context, pT.x, pT.y, radius-2, (M_PI - totalAngle)/2, (M_PI - totalAngle)/2 + totalAngle, 0);
        CGContextMoveToPoint(context, pL.x - 0.075*vectorL.x, pL.y - 0.075*vectorL.y);
        CGContextAddLineToPoint(context, halfwayL.x, halfwayL.y);
        CGContextAddArc(context, pT.x, pT.y, radius2, (M_PI - totalAngle)/2 + totalAngle, (M_PI - totalAngle)/2, 1);
        
        //CGContextAddLineToPoint(context, halfwayR.x, halfwayR.y);
        //CGContextSetRGBFillColor (context, 1, 1, 1, 1);
        //CGContextSetFillColorWithColor(context, self.bgColor);
        //CGContextFillPath(context);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
            
        //Draw Sine Wave
//        CGContextSaveGState(context);
//            
//            //get the documents directory:
//    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //    NSString *fileName = [NSString stringWithFormat:@"%@/newfile.txt", documentsDirectory];
//    //    NSString *content = @"";
//    //    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
//    //    NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
//
//        CGSize layerSize = rect.size;
//        
//        CGLayerRef pizzaSliceLayer = CGLayerCreateWithContext(context, layerSize, NULL); 
//        CGContextRef pizzaSliceLayerContext = CGLayerGetContext(pizzaSliceLayer);
//        
//        CGContextSetRGBFillColor (pizzaSliceLayerContext, 0, 0, 0, 0);
//        CGContextFillRect(pizzaSliceLayerContext, CGRectMake(0, 0, layerSize.width, layerSize.height));
//        
//        int level = 30;
//        CGContextBeginPath(pizzaSliceLayerContext);
//        CGContextSetRGBStrokeColor(pizzaSliceLayerContext, 1, 1, 1, 1);
//        CGContextSetLineWidth(pizzaSliceLayerContext, 1);
//        double x;
//        int old_y = rect.origin.y + layerSize.height/2 + 20;
//        double old_x = (((double)old_y/(double)layerSize.height) * (layerSize.width/2) * sin(((level*old_y) % 360) * M_PI/180)) + layerSize.width/2;
//        [dataPoints_ addObject:[NSValue valueWithCGPoint:CGPointMake((int)(old_x +0.5), (int)old_y)]];
//        
//    //    [myHandle seekToEndOfFile];
//    //    NSString* stringCoordinates = [NSString stringWithFormat:@"%i %i\n", (int)(old_x +0.5),(int)(old_y + 0.5)];
//    //    [myHandle writeData:  [stringCoordinates dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        for (double y = rect.origin.y + layerSize.height/2 + 20; y < layerSize.height-28; y += 1) {
//            x = ((y/(double)layerSize.height) * (layerSize.width/2) * sin(fmod(level*y, 360.0) * M_PI/180)) + layerSize.width/2;
//            
//            if (![dataPoints_ containsObject:[NSValue valueWithCGPoint:CGPointMake((int)(x+0.5), (int)(y+0.5))]]) {
//                [dataPoints_ addObject:[NSValue valueWithCGPoint:CGPointMake((int)(x+0.5), (int)(y+0.5))]];
//    //            [myHandle seekToEndOfFile];
//    //            NSString* stringCoordinates = [NSString stringWithFormat:@"%i %i\n", (int)(x+0.5),(int)(y+0.5)];
//    //            [myHandle writeData: [stringCoordinates dataUsingEncoding:NSUTF8StringEncoding]];
//                CGContextMoveToPoint(pizzaSliceLayerContext, old_x, old_y);
//                CGContextAddLineToPoint(pizzaSliceLayerContext, x, y);
//                CGContextStrokePath(pizzaSliceLayerContext);
//                
//                old_x = x; 
//                old_y = y;
//            }
//        }
//            
//            
//    //        [myHandle closeFile];
//    //        
//    //        NSString *filecontent = [[NSString alloc] initWithContentsOfFile:fileName
//    //                                                            usedEncoding:nil
//    //                                                                   error:nil];
//    //        NSLog(@"%@", filecontent);
//    //        NSLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
//
//            
//        CGContextDrawLayerAtPoint(context, CGPointMake(0, 0), pizzaSliceLayer);
//        CGContextRestoreGState(context);
        
      
        maskImage = CGBitmapContextCreateImage(context);
        //CGImageRetain(maskImage);    
    }
    
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);   
    CGContextClipToMask(context, rect, maskImage); 
    CGContextDrawImage(context, rect, self.object.image.CGImage);
    //CGImageRelease(maskImage);

}


- (NSComparisonResult) compareIndexes:(SegmentView*)otherEvenet {
    if (self.index < otherEvenet.index) {
        return NSOrderedAscending;
    } else if (self.index> otherEvenet.index) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}



- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Segment View touch began");
    [self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Segment View touch moved");
    [self.superview touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    NSLog(@"Segment View touch ended");
    [self.superview  touchesEnded:touches withEvent:event];
}



@end
