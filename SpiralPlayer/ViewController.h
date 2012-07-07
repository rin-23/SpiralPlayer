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
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController : UIViewController <AVAudioPlayerDelegate, MPMediaPickerControllerDelegate> {
    
    //MPMusicPlayerController* musicPlayer_;
    AVAudioPlayer *audioPlayer;
    SpiralControl* spiralControl_; 
       
    //Spiral Controls
    UISlider* waveFormHeightSlider_;
    UISlider* radiusStepSlider_;
    UISlider* sampleRateRatioSlider_;
    UISlider *seekControl;
    UIButton* playButton;
    UIButton* songChooseButton_;
    UIActivityIndicatorView* waveformSpinner_;
    UILabel* heightLabel_;
}


-(void) playButtonClicked;

@end
