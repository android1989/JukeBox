//
//  CLMCutAVideo.h
//  Jukebox
//
//  Created by Ricky Thomas on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^cutCompletionBlock)(void);

@interface CLMCutTrack : NSObject

+ (void) cutTrack:(NSString *)file toFile:(NSString *)outputURL startingAt:(float)start forDuration:(float)duration withCompletion:(cutCompletionBlock)completionBlock;

@end
