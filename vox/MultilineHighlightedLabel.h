//
//  MultilineHighlightedLabel.h
//  vox
//
//  Created by Colton Gyulay on 3/11/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultilineHighlightedLabel : UIView

@property (copy, nonatomic) NSString *text;

- (void)formatForText:(NSString *)text width:(CGFloat)width;

@end
