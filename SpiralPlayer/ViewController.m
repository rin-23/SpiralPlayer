//
//  ViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#include <AudioToolbox/AudioToolbox.h>

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
    
    // Spiral audio control
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        spiralControl_ = [[SpiralControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    } else {
        spiralControl_ = [[SpiralControl alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
    }
    spiralControl_.maximumValue = audioPlayer.duration;
    [spiralControl_ addTarget:self action:@selector(spiralValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:spiralControl_];
    //[spiralControl_ convertToCAF:songAsset];
    [spiralControl_ drawSpiralForAsset:songAsset]; //draw the spiral 
    [spiralControl_ release];
    
    // Play Button
    playButton= [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(10, 10, 44, 44);
    playButton.selected = NO;
    [playButton setImage:[UIImage imageNamed:@"play1-150x150.png"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"pause1-150x150"] forState:UIControlStateSelected];
    [playButton setImage:[UIImage imageNamed:@"play1-150x150.png"] forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
     
    // Choose Song Button
    songChooseButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    songChooseButton_.frame = CGRectMake(80, 10, 44, 29);
    [songChooseButton_ setImage:[UIImage imageNamed:@"choose_song_btn.png"] forState:UIControlStateNormal];   
    [songChooseButton_ addTarget:self action:@selector(chooseSongClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:songChooseButton_];
    
    
    // Linear audio control
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        seekControl = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 20, 400, 15)];
    } else {
        seekControl = [[UISlider alloc] initWithFrame:CGRectMake((360 - 120)/2, 20, 180, 15)];
    }
    seekControl.minimumValue = 0;
    seekControl.maximumValue = 1;
    seekControl.hidden = YES;
    [seekControl addTarget:self action:@selector(seekToTime) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview: seekControl];
    [seekControl release];
    
    //Height of the waveform control
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        waveFormHeightSlider_ = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 45, 400, 15)]; 
    } else {
        waveFormHeightSlider_ = [[UISlider alloc] initWithFrame:CGRectMake(80, 45, 180, 15)]; 
    }
    waveFormHeightSlider_.maximumValue = 70;
    waveFormHeightSlider_.minimumValue = 1;
    waveFormHeightSlider_.value = 30;
    [waveFormHeightSlider_ addTarget:self action:@selector(changeWaveFormHeight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waveFormHeightSlider_];
    [waveFormHeightSlider_ release];
    
    
    heightLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 300, 15)];
    heightLabel_.backgroundColor = [UIColor clearColor];
    heightLabel_.userInteractionEnabled = NO;
    heightLabel_.text = @"Scale Wave Form Height";
    [self.view addSubview:heightLabel_];
    [heightLabel_ release];
            
    UILabel* msg = [[UILabel alloc] initWithFrame:CGRectMake(75, 70, 300, 15)];
    msg.backgroundColor = [UIColor clearColor];
    msg.userInteractionEnabled = NO;
    msg.text = @"Use zoom and rotation gestures";
    [self.view addSubview:msg];
    [msg release];
    
    
    //Radius of the spiral step control
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        radiusStepSlider_ = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 70, 400, 15)]; 
    } else {
        radiusStepSlider_ = [[UISlider alloc] initWithFrame:CGRectMake((360 - 120)/2, 70, 180, 15)];
    }
    radiusStepSlider_.maximumValue = kMAX_SPIRAL_STEP_RADIUS;
    radiusStepSlider_.minimumValue = kMIN_SPIRAL_STEP_RADIUS;
    radiusStepSlider_.value = 50;
    radiusStepSlider_.hidden = YES;
    [radiusStepSlider_ addTarget:self action:@selector(changeRadiusStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:radiusStepSlider_];
    [radiusStepSlider_ release];

    //Radius of the spiral step control
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        sampleRateRatioSlider_ = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 95, 400, 15)];
    } else {
        sampleRateRatioSlider_ = [[UISlider alloc] initWithFrame:CGRectMake((360 - 120)/2, 95, 180, 15)];        
    }
    sampleRateRatioSlider_.maximumValue = kMAX_SAMPLE_RATE_RATIO;
    sampleRateRatioSlider_.minimumValue = kMIN_SAMPLE_RATE_RATIO;
    sampleRateRatioSlider_.value = 1;
    sampleRateRatioSlider_.hidden = YES;
    [sampleRateRatioSlider_ addTarget:self action:@selector(sampleRateRatioChanged) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sampleRateRatioSlider_];
    [sampleRateRatioSlider_ release];
    
    
    waveformSpinner_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    waveformSpinner_.frame = CGRectMake(0, 0, 30, 30);
    waveformSpinner_.center = CGPointMake(320/2, 480/2);
    [self.view addSubview:waveformSpinner_];
    [waveformSpinner_ release];
}

#pragma mark - MPMediaPickerControllerDelegate Methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    [self dismissModalViewControllerAnimated:YES];
	if ([mediaItemCollection count] < 1) {
		return;
	}
	
	// Populate meatadata
    MPMediaItem* song = [[mediaItemCollection items] objectAtIndex:0];
    NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    [waveformSpinner_ startAnimating];

    [audioPlayer stop];
    playButton.selected = NO;
    //[self loadNewAudio:assetURL];
    [self performSelectorInBackground:@selector(drawNewSpiral:) withObject:songAsset];

    
}

-(void) drawNewSpiral:(AVURLAsset*) songAsset {
    [spiralControl_ drawSpiralForAsset:songAsset];
    [waveformSpinner_ stopAnimating];    
}

-(void) loadNewAudio:(NSURL*) assetURL {
    if (audioPlayer!=nil) {
        [audioPlayer release];    
    }
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error:&error];
    if (error) {
        NSLog(@"Error in audioPlayer: %@", 
        [error localizedDescription]);
    } else {

        audioPlayer.delegate = self;
        
        [audioPlayer prepareToPlay];
        [audioPlayer play]; 
    }
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker{
    [self dismissModalViewControllerAnimated:YES];
}

// waveFormHeightSlider selector
- (void) changeWaveFormHeight {
    spiralControl_.waveFormHeight = waveFormHeightSlider_.value;   
}

// radiusStepSlider selector
- (void) changeRadiusStep {
    spiralControl_.radiusStep = radiusStepSlider_.value;   
}

// sampleRateRatioChanged selector
- (void) sampleRateRatioChanged {
    int rounded_value = ceil(sampleRateRatioSlider_.value);
    NSLog(@"SAMPLE RATE CHOSEN %i", rounded_value);
    sampleRateRatioSlider_.value = rounded_value;
    spiralControl_.samplesPerPixelRatio = rounded_value;
}

/*
 * Callback from SpiralControl when we change the needle postion
 */
-(void) spiralValueChanged {
    [audioPlayer setCurrentTime:spiralControl_.value];
}

-(void) chooseSongClicked {
    MPMediaPickerController* picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    picker.prompt = @"Choose song to process";
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void) playButtonClicked {
    
    if (audioPlayer.playing) {
        [audioPlayer pause];
        playButton.selected = NO;
    } else {
        [audioPlayer play];
        playButton.selected = YES;
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
