#import "ViewController.h"
#include <AudioToolbox/AudioToolbox.h>

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    
    audioPlayer = [[WaveAudioPlayer alloc] init];
    audioPlayer.delegate = self;

    // Spiral audio control
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        spiralControl_ = [[SpiralControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    } else {
        spiralControl_ = [[SpiralControl alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
    }
    [spiralControl_ addTarget:self action:@selector(spiralValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:spiralControl_];
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
    songChooseButton_.frame = CGRectMake(65, 10, 44, 44);
    [songChooseButton_ setImage:[UIImage imageNamed:@"eject.gif"] forState:UIControlStateNormal];   
    [songChooseButton_ addTarget:self action:@selector(chooseSongClicked) forControlEvents:UIControlEventTouchUpInside];
    songChooseButton_.hidden = NO;
    [self.view addSubview:songChooseButton_];
        
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
        waveFormHeightSlider_ = [[UISlider alloc] initWithFrame:CGRectMake(songChooseButton_.frame.origin.x+songChooseButton_.frame.size.width + 10, 22, 180, 15)]; 
    }
    waveFormHeightSlider_.maximumValue = 70;
    waveFormHeightSlider_.minimumValue = 1;
    waveFormHeightSlider_.value = 30;
    [waveFormHeightSlider_ addTarget:self action:@selector(changeWaveFormHeight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waveFormHeightSlider_];
    [waveFormHeightSlider_ release];
 
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        waveformSpinner_.center = CGPointMake(768/2, 1024/2);
    } else {
        waveformSpinner_.center = CGPointMake(320/2, 480/2);
    }
    [self.view addSubview:waveformSpinner_];
    [waveformSpinner_ release];
}

#pragma mark - MPMediaPickerControllerDelegate Methods

- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    [self dismissModalViewControllerAnimated:YES];
	if ([mediaItemCollection count] < 1) { return; }
	
    spiralControl_.dataReady = NO;
    spiralControl_.thumb.hidden = YES;
    [spiralControl_ setNeedsDisplay];
    
    MPMediaItem* mediaItem = [[mediaItemCollection items] objectAtIndex:0];
    [waveformSpinner_ startAnimating];
    [audioPlayer loadNextMediaItem:mediaItem];
          
}

- (void) finishedConvertingToPCM {
    spiralControl_.dataReady = NO;
    spiralControl_.thumb.hidden = YES;
    [spiralControl_ setNeedsDisplay];
    NSURL* fannyurl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Zaz – Le Long De La Route" ofType:@"mp3"]];
    //[spiralControl_ drawSpiralForMediaItem:audioPlayer.mediaItem];
    [spiralControl_ drawSpiralforAudioAsset:fannyurl];
    [waveformSpinner_ stopAnimating];
    spiralControl_.maximumValue = audioPlayer.player.duration;
    playButton.selected = YES;
    [audioPlayer.player play];
    
}

-(void) waveAudioPlayerDidFinishPlaying {
    playButton.selected = NO;
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
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
    [audioPlayer.player setCurrentTime:spiralControl_.value];
}

-(void) chooseSongClicked {
    
    MPMediaPickerController* picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    picker.prompt = @"Choose song to process";
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void) playButtonClicked { 
    if (audioPlayer.player == nil) return;
    
    if (audioPlayer.player.playing) {
        [audioPlayer.player pause];
        playButton.selected = NO;
    } else {
        [audioPlayer.player play];
        playButton.selected = YES;
    }
}

-(void) updateProgressBar {
    seekControl.value = (float)audioPlayer.player.currentTime/(float)audioPlayer.player.duration;
    spiralControl_.value = audioPlayer.player.currentTime;
}

-(void) seekToTime {
    //NSLog(@"%f", seekControl.value);
    audioPlayer.player.currentTime = audioPlayer.player.duration * seekControl.value;
}

//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    [audioPlayer.player play];
//    [seekControl setValue:0];
//}


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
     return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}




@end
