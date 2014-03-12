//
//  CLMDisplayNameCell.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMDisplayNameCell.h"


@interface CLMDisplayNameCell ()

@property (nonatomic, strong) IBOutlet UILabel *displayName;
@end

@implementation CLMDisplayNameCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureWithPeer:(MCPeerID *)peerID
{
    self.displayName.text = peerID.displayName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
