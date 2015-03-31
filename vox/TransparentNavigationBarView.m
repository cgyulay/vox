//
//  TransparentNavigationBarView.m
//  vox
//
//  Created by Colton Gyulay on 3/9/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "TransparentNavigationBarView.h"
#import "UIButton+Extensions.h"
#import "PureLayout.h"

@interface TransparentNavigationBarView ()

@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *gradientView;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIImageView *logoImageView;

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (assign, nonatomic) TransparentNavigationBarStyle style;

@property (nonatomic, copy) ButtonPressedBlock leftBlock;
@property (nonatomic, copy) ButtonPressedBlock rightBlock;

@end

@implementation TransparentNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        
        // Nav bar shadow and gradient
        self.shadowView = [[UIView alloc] initWithFrame:CGRectZero];
        self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        self.shadowView.alpha = 0.6;
        
        self.gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0, NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, 134.0)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.gradientView.bounds; // Need the height ahead of time to calculate gradient
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [self.gradientView.layer insertSublayer:gradient atIndex:0];
        self.gradientView.alpha = 0.6;
        
        // Buttons + titles
        self.leftButton = [UIButton new];
        self.leftButton.center = CGPointMake(35.0, 35.0); // Set buttons to generally correct place to smooth animation
        [self.leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.leftButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10.0, -10.0, -10.0, -10.0);
        // [self.leftButton setShowsTouchWhenHighlighted:YES];
        
        self.rightButton = [UIButton new];
        self.rightButton.center = CGPointMake(frame.size.width, 35.0);
        [self.rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10.0, -10.0, -10.0, -10.0);
        // [self.rightButton setShowsTouchWhenHighlighted:YES];
        
        self.logoImageView = [UIImageView new];
        self.style = TransparentNavigationBarStyleDefault;
        
        [self addSubview:self.shadowView];
        [self addSubview:self.gradientView];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.logoImageView];
        
        [self updateConstraints];
    }
    return self;
}

#pragma mark - Constraints

- (void)updateConstraints {
    [super updateConstraints];
    if (!self.didSetupConstraints) {
        [self.shadowView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.gradientView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self];
        [self.gradientView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.gradientView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.leftButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LEADING_PADDING];
        [self.leftButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.rightButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:LEADING_PADDING];
        [self.rightButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.logoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.logoImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
}

#pragma mark - Style transition

- (void)transitionButton:(UIButton *)button toImage:(UIImage *)image duration:(NSTimeInterval)duration {
    [UIView transitionWithView:button duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, image.size.width, image.size.height);
        [button setImage:image forState:UIControlStateNormal];
    } completion:nil];
}

#pragma mark - Setters

- (void)setStyle:(TransparentNavigationBarStyle)style {
    [self setStyle:style animated:NO];
}

- (void)setStyle:(TransparentNavigationBarStyle)style animated:(BOOL)animated {
    _style = style;
    
    NSTimeInterval duration = animated ? TRANSITION_SPEED : 0.0;
    switch (_style) {
        case TransparentNavigationBarStyleArticle: {
            UIImage *back = [UIImage imageNamed:@"icon-back-arrow"];
            [self transitionButton:self.leftButton toImage:back duration:duration];
            
            UIImage *bookmark = [UIImage imageNamed:@"icon-bookmark"];
            [self transitionButton:self.rightButton toImage:bookmark duration:duration];
            
            [UIView animateWithDuration:duration animations:^{
                self.logoImageView.alpha = 0.0;
            }];
        } break;
        
        case TransparentNavigationBarStyleDefault: default: {
            UIImage *search = [UIImage imageNamed:@"icon-search"];
            [self transitionButton:self.leftButton toImage:search duration:duration];
            
            UIImage *explore = [UIImage imageNamed:@"icon-explore"];
            [self transitionButton:self.rightButton toImage:explore duration:duration];
            
            UIImage *logo = [UIImage imageNamed:@"vox-logo"];
            self.logoImageView.frame = CGRectMake(0.0, 0.0, logo.size.width, logo.size.height);
            self.logoImageView.image = logo;
            
            [UIView animateWithDuration:duration animations:^{
                self.logoImageView.alpha = 1.0;
            }];
        } break;
    }
}

- (void)setGradientOpacity:(CGFloat)alpha {
    if (alpha > 0.6) alpha = 0.6;
    
    self.gradientView.alpha = alpha;
    self.shadowView.alpha = alpha;
}

#pragma mark - Button presses

- (void)leftButtonPressed {
    self.leftBlock();
}

- (void)rightButtonPressed {
    self.rightBlock();
}

- (void)leftButtonPressed:(ButtonPressedBlock)left right:(ButtonPressedBlock)right {
    self.leftBlock = left;
    self.rightBlock = right;
}

@end
