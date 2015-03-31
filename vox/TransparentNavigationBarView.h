//
//  TransparentNavigationBarView.h
//  vox
//
//  Created by Colton Gyulay on 3/9/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "Resources.h"
#import <UIKit/UIKit.h>

typedef void (^ButtonPressedBlock)();

@interface TransparentNavigationBarView : UIView

- (void)setStyle:(TransparentNavigationBarStyle)style animated:(BOOL)animated;
- (void)leftButtonPressed:(ButtonPressedBlock)left right:(ButtonPressedBlock)right;
- (void)setGradientOpacity:(CGFloat)alpha;

@end
