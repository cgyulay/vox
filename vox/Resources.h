//
//  Resources.h
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const int IMAGE_OFFSET_SPEED;
extern const double ANIMATION_DURATION;
extern const float IMAGE_HEIGHT;
extern const float TRANSITION_SPEED;
extern const float LEADING_PADDING;
extern const float NAVIGATION_BAR_HEIGHT;

// Transparent nav bar
typedef NS_ENUM(NSInteger, TransparentNavigationBarStyle) {
    TransparentNavigationBarStyleDefault,
    TransparentNavigationBarStyleArticle
};

@protocol ArticleViewDelegate
- (void)dismissArticle;
@end

@protocol SearchViewDelegate
- (void)dismissSearch;
@end

@protocol ExploreViewDelegate
- (void)dismissExplore;
@end

@protocol ShareButtonDelegate
- (void)presentShareOverlay;
- (void)dismissShareOverlay;
@end

@interface Resources : NSObject

+ (NSArray *)wordWrapText:(NSString *)text forWidth:(CGFloat)width;

+ (UIColor *)cYellow;

+ (UIFont *)articleFont;
+ (UIFont *)articleFontSmall;
+ (UIFont *)titleFont;
+ (UIFont *)authorFont;
+ (UIFont *)searchFont;

@end
