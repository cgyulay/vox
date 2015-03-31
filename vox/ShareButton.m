//
//  ShareButton.m
//  vox
//
//  Created by Colton Gyulay on 3/11/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ShareButton.h"
#import <pop/POP.h>

@interface ShareButton()

@property (assign, nonatomic) BOOL isShowingButtons;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIView *overlay;
@property (strong, nonatomic) NSMutableArray *shareButtons;

@end

@implementation ShareButton

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *shareImage = [UIImage imageNamed:@"share-button"];
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, shareImage.size.width, shareImage.size.height)];
        [self.shareButton setImage:shareImage forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(sharePressed) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGFloat width = self.shareButton.frame.size.width;
        CGFloat height = width * 4;
        self.frame = CGRectMake(bounds.size.width - LEADING_PADDING - width, bounds.size.height - LEADING_PADDING - height, width, height);
        self.shareButton.frame = CGRectMake(0.0, self.frame.size.height - self.shareButton.frame.size.height, width, self.shareButton.frame.size.height);
        [self addDropShadowToView:self.shareButton];
        
        [self addSubview:self.overlay];
        [self layoutShareButtons];
        [self addSubview:self.shareButton];
    }
    return self;
}

- (void)layoutShareButtons {
    self.shareButtons = [NSMutableArray new];
    NSArray *imageNames = [NSArray arrayWithObjects:@"share-messages", @"share-fb", @"share-twitter", @"share-email", @"share-more", nil];
    
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:imageName];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
        [button setImage:image forState:UIControlStateNormal];
        button.center = self.shareButton.center;
        [self addDropShadowToView:button];
        
        [self addSubview:button];
        [self.shareButtons addObject:button];
    }
}

- (void)sharePressed {
    if (self.isShowingButtons) {
        CGFloat targetY = self.shareButton.center.y - 8;
        for (UIButton *button in self.shareButtons) {
            POPSpringAnimation *move = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            move.toValue = [NSNumber numberWithFloat:targetY];
            move.springBounciness = 7;
            move.springSpeed = 5.0;
            [button.layer pop_addAnimation:move forKey:@"position"];
        }
        
        [UIView transitionWithView:self.shareButton duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.shareButton setImage:[UIImage imageNamed:@"share-button"] forState:UIControlStateNormal];
        } completion:nil];
        
        [self.delegate dismissShareOverlay];
        self.isShowingButtons = NO;
    } else {
        self.isShowingButtons = YES;
        [self.delegate presentShareOverlay];
        
        [UIView transitionWithView:self.shareButton duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.shareButton setImage:[UIImage imageNamed:@"share-close"] forState:UIControlStateNormal];
        } completion:nil];
        
        CGFloat initialY = self.shareButton.center.y;
        for (int i = 0; i < self.shareButtons.count; i++) {
            UIButton *button = [self.shareButtons objectAtIndex:i];
            CGFloat targetY = initialY - 10 - ((self.shareButton.frame.size.height - 5) * (i + 1));
            
            POPSpringAnimation *move = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            move.toValue = [NSNumber numberWithFloat:targetY];
            move.springBounciness = 7;
            move.springSpeed = 5.0;
            [button.layer pop_addAnimation:move forKey:@"position"];
        }
    }
}

- (void)addDropShadowToView:(UIView *)view {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 3);
    view.layer.shadowOpacity = 0.75;
    view.layer.shadowRadius = 3.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
