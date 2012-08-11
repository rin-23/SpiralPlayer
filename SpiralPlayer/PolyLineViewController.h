//
//  LineViewController.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolyLineControl.h"
#import "WaveAudioPlayer.h"
@interface PolyLineViewController : UIViewController {
    WaveAudioPlayer* audioPlayer_;
    PolyLineControl* curveControl_;
    UIView* view;    
}


@end
