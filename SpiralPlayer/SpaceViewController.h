//
//  SpaceViewController.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomableView.h"
#import "PolyLineAudioUnitView.h"
#import <QuartzCore/QuartzCore.h>
@interface SpaceViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView* scrollView_;
    //ZoomableView* zoomableView_;
    UIView* mainView_;
    NSMutableArray* array_;
   
}

@end
