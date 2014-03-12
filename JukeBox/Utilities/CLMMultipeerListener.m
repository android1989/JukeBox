//
//  CLMMultipeerListener.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/12/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMMultipeerListener.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "CLMConstants.h"

static CLMMultipeerListener *_sharedInstance;
static NSString * const JukeBoxServiceType = @"jukebox-service";

@interface CLMMultipeerListener () <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@property (nonatomic, strong) NSMutableArray *mutablePeers;
@property (nonatomic, strong) NSMutableArray *connectedPeers;
@end

@implementation CLMMultipeerListener

+ (void)startUp {
    CLMMultipeerListener *listener = [CLMMultipeerListener sharedInstance];
    [listener startAdvertisment];
    [listener startBrowsing];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CLMMultipeerListener alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        self.mutablePeers = [[NSMutableArray alloc] init];
        self.connectedPeers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startAdvertisment {
    self.advertiser =
    [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerID
                                      discoveryInfo:nil
                                        serviceType:JukeBoxServiceType];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
}

- (void)startBrowsing {
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myPeerID serviceType:JukeBoxServiceType];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
}
#pragma mark - MCSessionDelegate

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    
    if (![self.connectedPeers indexOfObject:peerID]) {
        MCSession *session = [[MCSession alloc] initWithPeer:self.myPeerID
                                            securityIdentity:nil
                                        encryptionPreference:MCEncryptionNone];
        session.delegate = self;
        
        [self.connectedPeers addObject:peerID];
        invitationHandler(YES, session);
    }
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    [self.mutablePeers addObject:peerID];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPeersDidChangeNotification object:nil];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    [self.mutablePeers removeObject:peerID];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPeersDidChangeNotification object:nil];
}

- (NSArray *)peers {
    return _mutablePeers;
}
@end
