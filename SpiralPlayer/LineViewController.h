//
//  LineViewController.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurveControl.h"
@interface LineViewController : UIViewController {
    CurveControl* curveControl_;
    
}

@property (nonatomic, retain) CurveControl* curveControl;

@end
