//
//  CLMSearchViewController.m
//  Jukebox
//
//  Created by Ricky Thomas on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMSearchViewController.h"
#import "CLMTrackModel.h"
#import "CLMBeatsTrack.h"
#import "CLMDisplayNameCell.h"

@interface CLMSearchViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *artistField;
@property (strong, nonatomic) IBOutlet UITextField *trackField;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

@implementation CLMSearchViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCells {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CLMDisplayNameCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CLMDisplayNameCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.results count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CLMDisplayNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CLMDisplayNameCell class]) forIndexPath:indexPath];
    
    [cell configureWithPeer:self.results[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectTrack:self.results[indexPath.item]];
}

-(IBAction)artistChanged:(id)sender{
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
    } completion:^(BOOL finished) {
        
    }];
}

-(IBAction)trackChanged:(id)sender{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.trackField) {
        [textField resignFirstResponder];
        [[CLMBeatsTrack sharedManager] beatsWith:[NSString stringWithFormat:@"%@+%@", self.trackField.text, self.artistField.text] completionBlock:^(NSArray *tracks) {
            self.results = tracks;
            [self.collectionView reloadData]; 
        }];
    }
    
    return NO;
}

- (void)reset {
    self.artistField.text = 0;
    self.trackField.text = 0;
    self.results = nil;
    [self.collectionView reloadData];
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        
    }];
}
@end
