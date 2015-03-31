//
//  ArticleViewController.h
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ArticleTitleView.h"
#import "TransparentNavigationBarView.h"
#import "Resources.h"
#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController

@property (strong, nonatomic) TransparentNavigationBarView *navigationBar;
@property (strong, nonatomic) ArticleTitleView *articleTitleView;
@property (weak, nonatomic) id<ArticleViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author image:(UIImage *)image;

@end
