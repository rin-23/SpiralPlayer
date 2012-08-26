//
//  ZhengViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZhengViewController.h"
#import "ZhengControl.h"
@implementation ZhengViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    ZhengControl* control;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        control = [[ZhengControl alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
        control.center = CGPointMake(768/2, 1024/2);
    } else {
        control = [[ZhengControl alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        control.center = CGPointMake(160, 240); 
    }
    [self.view addSubview:control];
    [control release];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
