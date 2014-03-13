//
//  CLMTrackCell.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMTrackCell.h"
#import <AVFoundation/AVFoundation.h>
@interface CLMTrackCell ()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) IBOutlet UIImageView *recordingAnimation;
@property (nonatomic, assign) BOOL shouldPlay;
@end

@implementation CLMTrackCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadRecordingAnimation];
    self.shouldPlay = YES;
}

- (void)loadRecordingAnimation
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    static int dots = 0;
    NSString *name = @"dots";
    
    switch (dots) {
        case 0:
            name = @"dots";
            break;
        case 1:
            name = @"circle";
            break;
        case 2:
            name = @"line";
            break;
        default:
            break;
    }
    
    dots++;
    for (int i = 1; i <= 23; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%02d",name, i]];
        [images addObject:image];
    }
    
    self.recordingAnimation.animationImages = images;
    self.recordingAnimation.animationRepeatCount = -1;
    self.recordingAnimation.animationDuration = 1;
}

- (void)configureWithAudioFile:(NSString *)fileName {
    
     NSURL *outputFileURL = nil;
    if (NSNotFound == [fileName rangeOfString:@"mp3"].location) {
        self.fileName = [NSString stringWithFormat:@"%@.caf", fileName];
        
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   self.fileName,
                                   nil];
        outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    }else{
        self.fileName = fileName;
        NSArray *components = [fileName componentsSeparatedByString:@"."];
        outputFileURL = [[NSBundle mainBundle] URLForResource:[components firstObject] withExtension:@"mp3"];
    }
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL error:&error];
    self.audioPlayer.numberOfLoops = -1;
}

- (void)play {
    if (!self.shouldPlay) {
        return;
    }
    [self.audioPlayer play];
    [self.recordingAnimation startAnimating];
}

- (void)stop {
    [self.audioPlayer stop];
    [self.recordingAnimation stopAnimating];
}

- (void)togglePlay {
    self.shouldPlay = !_shouldPlay;
    
    if (!self.shouldPlay) {
        self.alpha = .5;
    }else{
        self.alpha = 1;
    }
}
@end
