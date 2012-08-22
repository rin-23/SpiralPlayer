//
//  AppDelegate.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolyLineViewController.h"
#import "PizzaViewController.h"
#import "SpaceViewController.h"
#import "ZhengViewController.h"
@class ViewController;
@class PolyLineViewController;
@class ZhengViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController*  viewController;
@end
