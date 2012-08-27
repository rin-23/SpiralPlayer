//
//  SegmentView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentObject.h"
@interface SegmentView : UIButton <UIGestureRecognizerDelegate>{
    UIImage* image_;
    SegmentObject* object_;    
}

@property (nonatomic, readonly) int index;
@property (nonatomic, assign) CGColorRef bgColor;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) SegmentObject* object;

- (NSComparisonResult) compareIndexes:(SegmentView*)otherEvenet;

@end
