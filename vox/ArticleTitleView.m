//
//  ArticleTitleView.m
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ArticleTitleView.h"
#import "Resources.h"
#import "MultilineHighlightedLabel.h"
#import "PureLayout.h"

@interface ArticleTitleView ()

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) NSMutableArray *titleLabels;

@property (strong, nonatomic) UILabel *titleLabel1;
@property (strong, nonatomic) UILabel *titleLabel2;
@property (strong, nonatomic) UILabel *titleLabel3;

@end

@implementation ArticleTitleView

+ (instancetype)view {
    ArticleTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"ArticleTitleView" owner:nil options:nil] lastObject];
    
    if ([view isKindOfClass:[ArticleTitleView class]]) {
        return view;
    } else {
        return nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
        self.imageView.backgroundColor = [UIColor redColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = NO;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.numberOfLines = 1;
        // self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font = [Resources titleFont];
        self.titleLabel.text = @"the hero";
        
        self.titleLabel1 = [UILabel new];
        self.titleLabel1.textColor = [UIColor whiteColor];
        self.titleLabel1.numberOfLines = 1;
        self.titleLabel1.font = [Resources titleFont];
        
        self.titleLabel2 = [UILabel new];
        self.titleLabel2.textColor = [UIColor whiteColor];
        self.titleLabel2.numberOfLines = 1;
        self.titleLabel2.font = [Resources titleFont];
        
        self.titleLabel3 = [UILabel new];
        self.titleLabel3.textColor = [UIColor whiteColor];
        self.titleLabel3.numberOfLines = 1;
        self.titleLabel3.font = [Resources titleFont];
        
        self.authorLabel = [UILabel new];
        self.authorLabel.textColor = [UIColor whiteColor];
        self.authorLabel.font = [Resources authorFont];
        
//        self.titleLabels = [NSMutableArray new];
//        for (int i = 0; i < 4; i++) {
//            UILabel *label = [UILabel new];
//            label.textColor = [UIColor whiteColor];
//            label.font = [Resources titleFont];
//            label.text = @"some text here";
//            [self.titleLabels addObject:label];
//            [self addSubview:label];
//        }
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.titleLabel1];
        [self addSubview:self.titleLabel2];
        [self addSubview:self.titleLabel3];
        [self addSubview:self.authorLabel];
        
        [self updateConstraints];
    }
    return self;
}

#pragma mark - Constraints and formatting

- (void)updateConstraints {
    [super updateConstraints];
    if (!self.didSetupConstraints) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        insets.bottom = -30;
        [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:insets];
        
        [self.authorLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:LEADING_PADDING];
        [self.authorLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-LEADING_PADDING];
        [self.authorLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-LEADING_PADDING];
        
//        for (int i = 0; i < self.titleLabels.count; i++) {
//            UILabel *label = [self.titleLabels objectAtIndex:i];
//            UILabel *prevLabel = i > 0 ? [self.titleLabels objectAtIndex:i-1] : self.authorLabel;
//            
//            [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:LEADING_PADDING];
//            [label autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-LEADING_PADDING];
//            [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:prevLabel withOffset:-LEADING_PADDING];
//        }
        
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:LEADING_PADDING];
        [self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-LEADING_PADDING];
        [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.authorLabel withOffset:-LEADING_PADDING];
        
        [self.titleLabel1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:LEADING_PADDING];
        [self.titleLabel1 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-LEADING_PADDING];
        [self.titleLabel1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.titleLabel withOffset:-4];
        
        [self.titleLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:LEADING_PADDING];
        [self.titleLabel2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-LEADING_PADDING];
        [self.titleLabel2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.titleLabel1 withOffset:-4];
        
        [self.titleLabel3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:LEADING_PADDING];
        [self.titleLabel3 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-LEADING_PADDING];
        [self.titleLabel3 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.titleLabel2 withOffset:-4];
        
        self.didSetupConstraints = YES;
    }
}

- (void)formatText {
    // MultilineHighlightedLabel *label = [[MultilineHighlightedLabel alloc] init];
    // [label formatForText:self.titleLabel.text width:[UIScreen mainScreen].bounds.size.width - 2 * LEADING_PADDING];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [title addAttribute:NSBackgroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    self.titleLabel.attributedText = title;
    
    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:self.titleLabel1.text];
    [title1 addAttribute:NSBackgroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title1.length)];
    self.titleLabel1.attributedText = title1;
    
    if (self.titleLabel2.text) {
        NSMutableAttributedString *title2 = [[NSMutableAttributedString alloc] initWithString:self.titleLabel2.text];
        [title2 addAttribute:NSBackgroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title2.length)];
        self.titleLabel2.attributedText = title2;
    }
    if (self.titleLabel3.text) {
        NSMutableAttributedString *title3 = [[NSMutableAttributedString alloc] initWithString:self.titleLabel3.text];
        [title3 addAttribute:NSBackgroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title3.length)];
        self.titleLabel3.attributedText = title3;
    }
    
    NSMutableAttributedString *author = [[NSMutableAttributedString alloc] initWithString:self.authorLabel.text];
    [author addAttribute:NSBackgroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, author.length)];
    self.authorLabel.attributedText = author;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
    // Store image
    self.imageView.image = image;
    
    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset {
    
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.imageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.imageView.frame = offsetFrame;
    
    if (self.fadesTextAtOffsetZero && _imageOffset.y > 0) {
        CGFloat alpha = 1 - (_imageOffset.y / 15);
        self.titleAlpha = alpha;
        self.authorLabel.alpha = alpha;
    }
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    
    // Yiikes
    NSArray *lines = [Resources wordWrapText:titleText forWidth:[UIScreen mainScreen].bounds.size.width - 2 * LEADING_PADDING];
    if (lines.count == 1) {
        self.titleLabel.text = [lines objectAtIndex:0];
        self.titleLabel1.text = @"";
        self.titleLabel2.text = @"";
        self.titleLabel3.text = @"";
    } else if (lines.count == 2) {
        self.titleLabel.text = [lines objectAtIndex:1];
        self.titleLabel1.text = [lines objectAtIndex:0];
        self.titleLabel2.text = @"";
        self.titleLabel3.text = @"";
    } else if (lines.count == 3) {
        self.titleLabel.text = [lines objectAtIndex:2];
        self.titleLabel1.text = [lines objectAtIndex:1];
        self.titleLabel2.text = [lines objectAtIndex:0];
        self.titleLabel3.text = @"";
    } else if (lines.count == 4) {
        self.titleLabel.text = [lines objectAtIndex:3];
        self.titleLabel1.text = [lines objectAtIndex:2];
        self.titleLabel2.text = [lines objectAtIndex:1];
        self.titleLabel3.text = [lines objectAtIndex:0];
    }
}

- (void)setTitleAlpha:(CGFloat)titleAlpha {
    _titleAlpha = titleAlpha;
    
    self.titleLabel.alpha = _titleAlpha;
    self.titleLabel1.alpha = _titleAlpha;
    self.titleLabel2.alpha = _titleAlpha;
    self.titleLabel3.alpha = _titleAlpha;
}

@end
