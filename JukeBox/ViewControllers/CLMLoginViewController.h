//
//  CLMLoginViewController.h
//  Jukebox
//
//  Created by Phillip Jacobs on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLMLoginViewControllerDelegate;

@interface CLMLoginViewController : UIViewController

@property (nonatomic, weak) id<CLMLoginViewControllerDelegate> delegate;
@property (nonatomic, strong) UIWebView *webView;

@end

@protocol CLMLoginViewControllerDelegate <NSObject>

@end
