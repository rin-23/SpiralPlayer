//
//  PizzaViewController.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PizzaViewController.h"
#import "SineWaveView.h"
#import "PizzaControl.h"
#import "ExperimentView.h"

@implementation PizzaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
- (void)viewDidLoad {
    [super viewDidLoad];

//    ExperimentView* expView = [[ExperimentView alloc] initWithFrame:CGRectMake(0, 0, 768, 768)];
//    expView.center = CGPointMake(768/2, 1024/2);
//    [self.view addSubview:expView];
//    [expView release];
    
    PizzaControl* pizzaSpiralView = [[PizzaControl alloc] initWithFrame:CGRectMake(0, 0, 768, 768)];
    pizzaSpiralView.center = CGPointMake(768/2, 1024/2);
    [self.view addSubview:pizzaSpiralView];
    [pizzaSpiralView release];
    
    
//    SineWaveView* sine = [[SineWaveView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
//    [self.view addSubview:sine];
//    [sine release];
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
	return YES;
}

@end
