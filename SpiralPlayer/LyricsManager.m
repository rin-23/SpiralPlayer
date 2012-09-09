//
//  LyricsManager.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-09-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LyricsManager.h"


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
        NSLog(@"read char: %c", c);
        k[0] = c;
        k[1] = '\0';
        [array addObject:[NSString stringWithUTF8String:k]];
    }
    
    return [array autorelease];  

}

@end
