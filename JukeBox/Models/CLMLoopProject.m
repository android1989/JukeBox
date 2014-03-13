//
//  CLMLoopProject.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMLoopProject.h"

@implementation CLMLoopProject

- (id)init {
    self = [super init];
    if (self) {
        _recordings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSongClip {
    [_recordings addObject:@"10 Voyager.mp3"];
}

- (NSString *)nextRecordingFileName {
    NSString *fileName =  [NSString stringWithFormat:@"recording%lu", (unsigned long)[self.recordings count]];
    [self.recordings addObject:fileName];
    return fileName;
}
@end
