//
//  CLMLoopViewController.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMLoopViewController.h"
#import "CLMLoopProject.h"
#import "CLMRecorder.h"
#import "CLMTrackCell.h"
#import "CLMCutTrack.h"

@interface CLMLoopViewController () <CLMRecorderDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CLMLoopProject *loopProject;
@property (nonatomic, strong) CLMRecorder *recorder;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) IBOutlet UIImageView *recordingAnimation;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *bpmLabel;
@property (nonatomic, strong) IBOutlet UILabel *recordingsLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;

@property (nonatomic, strong) CLMTrackModel *trackModel;
@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) IBOutlet UIImageView *mootImageView;
@end

@implementation CLMLoopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCells];
    
    self.loopProject = [[CLMLoopProject alloc] init];
    self.recorder = [[CLMRecorder alloc] initWithCLMLoopProject:self.loopProject];
    self.recorder.delegate = self;
    
    [self loadRecordingAnimation];
    
    self.playButton.alpha = 0;
    self.bpmLabel.alpha = 0;
    self.timeLabel.alpha = 0;
    self.artistLabel.alpha = 0;
    self.progressView.alpha = 0;
    self.recordingsLabel.alpha = 0;
    self.mootImageView.alpha = 0;
    
    self.timeLabel.font = [UIFont fontWithName:@"KenyanCoffeeRg-Regular" size:36];
    self.bpmLabel.font = [UIFont fontWithName:@"KenyanCoffeeRg-Regular" size:36];
    self.artistLabel.font = [UIFont fontWithName:@"KenyanCoffeeRg-Regular" size:36];
    self.recordingsLabel.font = [UIFont fontWithName:@"KenyanCoffeeRg-Regular" size:22];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGPoint oldCenter = self.recordButton.center;
    self.recordButton.center = CGPointMake(oldCenter.x, -100);
   
    
    [UIView animateWithDuration:.4 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mootImageView.alpha = 1;
        self.recordButton.center = CGPointMake(oldCenter.x, oldCenter.y+5);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.recordButton.center = oldCenter;
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:.3 delay:2 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.mootImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.4 delay:2 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                if ([self.loopProject.recordings count] != 0) {
                    self.playButton.alpha = 1;
                }
                self.collectionView.alpha = 1;
                self.bpmLabel.alpha = 1;
                self.timeLabel.alpha = 1;
                self.recordingsLabel.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRecordingAnimation
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 40; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Recording_000%02d", i]];
        [images addObject:image];
    }
    
    self.recordingAnimation.animationImages = images;
    self.recordingAnimation.animationRepeatCount = -1;
    self.recordingAnimation.animationDuration = 2;
}

- (void)registerCells {
    NSString *trackCell = NSStringFromClass([CLMTrackCell class]);
    [self.collectionView registerNib:[UINib nibWithNibName:trackCell bundle:nil] forCellWithReuseIdentifier:trackCell];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.loopProject recordings] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLMTrackCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CLMTrackCell class]) forIndexPath:indexPath];
    
    [cell configureWithAudioFile:self.loopProject.recordings[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CLMTrackCell *track = (CLMTrackCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [track togglePlayShouldTakeActionNow:NO];
}

#pragma mark - IBActions

- (IBAction)playButtonTouchUpInside:(id)sender {
    if (self.isPlaying) {
        for (CLMTrackCell *track in self.collectionView.visibleCells) {
            [track stop];
        }
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        self.isPlaying = NO;
    }else{
        for (CLMTrackCell *track in self.collectionView.visibleCells) {
            [track play];
        }
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        self.isPlaying = YES;
    }
}

- (IBAction)playPauseTouchUpInside:(id)sender {
    if ([self.recorder isRecording]) {
        
    }else{
        if (self.isPlaying && self.trackModel) {
            [self stopSong];
            [self recorderdidStopRecording:nil];
            return;
        }
        
        [self animateDetailsOut];
        [self.delegate didBeginRecording];
        
        
        if (self.trackModel) {
            [self playSong];
        }else{
            [self.recorder startRecording];
        }
        
        [self.recordingAnimation startAnimating];

        [self.recordButton setTitle:@"Recording" forState:UIControlStateNormal];
    }
}

#pragma mark - CLMRecorderDelegate

- (void)recorderdidStopRecording:(CLMRecorder *)recoder {
    [self.playButton setTitle:@"Record" forState:UIControlStateNormal];
    self.recordButton.enabled = YES;
    [self.recordingAnimation stopAnimating];
    [self.collectionView reloadData];
       
    [UIView animateWithDuration:.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.recordButton.transform = CGAffineTransformIdentity;
        self.recordingAnimation.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
    
    [self.delegate didStopRecording];
    [self animateDetailsIn];
}

- (void)recorder:(CLMRecorder *)recoder peakLevel:(CGFloat)level {
    self.recordingAnimation.transform = CGAffineTransformMakeScale(2+level, 2+level);
    self.recordButton.transform = CGAffineTransformMakeScale(1+level, 1+level);
}

- (void)animateIn {
    
}

- (void)animateDetailsOut {
    [UIView animateWithDuration:.4 animations:^{
        self.playButton.alpha = 0;
        self.bpmLabel.alpha = 0;
        self.timeLabel.alpha = 0;
        self.collectionView.alpha = 0;
        self.recordingsLabel.alpha = 0;
    }];
}

- (void)animateDetailsIn {
    [UIView animateWithDuration:.4 animations:^{
        if ([self.loopProject.recordings count] != 0) {
            self.playButton.alpha = 1;
        }
        self.collectionView.alpha = 1;
        self.bpmLabel.alpha = 1;
        self.timeLabel.alpha = 1;
        self.recordingsLabel.alpha = 1;
    }];
}

- (void)setCLMTrackModel:(CLMTrackModel *)trackModel {
    _trackModel = trackModel;
    self.artistLabel.text = [NSString stringWithFormat:@"%@, %@", trackModel.display, trackModel.detail];
    self.progressView.progress = 0;
    [UIView animateWithDuration:.4 animations:^{
        self.artistLabel.alpha = 1;
        self.progressView.alpha = 1;
        self.playButton.alpha = 0;
    }];
}

- (void)playSong {
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressMade) userInfo:nil repeats:YES];
    self.progressView.progress = 0;
    self.isPlaying = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Full" withExtension:@"mp3"];
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)stopSong {
    //[self.loopProject addSongClip];
    self.isPlaying = NO;
    [self.audioPlayer stop];
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
    if (self.trackModel) {
        [CLMCutTrack cutTrack:@"10 Voyager" toFile:[self.loopProject nextRecordingFileName] startingAt:0.12 forDuration:8.0 withCompletion:^{
            self.trackModel = nil;
            self.progressView.progress = 0;
            
            [UIView animateWithDuration:.4 animations:^{
                self.artistLabel.alpha = 0;
                self.progressView.alpha = 0;
            }];
       }];
    }
    
    self.trackModel = nil;
    self.progressView.progress = 0;
    
    [UIView animateWithDuration:.4 animations:^{
        self.artistLabel.alpha = 0;
        self.progressView.alpha = 0;
    }];
}

- (void)progressMade {
    self.progressView.progress += .01;
}
@end
