//
//  MultilineHighlightedLabel.m
//  vox
//
//  Created by Colton Gyulay on 3/11/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "MultilineHighlightedLabel.h"
#import "Resources.h"

@interface MultilineHighlightedLabel ()

@end

@implementation MultilineHighlightedLabel

- (void)formatForText:(NSString *)text width:(CGFloat)width {
    self.text = text;
    [self layoutTextForWidth:width];
}

- (void)layoutTextForWidth:(CGFloat)width {
    // Find all " " locations
    NSMutableArray *locations = [NSMutableArray new];
    NSRange searchRange = NSMakeRange(0, self.text.length);
    NSRange foundRange;
    while (searchRange.location < self.text.length) {
        searchRange.length = self.text.length-searchRange.location;
        foundRange = [self.text rangeOfString:@" " options:0 range:searchRange];
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.text];
    [title addAttribute:NSFontAttributeName value:[Resources titleFont] range:NSMakeRange(0, self.text.length)];
    for (int i = 0; i < locations.count; i++) {
        NSInteger prevLocation = i > 0 ? [[locations objectAtIndex:i-1] integerValue] : 0;
        NSInteger location = [[locations objectAtIndex:i] integerValue];
        NSRange range = NSMakeRange(start, location - start);
        
        CGRect substringRect = [self boundingRectForCharacterRange:range string:title];
        
        if (substringRect.size.width > width) {
            [lines addObject:[self.text substringWithRange:NSMakeRange(start, prevLocation - start)]];
            start = prevLocation + 1;
            i--;
        }
    }
    [lines addObject:[self.text substringWithRange:NSMakeRange(start, self.text.length - start)]];
    NSLog(@"%@", lines);
    
    // Create highlighted label for each line
    
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range string:(NSAttributedString *)text {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:text];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    // Convert the range for glyphs
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
