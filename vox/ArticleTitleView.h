//
//  ArticleTitleView.h
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "HighlightLabel.h"
#import <UIKit/UIKit.h>

@interface ArticleTitleView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorLabel;

@property (copy, nonatomic) NSString *titleText;
@property (assign, nonatomic) CGFloat titleAlpha;

@property (assign, nonatomic) BOOL fadesTextAtOffsetZero;
@property (weak, nonatomic, readwrite) UIImage *image;
@property (assign, nonatomic, readwrite) CGPoint imageOffset;

- (void)formatText;
// + (instancetype)view;

@end
