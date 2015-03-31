//
//  ExploreViewController.h
//  vox
//
//  Created by Colton Gyulay on 3/12/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "Resources.h"
#import <UIKit/UIKit.h>

@interface ExploreViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *xButton;
@property (weak, nonatomic) id<ExploreViewDelegate> delegate;

@end
