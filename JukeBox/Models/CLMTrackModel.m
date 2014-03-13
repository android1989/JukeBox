//
//  CLMTrackModel.m
//  Jukebox
//
//  Created by Phillip Jacobs on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMTrackModel.h"

@implementation CLMTrackModel

- (instancetype)initWithDictionary:(NSDictionary *)properties {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"display"]) {
        self.display = value;
    } else if ([key isEqualToString:@"detail"]) {
        self.detail = value;
    } else if ([key isEqualToString:@"id"]) {
        self.beatId = value;
    }
}

@end
