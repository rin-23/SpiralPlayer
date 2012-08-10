//
//  SpaceViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpaceViewController.h"

@implementation SpaceViewController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, 768, 1024);
       
    array_ = [[NSMutableArray alloc] initWithCapacity:20];
    
    scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    scrollView_.contentSize = CGSizeMake(2000, 2000);
    scrollView_.delegate = self;
    scrollView_.bounces = NO;
    scrollView_.minimumZoomScale=1;
    scrollView_.maximumZoomScale=10;
    [self.view addSubview:scrollView_];
    [scrollView_ release];
    
    mainView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    mainView_.opaque = YES;
    mainView_.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [scrollView_ addSubview:mainView_];
    [mainView_ release];
    
    
    
    for (int i = 0; i<4;i++) {
        ZoomableView* zoomableView_ = [[ZoomableView alloc] initWithFrame:CGRectMake(190*i + 1*i + 1, 0, 190, 190)];
        [array_ addObject:zoomableView_];
        [mainView_ addSubview:zoomableView_];
        [zoomableView_ release];
    }
    
    
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    scale *= [[[scrollView window] screen] scale];
    [mainView_ setContentScaleFactor:scale];
    for (ZoomableView* zoom in array_) {
        [zoom setContentScaleFactor:scale];
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return mainView_;

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}



@end
