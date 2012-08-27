//
//  PlayListView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayListView.h"


@implementation PlayListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dimension = frame.size.width/5;
        
    }
    return self;
}

-(void)addSong:(SegmentView*)seg {
    if (numOfItemsChosen > 24) {
        return;
    }
    
    UIImage* image = seg.object.image;
    
    
    UIImageView* newimage = [[UIImageView alloc] initWithImage:image];
    
    int level = numOfItemsChosen / 5;
    
    newimage.frame = CGRectMake(dimension*(numOfItemsChosen%5), dimension*level, dimension, dimension);
    newimage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:newimage];
    numOfItemsChosen += 1;   

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
