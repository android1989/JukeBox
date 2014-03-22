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
typedef void (^beatsCompletionBlock2)(NSString *mp3);
typedef void (^echoNestCompletionBlock)(NSString *url);
typedef void (^echoNestCompletionBlock2)(NSArray *bars);

@interface CLMBeatsTrack : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)beatsWith:(NSString *)searchString completionBlock:(beatsCompletionBlock)completionBlock;
- (void)beatsTrackWith:(NSString *)trackId completionBlock:(beatsCompletionBlock2)completionBlock;

- (void)echoNestGetURLFrom:(CLMTrackModel *)model completionBlock:(echoNestCompletionBlock)completionBlock;
- (void)echoNestGetBarsFrom:(NSString *)url completionBlock:(echoNestCompletionBlock2)completionBlock;

@end
