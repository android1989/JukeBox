//
//  CLMLoopViewController.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLMLooperControllerDelegate;

@interface CLMLoopViewController : UIViewController

@property (nonatomic, weak) id<CLMLooperControllerDelegate> delegate;
@end

@protocol CLMLooperControllerDelegate <NSObject>

- (void)didBeginRecording;
- (void)didStopRecording;

@end