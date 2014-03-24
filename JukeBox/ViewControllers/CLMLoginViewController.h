//
//  CLMLoginViewController.h
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CLMLoginViewControllerDelegate;

@interface CLMLoginViewController : UIViewController

@property (nonatomic, weak) id<CLMLoginViewControllerDelegate> delegate;
@end

@protocol  CLMLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin;
- (void)loginViewControllerDidSkip;

@end