//
//  LineViewController.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurveControl.h"
#import "WaveAudioPlayer.h"
@interface LineViewController : UIViewController {
    WaveAudioPlayer* audioPlayer_;
    CurveControl* curveControl_;
    UIView* view;
    
}


@end
