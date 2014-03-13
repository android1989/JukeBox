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

@interface CLMLoopViewController () <CLMRecorderDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CLMLoopProject *loopProject;
@property (nonatomic, strong) CLMRecorder *recorder;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) IBOutlet UIImageView *recordingAnimation;
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
        [self.delegate didBeginRecording];
        [self.recorder startRecording];
        [self.recordingAnimation startAnimating];
        self.recordButton.enabled = NO;
        [self.recordButton setTitle:@"Recording" forState:UIControlStateNormal];
    }
}

#pragma mark - CLMRecorderDelegate

- (void)recorderdidStopRecording:(CLMRecorder *)recoder {
    [self.playButton setTitle:@"Record" forState:UIControlStateNormal];
    self.recordButton.enabled = YES;
    [self.recordingAnimation stopAnimating];
    [self.collectionView reloadData];
    self.recordButton.transform = CGAffineTransformIdentity;
    [self.delegate didStopRecording];
}

- (void)recorder:(CLMRecorder *)recoder peakLevel:(CGFloat)level {
    self.recordingAnimation.transform = CGAffineTransformMakeScale(2+level, 2+level);
    self.recordButton.transform = CGAffineTransformMakeScale(1+level, 1+level);
}
@end
