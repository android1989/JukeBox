//
//  CLMRecordViewController.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CLMLoopProject;

@protocol CLMRecorderDelegate;

@interface CLMRecorder : NSObject {
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
}

- (instancetype)initWithCLMLoopProject:(CLMLoopProject *)loopProject;
@property (nonatomic, weak) id<CLMRecorderDelegate> delegate;

- (void)startRecording;
- (void)playRecording;
- (void)stopPlaying;
- (BOOL)isRecording;
@end

@protocol CLMRecorderDelegate <NSObject>
- (void)recorder:(CLMRecorder *)recoder peakLevel:(CGFloat)level;
- (void)recorderdidStopRecording:(CLMRecorder *)recoder;
- (void)recorder:(CLMRecorder *)recoder hitBeat:(NSInteger)beat;
@end