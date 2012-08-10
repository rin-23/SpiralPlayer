//
//  DataPointsManager.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-08-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPointsManager : NSObject{
    
    NSMutableDictionary* filesRead_;
    

}

@property (nonatomic, retain) NSMutableDictionary* filesRead;

+ (DataPointsManager*) sharedInstance;
- (NSMutableDictionary*) getPointsForFile:(NSString*)fileName ofType:(NSString*)type;

@end
