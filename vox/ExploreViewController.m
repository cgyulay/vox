//
//  ExploreViewController.m
//  vox
//
//  Created by Colton Gyulay on 3/12/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ExploreViewController.h"
#import "UIButton+Extensions.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (void)dismiss {
    [self.delegate dismissExplore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.xButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10.0, -10.0, -10.0, -10.0);
    [self.xButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
