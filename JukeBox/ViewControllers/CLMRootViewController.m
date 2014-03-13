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
#import "CLMRtmp.h"


@interface CLMRootViewController ()

@property (nonatomic, strong) CLMLoopViewController *loopViewController;

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

    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loopViewController = [[CLMLoopViewController alloc] init];
                
                [self addChildViewController:self.loopViewController];
                [self.loopViewController willMoveToParentViewController:self];
                [self.view addSubview:self.loopViewController.view];
            });
        } else {
            
        }

    [[CLMBeatsTrack sharedManager] beatsWith:@"voyager" completionBlock:^(NSArray *tracks) {
        [[CLMBeatsTrack sharedManager] echoNestGetURLFrom:[tracks objectAtIndex:0] completionBlock:^(NSString *url) {
            [[CLMBeatsTrack sharedManager] echoNestGetBarsFrom:url completionBlock:^(NSArray *bars) {
                
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
