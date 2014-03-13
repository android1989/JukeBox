//
//  CLMLoopViewController.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMTrackModel.h"

@protocol CLMLooperControllerDelegate;

@interface CLMLoopViewController : UIViewController

- (void)setCLMTrackModel:(CLMTrackModel *)trackModel;
@property (nonatomic, weak) id<CLMLooperControllerDelegate> delegate;
@end

@protocol CLMLooperControllerDelegate <NSObject>

- (void)didBeginRecording;
- (void)didStopRecording;

@end