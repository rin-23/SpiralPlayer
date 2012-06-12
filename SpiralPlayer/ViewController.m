//
//  ViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

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
    
	// Do any additional setup after loading the view, typically from a nib.
    
    //Play Button
    playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake(40, 65, 60, 30);
    [playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.view addSubview:playButton];
    
    //Linear audio control
    seekControl = [[UISlider alloc] initWithFrame:CGRectMake((768 - 400)/2, 70, 400, 20)];
    seekControl.minimumValue = 0;
    seekControl.maximumValue = 1;
    [seekControl addTarget:self action:@selector(seekToTime) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview: seekControl];
    [seekControl release];
    
    //Load audio file
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ComeAway" ofType:@"mp3"]];
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
    spiralControl_.maximumValue = audioPlayer.duration;
    [spiralControl_ addTarget:self action:@selector(spiralValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:spiralControl_];
    [spiralControl_ release];
}

/*
 * Callback from SpiralControl when we change the needle postion
 */
-(void) spiralValueChanged {
    audioPlayer.currentTime = spiralControl_.value;
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
    NSLog(@"%f", seekControl.value);
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
