//
//  CLMCutAVideo.m
//  Jukebox
//
//  Created by Ricky Thomas on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMCutAVideo.h"
#import <AVFoundation/AVComposition.h>
#import <AVFoundation/AVCompositionTrack.h>
#import <AVFoundation/AVCompositionTrackSegment.h>
#import <AVFoundation/AVMediaFormat.h>

@implementation CLMCutAVideo

-(void) attemptToCutAVideo {
    NSError *error;
    AVMutableComposition *voyager = [AVMutableComposition composition];
    NSString *inputAudioPath = [[NSBundle mainBundle] pathForResource:@"" ofType:@"mp3"];
    NSURL* audioURL = [NSURL fileURLWithPath:inputAudioPath];
    AVURLAsset* audioAsset1 = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    //AVMutableCompositionTrack *compositionAudioTrack = [voyager addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid]
    AVMutableCompositionTrack *compositionAudioTrack = [voyager addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAsset1.duration)
                                    ofTrack:[[audioAsset1 tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                                     atTime:kCMTimeZero
                                      error:&error];
    NSLog(@"%@",error);
}

@end
