//
//  CLMBeatsTrack.m
//  Jukebox
//
//  Created by Phillip Jacobs on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMBeatsTrack.h"
#import <AFNetworking/AFNetworking.h>

static CLMBeatsTrack *_sharedBeats = nil;

@implementation CLMBeatsTrack

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBeats = [[CLMBeatsTrack alloc] init];
    });
    
    return _sharedBeats;
}

- (id)init {
    self = [super init];
    if (self) {
        [self.requestSerializer setValue:@"No-Cache" forHTTPHeaderField:@"Cache-Control"];
    }
    return self;
}


- (void)beatsWith:(NSString *)searchString completionBlock:(beatsCompletionBlock)completionBlock {
    NSString *finalPath = [NSString stringWithFormat:@"https://partner.api.beatsmusic.com/v1/api/search?q=%@&type=track&client_id=538k54xdrc6xnq9rnf55uyts", searchString];
    finalPath = [finalPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:finalPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *tracks = [[NSMutableArray alloc] init];
        NSDictionary *json = responseObject;
        for (NSDictionary *track in json[@"data"]) {
            [tracks addObject:[[CLMTrackModel alloc] initWithDictionary:track]];
        }
        completionBlock(tracks);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


- (void)echoNestGetURLFrom:(CLMTrackModel *)model completionBlock:(echoNestCompletionBlock1)completionBlock {
    NSLog(@"%@ by %@", model.display, model.detail);
    NSString *finalPath = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/song/search?api_key=YEDAAGNGLIRV8WD15&format=json&results=1&artist=%@&title=%@&bucket=id:mog&bucket=audio_summary&bucket=tracks", model.detail, model.display];
    [self GET:[finalPath stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock([responseObject[@"response"][@"songs"] objectAtIndex:0][@"audio_summary"][@"analysis_url"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


- (void)echoNestGetBarsFrom:(NSString *)url completionBlock:(echoNestCompletionBlock2)completionBlock {
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *barArr = [[NSMutableArray alloc] init];
        for (int k = 0; k < 4; k++) {
            NSDictionary *bar = [responseObject[@"bars"] objectAtIndex:k];
            [barArr addObject:bar];
        }
        completionBlock(barArr); //start of barArr[0]  == [barArr[0] valueForKey:@"start"]
        // end of the 4 bars is equal to the start value + 8 seconds ( in variable time case it would be equal to [barArr[3] valueForKey:@"start"] + [barArr[3] valueForKey:@"duration"]
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"err");
    }];
}

@end
