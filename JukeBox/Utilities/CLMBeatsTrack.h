//
//  CLMBeatsTrack.h
//  Jukebox
//
//  Created by Phillip Jacobs on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

typedef void (^beatsCompletionBlock)(NSArray *tracks);

@interface CLMBeatsTrack : AFHTTPSessionManager

+ (instancetype)sharedManager;
- (void)beatsWith:(NSString *)searchString completionBlock:(beatsCompletionBlock)completionBlock;

@end
