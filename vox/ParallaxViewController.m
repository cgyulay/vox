//
//  ParallaxViewController.m
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ParallaxViewController.h"
#import "ParallaxTableViewCell.h"
#import "TallParallaxTableViewCell.h"
#import "ArticleViewController.h"
#import "SearchViewController.h"
#import "ExploreViewController.h"
#import "TransparentNavigationBarView.h"
#import "UIImage+ImageEffects.h"
#import "PureLayout.h"

@interface ParallaxViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ArticleViewDelegate, SearchViewDelegate, ExploreViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TransparentNavigationBarView *navigationBar;

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *authors;
@property (assign, nonatomic) NSInteger currentCellIndex;

// Transition to article
@property (strong, nonatomic) UIImageView *bottomImage;
@property (strong, nonatomic) ArticleViewController *articleViewController;
@property (assign, nonatomic) CGRect initialContentRect;
@property (assign, nonatomic) CGRect initialArticleFrame;
@property (assign, nonatomic) CGRect initialBottomImageFrame;
@property (assign, nonatomic) CGPoint initialImageOffset;
@property (assign, nonatomic) BOOL isShowingArticle;
@property (assign, nonatomic) float screenScale;

// Search + explore
@property (strong, nonatomic) SearchViewController *searchViewController;
@property (strong, nonatomic) ExploreViewController *exploreViewController;
@property (strong, nonatomic) UIImageView *blurImageView;

@property (assign, nonatomic) BOOL centering;

@end

@implementation ParallaxViewController {
    NSIndexPath *selectedIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Track retina vs non
    self.screenScale = [[UIScreen mainScreen] scale];

    // Populate data
    self.currentCellIndex = 0;
    self.images = [NSMutableArray new];
    [self populateData];
    [self populateData];
    [self populateData];
    
    self.tableView.pagingEnabled = NO;
    [self.tableView registerClass:[ParallaxTableViewCell class] forCellReuseIdentifier:@"Parallax"];
    [self.tableView registerClass:[TallParallaxTableViewCell class] forCellReuseIdentifier:@"TallParallax"];
    [self.tableView reloadData];
    
    self.navigationBar = [[TransparentNavigationBarView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, NAVIGATION_BAR_HEIGHT)];
    [self.view addSubview:self.navigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Popular data

- (void)populateData {
    for (NSUInteger index = 1; index < 9; ++index) {
        NSString *name = [NSString stringWithFormat:@"%ld.jpg", (unsigned long)index];
        [self.images addObject:name];
    }
    
    self.titles = [NSMutableArray arrayWithObjects:@"The government is the one reason the US has more inequality than Sweden", @"The media is talking a lot about email, and not much about the stakes in 2016", @"Why do so many rich consider themselves \"middle class?\"", @"Here are the states that serve the most local food at school", @"Inside the quiet, state level push to expand abortion rights", @"Which politician looks the most comfortable with puppets?", @"Secretary of Labor Tom Perez on how to fight for social change", @"Giuliani to Obama: Be more like Bill Cosby!", nil];
    
    self.authors = [NSMutableArray arrayWithObjects:@"Dylan Matthews", @"Matthew Yglesias", @"Danielle Kurtzleben", @"Libby Nelson", @"Megan Thielking", @"Phil Edwards", @"Dara Lind", @"Jenée Desmond-Harris", nil];
}

#pragma mark - Navigation bar

- (void)setNavigationBar:(TransparentNavigationBarView *)navigationBar {
    _navigationBar = navigationBar;
    
    [self registerForNavigationBarButtonPresses];
}

- (void)registerForNavigationBarButtonPresses {
    [self.navigationBar leftButtonPressed:^{
        [self presentSearchOverlay];
    } right:^{
        [self presentExploreOverlay];
    }];
}

#pragma mark - UITableView data source + delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.images.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 500 : 350;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // Return tall cell for latestnews
        TallParallaxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TallParallax" forIndexPath:indexPath];
        CGFloat yOffset = ((self.tableView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        cell.imageOffset = CGPointMake(0.0, yOffset);
        
        return cell;
    }
    
    ParallaxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Parallax" forIndexPath:indexPath];
    NSInteger index = indexPath.item - 1;
    NSString *imageName = [self.images objectAtIndex:index];
    cell.articleTitleView.image = [UIImage imageNamed:imageName];
    
    NSString *title = [self.titles objectAtIndex:index % 8];
    cell.articleTitleView.titleText = title;
    
    NSString *author = [self.authors objectAtIndex:index % 8];
    cell.articleTitleView.authorLabel.text = author;
    
    CGFloat yOffset = ((self.tableView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.articleTitleView.imageOffset = CGPointMake(0.0, yOffset);
    
    cell.articleTitleView.titleAlpha = 1.0;
    cell.articleTitleView.authorLabel.alpha = 1.0;
    cell.articleTitleView.fadesTextAtOffsetZero = YES;
    [cell.articleTitleView formatText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return;
    
    ParallaxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Parallax" forIndexPath:indexPath];
    CGFloat yOffset = ((self.tableView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    CGPoint imageOffset = CGPointMake(0.0, yOffset);
    
    [self presentArticle:indexPath offset:imageOffset];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (ParallaxTableViewCell *cell in self.tableView.visibleCells) {
        CGFloat yOffset = ((self.tableView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        
        if ([cell respondsToSelector:@selector(articleTitleView)]) {
            cell.articleTitleView.imageOffset = CGPointMake(0.0, yOffset);
        } else {
            ((TallParallaxTableViewCell *)cell).imageOffset = CGPointMake(0.0, yOffset * 2);
        }
    }
}

// Relatively sticky scroll pagination
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    return;
    NSLog(@"current offset: %f, target: %f", self.tableView.contentOffset.y, targetContentOffset->y);
    
    // Bail out if we're at the top or bottom of the table
    // TODO: implement infinite scroll by adding cells
    if (targetContentOffset->y <= 0.0 && self.currentCellIndex == 0) return;
    if (targetContentOffset->y >= scrollView.contentSize.height - scrollView.bounds.size.height) return;
    
    CGFloat v = velocity.y / 2.0; // Dampening
    if (v < 0.2) return;
    // BOOL scrollingDown = self.tableView.contentOffset.y < targetContentOffset->y;
    
    // if (scrollingDown && v < 0.5) v = 0.5;
    // if (!scrollingDown && v >= -0.5) v = -0.5;
    
    NSInteger cellsToTravel = roundf(v);
    if (cellsToTravel > 3) cellsToTravel = 3;
    NSLog(@"cells to travel: %ld", (long)cellsToTravel);
    self.currentCellIndex += cellsToTravel;
    
    if (self.currentCellIndex < 0) self.currentCellIndex = 0;
    targetContentOffset->y = IMAGE_HEIGHT * self.currentCellIndex - (NAVIGATION_BAR_HEIGHT * 2);
    NSLog(@"return: %f", targetContentOffset->y);
}

#pragma mark - Transition to article view

- (void)presentArticle:(NSIndexPath *)indexPath offset:(CGPoint)imageOffset {
    self.isShowingArticle = YES;
    
    // Find the frame of the cell to be presented
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrame = [self.tableView convertRect:rectInTableView toView:self.tableView.superview];
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    // Create and line up the article view with the same origin
    NSInteger index = indexPath.row - 1;
    NSString *title = [self.titles objectAtIndex:index % 8];
    NSString *author = [self.authors objectAtIndex:index % 8];
    UIImage *image = [UIImage imageNamed:[self.images objectAtIndex:index]];
    
    self.articleViewController = [[ArticleViewController alloc] initWithTitle:title author:author image:image];
    self.articleViewController.delegate = self;
    CGRect initialFrame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, bounds.size.width, bounds.size.height);
    self.articleViewController.view.frame = initialFrame;
    self.articleViewController.articleTitleView.imageOffset = imageOffset;
    [self.articleViewController.articleTitleView formatText];
    
    self.initialArticleFrame = initialFrame;
    self.initialImageOffset = imageOffset;
    
    // Screenshot area below the cell, and pull it down to reveal the article's body
    CGRect bottomScreenshotFrame;
    
    if (CGRectGetMaxY(cellFrame) <= bounds.size.height) {
        CGFloat cellFrameMaxY = CGRectGetMaxY(cellFrame);
        bottomScreenshotFrame = CGRectMake(0.0, cellFrameMaxY, bounds.size.width, bounds.size.height - cellFrameMaxY);
        
        UIGraphicsBeginImageContextWithOptions(bottomScreenshotFrame.size, NO, [UIScreen mainScreen].scale);
        [self.view drawViewHierarchyInRect:CGRectMake(0.0, -bottomScreenshotFrame.origin.y, bottomScreenshotFrame.size.width, bounds.size.height) afterScreenUpdates:NO];
        self.bottomImage = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
    }
    
    // Place screenshot
    [self.view insertSubview:self.bottomImage belowSubview:self.navigationBar];
    [self.view insertSubview:self.articleViewController.view aboveSubview:self.tableView];
    self.bottomImage.frame = bottomScreenshotFrame;
    self.initialBottomImageFrame = bottomScreenshotFrame;
    
    // Calculate vertical scroll offset
    CGFloat yOffset = self.tableView.contentOffset.y;
    CGFloat lengthToScroll = initialFrame.origin.y;
    if (initialFrame.origin.y < 0.0) lengthToScroll = -lengthToScroll;
    self.initialContentRect = CGRectMake(0.0, yOffset, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    CGRect targetRect = CGRectOffset(self.initialContentRect, 0.0, lengthToScroll);
    
    // Animate
    [self.navigationBar setStyle:TransparentNavigationBarStyleArticle animated:YES];
    [self.articleViewController.navigationBar setStyle:TransparentNavigationBarStyleArticle animated:NO];
    [UIView animateWithDuration:TRANSITION_SPEED delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tableView scrollRectToVisible:targetRect animated:NO];
        self.bottomImage.frame = CGRectOffset(self.bottomImage.frame, 0.0, bounds.size.height);
        
        self.articleViewController.view.frame = bounds;
        self.articleViewController.articleTitleView.imageOffset = CGPointZero;
    } completion:^(BOOL completed) {
        // Add navigation bar ownership to articleViewController as well
        self.articleViewController.navigationBar = self.navigationBar;
    }];
}

#pragma mark - ArticleView delegate

- (void)dismissArticle {
    // Animate
    [self.navigationBar setStyle:TransparentNavigationBarStyleDefault animated:YES];
    [UIView animateWithDuration:TRANSITION_SPEED delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tableView scrollRectToVisible:self.initialContentRect animated:NO];
        self.bottomImage.frame = self.initialBottomImageFrame;
        
        self.articleViewController.view.frame = self.initialArticleFrame;
        self.articleViewController.articleTitleView.imageOffset = self.initialImageOffset;
    } completion:^(BOOL completed) {
        // Remove navigation bar ownership from article
        self.articleViewController.navigationBar = nil;
        [self.articleViewController.view removeFromSuperview];
        self.articleViewController = nil;
        [self registerForNavigationBarButtonPresses];
        
        [self.bottomImage removeFromSuperview];
    }];
    
    self.isShowingArticle = NO;
}

#pragma mark - Search delegate

- (void)dismissSearch {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.blurImageView.alpha = 0.0;
        self.searchViewController.view.alpha = 0.0;
    } completion:^(BOOL completed) {
        [self.searchViewController.view removeFromSuperview];
        self.searchViewController = nil;
    }];
}

#pragma mark - Explore delegate

- (void)dismissExplore {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.blurImageView.alpha = 0.0;
        self.exploreViewController.view.alpha = 0.0;
    } completion:^(BOOL completed) {
        [self.exploreViewController.view removeFromSuperview];
        self.exploreViewController = nil;
    }];
}

#pragma mark - Blur overlay

- (void)presentSearchOverlay {
    CGRect bounds = [UIScreen mainScreen].bounds;
    [self takeScreenshot];
    [self.view addSubview:self.blurImageView];
    
    // Create search view
    self.searchViewController = [[SearchViewController alloc] init];
    self.searchViewController.delegate = self;
    [self.view addSubview:self.searchViewController.view];
    self.searchViewController.view.alpha = 0.0;
    self.searchViewController.view.frame = bounds;
    
    // Present
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.blurImageView.alpha = 1.0;
        self.searchViewController.view.alpha = 1.0;
    }];
}

- (void)presentExploreOverlay {
    CGRect bounds = [UIScreen mainScreen].bounds;
    [self takeScreenshot];
    [self.view addSubview:self.blurImageView];
    
    // Instantiate from storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.exploreViewController = [storyboard instantiateViewControllerWithIdentifier:@"Explore"];
    self.exploreViewController.delegate = self;
    [self.view addSubview:self.exploreViewController.view];
    self.exploreViewController.view.alpha = 0.0;
    self.exploreViewController.view.frame = bounds;
    
    // Present
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.blurImageView.alpha = 1.0;
        self.exploreViewController.view.alpha = 1.0;
    }];
}

- (void)takeScreenshot {
    // Take screenshot
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height) afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create blurred image view
    self.blurImageView = [[UIImageView alloc] initWithFrame:bounds];
    self.blurImageView.image = [image applyBlurWithRadius:18 tintColor:[UIColor colorWithWhite:0.1 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];
    self.blurImageView.alpha = 0.0;
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
