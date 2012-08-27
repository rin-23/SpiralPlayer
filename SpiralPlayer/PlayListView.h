//
//  PlayListView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentView.h"
#import "SegmentObject.h"
@interface PlayListView : UIView {
    int numOfItemsChosen;
    int dimension;
}
-(void)addSong:(SegmentView*)seg;
@end
