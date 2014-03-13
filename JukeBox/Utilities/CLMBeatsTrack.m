//
//  CLMBeatsTrack.m
//  Jukebox
//
//  Created by Phillip Jacobs on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMBeatsTrack.h"
#import <AFNetworking/AFNetworking.h>
#import "CLMTrackModel.h"

static CLMBeatsTrack *_sharedBeats = nil;

@implementation CLMBeatsTrack

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBeats = [[CLMBeatsTrack alloc] init];
    });
    
    return _sharedBeats;
}


- (void)beatsWith:(NSString *)searchString completionBlock:(beatsCompletionBlock)completionBlock {
    NSString *finalPath = [NSString stringWithFormat:@"https://partner.api.beatsmusic.com/v1/api/search?q=%@&type=track&client_id=538k54xdrc6xnq9rnf55uyts", searchString];
    [self GET:finalPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSMutableArray *tracks = [[NSMutableArray alloc] init];
        NSDictionary *json = responseObject;
        for (NSDictionary *track in json[@"data"]) {
            [tracks addObject:[[CLMTrackModel alloc] initWithDictionary:track]];
        }
        completionBlock(tracks);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


@end
