//
//  CLMCutTrack.m
//  Jukebox
//
//  Created by Ricky Thomas on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMCutTrack.h"
#import <AVFoundation/AVComposition.h>
#import <AVFoundation/AVCompositionTrack.h>
#import <AVFoundation/AVCompositionTrackSegment.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAssetExportSession.h>

@implementation CLMCutTrack

+ (void) cutTrack:(NSString *)file toFile:(NSString *)outputURL startingAt:(float)start forDuration:(float)duration withCompletion:(cutCompletionBlock)completionBlock {
    NSError *error;
    AVMutableComposition *voyager = [AVMutableComposition composition];
    NSString *inputAudioPath = [[NSBundle mainBundle] pathForResource:file ofType:@"mp3"];
    NSURL* audioURL = [NSURL fileURLWithPath:inputAudioPath];
    AVURLAsset* audioAsset1 = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    AVMutableCompositionTrack *compositionAudioTrack = [voyager addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,CMTimeMakeWithSeconds(duration, kCMTimeMaxTimescale))
                                    ofTrack:[[audioAsset1 tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                                     atTime:CMTimeMakeWithSeconds(start, kCMTimeMaxTimescale)
                                      error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    } else {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:[compositionAudioTrack asset] presetName:nil];
        exportSession.outputURL = [NSURL URLWithString:outputURL];
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            completionBlock();
        }];
    }
}

@end
