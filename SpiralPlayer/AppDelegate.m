//
//  AppDelegate.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "LyricsViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
//    UITabBarController* tabBar =[[UITabBarController alloc] init];
//    
//    UIViewController* v1 = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
//
//    //UIViewController* v2  = [[PolyLineViewController alloc] init];
//    
//    UIViewController* v3   = [[PizzaViewController alloc] init];
//       
//    UIViewController* v4  = [[SpaceViewController alloc] init];
//    
//    UIViewController* v5  = [[ZhengViewController alloc] init];
//   
//    NSArray* controllers = [[NSArray alloc] initWithObjects:v1,v3,v4,v5, nil];
//    tabBar.viewControllers = controllers;
//    tabBar.selectedViewController = v5;
    
    
    
    //SpiralViewController
    //self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];

    //PolyLineViewController
    //self.viewController = [[PolyLineViewController alloc] init];
    
    //Pizza View Controller
    //self.viewController = [[PizzaViewController alloc] init];
    
    //Space View Controller
    //self.viewController = [[SpaceViewController alloc] init];
    
    //Zheng View Controller
    //self.viewController = [[ZhengViewController alloc] init];
      
    //Seek Control
    self.viewController = [[LyricsViewController alloc] init];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
