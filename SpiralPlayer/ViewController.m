//
//  ViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#include <AudioToolbox/AudioToolbox.h>

#define kInputFileLocation	CFSTR("ComeAway.mp3")

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    
    //Load audio file
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ChameleonComedian" ofType:@"mp3"]];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url  error:&error];
    if (error) {
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    } 
    
    //Spiral audio control
    spiralControl_ = [[SpiralControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    //spiralControl_ = [[SpiralControl alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
    spiralControl_.maximumValue = audioPlayer.duration;
    [spiralControl_ addTarget:self action:@selector(spiralValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:spiralControl_];
    [spiralControl_ drawSpiralForAsset:songAsset]; //draw the spiral
    [spiralControl_ release];
    
    //Play Button
    playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake(40, 65, 60, 30);
    //playButton.frame = CGRectMake(40, 20, 60, 30);
    [playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.view addSubview:playButton];
    
    //Linear audio control
    seekControl = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 20, 400, 15)];
    //seekControl = [[UISlider alloc] initWithFrame:CGRectMake((360 - 120)/2, 25, 180, 20)];
    seekControl.minimumValue = 0;
    seekControl.maximumValue = 1;
    [seekControl addTarget:self action:@selector(seekToTime) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview: seekControl];
    [seekControl release];
    
    //Height of the waveform control
    waveFormHeightSlider_ = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 45, 400, 15)];
    waveFormHeightSlider_.maximumValue = 70;
    waveFormHeightSlider_.minimumValue = 1;
    waveFormHeightSlider_.value = 30;
    [waveFormHeightSlider_ addTarget:self action:@selector(changeWaveFormHeight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waveFormHeightSlider_];
    [waveFormHeightSlider_ release];
    
    
    //Height of the waveform control
    radiusStepSlider_ = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 70, 400, 15)];
    radiusStepSlider_.maximumValue = 70;
    radiusStepSlider_.minimumValue = 20;
    radiusStepSlider_.value = 50;
    [radiusStepSlider_ addTarget:self action:@selector(changeRadiusStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:radiusStepSlider_];
    [radiusStepSlider_ release];

    
    
}

// waveFormHeightSlider selector
- (void) changeWaveFormHeight {
    spiralControl_.waveFormHeight = waveFormHeightSlider_.value;   
}

// radiusStepSlider selector
- (void) changeRadiusStep {
    spiralControl_.radiusStep = radiusStepSlider_.value;   
}

/*
 * Callback from SpiralControl when we change the needle postion
 */
-(void) spiralValueChanged {
    [audioPlayer setCurrentTime:spiralControl_.value];
}

-(void) playButtonClicked {
    if (audioPlayer.playing) {
        [audioPlayer pause];
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [audioPlayer play];
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
}

-(void) updateProgressBar{
    seekControl.value = (float)audioPlayer.currentTime/(float)audioPlayer.duration;
    spiralControl_.value = audioPlayer.currentTime;
}

-(void) seekToTime{
    //NSLog(@"%f", seekControl.value);
    audioPlayer.currentTime = audioPlayer.duration * seekControl.value;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [audioPlayer play];
    [seekControl setValue:0];
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}




@end
