//
//  ViewController.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController <AVAudioPlayerDelegate> {
    AVAudioPlayer *audioPlayer;
    UISlider *seekControl;
    UIButton* playButton;
}


-(void) playButtonClicked;
@end
