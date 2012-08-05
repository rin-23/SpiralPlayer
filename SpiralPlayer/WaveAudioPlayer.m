//
//  WaveAudioPlayer.m
//  SpiralPlayer
//
//  Created by Rinat Abdrashitov on 12-07-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaveAudioPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Constants.h"

@interface WaveAudioPlayer(PrivateMethods)
- (void) convertCurrentItemToCAF;
@end     

@implementation WaveAudioPlayer

@synthesize mediaItem = mediaItem_, player = audioPlayer_, delegate = delegate_;

/*
 * Initialization
 */
-(id) init{
    self = [super init];
    return self;
}

- (void) loadNextAudioAsset:(NSURL*) url {
    NSError *error;
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);

    audioPlayer_= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer_.delegate = self;
    [self.player prepareToPlay]; 
}

/*
 * Play next media item
 */ 
- (void) loadNextMediaItem:(MPMediaItem*) mediaItem {
    [self.player stop];
    self.mediaItem = mediaItem;
    [self convertCurrentItemToCAF]; //covert to pcm data
}

- (void) doneConverting {
    if (audioPlayer_ != nil) {
        [audioPlayer_ release];
    }
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    NSString *exportPath = [[documentsDirectoryPath stringByAppendingPathComponent:EXPORT_NAME] retain];
    NSURL *url = [NSURL fileURLWithPath:exportPath];
    NSError *error;
        
    //NSURL *test_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ChameleonComedian" ofType:@"mp3"]];
    audioPlayer_= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer_.delegate = self;
    
    if (error) {
        NSLog(@"Error in audioPlayer: %@",  [error localizedDescription]);
    } else {
        [self.player prepareToPlay]; 
        [delegate_ finishedConvertingToPCM];        
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [delegate_ waveAudioPlayerDidFinishPlaying];    
}

/*
 * Convert iPod musicItem to PCM format (Core Audio Format - CAF)
 */
- (void) convertCurrentItemToCAF {
    if (self.mediaItem == nil) {
        NSLog(@"ERROR: mediaItem is nil");
        return;
    }
    
    NSURL *assetURL = [self.mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    NSError *assetError = nil;
	AVAssetReader *assetReader = [[AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError]  retain];
	if (assetError) {
		NSLog (@"error: %@", assetError);
		return;
	}
	
	AVAssetReaderOutput *assetReaderOutput = [[AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                                                                                      audioSettings: nil] retain];
	if (! [assetReader canAddOutput: assetReaderOutput]) {
		NSLog (@"can't add reader output... die!");
		return;
	}
	[assetReader addOutput: assetReaderOutput];
	
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
	NSString *exportPath = [[documentsDirectoryPath stringByAppendingPathComponent:EXPORT_NAME] retain];
	if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
	}
	NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
	AVAssetWriter *assetWriter = [[AVAssetWriter assetWriterWithURL:exportURL
                                                           fileType:AVFileTypeCoreAudioFormat
                                                              error:&assetError] retain];
	if (assetError) {
		NSLog (@"error: %@", assetError);
		return; 
	}
	AudioChannelLayout channelLayout;
	memset(&channelLayout, 0, sizeof(AudioChannelLayout));
	channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
	NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey, 
									[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
									[NSNumber numberWithInt:2], AVNumberOfChannelsKey,
									[NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
									[NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
									[NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
									nil];
	AVAssetWriterInput *assetWriterInput = [[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                               outputSettings:outputSettings]
											retain];
	if ([assetWriter canAddInput:assetWriterInput]) {
		[assetWriter addInput:assetWriterInput];
	} else {
		NSLog (@"can't add asset writer input... die!");
		return;
	}
	
	assetWriterInput.expectsMediaDataInRealTime = NO;
    
	[assetWriter startWriting];
	[assetReader startReading];
    
	AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
	CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
	[assetWriter startSessionAtSourceTime: startTime];
	
	__block UInt64 convertedByteCount = 0;
	
	dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
	[assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue 
											usingBlock: ^ 
	 {
		 // NSLog (@"top of block");
		 while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 
                 NSNumber *convertedByteCountNumber = [NSNumber numberWithLong:convertedByteCount];
                 CFRelease(nextBuffer);
             } else {
                 // done!
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWriting];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:exportPath
                                                       error:nil];
                 NSLog (@"done. file size is %ld", [outputFileAttributes fileSize]);
                 NSNumber *doneFileSize = [NSNumber numberWithLong:[outputFileAttributes fileSize]];
                 [assetReader release];
                 [assetReaderOutput release];
                 [assetWriter release];
                 [assetWriterInput release];
                 [exportPath release];
                 [self  performSelectorOnMainThread: @selector(doneConverting) withObject:nil waitUntilDone:NO];
                 break;
             }
         }
         
	}];
	NSLog (@"bottom of convertTapped:");
}


@end
