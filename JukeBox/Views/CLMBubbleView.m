//
//  CLMBubbleView.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/14/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMBubbleView.h"

@interface CLMBubbleView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *animationImageView;
@end
@implementation CLMBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        self.animationImageView = [[UIImageView alloc] initWithFrame:frame];
        [self loadRecordingAnimation];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.image = [UIImage imageNamed:@"recordButton.png"];
    self.animationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.imageView];
    [self addSubview:self.animationImageView];
    [self loadRecordingAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rand()%3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animationImageView startAnimating];
    });
    
}

- (void)loadRecordingAnimation
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 40; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Recording_000%02d", i]];
        [images addObject:image];
    }
    
    self.animationImageView.animationImages = images;
    self.animationImageView.animationRepeatCount = -1;
    self.animationImageView.animationDuration = 2;
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
