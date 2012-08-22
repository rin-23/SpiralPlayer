//
//  SegmentView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView <UIGestureRecognizerDelegate>{
    
}

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIImageView* signImageView;
@property (nonatomic, assign) int index;

@end
