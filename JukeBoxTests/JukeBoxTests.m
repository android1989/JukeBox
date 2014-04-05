//
//  JukeBoxTests.m
//  JukeBoxTests
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLMCutATrack.h"

@interface JukeBoxTests : XCTestCase

@end

@implementation JukeBoxTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test {
    NSURL *inputURL = [[NSBundle mainBundle] URLForResource:@"Full" withExtension:@"mp3"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *outputPath = [NSString pathWithComponents:@[path, @"output.m4a"]];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    
    [CLMCutTrack cutFile:[inputURL absoluteString] toFile:[outputURL absoluteString] startingAt:10 forDuration:10 withCompletion:nil];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:outputPath]);
}

@end
