//
//  SeekControl.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ContainerView.h"

@interface LyricsControl : UIControl {
    int numOfSectionsVisible_;
    int numOfSectionsTotal_;
    double anglePerSector_;
    
    
    double beginTouchAngleRad_;
    int currentLevel_;
    int currentQuarter_;
    
    double current_rad; 
    double total_rad;  
    
    //Window indexes and sizes    
    double windowAngleSpanRad_;
    int windowStartIndex_;
    int windowEndIndex_;
    int windowSize_;
    
    BOOL continueTouch_;


    
}
@property (nonatomic, assign) CGAffineTransform startTransform;
@property (nonatomic, retain) NSMutableArray* slidingWindow;
//@property (nonatomic, retain) NSMutableArray* segmentObjectsArray;
@property (nonatomic, retain) NSMutableArray* audioFilesArray;
@property (nonatomic, retain) ContainerView* container;
@property (nonatomic, retain) NSMutableArray* letters;
@property (nonatomic, retain) NSMutableDictionary* karaokeData;



@end
