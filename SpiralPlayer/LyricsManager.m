//
//  LyricsManager.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LyricsManager.h"
#import "Constants.h"

@implementation LyricsManager

static LyricsManager* instance;

- (id) init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (LyricsManager*) sharedInstance {
    if (instance == nil) instance = [[LyricsManager alloc] init];
    return instance;
}

//Read all characters from a text file and return an array of those characters
- (NSMutableArray*) getCharactersFromFile:(NSString*)filename ofType:(NSString*)type {
    NSString* path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    
    FILE* file = fopen([path UTF8String], "r");
    if (file == NULL) {
        NSLog(@"Error opening the %@", filename);
        return nil;
    }
    int c;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    while ((c = fgetc(file)) != EOF) {
        if (c == '\n') c = ' ';
        char* k = malloc(2*sizeof(char));
        //NSLog(@"read char: %c", c);
        k[0] = c;
        k[1] = '\0';
        [array addObject:[NSString stringWithUTF8String:k]];
    }
    
    return [array autorelease];  

}

//Read karaoke file
- (NSMutableArray*) getKaraokeFromFile:(NSString*)filename ofType:(NSString*)type {
        
    NSMutableArray* letters = [[NSMutableArray alloc] init];
    NSMutableDictionary* karaokeData = [[NSMutableDictionary alloc] init]; 
    NSString* path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray* lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i < [lines count] - 1; i++) {
        NSArray* elements = [[lines objectAtIndex:i] componentsSeparatedByString:@"/"];
        NSString* words = [elements objectAtIndex:0];
        NSArray* times = [[elements objectAtIndex:1] componentsSeparatedByString:@" "];
        
        int startMin = [[times objectAtIndex:0] intValue];
        int startSec = [[times objectAtIndex:1] intValue];
        int startMilliSec = [[times objectAtIndex:2] intValue];
        NSTimeInterval startTime = startMin * 60 + startSec + startMilliSec/1000.0;
        
        int finishMin = [[times objectAtIndex:3] intValue];
        int finishSec = [[times objectAtIndex:4] intValue];
        int finishMilliSec = [[times objectAtIndex:5] intValue];
        NSTimeInterval finishTime = finishMin * 60 + finishSec + finishMilliSec/1000.0;
        
        NSTimeInterval duration = finishTime - startTime;
        if (duration<0) NSLog(@"ERROR: Duration is negative");
        
        [karaokeData setObject:[NSNumber numberWithDouble:startTime] forKey:kSTART_TIME];
        [karaokeData setObject:[NSNumber numberWithDouble:duration] forKey:kDURATION];
        [karaokeData setObject:[NSNumber numberWithInt:words.length] forKey:kCHARS_NUM];
                
        for (int j = 0; j<words.length; j++) {
            unichar c = [words characterAtIndex:j];
            char* k = malloc(2*sizeof(char));
            NSLog(@"read char: %c", c);
            k[0] = c; 
            k[1] = '\0';
            [letters addObject:[NSString stringWithUTF8String:k]];
        }
    
    }
    
    return [NSArray arrayWithObjects:letters, karaokeData, nil];
    
}




@end
