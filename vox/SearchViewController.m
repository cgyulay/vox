//
//  SearchViewController.m
//  vox
//
//  Created by Colton Gyulay on 3/12/15.
//  Copyright (c) 2015 Colton Gyulay. All rights reserved.
//

#import "SearchViewController.h"
#import "UIButton+Extensions.h"

@interface SearchViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *searchField;
@property (strong, nonatomic) NSMutableArray *results;

@end

@implementation SearchViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *searchImage = [UIImage imageNamed:@"icon-search"];
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:searchImage];
        searchImageView.frame = CGRectMake(LEADING_PADDING, LEADING_PADDING + 2.0, searchImage.size.width, searchImage.size.height);
        
        UIImage *xImage = [UIImage imageNamed:@"icon-x"];
        UIButton *xButton = [UIButton new];
        [xButton setImage:xImage forState:UIControlStateNormal];
        xButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - LEADING_PADDING - searchImage.size.width, LEADING_PADDING, searchImage.size.width, searchImage.size.height);
        [xButton addTarget:self action:@selector(xPressed) forControlEvents:UIControlEventTouchUpInside];
        xButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10.0, -10.0, -10.0, -10.0);
        
        self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + LEADING_PADDING, LEADING_PADDING + 2.0, 200.0, 17.0)];
        [[UITextField appearance] setTintColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        self.searchField.textColor = [UIColor whiteColor];
        self.searchField.font = [Resources searchFont];
        self.searchField.delegate = self;
        [self.searchField becomeFirstResponder];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * LEADING_PADDING;
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(LEADING_PADDING, CGRectGetMaxY(self.searchField.frame) + 15.0, width, 1.0)];
        separator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        
        self.results = [NSMutableArray new];
        NSArray *titles = [NSArray arrayWithObjects:@"The US and China just reached a major climate deal on cutting emissions", @"How America and China broke the global climate trap", @"China has 8 cities with bigger bike share systems than all of America", nil];
        NSArray *subtitles = [NSArray arrayWithObjects:@"By Brad Plumer on November 11, 2014, 11:12 p.m. ET", @"By Zak Beauchamp on November 12, 2014, 4:10 p.m. ET", @"By Joseph Stromberg on August 26, 2014, 1:10 p.m. ET", nil];
        
        CGFloat y = CGRectGetMaxY(separator.frame);
        for (int i = 0; i < titles.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, y, width, 100.0)];
            
            NSString *title = [titles objectAtIndex:i];
            NSString *subtitle = [subtitles objectAtIndex:i];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, width, 30.0)];
            titleLabel.numberOfLines = 0;
            titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont fontWithName:@"AlrightSans-Bold" size:18.0];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 6.0;
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:title attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            titleLabel.attributedText = string;
            [titleLabel sizeToFit];
            
            UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(titleLabel.frame) + 4.0, width, 20.0)];
            subtitleLabel.textColor = [UIColor whiteColor];
            subtitleLabel.font = [UIFont fontWithName:@"AlrightSans-RegularItalic" size:12.0];
            subtitleLabel.text = subtitle;
            
            if (i < 2) {
                UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0.0, view.frame.size.height - 1.0, width, 1.0)];
                sep.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
                [view addSubview:sep];
            }
            
            y += view.frame.size.height;
            
            [view addSubview:titleLabel];
            [view addSubview:subtitleLabel];
            
            view.alpha = 0.0;
            [self.view addSubview:view];
            [self.results addObject:view];
        }
        
        [self.view addSubview:searchImageView];
        [self.view addSubview:xButton];
        [self.view addSubview:self.searchField];
        [self.view addSubview:separator];
    }
    return self;
}

- (void)displayView:(UIView *)view {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        CGRect frame = view.frame;
        frame.origin.x = LEADING_PADDING;
        view.frame = frame;
        
        view.alpha = 1.0;
    }];
}

- (void)showResults {
    for (int i = 0; i < self.results.count; i++) {
        UIView *view = [self.results objectAtIndex:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self displayView:view];
        });
    }
}

#pragma mark - UITextField delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"n"]) {
        [self showResults];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)xPressed {
    [self.searchField resignFirstResponder];
    
    double delayInSeconds = 0.3;
    dispatch_time_t goTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(goTime, dispatch_get_main_queue(), ^(void){
        [self.delegate dismissSearch];
    });
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
