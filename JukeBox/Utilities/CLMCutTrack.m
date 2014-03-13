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
    
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:file withExtension:@"mp3"];

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
        
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   [NSString stringWithFormat:@"%@.mp3", outputURL], nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        exportSession.outputURL = outputFileURL;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            AVAssetExportSessionStatus exportStatus = exportSession.status;
            
            switch (exportStatus) {
                case AVAssetExportSessionStatusCompleted: {
                    completionBlock();
                    break;
                }
                default: {
                    NSLog(@"err: %@", exportSession.error);
                    break;
                }
            }
        }];
    }
}

@end
