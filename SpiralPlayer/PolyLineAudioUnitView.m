//
//  PolyLineAudioUnitView.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PolyLineAudioUnitView.h"

@implementation PolyLineAudioUnitView

@synthesize control = control_, audioPlayer = audioPlayer_;

- (id)initWithFrame:(CGRect)frame andAudio:(NSString*) audioFile
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        
        
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];

        self.audioPlayer = [[WaveAudioPlayer alloc] init];
        NSURL* audioUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audioFile ofType:@"mp3"]];
        [self.audioPlayer loadNextAudioAsset:audioUrl];
        [self.audioPlayer.player setNumberOfLoops:10];
        
        CGSize polyLineSize = CGSizeMake(250, 768/2);
        self.control = [[PolyLineControl alloc] initSineWaveWithFrame:CGRectMake(0, 0, polyLineSize.width, polyLineSize.height)]; 
        self.control.tracklength = [self.audioPlayer.player duration];
        [self.control addTarget:self action:@selector(curveValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.control];
        
        
        moveButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        moveButton_.frame = CGRectMake(0, self.control.frame.origin.y + self.control.frame.size.height+10, 55, 55);
        [moveButton_ setImage:[UIImage imageNamed:@"moveButton"] forState:UIControlStateNormal];
        moveButton_.opaque = YES;
        [moveButton_ addTarget:self action:@selector(dragMoveBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
        [moveButton_ addTarget:self action:@selector(dragMoveContinue:withEvent:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
        [moveButton_ addTarget:self action:@selector(dragMoveEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [self addSubview:moveButton_];
        
        playButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton_.frame = CGRectMake(moveButton_.frame.origin.x+ moveButton_.frame.size.width + 20, self.control.frame.origin.y + self.control.frame.size.height+10, 55, 55);
        playButton_.opaque = YES;
        [playButton_ addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [playButton_ setImage:[UIImage imageNamed:@"play1-150x150.png"] forState:UIControlStateNormal];
        [playButton_ setImage:[UIImage imageNamed:@"pause1-150x150"] forState:UIControlStateSelected];
        [playButton_ setImage:[UIImage imageNamed:@"play1-150x150.png"] forState:UIControlStateHighlighted];
        [self addSubview:playButton_];
        
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotaionGesture:)];
        [self addGestureRecognizer:rotationGesture];
        [rotationGesture release];
  
    }
    return self;
}


#pragma mark - GESTURE RECOGNIZER
- (void) handleRotaionGesture:(UIRotationGestureRecognizer*)sender {
        NSLog(@"Rotation");
    
        CGAffineTransform tr = CGAffineTransformMakeScale(0.3, 0.3);
        CGAffineTransform tr2 = CGAffineTransformRotate(tr, sender.rotation);
   //     CGAffineTransform myTransform = CGAffineTransformRotate(, sender.rotation);  
        //CGAffineTransform myTransform = CGAffineTransformMakeRotation(sender.rotation);
        self.transform = tr2;

}


-(void) playButtonClicked { 
    if (audioPlayer_.player == nil) return;
    
    if (audioPlayer_.player.playing) {
        [audioPlayer_.player pause];
        playButton_.selected = NO;
    } else {
        [audioPlayer_.player play];
        playButton_.selected = YES;
    }
}


#pragma mark - MOVE BUTTON TOUCH EVEN HANDLERS
- (void) dragMoveBegan:(UIControl*)control withEvent:(UIEvent*)event {
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self.superview];
    CGRect frame = self.frame;
    frame.origin = CGPointMake(touchPoint.x, touchPoint.y - self.frame.size.height);
    self.frame = frame;
    // [self correctLayerPosition];
}

- (void) dragMoveContinue:(UIControl*)control withEvent:(UIEvent*)event{
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self.superview];
    CGRect frame = self.frame;
    frame.origin = CGPointMake(touchPoint.x, touchPoint.y - self.frame.size.height);
    self.frame = frame;

    
}

- (void) dragMoveEnded:(UIControl*)control withEvent:(UIEvent*)event{
    CGPoint touchPoint =[[[event allTouches] anyObject] locationInView:self.superview];
    CGRect frame = self.frame;
    frame.origin = CGPointMake(touchPoint.x, touchPoint.y - self.frame.size.height);
    self.frame = frame;

    
}

- (void) updateProgressBar {
    self.control.value = audioPlayer_.player.currentTime;    
}

- (void) curveValueChanged { 
    self.audioPlayer.player.currentTime = self.control.value;
}

- (void)correctLayerPosition {
	CGPoint position = self.layer.position;
	CGPoint anchorPoint = self.layer.anchorPoint;
	CGRect bounds = self.bounds;
	// 0.5, 0.5 is the default anchorPoint; calculate the difference
	// and multiply by the bounds of the view
	position.x = (0.5 * bounds.size.width) + (anchorPoint.x - 0.5) * bounds.size.width;
	position.y = (0.5 * bounds.size.height) + (anchorPoint.y - 0.5) * bounds.size.height;
	self.layer.position = position;
}


@end
