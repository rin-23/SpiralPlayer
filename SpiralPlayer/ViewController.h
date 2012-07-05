//
//  ViewController.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SpiralControl.h"

@interface ViewController : UIViewController <AVAudioPlayerDelegate> {
    AVAudioPlayer *audioPlayer;
    SpiralControl* spiralControl_; 
       
    //Spiral Controls
    UISlider* waveFormHeightSlider_;
    UISlider* radiusStepSlider_;
    UISlider *seekControl;
    UIButton* playButton;
}


-(void) playButtonClicked;

@end
