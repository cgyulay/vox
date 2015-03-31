//
//  ArticleTableViewCell.m
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "Resources.h"
#import "PureLayout.h"

@interface ArticleTableViewCell()

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) ArticleTitleView *body;

@end

@implementation ArticleTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    // self.body = [ArticleTitleView view];
    self.contentView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.body];
    self.body.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f));
    NSLog(@"%@", NSStringFromCGRect(self.contentView.bounds));
    NSLog(@"%@", NSStringFromCGRect(self.body.frame));
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (!self.didSetupConstraints) {
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.body autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.body autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
        
        self.didSetupConstraints = YES;
    }
}

- (NSString *)reuseIdentifier {
    return @"ArticleTableViewCell";
}

@end
