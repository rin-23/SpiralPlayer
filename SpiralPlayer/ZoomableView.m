#import "ZoomableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZoomableView


// Initialize the layer by setting
// the levelsOfDetailBias of bias and levelsOfDetail
// of the tiled layer
-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            centerX_ = rect.size.width/2; // x-coordinate of the center of the spiral
            centerY_ = rect.size.height/2; // y-coordinate of the center of the spiral 
        } else {
            centerX_ = 320/2;
            centerY_ = 480/2 + 30; 
        }        
        maxArclength_ = 6000;
        radiusStep_ = 2;

    }
    return self;
}

// Implement -drawRect: so that the UIView class works correctly
// Real drawing work is done in -drawLayer:inContext
-(void)drawRect:(CGRect)rect {
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
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    int level = 0;
    double currentArc = 0.0;
    int j = 0;    
    
    CGContextMoveToPoint(context, newX, newY);
    for (int i = 0; i <= maxArclength_; i += 1) {
        j = i;
        level = 0;
        while (j >= 0) {
            level += 1;
            currentArc = j;
            j = j - 2*M_PI*(level*radiusStep_); 
        }   
        
        angle = currentArc/(level*radiusStep_) + 2*M_PI*(level-1); //total angle
        newX = (radiusStep_*angle*cos(angle))/(2*M_PI) + centerX_;
        newY = (radiusStep_*angle*sin(angle))/(2*M_PI) + centerY_;
           
        CGContextAddLineToPoint(context, newX, newY);
    } 
    CGContextStrokePath(context);
    
    maskImage = CGBitmapContextCreateImage(context);
    CGContextRestoreGState(context);
    /****************************END CREATE A MASK********************************/
    
//    CGImageRef cgimage = [UIImage imageNamed:@"morcheeba-skye"].CGImage;
    
    CGImageRef cgimage = [UIImage imageNamed:@"lana"].CGImage;
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, maskImage); 
    CGContextDrawImage(context, rect, cgimage);
    CGImageRelease(maskImage);
}

@end
