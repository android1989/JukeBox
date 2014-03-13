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
}

- (void)loadRecordingAnimation
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 23; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"small_000%02d", i]];
        [images addObject:image];
    }
    
    self.recordingAnimation.animationImages = images;
    self.recordingAnimation.animationRepeatCount = -1;
    self.recordingAnimation.animationDuration = 1;
}

- (void)configureWithAudioFile:(NSString *)fileName {
    self.fileName = fileName;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               [NSString stringWithFormat:@"%@.caf", fileName],
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL error:&error];
    self.audioPlayer.numberOfLoops = -1;
}

- (void)play {
    [self.audioPlayer play];
    [self.recordingAnimation startAnimating];
}

- (void)stop {
    [self.audioPlayer stop];
    [self.recordingAnimation stopAnimating];
}
@end
