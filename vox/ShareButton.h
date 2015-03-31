//
//  ShareButton.h
//  vox
//
//  Created by Colton Gyulay on 3/11/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "Resources.h"
#import <UIKit/UIKit.h>

@interface ShareButton : UIView

@property (weak, nonatomic) id<ShareButtonDelegate> delegate;

@end
