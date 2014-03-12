//
//  CLMDisplayNameCell.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CLMDisplayNameCell : UICollectionViewCell

- (void)configureWithPeer:(MCPeerID *)peerID;
@end
