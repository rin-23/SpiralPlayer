//
//  LyricsManager.h
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricsManager : NSObject

+ (LyricsManager*) sharedInstance;
- (NSMutableArray*) getCharactersFromFile:(NSString*)filename ofType:(NSString*)type;
- (NSMutableArray*) getKaraokeFromFile:(NSString*)filename ofType:(NSString*)type;
@end
