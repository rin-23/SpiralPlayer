#import "SineWaveView.h"
#include <math.h>
@implementation SineWaveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextClearRect(ctx, rect);
    CGContextBeginPath(ctx);
    CGColorRef leftcolor = [[UIColor whiteColor] CGColor]; 
    CGColorRef rightcolor = [[UIColor colorWithRed:0.7 green:0 blue:0 alpha:0] CGColor];
    CGContextRotateCTM(ctx, 10.0 * (M_PI/180));  
    CGContextSetLineWidth(ctx, 3);

    double x;
    int old_y = rect.origin.y;
    double old_x = (((double)old_y/(double)rect.size.height) * (rect.size.width/2) * sin(((30*old_y) % 360) * M_PI/180)) + rect.size.width/2;
    
    int colorIndex = 0;
    for (double y = rect.origin.y; y < rect.size.height/2; y += 0.1) {
        x = ((y/(double)rect.size.height) * (rect.size.width/2) * sin(fmod(10*y, 360.0) * M_PI/180)) + rect.size.width/2;

        CGContextMoveToPoint(ctx, old_x, old_y);
        
        if (colorIndex%2 == 0) { CGContextSetStrokeColorWithColor(ctx, leftcolor); } 
        else { CGContextSetStrokeColorWithColor(ctx, rightcolor); }

        CGContextAddLineToPoint(ctx, x, y);
        CGContextStrokePath(ctx);
        
        old_x = x;
        old_y = y;
        colorIndex ++;
    }
    
}

@end
