//
//  LineViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PolyLineViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation PolyLineViewController

- (id) init { 
    self = [super init];
    if (self) {
        self.title = @"5";

       [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
                
        audioPlayer_ = [[WaveAudioPlayer alloc] init];
        NSURL* audioUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hendrix" ofType:@"mp3"]];
        [audioPlayer_ loadNextAudioAsset:audioUrl];
        [audioPlayer_.player setNumberOfLoops:10];

        CGSize polyLineSize = CGSizeMake(730/2, 730/2);
        
        curveControl_ = [[PolyLineControl alloc] initWithFrame:CGRectMake(0, 0, polyLineSize.width, polyLineSize.height) dataPointsFile:@"segmentData" ofType:@"txt"];     
        curveControl_.tracklength = [audioPlayer_.player duration];
        NSLog(@"Track Duration: %f", curveControl_.tracklength);
        [curveControl_ addTarget:self action:@selector(curveValueChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:curveControl_];
        [curveControl_ release];
        
//        PolyLineControl* polyLineControl = [[PolyLineControl alloc] initWithFrame:CGRectMake(0, 0, polyLineSize.width, polyLineSize.height) dataPointsFile:@"segmentData" ofType:@"txt"];
//        [self.view addSubview:polyLineControl];
//        [polyLineControl release];
//        
        CATransform3D moveToCenter = CATransform3DMakeTranslation(768/2 - polyLineSize.width/2, 1024/2, 0);
        CATransform3D rotate = CATransform3DRotate(moveToCenter, 30*(M_PI/180), 0, 0, 1);
                
        curveControl_.layer.transform = moveToCenter;
//        
//        polyLineControl.layer.anchorPoint = CGPointMake(0.5, 0.0);
//        polyLineControl.layer.transform = rotate;
//        [polyLineControl correctLayerPosition];
        
       //[audioPlayer_.player play];
    }
    return self;
}



- (void) updateProgressBar {
    curveControl_.value = audioPlayer_.player.currentTime;    
}

- (void) curveValueChanged { 
    audioPlayer_.player.currentTime = curveControl_.value;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
