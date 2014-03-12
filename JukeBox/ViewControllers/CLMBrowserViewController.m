//
//  CLMBrowserViewController.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMBrowserViewController.h"
#import "CLMConstants.h"
#import "CLMMultipeerListener.h"

@interface CLMBrowserViewController ()

@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@end

@implementation CLMBrowserViewController

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
    [self registerNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerlistDidChange:) name:kPeersDidChangeNotification object:nil];
}

#pragma mark - Notifications

- (void)peerlistDidChange:(NSNotification *)notification {
    NSArray *peers = [[CLMMultipeerListener sharedInstance] peers];
    self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)peers.count];
}
@end
