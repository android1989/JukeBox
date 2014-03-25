//
//  CLMRecordViewController.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMRecorder.h"
#import "CLMLoopProject.h"

@interface CLMRecorder () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) CLMLoopProject *project;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *micSamplingTimer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat numberOfBeatsToRecord;
@property (nonatomic, assign) CGFloat lowPassResults;
@end
@implementation CLMRecorder

- (instancetype)initWithCLMLoopProject:(CLMLoopProject *)loopProject {
    self = [super init];
    if (self) {
        self.project = loopProject;
        recordEncoding = kAudioFormatMPEG4AAC;
    }
    return self;
}

- (void)playPreBeat {
    CGFloat bars = 4;
    CGFloat beats = 4;
    CGFloat beatsPerMinute = 120/60.0f;
    CGFloat duration = 1.0f/beatsPerMinute;
    self.numberOfBeatsToRecord = bars*beats;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"tick" withExtension:@"mp3"];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer prepareToPlay];

    audioRecorder = nil;
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               [NSString stringWithFormat:@"%@.caf", [self.project nextRecordingFileName]],
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    audioRecorder.meteringEnabled = YES;
    [audioRecorder prepareToRecord];
    audioRecorder.delegate = self;
    
    self.count = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];
    
    
}

- (void)targetMethod:(NSTimer *)timer {

    self.count ++;
    if (self.count == 4) {
        [self beginRecording];
        if ([self isHeadsetPluggedIn]) {
            [self.delegate recordingAndPlay];
        }
        self.micSamplingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo:nil repeats:YES];
    }
    
    if ([self isHeadsetPluggedIn]) {
        [audioPlayer play];
    }
    
    [self.delegate recorder:self hitBeat:self.count];
    if (self.numberOfBeatsToRecord+4 == self.count) {
        [self stopRecording];
    }
    
    
}


- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    
    BOOL headphonesLocated = NO;
    for ( AVAudioSessionPortDescription *portDescription in route.outputs ) {
        headphonesLocated |= ( [portDescription.portType isEqualToString:AVAudioSessionPortHeadphones] );
    }
    return headphonesLocated;
}


- (void)levelTimerCallback:(NSTimer *)timer {
	[audioRecorder updateMeters];
    
    const double ALPHA = 0.5;
	double peakPowerForChannel = pow(10, (0.5 * [audioRecorder peakPowerForChannel:0]));
	self.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;
    
    [self.delegate recorder:self peakLevel:self.lowPassResults];
}

- (void)beginRecording {
    [audioRecorder record];
}

-(void)startRecording
{
    [self playPreBeat];
}

-(void)stopRecording
{
    [audioRecorder stop];
    [self.timer invalidate];
    self.timer = nil;
    
    [self.micSamplingTimer invalidate];
    self.micSamplingTimer = nil;
}

-(void) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(void) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
}

- (BOOL)isRecording {
    return audioRecorder.recording;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self.delegate recorderdidStopRecording:self];
}
@end