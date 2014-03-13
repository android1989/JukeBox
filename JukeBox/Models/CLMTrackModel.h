//
//  CLMTrackModel.h
//  Jukebox
//
//  Created by Phillip Jacobs on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMTrackModel : NSObject

@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *display;
@property (nonatomic, strong) NSString *beatId;

- (instancetype)initWithDictionary:(NSDictionary *)properties;

@end
