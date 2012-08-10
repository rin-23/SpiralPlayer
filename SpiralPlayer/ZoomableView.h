//
//  ZoomableView.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomableView : UIView {
    double centerX_;
    double centerY_;
    double maxArclength_;
    double radiusStep_;
}

@end
