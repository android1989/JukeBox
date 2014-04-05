//
//  CLMCutTrack.m
//  Jukebox
//
//  Created by Ricky Thomas on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMCutATrack.h"
#import <AVFoundation/AVComposition.h>
#import <AVFoundation/AVCompositionTrack.h>
#import <AVFoundation/AVCompositionTrackSegment.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAssetExportSession.h>

@implementation CLMCutTrack

+ (void)cutFile:(NSString *)inputURLstring toFile:(NSString *)outputURLstring startingAt:(float)start forDuration:(float)duration withCompletion:(cutCompletionBlock)completionBlock {
    NSURL *inputURL = [NSURL URLWithString:inputURLstring];
    NSURL *outputURL = [NSURL URLWithString:outputURLstring];
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    NSLog(@"asset timeRange: %lld, %lld", kCMTimeZero.value, asset.duration.value);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputURLstring]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:outputURL error:&error];
        if (error) {
            NSLog(@"remove outputURL error: %@", error);
        }
    }
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    exportSession.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(start, kCMTimeMaxTimescale), CMTimeMakeWithSeconds(duration, kCMTimeMaxTimescale));
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    
    __weak AVAssetExportSession* weakSession = exportSession;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        if (weakSession.status != AVAssetExportSessionStatusCompleted) {
            NSLog(@"Error exporting: %@", weakSession.error);
            return;
        }
        
        if (completionBlock) {
            completionBlock();
        }
    }];
}

@end
