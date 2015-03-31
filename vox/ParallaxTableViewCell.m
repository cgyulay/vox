//
//  ParallaxTableViewCell.m
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ParallaxTableViewCell.h"
#import "PureLayout.h"

@interface ParallaxTableViewCell ()

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) UIView *separator;

@end

@implementation ParallaxTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) self.clipsToBounds = YES;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) self.clipsToBounds = YES;
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        
        self.articleTitleView = [ArticleTitleView new];
        [self.contentView addSubview:self.articleTitleView];
        
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        self.separator.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.separator];
        
        [self updateConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateConstraints {
    [super updateConstraints];
    if (!self.didSetupConstraints) {
        [self.articleTitleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        // [self.separator autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        // [self.separator autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        // [self.separator autoPinEdgeToSuperviewEdge:ALEdgeRight];
        // [self.separator autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        self.didSetupConstraints = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier {
    return @"Parallax";
}

- (void)prepareForReuse {
    self.articleTitleView.titleText = @"";
}

@end
