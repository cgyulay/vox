//
//  Resources.m
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "Resources.h"

static UIColor * cYellow;
const int IMAGE_OFFSET_SPEED = 25;
const double ANIMATION_DURATION = 0.3;
const float IMAGE_HEIGHT = 350;
const float TRANSITION_SPEED = 0.4;
const float LEADING_PADDING = 16.0;
const float NAVIGATION_BAR_HEIGHT = 54.0;

@implementation Resources

+ (void)initialize {
    if (self == [Resources class]) {
        cYellow = [UIColor colorWithRed:255/255.0f green:242/255.0f blue:0/255.0f alpha:1];
    }
}

+ (UIColor *)cYellow { return cYellow; }

+ (UIFont *)articleFont { return [UIFont fontWithName:@"AlrightSans-Regular" size:16.0]; } // Alright
+ (UIFont *)articleFontSmall { return [UIFont fontWithName:@"AlrightSans-RegularItalic" size:12.0]; } // Alright
+ (UIFont *)titleFont { return [UIFont fontWithName:@"CopyrightTypeSupply" size:28.0]; } // Balto
+ (UIFont *)authorFont { return [UIFont fontWithName:@"WebtypeWebUseOnly" size:18.0]; } // Harriet
+ (UIFont *)searchFont { return [UIFont fontWithName:@"AlrightSans-Regular" size:18.0]; } // Alright

+ (NSArray *)wordWrapText:(NSString *)text forWidth:(CGFloat)width {
    text = [text stringByAppendingString:@" "];
    
    // Find all " " locations
    NSMutableArray *locations = [NSMutableArray new];
    NSRange searchRange = NSMakeRange(0, text.length);
    NSRange foundRange;
    while (searchRange.location < text.length) {
        searchRange.length = text.length-searchRange.location;
        foundRange = [text rangeOfString:@" " options:0 range:searchRange];
        if (foundRange.location != NSNotFound) {
            searchRange.location = foundRange.location + foundRange.length;
            [locations addObject:@(foundRange.location)];
        } else {
            break;
        }
    }
    
    // Create substring with each location to find longest possible word-wrapped string for each line
    // subArrayWithRange
    NSMutableArray *lines = [NSMutableArray new];
    NSInteger start = 0;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:text];
    [title addAttribute:NSFontAttributeName value:[Resources titleFont] range:NSMakeRange(0, text.length)];
    for (int i = 0; i < locations.count; i++) {
        NSInteger prevLocation = i > 0 ? [[locations objectAtIndex:i-1] integerValue] : 0;
        NSInteger location = [[locations objectAtIndex:i] integerValue];
        NSRange range = NSMakeRange(start, location - start);
        
        CGRect substringRect = [Resources boundingRectForCharacterRange:range string:title];
        // NSLog(@"width: %f of substring: %@", substringRect.size.width, [text substringWithRange:NSMakeRange(start, location - start)]);
        
        if (substringRect.size.width > width) {
            // NSLog(@"%lu, %lu", range.location, range.length);
            [lines addObject:[text substringWithRange:NSMakeRange(start, prevLocation - start)]];
            start = prevLocation + 1;
            i--;
        }
    }
    [lines addObject:[text substringWithRange:NSMakeRange(start, text.length - start - 1)]];
    return lines;
}

+ (CGRect)boundingRectForCharacterRange:(NSRange)range string:(NSAttributedString *)text {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:text];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    CGSize bounds = [UIScreen mainScreen].bounds.size;
    bounds.width -= LEADING_PADDING * 2 - 1.0;
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:bounds];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    // Convert the range for glyphs
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

@end
