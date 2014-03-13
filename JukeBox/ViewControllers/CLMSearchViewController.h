//
//  CLMSearchViewController.h
//  Jukebox
//
//  Created by Ricky Thomas on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMTrackModel.h"

@protocol CLMSearchViewControllerDelegate;

@interface CLMSearchViewController : UIViewController

- (void)reset;
@property (nonatomic, weak) id<CLMSearchViewControllerDelegate> delegate;
@end

@protocol CLMSearchViewControllerDelegate <NSObject>

- (void)didSelectTrack:(CLMTrackModel *)track;

@end