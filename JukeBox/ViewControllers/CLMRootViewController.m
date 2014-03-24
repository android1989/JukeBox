//
//  CLMRootViewController.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMRootViewController.h"
#import "CLMLoopViewController.h"
#import "CLMMultipeerListener.h"
#import <AVFoundation/AVFoundation.h>
#import "CLMBeatsTrack.h"
#import "CLMSearchViewController.h"
#import "CLMLoginViewController.h"

@interface CLMRootViewController () <UIScrollViewDelegate, CLMLooperControllerDelegate, CLMSearchViewControllerDelegate, CLMLoginViewControllerDelegate>

@property (nonatomic, strong) CLMLoopViewController *loopViewController;
@property (nonatomic, strong) CLMSearchViewController *searchViewController;
@property (nonatomic, strong) CLMLoginViewController *loginViewController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *blackView;
@end

@implementation CLMRootViewController

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
    [CLMMultipeerListener startUp];
    // Do any additional setup after loading the view from its nib.

    self.loginViewController = [[CLMLoginViewController alloc] init];
    self.loginViewController.delegate = self;
    
    self.searchViewController = [[CLMSearchViewController alloc] init];
    self.searchViewController.delegate = self;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height)];
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:self.searchViewController.view];
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0)];
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.blackView];
    
    [self addChildViewController:self.loginViewController];
    [self.loopViewController willMoveToParentViewController:self];
    [self.view addSubview:self.loginViewController.view];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat xOffset = scrollView.contentOffset.x;
    
    CGFloat percentage = xOffset/self.view.bounds.size.width;
    percentage = MAX(percentage, .6);
    
    self.loopViewController.view.alpha = percentage;
    CGFloat offset = (1-percentage)*200;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-(self.view.bounds.size.width-xOffset), 0);
    self.loopViewController.view.transform = CGAffineTransformScale(transform, percentage, percentage);
    
}

- (void)didBeginRecording {
    self.scrollView.scrollEnabled = NO;
}

- (void)didStopRecording {
    self.scrollView.scrollEnabled = YES;
}

- (void)didSelectTrack:(CLMTrackModel *)track {
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:YES];
    [self.loopViewController setCLMTrackModel:track];
    [self.searchViewController reset];
}

- (void)loginViewControllerDidSkip {
    [self loginViewControllerDidLogin];
}

- (void)loginViewControllerDidLogin {
    [UIView animateWithDuration:.5 animations:^{
        self.loginViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loginViewController removeFromParentViewController];
        [self.loginViewController.view removeFromSuperview];
        [self.loginViewController didMoveToParentViewController:nil];
        
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loopViewController = [[CLMLoopViewController alloc] init];
                    
                    [self addChildViewController:self.loopViewController];
                    [self.loopViewController willMoveToParentViewController:self];
                    self.loopViewController.delegate = self;
                    self.loopViewController.view.frame = CGRectMake(self.view.bounds.size.width, 0, 320, self.view.bounds.size.height);
                    [self.scrollView insertSubview:self.loopViewController.view atIndex:0];
                    [self.blackView removeFromSuperview];
                });
            } else {
                
            }
        }];
        
    }];
}

@end
