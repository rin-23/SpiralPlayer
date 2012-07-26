//
//  LineViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LineViewController.h"

@implementation LineViewController

- (id) init { 
    self = [super init];
    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
                
        audioPlayer_ = [[WaveAudioPlayer alloc] init];
        NSURL* audioUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Jimmy Hendrix  – Voodoo Child" ofType:@"mp3"]];
        [audioPlayer_ loadNextAudioAsset:audioUrl];
        [audioPlayer_.player setNumberOfLoops:10];
        
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
//        imageView.image = [UIImage imageNamed:@"pinkfloyd.jpg"];
//        [self.view addSubview:imageView];
//        [imageView release];
    
        curveControl_ = [[CurveControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        curveControl_.tracklength = [audioPlayer_.player duration];
        // curveControl_.tracklength =300;
        NSLog(@"Track Duration: %f", curveControl_.tracklength);
        [curveControl_ addTarget:self action:@selector(curveValueChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:curveControl_];
        [curveControl_ release];
       
        [audioPlayer_.player play];
    }
    return self;
}

- (void) updateProgressBar {
    curveControl_.value = audioPlayer_.player.currentTime;    
}

- (void) curveValueChanged { 
    audioPlayer_.player.currentTime = curveControl_.value;
}





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
