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
#import "CLMDisplayNameCell.h"

@interface CLMBrowserViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) NSArray *peers;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
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
    [self registerCells];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerlistDidChange:) name:kPeersDidChangeNotification object:nil];
}

- (void)registerCells {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CLMDisplayNameCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CLMDisplayNameCell class])];
}

#pragma mark - Notifications

- (void)peerlistDidChange:(NSNotification *)notification {
    self.peers = [[CLMMultipeerListener sharedInstance] peers];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.peers count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CLMDisplayNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CLMDisplayNameCell class]) forIndexPath:indexPath];
    
    [cell configureWithPeer:self.peers[indexPath.item]];
    
    return cell;
}
@end
