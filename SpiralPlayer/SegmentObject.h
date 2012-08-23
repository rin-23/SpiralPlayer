//
//  SegmentObject.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentObject : NSObject {    
    UIImage* image_;      
    int index_;
}

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) int index;

@end
