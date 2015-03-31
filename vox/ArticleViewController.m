//
//  ArticleViewController.m
//  vox
//
//  Created by Colton Gyulay on 3/5/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "ArticleViewController.h"
#import "ShareButton.h"
#import "PureLayout.h"
#import "UIImage+ImageEffects.h"
#import "UIView+GradientMask.h"
@import QuartzCore;

#define HEADER_INIT_FRAME CGRectMake(0, 0, self.view.frame.size.width, IMAGE_HEIGHT)

const CGFloat kBackgroundParallexFactor = 0.0;
const CGFloat kBlurFadeInFactor = 0.005;
const CGFloat kTextFadeOutFactor = 0.05;
const CGFloat kCommentCellHeight = 50.0;

@interface ArticleViewController () <UIScrollViewDelegate, ShareButtonDelegate>

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) ShareButton *shareButton;
@property (strong, nonatomic) UIView *overlay;
@property (strong, nonatomic) UILabel *articleTitleLabel;

@end

@implementation ArticleViewController {
    UIScrollView *_mainScrollView;
    UIScrollView *_backgroundScrollView;
    UITextView *_articleTextView;
    UIImageView *_blurImageView;
    UIScrollView *_articleViewContainer;
    
    // UILabel *_textLabel;
    // UIImageView *_imageView;
    
    // TODO: Implement these
    UIGestureRecognizer *_leftSwipeGestureRecognizer;
    UIGestureRecognizer *_rightSwipeGestureRecognizer;
}

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author image:(UIImage *)image {
    self = [super init];
    if (self) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = YES;
        _mainScrollView.alwaysBounceVertical = YES;
        _mainScrollView.contentSize = CGSizeZero;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0);
        [self.view addSubview:_mainScrollView];
        
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:HEADER_INIT_FRAME];
        _backgroundScrollView.scrollEnabled = NO;
        _backgroundScrollView.contentSize = CGSizeMake(320, 1000);
        
        self.articleTitleView = [[ArticleTitleView alloc] initWithFrame:HEADER_INIT_FRAME];
        self.articleTitleView.image = image;
        self.articleTitleView.titleText = title;
        self.articleTitleView.authorLabel.text = author;
        [self.articleTitleView formatText];
        
        self.articleTitleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.articleTitleView.backgroundColor = [UIColor redColor];
        self.articleTitleView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.articleTitleView.imageView.clipsToBounds = NO;
        
        UIView *fadeView = [[UIView alloc] initWithFrame:self.articleTitleView.frame];
        fadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        fadeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_backgroundScrollView addSubview:self.articleTitleView];
        // [_backgroundScrollView addSubview:fadeView];
        
        // Take a snapshot of the background scroll view and apply a blur to that image
        // Then add the blurred image on top of the regular image and slowly fade it in scrollViewDidScroll
        UIGraphicsBeginImageContextWithOptions(_backgroundScrollView.bounds.size, _backgroundScrollView.opaque, 0.0);
        [_backgroundScrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _blurImageView = [[UIImageView alloc] initWithFrame:HEADER_INIT_FRAME];
        _blurImageView.image = [img applyBlurWithRadius:12 tintColor:[UIColor colorWithWhite:0.1 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];
        _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _blurImageView.alpha = 0;
        _blurImageView.backgroundColor = [UIColor clearColor];
        [_backgroundScrollView addSubview:_blurImageView];
        
        // Article view
        _articleViewContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backgroundScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - NAVIGATION_BAR_HEIGHT)];
        
        // Read/date label
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEADING_PADDING, LEADING_PADDING, _articleViewContainer.bounds.size.width, 20.0)];
        dateLabel.font = [Resources articleFontSmall];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.text = @"5 min read • March 12, 2015, 6:00 p.m. ET";
        [_articleViewContainer addSubview:dateLabel];
        
        // Article body
        CGFloat padding = LEADING_PADDING - 5.0;
        CGFloat internalPadding = 6.0;
        _articleTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(dateLabel.frame), _articleViewContainer.frame.size.width - 2 * padding, _articleViewContainer.frame.size.height)];
        CGFloat width = _articleTextView.frame.size.width;
        
        NSString *body1 = @"For decades now, Vermont has had a law on the books that banned abortion.\n\nBut nobody thought about it that much: Roe v. Wade, the landmark Supreme Court decision that guarantees a legal right to abortion, has superseded the Vermont law for more than four decades now.\n\nBut about a year and a half ago, Vermont State Senator Tim Ashe started to worry. He was thinking about the composition of the United States Supreme Court — and about how the court would rule on a challenge to abortion rights.\n\n\"We were increasingly sensing that really at any time the Supreme Court could dramatically alter the landscape of Roe,\" he says.\n\nSo Ashe decided to do something about it: in January 2014, he introduced a bill to repeal Vermont's abortion ban. And in March, it passed.\n\nAshe's bill is among the four laws to expand abortion rights that passed in 2014 — more than any year since 1990, the year the pro-choice research firm the Guttmacher Institute started keeping track of them. Legislators also introduced 91 other bills that failed to become law.\n\nFor much of the late 2000s and early 2010s, states passed barely any pro-choice laws. Nearly all abortion legislation focused on restricting access rather than expanding it. That's what makes this new crop of four laws in 2014 so interesting. State legislators have pushed forward on pro–abortion rights legislation because, much like Ashe, they worry about the possibility of the Supreme Court revisiting the issue — and using that as an opportunity to overturn Roe.Pro-choice groups think they also have a chance to capitalize on the many pro-life bills that have passed in the past five years: 231 since 2010, more than in the three decades prior combined.\n\n\"When [voters] see the actual facts of the laws that have been passed, they don’t just disagree with it — they are enraged. Incensed. I’ve never seen anything like it when people learn what’s going on,\" says Tresa Undem, a pollster at PerryUndem, which has done polling for abortion rights groups.";
        NSString *header1 = @"The makeup of the Supreme Court worries some legislators, pushing them to act";
        UIImage *image1 = [UIImage imageNamed:@"steps.jpg"];
        
        NSString *body2 = @"Legislators like Ashe say they've started to focus on expanding abortion access now for one big reason: they worry about the current makeup of the Supreme Court and whether the justices might overturn Roe if they take on another abortion case.\n\nThe court's most recent decision came out against abortion rights. That was Gonzalez v. Carhart, a 2007 case in which the Supreme Court upheld the Partial-Birth Abortion Ban Act, a law Congress passed five year prior that prohibits a type of late-term abortion. The decision worries some court watchers that this particular court could use another abortion case to revisit Roe and its guaranteed access to abortion.\n\nThere could be an opportunity to do that soon: states have passed dozens of abortion restrictions in recent years, many of which could potentially spur a case that makes it up to the Supreme Court.\n\nArizona legislators trying to bring back an old law that banned most abortions after 20 weeks of pregnancy attempted to take their case to the Supreme Court, which declined the appeal in early 2014. (A series of similar 20-week bans have centered on the idea that fetuses can feel pain after that point in a pregnancy.)\n\nThe court has also gotten involved in Texas abortion restrictions without actually hearing any cases and ruling on them. In October 2014, the Supreme Court issued an emergency ruling staying a law that would have shuttered many Texas abortion clinics.\n\nWhile that ruling was a positive one for the pro-choice movement, the justices also didn't vote to block other parts of the Texas law when asked to do so just a year earlier.\n\nSo the current makeup of the Supreme Court suggests to some observers that a case relating to women's reproductive health could swing in either direction. And states are gearing up for that by introducing a staggering number of abortion-related measures.";
        NSString *header2 = @"There was a big jump in the number of provisions that aimed to protect or expand access to abortions";
        
        NSString *body3 = @"In 2014, legislators introduced 95 different provisions, either bills or parts of bills, that aimed to protect or expand abortion access. It's the highest number of such measures since 1990. Of these, four passed.";
        UIImage *image3 = [UIImage imageNamed:@"graph.png"];
        
        NSString *body4 = @"Ashe's Vermont bill repealed the state's pre-Roe abortion ban, and a Utah measure scaled back on mandatory counseling in cases where serious problems have been found in a fetus.\n\nTwo measures passed establishing buffer zones around abortion clinics in Massachusetts and New Hampshire to keep protesters from harassing clinic patients, but those laws were quickly overturned by the Supreme Court's decision in June on McCullen v. Coakley, which ruled that buffer zones were too broad a limit on free speech. Four other states considered buffer zone legislation, but did not move forward on the issue.\n\nOther states have looked for different ways to expand abortion access, like loosening parental consent requirements for minors seeking abortions and eliminating the mandatory counseling some states have for victims of rape and incest who are seeking abortions.\n\nAnd while many of those bills weren't going to go far — they were, after all, being introduced in the same legislatures that passed restrictions — they sent a message, says Elizabeth Nash of the Guttmacher Institute. \"They put folks on notice that not everyone agrees with them,\" she says.";
        NSString *header4 = @"Public interest in abortion issues is slowly increasing";
        UIImage *image4 = [UIImage imageNamed:@"choice.jpg"];
        
        NSString *body5 = @"One reason that abortion legislation might be increasing on both sides of the issue: polls show a growing number of Americans consider it an important issue.\n\nIn the mid- to late 2000s, the number of US adults that said they view abortion as a critical issue in society fell significantly, dropping from 28 percent in 2006 to 15 percent in 2009, according to a poll from Pew. But in the years since, that number has crept slowly upward, reaching 18 percent in 2013.\n\nPro-choice groups also say they're seeing voters be increasingly interested in getting involved in the conversation about reproductive rights.\n\nVoters are getting more engaged, says Boyer, and the NWLC can see this through the reception of several social media campaigns the group ran to rally people to contact their legislators about abortion policy.\n\n\"We have seen social media really reach audiences that have been so far unengaged in these types of issues,\" she says. The activists say they're reaching more millennials but also more health-care providers who are speaking out against legislative interference in the doctor-patient relationship.";
        NSString *header5 = @"Legislators are escalating their efforts, but there are hurdles to doing so";
        
        NSString *body6 = @"Laws to expand abortion access still face hurdles, and 91 of the 95 measures introduced in 2014 ultimately didn't get passed.\n\nAssemblyman Tom Abinanti (D-NY) worked on one of those 91 bills. He introduced legislation in 2014 that aimed to establish a buffer zone to protect women entering abortion clinics from harassment.\n\nBut his law ultimately failed in the assembly, as the debate over a hot-button issue like abortion led to it stalling. \"Somehow this is made out to be an abortion versus anti-abortion issue, but that’s not necessarily the case,\" he says. \"The issue here is access to reproductive health-care services.\"\n\nPro-choice politicians don't always make abortion their top issue, either. In New York, Gov. Andrew Cuomo introduced the Women's Equality Act in early 2013. It would, among other measures, codify Roe v. Wade. But even with the governor's support, the abortion part of that legislation is still sitting in the state Senate — and, Abinanti argues, taking attention away from other pro-choice bills like his.\n\n\"The big battle at the moment is codifying Roe v. Wade, so I'm expecting we're not going to be able to move this [buffer zone bill] until we resolve that issue,\" he says.";
        UIImage *image6 = [UIImage imageNamed:@"share_bottom"];
        
        // Layout article piece by piece
        UITextView *textView1 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(dateLabel.frame) + padding, width, 0.0)];
        textView1.attributedText = [self attributedBodyWithText:body1];
        textView1.scrollEnabled = NO;
        [textView1 sizeToFit];
        [_articleViewContainer addSubview:textView1];
        
        UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView1.frame) + internalPadding, width, 0.0)];
        textView2.attributedText = [self attributedHeaderWithText:header1];
        textView2.scrollEnabled = NO;
        [textView2 sizeToFit];
        [_articleViewContainer addSubview:textView2];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView2.frame) + internalPadding, width, 230.0)];
        imageView1.image = image1;
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        [_articleViewContainer addSubview:imageView1];
        
        UITextView *textView3 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(imageView1.frame) + padding, width, 0.0)];
        textView3.attributedText = [self attributedBodyWithText:body2];
        textView3.scrollEnabled = NO;
        [textView3 sizeToFit];
        [_articleViewContainer addSubview:textView3];
        
        UITextView *textView4 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView3.frame) + internalPadding, width, 0.0)];
        textView4.attributedText = [self attributedHeaderWithText:header2];
        textView4.scrollEnabled = NO;
        [textView4 sizeToFit];
        [_articleViewContainer addSubview:textView4];
        
        UITextView *textView5 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView4.frame) + padding, width, 0.0)];
        textView5.attributedText = [self attributedBodyWithText:body3];
        textView5.scrollEnabled = NO;
        [textView5 sizeToFit];
        [_articleViewContainer addSubview:textView5];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView5.frame) + internalPadding, width, 230.0)];
        imageView2.image = image3;
        imageView2.contentMode = UIViewContentModeScaleAspectFit;
        [_articleViewContainer addSubview:imageView2];
        
        UITextView *textView6 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(imageView2.frame) + padding, width, 0.0)];
        textView6.attributedText = [self attributedBodyWithText:body4];
        textView6.scrollEnabled = NO;
        [textView6 sizeToFit];
        [_articleViewContainer addSubview:textView6];
        
        UITextView *textView7 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView6.frame) + internalPadding, width, 0.0)];
        textView7.attributedText = [self attributedHeaderWithText:header4];
        textView7.scrollEnabled = NO;
        [textView7 sizeToFit];
        [_articleViewContainer addSubview:textView7];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView7.frame), width, 230.0)];
        imageView3.image = image4;
        imageView3.contentMode = UIViewContentModeScaleAspectFit;
        [_articleViewContainer addSubview:imageView3];
        
        UITextView *textView8 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(imageView3.frame) + internalPadding, width, 0.0)];
        textView8.attributedText = [self attributedBodyWithText:body5];
        textView8.scrollEnabled = NO;
        [textView8 sizeToFit];
        [_articleViewContainer addSubview:textView8];
        
        UITextView *textView9 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView8.frame) + internalPadding, width, 0.0)];
        textView9.attributedText = [self attributedHeaderWithText:header5];
        textView9.scrollEnabled = NO;
        [textView9 sizeToFit];
        [_articleViewContainer addSubview:textView9];
        
        UITextView *textView10 = [[UITextView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(textView9.frame) + padding, width, 0.0)];
        textView10.attributedText = [self attributedBodyWithText:body6];
        textView10.scrollEnabled = NO;
        [textView10 sizeToFit];
        [_articleViewContainer addSubview:textView10];
        
        UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(textView10.frame) + padding, [UIScreen mainScreen].bounds.size.width, 487.0)];
        imageView4.image = image6;
        imageView4.contentMode = UIViewContentModeScaleAspectFit;
        [_articleViewContainer addSubview:imageView4];
        
        _articleTextView.font = [Resources articleFont];
        _articleTextView.editable = NO;
        _articleTextView.scrollEnabled = NO;
        
        // NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        // paragraphStyle.lineSpacing = 6.0;
        // paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        // NSAttributedString *string = [[NSAttributedString alloc] initWithString:body1 attributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: [Resources articleFont]}];
        // _articleTextView.attributedText = string;
        // [_articleTextView sizeToFit];
        
        // _articleTextView.textContainer.size = _articleTextView.frame.size;
        // [_articleViewContainer addSubview:_articleTextView];
        
        [_mainScrollView addSubview:_backgroundScrollView];
        [_mainScrollView addSubview:_articleViewContainer];
        
        // Article title label
        UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(60.0, 0.0, 265.0, NAVIGATION_BAR_HEIGHT)];
        mask.backgroundColor = [UIColor clearColor];
        mask.clipsToBounds = YES;
        
        self.articleTitleLabel = [[UILabel alloc] init];
        self.articleTitleLabel.textColor = [UIColor whiteColor];
        self.articleTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.articleTitleLabel.font = [UIFont fontWithName:@"AlrightSans-Bold" size:22.0];
        self.articleTitleLabel.text = self.articleTitleView.titleText;
        self.articleTitleLabel.frame = CGRectMake(0.0, NAVIGATION_BAR_HEIGHT, 265.0, 30.0); // y -> 14.0
        self.articleTitleLabel.alpha = 0.0;
        [mask addSubview:self.articleTitleLabel];
        [self.view addSubview:mask];
        
        // Share button on top of everything else
        self.shareButton = [[ShareButton alloc] init];
        self.shareButton.delegate = self;
        self.shareButton.alpha = 0.0;
        [self.view addSubview:self.shareButton];
        
        self.overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.overlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        self.overlay.alpha = 0.0;
        [self.view addSubview:self.overlay];
    }
    return self;
}

- (NSAttributedString *)attributedBodyWithText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: [Resources articleFont]}];
    return string;
}

- (NSAttributedString *)attributedHeaderWithText:(NSString *)text {
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AlrightSans-Bold" size:20.0]}];
    return string;
}

- (instancetype)init {
    return [self initWithTitle:@"Title" author:@"By Author" image:[UIImage new]];
}

#pragma mark - Constraints

// Currently not in use
- (void)updateConstraints {
    [super updateViewConstraints];
    if (!self.didSetupConstraints) {
        [self.shareButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-LEADING_PADDING];
        [self.shareButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-LEADING_PADDING];
        
        self.didSetupConstraints = YES;
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    CGFloat delta = 0.0;
    CGRect rect = HEADER_INIT_FRAME;

    // Zoom cover image and quickly fade out its subviews
    if (scrollView.contentOffset.y < 0.0) {
        delta = fabs(MIN(0.0f, _mainScrollView.contentOffset.y));
        _backgroundScrollView.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0, CGRectGetMinY(rect) - delta, CGRectGetWidth(rect) + delta, CGRectGetHeight(rect) + delta);
        self.articleTitleView.titleAlpha = MIN(1.0, 1.0 - delta * kTextFadeOutFactor);
        self.articleTitleView.authorLabel.alpha = MIN(1.0, 1.0 - delta * kTextFadeOutFactor);
    } else {
        delta = _mainScrollView.contentOffset.y;
        self.articleTitleView.titleAlpha = 1.0;
        self.articleTitleView.authorLabel.alpha = 1.0;
        
        CGFloat blur = MIN(1 , delta * kBlurFadeInFactor);
        _blurImageView.alpha = blur;
        [self.navigationBar setGradientOpacity:1-blur];
        
        CGFloat backgroundScrollViewLimit = _backgroundScrollView.frame.size.height - NAVIGATION_BAR_HEIGHT;
        
        // Check whether or not the user has scrolled passed the limit where we want to stick the header, if they have then we move the frame with the scroll view to give it a sticky look
        if (delta > backgroundScrollViewLimit) {
            _backgroundScrollView.frame = (CGRect) {.origin = {0, delta - _backgroundScrollView.frame.size.height + NAVIGATION_BAR_HEIGHT}, .size = {self.view.frame.size.width, IMAGE_HEIGHT}};
            _articleViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(_backgroundScrollView.frame) + CGRectGetHeight(_backgroundScrollView.frame)}, .size = _articleViewContainer.frame.size };
            _articleViewContainer.contentOffset = CGPointMake(0, delta - backgroundScrollViewLimit);
            CGFloat contentOffsetY = -backgroundScrollViewLimit * kBackgroundParallexFactor;
            [_backgroundScrollView setContentOffset:(CGPoint){0,contentOffsetY} animated:NO];
            
            // Add article title to header
            CGFloat y = NAVIGATION_BAR_HEIGHT - (delta - backgroundScrollViewLimit);
            if (y < 14.0) y = 14.0;
            CGRect frame = self.articleTitleLabel.frame;
            frame.origin.y = y;
            self.articleTitleLabel.frame = frame;
            
            CGFloat alpha = (delta - backgroundScrollViewLimit) / 100.0;
            self.articleTitleLabel.alpha = alpha;
            self.shareButton.alpha = alpha;
            
            if (delta - backgroundScrollViewLimit > 5120) {
                self.shareButton.alpha = (5220 - (delta - backgroundScrollViewLimit)) / 100.0;
            }
        } else {
            self.articleTitleLabel.alpha = 0.0;
            self.shareButton.alpha = 0.0;
            
            _backgroundScrollView.frame = rect;
            _articleViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(rect) + CGRectGetHeight(rect)}, .size = _articleViewContainer.frame.size };
            [_articleViewContainer setContentOffset:(CGPoint){0,0} animated:NO];
            [_backgroundScrollView setContentOffset:CGPointMake(0, -delta * kBackgroundParallexFactor)animated:NO];
        }
    }
}

#pragma mark - Navigation bar

- (void)setNavigationBar:(TransparentNavigationBarView *)navigationBar {
    _navigationBar = navigationBar;
    
    [self.navigationBar leftButtonPressed:^{
        [self dismiss];
    } right:^{
        NSLog(@"bookmark pressed");
    }];
}

#pragma mark - ShareButton delegate

- (void)presentShareOverlay {
    [self.view bringSubviewToFront:self.shareButton];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.overlay.alpha = 1.0;
        self.navigationBar.alpha = 0.2;
    }];
}

- (void)dismissShareOverlay {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.overlay.alpha = 0.0;
        self.navigationBar.alpha = 1.0;
    }];
}

#pragma mark - Dismiss self

- (void)dismiss {

    // Scroll to top if necessary
    [UIView animateWithDuration:TRANSITION_SPEED animations:^{
        [_mainScrollView scrollRectToVisible:CGRectZero animated:NO];
    }];
    
    if (self.delegate) [self.delegate dismissArticle];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), _articleViewContainer.bounds.size.height + CGRectGetHeight(_backgroundScrollView.frame) + 5715);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
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
