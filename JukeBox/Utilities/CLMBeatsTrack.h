//
//  CLMBeatsTrack.h
//  Jukebox
//
//  Created by Phillip Jacobs on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "CLMTrackModel.h"

typedef void (^beatsCompletionBlock)(NSArray *tracks);
typedef void (^echoNestCompletionBlock1)(NSString *url);
typedef void (^echoNestCompletionBlock2)(NSArray *bars);
typedef void (^echoNestCompletionBlock3)(void);

@interface CLMBeatsTrack : AFHTTPSessionManager

+ (instancetype)sharedManager;
- (void)beatsWith:(NSString *)searchString completionBlock:(beatsCompletionBlock)completionBlock;
- (void)echoNestGetURLFrom:(CLMTrackModel *)model completionBlock:(echoNestCompletionBlock1)completionBlock;
- (void)echoNestGetBarsFrom:(NSString *)url completionBlock:(echoNestCompletionBlock2)completionBlock;
- (void)beatsTrackWith:(NSString *)trackId completionBlock:(echoNestCompletionBlock3)completionBlock;

@end
