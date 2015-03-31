//
//  TallParallaxTableViewCell.m
//  vox
//
//  Created by Colton Gyulay on 3/12/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "TallParallaxTableViewCell.h"
#import "PureLayout.h"

@interface TallParallaxTableViewCell()

@property (assign, nonatomic) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *textImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIView *separator;

@end

@implementation TallParallaxTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"latest_bg"]];
        [self.contentView addSubview:self.backgroundImageView];
        
        self.textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"latest_overlay"]];
        [self.contentView addSubview:self.textImageView];
        

        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        self.separator.backgroundColor = [UIColor whiteColor];
        // [self.contentView addSubview:self.separator];
        
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    if (!self.didSetupConstraints) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        insets.bottom = -30;
        [self.backgroundImageView autoPinEdgesToSuperviewEdgesWithInsets:insets];
        
        [self.textImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageOffset:(CGPoint)imageOffset {
    
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.backgroundImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.backgroundImageView.frame = offsetFrame;
    
    CGFloat alpha = 1 - (_imageOffset.y / 60);
    self.textImageView.alpha = alpha;
}

- (NSString *)reuseIdentifier {
    return @"TallParallax";
}

@end
