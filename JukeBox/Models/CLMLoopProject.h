//
//  CLMLoopProject.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMLoopProject : NSObject

@property (nonatomic, strong) NSMutableArray *recordings;
- (NSString *)nextRecordingFileName;
- (void)addSongClip;
@end
