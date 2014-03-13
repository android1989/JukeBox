//
//  CLMTrackCell.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLMTrackCell : UICollectionViewCell

- (void)configureWithAudioFile:(NSString *)fileName;
- (void)play;
- (void)stop;
- (void)togglePlayShouldTakeActionNow:(BOOL)actionNow;
@end
