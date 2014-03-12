//
//  CLMMultipeerListener.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMMultipeerListener : NSObject

+ (instancetype)sharedInstance;
+ (void)startUp;
@property (nonatomic, strong, readonly) NSArray *peers;
@end
